module csi_rx_align_byte (
	clock,
	reset,
	enable,
	deser_in,
	wait_for_sync,
	packet_done,
	data_out,
	data_vld
);
	reg _sv2v_0;
	input wire clock;
	input wire reset;
	input wire enable;
	input wire [7:0] deser_in;
	input wire wait_for_sync;
	input wire packet_done;
	output reg [7:0] data_out;
	output reg data_vld;
	reg [7:0] curr_byte;
	reg [7:0] last_byte;
	reg [7:0] shifted_byte;
	reg found;
	reg [2:0] offset;
	reg [2:0] data_offs;
	always @(posedge clock) begin : _ff
		if (enable == 1'b1) begin
			curr_byte <= deser_in;
			last_byte <= curr_byte;
			data_out <= shifted_byte;
		end
		if (reset == 1'b1) begin
			data_vld <= 1'b0;
			data_offs <= 1'sb0;
		end
		else if (enable == 1'b1) begin
			if (packet_done == 1'b1)
				data_vld <= found;
			else if ({wait_for_sync, found, data_vld} == 3'b110) begin
				data_vld <= 1'b1;
				data_offs <= offset;
			end
		end
	end
	localparam [7:0] SYNC = 8'b10111000;
	always @(*) begin : _comb
		if (_sv2v_0)
			;
		found = 1'b0;
		offset = 3'd0;
		if ({curr_byte[0], last_byte} == {SYNC, 1'd0}) begin
			found = 1'b1;
			offset = 3'd0;
		end
		if ({curr_byte[1:0], last_byte} == {SYNC, 2'd0}) begin
			found = 1'b1;
			offset = 3'd1;
		end
		if ({curr_byte[2:0], last_byte} == {SYNC, 3'd0}) begin
			found = 1'b1;
			offset = 3'd2;
		end
		if ({curr_byte[3:0], last_byte} == {SYNC, 4'd0}) begin
			found = 1'b1;
			offset = 3'd3;
		end
		if ({curr_byte[4:0], last_byte} == {SYNC, 5'd0}) begin
			found = 1'b1;
			offset = 3'd4;
		end
		if ({curr_byte[5:0], last_byte} == {SYNC, 6'd0}) begin
			found = 1'b1;
			offset = 3'd5;
		end
		if ({curr_byte[6:0], last_byte} == {SYNC, 7'd0}) begin
			found = 1'b1;
			offset = 3'd6;
		end
		if (curr_byte[7:0] == SYNC) begin
			found = 1'b1;
			offset = 3'd7;
		end
		(* full_case, parallel_case *)
		case (data_offs)
			3'd7: shifted_byte = curr_byte;
			3'd6: shifted_byte = {curr_byte[6:0], last_byte[7]};
			3'd5: shifted_byte = {curr_byte[5:0], last_byte[7:6]};
			3'd4: shifted_byte = {curr_byte[4:0], last_byte[7:5]};
			3'd3: shifted_byte = {curr_byte[3:0], last_byte[7:4]};
			3'd2: shifted_byte = {curr_byte[2:0], last_byte[7:3]};
			3'd1: shifted_byte = {curr_byte[1:0], last_byte[7:2]};
			default: shifted_byte = {curr_byte[0], last_byte[7:1]};
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
