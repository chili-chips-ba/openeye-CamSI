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
// Description: Module for crossing from Camera to HDMI domain. It includes:
//   - AsyncFIFO for CDC, acting as a video Line Buffer
//   - Logic for synchronization of HDMI output to Camera input
//========================================================================

module rgb2hdmi
   import top_pkg::*;
   import hdmi_pkg::*;
(
 //from/to CSI and RGB block
   input  logic csi_clk,
   input  logic reset, // active-1 synchronous reset

   input  logic csi_in_line,
   input  logic csi_in_frame,

   input  pix_t rgb_pix,
   input  logic rgb_reading,
   output logic rgb_valid,

 //from/to HDMI block
   input  logic hdmi_clk,

   input  logic hdmi_frame,
   input  logic hdmi_blank,
   output logic hdmi_reset_n,
   output pix_t hdmi_pix
);

//--------------------------------
// Synchronization Logic
//--------------------------------
   logic   csi_in_line_dly;   
   bus11_t csi_line_count;
   
   always_ff @(posedge csi_clk) begin 
      if (reset == 1'b1) begin         
         csi_in_line_dly <= 1'b0;
         csi_line_count  <= '0;

         rgb_valid       <= 1'b0;
         hdmi_reset_n    <= 1'b0;
      end 
      else begin          
         csi_in_line_dly <= csi_in_line;

         // skip first 3 CMOS lines to start calculate RGB values
         rgb_valid       <= (csi_line_count >= 11'd3);
         
         // keep HDMI in reset between start of CMOS 
         //  frame and rising edge on first CMOS line  
         hdmi_reset_n    <= (csi_line_count >= 11'd1);

         if (csi_in_frame == 1'b0) begin 
            csi_line_count <= 11'd0;
         end
         // increment Line count with every 'csi_in_line' posedge
         //   unless outside of the visible screen
         else if ({csi_in_line_dly, csi_in_line} == 2'b01) begin
            if (csi_line_count < 11'd1300) begin
               csi_line_count <= 11'(csi_line_count + 11'd1);
            end
         end 
      end // else: !if(reset == 1'b1)
   end // always_ff @ (posedge csi_clk)
   

//--------------------------------
// AsyncFIFO
//--------------------------------
   axis_data_fifo u_afifo(
      .s_axis_aresetn (csi_in_frame | hdmi_frame), //i

     //FIFO Write side: Camera 
      .s_axis_aclk    (csi_clk),     //i
      .s_axis_tvalid  (rgb_reading), //i
      .s_axis_tready  (),            //o
      .s_axis_tdata   (rgb_pix),     //i[23:0] 

     //FIFO Read side: HDMI 
      .m_axis_aclk    (hdmi_clk),    //i
      .m_axis_tvalid  (),            //o
      .m_axis_tready  (~hdmi_blank), //i
      .m_axis_tdata   ( hdmi_pix)    //o[23:0]
   );

endmodule: rgb2hdmi

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/5/3 AnelH: Initial creation
*/
