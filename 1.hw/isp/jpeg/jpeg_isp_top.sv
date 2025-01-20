`define USE_SCB
`undef USE_SCB

module jpeg_colorbalance(

    input   logic               start_capture_in,  // must rise before every frame to trigger the FSM

    input   logic [7:0]         red_data_in,       // 8-bit value of the red channel
    input   logic [7:0]         green_data_in,     // 8-bit value of the green channel
    input   logic [7:0]         blue_data_in,      // 8-bit value of the blue channel
    input   logic               frame_valid_in,    // active while a frame is being transmitted
    input   logic               line_valid_in,     // active while a line is being transmitted

    output  logic [31:0]        data_out,           // 4 bytes of data
    output  logic [15:0]        address_out,        // adress of 16-byte data in image buffer (in bytes), shows the number of bytes processed
    output  logic               image_valid_out,    // when 1, a frame has been fully processed
    output  logic               data_valid_out,     // output data is valid if 1

    input   logic[1:0]          qf_select_in,       // select one of the 4 possible QF (00 for 50%, 01 for 100%, 10 for 10%, 11 for 25%)

    input   logic[10:0] x_size_in, 
    input   logic[9:0] y_size_in, 

    // input   logic               pixel_clock_in,
    // input   logic               pixel_reset_n_in,
    // input   logic               jpeg_fast_clock_in,
    // input   logic               jpeg_fast_reset_n_in,
    // input   logic               jpeg_slow_clock_in,
    // input   logic               jpeg_slow_reset_n_in

    input   logic               clk,                // 100MHz
    input   logic               reset,

    output  logic               clk_36MHz,
    output  logic               jpeg_slow_clock_out
);

logic [7:0] red_data_balanced;
logic [7:0] green_data_balanced;
logic [7:0] blue_data_balanced;

logic line_valid_in_delayed;
logic frame_valid_in_delayed;

logic clk_12MHz, clk_72MHz;
// logic clk_36MHz;

logic pixel_clock_in, jpeg_slow_clock_in, jpeg_fast_clock_in;
logic pixel_reset_n_in, jpeg_slow_reset_n_in, jpeg_fast_reset_n_in;

logic clkfb, locked;

