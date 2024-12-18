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
//--------------------------------------------------------------------------
// Description: Simulation testbench for FPGA. It provides models of 
//              external resources, as connected on the actual board
//==========================================================================

`timescale 1ps/1ps

module tb #(
   parameter int RUN_SIM_US = 15_000
)();

   import top_pkg::*;
  
//--------------------------------------------------------------
// Generate clock and run sim for the specified amount of time
   localparam  HALF_PERIOD_PS = 5_000; // 50MHz
   logic       clk_100;
   logic       reset;

   initial begin
      reset    = 1'b1;
      clk_100  = 1'b0;
      
      fork 
         forever begin: clock_gen
            #(HALF_PERIOD_PS * 1ps) clk_100 = ~clk_100;
         end

         begin: run_sim
            #(RUN_SIM_US * 1us);
            $finish(2);
         end
      join
   end

//--------------------------------------------------------------
   lane_diff_t cam_dphy_dat;

   top dut (
      .areset        (reset),        //i     
      .clk_ext       (clk_100),      //i 

     //I2C_Master to Camera
      .i2c_sda       (),             //io 
      .i2c_scl       (),             //io 
   
     //MIPI DPHY from/to Camera
      .cam_dphy_clk  (),             //i'diff_t 
      .cam_dphy_dat  (cam_dphy_dat), //i'lane_diff_t

      .cam_en        (),             //o
      
     //HDMI output, goes directly to connector
      .hdmi_clk_p    (),             //o 
      .hdmi_clk_n    (),             //o 
      .hdmi_dat_p    (),             //o'bus3_t
      .hdmi_dat_n    (),             //o'bus3_t 
   
     //Misc/Debug
      .led           (),             //o'bus3_t
      .debug_pins    ()              //o'bus8_t
   );

//--------------------------------------------------------------
// FIXME: models of external components
//--------------------------------------------------------------


//--------------------------------------------------------------
/* Assertions have to be done like this

    always_ff @(posedge clk) begin

       $display("a = %b, b = %b, c = %b, y = %b",a,b,c,y);

       if ($past(b) > 2'b0) begin
          if (y !== 1'b1) $fatal("Assertion failed for Test Case: b > 2'b0");
       end 
       else begin
          if (y !== 1'b0) $fatal("Assertion failed for Test Case: b <= 2'b0");
       end
    end
*/

endmodule: tb

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/05/02 AnelH: initial creation    
*/
