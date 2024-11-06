module fpga_oser10 (
	arst,
	clk_par,
	clk_ser,
	d,
	q,
	unused_ofb,
	unused_oq
);
	input wire arst;
	input wire clk_par;
	input wire clk_ser;
	input wire [9:0] d;
	output wire q;
	output wire unused_ofb;  // Dummy signal za OFB
	output wire unused_oq;   // Dummy signal za OQ
	assign unused_ofb=d[0];
	assign unused_oq=d[1];
	wire shift1;
	wire shift2;
	OSERDESE2 #(
		.DATA_RATE_OQ("DDR"),
		.DATA_RATE_TQ("DDR"),
		.DATA_WIDTH(10),
		.INIT_OQ(1'b1),
		.INIT_TQ(1'b1),
		.SERDES_MODE("MASTER"),
		.SRVAL_OQ(1'b0),
		.SRVAL_TQ(1'b0),
		.TBYTE_CTL("FALSE"),
		.TBYTE_SRC("FALSE"),
		.TRISTATE_WIDTH(1)
	) master_oserdese(
		.OFB(),
		.SHIFTOUT1(),
		.SHIFTOUT2(),
		.TBYTEOUT(),
		.TFB(),
		.TQ(),
		.OQ(q),
		.CLK(clk_ser),
		.CLKDIV(clk_par),
		.D1(d[0]),
		.D2(d[1]),
		.D3(d[2]),
		.D4(d[3]),
		.D5(d[4]),
		.D6(d[5]),
		.D7(d[6]),
		.D8(d[7]),
		.OCE(1'b1),
		.RST(arst),
		.SHIFTIN1(shift1),
		.SHIFTIN2(shift2),
		.T1(1'b0),
		.T2(1'b0),
		.T3(1'b0),
		.T4(1'b0),
		.TBYTEIN(1'b0),
		.TCE(1'b0)
	);
	OSERDESE2 #(
		.DATA_RATE_OQ("DDR"),
		.DATA_RATE_TQ("DDR"),
		.DATA_WIDTH(10),
		.INIT_OQ(1'b1),
		.INIT_TQ(1'b1),
		.SERDES_MODE("SLAVE"),
		.SRVAL_OQ(1'b0),
		.SRVAL_TQ(1'b0),
		.TBYTE_CTL("FALSE"),
		.TBYTE_SRC("FALSE"),
		.TRISTATE_WIDTH(1)
	) slave_oserdese(
		.OFB(unused_ofb),
		.OQ(unused_oq),
		.SHIFTOUT1(shift1),
		.SHIFTOUT2(shift2),
		.TBYTEOUT(),
		.TFB(),
		.TQ(),
		.CLK(clk_ser),
		.CLKDIV(clk_par),
		.D1(1'b0),
		.D2(1'b0),
		.D3(d[8]),
		.D4(d[9]),
		.D5(1'b0),
		.D6(1'b0),
		.D7(1'b0),
		.D8(1'b0),
		.OCE(1'b1),
		.RST(arst),
		.SHIFTIN1(1'b0),
		.SHIFTIN2(1'b0),
		.T1(1'b0),
		.T2(1'b0),
		.T3(1'b0),
		.T4(1'b0),
		.TBYTEIN(1'b0),
		.TCE(1'b0)
	);
endmodule
