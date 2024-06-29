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
// Description: This module handles input skew compensation and
// deserialisation for the CSI data input lanes. Output has arbitrary
// alignment which must be fixed later on in the processing chain
//========================================================================

module csi_rx_phy_dat #(
   parameter          INVERT = 1'b0,// 1 to invert (if pairs are swapped on board)
   parameter bit[4:0] DELAY  = 5'd3 // IDELAY delay value for skew compensation
)(
   input  logic       reset,      // async reset, sync'd internally to byte clock
   input  logic       bit_clock,  // DDR bit clocks, buffered from D-PHY clock
   input  logic       byte_clock, // byte clock = input clock /4

   input  logic [1:0] dphy_hs,    // lane input: [1]=P; [0]=N
   output logic [7:0] deser_out   // deserialised byte output
);

   logic       in_se;           // Single-Ended data input
   logic       in_delayed;      // data input after deskew
   logic [7:0] serdes_out;      // parallel data from ISERDES 

//---------------------------------------------   
   IBUFDS #(
      .DIFF_TERM    (top_pkg::DPHY_TERM_EN), // Differential Termination
      .IBUF_LOW_PWR ("TRUE"),   // Low power="TRUE", Highest Perf="FALSE"
      .IOSTANDARD   ("LVDS_25")
   ) 
   u_ibuf (
      .I   (dphy_hs[1]),        // Diff_P buffer input
      .IB  (dphy_hs[0]),        // Diff_N buffer input

      .O   (in_se)              // Buffer output
   );

   
