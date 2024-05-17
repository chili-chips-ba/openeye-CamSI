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
// Description: Simple Byte_Clock Detector for CSI2 Rx
//
//  1) Asserts reset if byte_clock has not toggled for 5 cycles of ref clock
//
//  2) To ensure proper ISERDES behaviour, holds ISERDES in reset 
//      until at least 3 good byte_clock cycles have been detected
//========================================================================

module csi_rx_clk_det (
   input  logic ref_clock,  // ref.clock, MUST NOT BE SYNCHRONISED to ext_clock
   input  logic byte_clock, // external byte clock that's subject to detection

   input  logic reset_in,   // active1 asynchronous reset in
   input  logic enable,     // active1 enable

   output logic reset_out   // active1 reset out to ISERDESs
);

//--------------------------------------------------
// Detection of BYTE_CLOCK:
//  Reset in-between frames, by detecting the loss of byte_clock
//--------------------------------------------------
   logic [1:0] byte_clk_demet; // 2-stage demet
   logic [2:0] byte_clk_cnt;
   logic       byte_clk_fail;

   // this is also a mini-CDC, as 'reset_in' comes from another clock
   logic       reset_in_demet;
   always_ff @(posedge ref_clock) reset_in_demet <= reset_in;


   always_ff @(posedge reset_in_demet or posedge ref_clock) begin
      if (reset_in_demet == 1'b1) begin
         byte_clk_fail <= 1'b1;
      end
      else begin
         byte_clk_fail <= (byte_clk_cnt >= 3'd5);
      end
   end

   always_ff @(posedge ref_clock) begin
      byte_clk_demet <= {byte_clk_demet[0], byte_clock};
      
      // reset counter whenever two consecutive samples are
      //  different, i.e. when whenever byte_clock toggles
      if (^byte_clk_demet == 1'b1) begin
         byte_clk_cnt <= '0;
      end 
      else if (byte_clk_fail == 1'b0) begin
         byte_clk_cnt <= 3'(byte_clk_cnt + 3'd1);
      end
   end


//--------------------------------------------------
// keep ISERDES in reset until 3 good byte_clock cycles are detected
//--------------------------------------------------
   logic [1:0] rst_cnt;

   always_ff @(posedge byte_clk_fail or posedge byte_clock) begin
      if (byte_clk_fail == 1'b1) begin
         rst_cnt <= '0;
      end 
      else if ({enable, reset_out} == 2'b11) begin
         rst_cnt <= 2'(rst_cnt + 2'd1);
      end
   end

   always_ff @(posedge byte_clock) begin
      reset_out <= (rst_cnt < 2'd2);
   end

endmodule: csi_rx_clk_det

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/6  Armin Zunic: Initial creation
*/
