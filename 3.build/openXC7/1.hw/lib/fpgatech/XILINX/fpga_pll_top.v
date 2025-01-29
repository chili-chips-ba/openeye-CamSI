module fpga_pll_top (
	areset,
	clk_in,
	srst,
	clk_out0,
	clk_out1
);
	input wire areset;
	input wire clk_in;
	output reg srst;
	output wire clk_out0;
	output wire clk_out1;
	wire pll_lock;
	wire clkfb;
	wire uclk_out0;
	wire uclk_out1;
	MMCME2_BASE #(
		.BANDWIDTH("OPTIMIZED"),
		.DIVCLK_DIVIDE(5),
		.CLKFBOUT_MULT_F(45.0),
		.CLKFBOUT_PHASE(0.0),
		.CLKIN1_PERIOD(10.000),
		.CLKOUT0_DIVIDE_F(4.5),
		.CLKOUT1_DIVIDE(1),
		.CLKOUT2_DIVIDE(5),
		.CLKOUT3_DIVIDE(1),
		.CLKOUT4_DIVIDE(1),
		.CLKOUT5_DIVIDE(1),
		.CLKOUT6_DIVIDE(1),
		.CLKOUT0_DUTY_CYCLE(0.5),
		.CLKOUT1_DUTY_CYCLE(0.5),
		.CLKOUT2_DUTY_CYCLE(0.5),
		.CLKOUT3_DUTY_CYCLE(0.5),
		.CLKOUT4_DUTY_CYCLE(0.5),
		.CLKOUT5_DUTY_CYCLE(0.5),
		.CLKOUT6_DUTY_CYCLE(0.5),
		.CLKOUT0_PHASE(0.0),
		.CLKOUT1_PHASE(0.0),
		.CLKOUT2_PHASE(0.0),
		.CLKOUT3_PHASE(0.0),
		.CLKOUT4_PHASE(0.0),
		.CLKOUT5_PHASE(0.0),
		.CLKOUT6_PHASE(0.0),
		.CLKOUT4_CASCADE("FALSE"),
		.REF_JITTER1(0.0),
		.STARTUP_WAIT("FALSE")
	) uMMCME2_BASE(
		.CLKOUT0(uclk_out0),
		.CLKOUT0B(),
		.CLKOUT1(),
		.CLKOUT1B(),
		.CLKOUT2(uclk_out1),
		.CLKOUT2B(),
		.CLKOUT3(),
		.CLKOUT3B(),
		.CLKOUT4(),
		.CLKOUT5(),
		.CLKOUT6(),
		.CLKFBOUT(clkfb),
		.LOCKED(pll_lock),
		.CLKIN1(clk_in),
		.CLKFBIN(clkfb),
		.CLKFBOUTB(),
		.PWRDWN(1'b0),
		.RST(1'b0)
	);
	BUFG u_BUFG_clk_out0(
		.I(uclk_out0),
		.O(clk_out0)
	);
	BUFG u_BUFG_clk_out2(
		.I(uclk_out1),
		.O(clk_out1)
	);
	wire arst_n;
	assign arst_n = ~areset & pll_lock;
	reg [2:0] srst_pipe;
	always @(negedge arst_n or posedge clk_out0)
		if (arst_n == 1'b0) begin
			srst_pipe <= 1'sb1;
			srst <= 1'b1;
		end
		else begin
			srst_pipe <= {srst_pipe[1:0], 1'b0};
			srst <= srst_pipe[2];
		end
endmodule
