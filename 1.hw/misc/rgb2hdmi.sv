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
   output pix_t hdmi_pix,

   output bus4_t debug_fifo
);

//--------------------------------
// Synchronization Logic
//--------------------------------
logic            csi_in_line_dly, csi_in_frame_dly;   
logic [10:0]     csi_line_count;
logic [5:0]      csi_frame_count;  // Brojač frejmova sada ide do 59

always_ff @(posedge csi_clk) begin 
   if (reset) begin
      csi_in_line_dly   <= 1'b0;
      csi_in_frame_dly  <= 1'b0;
      csi_line_count    <= 11'd0;
      csi_frame_count   <= 6'd0;  // Brojač frejmova resetujemo na 0

      // Ostali vaši signali...
      rgb_valid         <= 1'b0;
      hdmi_reset_n      <= 1'b0;  // Reset je aktivan odmah na početku
   end 
   else begin
      // ------------------------------------
      // 1) Formiranje kašnjenja za detekciju ivice
      // ------------------------------------
      csi_in_line_dly   <= csi_in_line;
      csi_in_frame_dly  <= csi_in_frame;

      // ------------------------------------
      // 2) Brojač frejmova (0..59)
      // ------------------------------------
      if ({csi_in_frame_dly, csi_in_frame} == 2'b01) begin
         if (csi_frame_count == 6'd1)
            csi_frame_count <= 6'd0;
         else
            csi_frame_count <= csi_frame_count + 1'b1;

         // Na početku svakog frejma reset linija
         csi_line_count <= 11'd0; 
      end
      else if ( (csi_in_frame == 1'b1) && ({csi_in_line_dly, csi_in_line} == 2'b01) ) begin
         csi_line_count <= csi_line_count + 1'b1;
      end

      // ------------------------------------
      // 3) Generisanje hdmi_reset_n
      //    - 0 na prvoj liniji svakog "60-tog" frejma
      //    - Takođe, 0 na prvoj liniji prvog frejma (inicijalni reset)
      // ------------------------------------
      if ((csi_frame_count == 6'd0) && (csi_line_count == 11'd0))
         hdmi_reset_n <= 1'b0;  // Puls reset signala
      else
         hdmi_reset_n <= 1'b1;

      // ------------------------------------
      // 4) Primer za rgb_valid (kako je ranije bio)
      // ------------------------------------
      // recimo želite da bude validno nakon 3 linije itd...
      rgb_valid <= (csi_line_count >= 11'd3);
   end
end


   

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
      .m_axis_tdata   ( hdmi_pix),   //o[23:0]

      .debug_fifo     (debug_fifo)   //o[3:0]
   );

endmodule: rgb2hdmi

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/5/3 AnelH: Initial creation
*/
