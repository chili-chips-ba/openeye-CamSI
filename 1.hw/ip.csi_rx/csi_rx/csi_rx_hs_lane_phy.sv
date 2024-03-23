//High-Speed D-PHY lane RX PHY for MIPI CSI-2 Rx core

//This entity handles input skew compensation and deserialisation for the
//CSI data input lanes. Output is has arbitrary alignment which must be fixed later on
//in the processing chain

module csi_rx_hs_lane_phy #(
   parameter invert = 1'b0,    // Whether or not to invert output (i.e., if pairs are swapped)
   parameter term_en = "TRUE",   // Whether or not to enable internal input termination
   parameter delay = 0         // IDELAY delay value for skew compensation
)(
   input  logic       bit_clock,       // true and complement DDR bit clocks, buffered from D-PHY clock
   input  logic       byte_clock,      // byte clock; i.e., input clock /4
   input  logic       enable,          // active high enable for SERDES
   input  logic       reset,           // reset, latched internally to byte clock
   input  logic       load,            // In VAR_LOAD mode, it loads the value of CNTVALUEIN
   input  logic [1:0] dphy_hs,         // lane input, 1 is P, 0 is N
   input  logic [4:0] delay_in,
   output logic [4:0] delay_out,
   output logic [7:0] deser_out        // deserialised byte output
);

   logic       reset_lat;              // reset synchronized to byte clock
   logic       in_se;                  // input after differential buffer    
   logic       in_delayed;             // input after deskew    
   logic       bit_clock_b;

   logic [7:0] serdes_out_int;
   
   always_ff @(posedge byte_clock) begin
      reset_lat <= reset;
   end
   
   IBUFDS #(
      .DIFF_TERM(term_en),             // Differential Termination
      .IBUF_LOW_PWR("TRUE"),           // Low power="TRUE", Highest performance="FALSE"
      .IOSTANDARD("LVDS_25")           // Specify the input I/O standard
   ) IBUFDS_inst (
      .O(in_se),                       // Buffer output
      .I(dphy_hs[1]),                  // Diff_p buffer input (connect directly to top-level port)
      .IB(dphy_hs[0])                  // Diff_n buffer input (connect directly to top-level port)
   );
   
   assign bit_clock_b = ~bit_clock;
  
   IDELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("IDATAIN"),           // Delay input (IDATAIN, DATAIN)
      .HIGH_PERFORMANCE_MODE("TRUE"),  // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .IDELAY_TYPE("VAR_LOAD"),        // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .IDELAY_VALUE(delay),            // Input delay tap setting (0-31)
      .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(199.5),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("DATA")          // DATA, CLOCK input signal
   )
   IDELAYE2_inst (
      .CNTVALUEOUT(delay_out),         // 5-bit output: Counter value output
      .DATAOUT(in_delayed),            // 1-bit output: Delayed data output
      .C(byte_clock),                  // 1-bit input: Clock input
      .CE(1'b0),                       // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(1'b0),                 // 1-bit input: Dynamic clock inversion input
      .CNTVALUEIN(delay_in),           // 5-bit input: Counter value input
      .DATAIN(1'b0),                   // 1-bit input: Internal delay data input
      .IDATAIN(in_se),                 // 1-bit input: Data input from the I/O
      .INC(1'b0),                      // 1-bit input: Increment / Decrement tap delay input
      .LD(load),                       // 1-bit input: Load IDELAY_VALUE input
      .LDPIPEEN(1'b0),                 // 1-bit input: Enable PIPELINE register to load data input
      .REGRST(1'b0)                    // 1-bit input: Active-high reset tap-delay input
   );

   ISERDESE2 #(
      .DATA_RATE("DDR"),               // DDR, SDR
      .DATA_WIDTH(8),                  // Parallel data width (2-8,10,14)
      .DYN_CLKDIV_INV_EN("FALSE"),     // Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
      .DYN_CLK_INV_EN("FALSE"),        // Enable DYNCLKINVSEL inversion (FALSE, TRUE)
      
      // INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
      .INIT_Q1(1'b0),
      .INIT_Q2(1'b0),
      .INIT_Q3(1'b0),
      .INIT_Q4(1'b0),
      
      .INTERFACE_TYPE("NETWORKING"),   // MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
      .IOBDELAY("IFD"),                // NONE, BOTH, IBUF, IFD
      .NUM_CE(1),                      // Number of clock enables (1,2)
      .OFB_USED("FALSE"),              // Select OFB path (FALSE, TRUE)
      .SERDES_MODE("MASTER"),          // MASTER, SLAVE
      
      // SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
      .SRVAL_Q1(1'b0),
      .SRVAL_Q2(1'b0),
      .SRVAL_Q3(1'b0),
      .SRVAL_Q4(1'b0)
   )
   ISERDESE2_inst (
      .O("OPEN"),                         // 1-bit output: Combinatorial output
      
      // Q1 - Q8: 1-bit (each) output: Registered data outputs
      // In the ISERDESE2, Q8 is the oldest bit but in the CSI spec
      //the MSB is the most recent bit. So we mirror the output
      .Q1(serdes_out_int[7]),
      .Q2(serdes_out_int[6]),
      .Q3(serdes_out_int[5]),
      .Q4(serdes_out_int[4]),
      .Q5(serdes_out_int[3]),
      .Q6(serdes_out_int[2]),
      .Q7(serdes_out_int[1]),
      .Q8(serdes_out_int[0]),
      
      // SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
      .SHIFTOUT1("OPEN"),
      .SHIFTOUT2("OPEN"),
      
      .BITSLIP(1'b0),

      // CE1, CE2: 1-bit (each) input: Data register clock enable inputs
      .CE1(1'b1),
      .CE2(1'b1),
      .CLKDIVP(1'b0),                  // 1-bit input: TBD
      
      // Clocks: 1-bit (each) input: ISERDESE2 clock input ports
      .CLK(bit_clock),                 // 1-bit input: High-speed clock
      .CLKB(bit_clock_b),              // 1-bit input: High-speed secondary clock
      .CLKDIV(byte_clock),             // 1-bit input: Divided clock
      .OCLK(1'b0),                     // 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY"
      
      // Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
      .DYNCLKDIVSEL(1'b0),             // 1-bit input: Dynamic CLKDIV inversion
      .DYNCLKSEL(1'b0),                // 1-bit input: Dynamic CLK/CLKB inversion
      
      // Input Data: 1-bit (each) input: ISERDESE2 data input ports
      .D(1'b0),                        // 1-bit input: Data input
      .DDLY(in_delayed),                     // 1-bit input: Serial data from IDELAYE2 ????????????
      .OFB(1'b0),                      // 1-bit input: Data feedback from OSERDESE2
      .OCLKB(1'b0),                    // 1-bit input: High speed negative edge output clock
      .RST(reset_lat),                   // 1-bit input: Active high asynchronous reset
      
      // SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
      .SHIFTIN1(1'b0),
      .SHIFTIN2(1'b0)
   );
   
   /*always_comb begin
      if (invert == 1'b0)
         deser_out = serdes_out_int;
      else if (invert == 1'b1)
         deser_out = !serdes_out_int;
   end*/
   
   assign deser_out = (invert == 1'b0) ? serdes_out_int : ~serdes_out_int;

   
endmodule