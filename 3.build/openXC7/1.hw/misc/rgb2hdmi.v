module rgb2hdmi (
	csi_clk,
	reset,
	csi_in_line,
	csi_in_frame,
	rgb_pix,
	rgb_reading,
	rgb_valid,
	hdmi_clk,
	hdmi_frame,
	hdmi_blank,
	hdmi_reset_n,
	hdmi_pix
);
	input wire csi_clk;
	input wire reset;
	input wire csi_in_line;
	input wire csi_in_frame;
	input wire [23:0] rgb_pix;
	input wire rgb_reading;
	output reg rgb_valid;
	input wire hdmi_clk;
	input wire hdmi_frame;
	input wire hdmi_blank;
	output reg hdmi_reset_n;
	output wire [23:0] hdmi_pix;
	reg csi_in_line_dly;
	reg [10:0] csi_line_count;
	always @(posedge csi_clk)
		if (reset == 1'b1) begin
			csi_in_line_dly <= 1'b0;
			csi_line_count <= 1'sb0;
			rgb_valid <= 1'b0;
			hdmi_reset_n <= 1'b0;
		end
		else begin
			csi_in_line_dly <= csi_in_line;
			rgb_valid <= csi_line_count >= 11'd3;
			hdmi_reset_n <= csi_line_count >= 11'd1;
			if (csi_in_frame == 1'b0)
				csi_line_count <= 11'd0;
			else if ({csi_in_line_dly, csi_in_line} == 2'b01) begin
				if (csi_line_count < 11'd1300)
					csi_line_count <= csi_line_count + 11'd1;
			end
		end
	axis_data_fifo u_afifo(
		.s_axis_aresetn(csi_in_frame | hdmi_frame),
		.s_axis_aclk(csi_clk),
		.s_axis_tvalid(rgb_reading),
		.s_axis_tready(),
		.s_axis_tdata(rgb_pix),
		.m_axis_aclk(hdmi_clk),
		.m_axis_tvalid(),
		.m_axis_tready(~hdmi_blank),
		.m_axis_tdata(hdmi_pix)
	);
endmodule
