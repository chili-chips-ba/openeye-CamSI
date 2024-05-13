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
   input  logic  reset,        // reset input for BUFR

   output logic  bit_clock,    // DDR bit clock  =buffered input clock
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
// BUFMR: Multi-Region Clock Buffer
   BUFMR u_bufmr (
      .I(dphy_clk_in), // Clock input (Connect to IBUFG)
      .O(dphy_clk_buf) // Clock output (connect to BUFIOs/BUFRs)
    );   

/* 
 //BUFIO : Local Clock Buffer for I/O
   BUFIO u_bufio (
      .I(dphy_clk_in), // Clock input (connect to an IBUF or BUFMR)
      .O(dphy_clk_buf) // Clock output (connect to I/O clock loads)
   );
*/

//---------------------------------------------BYPASS
 //BUFR : Regional Clock Buffer
   BUFR #(
      .BUFR_DIVIDE ("BYPASS"), // Values: "BYPASS", 1, 2, 3, 4, 5, 6, 7, 8
      .SIM_DEVICE  (FPGA_DEV)  // Must be set to "7SERIES"
   ) 
   u_bufr (
      .CE  (1'b1),         //i: Active high, clock enable (Divided modes only)
      .CLR (reset),        //i: Active high, asynchronous clear (Divided modes only)
      .I   (dphy_clk_buf), //i: Clock buffer input driven by an IBUF, MMCM or local interconnect

      .O   (bit_clock)     //o: Clock output port
    );  
     
//---------------------------------------------DIV4
 //BUFR : Regional Clock Buffer
   BUFR #(
      .BUFR_DIVIDE ("4"),       // Values: "BYPASS", 1, 2, 3, 4, 5, 6, 7, 8
      .SIM_DEVICE  (FPGA_DEV) // Must be set to "7SERIES"
   )
   u_clkdiv (
      .CE  (1'b1),         //i: Active high, clock enable (Divided modes only)
      .CLR (reset),        //i: Active high, asynchronous clear (Divided modes only)
      .I   (dphy_clk_buf), //i: Clock buffer input driven by an IBUF, MMCM or local interconnect

      .O   (byte_clock)    //o: Clock output port
   );
   
endmodule: csi_rx_phy_clk

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/7  Isam Vrce: Initial creation
*/
