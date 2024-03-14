//----------------------------------------------------------------------------------
//-- CHILI CHIPS LLC
//----------------------------------------------------------------------------------
//-- Technology-specific Xilinx PLL
//----------------------------------------------------------------------------------

module fpga_pll (
   input  logic clk_in,   // 200MHz

   output logic srst_n,
   output logic clk_out0, // 228MHz
   output logic clk_out1  // 200MHz
);

   logic pll_lock;
   logic clkfb;
   logic srst_n_pipe;
   logic uclk_out0;
   logic uclk_out1;

   MMCME2_BASE #(
     .BANDWIDTH       ("OPTIMIZED"), // Jitter programming (OPTIMIZED, HIGH, LOW)
     .DIVCLK_DIVIDE   (5),           // Master division value (1-106)
     .CLKFBOUT_MULT_F (49.875),      // Multiply value for all CLKOUT (2.000-64.000)
     .CLKFBOUT_PHASE  (0.0),         // Phase offset in degrees of CLKFB (-360.000-360.000)
     .CLKIN1_PERIOD   (10.000),      // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz)
                                     // VCO range(400MHz to 1080MHz) = CLKFBOUT_MULT_F/(CLKIN1_PERIOD*DIVCLK_DIVIDE)
      
     // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
     .CLKOUT0_DIVIDE_F(4.375),    // Divide amount for CLKOUT0 (1.000-128.000)
     .CLKOUT1_DIVIDE  (1),
     .CLKOUT2_DIVIDE  (5),
     .CLKOUT3_DIVIDE  (1),
     .CLKOUT4_DIVIDE  (1),
     .CLKOUT5_DIVIDE  (1),
     .CLKOUT6_DIVIDE  (1),
      
     // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99)
     .CLKOUT0_DUTY_CYCLE (0.5),
     .CLKOUT1_DUTY_CYCLE (0.5),
     .CLKOUT2_DUTY_CYCLE (0.5),
     .CLKOUT3_DUTY_CYCLE (0.5),
     .CLKOUT4_DUTY_CYCLE (0.5),
     .CLKOUT5_DUTY_CYCLE (0.5),
     .CLKOUT6_DUTY_CYCLE (0.5),
      
     // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000)
     .CLKOUT0_PHASE      (0.0),
     .CLKOUT1_PHASE      (0.0),
     .CLKOUT2_PHASE      (0.0),
     .CLKOUT3_PHASE      (0.0),
     .CLKOUT4_PHASE      (0.0),
     .CLKOUT5_PHASE      (0.0),
     .CLKOUT6_PHASE      (0.0),
             
     .CLKOUT4_CASCADE("FALSE"),    // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
     .REF_JITTER1        (0.0),    // Reference input jitter in UI (0.000-0.999)
     .STARTUP_WAIT       ("FALSE") // Delays DONE until MMCM is locked (FALSE, TRUE)
   ) 
   u_MMCME2_BASE (
     .CLKOUT0   (uclk_out0),       // 1-bit output: CLKOUT0
     .CLKOUT2   (uclk_out1),       // 1-bit output: CLKOUT2
     .CLKFBOUT  (clkfb),           // 1-bit output: Feedback clock
     .LOCKED    (pll_lock),        // 1-bit output: LOCK
     .CLKIN1    (clk_in),          // 1-bit input: Clock
     .CLKFBIN   (clkfb)            // 1-bit input: Feedback clock
   );


//----------------------------------------------
// Clock buffers
//----------------------------------------------
   BUFG u_BUFG_clk_out0 (
     .I(uclk_out0),
     .O(clk_out0)
   );
   
   BUFG u_BUFG_clk_out1 (
     .I(uclk_out1),
     .O(clk_out1)
   );

//----------------------------------------------
// Reset synchronizer
//----------------------------------------------
   always_ff @(posedge clk_out0 or negedge pll_lock) begin
      if (pll_lock == 1'b0) begin
         srst_n_pipe <= 1'b0;
         srst_n      <= 1'b0;
      end 
      else begin
         srst_n_pipe <= {srst_n_pipe[1:0], 1'b1};
         srst_n      <= srst_n_pipe[2];
      end
   end
        
endmodule: fpga_pll
