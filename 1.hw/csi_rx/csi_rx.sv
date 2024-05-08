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
// Description: This module includes:
//   - Clock and Data PHYs
//   - Clock Detector
//   - Byte Aligners 
//   - Word Aligner 
//
// It supports any number of lanes
//========================================================================

module csi_rx 
   import top_pkg::*;
(
   input  logic       ref_clock,     // refclk for MIPI-CSI clk detector
   input  diff_t      dphy_clk,      // clock lane
   input  lane_diff_t dphy_dat,      // data lanes
                       
   input  logic       reset,         // active-1 synchronous reset
   input  logic       enable,        // active-1 enable
   input  logic       wait_for_sync, // sync wait signal from packet handler
   input  logic       packet_done,   // packet done signal from packet handler
                       
   output logic       reset_out,     // internal reset based on clock detection
   output logic       byte_clock,    // divided byte clock output
   output logic       word_valid,    // 1 when word is synced and aligned
   output lane_data_t word_data,     // aligned word data output

   output lane_vld_t  debug_out
);

   lane_data_t deser_data;
   lane_data_t byte_align_data;
   lane_vld_t  byte_valid;

   assign      debug_out = byte_valid;

//--------------------------------
// DPHY-Clock with clock detector
//--------------------------------
   logic bit_clock;

   csi_rx_phy_clk u_phy_clk (   
      .dphy_clk   (dphy_clk),   //i[1:0]
      .reset      (reset),      //i
                                 
      .bit_clock  (bit_clock),  //o buffered dphy clock
      .byte_clock (byte_clock)  //o buferred dphy clock / 4
   );

   csi_rx_clk_det u_clk_det (
      .ref_clock  (ref_clock),  //i 
      .byte_clock (byte_clock), //i 

      .reset_in   (reset),      //i   
      .enable     (enable),     //i 

      .reset_out  (reset_out)   //o
   );

//--------------------------------
// DPHY-Data
//--------------------------------
   for (genvar i=0; i<NUM_LANE; i++) begin: _lane
      csi_rx_phy_dat #(
         .INVERT     (DINVERT   [i]),
         .DELAY      (DSKEW     [i])
      ) 
      u_phy_dat (      
         .bit_clock  (bit_clock),     //i
         .byte_clock (byte_clock),    //i     

         .reset      (reset_out),     //i
         .enable     (enable),        //i
       
         .dphy_hs    (dphy_dat  [i]), //i[1:0]
         .deser_out  (deser_data[i])  //o[7:0]
      );
   end: _lane

   
//--------------------------------
// Byte and Word Aligners
//--------------------------------
   logic  byte_packet_done;

   csi_rx_align_byte u_align_byte [NUM_LANE-1:0] (
      .clock         (byte_clock),         //i
      .reset         (reset_out),          //i
                                            
      .enable        (enable),             //i
      .deser_in      (deser_data),         //i[7:0]
      .wait_for_sync (wait_for_sync),      //i
      .packet_done   (byte_packet_done),   //i
                                            
      .data_out      (byte_align_data),    //o[7:0]
      .data_vld      (byte_valid)          //o
   );

//--------------------------------
   csi_rx_align_word u_align_word (
      .byte_clock      (byte_clock),       //i
      .reset           (reset_out),        //i

      .enable          (enable),           //i
      .packet_done     (packet_done),      //i
      .wait_for_sync   (wait_for_sync),    //i
      .word_in         (byte_align_data),  //i'lane_data_t
      .valid_in        (byte_valid),       //i'lane_vld_t

      .packet_done_out (byte_packet_done), //o
      .word_out        (word_data),        //o'lane_data_t
      .valid_out       (word_valid)        //o
   );

endmodule: csi_rx

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/4  Armin Zunic: Initial creation
*/
