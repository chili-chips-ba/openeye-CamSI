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
// Description: Clock and reset generator. It generates:
//   - 400kHz strobe
//   - 200MHz IDELAYCTRL reference clock (along with instance of it)
//   - reset sequence for Camera and I2C Master blocks
//========================================================================

module clkrst_gen 
   import top_pkg::*;
(
// external inputs 
   input  logic  reset_ext,
   input  logic  clk_ext,

// internal signals
   output logic  clk_100,
   output logic  clk_200,
   output logic  clk_1hz,
   output logic  strobe_400kHz, // 400kHz strobe synchronous to 'clk'

   output logic  reset,
   output logic  cam_en,
   output logic  i2c_reset
);

   
//--------------------------------
// Clock and reset gen
//--------------------------------
   BUFG u_ibufio (.I(clk_ext), .O(clk_100));

   logic srst0, srst1;
   
   fpga_pll_top u_pll_top (
      .areset   (reset_ext), //i
      .clk_in   (clk_100),   //i 100MHz

      .srst     (srst0),     //o
      .clk_out0 (),          //o: 228MHz 
      .clk_out1 (clk_200)    //o: 200MHz
   );


//--------------------------------
// Reset fanout, for easier timing closure
//--------------------------------
   always_ff @(posedge srst0 or posedge clk_100) begin
      if (srst0 == 1'b1) begin
         reset <= 1'b1;
         srst1 <= 1'b1;
      end
      else begin   
         reset <= 1'b0;
         srst1 <= 1'b0;
      end
   end
   
//--------------------------------
// 400kHz Strobe generator for I2C Master
//--------------------------------
   cnt_400khz_t cnt_400khz;

   always_ff @(posedge srst1 or posedge clk_100) begin
      if (srst1 == 1'b1) begin
         cnt_400khz    <= '0;
         strobe_400kHz <= 1'b0;
      end 
      else begin
         if (cnt_400khz == cnt_400khz_t'(NUM_CLK_FOR_400kHZ-1)) begin
            cnt_400khz    <= '0;
            strobe_400kHz <= 1'b1;
         end 
         else begin
            cnt_400khz    <= cnt_400khz_t'(cnt_400khz + cnt_400khz_t'(1));
            strobe_400kHz <= 1'b0;
         end
      end
   end

   
//--------------------------------
// Generate 1Hz pulse from the 100MHz input clock
//--------------------------------
   cnt_1hz_t    cnt_1hz;
   logic [3:0]  rst_delay_cnt;

   always_ff @(posedge srst1 or posedge clk_100) begin     
      if (srst1 == 1'b1) begin
         cnt_1hz       <= '0;
         clk_1hz       <= 1'b0;   
         rst_delay_cnt <= '0; 

         cam_en        <= 1'b0;
         i2c_reset     <= 1'b0;
      end 
      else if (strobe_400kHz == 1'b1) begin

         // -1, since counter starts at 0
         if (cnt_1hz != cnt_1hz_t'(NUM_CLK_FOR_1HZ-1)) begin
            cnt_1hz <= cnt_1hz_t'(cnt_1hz + cnt_1hz_t'(1));
         end
         else begin
            cnt_1hz <= '0;            
            clk_1hz <= ~clk_1hz;
          
            if (rst_delay_cnt < 4'd8) begin
                rst_delay_cnt <= 4'(rst_delay_cnt + 4'(1));
          
                // Enable CMOS power after 2 secs to give pwr supply
                // ample time to stabilize. In reality, while only a 
                // few msec is needed, it's simpler to use this timer
                cam_en <= (rst_delay_cnt > 4'd1);
          
                // I2C exits reset after 4 secs, 
                //  to then start initializing camera
                i2c_reset <= (rst_delay_cnt > 4'd4);
            end            
         end
      end // if (strobe_400kHz == 1'b1)
   end // always_ff @ (posedge clk_100)


//--------------------------------
// Xilinx-specific IDELAY controller
//--------------------------------
   IDELAYCTRL u_idelayctrl (
      .RDY    (),        //o Not used, thus connected to nothing
      .REFCLK (clk_200), //i Reference clock input
      .RST    (srst0)    //i Reset input
   );
   
endmodule: clkrst_gen

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/5/20 AnelH: Initial creation
*/
