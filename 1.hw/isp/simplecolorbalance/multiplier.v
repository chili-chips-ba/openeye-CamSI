// SPDX-FileCopyrightText: 2025 Silicon Highway Technologies
//
// SPDX-License-Identifier: BSD-3-Clause

//======================================================================== 
// openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
//------------------------------------------------------------------------
//                   Copyright (C) 2025 Silicon Highway Technologies
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
// Description: Multiplier used in the simple color balance algorithm
//========================================================================

module mult(clk, reset, multiplicand, multiplier, result);

  input clk, reset;
  
  // floats are loaded at low end of multiplicand //
  // multiplicand is int[15:8].float[7:0] //

  // result is 16 + 8 = 24 bits, but as integer part cannot be > 8-bits //
  // we are interested in result as int[15:8].float[7:0] //
  
  input [15:0] multiplicand; // x2 larger than multiplier to support floats //
  input [7:0] multiplier;
  output [23:0] result;

  reg [23:0] result;
  
  wire [23:0] msh1 = (multiplier[0] == 1) ? {8'b0, multiplicand[15:0]} : 24'b0;
  wire [23:0] msh2 = (multiplier[1] == 1) ? {7'b0, multiplicand[15:0], 1'b0} : 24'b0;
  
  wire [23:0] msh3 = (multiplier[2] == 1) ? {6'b0, multiplicand[15:0], 2'b0} : 24'b0;   
  wire [23:0] msh4 = (multiplier[3] == 1) ? {5'b0, multiplicand[15:0], 3'b0} : 24'b0;

  wire [23:0] msh5 = (multiplier[4] == 1) ? {4'b0, multiplicand[15:0], 4'b0} : 24'b0;
  wire [23:0] msh6 = (multiplier[5] == 1) ? {3'b0, multiplicand[15:0], 5'b0} : 24'b0;

  wire [23:0] msh7 = (multiplier[6] == 1) ? {2'b0, multiplicand[15:0], 6'b0} : 24'b0;
  wire [23:0] msh8 = (multiplier[7] == 1) ? {1'b0, multiplicand[15:0], 7'b0} : 24'b0;

  // 1st level of additions //
  wire [23:0] r18 = (msh1 + msh8);
  wire [23:0] r27 = (msh2 + msh7);
  wire [23:0] r36 = (msh3 + msh6);
  wire [23:0] r45 = (msh4 + msh5);

  // 2nd level of additions //
  wire [23:0] r18_r45 = (r18 + r45);
  wire [23:0] r27_r36 = (r27 + r36);
  
  // 3rd and final level of additions //
  wire [23:0] result_wire = (r18_r45 + r27_r36) & 24'hFFFFFF;

  always @(posedge clk) begin
  if (reset == 1) begin
      result <= 24'b0;
    end
  else begin
      result <= result_wire;
  end
end
   
endmodule // multiplier
