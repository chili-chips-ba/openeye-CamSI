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
// Description: This modules receives aligned bytes with their valid flags
// to then COMPENSATE FOR UP TO 2 CLOCK CYCLES OF SKEW BETWEEN LANES.
//
// It also resets byte aligners' sync stat us (via 'packet_done_out')
// when SYNC pattern is not found by byte aligners on all lanes.
//
// Similarly to the byte aligner, it locks the alignment taps when a 
// valid word is found and until 'packet_done' is asserted.
//
//------------------------------------------------------------------------
// Here is an illustration of 2-lane case with 2-clock-cycle skew between 
// them. This RTL is written to work for any number of lanes.
//   
//    clk            | 1 | 2 |         |n-1| n |
//                   |___|___|_________|   |   |
//    lane0 vld_in __|                 |_____________
//          data_in  |<===============>     |
//                   |                 
//                   |<--2-->|_________________
//    lane1 vld_in __________|                 |_____
//          data_in           <===============>
//                   |   |   |
//    taps           0   1   2
//                            _________
//      vld_in_all __________|         |_____________
//
// In this case, taps[0]=2, taps[1]=0, i.e. take: 
//   - lane0 byte after delay by 2 clocks
//   - lane1 byte without any delay
//========================================================================

module csi_rx_align_word 
   import top_pkg::*;
(
   input  logic       byte_clock,      // byte clock in
   input  logic       reset,           // active-1 synchronous reset

   input  logic       enable,          // active-1 enable
   input  logic       packet_done,     // packet done input from packet handler entity
   input  logic       wait_for_sync,   // whether or not to be looking for an alignment
   input  lane_data_t word_in,         // unaligned word from the byte aligners
   input  lane_vld_t  valid_in,        // valid flags from byte aligners

   output logic       packet_done_out, // 'packet_done' output to byte aligners
   output lane_data_t word_out,        // aligned word out to packet handler
   output logic       valid_out        // goes high once alignment is valid: First word
);                                     //   with 'valid_out=1' is the CSI packet header

//--------------------------------
   logic [15:0] word_dly_0;
   logic [15:0] word_dly_1;
   logic [15:0] word_dly_2;

   logic [1:0] valid_dly_0;
   logic [1:0] valid_dly_1;
   logic [1:0] valid_dly_2;

   typedef logic [1:0] taps_t [4];

   taps_t taps;
   taps_t next_taps;

   logic valid = 1'b0;
   logic next_valid;
   logic invalid_start = 1'b0;
   logic [15:0] aligned_word;
   
   
   // Process handling the word_clock
   always_ff @(posedge byte_clock) begin
      if (reset == 1'b1) begin
         valid <= 0;
         taps = '{2'b00, 2'b00, 2'b00, 2'b00}; // Reset taps
      end else if (enable == 1'b1) begin
         word_dly_0  <= word_in;
         valid_dly_0 <= valid_in;
         word_dly_1  <= word_dly_0;
         valid_dly_1 <= valid_dly_0;
         word_dly_2  <= word_dly_1;
         valid_dly_2 <= valid_dly_1;
         valid_out   <= valid;
         word_out    <= aligned_word;
         if ({next_valid, valid, wait_for_sync} == 3'b101) begin
            valid <= 1'b1;
            taps  <= next_taps;
         end else if (packet_done == 1'b1) begin
            valid <= 1'b0;
         end
      end
   end

   // Process handling valid delay logic and tap calculation
   always_comb begin
      logic next_valid_int;
      logic is_triggered = 1'b0;

      next_valid_int = &valid_dly_0;
      is_triggered   = 1'b0;
      for (int i = 0; i <= 1; i++) begin
         if ({valid_dly_0[i], valid_dly_1[i], valid_dly_2[i]} == 3'b111) begin
            is_triggered = 1'b1;
         end
      end
      invalid_start <= (!next_valid_int) && is_triggered;
      next_valid    <= next_valid_int;
      for (int i = 0; i <= 1; i++) begin
         if (valid_dly_2[i]) begin
            next_taps[i] = 2'b10;
         end else if (valid_dly_1[i]) begin
            next_taps[i] = 2'b01;
         end else begin
            next_taps[i] = 2'b00;
         end
      end
   end

   // Process handling word alignment
   always_comb begin
      for (int i = 0; i <= 1; i++) begin
         case (taps[i])
            2'b10: aligned_word[(8*i)+7 -: 8] = word_dly_2[(8*i)+7 -: 8];
            2'b01: aligned_word[(8*i)+7 -: 8] = word_dly_1[(8*i)+7 -: 8];
            default: aligned_word[(8*i)+7 -: 8] = word_dly_0[(8*i)+7 -: 8];
         endcase
      end
   end

   // Update packet_done_out
   assign packet_done_out = packet_done || invalid_start;
   
endmodule: csi_rx_align_word

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/18  Armin Zunic: Initial creation
*/
