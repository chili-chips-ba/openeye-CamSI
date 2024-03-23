module csi_rx_idelayctrl_gen (
   input  logic ref_clock, // IDELAYCTRL reference clock
   input  logic reset     // IDELAYCTRL reset
);

   IDELAYCTRL delayctrl_inst (
      .RDY(),       // Ready output (not used, thus connected to nothing)
      .REFCLK(ref_clock), // Reference clock input
      .RST(reset)   // Reset input
   );

endmodule