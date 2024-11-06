module isp_top (
	clk,
	rst,
	data_in,
	data_valid,
	rgb_valid,
	reading,
	rgb_out
);
	parameter LINE_LENGTH = 640;
	parameter RGB_WIDTH = 24;
	input wire clk;
	input wire rst;
	localparam top_pkg_NUM_LANE = 2;
	input wire [15:0] data_in;
	input wire data_valid;
	input wire rgb_valid;
	output wire reading;
	output wire [RGB_WIDTH - 1:0] rgb_out;
	localparam signed [31:0] hdmi_pkg_HSCREEN = 1280;
	raw2rgb_8 #(
		.LINE_LENGTH(640),
		.RGB_WIDTH(RGB_WIDTH)
	) u_raw2rgb(
		.clk(clk),
		.rst(rst),
		.data_in(data_in),
		.data_valid(data_valid),
		.rgb_valid(rgb_valid),
		.reading(reading),
		.rgb_out(rgb_out)
	);
endmodule
