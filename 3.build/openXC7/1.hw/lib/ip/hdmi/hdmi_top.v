module hdmi_top (
	clk_ext,
	clk_pix,
	pix,
	hdmi_reset_n,
	hdmi_frame,
	blank,
	vsync,
	hsync,
	hdmi_clk_p,
	hdmi_clk_n,
	hdmi_dat_p,
	hdmi_dat_n,
	x,
	y
);
	input wire clk_ext;
	output wire clk_pix;
	input wire [23:0] pix;
	input wire hdmi_reset_n;
	output wire hdmi_frame;
	output wire blank;
	output wire vsync;
	output wire hsync;
	output wire hdmi_clk_p;
	output wire hdmi_clk_n;
	output wire [2:0] hdmi_dat_p;
	output wire [2:0] hdmi_dat_n;
	output wire [11:0] x;
	output wire [10:0] y;
	hdmi_backend u_hdmi_backend(
		.clk_ext(clk_ext),
		.clk_pix(clk_pix),
		.srst_n(),
		.hcount(x),
		.vcount(y),
		.pix(pix),
		.fifo_empty(1'b0),
		.hdmi_reset_n(hdmi_reset_n),
		.hdmi_frame(hdmi_frame),
		.blank(blank),
		.vsync(vsync),
		.hsync(hsync),
		.hdmi_clk_p(hdmi_clk_p),
		.hdmi_clk_n(hdmi_clk_n),
		.hdmi_dat_p(hdmi_dat_p),
		.hdmi_dat_n(hdmi_dat_n)
	);
endmodule
