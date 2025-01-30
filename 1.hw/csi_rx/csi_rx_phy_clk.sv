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
// Description: High-Speed D-PHY clock receiver for MIPI CSI2 Rx core
//
// It receives input clock and produces both real and complement DDR 
// bit clocks and an SDR (i.e. in/4) byte clock for the SERDES and 
// other downstream devices
//========================================================================

module csi_rx_phy_clk 
  import top_pkg::*;
(
   input  diff_t dphy_clk,     // D-PHY clock input; 1 is P, 0 is N
   input  logic  reset,        // reset input
   
   output logic  reset_out,    // 1 until both clocks are ready for use
   output logic  bit_clock,    // DDR bit  clock =buffered input clock
   output logic  byte_clock    // SDR byte clock =buffered input clock/4
);

   logic dphy_clk_in;
   logic dphy_clk_buf;

//---------------------------------------------
   IBUFDS #(
      .DIFF_TERM    (DPHY_TERM_EN), // Differential Termination
      .IBUF_LOW_PWR ("TRUE"),       // Low power="TRUE", HighestPerf="FALSE"
      .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
   ) 
   u_bufds_clk (      
      .I  (dphy_clk[1]),
      .IB (dphy_clk[0]),

      .O  (dphy_clk_in)
   );


//---------------------------------------------
// The BUFMR/BUFR method works fine with Vivado. But, openXC7 has problems
// with it, see: https://github.com/chili-chips-ba/openeye-CamSI/issues/36
//
// As we cannot wait for openXC7 to add BUFMR support, hence this 
// alternative solution with MMCM, which is supported by openXC7
//---------------------------------------------
   
/*

//--------Multi-Region Clock Buffer
   BUFMR u_bufmr (
      .I   (dphy_clk_in),      // Clock input  (Connect to IBUFG)
      .O   (dphy_clk_buf)      // Clock output (connect to BUFIOs/BUFRs)
    );

//--------BYPASS through Regional Clock buffer
   BUFR #(
      .BUFR_DIVIDE ("BYPASS"), // Values: "BYPASS", 1, 2, 3, 4, 5, 6, 7, 8
      .SIM_DEVICE  (FPGA_DEV)  // Must be set to "7SERIES"
   ) 
   u_bufr (
      .CE  (1'b1),             //i: Active high, clock enable (Divided modes only)
      .CLR (reset),            //i: Active high, asynchronous clear (Divided modes only)
      .I   (dphy_clk_buf),     //i: Clock buffer input driven by an IBUF, MMCM or local interconnect
                                
      .O   (bit_clock)         //o: Clock output port
    );  
     
//--------DIV4 through Regional Clock Buffer
   BUFR #(
      .BUFR_DIVIDE ("4"),     // Values: "BYPASS", 1, 2, 3, 4, 5, 6, 7, 8
      .SIM_DEVICE  (FPGA_DEV) // Must be set to "7SERIES"
   )
   u_clkdiv (
      .CE  (1'b1),            //i: Active high, clock enable (Divided modes only)
      .CLR (reset),           //i: Active high, asynchronous clear (Divided modes only)
      .I   (dphy_clk_buf),    //i: Clock buffer input driven by an IBUF, MMCM or local interconnect
                               
      .O   (byte_clock)       //o: Clock output port
   );
*/


//---------------------------------------------
// openXC7-compatible solution with MMCM
//  See Figure 3-11: Global Clock Network Deskew Using Two BUFGs (page 92)
//  of '0.doc/Xilinx/ug472_7Series_Clocking.pdf'
//---------------------------------------------
   BUFG u_IBUFG_clk_in (
      .I  (dphy_clk_in),
      .O  (dphy_clk_buf)
   );

   logic uclk_out, uclk_out_div4, uclk_fb, clk_fb;
   logic pll_lock;

