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
// Description: This is the CSI_RX top-level file. It includes:
//   - CSI_RX camera front-end
//========================================================================

module csi_rx_top 
   import top_pkg::*;
(

 //clocks and resets
   input  logic       ref_clock, // 200MHz refclk
   input  logic       reset,     // active-1 synchronous reset

 //MIPI DPHY from/to Camera
   input  diff_t      cam_dphy_clk,
   input  diff_t      cam_dphy_dat [NUM_LANE],
   output logic       cam_en,

 //CSI to internal video pipeline
   output logic       csi_byte_clk,
   output lane_data_t csi_unpack_dat,
   output logic       csi_unpack_dat_vld,
    
   output logic       csi_in_line,
   output logic       csi_in_frame,   

 //Misc/Debug
   output bus8_t      debug_pins
);
   
//--------------------------------
// CSI_Rx
//--------------------------------
   logic       csi_link_reset_out;
   logic       csi_wait_for_sync;
   logic       csi_packet_done;
   lane_data_t csi_word_data;
   logic       csi_word_valid;
   logic       csi_sync_seq;

   lane_vld_t  debug_out;
   bus2_t      debug_pkgout;

   csi_rx u_csi_rx (
      .ref_clock      (ref_clock),          //i 
      .dphy_clk       (cam_dphy_clk),       //i'diff_t 
      .dphy_dat       (cam_dphy_dat),       //i'lane_diff_t 

      .reset          (reset),              //i
      .enable         (cam_en),             //i
      .wait_for_sync  (csi_wait_for_sync),  //i
      .packet_done    (csi_packet_done),    //i

      .reset_out      (csi_link_reset_out), //o
      .byte_clock     (csi_byte_clk),       //o
      .word_valid     (csi_word_valid),     //o
      .word_data      (csi_word_data),      //o'lane_data_t

      .debug_out      (debug_out)           //o'lane_vld_t
   );  
   

//--------------------------------
// CSI Packet Handler
//--------------------------------
   csi_rx_packet_handler u_depacket (
      .clock          (csi_byte_clk),       //i 
      .reset          (csi_link_reset_out), //i 
      .enable         (cam_en),             //i 

      .data           (csi_word_data),      //i'lane_data_t
      .data_valid     (csi_word_valid),     //i

      .sync_wait      (csi_wait_for_sync),  //o
      .packet_done    (csi_packet_done),    //o 
      .payload_out    (csi_unpack_dat),     //o'lane_data_t
      .payload_valid  (csi_unpack_dat_vld), //o

      .sync_seq       (csi_sync_seq),       //o
      .in_frame       (csi_in_frame),       //o
      .in_line        (csi_in_line),        //o

      .ecc_out        (),                   //o
      .debug_out      (debug_pkgout)        //o[1:0]
   );


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
       .probe5  (debug_out[0]),
       .probe6  (debug_out[1]),        
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
       debug_pkgout, 
       debug_out[1:0], 
       csi_sync_seq, 
       1'b0, 
       csi_in_line, 
       csi_in_frame
    };
    
endmodule: csi_rx_top

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/25 AnelH: Initial creation
*/
