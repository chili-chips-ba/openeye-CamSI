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
// Description: This is the CSI_RX top-level file. It includes camera 
// front-end logic:
//   - Clock and Data PHYs
//   - Clock Detector
//   - Byte Aligners 
//   - Word Aligner 
//   - Depacketizer
//========================================================================

module csi_rx_top 
   import top_pkg::*;
(

 //clocks and resets
   input  logic           ref_clock, // 200MHz refclk
   input  logic           reset,     // active-1 synchronous reset
   input  logic           clk_1hz,

 //MIPI DPHY from/to Camera
   input  diff_t          cam_dphy_clk,
   input  lane_diff_t     cam_dphy_dat,
   input  logic           cam_en,

 //CSI to internal video pipeline
   output logic           csi_byte_clk,
   output lane_raw_data_t csi_unpack_raw_dat,
   output logic           csi_unpack_raw_dat_vld,
    
   output logic           csi_in_line,
   output logic           csi_in_frame,   

 //Misc/Debug
   output bus8_t         debug_pins
);
   
//--------------------------------
// DPHY-Clock with clock detector
//--------------------------------
   logic bit_clock;
   logic dphy_clk_reset;
   logic csi_reset;
   
   csi_rx_phy_clk u_phy_clk (   
      .dphy_clk   (cam_dphy_clk),   //i[1:0]
      .reset      (reset),          //i

      .reset_out  (dphy_clk_reset), //o      
      .bit_clock  (bit_clock),      //o buffered dphy clock
      .byte_clock (csi_byte_clk)    //o buferred dphy clock / 4
   );

   csi_rx_clk_det u_clk_det (
      .ref_clock  (ref_clock),      //i 
      .byte_clock (csi_byte_clk),   //i 

      .reset_in   (dphy_clk_reset), //i   
      .enable     (cam_en),         //i 

      .reset_out  (csi_reset)       //o
   );

//--------------------------------
// DPHY-Data
//--------------------------------
   lane_data_t deser_data;
   logic [9:0] delay;

   always_ff @(posedge ref_clock) begin
      delay <= (delay == 10'd1023) ? 10'd0 : delay + 10'd1;
   end
   
   for (genvar i=0; i<NUM_LANE; i++) begin: lane
      csi_rx_phy_dat #(
         .INVERT     (DINVERT   [i]),
         .DELAY      (DSKEW     [i])
      ) 
      u_phy_dat (      
         .delay      (delay[i*5 +: 5]), //i[4:0]
         .reset      (csi_reset),       //i
         .bit_clock  (bit_clock),       //i
         .byte_clock (csi_byte_clk),    //i     

         .dphy_hs    (cam_dphy_dat[i]), //i[1:0]
         .deser_out  (deser_data  [i])  //o[7:0]
      );
   end: lane


//--------------------------------
// Byte and Word Aligners
//--------------------------------
   logic        wait_for_sync;
   logic        byte_packet_done;
   logic        packet_done;

   lane_data_t  byte_align_data;
   lane_vld_t   byte_valid;

   lane_data_t  word_data;
   logic        word_valid;
   
   
   csi_rx_align_byte u_align_byte [NUM_LANE-1:0] (
      .clock           (csi_byte_clk),     //i
      .reset           (csi_reset),        //i
                                            
      .enable          (cam_en),           //i
      .deser_in        (deser_data),       //i[7:0]
      .wait_for_sync   (wait_for_sync),    //i
      .packet_done     (byte_packet_done), //i
                                            
      .data_out        (byte_align_data),  //o[7:0]
      .data_vld        (byte_valid)        //o
   );

//--------------------------------
   csi_rx_align_word u_align_word (
      .byte_clock      (csi_byte_clk),     //i
      .reset           (csi_reset),        //i

      .enable          (cam_en),           //i
      .packet_done     (packet_done),      //i
      .wait_for_sync   (wait_for_sync),    //i
      .word_in         (byte_align_data),  //i'lane_data_t
      .valid_in        (byte_valid),       //i'lane_vld_t

      .packet_done_out (byte_packet_done), //o
      .word_out        (word_data),        //o'lane_data_t
      .valid_out       (word_valid)        //o
   );

