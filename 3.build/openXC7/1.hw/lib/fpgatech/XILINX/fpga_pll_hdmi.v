module fpga_pll_hdmi (
	clk_ext,
	srst_n,
	clk_pix,
	clk_pix5
);
	input wire clk_ext;
	output reg srst_n;
	output wire clk_pix;
	output wire clk_pix5;
	wire pll_lock;
	wire clkfb;
	reg [2:0] srst_n_pipe;
	wire uclk_pix;
	wire uclk_pix5;
	MMCME2_BASE #(
		.BANDWIDTH("OPTIMIZED"),
		.DIVCLK_DIVIDE(3),
		.CLKFBOUT_MULT_F(38.750),
		.CLKFBOUT_PHASE(0.0),
		.CLKIN1_PERIOD(10.000),
		.CLKOUT0_DIVIDE_F(3.0),
		.CLKOUT1_DIVIDE(1),
		.CLKOUT2_DIVIDE(15),
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
	) u_MMCME2_BASE(
		.CLKOUT0(uclk_pix5),
		.CLKOUT0B(),
		.CLKOUT1(),
		.CLKOUT1B(),
		.CLKOUT2(uclk_pix),
		.CLKOUT2B(),
		.CLKOUT3(),
		.CLKOUT3B(),
		.CLKOUT4(),
		.CLKOUT5(),
		.CLKOUT6(),
		.CLKFBOUT(clkfb),
		.LOCKED(pll_lock),
		.CLKIN1(clk_ext),
		.CLKFBIN(clkfb),
		.CLKFBOUTB(),
		.PWRDWN(1'b0),
		.RST(1'b0)
	);
	BUFG u_BUFG_clk_pix(
		.I(uclk_pix),
		.O(clk_pix)
	);
	BUFG u_BUFG_clk_pix5(
		.I(uclk_pix5),
		.O(clk_pix5)
	);
	always @(posedge clk_pix or negedge pll_lock)
		if (pll_lock == 1'b0) begin
			srst_n_pipe <= 1'sb0;
			srst_n <= 1'b0;
		end
		else begin
			srst_n_pipe <= {srst_n_pipe[1:0], 1'b1};
			srst_n <= srst_n_pipe[2];
		end
endmodule
