module csi_rx_align_word (
	byte_clock,
	reset,
	enable,
	packet_done,
	wait_for_sync,
	word_in,
	valid_in,
	packet_done_out,
	word_out,
	valid_out
);
	reg _sv2v_0;
	input wire byte_clock;
	input wire reset;
	input wire enable;
	input wire packet_done;
	input wire wait_for_sync;
	localparam top_pkg_NUM_LANE = 2;
	input wire [15:0] word_in;
	input wire [1:0] valid_in;
	output reg packet_done_out;
	output reg [15:0] word_out;
	output reg valid_out;
	reg [15:0] word_dly_1;
	reg [15:0] word_dly_2;
	reg [1:0] valid_dly_1;
	reg [1:0] valid_dly_2;
	reg [3:0] taps;
	reg valid;
	reg valid_in_all;
	reg is_triggered;
	always @(*) begin
		if (_sv2v_0)
			;
		valid_in_all = &valid_in;
		is_triggered = 1'b0;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i <= 1; i = i + 1)
				if ({valid_in[i], valid_dly_1[i], valid_dly_2[i]} == 3'b111)
					is_triggered = 1'b1;
		end
		packet_done_out = packet_done | (is_triggered & ~valid_in_all);
	end
	always @(posedge byte_clock) begin : ff
		word_dly_1 <= word_in;
		word_dly_2 <= word_dly_1;
		valid_dly_1 <= valid_in;
		valid_dly_2 <= valid_dly_1;
		if (reset == 1'b1)
			valid <= 1'sb0;
		else if (enable == 1'b1) begin
			if ({valid_in_all, valid, wait_for_sync} == 3'b101) begin
				valid <= 1'b1;
				begin : sv2v_autoblock_2
					reg signed [31:0] i;
					for (i = 0; i <= 1; i = i + 1)
						if (valid_dly_2[i] == 1'b1)
							taps[i * 2+:2] <= 2'd2;
						else if (valid_dly_1[i] == 1'b1)
							taps[i * 2+:2] <= 2'd1;
						else
							taps[i * 2+:2] <= 2'd0;
				end
			end
			else if (packet_done == 1'b1)
				valid <= 1'b0;
		end
		if (valid == 1'b1) begin : sv2v_autoblock_3
			reg signed [31:0] i;
			for (i = 0; i <= 1; i = i + 1)
				(* full_case, parallel_case *)
				case (taps[i * 2+:2])
					2'd2: word_out[i * 8+:8] <= word_dly_2[i * 8+:8];
					2'd1: word_out[i * 8+:8] <= word_dly_1[i * 8+:8];
					default: word_out[i * 8+:8] <= word_in[i * 8+:8];
				endcase
		end
		valid_out <= valid;
	end
	initial _sv2v_0 = 0;
endmodule
