module axis_data_fifo (
	s_axis_aresetn,
	s_axis_aclk,
	s_axis_tvalid,
	s_axis_tready,
	s_axis_tdata,
	m_axis_aclk,
	m_axis_tvalid,
	m_axis_tready,
	m_axis_tdata
);
	parameter DEPTH = 8192;
	parameter DW = 24;
	input wire s_axis_aresetn;
	input wire s_axis_aclk;
	input wire s_axis_tvalid;
	output wire s_axis_tready;
	input wire [DW - 1:0] s_axis_tdata;
	input wire m_axis_aclk;
	output reg m_axis_tvalid;
	input wire m_axis_tready;
	output wire [DW - 1:0] m_axis_tdata;
	localparam AW = $clog2(DEPTH);
	reg srst_n_sclk;
	reg srst_n_sclk_0;
	always @(negedge s_axis_aresetn or posedge s_axis_aclk)
		if (s_axis_aresetn == 1'b0)
			{srst_n_sclk, srst_n_sclk_0} <= 1'sb0;
		else
			{srst_n_sclk, srst_n_sclk_0} <= {srst_n_sclk_0, 1'b1};
	reg srst_n_mclk;
	reg srst_n_mclk_0;
	always @(negedge s_axis_aresetn or posedge m_axis_aclk)
		if (s_axis_aresetn == 1'b0)
			{srst_n_mclk, srst_n_mclk_0} <= 1'sb0;
		else
			{srst_n_mclk, srst_n_mclk_0} <= {srst_n_mclk_0, 1'b1};
	wire empty;
	wire full;
	wire wr;
	wire rd;
	wire [AW - 1:0] waddr;
	wire [AW - 1:0] raddr;
	assign s_axis_tready = ~full;
	afifo_ctrl #(
		.DW(DW),
		.AW(AW)
	) u_afifo_ctrl(
		.i_wclk(s_axis_aclk),
		.i_wrst_n(srst_n_sclk),
		.i_wr(s_axis_tvalid),
		.o_wr(wr),
		.o_wfull(full),
		.o_waddr(waddr),
		.i_rclk(m_axis_aclk),
		.i_rrst_n(srst_n_mclk),
		.i_rd(~m_axis_tvalid | m_axis_tready),
		.o_rd(rd),
		.o_rempty(empty),
		.o_raddr(raddr)
	);
	localparam sv2v_uu_ram_W = DW;
	localparam [(sv2v_uu_ram_W / 8) - 1:0] sv2v_uu_ram_ext_wea_1 = 1'sb1;
	localparam [(sv2v_uu_ram_W / 8) - 1:0] sv2v_uu_ram_ext_web_0 = 1'sb0;
	localparam [sv2v_uu_ram_W - 1:0] sv2v_uu_ram_ext_dinb_0 = 1'sb0;
	DP_BRAM #(
		.D(DEPTH),
		.W(DW)
	) ram(
		.clka(s_axis_aclk),
		.ena(wr),
		.addra(waddr),
		.wea(sv2v_uu_ram_ext_wea_1),
		.dina(s_axis_tdata),
		.douta(),
		.clkb(m_axis_aclk),
		.enb(rd),
		.addrb(raddr),
		.web(sv2v_uu_ram_ext_web_0),
		.dinb(sv2v_uu_ram_ext_dinb_0),
		.doutb(m_axis_tdata)
	);
	always @(posedge m_axis_aclk) m_axis_tvalid <= ~empty;
endmodule
