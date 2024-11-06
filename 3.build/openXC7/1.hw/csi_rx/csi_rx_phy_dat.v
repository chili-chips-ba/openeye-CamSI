module csi_rx_phy_dat (
	reset,
	bit_clock,
	byte_clock,
	dphy_hs,
	deser_out
);
	parameter INVERT = 1'b0;
	parameter [4:0] DELAY = 5'd3;
	input wire reset;
	input wire bit_clock;
	input wire byte_clock;
	input wire [1:0] dphy_hs;
	output wire [7:0] deser_out;
	wire in_se;
	wire in_delayed;
	wire [7:0] serdes_out;
	localparam top_pkg_DPHY_TERM_EN = "TRUE";
	IBUFDS #(
		.DIFF_TERM(top_pkg_DPHY_TERM_EN),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("LVDS_25")
	) u_ibuf(
		.I(dphy_hs[1]),
		.IB(dphy_hs[0]),
		.O(in_se)
	);
	IDELAYE2 #(
		.CINVCTRL_SEL("FALSE"),
		.DELAY_SRC("IDATAIN"),
		.HIGH_PERFORMANCE_MODE("TRUE"),
		.IDELAY_TYPE("VAR_LOAD"),
		.IDELAY_VALUE({27'd0, DELAY}),
		.PIPE_SEL("FALSE"),
		.REFCLK_FREQUENCY(199.5),
		.SIGNAL_PATTERN("DATA")
	) u_indelay(
		.DATAOUT(in_delayed),
		.DATAIN(1'b0),
		.C(byte_clock),
		.CE(1'b0),
		.INC(1'b0),
		.IDATAIN(in_se),
		.CNTVALUEIN(DELAY),
		.CNTVALUEOUT(),
		.CINVCTRL(1'b0),
		.LD(1'b1),
		.LDPIPEEN(1'b0),
		.REGRST(1'b0)
	);
	reg sreset;
	always @(posedge byte_clock) sreset <= reset;
	ISERDESE2 #(
		.DATA_RATE("DDR"),
		.DATA_WIDTH(8),
		.DYN_CLKDIV_INV_EN("FALSE"),
		.DYN_CLK_INV_EN("FALSE"),
		.INIT_Q1(1'b0),
		.INIT_Q2(1'b0),
		.INIT_Q3(1'b0),
		.INIT_Q4(1'b0),
		.INTERFACE_TYPE("NETWORKING"),
		.IOBDELAY("IFD"),
		.NUM_CE(1),
		.OFB_USED("FALSE"),
		.SERDES_MODE("MASTER"),
		.SRVAL_Q1(1'b0),
		.SRVAL_Q2(1'b0),
		.SRVAL_Q3(1'b0),
		.SRVAL_Q4(1'b0)
	) ideser(
		.RST(sreset),
		.Q1(serdes_out[7]),
		.Q2(serdes_out[6]),
		.Q3(serdes_out[5]),
		.Q4(serdes_out[4]),
		.Q5(serdes_out[3]),
		.Q6(serdes_out[2]),
		.Q7(serdes_out[1]),
		.Q8(serdes_out[0]),
		.BITSLIP(1'b0),
		.CE1(1'b1),
		.CE2(1'b1),
		.CLKDIVP(1'b0),
		.CLK(bit_clock),
		.CLKB(~bit_clock),
		.CLKDIV(byte_clock),
		.OCLK(1'b0),
		.DYNCLKDIVSEL(1'b0),
		.DYNCLKSEL(1'b0),
		.D(1'b0),
		.DDLY(in_delayed),
		.OFB(1'b0),
		.OCLKB(1'b0),
		.SHIFTIN1(1'b0),
		.SHIFTIN2(1'b0),
		.SHIFTOUT1(),
		.SHIFTOUT2(),
		.O()
	);
	assign deser_out = (INVERT == 1'b1 ? ~serdes_out : serdes_out);
endmodule
