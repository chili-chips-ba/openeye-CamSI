module afifo_ctrl (
	i_wclk,
	i_wrst_n,
	i_wr,
	o_wr,
	o_wfull,
	o_waddr,
	i_rclk,
	i_rrst_n,
	i_rd,
	o_rd,
	o_rempty,
	o_raddr
);
	parameter DW = 8;
	parameter AW = 8;
	input wire i_wclk;
	input wire i_wrst_n;
	input wire i_wr;
	output wire o_wr;
	output wire o_wfull;
	output wire [AW - 1:0] o_waddr;
	input wire i_rclk;
	input wire i_rrst_n;
	input wire i_rd;
	output wire o_rd;
	output wire o_rempty;
	output wire [AW - 1:0] o_raddr;
	reg [AW:0] wgray;
	reg [AW:0] wbin;
	reg [AW:0] wq2_rgray;
	reg [AW:0] wq1_rgray;
	reg [AW:0] rgray;
	reg [AW:0] rbin;
	reg [AW:0] rq2_wgray;
	reg [AW:0] rq1_wgray;
	wire [AW:0] wgray_next;
	wire [AW:0] wbin_next;
	wire [AW:0] rgray_next;
	wire [AW:0] rbin_next;
	always @(posedge i_wclk)
		if (i_wrst_n == 1'b0)
			{wq2_rgray, wq1_rgray} <= 1'sb0;
		else
			{wq2_rgray, wq1_rgray} <= {wq1_rgray, rgray};
	function automatic [(AW >= 0 ? AW + 1 : 1 - AW) - 1:0] sv2v_cast_ECEF9;
		input reg [(AW >= 0 ? AW + 1 : 1 - AW) - 1:0] inp;
		sv2v_cast_ECEF9 = inp;
	endfunction
	assign wbin_next = sv2v_cast_ECEF9(wbin + {{AW {1'b0}}, o_wr});
	assign wgray_next = (wbin_next >> 1) ^ wbin_next;
	assign o_waddr = wbin[AW - 1:0];
	always @(posedge i_wclk)
		if (i_wrst_n == 1'b0)
			{wbin, wgray} <= 1'sb0;
		else
			{wbin, wgray} <= {wbin_next, wgray_next};
	assign o_wfull = wgray == {~wq2_rgray[AW:AW - 1], wq2_rgray[AW - 2:0]};
	assign o_wr = i_wr & ~o_wfull;
	always @(posedge i_rclk)
		if (i_rrst_n == 1'b0)
			{rq2_wgray, rq1_wgray} <= 1'sb0;
		else
			{rq2_wgray, rq1_wgray} <= {rq1_wgray, wgray};
	assign rbin_next = sv2v_cast_ECEF9(rbin + {{AW {1'b0}}, o_rd});
	assign rgray_next = (rbin_next >> 1) ^ rbin_next;
	always @(posedge i_rclk)
		if (i_rrst_n == 1'b0)
			{rbin, rgray} <= 1'sb0;
		else
			{rbin, rgray} <= {rbin_next, rgray_next};
	assign o_raddr = rbin[AW - 1:0];
	assign o_rempty = rgray == rq2_wgray;
	assign o_rd = i_rd & ~o_rempty;
endmodule
