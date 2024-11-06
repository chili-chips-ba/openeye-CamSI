module csi_rx_packet_handler (
	clock,
	reset,
	enable,
	data,
	data_valid,
	sync_wait,
	packet_done,
	payload_out,
	payload_valid,
	sync_seq,
	in_frame,
	in_line,
	ecc_out,
	debug_out
);
	reg _sv2v_0;
	input wire clock;
	input wire reset;
	input wire enable;
	localparam top_pkg_NUM_LANE = 2;
	input wire [15:0] data;
	input wire data_valid;
	output wire sync_wait;
	output wire packet_done;
	output wire [15:0] payload_out;
	output wire payload_valid;
	output reg sync_seq;
	output reg in_frame;
	output reg in_line;
	output reg ecc_out;
	output wire [1:0] debug_out;
	reg [2:0] state;
	reg is_hdr;
	reg [31:0] packet_data;
	reg [5:0] packet_type;
	reg [15:0] packet_len;
	reg [15:0] packet_len_q;
	reg [23:0] packet_for_ecc;
	reg long_packet;
	reg valid_packet;
	reg [15:0] bytes_read;
	function is_allowed_type;
		input reg [5:0] packet_type;
		reg result;
		begin
			result = 1'b0;
			if (|{packet_type == 6'h00, packet_type == 6'h01, packet_type == 6'h02, packet_type == 6'h03, packet_type == 6'h10, packet_type == 6'h11, packet_type == 6'h12, packet_type == 6'h28, packet_type == 6'h29, packet_type == 6'h2a, packet_type == 6'h2b, packet_type == 6'h2c, packet_type == 6'h2d})
				result = 1'b1;
			is_allowed_type = result;
		end
	endfunction
	wire [7:0] expected_ecc;
	always @(*) begin
		if (_sv2v_0)
			;
		is_hdr = {data_valid, state} == 4'hd;
		packet_type = packet_data[5:0];
		packet_len = packet_data[23:8];
		packet_for_ecc = packet_data[23:0];
		valid_packet = ((packet_data[31:24] == expected_ecc) & is_allowed_type(packet_type)) & (packet_data[7:6] == 2'd0);
		ecc_out = packet_data[31:24] == expected_ecc;
		long_packet = (packet_type > 6'h0f) & valid_packet;
	end
	csi_rx_hdr_ecc u_ecc(
		.data(packet_for_ecc),
		.ecc(expected_ecc)
	);
	always @(posedge clock)
		if (reset == 1'b1) begin
			state <= 3'd0;
			sync_seq <= 1'b0;
			bytes_read <= 1'sb0;
			packet_data <= 1'sb0;
			packet_len_q <= 1'sb0;
		end
		else if (enable == 1'b1) begin
			packet_data <= {data, packet_data[31:16]};
			(* full_case, parallel_case *)
			case (state)
				3'd0: state <= 3'd1;
				3'd1: begin
					bytes_read <= 1'sb0;
					if (data_valid == 1'b1)
						state <= 3'd6;
				end
				3'd6: begin
					sync_seq <= 1'b1;
					state <= 3'd5;
				end
				3'd5: begin
					sync_seq <= 1'b0;
					packet_len_q <= packet_len;
					if (long_packet == 1'b0)
						state <= 3'd3;
					else
						state <= 3'd7;
				end
				3'd7: state <= 3'd2;
				3'd2:
					if ((bytes_read < (packet_len_q - (16'd1 * top_pkg_NUM_LANE))) && (bytes_read < 16'd8192))
						bytes_read <= bytes_read + (16'd1 * top_pkg_NUM_LANE);
					else
						state <= 3'd3;
				3'd3: state <= 3'd4;
				3'd4: state <= 3'd1;
				default: state <= 3'd0;
			endcase
		end
	always @(posedge clock)
		if (reset == 1'b1) begin
			in_frame <= 1'b0;
			in_line <= 1'b0;
		end
		else if (enable == 1'b1) begin
			if ({is_hdr, valid_packet, packet_type[5:1]} == 7'h60) begin
				if (packet_type[0] == 1'b0)
					in_frame <= 1'b1;
				else if (packet_type[0] == 1'b1)
					in_frame <= 1'b0;
			end
			if ({is_hdr, valid_packet, packet_type[5:4]} == 4'he)
				in_line <= 1'b1;
			else if (|{state == 3'd6, state == 3'd5, state == 3'd7, state == 3'd2} == 1'b0)
				in_line <= 1'b0;
		end
	assign sync_wait = state == 3'd1;
	assign payload_out = (state == 3'd2 ? packet_data[0+:16] : {16 {1'sb0}});
	assign packet_done = state == 3'd3;
	assign payload_valid = state == 3'd2;
	assign debug_out = {state == 3'd2, long_packet};
	initial _sv2v_0 = 0;
endmodule
