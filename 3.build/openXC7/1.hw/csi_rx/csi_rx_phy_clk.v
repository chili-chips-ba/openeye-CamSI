module csi_rx_phy_clk (
	dphy_clk,
	reset,
	bit_clock,
	byte_clock
);
	input wire [1:0] dphy_clk;
	input wire reset;
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
	BUFMR u_bufmr(
		.I(dphy_clk_in),
		.O(dphy_clk_buf)
	);
	localparam top_pkg_FPGA_DEV = "7SERIES";
	BUFR #(
		.BUFR_DIVIDE("BYPASS"),
		.SIM_DEVICE(top_pkg_FPGA_DEV)
	) u_bufr(
		.CE(1'b1),
		.CLR(reset),
		.I(dphy_clk_buf),
		.O(bit_clock)
	);
	BUFR #(
		.BUFR_DIVIDE("4"),
		.SIM_DEVICE(top_pkg_FPGA_DEV)
	) u_clkdiv(
		.CE(1'b1),
		.CLR(reset),
		.I(dphy_clk_buf),
		.O(byte_clock)
	);
endmodule