`ifdef COCOTB_SIM
   // PLL outputs driven from cocotb
   initial begin
      pll_lock  = 1'b0;
      uclk_out = 'x;
      uclk_out_div4 = 'x;
   end

`else
   MMCME2_BASE #(
      .BANDWIDTH       ("OPTIMIZED"), // Jitter programming (OPTIMIZED, HIGH, LOW)
      .DIVCLK_DIVIDE   (1),           // Master division value (1-106)
      .CLKFBOUT_MULT_F (2.0),         // Multiply value for all CLKOUT (2.000-64.000)
      .CLKFBOUT_PHASE  (0.0),         // Phase offset in degrees of CLKFB (-360.000-360.000)
      .CLKIN1_PERIOD   (2.190),       // Input clock period in ns to ps resolution 
                                      //  (i.e. 2.190 is 456MHz)
                                      //  VCO range(400MHz to 1080MHz) = 
                                      //  CLKFBOUT_MULT_F/(CLKIN1_PERIOD*DIVCLK_DIVIDE) 
                                      //   = 912MHz

     //CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      .CLKOUT0_DIVIDE_F(2.0),         // Divide amount for CLKOUT0 (1.000-128.000)
      .CLKOUT1_DIVIDE  (1),
      .CLKOUT2_DIVIDE  (8),           // this is our DIV4 clock       
      .CLKOUT3_DIVIDE  (1),
      .CLKOUT4_DIVIDE  (1),
      .CLKOUT5_DIVIDE  (1),
      .CLKOUT6_DIVIDE  (1),

     //CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: 
     //Duty cycle for each CLKOUT (0.01-0.99)
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT5_DUTY_CYCLE(0.5),
      .CLKOUT6_DUTY_CYCLE(0.5),

     //CLKOUT0_PHASE - CLKOUT6_PHASE: 
     //Phase offset for each CLKOUT (-360.000-360.000)
      .CLKOUT0_PHASE(0.0),
      .CLKOUT1_PHASE(0.0),
      .CLKOUT2_PHASE(0.0),
      .CLKOUT3_PHASE(0.0),
      .CLKOUT4_PHASE(0.0),
      .CLKOUT5_PHASE(0.0),
      .CLKOUT6_PHASE(0.0),
              
      .CLKOUT4_CASCADE ("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      .REF_JITTER1     (0.0),     // Reference input jitter in UI (0.000-0.999)
      .STARTUP_WAIT    ("FALSE")  // Delays DONE until MMCM is locked (FALSE, TRUE)
   ) 
   uMMCME2_BASE (
      .CLKOUT0   (uclk_out),     //o: CLKOUT0
      .CLKOUT0B  (),             //o

      .CLKOUT1   (),             //o
      .CLKOUT1B  (),             //o

      .CLKOUT2   (uclk_out_div4),//o: CLKOUT2
      .CLKOUT2B  (),             //o

      .CLKOUT3   (),             //o 
      .CLKOUT3B  (),             //o 

      .CLKOUT4   (),             //o                
      .CLKOUT5   (),             //o 
      .CLKOUT6   (),             //o 

      .CLKFBOUT  (uclk_fb),      //o: Feedback clock
      .LOCKED    (pll_lock),     //o: LOCK

      .CLKIN1    (dphy_clk_buf), //i: Clock
      .CLKFBIN   (clk_fb),       //i: Feedback clock
      .CLKFBOUTB (),             //o

      .PWRDWN    (1'b0),         //i
      .RST       (reset)         //i
   );
`endif //COCOTB_SIM


// Clock buffers
   BUFG u_BUFG_clk_fb (
      .I(uclk_fb),
      .O( clk_fb)
   );

   BUFG u_BUFG_clk_out (
      .I(uclk_out),
      .O(bit_clock)
   );
   
   BUFG u_BUFG_clk_out_div4 (
      .I(uclk_out_div4),
      .O(byte_clock)
   );

// Reset synchronizer
    logic [2:0] srst_pipe;

    always_ff @(posedge byte_clock or negedge pll_lock) begin
       if (pll_lock == 1'b0) begin
          srst_pipe  <= '1;
          reset_out  <= 1'b1;
       end 
       else begin
          srst_pipe  <= {srst_pipe[1:0], 1'b0};
          reset_out  <=  srst_pipe[2];
       end
    end
   
endmodule: csi_rx_phy_clk

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/7  Isam Vrce  : Initial creation
 2025/1/10 Armin Zunic: Replaced BUFMR with MMCM
*/