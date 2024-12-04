`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2024 11:08:27 AM
// Design Name: 
// Module Name: phy_rx_idelay
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

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
endmodule
