// SPDX-FileCopyrightText: 2024 Silicon Highway Technologies
//
// SPDX-License-Identifier: BSD-3-Clause

//======================================================================== 
// openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
//------------------------------------------------------------------------
//                   Copyright (C) 2024 Silicon Highway Technologies
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
// Description: The top-level module of the simple color balance algorithm,
// as well as some utility modules for the simple color balance algorithm
//========================================================================

module minmaxpixelvalue(clk, reset, en, resetbounds, pixelv, maxvalue, minvalue);

  input clk, reset, en, resetbounds;
  input [7:0] pixelv;
  output [7:0] maxvalue;
  output [7:0] minvalue;

  reg [7:0] maxvalue;
  reg [7:0] minvalue;

  always @(posedge clk) begin

    if (reset == 1) begin
        // init max, min bounds //
        maxvalue <= 8'b0;
        minvalue <= 8'b1111_1111;
      end

    else begin
      if (en == 1) begin
        if (pixelv > maxvalue)
          maxvalue <= pixelv;
        if (pixelv < minvalue)
          minvalue <= pixelv;
      end

      else if (en == 0) begin
        if (resetbounds == 1) begin
          // reset max, min bounds //
          maxvalue <= 8'b0;
          minvalue <= 8'b1111_1111;
        end
      end
	  end
  end

endmodule // maxpixelvalue

module frameedgedetector(clk, reset, framevalid, endofframe);

  input clk, reset, framevalid;
  output endofframe;

  reg prevframevalid;
  reg endofframe;
  
  wire negedgeframevalid = prevframevalid & ~framevalid;
      
  always @(posedge clk) begin
    if (reset == 1)
      endofframe <= 0;

    else begin
      if (negedgeframevalid == 1) begin
        endofframe <= 1;
      end
      else if (framevalid == 1) begin
        // reset when signal is sampled high //
        endofframe <= 0;
      end

      // store framevalid //
      prevframevalid <= framevalid;
    end
  end
   
endmodule; // frameedgedetector

