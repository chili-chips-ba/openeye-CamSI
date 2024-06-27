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
// Description: Top-level interconnect for all ISP functions
//========================================================================

module isp_top
  import top_pkg::*;
#(
   parameter LINE_LENGTH = 640, // number of data entries per line
   parameter RGB_WIDTH   = 24   // width of RGB data (24-bit)
)(
   input  logic        clk,     // byte_clock      
   input  logic        rst,
                        
   input  lane_data_t  data_in,
   input  logic        data_valid,    
   input  logic        rgb_valid,
                        
   output logic        reading,
   output logic         
      [RGB_WIDTH-1:0]  rgb_out
);

//---------------------------------
// Debayer ISP function
//---------------------------------
   raw2rgb #(
      .LINE_LENGTH (LINE_LENGTH), // number of data entries per line
      .RGB_WIDTH   (RGB_WIDTH)    // width of RGB data (24-bit)
   )
   u_raw2rgb (
      .clk        (clk),          //i           
      .rst        (rst),          //i

      .data_in    (data_in),      //i'lane_data_t
      .data_valid (data_valid),   //i  
      .rgb_valid  (rgb_valid),    //i

      .reading    (reading),      //o
      .rgb_out    (rgb_out)       //o[RGB_WIDTH-1:0]
   );

//---------------------------------
// More ISP functions to follow
//---------------------------------
   
endmodule: isp_top

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/5/14 Armin Zunic: initial creation
*/
