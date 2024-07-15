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
// Description: 
//  - Generates 'wait_for_sync' and 'packet_done' for byte/word aligners
//  - Receives aligned words and processes them
//  - Keeps track of whether or not we are currently in a video line or frame
//  - Pulls the video payload out of long packets of the correct type
//========================================================================

module csi_rx_packet_handler 
   import top_pkg::*;
(
   input  logic       clock,         // state machine clock in
   input  logic       reset,         // asynchronous active high reset
   input  logic       enable,        // active high enable

   input  lane_data_t data,          // data from word aligner
   input  logic       data_valid,    // valid from word aligner

   output logic       sync_wait,     // drives byte+word aligner wait_for_sync
   output logic       packet_done,   // drives word aligner packet_done
   output lane_data_t payload_out,   // payload out from long video packets
   output logic       payload_valid, // whether or not payload output is valid
                                     // (i.e. currently receiving long packet)

   output logic       sync_seq,      // 1 when found MIPI SYNC sequence (B8B8)
   output logic       in_frame,      // 1 = in video frame: Got FS but not FE
   output logic       in_line,       // 1 when receiving video line

   output logic       ecc_out,       // ECC output
   output logic [1:0] debug_out
);

//----------------------
// Header parser / decoder
//----------------------
   typedef enum logic [2:0] {
      INIT      = 3'd0,
      START     = 3'd1,
      LONG_READ = 3'd2,
      DONE      = 3'd3,
      STOP      = 3'd4,
      SYNC1     = 3'd5,
      SYNC0     = 3'd6,
      LONG_WAIT = 3'd7
   } state_t;

   state_t state;

   logic        is_hdr;

   logic [31:0] packet_data;
   logic [5:0]  packet_type;
   logic [15:0] packet_len, packet_len_q;
   logic [23:0] packet_for_ecc;

   logic        long_packet;
   logic        valid_packet;

   logic [15:0] bytes_read;
   
   function logic is_allowed_type(
      input logic [5:0] packet_type
   );
      logic result;

`ifdef ICARUS
      // sorry: "inside" expressions not supported yet.
      case(packet_type)
         /*SYNC*/ 
         6'h00, 6'h01, 6'h02, 6'h03,

         /*Non-Image*/ 
         6'h10, 6'h11, 6'h12,

         /*RAW*/ 
         6'h28, 6'h29, 6'h2A, 6'h2B, 6'h2C, 6'h2D: 
            result = 1'b1;
         
         default: result = 1'b0;
      endcase
`else
      result = 1'b0;

      if (packet_type inside {
         /*SYNC*/ 
         6'h00, 6'h01, 6'h02, 6'h03,

         /*Non-Image*/ 
         6'h10, 6'h11, 6'h12,

         /*RAW*/ 
         6'h28, 6'h29, 6'h2A, 6'h2B, 6'h2C, 6'h2D
      }) result = 1'b1;
