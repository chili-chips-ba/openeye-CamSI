//======================================================================== 
// openCologne * NLnet-sponsored open-source design ware for GateMate
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
// Description: <your text goes here>
//========================================================================

// <modify as needed>

module top 
   import top_pkg::*;
(
   input logic   areset,   // external active-1 asynchronous reset
   input logic   clk_ext,  // external 100MHz clock source

  //I2C_Master to Camera
   inout  wire   i2c_sda,
   inout  wire   i2c_scl,
   
  //MIPI DPHY from/to Camera
   input  diff_t      cam_dphy_clk,
   input  lane_diff_t cam_dphy_dat
);

//--------------------------------
// Clock and reset gen
//--------------------------------
   logic reset, i2c_reset;
   logic clk_100, clk_200, clk_1hz, strobe_400kHz;

   clkrst_gen u_clkrst_gen (
      .reset_ext     (areset),        //i
      .clk_ext       (clk_ext),       //i
                                       
      .clk_100       (clk_100),       //o: 100MHz 
      .clk_200       (clk_200),       //o: 200MHz 
      .clk_1hz       (clk_1hz),       //o: 1Hz
      .strobe_400kHz (strobe_400kHz), //o: pulse1 at 400kHz

      .reset         (reset),         //o
      .cam_en        (cam_en),        //o
      .i2c_reset     (i2c_reset)      //o
   );

//--------------------------------
// I2C Master
//--------------------------------
   i2c_top u_i2c  (
     //clocks and resets
      .clk           (clk_100),       //i
      .strobe_400kHz (strobe_400kHz), //i
      .reset         (i2c_reset),     //i

     //I2C_Master to Camera
      .i2c_scl       (i2c_scl),       //io 
      .i2c_sda       (i2c_sda)        //io 
   );

endmodule: top

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/5/10 <your-name>: Initial creation
*/
