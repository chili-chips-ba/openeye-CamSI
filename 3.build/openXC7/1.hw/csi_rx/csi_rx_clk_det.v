module csi_rx_clk_det (
	ref_clock,
	byte_clock,
	reset_in,
	enable,
	reset_out
);
	input wire ref_clock;
	input wire byte_clock;
	input wire reset_in;
	input wire enable;
	output reg reset_out;
	reg [1:0] byte_clk_demet;
	reg [3:0] byte_clk_cnt;
	reg byte_clk_fail;
	reg reset_in_demet;
	always @(posedge ref_clock) reset_in_demet <= reset_in;
	always @(posedge reset_in_demet or posedge ref_clock)
		if (reset_in_demet == 1'b1)
			byte_clk_fail <= 1'b1;
		else
			byte_clk_fail <= byte_clk_cnt >= 4'd10;
	always @(posedge ref_clock) begin
		byte_clk_demet <= {byte_clk_demet[0], byte_clock};
		if (^byte_clk_demet == 1'b1)
			byte_clk_cnt <= 1'sb0;
		else if (byte_clk_fail == 1'b0)
			byte_clk_cnt <= byte_clk_cnt + 4'd1;
	end
	reg [1:0] rst_cnt;
	always @(posedge byte_clk_fail or posedge byte_clock)
		if (byte_clk_fail == 1'b1)
			rst_cnt <= 1'sb0;
		else if ({enable, reset_out} == 2'b11)
			rst_cnt <= rst_cnt + 2'd1;
	always @(posedge byte_clock) reset_out <= rst_cnt < 2'd2;
endmodule
