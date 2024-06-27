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
// Description: Calculates ECC of the CSI header
//========================================================================

module csi_rx_hdr_ecc (
   input  logic [23:0] data,
   output logic [7:0]  ecc
);

   always_comb begin
      ecc[7] = 1'b0;
      ecc[6] = 1'b0;

      ecc[5] = data[10] ^ data[11] ^ data[12] ^ data[13] ^ data[14] ^ data[15] 
             ^ data[16] ^ data[17] ^ data[18] ^ data[19] ^ data[21] ^ data[22] 
             ^ data[23];

      ecc[4] = data[4]  ^ data[5]  ^ data[6]  ^ data[7]  ^ data[8]  ^ data[9]  
             ^ data[16] ^ data[17] ^ data[18] ^ data[19] ^ data[20] ^ data[22] 
             ^ data[23];

      ecc[3] = data[1]  ^ data[2]  ^ data[3]  ^ data[7]  ^ data[8]  ^ data[9]  
             ^ data[13] ^ data[14] ^ data[15] ^ data[19] ^ data[20] ^ data[21] 
             ^ data[23];

      ecc[2] = data[0]  ^ data[2]  ^ data[3]  ^ data[5]  ^ data[6]  ^ data[9]  
             ^ data[11] ^ data[12] ^ data[15] ^ data[18] ^ data[20] ^ data[21] 
             ^ data[22];

      ecc[1] = data[0]  ^ data[1]  ^ data[3]  ^ data[4]  ^ data[6]  ^ data[8]  
             ^ data[10] ^ data[12] ^ data[14] ^ data[17] ^ data[20] ^ data[21] 
             ^ data[22] ^ data[23];

      ecc[0] = data[0]  ^ data[1]  ^ data[2]  ^ data[4]  ^ data[5]  ^ data[7]  
             ^ data[10] ^ data[11] ^ data[13] ^ data[16] ^ data[20] ^ data[21] 
             ^ data[22] ^ data[23];
   end
   
endmodule: csi_rx_hdr_ecc

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/27 Armin Zunic: Initial creation
*/