//--------------------------------
   lane_data_t csi_unpack_dat;
   logic       csi_unpack_dat_vld;
   logic       csi_sync_seq;
   bus2_t      debug_pkt;

   csi_rx_packet_handler u_depacket (
      .clock           (csi_byte_clk),       //i 
      .reset           (csi_reset),          //i 
      .enable          (cam_en),             //i 
                        
      .data            (word_data),          //i'lane_data_t
      .data_valid      (word_valid),         //i
                        
      .sync_wait       (wait_for_sync),      //o
      .packet_done     (packet_done),        //o 
      .payload_out     (csi_unpack_dat),     //o'lane_data_t
      .payload_valid   (csi_unpack_dat_vld), //o
                        
      .sync_seq        (csi_sync_seq),       //o
      .in_frame        (csi_in_frame),       //o
      .in_line         (csi_in_line),        //o
                        
      .ecc_out         (),                   //o
      .debug_out       (debug_pkt)           //o[1:0]
   );

//--------------------------------
`ifdef RAW8
   assign csi_unpack_raw_dat     = csi_unpack_dat;
   assign csi_unpack_raw_dat_vld = csi_unpack_dat_vld;
`elsif RAW10
   csi_rx_10bit_unpack u_10bit_unpack (
      .clock           (csi_byte_clk),          //i
      .reset           (csi_reset),             //i
      .enable          (cam_en),                //i
      .data_in         (csi_unpack_dat),        //i'lane_data_t
      .din_valid       (csi_unpack_dat_vld),    //i
      .data_out        (csi_unpack_raw_dat),    //o'lane_raw_data_t
      .dout_valid      (csi_unpack_raw_dat_vld) //o
   );
`else // RAW12
   csi_rx_12bit_unpack u_12bit_unpack (
      .clock           (csi_byte_clk),          //i
      .reset           (csi_reset),             //i
      .enable          (cam_en),                //i
      .data_in         (csi_unpack_dat),        //i'lane_data_t
      .din_valid       (csi_unpack_dat_vld),    //i
      .data_out        (csi_unpack_raw_dat),    //o'lane_raw_data_t
      .dout_valid      (csi_unpack_raw_dat_vld) //o
   );
`endif

//--------------------------------
// Misc and Debug
//--------------------------------

/*
//______
// Extend the width of Start-Of-Frame pulse
   logic [2:0] sof_cnt;
   logic       sof_extended;

   always_ff @(posedge csi_byte_clk) begin
      if (csi_link_reset_out == 1'b1) begin
         sof_cnt      <= '0;
         sof_extended <= 1'b0;
      end 
      else begin
         if (sof_cnt < 3'd5) begin
            sof_cnt      <= 3'(sof_cnt + 3'd1);
            sof_extended <= 1'b1;
         end 
         else begin
            sof_extended <= 1'b0;
         end
      end
   end

//______
   ila_0 u_ila_0 (
       .clk     (clk_temp),
       .probe0  (csi_byte_clk),
       .probe1  (csi_in_frame),
       .probe2  (csi_in_line),
       .probe3  (sof_extended),
       .probe4  (csi_sync_seq),
       .probe5  (byte_valid[0]),
       .probe6  (byte_valid[1]),        
       .probe7  (csi_word_data)       
   );   

   logic sig_in_delayed, first_pulse_generated;
   always_ff @(posedge clk) begin
      sig_in_delayed <= csi_sync_seq; // Delay sig_in by one clock cycle

      // Generate pulse on the first rising edge of sig_in
      if (csi_sync_seq == 1'b1 && sig_in_delayed == 1'b0 && first_pulse_generated == 1'b0) begin
          start <= 1'b1;
          first_pulse_generated <= 1'b1; // Set flag after generating the first pulse
      end else begin
          start <= 1'b0; // Ensure pulse_out is only high for one clock cycle
      end
   end

 */   

   assign debug_pins = { 
      csi_in_frame,
      csi_in_line,
      csi_unpack_dat_vld, 
      packet_done,
      word_valid,
      wait_for_sync,
      byte_valid[0],
      csi_reset
   };
    
endmodule: csi_rx_top

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/25 AnelH: Initial creation
*/
