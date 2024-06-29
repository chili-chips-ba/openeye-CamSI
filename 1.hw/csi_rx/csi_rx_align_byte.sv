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
// Description: This modules receives raw, unaligned bytes (which could 
//  contain fragments of two bytes) from the SERDES and aligns them by 
//  looking for the standard D-PHY SYNC pattern.
//
//  When 'wait_for_sync=1', it will wait until it sees the valid header
//  at some alignment, at which point the found alignment is locked 
//  until 'packet_done=1' arrives.
//
//  'valid_data' is asserted as soon as the SYNC pattern is found. 
//  The next byte therefore contains the CSI packet header.
//
//  In reality, to avoid false triggers we must look for a valid SYNC 
//  pattern on all used lanes. If this does not occur, the word aligner 
//  (which is a seperate block), will assert 'packet_done' immediately.
//========================================================================

module csi_rx_align_byte (
   input  logic       clock,         // byte clock in
   input  logic       reset,         // synchronous, active-1 reset

   input  logic       enable,        // active-1 enable
   input  logic [7:0] deser_in,      // raw data from ISERDES
   input  logic       wait_for_sync, // when 1, if sync not already found, look for it
   input  logic       packet_done,   // drive 1 to reset synchronisation status

   output logic [7:0] data_out,      // aligned data out, typically delayed by 2 cycles
   output logic       data_vld       // goes 1 as soon as sync pattern is found 
);                                   //  so data_out on next cycle contains header

//--------------------------------
   logic [7:0]  curr_byte;
   logic [7:0]  last_byte;
   logic [7:0]  shifted_byte;   
   
   logic        found;
   logic [2:0]  offset;
   logic [2:0]  data_offs;
         
   always_ff @(posedge clock) begin: _ff
      if (enable == 1'b1) begin
         curr_byte <= deser_in;
         last_byte <= curr_byte;
         data_out  <= shifted_byte;
      end

      if (reset == 1'b1) begin
         data_vld  <= 1'b0;
         data_offs <= '0;
      end 
      else if (enable == 1'b1) begin
         if (packet_done == 1'b1) begin
            data_vld  <= found;
         end 
         else if ({wait_for_sync, found, data_vld} == 3'b110) begin
            data_vld  <= 1'b1;
            data_offs <= offset;
         end
      end
   end: _ff

   
//--------------------------------
/*
   function logic is_zero (
      input logic [15:0] value,
      input int          msb
   );
      is_zero = 1'b1;
  
      if(msb < 7) begin
         for (int i = 0; i < msb; i++) begin
            if (value[i] == 1'b1) is_zero = 1'b0;
         end
      end
   endfunction: is_zero
*/
  
//--------------------------------
   localparam bit[7:0] SYNC = 8'b1011_1000;

   always_comb begin: _comb

   //---find SYNC pattern and its bit-offset
      found  = 1'b0;
      offset = 3'd0;

   //for (int i = 8; i < 16; i++) begin
   //  if((curr_byte[i -:8] == SYNC) && is_zero(curr_byte, i-8)) begin
   //      found  = 1'b1;
   //      offset = i-8;
   //   end
   //end

      if ({curr_byte[0],   last_byte} == {SYNC, 1'd0}) begin
         found  = 1'b1;
         offset = 3'd0;
      end
      if ({curr_byte[1:0], last_byte} == {SYNC, 2'd0}) begin
         found  = 1'b1;
         offset = 3'd1;
      end 
      if ({curr_byte[2:0], last_byte} == {SYNC, 3'd0}) begin
         found  = 1'b1;
         offset = 3'd2;
      end 
      if ({curr_byte[3:0], last_byte} == {SYNC, 4'd0}) begin
         found  = 1'b1;
         offset = 3'd3;
      end      
      if ({curr_byte[4:0], last_byte} == {SYNC, 5'd0}) begin
         found  = 1'b1;
         offset = 3'd4;
      end
      if ({curr_byte[5:0], last_byte} == {SYNC, 6'd0}) begin
         found  = 1'b1;
         offset = 3'd5;
      end   
      if ({curr_byte[6:0], last_byte} == {SYNC, 7'd0}) begin
         found  = 1'b1;
         offset = 3'd6;
      end                            
      if (curr_byte[7:0] == SYNC) begin
         found  = 1'b1;
         offset = 3'd7;
      end

   //---then barrel-shift input data to align output
      unique case (data_offs)
         3'd7   : shifted_byte =  curr_byte;
         3'd6   : shifted_byte = {curr_byte[6:0], last_byte[7]};
         3'd5   : shifted_byte = {curr_byte[5:0], last_byte[7:6]};
         3'd4   : shifted_byte = {curr_byte[4:0], last_byte[7:5]};
         3'd3   : shifted_byte = {curr_byte[3:0], last_byte[7:4]};
         3'd2   : shifted_byte = {curr_byte[2:0], last_byte[7:3]};
         3'd1   : shifted_byte = {curr_byte[1:0], last_byte[7:2]}; 
         default: shifted_byte = {curr_byte[0],   last_byte[7:1]};
      endcase

   end: _comb
   
endmodule: csi_rx_align_byte

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/14  Armin Zunic: Initial creation
*/
