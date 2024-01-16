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
// Designers  : Armin Zunic, Isam Vrce
// Description:
// HDMI controller that renders image on 1280x720P@60Hz display.
// Provides screen X&Y co-ordinates for external logic to generate colors.
//
// RTL is written in a way that facilitates porting to different FPGA platforms.
// Tested with:
//  1) Xilinx Artix7    (XC7A35T-1CPG236) on Digilent Cmod A7-35T, 24MHz ext.clock
//  2) GoWin  LittleBee (GW1NR-9C)        on Sipeed   TangNano-9K, 27MHz ext.clock
//========================================================================

module hdmi_backend 
   import hdmi_pkg::*;
(
   input  logic   clk_ext,
   output logic   clk_pix,     // main/parallel pixel clock
   output logic   srst_n,      // synch reset for pixel clock

  // Current X and Y position of the pixel
   output bus12_t hcount,
   output bus12_t vcount,
   input  pix_t   pix,         // pixel color data

 //Pulse1 when done rendering: 
   output logic   frame_done,  // one visible frame: 1/60Hz = 16.7ms
   output logic   mfram_done,  // multiple frames, per MFRAM_CNT_MAX

 //HDMI output, goes directly to connector
   output logic   hdmi_clk_p,
   output logic   hdmi_clk_n,
   output bus3_t  hdmi_dat_p,
   output bus3_t  hdmi_dat_n
);

//-----------------------------------------------------------
// Clock generation (technology-specific). Parallel and 5x
//  serial, as needed for the 1280x720P@60Hz display.
//-----------------------------------------------------------
   logic clk_pix5; // serial (x5) pixel clock

   fpga_pll u_fpga_pll (
      .clk_ext  (clk_ext),  //i

      .srst_n   (srst_n),   //o  main reset, sync'd to clk_pix
      .clk_pix5 (clk_pix5), //o  371.25MHz 5x serial clock
      .clk_pix  (clk_pix)   //o   74.25MHz pixel clock
   );

//-----------------------------------------------------------
// Screen timebase generation for 1280x720Px60Hz
//-----------------------------------------------------------
   logic       hsync;
   logic       vsync;    
   logic       blank;
   logic       frame_done0;
   mfram_cnt_t mfram_cnt;
  
   assign frame_done0 = (hcount == HSCREEN) & (vcount == VSCREEN); 

   always_ff @(negedge srst_n or posedge clk_pix) begin: _tbase_gen
      if (srst_n == LO) begin      
         hcount     <= '0;
         vcount     <= '0;
         hsync      <= LO;
         vsync      <= LO;
         blank      <= HI;

         frame_done <= LO;
         mfram_done <= LO; 
         mfram_cnt  <= '0;
      end
      else begin
      // Count lines and rows      
         if (hcount == HFRAME-1) begin
            hcount    <= '0;
          
            if (vcount == VFRAME-1) begin
               vcount <= '0;
            end
            else begin
               vcount <= 12'(vcount + 12'(1)); 
            end
         end

         else begin
            hcount    <= 12'(hcount + 12'(1)); 
         end

      // Horizontal Sync
         if ((hcount >= HSYNC_START) && (hcount < HSYNC_END)) begin
            hsync <=  HSYNC_POLARITY;
         end
         else begin
            hsync <= ~HSYNC_POLARITY;
         end

      // Vertical Sync
         if ((vcount >= VSYNC_START) && (vcount < VSYNC_END)) begin
            vsync <= VSYNC_POLARITY;
         end 
         else begin
            vsync <= ~VSYNC_POLARITY;
         end

      // Blank when outside the visible screen
         blank <= (hcount >= HSCREEN) | (vcount >= VSCREEN);
        
      // Pulse1 when done rendering one visible frame (frame_done),
      // as well as MFRAM_CNT_MAX visible frames      (mfram_done)
         frame_done <= frame_done0;
         mfram_done <= frame_done0 & (mfram_cnt == MFRAM_CNT_MAX-1);
         
         if (mfram_done == HI) begin
            mfram_cnt <= '0;
         end
         else if (frame_done == HI) begin
            mfram_cnt <= mfram_cnt_t'(mfram_cnt + mfram_cnt_t'(1));
         end
      end
   end: _tbase_gen

//-----------------------------------------------------------
// TMDS encoding, Output serializers and LVDS buffers.
// At-resolution pixel-level and TDMS processing
//-----------------------------------------------------------
   logic       srst;
   
   tdms_pix_t  tdms_pix;  // raw input TDMS pixel
   tdms_pix_t  tdms_enc;  // TDMS-encoded pixel symbols

   bus3_t      tdms_sdat; // Serialized Pixel data
   logic       tdms_sclk; //  and clock

   always_comb begin: _comb
      srst = ~srst_n;
   
      tdms_pix[2].c = '0;             //R 
      tdms_pix[1].c = '0;             //G 
      tdms_pix[0].c = {vsync, hsync}; //B 

      tdms_pix[2].d = pix.R;
      tdms_pix[1].d = pix.G;
      tdms_pix[0].d = pix.B;
   end: _comb
   
   for (genvar i=0; i<3; i++) begin: _tdms_sdat
      hdmi_tdms_enc u_tmds (
         .clk     (clk_pix),
         .blank   (blank),
         .raw     (tdms_pix [i]),
         .encoded (tdms_enc [i])
      );

      fpga_oser10 u_oser_dat (
         .arst    (srst),
         .clk_par (clk_pix),
         .clk_ser (clk_pix5),
         .d       (tdms_enc [i]),
         .q       (tdms_sdat[i])
      );

      fpga_olvds u_obuf_dat (
         .i       (tdms_sdat [i]),
         .o       (hdmi_dat_p[i]),
         .ob      (hdmi_dat_n[i])
      );
   end: _tdms_sdat

//-----------------------------------------------------------
// TDMS clock generator
//-----------------------------------------------------------
   fpga_oser10 u_oser_clk (
     .arst    (srst),
     .clk_par (clk_pix),
     .clk_ser (clk_pix5),
     .d       (10'b00000_11111),

     .q       (tdms_sclk)
   );

   fpga_olvds u_obuf_clk (
     .i       (tdms_sclk),
     .o       (hdmi_clk_p),
     .ob      (hdmi_clk_n)
   );

endmodule: hdmi_backend

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/01/15 AZ: initial creation    

*/