module simplecolorbalance(clk, reset, red_data_in, green_data_in, blue_data_in, line_valid_in, frame_valid_in, line_valid_out, frame_valid_out, red_data_out, green_data_out, blue_data_out);

  input clk, reset;
  input [7:0] red_data_in;
  input [7:0] green_data_in;
  input [7:0] blue_data_in;

  input line_valid_in;
  input frame_valid_in;

  output line_valid_out; // these are delayed by 1 clock cycle to match multiplier 1 cycle //
  output frame_valid_out; // FF output delay, see red, green, blue mult instances at bottom //

  reg line_valid_out;
  reg frame_valid_out;

  output [7:0] red_data_out;
  output [7:0] green_data_out;
  output [7:0] blue_data_out;
  
  wire datavalid = line_valid_in & frame_valid_in;

  wire endofframe;
  
  // generate start, at end of frame //
  reg start, startupdated;

  // ratio division signals //
  wire donered, donegreen, doneblue;

  // min, max values signals //
  wire [7:0] redmaxvalue, redminvalue;
  wire [7:0] greenmaxvalue, greenminvalue;
  wire [7:0] bluemaxvalue, blueminvalue;

  wire resetboundsred, resetboundsgreen, resetboundsblue;
  
  // resetbounds are reset directly from the respective done signal //
  // NOTE: done signals last only for 1 cycle, see divider module description in maxminuxminratio.v //
  assign resetboundsred = donered;
  assign resetboundsgreen = donegreen;
  assign resetboundsblue = doneblue;

  // min, max values, computed when datavalid is set //
  minmaxpixelvalue redminmax (.clk(clk), .reset(reset), .en(datavalid), .resetbounds(resetboundsred), .pixelv(red_data_in), .maxvalue(redmaxvalue), .minvalue(redminvalue));
  
  minmaxpixelvalue greenminmax (.clk(clk), .reset(reset), .en(datavalid), .resetbounds(resetboundsgreen), .pixelv(green_data_in), .maxvalue(greenmaxvalue), .minvalue(greenminvalue));
  
  minmaxpixelvalue blueminmax (.clk(clk), .reset(reset), .en(datavalid), .resetbounds(resetboundsblue), .pixelv(blue_data_in), .maxvalue(bluemaxvalue), .minvalue(blueminvalue));
    
  // frame detector //
  frameedgedetector frameenddetectorinst (.clk(clk), .reset(reset), .framevalid(frame_valid_in), .endofframe(endofframe));

  // start signal generation for dividers, essentially a simple FSM, dividers reply with out, i.e. done signals //
  // NOTE: start signal also stores frame min, max values, whereas done signal from dividers resets min, max bounds for minmaxpixelvalue modules //
  always @(posedge clk) begin
    if (reset == 1) begin
      start <= 0;
      startupdated <= 0; // used to perform 1 start pulse //
    end

    else if (endofframe == 1) begin
      if ((start == 0) && (startupdated == 0)) begin
        start <= 1;
        startupdated <= 1;
      end 
      else if ((start == 1) && (startupdated == 1)) begin
        start <= 0;
      end
    end

    else if (endofframe == 0) begin
        start <= 0;
        startupdated <= 0;
    end
  end

  // ratio values //
  wire [15:0] redstoredratiovalue, greenstoredratiovalue, bluestoredratiovalue;

  wire allfractionsdone = donered & donegreen & doneblue;
    
  // (max - min) ratio, i.e. 255/(max - min) dividers per colour //
  
  maxminusminratio redmmmratio (.clk(clk), .reset(reset), .start(start), .done(donered), .minvalue(redminvalue), .maxvalue(redmaxvalue), .storedratiovalue(redstoredratiovalue), .storedremaindervalue());
  
  maxminusminratio greenmmmratio (.clk(clk), .reset(reset), .start(start), .done(donegreen), .minvalue(greenminvalue), .maxvalue(greenmaxvalue), .storedratiovalue(greenstoredratiovalue), .storedremaindervalue());

  maxminusminratio bluemmmratio (.clk(clk), .reset(reset), .start(start), .done(doneblue), .minvalue(blueminvalue), .maxvalue(bluemaxvalue), .storedratiovalue(bluestoredratiovalue), .storedremaindervalue());

  // in to out filter multipliers //

  // if ratio is 0, convert to 1.0 in int[15:8].float[7:0] representation //
  wire [15:0] redratiovalue = (redstoredratiovalue == 16'b0) ? 16'b0000_0001_0000_0000 : redstoredratiovalue;
  wire [15:0] greenratiovalue = (greenstoredratiovalue == 16'b0) ? 16'b0000_0001_0000_0000 : greenstoredratiovalue;
  wire [15:0] blueratiovalue = (bluestoredratiovalue == 16'b0) ? 16'b0000_0001_0000_0000 : bluestoredratiovalue;

  wire [23:0] red24bit_data_out, green24bit_data_out, blue24bit_data_out;

  // (i - min) distances, i is current frame pixel value //
  wire [7:0] redpixelmindist, greenpixelmindist, bluepixelmindist;
  wire redpixelmindistoverflow, greenpixelmindistoverflow, bluepixelmindistoverflow;

  // registered versions of (i - min) distances, i.e. with 1 cycle delay //
  reg redpixelmindistoverflow_cycledelay, greenpixelmindistoverflow_cycledelay, bluepixelmindistoverflow_cycledelay;

  // (max - i) distances, i is current frame pixel value //
  wire [7:0] redpixelmaxdist, greenpixelmaxdist, bluepixelmaxdist;
  wire redpixelmaxdistoverflow, greenpixelmaxdistoverflow, bluepixelmaxdistoverflow;

  // registered versions of (max - i) distances, i.e. with 1 cycle delay //
  reg redpixelmaxdistoverflow_cycledelay, greenpixelmaxdistoverflow_cycledelay, bluepixelmaxdistoverflow_cycledelay;
  
  // reference values for entire frame, used to correct next frame //
  reg [7:0] frameredminvalue, framegreenminvalue, frameblueminvalue;
  reg [7:0] frameredmaxvalue, framegreenmaxvalue, framebluemaxvalue;

  // red, green, blue min values per frame, used to compute (i - min) //
  always @(posedge clk) begin
    if (reset == 1) begin
          // min, max values reset to 0 //
          frameredminvalue <= 8'b0; frameredmaxvalue <= 8'b1111_1111;
          framegreenminvalue <= 8'b0; framegreenmaxvalue <= 8'b1111_1111;
          frameblueminvalue <= 8'b0; framebluemaxvalue <= 8'b1111_1111;
      end
      else if (start == 1) begin
            // store frame wide min, max values //
            frameredminvalue <= redminvalue; frameredmaxvalue <= redmaxvalue;
            framegreenminvalue <= greenminvalue; framegreenmaxvalue <= greenmaxvalue; 
            frameblueminvalue <= blueminvalue; framebluemaxvalue <= bluemaxvalue; 
        end
    end

  // compute (max - i) //
  subtractor_8 redsubpixelmaxdist (.a(frameredmaxvalue), .b(red_data_in), .overflow(redpixelmaxdistoverflow), .result(redpixelmaxdist));
  subtractor_8 greensubpixelmaxdist (.a(framegreenmaxvalue), .b(green_data_in), .overflow(greenpixelmaxdistoverflow), .result(greenpixelmaxdist));
  subtractor_8 bluesubpixelmaxdist (.a(framebluemaxvalue), .b(blue_data_in), .overflow(bluepixelmaxdistoverflow), .result(bluepixelmaxdist));
    
  // compute (i - min) //
  subtractor_8 redsubpixelmindist (.a(red_data_in), .b(frameredminvalue), .overflow(redpixelmindistoverflow), .result(redpixelmindist));
  subtractor_8 greensubpixelmindist (.a(green_data_in), .b(framegreenminvalue), .overflow(greenpixelmindistoverflow), .result(greenpixelmindist));
  subtractor_8 bluesubpixelmindist (.a(blue_data_in), .b(frameblueminvalue), .overflow(bluepixelmindistoverflow), .result(bluepixelmindist));

  // NOTE: multiplicand is in form int[15:8].float[7:0], i.e. 16-bit, //
  // multiplier is 8-bit, and combinatorial output result is 24-bit.  //
  // NOTE: all *24bit_data_out signals below are registered at FFs and have 1 cycle delay //
  mult redmult (.clk(clk), .reset(reset), .multiplicand(redratiovalue), .multiplier(redpixelmindist), .result(red24bit_data_out));
  mult greenmult (.clk(clk), .reset(reset), .multiplicand(greenratiovalue), .multiplier(greenpixelmindist), .result(green24bit_data_out));
  mult bluemult (.clk(clk), .reset(reset), .multiplicand(blueratiovalue), .multiplier(bluepixelmindist), .result(blue24bit_data_out));

  // multiplier registered overflow signals, which need 1 cycle delay to align with the *24bit_data_out signals //
  always @(posedge clk) begin
    if (reset == 1) begin
      redpixelmaxdistoverflow_cycledelay <= 1'b0;
      greenpixelmaxdistoverflow_cycledelay <= 1'b0;
      bluepixelmaxdistoverflow_cycledelay <= 1'b0;

      redpixelmindistoverflow_cycledelay <= 1'b0;
      greenpixelmindistoverflow_cycledelay <= 1'b0;
      bluepixelmindistoverflow_cycledelay <= 1'b0;
      end
    else begin
      redpixelmaxdistoverflow_cycledelay <= redpixelmaxdistoverflow;
      greenpixelmaxdistoverflow_cycledelay <= greenpixelmaxdistoverflow;
      bluepixelmaxdistoverflow_cycledelay <= bluepixelmaxdistoverflow;

      redpixelmindistoverflow_cycledelay <= redpixelmindistoverflow;
      greenpixelmindistoverflow_cycledelay <= greenpixelmindistoverflow;
      bluepixelmindistoverflow_cycledelay <= bluepixelmindistoverflow;
      end
  end
  
  // NOTE: two corner cases exist for output data //
  // 1. pixelmindist < 0, when (current frame pixel < min pixel of previous frame) => out = minimum value = 0 //
  // 2. if (current frame pixel in > max pixel of previous frame) => out = maximum value = 255 //
  // ----------------------------------------------------------------------------------------- //
  // the reason for the above is if e.g. input range is [10, 150] at frame i, as these values  //
  // are scaled to [0, ~255], any values outside this range, from above or below, at the next  //
  // frame, (i + 1) we get 160 > 150, 5 < 10, these must be reset to max and min respectively. //

  // NOTE: as *24bit_data_out signals are from FF outputs, all RGB data out signals have 1 cycle delay //
  // thus, the overflow signal related to the *24bit_data_out the registered *overflow_cycledelay! //
  
  // [23:16] byte discaded too large integer part, [15:8] sent to output, [7:0] discarded, floating point part //

  assign red_data_out[7:0] = (redpixelmindistoverflow_cycledelay== 1'b1) ? 8'b0 : ((redpixelmaxdistoverflow_cycledelay == 1'b1) ? 8'b1111_1111 : red24bit_data_out[15:8]);
  assign green_data_out[7:0] = (greenpixelmindistoverflow_cycledelay == 1'b1) ? 8'b0 : ((greenpixelmaxdistoverflow_cycledelay == 1'b1) ? 8'b1111_1111 : green24bit_data_out[15:8]);
  assign blue_data_out[7:0] = (bluepixelmindistoverflow_cycledelay == 1'b1) ? 8'b0 : ((bluepixelmaxdistoverflow_cycledelay == 1'b1) ? 8'b1111_1111 : blue24bit_data_out[15:8]);

  // no corner case handling, output RGB fed from multiplier mid byte, [15:8] //
  //   assign red_data_out[7:0] = red24bit_data_out[15:8];
  //   assign green_data_out[7:0] = green24bit_data_out[15:8];
  //   assign blue_data_out[7:0] = blue24bit_data_out[15:8];

  // line_valid_out, frame_valid_out are 1 cycle delayed versions of their in versions to //
  // align red, green, blue pixel out with the former, due to 1 cycle mults delay above //

  always @(posedge clk) begin
    if (reset == 1) begin
      line_valid_out <= 0;
      frame_valid_out <= 0;
      end
    else begin
      line_valid_out <= line_valid_in;
      frame_valid_out <= frame_valid_in;
    end
  end
   
endmodule; // simplecolorbalance
