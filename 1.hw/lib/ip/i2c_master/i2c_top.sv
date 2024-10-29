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
// Description: Top-level for I2C Master. It:
//   - implements state machine for sending data to I2C Controller
//   - instantiates the I2C Controller itself
//   - for most part operates in sync with external 400kHz strobe
//========================================================================

import top_pkg::*;
module i2c_top #(
   parameter I2C_SLAVE_ADDR = 7'd26
)(

 //clocks and resets
   input  logic  clk,
   input  logic  strobe_400kHz, // 400kHz strobe synchrnous to 'clk'
   input  logic  areset_n,      // active-0 asynchronous reset

 //I/O pads
   inout  wire   i2c_scl,
   inout  wire   i2c_sda,

 //Misc/Debug
   output bus8_t debug_pins
);

   parameter NUM_REGISTERS = 56;

//--------------------------------
// I2C Master
//--------------------------------
   logic        i2c_enable;

   logic [15:0] i2c_reg_addr;
   logic [5:0]  i2c_reg_cnt;
   logic        i2c_reg_done;

   logic [31:0] i2c_data_init[NUM_REGISTERS];
   logic [7:0]  i2c_data_in;

   logic        i2c_scl_do;
   logic        i2c_scl_di;
   logic        i2c_scl_oe;

   logic        i2c_sda_do; 
   logic        i2c_sda_di;
   logic        i2c_sda_oe;
   
   logic [7:0]  i2c_pause;

   i2c_ctrl u_ctrl (
      .clk              (clk),            //i 
      .strobe_400kHz    (strobe_400kHz),  //i 
      .areset_n         (areset_n),       //i 

      .enable           (i2c_enable),     //i 
      .slave_address    (I2C_SLAVE_ADDR), //i[6:0] 
      .register_address (i2c_reg_addr),   //i[15:0] 
      .data_in          (i2c_data_in),    //i[7:0] 
      .register_done    (i2c_reg_done),   //o 

      .scl_oe           (i2c_scl_oe),     //o
      .scl_di           (i2c_scl_di),     //i
      
      .sda_oe           (i2c_sda_oe),     //o
      .sda_di           (i2c_sda_di),     //i
      .pause_duration   (i2c_pause)       //i[7:0]
   );


`ifndef SIM_ONLY
   initial $readmemh("i2c_init.mem", i2c_data_init);

`else
   string i2c_init_mem_file;

   initial begin
      if ($value$plusargs("i2c_init_mem_file=%s", i2c_init_mem_file)) begin
         $readmemh(i2c_init_mem_file, i2c_data_init);
      end
      else begin
         $readmemh("../../../1.hw/lib/ip/i2c_master/i2c_init.mem", i2c_data_init);
      end
   end
`endif

   assign i2c_enable   = (i2c_reg_cnt < NUM_REGISTERS);
   assign i2c_reg_addr = i2c_data_init[i2c_reg_cnt][31:16];
   assign i2c_data_in  = i2c_data_init[i2c_reg_cnt][15:8];
   assign i2c_pause    = i2c_data_init[i2c_reg_cnt][7:0];

   always_ff @(negedge areset_n or posedge clk) begin
      if (areset_n == 1'b0) begin
         i2c_reg_cnt    <= '0;
      end 
      else if ({strobe_400kHz, i2c_enable} == 2'b11) begin
         if (i2c_reg_done == 1'd1) begin
            if (i2c_reg_cnt < NUM_REGISTERS) begin
               i2c_reg_cnt <= 6'(i2c_reg_cnt + 6'd1);
            end
         end
      end 
   end

   IOBUF #(
      .DRIVE        (12), 
      .IBUF_LOW_PWR ("TRUE"), // Low Power:"TRUE", High Performance:"FALSE"
      .IOSTANDARD   ("DEFAULT"),
      .SLEW         ("SLOW") 
   ) 
   u_i2c_iobuf[1:0] (
      .IO ({ i2c_sda,     i2c_scl    }), //io pad
      .O  ({ i2c_sda_di,  i2c_scl_di }), //o
      .I  ({ 1'b0,        1'b0       }), //i
      .T  ({ ~i2c_sda_oe, ~i2c_scl_oe })  //i: 3-state enable: 1=input, 0=output
   );

   assign debug_pins = {
      i2c_sda_di, 
      i2c_scl_di, 
      i2c_sda_oe, 
      i2c_scl_oe, 
      i2c_enable, 
      areset_n,
      i2c_reg_done,
      strobe_400kHz
   };
   
endmodule: i2c_top

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/30 Isam Vrce: Initial creation
 2024/6/6  Armin Zunic: More improvements
*/
