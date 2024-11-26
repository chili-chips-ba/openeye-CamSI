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
// Description: This module provide de-Bayer filter for 12-bit MIPI CSI2 
//  Raw format. For more, see: https://en.wikipedia.org/wiki/Bayer_filter
//
// Note: This implementation uses the GBRG Bayer pattern convention.
//========================================================================

module raw2rgb_12 
  import top_pkg::*;
#(
   parameter LINE_LENGTH = 640, // number of data entries per line
   parameter RGB_WIDTH   = 24   // width of RGB data (24-bit)
)(
   input  logic           clk,  // byte_clock      
   input  logic           rst,
                        
   input  lane_raw_data_t data_in,
   input  logic           data_valid,    
   input  logic           rgb_valid,
                        
   output logic           reading,
   output logic         
      [RGB_WIDTH-1:0]     rgb_out
);

   localparam CNT_WIDTH = $clog2(LINE_LENGTH);
   typedef logic [CNT_WIDTH-1:0] cnt_t;
   
//---------------------------------------------
// Write side
//---------------------------------------------
   cnt_t       write_count;  // count up to LINE_LENGTH
   logic       writing;      // 1 when writing process is active
   logic [1:0] wr_line_sel;  // 4 lines

    always_ff @(posedge clk) begin
       if (rst == 1'b1) begin            
          write_count <= '0;
          writing     <= 1'b0;
          wr_line_sel <= '0;         
       end 
       else if ({data_valid, writing} == 2'b10) begin
          writing <= 1'b1;         
       end 
       else if (writing == 1'b1) begin
          if (write_count < cnt_t'(LINE_LENGTH-1)) begin
             if(data_valid == 1'b1)
               write_count <= cnt_t'(write_count + cnt_t'(1));
          end 
          else begin
             write_count <= '0;   // Reset write_count for the next cycle
             writing     <= 1'b0; // Stop writing
             wr_line_sel <= 2'(wr_line_sel + 2'd1);
          end
       end
    end    
   
   logic [3:0] wen;
   
   // Definition of arrays to store 2 lines of data
   //  1) Vivado 'ram_style' synth attributes: 
   //       block, distributed, registers, ultra, mixed, auto
   //  2) Yosys  'ram_style' synth attributes: 
   //       block, distributed
   (* ram_style = "block" *) lane_raw_data_t line0_mem[LINE_LENGTH:0];
   (* ram_style = "block" *) lane_raw_data_t line1_mem[LINE_LENGTH:0];
   (* ram_style = "block" *) lane_raw_data_t line2_mem[LINE_LENGTH:0];
   (* ram_style = "block" *) lane_raw_data_t line3_mem[LINE_LENGTH:0];

   always_comb begin
      for (int i=0; i<4; i++) begin
         wen[i] = writing & data_valid & (wr_line_sel == 2'(i));
      end
   end
   
   always_ff @(posedge clk) begin
      if (wen[0] == 1'b1) line0_mem[write_count] <= data_in;
      if (wen[1] == 1'b1) line1_mem[write_count] <= data_in;
      if (wen[2] == 1'b1) line2_mem[write_count] <= data_in;
      if (wen[3] == 1'b1) line3_mem[write_count] <= data_in;
   end
   

//---------------------------------------------
// Read side
//---------------------------------------------
   cnt_t       read_count; // count up to LINE_LENGTH-1
   cnt_t       read_count_nxt;
   assign      read_count_nxt = cnt_t'(read_count + cnt_t'(1));
     
   logic       odd_pixel, line_end, temp_4lane;
   logic [1:0] line_not_read;

   always_ff @(posedge clk) begin
      if (rgb_valid == 1'b0) begin
         read_count    <= '0;
         reading       <= 1'b0;
         odd_pixel     <= 1'b0;
         line_not_read <= 2'd3;
         temp_4lane    <= 1'b0;
      end 

      else if ({data_valid, reading} == 2'b10) begin
         reading <= 1'b1;      
      end 

      else if (reading == 1'b1) begin
         if ((odd_pixel == 1'b1) && (read_count == cnt_t'(LINE_LENGTH-1))) begin
            read_count    <= '0;   // Reset read_count for the next cycle
            reading       <= 1'b0; // Stop reading
            odd_pixel     <= 1'b0;
            line_not_read <= 2'(line_not_read + 2'd1);
            temp_4lane    <= 1'b0;
         end 
         else begin
            if (odd_pixel == 1'b1) begin
               temp_4lane <= ~temp_4lane;
            end
           `ifdef MIPI_4_LANE 
            if (temp_4lane == 1'b1 && odd_pixel == 1'b1)
               read_count <= read_count_nxt;
           `else
            if (odd_pixel == 1'b1)
               read_count <= read_count_nxt;
           `endif
            odd_pixel     <= ~odd_pixel;
         end
      end
   end

   logic [11:0] line0_green0, line0_blue0,  line0_green1, line0_blue1;
   logic [11:0] line1_red0,   line1_green0, line1_red1,   line1_green1;
   logic [11:0] line2_green0, line2_blue0,  line2_green1, line2_blue1;
   logic [11:0] line3_red0,   line3_green0, line3_red1,   line3_green1;    

   always_ff @(posedge clk) begin
      `ifdef MIPI_4_LANE
      if (reading == 1'b1) begin
         //                           line                  lane
         if (temp_4lane == 1'b0) begin
            line0_green0 <= line0_mem[read_count][47:36]; //1
            line0_blue0  <= line0_mem[read_count][35:24]; //0
            line0_green1 <= line0_mem[read_count][23:12];
            line0_blue1  <= line0_mem[read_count][11:0];
            
            line1_red0   <= line1_mem[read_count][47:36];
            line1_green0 <= line1_mem[read_count][35:24];
            line1_red1   <= line1_mem[read_count][23:12];
            line1_green1 <= line1_mem[read_count][11:0];
            
            line2_green0 <= line2_mem[read_count][47:36];
            line2_blue0  <= line2_mem[read_count][35:24];
            line2_green1 <= line2_mem[read_count][23:12];
            line2_blue1  <= line2_mem[read_count][11:0];
            
            line3_red0   <= line3_mem[read_count][47:36];
            line3_green0 <= line3_mem[read_count][35:24]; 
            line3_red1   <= line3_mem[read_count][23:12];
            line3_green1 <= line3_mem[read_count][11:0];
         end
         else begin
         //                           line                  lane
            line0_green0 <= line0_mem[read_count]    [23:12]; //1
            line0_blue0  <= line0_mem[read_count]    [11:0];  //0
            line0_green1 <= line0_mem[read_count_nxt][47:36];
            line0_blue1  <= line0_mem[read_count_nxt][35:24];
            
            line1_red0   <= line1_mem[read_count]    [23:12];
            line1_green0 <= line1_mem[read_count]    [11:0];
            line1_red1   <= line1_mem[read_count_nxt][47:36];
            line1_green1 <= line1_mem[read_count_nxt][35:24];
            
            line2_green0 <= line2_mem[read_count]    [23:12];
            line2_blue0  <= line2_mem[read_count]    [11:0];
            line2_green1 <= line2_mem[read_count_nxt][47:36];
            line2_blue1  <= line2_mem[read_count_nxt][35:24];
            
            line3_red0   <= line3_mem[read_count]    [23:12];
            line3_green0 <= line3_mem[read_count]    [11:0];  
            line3_red1   <= line3_mem[read_count_nxt][47:36];
            line3_green1 <= line3_mem[read_count_nxt][35:24];
         end
      end
      `else
      if (reading == 1'b1) begin
         //                           line                  lane
         line0_green0 <= line0_mem[read_count]    [23:12]; //1
         line0_blue0  <= line0_mem[read_count]    [11:0];  //0
         line0_green1 <= line0_mem[read_count_nxt][23:12];
         line0_blue1  <= line0_mem[read_count_nxt][11:0];
         
         line1_red0   <= line1_mem[read_count]    [23:12];
         line1_green0 <= line1_mem[read_count]    [11:0];
         line1_red1   <= line1_mem[read_count_nxt][23:12];
         line1_green1 <= line1_mem[read_count_nxt][11:0];
         
         line2_green0 <= line2_mem[read_count]    [23:12];
         line2_blue0  <= line2_mem[read_count]    [11:0];
         line2_green1 <= line2_mem[read_count_nxt][23:12];
         line2_blue1  <= line2_mem[read_count_nxt][11:0];
         
         line3_red0   <= line3_mem[read_count]    [23:12];
         line3_green0 <= line3_mem[read_count]    [11:0];  
         line3_red1   <= line3_mem[read_count_nxt][23:12];
         line3_green1 <= line3_mem[read_count_nxt][11:0];
      end
     `endif
   end  

   logic [RGB_WIDTH-1:0] rgb_out1;         

   always_ff @(posedge clk) if (reading == 1'b1) begin 

    unique case (line_not_read) 
      2'd3: begin //-----line0/1/2 (first three lines)
         if (odd_pixel == 1'b0) begin
            rgb_out1[23:16] <= (line1_red0   >> 5) + (line1_red1   >> 5);

            rgb_out1[15:8]  <= (line0_green0 >> 6) + (line0_green1 >> 6) 
                             + (line2_green0 >> 6) + (line2_green1 >> 6);

            rgb_out1[7:0]   <= (line0_blue0  >> 5) + (line2_blue0  >> 5);
         end 
         else begin
            rgb_out1[23:16] <=  line1_red1   >> 4;

            rgb_out1[15:8]  <= (line0_green1 >> 6) + (line1_green0 >> 6) 
                             + (line1_green1 >> 6) + (line2_green1 >> 6);

            rgb_out1[7:0]   <= (line0_blue0  >> 6) + (line0_blue1  >> 6)
                             + (line2_blue0  >> 6) + (line2_blue1  >> 6);
         end
      end 

      2'd0: begin //-----line1/2/3
         if (odd_pixel == 1'b0) begin
            rgb_out1[23:16] <= (line1_red0   >> 6) + (line1_red1   >> 6) 
                             + (line3_red0   >> 6) + (line3_red1   >> 6);

            rgb_out1[15:8]  <= (line1_green0 >> 6) + (line2_green0 >> 6)
                             + (line2_green1 >> 6) + (line3_green0 >> 6);

            rgb_out1[7:0]   <=  line2_blue0  >> 4;
         end 
         else begin
            rgb_out1[23:16] <= (line1_red1   >> 5) + (line3_red1   >> 5);

            rgb_out1[15:8]  <= (line1_green0 >> 6) + (line1_green1 >> 6) 
                             + (line3_green0 >> 6) + (line3_green1 >> 6);

            rgb_out1[7:0]   <= (line2_blue0  >> 5) + (line2_blue1  >> 5);
         end
      end 

      2'd1: begin //-----line0/2/3
         if (odd_pixel == 1'b0) begin
            rgb_out1[23:16] <= (line3_red0   >> 5) + (line3_red1   >> 5);

            rgb_out1[15:8]  <= (line2_green0 >> 6) + (line2_green1 >> 6) 
                             + (line0_green0 >> 6) + (line0_green1 >> 6);

            rgb_out1[7:0]   <= (line2_blue0  >> 5) + (line0_blue0  >> 5);
         end 
         else begin
            rgb_out1[23:16] <=  line3_red1   >> 4;

            rgb_out1[15:8]  <= (line2_green1 >> 6) + (line3_green0 >> 6) 
                             + (line3_green1 >> 6) + (line0_green1 >> 6);

            rgb_out1[7:0]   <= (line2_blue0  >> 6) + (line2_blue1  >> 6) 
                             + (line0_blue0  >> 6) + (line0_blue1  >> 6);
         end
      end 

      default: begin // 2'd2 -----line0/1/3
         if (odd_pixel == 1'b0) begin
            rgb_out1[23:16] <= (line3_red0   >> 6) + (line3_red1   >> 6) 
                             + (line1_red0   >> 6) + (line1_red1   >> 6);

            rgb_out1[15:8]  <= (line3_green0 >> 6) + (line0_green0 >> 6) 
                             + (line0_green1 >> 6) + (line1_green0 >> 6);

            rgb_out1[7:0]   <=  line0_blue0  >> 4;
         end 
         else begin
            rgb_out1[23:16] <= (line3_red1   >> 5) + (line1_red1   >> 5);

            rgb_out1[15:8]  <= (line3_green0 >> 6) + (line3_green1 >> 6) 
                             + (line1_green0 >> 6) + (line1_green1 >> 6);

            rgb_out1[7:0]   <= (line0_blue0  >> 5) + (line0_blue1  >> 5);
         end
      end
    endcase // unique case (line_not_read)
   end // if (reading == 1'b1)


 //this pattern of RGB inversions is for CRUVI A
   assign rgb_out = {~rgb_out1[7:0], 
                     rgb_out1[15:8], 
                     ~rgb_out1[23:16]}; 

endmodule: raw2rgb_12 

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/4/14 Armin Zunic: initial creation
*/
