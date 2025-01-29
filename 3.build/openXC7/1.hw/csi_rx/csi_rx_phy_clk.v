module csi_rx_phy_clk (
	dphy_clk,
	reset,
	reset_out,
	bit_clock,
	byte_clock
);
	input wire [1:0] dphy_clk;
	input wire reset;
	output reg reset_out;
	output wire bit_clock;
	output wire byte_clock;
	wire dphy_clk_in;
	wire dphy_clk_buf;
	localparam top_pkg_DPHY_TERM_EN = "TRUE";
	IBUFDS #(
		.DIFF_TERM(top_pkg_DPHY_TERM_EN),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("LVDS_25")
	) u_bufds_clk(
		.I(dphy_clk[1]),
		.IB(dphy_clk[0]),
		.O(dphy_clk_in)
	);
	BUFG u_IBUFG_clk_in(
		.I(dphy_clk_in),
		.O(dphy_clk_buf)
	);
	wire uclk_out;
	wire uclk_out_div4;
	wire uclk_fb;
	wire clk_fb;
	wire pll_lock;
	MMCME2_BASE #(
		.BANDWIDTH("OPTIMIZED"),
		.DIVCLK_DIVIDE(1),
		.CLKFBOUT_MULT_F(2.0),
		.CLKFBOUT_PHASE(0.0),
		.CLKIN1_PERIOD(2.190),
		.CLKOUT0_DIVIDE_F(2.0),
		.CLKOUT1_DIVIDE(1),
		.CLKOUT2_DIVIDE(8),
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
		.CLKOUT0(uclk_out),
		.CLKOUT0B(),
		.CLKOUT1(),
		.CLKOUT1B(),
		.CLKOUT2(uclk_out_div4),
		.CLKOUT2B(),
		.CLKOUT3(),
		.CLKOUT3B(),
		.CLKOUT4(),
		.CLKOUT5(),
		.CLKOUT6(),
		.CLKFBOUT(uclk_fb),
		.LOCKED(pll_lock),
		.CLKIN1(dphy_clk_buf),
		.CLKFBIN(clk_fb),
		.CLKFBOUTB(),
		.PWRDWN(1'b0),
		.RST(reset)
	);
	BUFG u_BUFG_clk_fb(
		.I(uclk_fb),
		.O(clk_fb)
	);
	BUFG u_BUFG_clk_out(
		.I(uclk_out),
		.O(bit_clock)
	);
	BUFG u_BUFG_clk_out_div4(
		.I(uclk_out_div4),
		.O(byte_clock)
	);
	reg [2:0] srst_pipe;
	always @(posedge byte_clock or negedge pll_lock)
		if (pll_lock == 1'b0) begin
			srst_pipe <= 1'sb1;
			reset_out <= 1'b1;
		end
		else begin
			srst_pipe <= {srst_pipe[1:0], 1'b0};
			reset_out <= srst_pipe[2];
		end
endmodule
