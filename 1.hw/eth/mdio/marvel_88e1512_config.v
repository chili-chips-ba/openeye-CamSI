// SPDX-FileCopyrightText: 2024 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//======================================================================== 
// openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
//------------------------------------------------------------------------
//                   Copyright (C) 2024 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//------------------------------------------------------------------------
// Description: MDIO initializtion for Marvel 1GE PHY
//========================================================================

module marvel_88e1512_config #(
   parameter REF_CLK = 100,        // reference clock frequency(MHz)
   parameter MDC_CLK = 500         // mdc clock(KHz)
)
(
   input                 clk,
   input                 rst_n,

   output                mdc,      //mdc interface
   inout                 mdio,     //mdio interface
   output [7:0]          debug
);

   reg  [4:0]         phy_addr      ;   //phy address 5'b0001
   reg  [4:0]         reg_addr      ;   //phy register address
   reg                write_req     ;   //write smi request
   reg  [15:0]        write_data    ;   //write smi data
   reg                read_req      ;   //read smi request
   wire [15:0]        read_data     ;   //read smi data
   wire               data_valid    ;   //read smi data valid
   wire               done          ;   //write or read finished
   reg  [15:0]        read_data_buf ;   //read register data latch
   reg  [31:0]        timer         ;   //wait counter 
   
   parameter P_WAIT           = 32'd1500; // P_WAIT * 10ns
   
   localparam IDLE            = 4'd0 ;
   localparam PREABMLE        = 4'd1 ;
   localparam R_GEN_REQ       = 4'd2 ;
   localparam R_REG           = 4'd3 ;
   localparam R_WAIT          = 4'd4 ;
   localparam ADDR_INC        = 4'd5 ;        
   localparam W_GEN_REQ       = 4'd6 ;
   localparam W_REG           = 4'd7 ;
   localparam W_WAIT          = 4'd8 ;
   localparam DONE            = 4'd9 ;

   reg [39:0] init_data[31:0];
   reg [4:0] init_cnt;
   reg [4:0] init_end = 5'd3;
   
   initial begin
      init_cnt = 5'd0;
      init_data[0]= 40'h1600FF0012; // Set page(18) 0x12,     mask 0x00FF, data 0x0012
      init_data[1]= 40'h1400070000; // Set register(20) 0x14, mask 0x0007, data 0x0000
      init_data[2]= 40'h1480008000; // Set register(20) 0x14, mask 0x8000, data 0x8000
      init_data[3]= 40'h1600FF0000; // Set page(00) 0x00,     mask 0x00FF, data 0x0002   
         
//      init_data[0] = 40'h1600FF00FF; // Set page FF
//      init_data[1] = 40'h11FFFF214B; // Set register(17) 0x11, mask: 0xFFFF, data: 0x214B
//      init_data[2] = 40'h10FFFF2144; // Set register(16) 0x10, mask: 0xFFFF, data: 0x2144
//      init_data[3] = 40'h11FFFF0C28; // Set register(17) 0x11, mask: 0xFFFF, data: 0x0C28
//      init_data[4] = 40'h10FFFF2146; // Set register(16) 0x10, mask: 0xFFFF, data: 0x2146
//      init_data[5] = 40'h11FFFFB233; // Set register(17) 0x11, mask: 0xFFFF, data: 0xB233
//      init_data[6] = 40'h10FFFF214D; // Set register(16) 0x10, mask: 0xFFFF, data: 0x214D
//      init_data[7] = 40'h11FFFFCC0C; // Set register(17) 0x11, mask: 0xFFFF, data: 0xCC0C
//      init_data[8] = 40'h10FFFF2159; // Set register(16) 0x10, mask: 0xFFFF, data: 0x2159
//      init_data[9] = 40'h1600FF00FB; // Set page FB      0x12, mask: 0x00FF, data: 0x00FB 
//      init_data[10]= 40'h07FFFFC00D; // Set register(07) 0x07, mask: 0xFFFF, data: 0xC00D        
//      init_data[11]= 40'h1600FF0012; // Set page(18)     0x12, mask: 0x00FF, data: 0x0012 
//      init_data[12]= 40'h1400070000; // Set register(20) 0x14, mask: 0x0007, data: 0x0000
//      init_data[13]= 40'h1480008000; // Set register(20) 0x14, mask: 0x8000, data: 0x8000
//      init_data[14]= 40'h1600FF0000; // Set page(00) 0x00,     mask 0x00FF, data 0x0000  
   end         
   reg [3:0]    state;
   reg [3:0]    next_state ;
   reg          next_reg ;
   
   always @(posedge clk or negedge rst_n)
   begin
      if (~rst_n)
         state  <=  IDLE;
      else
         state  <= next_state;  
   end

   always @(*)
   begin
      case(state)
         IDLE:            
            next_state <= PREABMLE ;            
         PREABMLE:
            begin
               if (timer == P_WAIT)
                  next_state <= R_GEN_REQ ;
               else
                  next_state <= PREABMLE ;
            end            
         W_GEN_REQ:
            next_state <= W_REG ;
         W_REG:
            begin
               if (done)
                  next_state <= W_WAIT ;
               else
                  next_state <= W_REG ;
            end
         W_WAIT:
            begin
               if (timer == P_WAIT)
                  next_state <= R_GEN_REQ ;                  
