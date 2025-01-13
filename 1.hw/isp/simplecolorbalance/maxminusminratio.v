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
// Description: Utility modules for the simple color balance algorithm
//========================================================================

module subtractor_8(a, b, overflow, result);

  parameter N = 8; // bit width //

  input [N-1:0] a;
  input [N-1:0] b;
  output overflow;

  output [N-1:0] result;

  reg [N:0] temp;

  always @(a or b) begin
    temp = a + (-{1'b0, b});
  end

  assign result = temp[N-1:0];
  assign overflow = temp[N];  
   
endmodule // subtractor

module subtractor(a, b, result);

  parameter N = 16; // bit width //

  input [N-1:0] a;
  input [N-1:0] b;
  output [N-1:0] result;
  
  reg [N-1:0] result;
  
  always @(a or b) begin
    result = a + (-b);
  end
   
endmodule // subtractor

// compute divident/divisor in quotient and remainder //
module divider(clk, reset, start, divident, divisor, quotient, remainder, out);

  parameter N = 16; // bit width //

  input clk, reset, start;
  output out;
  input [N-1:0] divident;
  input [N-1:0] divisor;
  output [N-1:0] quotient;
  output [N-1:0] remainder;

  reg out;

  reg [4:0] count; // state counter, (N + 1) is a valid value //

  reg [N-1:0] dsoreg; // divisor register //

  reg [N-1:0] qreg; // quotient register //

  wire [N-1:0] subresult; // subtractor result,  check if < 0 or > 0 //

  reg [2*N-1:0] divdremlreg; // divident/remainder register - double width //
  
  subtractor divider_subtractor(.a(divdremlreg[2*N-1:N]), .b(dsoreg), .result(subresult));

  reg divideractive; // divider active signal //
  
  assign quotient = qreg;
  assign remainder = divdremlreg[2*N-1:N];

  // (n + 1) cycles divider //
  
  always @(posedge clk)begin
    out <= 1'b0;

    if (reset == 1) begin // initialise when reset is high // 
      dsoreg <= divisor;

      divdremlreg[2*N-1:N] <= 0; // higher part //
      divdremlreg[N-1:0] <= divident; // lower part //
        
      qreg <= 16'b0;
      count <= 5'b0;
      divideractive <= 0; // reset to 1 //
    end

    else if (start == 1) begin// re-initialise when start is high //
      dsoreg <= divisor;

      divdremlreg[2*N-1:N] <= 0; // higher part //
      divdremlreg[N-1:0] <= divident; // lower part //
      
      qreg <= 16'b0;
      count <= 5'b0;
      divideractive <= 1; // reset to 1 //
      end

    else begin
      if (divideractive == 1) begin

        if (count < N) begin 
            // #1 (divident - remainder) check //
            if (subresult[N-1] == 1'b1) begin // negative //
              qreg[N-1:0] <= {qreg[N-2:0], 1'b0}; // shift in 0 in quotient from left //
    
              // #2 shift divdremlreg to left //
              divdremlreg[2*N-1:0] <= {divdremlreg[2*N-2:0], 1'b0};
              end
              
            else if (subresult[N-1] == 1'b0) begin // positive //
              qreg[N-1:0] <= {qreg[N-2:0], 1'b1}; // shift in 1 in quotient from left //
          
              // store subtraction result at high part of divident/remainder register //
              // and #2 shift divdremlreg to left //
              divdremlreg[2*N-1:0] <= {subresult[N-2:0], divdremlreg[N-1:0], 1'b0};
              end
          end   

        else if (count == N) begin// last bit; DONT SHIFT //

            if (subresult[N-1] == 1'b1) begin // negative //
              qreg[N-1:0] <= {qreg[N-2:0], 1'b0}; // shift in 0 in quotient from left //
            end

            else if (subresult[N-1] == 1'b0) begin // positive //
              qreg[N-1:0] <= {qreg[N-2:0], 1'b1}; // shift in 1 in quotient from left //
          
              // store subtraction result at high part of divident/remainder register //
              // no shift for last cycle, to reset remainder //
              divdremlreg[2*N-1:0] <= {subresult[N-1:0], divdremlreg[N-1:0]};
            end

          end

        else begin
          out <= 1'b1; // result is ready //
          divideractive <= 0; // reset divider active signal //
        end

        count <= count + 1'b1; // state count //

      end // if (divideractive == 1)
    end
  end
   
endmodule

// uses divider, i.e. needs (N + 1) cycles to compute 255/(max - min) //
// NOTE: ratiovalue will always be > 0 //
module maxminusminratio(clk, reset, start, done, minvalue, maxvalue, storedratiovalue, storedremaindervalue);

  input clk, reset;
  input start;
  
  input [7:0] minvalue;
  input [7:0] maxvalue;

  output done;
  output [15:0] storedratiovalue;
  output [15:0] storedremaindervalue;

  wire [7:0] denominator;
  wire [15:0] ratioremainder;
  wire [15:0] ratiovalue;
  
  reg [15:0] storedratiovalue; // int[15:8].float[7:0] //
  reg [15:0] storedremaindervalue; // int[15:8].float[7:0] //

  subtractor_8 ratiosubtractor(.a(maxvalue), .b(minvalue), .overflow(), .result(denominator));
  
  // compute 255/(max - min) //
  divider ratiodivider(.clk(clk), .reset(reset), .start(start), .divident({8'b1111_1111, 8'b0}), .divisor({8'b0, denominator}), .quotient(ratiovalue), .remainder(ratioremainder), .out(done));

  always @(posedge clk) begin
    if (reset == 1) begin
      storedratiovalue <= 16'b0;
      storedremaindervalue <= 16'b0;
    end
	  else begin
      if (done == 1) begin
        storedratiovalue <= ratiovalue;
        storedremaindervalue <= ratioremainder;
      end
	  end
  end
   
endmodule // maxminusminratio
