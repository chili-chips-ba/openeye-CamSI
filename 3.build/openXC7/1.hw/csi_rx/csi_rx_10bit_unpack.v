module csi_rx_10bit_unpack (
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
	reg [39:0] dout_int;
	reg [39:0] dout_unpacked;
	reg [31:0] bytes_int;
	reg [2:0] byte_count_int;
	reg dout_valid_int;
	reg dout_valid_up;
	function [39:0] mipi10_unpack;
		input reg [39:0] packed_data;
		reg [39:0] result;
		begin
			result[9:0] = {packed_data[7:0], packed_data[33:32]};
			result[19:10] = {packed_data[15:8], packed_data[35:34]};
			result[29:20] = {packed_data[23:16], packed_data[37:36]};
			result[39:30] = {packed_data[31:24], packed_data[39:38]};
			mipi10_unpack = result;
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
						byte_count_int <= 3'd4;
						dout_valid_int <= 1'b0;
						bytes_int <= data_in;
					end
					1: begin
						dout_int <= {data_in, bytes_int[7:0]};
						byte_count_int <= 3'd0;
						dout_valid_int <= 1'b1;
						bytes_int <= 1'sb0;
					end
					2: begin
						dout_int <= {data_in[23:0], bytes_int[15:0]};
						byte_count_int <= 3'd1;
						dout_valid_int <= 1'b1;
						bytes_int <= {24'd0, data_in[31:24]};
					end
					3: begin
						dout_int <= {data_in[15:0], bytes_int[23:0]};
						byte_count_int <= 3'd2;
						dout_valid_int <= 1'b1;
						bytes_int <= {16'd0, data_in[31:16]};
					end
					4: begin
						dout_int <= {data_in[7:0], bytes_int[31:0]};
						byte_count_int <= 3'd3;
						dout_valid_int <= 1'd1;
						bytes_int <= {8'd0, data_in[31:8]};
					end
				endcase
			else begin
				byte_count_int <= 1'sb0;
				dout_valid_int <= 1'b0;
			end
			dout_unpacked <= mipi10_unpack(dout_int);
			dout_valid_up <= dout_valid_int;
			data_out <= dout_unpacked;
			dout_valid <= dout_valid_up;
		end
endmodule
