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
// Description: Simple I2C Controller for configuration of camera.
//  At the moment, it is only capable of I2C writes
//========================================================================

module i2c_ctrl (
   input  logic        clk,
   input  logic        strobe_400kHz,
   input  logic        areset_n,

   input  logic        enable,
   input  logic [6:0]  slave_address,
   input  logic [15:0] register_address,
   input  logic [7:0]  data_in,
   output logic        register_done,
        
   input  logic        scl_do,
   output logic        scl_di,

   input  logic        sda_do,
   output logic        sda_di
);

   typedef enum logic [3:0] {
      IDLE               = 4'd0,
      START              = 4'd1,
      WRITE_SLAVE_ADDR   = 4'd2,
      CHECK_ACK          = 4'd3,
      WRITE_REG_ADDR_MSB = 4'd4,
      WRITE_REG_ADDR     = 4'd5,
      WRITE_REG_DATA     = 4'd6,
      STOP               = 4'd7,
      RESTART            = 4'd8
   } state_t;
   
   state_t state;
   state_t post_state;
   
   logic [1:0] process_cnt;
   logic [7:0] slave_address_plus_rw;
   logic [3:0] bit_cnt, bit_cnt_dec;
   logic       post_serial_data;
   logic       acknowledge_bit;
   
   assign bit_cnt_dec = 4'(bit_cnt - 4'd1);
   

   always_ff @(negedge areset_n or posedge clk) begin
      if (areset_n == 1'b0) begin
         register_done         <= 1'b0;
         state                 <= IDLE;
         post_state            <= IDLE;
         process_cnt           <= '0;
         slave_address_plus_rw <= '0;
         bit_cnt               <= '0;
         post_serial_data      <= 1'b0;
         acknowledge_bit       <= 1'b0;
         scl_di                <= 1'b1;
         sda_di                <= 1'b1;
      end 
      else begin
`ifndef ICARUS
         unique case (state)
`else
         case (state)
`endif
         //----------------------
            IDLE: begin
               process_cnt           <= '0;
               bit_cnt               <= '0;
               acknowledge_bit       <= 1'b0;
               slave_address_plus_rw <= {slave_address, 1'b0};
               scl_di                <= 1'b1;
               sda_di                <= 1'b1;

               if (enable == 1'b1) begin
                  register_done   <= 1'b0;
                  state           <= START;
                  post_state      <= WRITE_SLAVE_ADDR;
               end
            end

         //----------------------
            START: if (strobe_400kHz == 1'b1) begin
               unique case (process_cnt)
                  2'd0: begin
                     process_cnt <= 2'd1;
                  end
                  2'd1: begin
                     sda_di      <= 1'b0;
                     process_cnt <= 2'd2;
                  end
                  2'd2: begin
                     bit_cnt     <= 4'd8;
                     process_cnt <= 2'd3;
                  end
                  2'd3: begin
                     scl_di      <= 1'b0;
                     process_cnt <= 2'd0;
                     state       <= post_state;
                     sda_di      <= slave_address_plus_rw[3'd7];
                  end
               endcase
            end

         //----------------------
            WRITE_SLAVE_ADDR: if (strobe_400kHz == 1'b1) begin
               unique case (process_cnt)
                  2'd0: begin
                     scl_di      <= 1'b1;
                     process_cnt <= 2'd1;
                  end
                  2'd1: begin
                     //check for clock stretching
                     if (scl_do == 1'b1) begin
                        process_cnt <= 2'd2;
                     end
                  end
                  2'd2: begin
                     scl_di      <= 1'b0;
                     bit_cnt     <= bit_cnt_dec;
                     process_cnt <= 2'd3;
                  end
                  2'd3: begin
                     process_cnt <= 2'd0;
  
                     if (bit_cnt == 4'd0) begin
                        post_serial_data <= register_address[4'd15];
                                                
                        state      <= CHECK_ACK;
                        post_state <= WRITE_REG_ADDR_MSB;
                        bit_cnt    <= 4'd8;
                     end
                     else begin
                        sda_di   <= slave_address_plus_rw[bit_cnt_dec[2:0]];
                     end
                  end
               endcase
            end

         //----------------------
            CHECK_ACK: if (strobe_400kHz == 1'b1) begin
               unique case (process_cnt)
                  2'd0: begin
                     scl_di      <= 1'b1;
                     process_cnt <= 2'd1;
                  end
                  2'd1: begin
                     //check for clock stretching
                     if (scl_do == 1'b1) begin
                        process_cnt <= 2'd2;
                     end
                  end
                  2'd2: begin
                     scl_di <= 1'b0;

                     if (sda_do == 1'b0) begin
                        acknowledge_bit <= 1'b1;
                     end
                     process_cnt <= 2'd3;
                  end
                  2'd3: begin
                     if (acknowledge_bit == 1'b1) begin
                        acknowledge_bit <= 1'b0;
                        sda_di          <= post_serial_data;
                        state           <= post_state;
                     end
                     else begin
                        state    <= RESTART;
                     end
                     process_cnt <= 2'd0;
                  end
               endcase
            end

         //----------------------
            WRITE_REG_ADDR_MSB: if (strobe_400kHz == 1'b1) begin
               unique case (process_cnt)
                  2'd0: begin
                     scl_di      <= 1'b1;
                     process_cnt <= 2'd1;
                  end
                  2'd1: begin
                     //check for clock stretching
                     if (scl_do == 1'b1) begin
                        process_cnt <= 2'd2;
                     end
                  end
                  2'd2: begin
                     scl_di      <= 1'b0;
                     bit_cnt     <= bit_cnt_dec;
                     process_cnt <= 2'd3;
                  end
                  2'd3: begin
                     if (bit_cnt == 4'd0) begin
                        post_serial_data <= register_address[4'd7];
                        //sda_di       <= 1'b0; //redundant, not needed
                        state        <= CHECK_ACK;
                        post_state   <= WRITE_REG_ADDR;
                        bit_cnt      <= 4'd8;
                     end
                     else begin
                        sda_di <= register_address[bit_cnt + 4'd7];
                     end
                     process_cnt <= 2'd0;
                  end
               endcase
            end

         //----------------------
            WRITE_REG_ADDR: if (strobe_400kHz == 1'b1) begin
               unique case (process_cnt)
                  2'd0: begin
                     scl_di      <= 1'b1;
                     process_cnt <= 2'd1;
                  end
                  2'd1: begin
                     //check for clock stretching
                     if (scl_do == 1'b1) begin
                        process_cnt <= 2'd2;
                     end
                  end
                  2'd2: begin
                     scl_di      <= 1'b0;
                     bit_cnt     <= bit_cnt_dec;
                     process_cnt <= 2'd3;
                  end
                  2'd3: begin
                     if (bit_cnt == 4'd0) begin
                        post_serial_data <= data_in[3'd7];
                        post_state       <= WRITE_REG_DATA;
                        state   <= CHECK_ACK;
                        bit_cnt <= 4'd8;
                     end
                     else begin
                        sda_di <= register_address[bit_cnt_dec];
                     end
                     process_cnt <= 2'd0;
                  end
               endcase
            end

         //----------------------
            WRITE_REG_DATA: if (strobe_400kHz == 1'b1) begin
               unique case (process_cnt)
                  2'd0: begin
                     scl_di      <= 1'b1;
                     process_cnt <= 2'd1;
                  end
                  2'd1: begin
                     //check for clock stretching
                     if (scl_do == 1'b1) begin
                        process_cnt <= 2'd2;
                     end
                  end
                  2'd2: begin
                     scl_di      <= 1'b0;
                     bit_cnt     <= bit_cnt_dec;
                     process_cnt <= 2'd3;
                  end
                  2'd3: begin
                     if (bit_cnt == 4'd0) begin
                        post_serial_data <= 1'b0;
                        state            <= CHECK_ACK;
                        post_state       <= STOP;
                        bit_cnt          <= 4'd8;
                        //register_done    <= 1'b1;
                     end
                     else begin
                        sda_di <= data_in[bit_cnt_dec[2:0]];
                     end
                     process_cnt <= 2'd0;
                  end
               endcase
            end
 
         //----------------------
            STOP: if (strobe_400kHz == 1'b1) begin
               unique case (process_cnt)
                  2'd0: begin
                     scl_di      <= 1'b1;
                     process_cnt <= 2'd1;
                  end
                  2'd1: begin
                     //check for clock stretching
                     if (scl_do == 1'b1) begin
                        process_cnt <= 2'd2;
                     end
                  end
                  2'd2: begin
                     sda_di        <= 1'b1;
                     process_cnt   <= 2'd3;
                     register_done <= 1'b1;
                  end
                  2'd3: begin
                     state <= IDLE;
                  end
               endcase
            end

         //----------------------
            RESTART: if (strobe_400kHz == 1'b1) begin
               unique case (process_cnt)
                  2'd0: begin
                     scl_di      <= 1'b1;
                     process_cnt <= 2'd1;
                  end
                  2'd1: begin
                     //check for clock stretching
                     if (scl_do == 1'b1) begin
                        process_cnt <= 2'd2;
                     end
                  end
                  2'd2: begin
                     sda_di      <= 1'b1;
                     process_cnt <= 2'd3;
                  end
                  2'd3: begin
                     state <= IDLE;
                  end
               endcase
            end // case: RESTART
         endcase // unique case (state)
         
      end // else: !if(reset == 1'b1)
   end // always_ff @ (posedge reset or posedge clk)
   
endmodule: i2c_ctrl

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/10 Isam Vrce: Initial creation
*/