//---------------------------------------------
   IDELAYE2 #(
      .CINVCTRL_SEL          ("FALSE"),    // Enable dynamic clock inversion: FALSE/TRUE
      .DELAY_SRC             ("IDATAIN"),  // Delay input (IDATAIN, DATAIN)
      .HIGH_PERFORMANCE_MODE ("TRUE"),     // Reduced jitter:TRUE; Reduced power:FALSE
      .IDELAY_TYPE           ("VAR_LOAD"), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .IDELAY_VALUE          ({27'd0,DELAY}), // Input delay tap setting (0-31)
      .PIPE_SEL              ("FALSE"),    // Select pipelined mode: FALSE/TRUE
      .REFCLK_FREQUENCY      (199.5),      // IDELAYCTRL clock input frequency in MHz:
                                           //  190.0-210.0 or 290.0-310.0
      .SIGNAL_PATTERN        ("DATA")      // DATA, CLOCK input signal
   )
   u_indelay (      
      .DATAOUT     (in_delayed), //o: Delayed data output
      .DATAIN      (1'b0),       //i: Internal delay data input
      .C           (byte_clock), //i: Clock input
      .CE          (1'b0),       //i: Active high enable inc/dect input
      .INC         (1'b0),       //i: Increment / Decrement tap delay input 
      .IDATAIN     (in_se),      //i: Data input from the I/O           
      .CNTVALUEIN  (5'(DELAY)),  //i[4:0]: Counter value input
      .CNTVALUEOUT (),           //o[4:0]: Counter value output     
      .CINVCTRL    (1'b0),       //i: Dynamic clock inversion input       
      .LD          (1'b1),       //i: VAR_LOAD mode, load value of CNTVALUEIN
      .LDPIPEEN    (1'b0),       //i: Enable PIPELINE register to load data input
      .REGRST      (1'b0)        //i: Active-high reset tap-delay input
   );


//---------------------------------------------
   logic sreset; // reset synchronized to byte clock

   always_ff @(posedge byte_clock) begin
      sreset <= reset;
   end
   
`ifdef ISERDES_SIM_MODEL
 // Simplified 8:1 ISERDES model (functionality verified in Xsim)
   logic FF0, FF1;
   logic [7:0] SHIFT0, SHIFT1, SHIFT2, Q;

   always @(posedge bit_clock) FF0 <= in_se;
   always @(negedge bit_clock) FF1 <= in_se; 

   always @(posedge bit_clock) begin
      SHIFT0 <= {FF1, FF0, SHIFT0[7:2]};
      SHIFT1 <= SHIFT0;
      SHIFT2 <= SHIFT1;
   end
   
   always @(posedge byte_clock) Q <= SHIFT2;
   always_comb serdes_out = Q;

`else
   ISERDESE2 #(
      .DATA_RATE         ("DDR"),   // DDR, SDR
      .DATA_WIDTH        (8),       // Parallel data width (2-8,10,14)
      .DYN_CLKDIV_INV_EN ("FALSE"), // Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
      .DYN_CLK_INV_EN    ("FALSE"), // Enable DYNCLKINVSEL inversion (FALSE, TRUE)
      
      // INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
      .INIT_Q1           (1'b0),
      .INIT_Q2           (1'b0),
      .INIT_Q3           (1'b0),
      .INIT_Q4           (1'b0),
      
      .INTERFACE_TYPE    ("NETWORKING"), 
                                     // MEMORY, MEMORY_DDR3, MEMORY_QDR, 
                                     // NETWORKING, OVERSAMPLE
      .IOBDELAY          ("IFD"),    // NONE, BOTH, IBUF, IFD
      .NUM_CE            (1),        // Number of clock enables (1,2)
      .OFB_USED          ("FALSE"),  // Select OFB path: FALSE/TRUE
      .SERDES_MODE       ("MASTER"), // MASTER, SLAVE
      
      // SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
      .SRVAL_Q1          (1'b0),
      .SRVAL_Q2          (1'b0),
      .SRVAL_Q3          (1'b0),
      .SRVAL_Q4          (1'b0)
   )
   ideser (
      .RST               (sreset),   //i: Active-1 async reset

      // Q1 - Q8: 1-bit (each) output: Registered data outputs
      // In the ISERDESE2, Q8 is the oldest bit but in the CSI spec
      //the MSB is the most recent bit. So we mirror the output
      .Q1                (serdes_out[7]),
      .Q2                (serdes_out[6]),
      .Q3                (serdes_out[5]),
      .Q4                (serdes_out[4]),
      .Q5                (serdes_out[3]),
      .Q6                (serdes_out[2]),
      .Q7                (serdes_out[1]),
      .Q8                (serdes_out[0]),
      
      .BITSLIP           (1'b0),

      // CE1, CE2: 1-bit (each) input: Data register clock enable inputs
      .CE1               (1'b1),
      .CE2               (1'b1),
      .CLKDIVP           (1'b0),     //i: TBD
      
      // Clocks: 1-bit (each) input: ISERDESE2 clock input ports
      .CLK               ( bit_clock), //i: High-speed clock
      .CLKB              (~bit_clock), //i: High-speed secondary clock
      .CLKDIV            (byte_clock), //i: Divided clock
      .OCLK              (1'b0),       //i: High speed output clock used when INTERFACE_TYPE="MEMORY"
      
      // Dynamic Clock Inversions: 1-bit (each) input: 
      // Dynamic clock inversion pins to switch clock polarity
      .DYNCLKDIVSEL      (1'b0),       //i: Dynamic CLKDIV inversion
      .DYNCLKSEL         (1'b0),       //i: Dynamic CLK/CLKB inversion
      
      // Input Data: 1-bit (each) input: ISERDESE2 data input ports
      .D                 (1'b0),       //i: Data input
      .DDLY              (in_delayed), //i: Serial data from IDELAYE2
      .OFB               (1'b0),       //i: Data feedback from OSERDESE2
      .OCLKB             (1'b0),       //i: High speed negative edge output clock
      
      // Data width expansion ports
      .SHIFTIN1          (1'b0),       //i 
      .SHIFTIN2          (1'b0),       //i
      .SHIFTOUT1         (),           //o
      .SHIFTOUT2         (),           //o

      .O()                             //o: Combinatorial output
   );
`endif //ISERDES_SIM_MODEL
   
//---------------------------------------------
   assign deser_out = (INVERT == 1'b1) ? ~serdes_out : serdes_out;

endmodule: csi_rx_phy_dat

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/2/24  Armin Zunic: Initial creation
*/
