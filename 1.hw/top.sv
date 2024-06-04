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
// Description: This is the Chip top-level file. It includes:
//   - Main PLL with top-level clock and reset generation
//   - Xilinx-specific IDELAY controller
//   - I2C Master for loading configuration into camera
//   - CSI_RX camera front-end
//   - ISP blocks:
//        - raw2rgb
//   - Asynchronous FIFO
//   - HDMI monitor back-end
//   - Misc and Debug utilities
//========================================================================

module top 
   import top_pkg::*;
   import hdmi_pkg::*;
(
   input logic   areset,   // external active-1 asynchronous reset
   input logic   clk_ext,  // external 100MHz clock source

  //I2C_Master to Camera
`ifdef COCOTB_SIM
   inout  tri1   i2c_sda,
   inout  tri1   i2c_scl,
`else
   inout  wire   i2c_sda,
   inout  wire   i2c_scl,
`endif //COCOTB_SIM

  //MIPI DPHY from/to Camera
   input  diff_t      cam_dphy_clk,
   input  lane_diff_t cam_dphy_dat,

   output logic       cam_en,
      
  //HDMI output, goes directly to connector
   output logic  hdmi_clk_p,
   output logic  hdmi_clk_n,
   output bus3_t hdmi_dat_p,
   output bus3_t hdmi_dat_n,
   
  //Misc/Debug
   output bus3_t led,
   output bus8_t debug_pins
);

`ifdef COCOTB_SIM
glbl glbl();
`endif
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
   i2c_top  #(
      .I2C_SLAVE_ADDR (7'd16)
   ) u_i2c  (
     //clocks and resets
      .clk           (clk_100),       //i
      .strobe_400kHz (strobe_400kHz), //i
      .areset_n      (i2c_reset),     //i

     //I2C_Master to Camera
      .i2c_scl       (i2c_scl),       //io 
      .i2c_sda       (i2c_sda)        //io 
   );

//--------------------------------
// CSI_RX
//--------------------------------
   logic       csi_byte_clk;
   lane_data_t csi_word_data;
   logic       csi_word_valid;
   logic       csi_in_line, csi_in_frame;   

   bus8_t      debug_csi;
    
   csi_rx_top u_csi_rx_top (
      .ref_clock          (clk_200),        //i 
      .reset              (reset),          //i 
                          
     //MIPI DPHY from/to Camera
      .cam_dphy_clk       (cam_dphy_clk),   //i'diff_t
      .cam_dphy_dat       (cam_dphy_dat),   //i'lane_diff_t
      .cam_en             (cam_en),         //o 

     //CSI to internal video pipeline     
      .csi_byte_clk       (csi_byte_clk),   //o
      .csi_unpack_dat     (csi_word_data),  //o'lane_data_t
      .csi_unpack_dat_vld (csi_word_valid), //o

      .csi_in_line        (csi_in_line),    //o    
      .csi_in_frame       (csi_in_frame),   //o

     //Misc/Debug
      .debug_pins         (debug_csi)       //o[7:0]
   );
      
//--------------------------------
// ISP Functions
//--------------------------------
   logic  rgb_valid;
   pix_t  rgb_pix;
   logic  rgb_reading;

   isp_top #(
      .LINE_LENGTH (640),           // number of data entries per line
      .RGB_WIDTH   ($bits(pix_t))   // width of RGB data (24-bit)
   )
   u_isp (
      .clk        (csi_byte_clk),   //i           
      .rst        (reset),          //i

      .data_in    (csi_word_data),  //i'lane_data_t
      .data_valid (csi_in_line),    //i  
      .rgb_valid  (rgb_valid),      //i

      .reading    (rgb_reading),    //o
      .rgb_out    (rgb_pix)         //o[RGB_WIDTH-1:0]
   );
      
//--------------------------------
// AsyncFIFO with Synchronization
//--------------------------------
   logic hdmi_clk;
   logic hdmi_frame;
   logic hdmi_blank;
   logic hdmi_reset_n;
   pix_t hdmi_pix;

   rgb2hdmi u_rgb2hdmi (
     //from/to CSI and RGB block
      .csi_clk      (csi_byte_clk),   //i           
      .reset        (reset),          //i

      .csi_in_line  (csi_in_line),    //i  
      .csi_in_frame (csi_in_frame),   //i  

      .rgb_pix      (rgb_pix),        //i'pix_t
      .rgb_reading  (rgb_reading),    //i 
      .rgb_valid    (rgb_valid),      //o

     //from/to HDMI block
      .hdmi_clk     (hdmi_clk),       //i

      .hdmi_frame   (hdmi_frame),     //i
      .hdmi_blank   (hdmi_blank),     //i
      .hdmi_reset_n (hdmi_reset_n),   //o
      .hdmi_pix     (hdmi_pix)        //o'pix_t 
   );

//--------------------------------
// HDMI backend
//--------------------------------
   logic hdmi_hsync, hdmi_vsync;

   hdmi_top u_hdmi_top(
      .clk_ext      (clk_100),      //i 
      .clk_pix      (hdmi_clk),     //o
                     
      .pix          (hdmi_pix),     //i'pix_t  
     
     //synchronization
      .hdmi_reset_n (hdmi_reset_n), //i

      .hdmi_frame   (hdmi_frame),   //o

      .blank        (hdmi_blank),   //o
      .vsync        (hdmi_vsync),   //o 
      .hsync        (hdmi_hsync),   //o 
                     
     //HDMI output, goes directly to connector
      .hdmi_clk_p   (hdmi_clk_p),   //o
      .hdmi_clk_n   (hdmi_clk_n),   //o
      .hdmi_dat_p   (hdmi_dat_p),   //o'bus3_t
      .hdmi_dat_n   (hdmi_dat_n)    //o'bus3_t
   );
   

//--------------------------------
// Misc and Debug
//--------------------------------
    assign led[0] = cam_en;
    assign led[1] = 1'b0;
    assign led[2] = clk_1hz; 

   assign debug_pins = {
      ~hdmi_hsync, 
      ~hdmi_vsync, 
       hdmi_blank, 
       rgb_reading, 
       hdmi_reset_n, 
       debug_csi[2:0]
   };
   
endmodule: top

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/30 AnelH: Initial creation
 2024/3/14 Armin Zunic: updated based on sim results
*/
