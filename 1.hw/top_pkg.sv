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
// Description: Common declarations, applicable across the board
//========================================================================

`ifndef __TOP_PKG__
`define __TOP_PKG__

`define HDMI_720p60
//`define HDMI_1080p30
//`define HDMI_1080p60 /*Artix-7 cannot go this option*/ 


package top_pkg;
   
//-----------------------------------------------------------
// Standard utility and bare essentials
//-----------------------------------------------------------
   typedef enum logic {LO = 1'b0, HI = 1'b1} bin_t;

   typedef logic [  1:0] bus2_t;   
   typedef logic [  2:0] bus3_t;    
   typedef logic [  3:0] bus4_t;   
   typedef logic [  4:0] bus5_t;    
   typedef logic [  5:0] bus6_t;   
   typedef logic [  6:0] bus7_t;   
   typedef logic [  7:0] bus8_t;   
   typedef logic [  8:0] bus9_t;   
   typedef logic [  9:0] bus10_t;
   typedef logic [ 10:0] bus11_t;  
   typedef logic [ 11:0] bus12_t;  
   typedef logic [ 15:0] bus16_t;  
   typedef logic [ 31:0] bus32_t;  
   typedef logic [127:0] bus128_t; 

   typedef logic [  1:0] diff_t; // P=bit[1]; N=[0] 

//-----------------------------------------------------------
// Chip-specific
//-----------------------------------------------------------
   localparam FPGA_DEV     = "7SERIES";
   localparam DPHY_TERM_EN = "TRUE";


`ifdef SIM_ONLY
 //speed-up for sim
   localparam NUM_CLK_FOR_400kHZ = 20;
   localparam NUM_CLK_FOR_1HZ    = 100; 
`else
   localparam NUM_CLK_FOR_400kHZ = 125;
   localparam NUM_CLK_FOR_1HZ    = 200_000;
   // (400kHz / 1 Hz) * 50% duty cycle ==> (400_000 / 1) * 0.5 = 200_000
`endif

   typedef logic[$clog2(NUM_CLK_FOR_400kHZ)-1:0] cnt_400khz_t;
   typedef logic[$clog2(NUM_CLK_FOR_1HZ)   -1:0] cnt_1hz_t;


   
// number of CSI lanes
`ifdef MIPI_4_LANE
   localparam                      NUM_LANE = 4; 
   localparam bit   [NUM_LANE-1:0] DINVERT  = 4'b1010; // adjust as needed
   localparam bus5_t[NUM_LANE-1:0] DSKEW    = {5'd3, 5'd3, 5'd3, 5'd3};
`else
   localparam                      NUM_LANE = 2;
   localparam bit   [NUM_LANE-1:0] DINVERT  = 2'b10; // this is based on Trenz board
   localparam bus5_t[NUM_LANE-1:0] DSKEW    = {5'd3, 5'd3};
`endif
   
   typedef diff_t [NUM_LANE-1:0] lane_diff_t;
   typedef bus5_t [NUM_LANE-1:0] lane_dly_t;

   typedef logic  [NUM_LANE-1:0] lane_vld_t;
   typedef bus8_t [NUM_LANE-1:0] lane_data_t;

endpackage: top_pkg
`endif //__TOP_PKG__
/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/4/24 Isam Vrce: Initial creation 
 */
