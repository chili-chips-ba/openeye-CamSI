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
// Description: Top module for HDMI oputput. Patern generation. 
// It instantiates:
//    1) video back-end that generates pixel clock and renders the screen
//    2) video front-end that creates the game 
//
// 1080p@60Hz on this hardver is not possible, 666.666MHz frequency needed,
//  but 464MHz possible.
//
// See: https://github.com/hdl-util/hdmi/blob/master/src/hdmi.sv
//      https://www.fpga4fun.com/HDMI.html
//      https://tomverbeure.github.io/video_timings_calculator
//      https://purisa.me/blog/hdmi-released
//
// Xilinx Artix7 (XC7A100T-CSG324) on Trenz Adapter board (TEB0707-2) with
// 100MHz external clock
//========================================================================

module hdmi_top 
   import top_pkg::*;
   import hdmi_pkg::*;
(
   input  logic  clk_ext, // External clock: Artix7 = 100MHz
   output logic  clk_pix,

   input  pix_t  pix,

 //synchronization
   input  logic  hdmi_reset_n,

   output logic  hdmi_frame, 
   output logic  blank,
   output logic  vsync,
   output logic  hsync,        
       
 //HDMI output, goes directly to connector
   output logic  hdmi_clk_p,
   output logic  hdmi_clk_n,
   output bus3_t hdmi_dat_p,
   output bus3_t hdmi_dat_n
);

   bus11_t x, y;

//-----------------------------------------------------------
// Color generation algorithm: Based on the X,Y screen coordinates,
// set colors as you wish, or your imagination whispers to your ear
//    24'h00_00_00 is pitch-black 
//    24'hFF_FF_FF is bright-white
//
//   [2]=Red, [1]=Green, [0]=Blue
//
// For resolution 1280x720Px60Hz:
//    max visible X=1279 [10:0]
//    max visible Y= 719 [9:0]
//
// For resolutions 1920x1080P@30Hz and 1920x1080P@60Hz:
//    max visible X=1919 [10:0]
//    max visible Y=1079 [10:0]
//-----------------------------------------------------------
/*
    pix_t pix;

    always_comb begin: test_screen
        if (y[9:6] > 4'd8) begin // horizontal Gradient
            pix.R = x[10:3];
            pix.G = x[8:1];
            pix.B = x[7:0];
        end
        else unique case (x[10:7])
            4'd0: begin // pure Red
                pix.R = '1;
                pix.G = '0;
                pix.B = '0;
            end
            4'd1: begin // pure Green
                pix.R = '0;
                pix.G = '1;
                pix.B = '0;
            end
            4'd2: begin // pure Blue
                pix.R = '0;
                pix.G = '0;
                pix.B = '1;
            end
            4'd3: begin // vertical Gradient
                pix.R = {1'd0, y[5:0], 1'd1};
                pix.G = {1'd0, y[5:0], 1'd1};
                pix.B = {1'd0, y[5:0], 1'd1};
            end
            default: begin // interesting Scottish pattern
                pix.R = {y[5], x[5], y[5], x[5], 4'h4};
                pix.G = {y[6], x[3], y[6], x[3], 4'h3};
                pix.B = {x[7], y[1], x[7], y[1], 4'h2};
            end
        endcase
    end: test_screen
*/
   

//-----------------------------------------------------------
// HDMI Backend: 1280x720P@60Hz (or 1920x1080P@30Hz or 1920x1080P@60Hz) 
//  display renderer
//-----------------------------------------------------------
    hdmi_backend u_hdmi_backend ( 
       .clk_ext      (clk_ext),      //i
       .clk_pix      (clk_pix),      //o 
       .srst_n       (),             //o
                                
       //current X and Y position of the pixel
       .hcount       (x),            //o'bus11_t 
       .vcount       (y),            //o'bus11_t
       .pix          (pix),          //i'pix_t

       //synchronization
       .fifo_empty   (1'b0),         //i
       .hdmi_reset_n (hdmi_reset_n), //i

       .hdmi_frame   (hdmi_frame),   //o                       
       .blank        (blank),        //o
       .vsync        (vsync),        //o
       .hsync        (hsync),        //o    

       //HDMI output, goes directly to connector                       
       .hdmi_clk_p   (hdmi_clk_p),   //o 
       .hdmi_clk_n   (hdmi_clk_n),   //o 
       .hdmi_dat_p   (hdmi_dat_p),   //o[2:0] 
       .hdmi_dat_n   (hdmi_dat_n)    //o[2:0] 
    );
    
endmodule: hdmi_top

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/1/4  Isam Vrce  : Initial creation
 2024/1/8  Armin Zunic: Timing improvements
 2024/1/10 Isam Vrce  : More timing tuning
*/
