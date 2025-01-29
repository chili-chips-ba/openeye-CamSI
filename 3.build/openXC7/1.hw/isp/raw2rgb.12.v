module raw2rgb_12 (
	clk,
	rst,
	data_in,
	data_valid,
	rgb_valid,
	reading,
	rgb_out
);
	reg _sv2v_0;
	parameter LINE_LENGTH = 640;
	parameter RGB_WIDTH = 24;
	input wire clk;
	input wire rst;
	localparam top_pkg_NUM_LANE = 2;
	input wire [15:0] data_in;
	input wire data_valid;
	input wire rgb_valid;
	output reg reading;
	output wire [RGB_WIDTH - 1:0] rgb_out;
	localparam CNT_WIDTH = $clog2(LINE_LENGTH);
	reg [CNT_WIDTH - 1:0] write_count;
	reg writing;
	reg [1:0] wr_line_sel;
	function automatic [CNT_WIDTH - 1:0] sv2v_cast_1924C;
		input reg [CNT_WIDTH - 1:0] inp;
		sv2v_cast_1924C = inp;
	endfunction
	always @(posedge clk)
		if (rst == 1'b1) begin
			write_count <= 1'sb0;
			writing <= 1'b0;
			wr_line_sel <= 1'sb0;
		end
		else if ({data_valid, writing} == 2'b10)
			writing <= 1'b1;
		else if (writing == 1'b1) begin
			if (write_count < sv2v_cast_1924C(LINE_LENGTH - 1)) begin
				if (data_valid == 1'b1)
					write_count <= sv2v_cast_1924C(write_count + sv2v_cast_1924C(1));
			end
			else begin
				write_count <= 1'sb0;
				writing <= 1'b0;
				wr_line_sel <= wr_line_sel + 2'd1;
			end
		end
	reg [3:0] wen;
	(* ram_style = "block" *) reg [15:0] line0_mem [LINE_LENGTH:0];
	(* ram_style = "block" *) reg [15:0] line1_mem [LINE_LENGTH:0];
	(* ram_style = "block" *) reg [15:0] line2_mem [LINE_LENGTH:0];
	(* ram_style = "block" *) reg [15:0] line3_mem [LINE_LENGTH:0];
	function automatic signed [1:0] sv2v_cast_2_signed;
		input reg signed [1:0] inp;
		sv2v_cast_2_signed = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 4; i = i + 1)
				wen[i] = (writing & data_valid) & (wr_line_sel == sv2v_cast_2_signed(i));
		end
	end
	always @(posedge clk) begin
		if (wen[0] == 1'b1)
			line0_mem[write_count] <= data_in;
		if (wen[1] == 1'b1)
			line1_mem[write_count] <= data_in;
		if (wen[2] == 1'b1)
			line2_mem[write_count] <= data_in;
		if (wen[3] == 1'b1)
			line3_mem[write_count] <= data_in;
	end
	reg [CNT_WIDTH - 1:0] read_count;
	wire [CNT_WIDTH - 1:0] read_count_nxt;
	assign read_count_nxt = sv2v_cast_1924C(read_count + sv2v_cast_1924C(1));
	reg odd_pixel;
	wire line_end;
	reg temp_4lane;
	reg [1:0] line_not_read;
	always @(posedge clk)
		if (rgb_valid == 1'b0) begin
			read_count <= 1'sb0;
			reading <= 1'b0;
			odd_pixel <= 1'b0;
			line_not_read <= 2'd3;
			temp_4lane <= 1'b0;
		end
		else if ({data_valid, reading} == 2'b10)
			reading <= 1'b1;
		else if (reading == 1'b1) begin
			if ((odd_pixel == 1'b1) && (read_count == sv2v_cast_1924C(LINE_LENGTH - 1))) begin
				read_count <= 1'sb0;
				reading <= 1'b0;
				odd_pixel <= 1'b0;
				line_not_read <= line_not_read + 2'd1;
				temp_4lane <= 1'b0;
			end
			else begin
				if (odd_pixel == 1'b1)
					temp_4lane <= ~temp_4lane;
				if (odd_pixel == 1'b1)
					read_count <= read_count_nxt;
				odd_pixel <= ~odd_pixel;
			end
		end
	reg [11:0] line0_green0;
	reg [11:0] line0_blue0;
	reg [11:0] line0_green1;
	reg [11:0] line0_blue1;
	reg [11:0] line1_red0;
	reg [11:0] line1_green0;
	reg [11:0] line1_red1;
	reg [11:0] line1_green1;
	reg [11:0] line2_green0;
	reg [11:0] line2_blue0;
	reg [11:0] line2_green1;
	reg [11:0] line2_blue1;
	reg [11:0] line3_red0;
	reg [11:0] line3_green0;
	reg [11:0] line3_red1;
	reg [11:0] line3_green1;
	always @(posedge clk)
		if (reading == 1'b1) begin
			line0_green0 <= line0_mem[read_count][23:12];
			line0_blue0 <= line0_mem[read_count][11:0];
			line0_green1 <= line0_mem[read_count_nxt][23:12];
			line0_blue1 <= line0_mem[read_count_nxt][11:0];
			line1_red0 <= line1_mem[read_count][23:12];
			line1_green0 <= line1_mem[read_count][11:0];
			line1_red1 <= line1_mem[read_count_nxt][23:12];
			line1_green1 <= line1_mem[read_count_nxt][11:0];
			line2_green0 <= line2_mem[read_count][23:12];
			line2_blue0 <= line2_mem[read_count][11:0];
			line2_green1 <= line2_mem[read_count_nxt][23:12];
			line2_blue1 <= line2_mem[read_count_nxt][11:0];
			line3_red0 <= line3_mem[read_count][23:12];
			line3_green0 <= line3_mem[read_count][11:0];
			line3_red1 <= line3_mem[read_count_nxt][23:12];
			line3_green1 <= line3_mem[read_count_nxt][11:0];
		end
	reg [RGB_WIDTH - 1:0] rgb_out1;
	always @(posedge clk)
		if (reading == 1'b1)
			(* full_case, parallel_case *)
			case (line_not_read)
				2'd3:
					if (odd_pixel == 1'b0) begin
						rgb_out1[23:16] <= (line1_red0 >> 5) + (line1_red1 >> 5);
						rgb_out1[15:8] <= (((line0_green0 >> 6) + (line0_green1 >> 6)) + (line2_green0 >> 6)) + (line2_green1 >> 6);
						rgb_out1[7:0] <= (line0_blue0 >> 5) + (line2_blue0 >> 5);
					end
					else begin
						rgb_out1[23:16] <= line1_red1 >> 4;
						rgb_out1[15:8] <= (((line0_green1 >> 6) + (line1_green0 >> 6)) + (line1_green1 >> 6)) + (line2_green1 >> 6);
						rgb_out1[7:0] <= (((line0_blue0 >> 6) + (line0_blue1 >> 6)) + (line2_blue0 >> 6)) + (line2_blue1 >> 6);
					end
				2'd0:
					if (odd_pixel == 1'b0) begin
						rgb_out1[23:16] <= (((line1_red0 >> 6) + (line1_red1 >> 6)) + (line3_red0 >> 6)) + (line3_red1 >> 6);
						rgb_out1[15:8] <= (((line1_green0 >> 6) + (line2_green0 >> 6)) + (line2_green1 >> 6)) + (line3_green0 >> 6);
						rgb_out1[7:0] <= line2_blue0 >> 4;
					end
					else begin
						rgb_out1[23:16] <= (line1_red1 >> 5) + (line3_red1 >> 5);
						rgb_out1[15:8] <= (((line1_green0 >> 6) + (line1_green1 >> 6)) + (line3_green0 >> 6)) + (line3_green1 >> 6);
						rgb_out1[7:0] <= (line2_blue0 >> 5) + (line2_blue1 >> 5);
					end
				2'd1:
					if (odd_pixel == 1'b0) begin
						rgb_out1[23:16] <= (line3_red0 >> 5) + (line3_red1 >> 5);
						rgb_out1[15:8] <= (((line2_green0 >> 6) + (line2_green1 >> 6)) + (line0_green0 >> 6)) + (line0_green1 >> 6);
						rgb_out1[7:0] <= (line2_blue0 >> 5) + (line0_blue0 >> 5);
					end
					else begin
						rgb_out1[23:16] <= line3_red1 >> 4;
						rgb_out1[15:8] <= (((line2_green1 >> 6) + (line3_green0 >> 6)) + (line3_green1 >> 6)) + (line0_green1 >> 6);
						rgb_out1[7:0] <= (((line2_blue0 >> 6) + (line2_blue1 >> 6)) + (line0_blue0 >> 6)) + (line0_blue1 >> 6);
					end
				default:
					if (odd_pixel == 1'b0) begin
						rgb_out1[23:16] <= (((line3_red0 >> 6) + (line3_red1 >> 6)) + (line1_red0 >> 6)) + (line1_red1 >> 6);
						rgb_out1[15:8] <= (((line3_green0 >> 6) + (line0_green0 >> 6)) + (line0_green1 >> 6)) + (line1_green0 >> 6);
						rgb_out1[7:0] <= line0_blue0 >> 4;
					end
					else begin
						rgb_out1[23:16] <= (line3_red1 >> 5) + (line1_red1 >> 5);
						rgb_out1[15:8] <= (((line3_green0 >> 6) + (line3_green1 >> 6)) + (line1_green0 >> 6)) + (line1_green1 >> 6);
						rgb_out1[7:0] <= (line0_blue0 >> 5) + (line0_blue1 >> 5);
					end
			endcase
	assign rgb_out = {~rgb_out1[7:0], rgb_out1[15:8], ~rgb_out1[23:16]};
	initial _sv2v_0 = 0;
endmodule
