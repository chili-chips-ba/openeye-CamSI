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
// Description: This module provide de-Bayer filter. 
// For more, see: https://en.wikipedia.org/wiki/Bayer_filter
//
//   FIXME: Adapt logic to 4-lane datapath
//========================================================================

//FIXME: These Verilator Warnings should not be ignored, 
//       but rather fixed in RTL

// verilator lint_off SELRANGE
// verilator lint_off WIDTHTRUNC

module raw2rgb 
  import top_pkg::*;
#(
   parameter LINE_LENGTH = 640, // number of data entries per line
   parameter RGB_WIDTH   = 24   // width of RGB data (24-bit)
)(
   input  logic        clk,     // byte_clock      
   input  logic        rst,
                        
   input  lane_data_t  data_in,
   input  logic        data_valid,    
   input  logic        rgb_valid,
                        
   output logic        reading,
   output logic         
      [RGB_WIDTH-1:0]  rgb_out
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
          if (write_count < cnt_t'(LINE_LENGTH)) begin
             write_count <= cnt_t'(write_count + cnt_t'(1));
          end 
          else if (data_valid == 1'b0)  begin
             write_count <= '0;   // Reset write_count for the next cycle
             writing     <= 1'b0; // Stop writing
             wr_line_sel <= 2'(wr_line_sel + 2'd1);
          end
       end
    end    
   
   logic [3:0] wen;
   assign wen[0] = writing & data_valid & (wr_line_sel == 2'd0);
   assign wen[1] = writing & data_valid & (wr_line_sel == 2'd1);
   assign wen[2] = writing & data_valid & (wr_line_sel == 2'd2);
   assign wen[3] = writing & data_valid & (wr_line_sel == 2'd3);
   
   // Definition of arrays to store 2 lines of data
   (* ram_style = "block" *) lane_data_t line0_buffer[LINE_LENGTH:0];
   (* ram_style = "block" *) lane_data_t line1_buffer[LINE_LENGTH:0];
   (* ram_style = "block" *) lane_data_t line2_buffer[LINE_LENGTH:0];
   (* ram_style = "block" *) lane_data_t line3_buffer[LINE_LENGTH:0];
   
   always_ff @(posedge clk) begin
      if(wen[0] == 1'b1) line0_buffer[write_count] <= data_in;
      if(wen[1] == 1'b1) line1_buffer[write_count] <= data_in;
      if(wen[2] == 1'b1) line2_buffer[write_count] <= data_in;
      if(wen[3] == 1'b1) line3_buffer[write_count] <= data_in;
   end
   

//---------------------------------------------
// Read side
//---------------------------------------------
   cnt_t       read_count; // count up to LINE_LENGTH-1
   logic       odd_pixel, line_end;
   logic [1:0] line_not_read;

   always_ff @(posedge clk) begin
      if (rgb_valid == 1'b0) begin
         read_count    <= '0;
         reading       <= 1'b0;
         odd_pixel     <= 1'b0;
         line_not_read <= 2'd3;
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
         end 
         else begin
            if (odd_pixel == 1'b1) begin
               read_count <= cnt_t'(read_count + cnt_t'(1));
            end
            odd_pixel     <= ~odd_pixel;
         end
      end
   end
   
   logic [7:0] line0_green0, line0_blue0,  line0_green1, line0_blue1;
   logic [7:0] line1_red0,   line1_green0, line1_red1,   line1_green1;
   logic [7:0] line2_green0, line2_blue0,  line2_green1, line2_blue1;
   logic [7:0] line3_red0,   line3_green0, line3_red1,   line3_green1;  

   always_ff @(posedge clk) begin
      if (reading == 1'b1) begin

         line0_green0 <= line0_buffer[read_count][15:8];
         line0_blue0  <= line0_buffer[read_count][7:0];
         line0_green1 <= line0_buffer[read_count + 10'd1][15:8];
         line0_blue1  <= line0_buffer[read_count + 10'd1][7:0];
         
         line1_red0   <= line1_buffer[read_count][15:8];
         line1_green0 <= line1_buffer[read_count][7:0];
         line1_red1   <= line1_buffer[read_count + 10'd1][15:8];
         line1_green1 <= line1_buffer[read_count + 10'd1][7:0];
         
         line2_green0 <= line2_buffer[read_count][15:8];
         line2_blue0  <= line2_buffer[read_count][7:0];
         line2_green1 <= line2_buffer[read_count + 10'd1][15:8];
         line2_blue1  <= line2_buffer[read_count + 10'd1][7:0];
         
         line3_red0   <= line3_buffer[read_count][15:8];
         line3_green0 <= line3_buffer[read_count][7:0];  
         line3_red1   <= line3_buffer[read_count + 10'd1][15:8];
         line3_green1 <= line3_buffer[read_count + 10'd1][7:0];

      end
   end  

   logic [RGB_WIDTH-1:0] rgb_out1;         

   always_ff @(posedge clk) if (reading == 1'b1) begin 

    unique case (line_not_read) 
      2'd3: begin //-----line0/1/2 (first three lines)
         if (odd_pixel == 1'b0) begin
            rgb_out1[23:16] <= (line1_red0   >> 1) + (line1_red1   >> 1);

            rgb_out1[15:8]  <= (line0_green0 >> 2) + (line0_green1 >> 2) 
                             + (line2_green0 >> 2) + (line2_green1 >> 2);

            rgb_out1[7:0]   <= (line0_blue0  >> 1) + (line2_blue0  >> 1);
         end 
         else begin
            rgb_out1[23:16] <=  line1_red1;

            rgb_out1[15:8]  <= (line0_green1 >> 2) + (line1_green0 >> 2) 
                             + (line1_green1 >> 2) + (line2_green1 >> 2);

            rgb_out1[7:0]   <= (line0_blue0  >> 2) + (line0_blue1  >> 2)
                             + (line2_blue0  >> 2) + (line2_blue1  >> 2);
         end
      end 

      2'd0: begin //-----line1/2/3
         if (odd_pixel == 1'b0) begin
            rgb_out1[23:16] <= (line1_red0   >> 2) + (line1_red1   >> 2) 
                             + (line3_red0   >> 2) + (line3_red1   >> 2);

            rgb_out1[15:8]  <= (line1_green0 >> 2) + (line2_green0 >> 2) 
                             + (line2_green1 >> 2) + (line3_green0 >> 2);

            rgb_out1[7:0]   <=  line2_blue0;
         end 
         else begin
            rgb_out1[23:16] <= (line1_red1   >> 1) + (line3_red1   >> 1);

            rgb_out1[15:8]  <= (line1_green0 >> 2) + (line1_green1 >> 2) 
                             + (line3_green0 >> 2) + (line3_green1 >> 2);

            rgb_out1[7:0]   <= (line2_blue0  >> 1) + (line2_blue1  >> 1);
         end
      end 

      2'd1: begin //-----line0/2/3
         if (odd_pixel == 1'b0) begin
            rgb_out1[23:16] <= (line3_red0   >> 1) + (line3_red1   >> 1);

            rgb_out1[15:8]  <= (line2_green0 >> 2) + (line2_green1 >> 2) 
                             + (line0_green0 >> 2) + (line0_green1 >> 2);

            rgb_out1[7:0]   <= (line2_blue0  >> 1) + (line0_blue0  >> 1);
         end 
         else begin
            rgb_out1[23:16] <=  line3_red1;

            rgb_out1[15:8]  <= (line2_green1 >> 2) + (line3_green0 >> 2) 
                             + (line3_green1 >> 2) + (line0_green1 >> 2);

            rgb_out1[7:0]   <= (line2_blue0  >> 2) + (line2_blue1  >> 2) 
                             + (line0_blue0  >> 2) + (line0_blue1  >> 2);
         end
      end 

      default: begin // 2'd2 -----line0/1/3
         if (odd_pixel == 1'b0) begin
            rgb_out1[23:16] <= (line3_red0   >> 2) + (line3_red1   >> 2) 
                             + (line1_red0   >> 2) + (line1_red1   >> 2);

            rgb_out1[15:8]  <= (line3_green0 >> 2) + (line0_green0 >> 2) 
                             + (line0_green1 >> 2) + (line1_green0 >> 2);

            rgb_out1[7:0]   <=  line0_blue0;
         end 
         else begin
            rgb_out1[23:16] <= (line3_red1   >> 1) + (line1_red1   >> 1);

            rgb_out1[15:8]  <= (line3_green0 >> 2) + (line3_green1 >> 2) 
                             + (line1_green0 >> 2) + (line1_green1 >> 2);

            rgb_out1[7:0]   <= (line0_blue0  >> 1) + (line0_blue1  >> 1);
         end
      end
    endcase // unique case (line_not_read)
   end // if (reading == 1'b1)

/*
  // Test pattern
   always_ff @(posedge clk) begin
      if(read_count < 10'd100) begin
         rgb_out1[23:16] <= 8'hFF;  // R 1 Red
         rgb_out1[15:8]  <= 8'h00;  // G 0
         rgb_out1[7:0]   <= 8'h00;  // B 0
      end
      else if(read_count < 10'd200) begin 
         rgb_out1[23:16] <= 8'hFF;  // R 1  Pink
         rgb_out1[15:8]  <= 8'h00;  // G 0
         rgb_out1[7:0]   <= 8'hFF;  // B 1
      end     
      else if(read_count < 10'd250) begin
         rgb_out1[23:16] <= 8'h00;  // R 0 Green
         rgb_out1[15:8]  <= 8'hFF;  // G 1
         rgb_out1[7:0]   <= 8'h00;  // B 0
      end          
      else if(read_count < 10'd300) begin
         rgb_out1[23:16] <= 8'hFF;  // R 1 Yellow
         rgb_out1[15:8]  <= 8'hFF;  // G 1
         rgb_out1[7:0]   <= 8'h00;  // B 0
      end   
      else if(read_count < 10'd400) begin
         rgb_out1[23:16] <= 8'h00;  // R 0  Black
         rgb_out1[15:8]  <= 8'h00;  // G 0
         rgb_out1[7:0]   <= 8'h00;  // B 0
      end         
      else if(read_count < 10'd475) begin
         rgb_out1[23:16] <= 8'hFF;  // R 0 White
         rgb_out1[15:8]  <= 8'hFF;  // G 0
         rgb_out1[7:0]   <= 8'hFF;  // B 0
      end   
      else if(read_count < 10'd575) begin
         rgb_out1[23:16] <= 8'h00;  // R 0 Blue
         rgb_out1[15:8]  <= 8'h00;  // G 0
         rgb_out1[7:0]   <= 8'hFF;  // B 1
      end               
      else begin
         rgb_out1[23:16] <= 8'h00;   // R 0 Cyan
         rgb_out1[15:8]  <= 8'hFF;   // G 1
         rgb_out1[7:0]   <= 8'hFF;   // B 1
      end
   end
*/


 //this pattern of RGB inversions is for CRUVI A
   assign rgb_out = {~rgb_out1[23:16], 
                     ~rgb_out1[15:8], 
                      rgb_out1[7:0]}; 

endmodule: raw2rgb

// verilator lint_on SELRANGE
// verilator lint_on WIDTHTRUNC

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/4/14 Armin Zunic: initial creation
*/