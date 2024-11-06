module hdmi_tdms_enc (
	clk,
	blank,
	raw,
	encoded
);
	reg _sv2v_0;
	input wire clk;
	input wire blank;
	input wire [9:0] raw;
	output reg [9:0] encoded;
	reg [8:0] xored;
	reg [8:0] xnord;
	reg [3:0] num_ones;
	reg [8:0] data;
	reg [8:0] data_n;
	reg [3:0] data_disparity;
	reg [3:0] dc_bias;
	reg [3:0] dc_bias_plus;
	reg [3:0] dc_bias_minus;
	always @(*) begin : _comb
		if (_sv2v_0)
			;
		xored[0] = raw[0];
		xnord[0] = raw[0];
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 1; i < 8; i = i + 1)
				begin
					xored[i] = raw[0 + i] ^ xored[i - 1];
					xnord[i] = ~(raw[0 + i] ^ xnord[i - 1]);
				end
		end
		xored[8] = 1'b1;
		xnord[8] = 1'b0;
		num_ones = 4'd0;
		begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < 8; i = i + 1)
				num_ones = num_ones + {3'd0, raw[0 + i]};
		end
		if ((num_ones > 4'd4) || ({num_ones, raw[0]} == 5'h08)) begin
			data = xnord;
			data_n = ~xnord;
		end
		else begin
			data = xored;
			data_n = ~xored;
		end
		data_disparity = 4'd12;
		begin : sv2v_autoblock_3
			reg signed [31:0] i;
			for (i = 0; i < 8; i = i + 1)
				data_disparity = data_disparity + {3'd0, data[i]};
		end
		dc_bias_plus = dc_bias + data_disparity;
		dc_bias_minus = dc_bias - data_disparity;
	end
	function automatic [3:0] sv2v_cast_4;
		input reg [3:0] inp;
		sv2v_cast_4 = inp;
	endfunction
	always @(posedge clk) begin : _flop
		if (blank == 1'b1) begin
			dc_bias <= 1'sb0;
			(* full_case, parallel_case *)
			case (raw[9-:2])
				2'd0: encoded <= 10'b1101010100;
				2'd1: encoded <= 10'b0010101011;
				2'd2: encoded <= 10'b0101010100;
				default: encoded <= 10'b1010101011;
			endcase
		end
		else if ((dc_bias == {4 {1'sb0}}) || (data_disparity == {4 {1'sb0}})) begin
			if (data[8] == 1'b1) begin
				dc_bias <= dc_bias_plus;
				encoded <= {2'b01, data[7:0]};
			end
			else begin
				dc_bias <= dc_bias_minus;
				encoded <= {2'b10, data_n[7:0]};
			end
		end
		else if (({dc_bias[3], data_disparity[3]} == 2'b00) || ({dc_bias[3], data_disparity[3]} == 2'b11)) begin
			encoded <= {1'b1, data[8], data_n[7:0]};
			dc_bias <= sv2v_cast_4(dc_bias_minus + {3'd0, data[8]});
		end
		else begin
			encoded <= {1'b0, data};
			dc_bias <= sv2v_cast_4(dc_bias_plus - {3'd0, data_n[8]});
		end
	end
	initial _sv2v_0 = 0;
endmodule