MMCME2_BASE #(
  .BANDWIDTH("OPTIMIZED"),   // Jitter programming (OPTIMIZED, HIGH, LOW)
  .CLKFBOUT_MULT_F(36.0),     // Multiply value for all CLKOUT (2.000-64.000).
  .CLKFBOUT_PHASE(0.0),      // Phase offset in degrees of CLKFB (-360.000-360.000).
  .CLKIN1_PERIOD(10.0),       // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
  // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
  .CLKOUT1_DIVIDE(60),
  .CLKOUT2_DIVIDE(20),
  .CLKOUT3_DIVIDE(10),
  .CLKOUT4_DIVIDE(1),
  .CLKOUT5_DIVIDE(1),
  .CLKOUT6_DIVIDE(1),
  .CLKOUT0_DIVIDE_F(1),    // Divide amount for CLKOUT0 (1.000-128.000).
  // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
  .CLKOUT0_DUTY_CYCLE(0.5),
  .CLKOUT1_DUTY_CYCLE(0.5),
  .CLKOUT2_DUTY_CYCLE(0.5),
  .CLKOUT3_DUTY_CYCLE(0.5),
  .CLKOUT4_DUTY_CYCLE(0.5),
  .CLKOUT5_DUTY_CYCLE(0.5),
  .CLKOUT6_DUTY_CYCLE(0.5),
  // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
  .CLKOUT0_PHASE(0.0),
  .CLKOUT1_PHASE(0.0),
  .CLKOUT2_PHASE(0.0),
  .CLKOUT3_PHASE(0.0),
  .CLKOUT4_PHASE(0.0),
  .CLKOUT5_PHASE(0.0),
  .CLKOUT6_PHASE(0.0),
  .CLKOUT4_CASCADE("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
  .DIVCLK_DIVIDE(5.0),         // Master division value (1-106)
  .REF_JITTER1(0.0),         // Reference input jitter in UI (0.000-0.999).
  .STARTUP_WAIT("FALSE")     // Delays DONE until MMCM is locked (FALSE, TRUE)
)
MMCME2_BASE_inst (
  // Clock Outputs: 1-bit (each) output: User configurable clock outputs
  // .CLKOUT0(clkout0),     // 1-bit output: CLKOUT0
  // .CLKOUT0B(clkout0b),   // 1-bit output: Inverted CLKOUT0
  .CLKOUT1(clk_12MHz),     // 1-bit output: new_clk (our new clock)
  // .CLKOUT1B(clkout1b),   // 1-bit output: Inverted CLKOUT1
  .CLKOUT2(clk_36MHz),     // 1-bit output: CLKOUT2
  // .CLKOUT2B(clkout2b),   // 1-bit output: Inverted CLKOUT2
  .CLKOUT3(clk_72MHz),     // 1-bit output: CLKOUT3
  // .CLKOUT3B(clkout3b),   // 1-bit output: Inverted CLKOUT3
  // .CLKOUT4(clkout4),     // 1-bit output: CLKOUT4
  // .CLKOUT5(clkout5),     // 1-bit output: CLKOUT5
  // .CLKOUT6(clkout6),     // 1-bit output: CLKOUT6
  // Feedback Clocks: 1-bit (each) output: Clock feedback ports
  .CLKFBOUT(clkfb),   // 1-bit output: Feedback clock
  // .CLKFBOUTB(clkfboutb), // 1-bit output: Inverted CLKFBOUT
  // Status Ports: 1-bit (each) output: MMCM status ports
  .LOCKED(locked),       // 1-bit output: LOCK
  // Clock Inputs: 1-bit (each) input: Clock input
  .CLKIN1(clk),       // 1-bit input: Clock
  // Control Ports: 1-bit (each) input: MMCM control ports
  .PWRDWN(1'b0),       // 1-bit input: Power-down
  .RST(reset),             // 1-bit input: Reset
  // Feedback Clocks: 1-bit (each) input: Clock feedback ports
  .CLKFBIN(clkfb)      // 1-bit input: Feedback clock
);

assign pixel_clock_in = clk_36MHz;
assign jpeg_slow_clock_in = clk_12MHz;
assign jpeg_fast_clock_in = clk_72MHz;

assign pixel_reset_n_in = locked;
assign jpeg_slow_reset_n_in = locked;
assign jpeg_fast_reset_n_in = locked;

assign jpeg_slow_clock_out = jpeg_slow_clock_in;

`ifdef USE_SCB 
  simplecolorbalance simplecolorbalance_inst(
    .clk(pixel_clock_in),
    .reset_async(!pixel_reset_n_in),
    .red_data_in(red_data_in),
    .green_data_in(green_data_in),
    .blue_data_in(blue_data_in),
    .line_valid_in(line_valid_in),
    .frame_valid_in(frame_valid_in),
    .red_data_out(red_data_balanced),
    .green_data_out(green_data_balanced),
    .blue_data_out(blue_data_balanced),
    .line_valid_out(line_valid_in_delayed),
    .frame_valid_out(frame_valid_in_delayed)
  );
`else
  assign red_data_balanced = red_data_in;
  assign green_data_balanced = green_data_in;
  assign blue_data_balanced = blue_data_in;
  assign line_valid_in_delayed = line_valid_in;
  assign frame_valid_in_delayed = frame_valid_in;
`endif

jpeg_encoder jpeg_encoder_inst(
  .start_capture_in(start_capture_in),
  .red_data_in({red_data_balanced, 2'b0}),
  .green_data_in({green_data_balanced, 2'b0}),
  .blue_data_in({blue_data_balanced, 2'b0}),
  .frame_valid_in(frame_valid_in_delayed),
  .line_valid_in(line_valid_in_delayed),
  .data_out(data_out),
  .address_out(address_out),
  .image_valid_out(image_valid_out),
  .data_valid_out(data_valid_out),
  .qf_select_in(qf_select_in),
  .x_size_in(x_size_in),
  .y_size_in(y_size_in),
  .pixel_clock_in(pixel_clock_in),
  .pixel_reset_n_in(pixel_reset_n_in),
  .jpeg_fast_clock_in(jpeg_fast_clock_in),
  .jpeg_fast_reset_n_in(jpeg_fast_reset_n_in),
  .jpeg_slow_clock_in(jpeg_slow_clock_in),
  .jpeg_slow_reset_n_in(jpeg_slow_reset_n_in)
);

endmodule