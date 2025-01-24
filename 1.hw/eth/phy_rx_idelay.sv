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
// Description: Delays on Rx PHY datapath
//========================================================================

module phy_rx_idelay
   import top_pkg::*;
   import hdmi_pkg::*;   
(   
   input  bus4_t     phy_rxd,
   output bus4_t     phy_rxd_delay,
   
   input  logic      phy_rx_ctl,
   output logic      phy_rx_ctl_delay
);

//---------------------------------------------
   IDELAYE2 #(
      .REFCLK_FREQUENCY(199.5),
      .IDELAY_TYPE("FIXED"),
      .IDELAY_VALUE(0),
      .SIGNAL_PATTERN("DATA")      // DATA, CLOCK input signal
   )
   phy_rxd_idelay_0 (
       .IDATAIN(phy_rxd[0]),
       .DATAOUT(phy_rxd_delay[0]),
       .DATAIN(1'b0),
       .C(1'b0),
       .CE(1'b0),
       .INC(1'b0),
       .CINVCTRL(1'b0),
       .CNTVALUEIN(5'd0),
       .CNTVALUEOUT(),
       .LD(1'b0),
       .LDPIPEEN(1'b0),
       .REGRST(1'b0)
   );

   IDELAYE2 #(
      .REFCLK_FREQUENCY(199.5),
      .IDELAY_TYPE("FIXED"),
      .IDELAY_VALUE(0),
      .SIGNAL_PATTERN("DATA")      // DATA, CLOCK input signal
   )
   phy_rxd_idelay_1 (
       .IDATAIN(phy_rxd[1]),
       .DATAOUT(phy_rxd_delay[1]),
       .DATAIN(1'b0),
       .C(1'b0),
       .CE(1'b0),
       .INC(1'b0),
       .CINVCTRL(1'b0),
       .CNTVALUEIN(5'd0),
       .CNTVALUEOUT(),
       .LD(1'b0),
       .LDPIPEEN(1'b0),
       .REGRST(1'b0)
   );

   IDELAYE2 #(
      .REFCLK_FREQUENCY(199.5),  
      .IDELAY_TYPE("FIXED"),
      .IDELAY_VALUE(0),
      .SIGNAL_PATTERN("DATA")      // DATA, CLOCK input signal
   )
   phy_rxd_idelay_2 (
       .IDATAIN(phy_rxd[2]),
       .DATAOUT(phy_rxd_delay[2]),
       .DATAIN(1'b0),
       .C(1'b0),
       .CE(1'b0),
       .INC(1'b0),
       .CINVCTRL(1'b0),
       .CNTVALUEIN(5'd0),
       .CNTVALUEOUT(),
       .LD(1'b0),
       .LDPIPEEN(1'b0),
       .REGRST(1'b0)
   );

   IDELAYE2 #(
      .REFCLK_FREQUENCY(199.5),
      .IDELAY_TYPE("FIXED"),
      .IDELAY_VALUE(0),
      .SIGNAL_PATTERN("DATA")      // DATA, CLOCK input signal
   )
   phy_rxd_idelay_3 (
       .IDATAIN(phy_rxd[3]),
       .DATAOUT(phy_rxd_delay[3]),
       .DATAIN(1'b0),
       .C(1'b0),
       .CE(1'b0),
       .INC(1'b0),
       .CINVCTRL(1'b0),
       .CNTVALUEIN(5'd0),
       .CNTVALUEOUT(),
       .LD(1'b0),
       .LDPIPEEN(1'b0),
       .REGRST(1'b0)
   );

   IDELAYE2 #(
      .REFCLK_FREQUENCY(199.5),
      .IDELAY_TYPE("FIXED"),
      .IDELAY_VALUE(0),
      .SIGNAL_PATTERN("DATA")      // DATA, CLOCK input signal
   )
   phy_rx_ctl_idelay (
       .IDATAIN(phy_rx_ctl),
       .DATAOUT(phy_rx_ctl_delay),
       .DATAIN(1'b0),
       .C(1'b0),
       .CE(1'b0),
       .INC(1'b0),
       .CINVCTRL(1'b0),
       .CNTVALUEIN(5'd0),
       .CNTVALUEOUT(),
       .LD(1'b0),
       .LDPIPEEN(1'b0),
       .REGRST(1'b0)
   );
     
//---------------------------------------------
endmodule: phy_rx_idelay

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/11/24 Anel H: Initial creation 
*/
