//High-Speed D-PHY clock RX PHY for MIPI CSI-2 Rx core

// This receives the input clock and produces both real and complement DDR bit
// clocks and an SDR (i.e. in/4) byte clock for the SERDES and other downstream devices

module csi_rx_hs_clk_phy #(
   parameter term_en = "TRUE" // TRUE enables, FALSE disables the 100 ohm termination between the P and N sides of a differential pair
)(
   input  logic [1:0] dphy_clk,  // D-PHY clock input; 1 is P, 0 is N
   input  logic       reset,     // reset input for BUFR
   output logic       bit_clock, // DDR bit clock (i.e., input clock buffered) out
   output logic       byte_clock // SDR byte clock (i.e., input clock / 4) out
);

   logic bit_clock_int_pre;
   logic bit_clock_int_bufg;
   logic bit_clock_int;

   logic bit_clock_b_int;
   logic byte_clock_int;
   logic word_clock_int;
   
   IBUFDS #(
      .DIFF_TERM(term_en),       // Differential Termination
      .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE"
      .IOSTANDARD("LVDS_25")     // Specify the input I/O standard
   ) IBUFDS_inst (      
      .O(bit_clock_int_bufg),     // Buffer output
      .I(dphy_clk[1]),            // Diff_p buffer input (connect directly to top-level port)
      .IB(dphy_clk[0])            // Diff_n buffer input (connect directly to top-level port)
   );
   
    // BUFMR: Multi-Region Clock Buffer
    BUFMR BUFMR_inst (
        .O(bit_clock_int_pre), // 1-bit output: Clock output (connect to BUFIOs/BUFRs)
        .I(bit_clock_int_bufg) // 1-bit input: Clock input (Connect to IBUFG)
    );   

/*   
   //BUFIO : Local Clock Buffer for I/O
   BUFIO BUFIO_inst (
      .O(bit_clock_int),         // 1-bit output: Clock output (connect to I/O clock loads).
      .I(bit_clock_int_pre)      // 1-bit input: Clock input (connect to an IBUF or BUFMR).
   );
 */
 
    //BUFR : Regional Clock Buffer
    BUFR #(
        .BUFR_DIVIDE("BYPASS"),
        .SIM_DEVICE("7SERIES")
   ) BUFR_bit_inst (
        .O(bit_clock_int),
        .CE(1'b1),                 // 1-bit input: Active high, clock enable (Divided modes only)
        .CLR(reset),               // 1-bit input: Active high, asynchronous clear (Divided modes only)
        .I(bit_clock_int_pre)      // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
    );  
     
   //BUFR : Regional Clock Buffer
   BUFR #(
      .BUFR_DIVIDE(4),           // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8"
      .SIM_DEVICE("7SERIES")     // Must be set to "7SERIES"
   )
   BUFR_byte_inst (
      .O(byte_clock_int),        // 1-bit output: Clock output port
      .CE(1'b1),                 // 1-bit input: Active high, clock enable (Divided modes only)
      .CLR(reset),               // 1-bit input: Active high, asynchronous clear (Divided modes only)
      .I(bit_clock_int_pre)      // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
   );
   
   assign bit_clock  = bit_clock_int;
   assign byte_clock = byte_clock_int;

endmodule