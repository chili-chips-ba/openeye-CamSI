module csi_rx_12bit_unpack (
	clock,
	reset,
	enable,
	data_in,
	din_valid,
	data_out,
	dout_valid
);
	input wire clock;
	input wire reset;
	input wire enable;
	input wire [31:0] data_in;
	input wire din_valid;
	localparam top_pkg_NUM_LANE = 2;
	output reg [15:0] data_out;
	output reg dout_valid;
	reg [47:0] dout_int;
	reg [47:0] dout_unpacked;
	reg [31:0] bytes_int;
	reg [1:0] byte_count_int;
	reg dout_valid_int;
	reg dout_valid_up;
	function [47:0] mipi12_unpack;
		input reg [47:0] packed_data;
		reg [47:0] result;
		begin
			result[11:0] = {packed_data[7:0], packed_data[19:16]};
			result[23:12] = {packed_data[15:8], packed_data[23:20]};
			result[35:24] = {packed_data[31:24], packed_data[43:40]};
			result[47:36] = {packed_data[39:32], packed_data[47:44]};
			mipi12_unpack = result;
		end
	endfunction
	always @(posedge clock or posedge reset)
		if (reset == 1'b1) begin
			dout_int <= 1'sb0;
			byte_count_int <= 1'sb0;
			dout_valid_int <= 1'b0;
		end
		else if (enable == 1'b1) begin
			if (din_valid == 1'b1)
				case (byte_count_int)
					0: begin
						dout_int <= 1'sb0;
						byte_count_int <= 3'd2;
						dout_valid_int <= 1'b0;
						bytes_int <= data_in;
					end
					1: begin
						dout_int <= {data_in[31:0], bytes_int[15:0]};
						byte_count_int <= 3'd0;
						dout_valid_int <= 1'b1;
						bytes_int <= 1'sb0;
					end
					2: begin
						dout_int <= {data_in[15:0], bytes_int[31:0]};
						byte_count_int <= 3'd1;
						dout_valid_int <= 1'b1;
						bytes_int <= {16'd0, data_in[31:16]};
					end
				endcase
			else begin
				byte_count_int <= 1'sb0;
				dout_valid_int <= 1'b0;
			end
			dout_unpacked <= mipi12_unpack(dout_int);
			dout_valid_up <= dout_valid_int;
			data_out <= dout_unpacked;
			dout_valid <= dout_valid_up;
		end
endmodule
