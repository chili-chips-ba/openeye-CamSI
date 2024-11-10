module fpga_olvds (
	i,
	o,
	ob
);
	input wire i;
	output wire o;
	output wire ob;
	OBUFDS #(
		.IOSTANDARD("TMDS_33"),
		.SLEW("FAST")
	) u_OBUFDS(
		.O(o),
		.OB(ob),
		.I(i)
	);
endmodule
