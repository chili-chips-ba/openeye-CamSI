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
// Description: HDMI TDMS Encoder 
// 8 bits colour, 2 control bits and one blanking bits in the 10 bits
// of TDMS-encoded data out. Runs with the pixel clock
//
// Xilinx Artix7 (XC7A100T-CSG324) on Trenz Adapter board (TEB0707-2) with
// 100MHz external clock
//========================================================================

module hdmi_tdms_enc 
   import top_pkg::*;
   import hdmi_pkg::*;
(
   input  logic   clk,
   input  logic   blank,
   input  tdms_t  raw,
                   
   output tdms_t  encoded
);

   bus9_t   xored;
   bus9_t   xnord;
            
   bus4_t   num_ones;

   bus9_t   data;
   bus9_t   data_n;

   bus4_t   data_disparity;

   bus4_t   dc_bias;
   bus4_t   dc_bias_plus;
   bus4_t   dc_bias_minus;

//-----------------------------------------------------
   always_comb begin: _comb
       
   // work out two different encodings for the byte
       xored[0] = raw.d[0];
       xnord[0] = raw.d[0];
`ifdef ICARUS
            xored[1] =   raw.d[1] ^ xored[0];
            xnord[1] = ~(raw.d[1] ^ xnord[0]);
            xored[2] =   raw.d[2] ^ xored[1];
            xnord[2] = ~(raw.d[2] ^ xnord[1]);
            xored[3] =   raw.d[3] ^ xored[2];
            xnord[3] = ~(raw.d[3] ^ xnord[2]);
            xored[4] =   raw.d[4] ^ xored[3];
            xnord[4] = ~(raw.d[4] ^ xnord[3]);
            xored[5] =   raw.d[5] ^ xored[4];
            xnord[5] = ~(raw.d[5] ^ xnord[4]);
            xored[6] =   raw.d[6] ^ xored[5];
            xnord[6] = ~(raw.d[6] ^ xnord[5]);
            xored[7] =   raw.d[7] ^ xored[6];
            xnord[7] = ~(raw.d[7] ^ xnord[6]);
`else
       // verilator lint_off ALWCOMBORDER
       for (int i=1; i<8; i++) begin
           xored[i] =   raw.d[i] ^ xored[i-1];
           xnord[i] = ~(raw.d[i] ^ xnord[i-1]);
       end
       // verilator lint_on ALWCOMBORDER
`endif //ICARUS
       xored[8] = HI;
       xnord[8] = LO;
     
   // count how many ones are set in data
       num_ones = 4'd0;
`ifdef ICARUS
            num_ones = num_ones + {3'd0, raw.d[0]};
            num_ones = num_ones + {3'd0, raw.d[1]};
            num_ones = num_ones + {3'd0, raw.d[2]};
            num_ones = num_ones + {3'd0, raw.d[3]};
            num_ones = num_ones + {3'd0, raw.d[4]};
            num_ones = num_ones + {3'd0, raw.d[5]};
            num_ones = num_ones + {3'd0, raw.d[6]};
            num_ones = num_ones + {3'd0, raw.d[7]};
`else
       for (int i=0; i<8; i++) begin
           num_ones = num_ones + {3'd0, raw.d[i]};
       end     
`endif //ICARUS

   // decide which encoding to use
       if (
            ( num_ones > 4'd4) 
         || ({num_ones, raw.d[0]} == {4'd4, LO})
       ) begin
           data   =  xnord;
           data_n = ~xnord;
       end
       else begin
           data   =  xored;
           data_n = ~xored;
       end

   // Work out the DC bias of the dataword
       data_disparity = 4'd12;
       for (int i=0; i<8; i++) begin
           data_disparity = data_disparity + {3'd0, data[i]};
       end

   // Common/reused math
       dc_bias_plus  = bus4_t'(dc_bias + data_disparity);
       dc_bias_minus = bus4_t'(dc_bias - data_disparity);

   end: _comb
          
 
//-----------------------------------------------------
// work out what the final output should be
//-----------------------------------------------------
   always_ff @(posedge clk) begin: _flop
      if (blank == HI) begin 
          dc_bias <= '0;

          //in the control periods, all values have balanced bit count
          unique case (raw.c)
              2'd0   : encoded <= 10'b11_0101_0100;
              2'd1   : encoded <= 10'b00_1010_1011;
              2'd2   : encoded <= 10'b01_0101_0100;
              default: encoded <= 10'b10_1010_1011;
          endcase
      end
      else begin
          // dataword has no disparity
          if ((dc_bias == '0) || (data_disparity == '0)) begin
              if (data[8] == HI) begin
                  dc_bias <= dc_bias_plus;
                  encoded <= {2'b01, data[7:0]};
              end
              else begin
                  dc_bias <= dc_bias_minus;
                  encoded <= {2'b10, data_n[7:0]};
              end
          end

          // dataword has disparity
          else if (
              ({dc_bias[3], data_disparity[3]} == 2'b00)
           || ({dc_bias[3], data_disparity[3]} == 2'b11) 
          ) begin
              encoded <= {HI, data[8], data_n[7:0]};
              dc_bias <= bus4_t'(dc_bias_minus + {3'd0, data[8]});
          end

          else begin
              encoded <= {LO, data};
              dc_bias <= bus4_t'(dc_bias_plus - {3'd0, data_n[8]});
          end
      end // else: !if(blank == HI)
   end: _flop

endmodule: hdmi_tdms_enc

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/1/4  Isam Vrce: Initial creation 
 2024/1/8  Armin Zunic: Timing improvements
 2024/1/10 Isam Vrce: More timing tuning 
*/
