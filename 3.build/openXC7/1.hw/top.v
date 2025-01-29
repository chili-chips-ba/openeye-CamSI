module top (
	areset,
	clk_ext,
	i2c_sda,
	i2c_scl,
	cam_dphy_clk,
	cam_dphy_dat,
	cam_en,
	hdmi_clk_p,
	hdmi_clk_n,
	hdmi_dat_p,
	hdmi_dat_n,
	led,
	//debug_pins
);
	input wire areset;
	input wire clk_ext;
	inout wire i2c_sda;
	inout wire i2c_scl;
	input wire [1:0] cam_dphy_clk;
	localparam top_pkg_NUM_LANE = 2;
	input wire [3:0] cam_dphy_dat;
	output wire cam_en;
	output wire hdmi_clk_p;
	output wire hdmi_clk_n;
	output wire [2:0] hdmi_dat_p;
	output wire [2:0] hdmi_dat_n;
	output wire [2:0] led;
	//output wire [15:0] debug_pins;
	wire reset;
	wire i2c_areset_n;
	wire clk_100;
	wire clk_180;
	wire clk_200;
	wire clk_1hz;
	wire strobe_400kHz;
	clkrst_gen u_clkrst_gen(
		.reset_ext(areset),
		.clk_ext(clk_ext),
		.clk_100(clk_100),
		.clk_180(clk_180),
		.clk_200(clk_200),
		.clk_1hz(clk_1hz),
		.strobe_400kHz(strobe_400kHz),
		.reset(reset),
		.cam_en(cam_en),
		.i2c_areset_n(i2c_areset_n)
	);
	wire [7:0] debug_i2c;
	localparam [6:0] top_pkg_I2C_SLAVE_ADDR = 7'd16;
	localparam signed [31:0] top_pkg_NUM_REGISTERS = 65;
	i2c_top #(
		.I2C_SLAVE_ADDR(top_pkg_I2C_SLAVE_ADDR),
		.NUM_REGISTERS(top_pkg_NUM_REGISTERS)
	) u_i2c(
		.clk(clk_100),
		.strobe_400kHz(strobe_400kHz),
		.areset_n(i2c_areset_n),
		.i2c_scl(i2c_scl),
		.i2c_sda(i2c_sda),
		.debug_pins(debug_i2c)
	);
	wire csi_byte_clk;
	wire [15:0] csi_word_data;
	wire csi_word_valid;
	wire csi_in_line;
	wire csi_in_frame;
	wire [7:0] debug_csi;
	csi_rx_top u_csi_rx_top(
		.ref_clock(clk_200),
		.reset(reset),
		.clk_1hz(clk_1hz),
		.cam_dphy_clk(cam_dphy_clk),
		.cam_dphy_dat(cam_dphy_dat),
		.cam_en(cam_en),
		.csi_byte_clk(csi_byte_clk),
		.csi_unpack_raw_dat(csi_word_data),
		.csi_unpack_raw_dat_vld(csi_word_valid),
		.csi_in_line(csi_in_line),
		.csi_in_frame(csi_in_frame),
		.debug_pins(debug_csi)
	);
	wire rgb_valid;
	wire [23:0] rgb_pix;
	wire rgb_reading;
	localparam signed [31:0] hdmi_pkg_HSCREEN = 1280;
	isp_top #(
		.LINE_LENGTH(640),
		.RGB_WIDTH(24)
	) u_isp(
		.clk(csi_byte_clk),
		.rst(reset),
		.data_in(csi_word_data),
		.data_valid(csi_word_valid),
		.rgb_valid(rgb_valid),
		.reading(rgb_reading),
		.rgb_out(rgb_pix)
	);
	wire hdmi_clk;
	wire hdmi_frame;
	wire hdmi_blank;
	wire hdmi_reset_n;
	wire [23:0] hdmi_pix;
	wire [3:0] debug_fifo;
	rgb2hdmi u_rgb2hdmi(
		.csi_clk(csi_byte_clk),
		.reset(reset),
		.csi_in_line(csi_in_line),
		.csi_in_frame(csi_in_frame),
		.rgb_pix(rgb_pix),
		.rgb_reading(rgb_reading),
		.rgb_valid(rgb_valid),
		.hdmi_clk(hdmi_clk),
		.hdmi_frame(hdmi_frame),
		.hdmi_blank(hdmi_blank),
		.hdmi_reset_n(hdmi_reset_n),
		.hdmi_pix(hdmi_pix),
		.debug_fifo(debug_fifo)
	);
	wire hdmi_hsync;
	wire hdmi_vsync;
	wire [11:0] x;
	wire [10:0] y;
	hdmi_top u_hdmi_top(
		.clk_ext(clk_100),
		.clk_pix(hdmi_clk),
		.pix(hdmi_pix),
		.hdmi_reset_n(hdmi_reset_n),
		.hdmi_frame(hdmi_frame),
		.blank(hdmi_blank),
		.vsync(hdmi_vsync),
		.hsync(hdmi_hsync),
		.hdmi_clk_p(hdmi_clk_p),
		.hdmi_clk_n(hdmi_clk_n),
		.hdmi_dat_p(hdmi_dat_p),
		.hdmi_dat_n(hdmi_dat_n),
		.x(x),
		.y(y)
	);
	assign led[0] = cam_en;
	assign led[1] = clk_1hz;
	assign led[2] = csi_in_frame;
	wire [7:0] debug_hdmi;
	assign debug_hdmi = {hdmi_reset_n, hdmi_frame, hdmi_hsync, hdmi_vsync, hdmi_blank, hdmi_clk, rgb_valid, 1'b0};
	//assign debug_pins = {debug_hdmi[7:0], debug_csi[7:0]};
endmodule
