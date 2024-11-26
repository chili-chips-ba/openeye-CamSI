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
// Description: This module implements the unpacking of 12-bit MIPI CSI2 
// packed data. The logic converts the packed 12-bit data into 4 sequential 
// 12-bit pixels for further processing.
// 
// Features:
//   - Accepts 32-bit packed data input from the packet handler
//   - Outputs unpacked 12-bit pixel data
//   - Includes logic for valid data signaling
//   - Implements a 12-bit unpacking function
//========================================================================

module csi_rx_12bit_unpack 
   import top_pkg::*;
(
   input  logic        clock,      // byte clock in
   input  logic        reset,      // active-1 synchronous reset
   input  logic        enable,     // active-1 enable

   input  logic [31:0] data_in,    // packet payload in from packet handler
   input  logic        din_valid,  // payload in valid from packet handler

   output lane_raw_data_t data_out,   // unpacked data out
   output logic        dout_valid  // data out valid (see above)
);

   logic [47:0] dout_int;
   logic [47:0] dout_unpacked;

   logic [31:0] bytes_int;
   logic [1:0]  byte_count_int;

   logic dout_valid_int;
   logic dout_valid_up;

   // Unpack CSI packed 10-bit to 4 sequential 10-bit pixels
   function logic [47:0] mipi12_unpack(input logic [47:0] packed_data);
      logic [47:0] result;
      result[11:0]  = {packed_data[7:0],   packed_data[19:16]};
      result[23:12] = {packed_data[15:8],  packed_data[23:20]};
      result[35:24] = {packed_data[31:24], packed_data[43:40]};
      result[47:36] = {packed_data[39:32], packed_data[47:44]};
      return result;
   endfunction

   always_ff @(posedge clock or posedge reset) begin
      if (reset == 1'b1) begin
         dout_int       <= '0;
         byte_count_int <= '0;
         dout_valid_int <= 1'b0;
      end else if (enable == 1'b1) begin
         if (din_valid == 1'b1) begin
               case (byte_count_int)
                  0: begin
                     dout_int       <= '0;
                     byte_count_int <= 3'd2;
                     dout_valid_int <= 1'b0;
                     bytes_int      <= data_in;
                  end
                  1: begin
                     dout_int       <= {data_in[31:0], bytes_int[15:0]};
                     byte_count_int <= 3'd0;
                     dout_valid_int <= 1'b1;
                     bytes_int      <= '0;
                  end
                  2: begin
                     dout_int       <= {data_in[15:0], bytes_int[31:0]};
                     byte_count_int <= 3'd1;
                     dout_valid_int <= 1'b1;
                     bytes_int      <= {16'd0, data_in[31:16]};
                  end
               endcase
         end else begin
               byte_count_int <= '0;
               dout_valid_int <= 1'b0;
         end
         dout_unpacked <= mipi12_unpack(dout_int);  // Use 12-bit unpacking function
         dout_valid_up <= dout_valid_int;
         data_out      <= dout_unpacked;
         dout_valid    <= dout_valid_up;
      end
   end
endmodule