`endif //ICARUS

      return result;
   endfunction: is_allowed_type
   
   
/*
RM/Yimin:
../../../1.hw/csi_rx/csi_rx_packer_handler.sv:138: error: Unable to bind wire/reg/memory `expected_ecc' in `top.u_csi_rx_top.u_depacket'
../../../1.hw/csi_rx/csi_rx_packer_handler.sv:151:      : A symbol with that name was declared here. Check for declaration after use.
../../../1.hw/csi_rx/csi_rx_packer_handler.sv:142: error: Unable to bind wire/reg/memory `expected_ecc' in `top.u_csi_rx_top.u_depacket'
../../../1.hw/csi_rx/csi_rx_packer_handler.sv:151:      : A symbol with that name was declared here. Check for declaration after use.
*/
   logic [7:0]  expected_ecc;

   always_comb begin
      is_hdr         = ({data_valid, state} == {1'b1, SYNC1});

      packet_type    = packet_data[5:0];
      packet_len     = packet_data[23:8];
      packet_for_ecc = packet_data[23:0];

      valid_packet   = (packet_data[31:24] == expected_ecc) 
                     & is_allowed_type(packet_type) 
                     & (packet_data[7:6] == 2'd0);

      ecc_out        = (packet_data[31:24] == expected_ecc);

      long_packet    = (packet_type > 6'h0F) & valid_packet;
   end


//----------------------
// ECC Calculation
//----------------------
   
   csi_rx_hdr_ecc u_ecc (
      .data (packet_for_ecc), //i[23:0]
      .ecc  (expected_ecc)    //o[7:0]
   );


//----------------------
// Main FSM
//----------------------

   always_ff @(posedge reset or posedge clock) begin
      if (reset == 1'b1) begin
         state        <= INIT;
         sync_seq     <= 1'b0;

         bytes_read   <= '0;
         packet_data  <= '0;
         packet_len_q <= '0;
      end 
      else if (enable == 1'b1) begin
      `ifdef MIPI_4_LANE
         packet_data  <= data;
      `else
         packet_data  <= {data, packet_data[31:16]};
      `endif

         unique case (state)
            // wait one cycle to START
            INIT: state <= START;

            // waiting for first word to start processing it
            START: begin 
               bytes_read <= '0;

               if (data_valid == 1'b1) begin
              `ifdef MIPI_4_LANE
                  state <= SYNC1;
              `else
                  state <= SYNC0;
              `endif 
               end
            end

            SYNC0: begin // sync sequence 0xB8B8
               sync_seq <= 1'b1;
               state    <= SYNC1;
            end

            SYNC1: begin
               sync_seq     <= 1'b0;
               packet_len_q <= packet_len;

               if (long_packet == 1'b0) begin
                  state <= DONE;
               end

               else begin
              `ifdef MIPI_4_LANE
                  state <= LONG_READ; 
              `else
                 // wait one cycle to complete packet header (which is 32 bits)
                  state <= LONG_WAIT; 
              `endif 
               end 
            end

            LONG_WAIT: // Rx long packet
               state <= LONG_READ; // header completed go to read long packet

            LONG_READ: begin// Rx long packet
               // FIXME: adapt to 4-lane case
               if (   (bytes_read < (packet_len_q - 16'd1 * NUM_LANE)) 
                   && (bytes_read < 16'd8192)
               ) begin
                  bytes_read <= bytes_read + 16'd1 * NUM_LANE;
               end
               else begin
                  state <= DONE;
               end
            end   

            // packet done, assert packet_done
            DONE: state <= STOP;

            // wait one cycle and reset
            STOP: state <= START;

            // safety clause
            default: state <= INIT;
         endcase;
      end
   end
   
   
   always_ff @(posedge reset or posedge clock) begin
      if (reset == 1'b1) begin
         in_frame <= 1'b0;
         in_line  <= 1'b0;
      end 
      else if (enable == 1'b1) begin
         if ({is_hdr, valid_packet, packet_type[5:1]} == {2'b11, 5'd0}) begin
            if (packet_type[0] == 1'b0) begin //FS (Frame Start)
               in_frame <= 1'b1;
            end
            else if (packet_type[0] == 1'b1) begin //FE (Frame End)
               in_frame <= 1'b0;
            end
         end

         // Video line detection
         if ({is_hdr, valid_packet, packet_type[5:4]} == {2'b11, 2'd2}) begin
            in_line <= 1'b1;
         end
`ifdef ICARUS 
         // sorry: "inside" expressions not supported yet.
         else if ((state==SYNC0 || state==SYNC1 || state==LONG_WAIT || state==LONG_READ) == 1'b0) begin
`else
         else if ((state inside {SYNC0, SYNC1, LONG_WAIT, LONG_READ}) == 1'b0) begin
`endif //ICARUS
            in_line <= 1'b0;
         end
      end
   end
   
   assign sync_wait     =  (state == START);
   assign payload_out   =  (state == LONG_READ) ? packet_data[(NUM_LANE*8)-1:0] : '0; // FIXME: adapt to 4-lane case
   assign packet_done   =  (state == DONE);
   assign payload_valid =  (state == LONG_READ);
   assign debug_out     = {(state == LONG_READ), long_packet};

endmodule: csi_rx_packet_handler

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/3/10 AnelH: Initial creation
*/

