//======================================================================== 
// openeye-CSI * NLnet-sponsored open-source core for Camera I/F with ISP
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
// Designers  : Armin Zunic, Isam Vrce
// Description: Common HDMI-related declarations
//========================================================================

`define HDMI_720p60
//`define HDMI_1080p30
//`define HDMI_1080p60

package hdmi_pkg;

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

//-----------------------------------------------------------
// Screen Resolution and timings:
//-----------------------------------------------------------
// See: https://github.com/hdl-util/hdmi/blob/master/src/hdmi.sv
//      https://www.fpga4fun.com/HDMI.html
//      https://tomverbeure.github.io/video_timings_calculator (CEA-861)
//      https://tomverbeure.github.io/video_timings_calculator (CVT-RBv2)
//      https://purisa.me/blog/hdmi-released
//-----------------------------------------------------------

`ifdef HDMI_720p60
    //__1280x720Px60Hz
    localparam int HFRAME         = 1650; // complete frame X
    localparam int HSCREEN        = 1280; // visible X
    localparam int HSYNC_START    = HSCREEN + 110;
    localparam int HSYNC_SIZE     = 40;
    localparam int HSYNC_END      = HSYNC_START + HSYNC_SIZE;
    localparam bit HSYNC_POLARITY = HI;    // '+'

    localparam int VFRAME         = 750;  // complete frame Y
    localparam int VSCREEN        = 720;  // visible Y
    localparam int VSYNC_START    = VSCREEN + 5;
    localparam int VSYNC_SIZE     = 5;
    localparam int VSYNC_END      = VSYNC_START + VSYNC_SIZE;
    localparam bit VSYNC_POLARITY = HI;    // '+'
`elif HDMI_1080p30	
    //__1920x1080Px30Hz
    localparam int HFRAME         = 2200;  // complete frame X
    localparam int HSCREEN        = 1920;  // visible X
    localparam int HSYNC_START    = HSCREEN + 88;
    localparam int HSYNC_SIZE     = 44;
    localparam int HSYNC_END      = HSYNC_START + HSYNC_SIZE;
    localparam bit HSYNC_POLARITY = HI;     // '+'

    localparam int VFRAME         = 1125;  // complete frame Y
    localparam int VSCREEN        = 1080;  // visible Y
    localparam int VSYNC_START    = VSCREEN + 4;
    localparam int VSYNC_SIZE     = 5;
    localparam int VSYNC_END      = VSYNC_START + VSYNC_SIZE;
    localparam bit VSYNC_POLARITY = HI;     // '+'
`else
    //__1920x1080Px60Hz CVT-RBv2
    localparam int HFRAME         = 2000;  // complete frame X
    localparam int HSCREEN        = 1920;  // visible X
    localparam int HSYNC_START    = HSCREEN + 8;
    localparam int HSYNC_SIZE     = 32;
    localparam int HSYNC_END      = HSYNC_START + HSYNC_SIZE;
    localparam bit HSYNC_POLARITY = HI;     // '+'
 
    localparam int VFRAME         = 1111;  // complete frame Y
    localparam int VSCREEN        = 1080;  // visible Y
    localparam int VSYNC_START    = VSCREEN + 17;
    localparam int VSYNC_SIZE     = 8;
    localparam int VSYNC_END      = VSYNC_START + VSYNC_SIZE;
    localparam bit VSYNC_POLARITY = HI;     // '+'
`endif

//-----------------------------------------------------------
// Pixel and TDMS Declarations:
//  2 = Red
//  1 = Green
//  0 = Blue
//-----------------------------------------------------------
    typedef struct packed {
        bus8_t  R;   // [2]
        bus8_t  G;   // [1]
        bus8_t  B;   // [0]
    } pix_t;

    typedef struct packed {
        bus2_t  c; //[9:8] - control[1:0]
        bus8_t  d; //[7:0] - data[7:0]
    } tdms_t;
   
    typedef tdms_t [2:0] tdms_pix_t;

endpackage: hdmi_pkg

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/1/4 Isam Vrce: Initial creation 
 2024/1/8 Armin Zunic: Timing improvements  
 2024/1/10 Isam Vrce: More timing tuning
 2024/1/16 Armin Zunic: Adding ifdef parts
 */