//                  if(init_cnt >= init_end)
//                     next_state <= DONE ;
//                  else 
//                     next_state <= ADDR_INC ;
               else
                  next_state <= W_WAIT ;
            end             
         ADDR_INC: 
            begin            
               if(init_cnt >= init_end)
                  next_state <= DONE ;
               else  
                  next_state <= R_GEN_REQ ;           
            end   
         R_GEN_REQ: 
            next_state <= R_REG ;                           
         R_REG:
            begin
               if (done)
                  next_state <= R_WAIT ;
               else
                  next_state <= R_REG ;
            end            
         R_WAIT:
            begin
               if (timer == P_WAIT)
//                  next_state <= W_GEN_REQ;
                  if(next_reg) 
                     next_state <= ADDR_INC ;
                  else 
                     next_state <= W_GEN_REQ ;
               else
                  next_state <= R_WAIT ;
            end 
         DONE:    
            next_state <= DONE;
         default:
            next_state <= IDLE ;
      endcase
   end

   always @(posedge clk or negedge rst_n)
   begin
      if (~rst_n)
         write_req <= 1'b0 ;
      else if (state == W_GEN_REQ)
         write_req <= 1'b1 ;         
      else
         write_req <= 1'b0 ;
   end
  
   //wait counter  
   always @(posedge clk or negedge rst_n)
   begin
      if (~rst_n)
         timer <= 32'd0 ;
      else if (state == PREABMLE | state == R_WAIT | state == W_WAIT)
         timer <= timer + 1'b1 ;
      else
         timer <= 32'd0 ;
   end

   //wait counter  
   always @(posedge clk or negedge rst_n)
   begin
      if (~rst_n)
         init_cnt = 5'd0;
      else if (state == IDLE) begin
         init_cnt = 5'd0; 
      end else if (state == ADDR_INC) begin
         if(init_cnt < init_end) begin
            init_cnt <= init_cnt + 1'd1 ;
         end                  
      end
  end
  
   //read smi request  
   always @(posedge clk or negedge rst_n)
   begin
      if (~rst_n) begin
         read_req <= 1'b0 ;
         next_reg <= 1'b1;
      end else if (state == R_GEN_REQ) begin
         read_req <= 1'b1 ;
         next_reg <= ~next_reg;
      end else
         read_req <= 1'b0 ;
   end

   //read data latch
   always @(posedge clk or negedge rst_n)
   begin
      if (~rst_n)
         read_data_buf <= 16'd0 ;
      else if (data_valid)
         read_data_buf <= read_data ;
   end

   //phy address
   always @(posedge clk or negedge rst_n)
   begin
      if (~rst_n)
         phy_addr <= 5'd0 ;
      else 
         phy_addr <= 5'b00001 ;
   end

   //phy register address
   always @(posedge clk or negedge rst_n)
   begin
      if (~rst_n) begin
         reg_addr <= 5'd0 ;
      end else if (state == R_REG) begin
         reg_addr <= init_data[init_cnt][36:32];
         write_data <= 16'hFFFF;
      end else if (state == W_REG) begin
         reg_addr <= init_data[init_cnt][36:32];
         write_data <= (read_data_buf & ~init_data[init_cnt][31:16]) | (init_data[init_cnt][31:16] & init_data[init_cnt][15:0]);
      end
   end

   wire [7:0] debug_mdio;
   
   mdio_read_write #(
      .REF_CLK          (REF_CLK),
      .MDC_CLK          (MDC_CLK)
   ) mdio_rw_inst (
      .clk              (clk        ),
      .rst_n            (rst_n      ),
      .mdc              (mdc        ),
      .mdio             (mdio       ),
      .phy_addr         (phy_addr   ),
      .reg_addr         (reg_addr   ),
      .write_req        (write_req  ),
      .write_data       (write_data ),
      .read_req         (read_req   ),
      .read_data        (read_data  ),
      .data_valid       (data_valid ),
      .done             (done       ),
      .debug            (debug_mdio )
   );
   
   assign debug = { data_valid, (state == ADDR_INC), (state == W_REG), (state == R_REG), ((state == DONE) || (state == IDLE)), debug_mdio[2:0]};

endmodule: marvel_88e1512_config

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/11/10 Anel H: Initial creation 
*/

