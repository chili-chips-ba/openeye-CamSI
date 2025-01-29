module i2c_ctrl (
	clk,
	strobe_400kHz,
	areset_n,
	enable,
	slave_address,
	register_address,
	data_in,
	register_done,
	scl_oe,
	scl_di,
	sda_oe,
	sda_di,
	pause_duration
);
	input wire clk;
	input wire strobe_400kHz;
	input wire areset_n;
	input wire enable;
	input wire [6:0] slave_address;
	input wire [15:0] register_address;
	input wire [7:0] data_in;
	output reg register_done;
	output wire scl_oe;
	input wire scl_di;
	output wire sda_oe;
	input wire sda_di;
	input wire [7:0] pause_duration;
	reg [3:0] state;
	reg [3:0] post_state;
	reg scl_do;
	reg sda_do;
	reg [1:0] process_cnt;
	reg [7:0] slave_address_plus_rw;
	reg [3:0] bit_cnt;
	wire [3:0] bit_cnt_dec;
	reg post_serial_data;
	reg acknowledge_bit;
	reg [7:0] outer_counter;
	reg [8:0] inner_counter;
	assign bit_cnt_dec = bit_cnt - 4'd1;
	assign scl_oe = ~scl_do;
	assign sda_oe = ~((state == 4'd3) || (state == 4'd0) ? 1'b1 : sda_do);
	function automatic [8:0] sv2v_cast_9;
		input reg [8:0] inp;
		sv2v_cast_9 = inp;
	endfunction
	function automatic [7:0] sv2v_cast_8;
		input reg [7:0] inp;
		sv2v_cast_8 = inp;
	endfunction
	always @(negedge areset_n or posedge clk)
		if (areset_n == 1'b0) begin
			register_done <= 1'b0;
			state <= 4'd0;
			post_state <= 4'd0;
			process_cnt <= 1'sb0;
			slave_address_plus_rw <= 1'sb0;
			bit_cnt <= 1'sb0;
			post_serial_data <= 1'b0;
			acknowledge_bit <= 1'b0;
			scl_do <= 1'b1;
			sda_do <= 1'b1;
			outer_counter <= 1'sb0;
			inner_counter <= 1'sb0;
		end
		else
			(* full_case, parallel_case *)
			case (state)
				4'd0: begin
					process_cnt <= 1'sb0;
					bit_cnt <= 1'sb0;
					acknowledge_bit <= 1'b0;
					slave_address_plus_rw <= {slave_address, 1'b0};
					scl_do <= 1'b1;
					sda_do <= 1'b1;
					register_done <= 1'b0;
					if (enable == 1'b1) begin
						state <= 4'd1;
						post_state <= 4'd2;
					end
				end
				4'd1:
					if (strobe_400kHz == 1'b1)
						(* full_case, parallel_case *)
						case (process_cnt)
							2'd0: begin
								scl_do <= 1'b1;
								process_cnt <= 2'd1;
							end
							2'd1: begin
								sda_do <= 1'b0;
								process_cnt <= 2'd2;
							end
							2'd2: begin
								scl_do <= 1'b0;
								bit_cnt <= 4'd8;
								process_cnt <= 2'd3;
							end
							2'd3: begin
								process_cnt <= 2'd0;
								state <= post_state;
								sda_do <= slave_address_plus_rw[3'd7];
							end
						endcase
				4'd2:
					if (strobe_400kHz == 1'b1)
						(* full_case, parallel_case *)
						case (process_cnt)
							2'd0: begin
								scl_do <= 1'b1;
								process_cnt <= 2'd1;
							end
							2'd1:
								if (scl_di == 1'b1)
									process_cnt <= 2'd2;
							2'd2: begin
								scl_do <= 1'b0;
								bit_cnt <= bit_cnt_dec;
								process_cnt <= 2'd3;
							end
							2'd3: begin
								process_cnt <= 2'd0;
								if (bit_cnt == 4'd0) begin
									post_serial_data <= register_address[4'd15];
									state <= 4'd3;
									post_state <= 4'd4;
									bit_cnt <= 4'd8;
								end
								else
									sda_do <= slave_address_plus_rw[bit_cnt_dec[2:0]];
							end
						endcase
				4'd3:
					if (strobe_400kHz == 1'b1)
						(* full_case, parallel_case *)
						case (process_cnt)
							2'd0: begin
								scl_do <= 1'b1;
								process_cnt <= 2'd1;
							end
							2'd1:
								if (scl_di == 1'b1)
									process_cnt <= 2'd2;
							2'd2: begin
								scl_do <= 1'b0;
								if (sda_di == 1'b0)
									acknowledge_bit <= 1'b1;
								process_cnt <= 2'd3;
							end
							2'd3: begin
								if (acknowledge_bit == 1'b1) begin
									acknowledge_bit <= 1'b0;
									sda_do <= post_serial_data;
									state <= post_state;
								end
								else
									state <= 4'd8;
								process_cnt <= 2'd0;
							end
						endcase
				4'd4:
					if (strobe_400kHz == 1'b1)
						(* full_case, parallel_case *)
						case (process_cnt)
							2'd0: begin
								scl_do <= 1'b1;
								process_cnt <= 2'd1;
							end
							2'd1:
								if (scl_di == 1'b1)
									process_cnt <= 2'd2;
							2'd2: begin
								scl_do <= 1'b0;
								bit_cnt <= bit_cnt_dec;
								process_cnt <= 2'd3;
							end
							2'd3: begin
								if (bit_cnt == 4'd0) begin
									post_serial_data <= register_address[4'd7];
									state <= 4'd3;
									post_state <= 4'd5;
									bit_cnt <= 4'd8;
								end
								else
									sda_do <= register_address[bit_cnt + 4'd7];
								process_cnt <= 2'd0;
							end
						endcase
				4'd5:
					if (strobe_400kHz == 1'b1)
						(* full_case, parallel_case *)
						case (process_cnt)
							2'd0: begin
								scl_do <= 1'b1;
								process_cnt <= 2'd1;
							end
							2'd1:
								if (scl_di == 1'b1)
									process_cnt <= 2'd2;
							2'd2: begin
								scl_do <= 1'b0;
								bit_cnt <= bit_cnt_dec;
								process_cnt <= 2'd3;
							end
							2'd3: begin
								if (bit_cnt == 4'd0) begin
									post_serial_data <= data_in[3'd7];
									post_state <= 4'd6;
									state <= 4'd3;
									bit_cnt <= 4'd8;
								end
								else
									sda_do <= register_address[bit_cnt_dec];
								process_cnt <= 2'd0;
							end
						endcase
				4'd6:
					if (strobe_400kHz == 1'b1)
						(* full_case, parallel_case *)
						case (process_cnt)
							2'd0: begin
								scl_do <= 1'b1;
								process_cnt <= 2'd1;
							end
							2'd1:
								if (scl_di == 1'b1)
									process_cnt <= 2'd2;
							2'd2: begin
								scl_do <= 1'b0;
								bit_cnt <= bit_cnt_dec;
								process_cnt <= 2'd3;
							end
							2'd3: begin
								if (bit_cnt == 4'd0) begin
									post_serial_data <= 1'b0;
									state <= 4'd3;
									post_state <= 4'd7;
									bit_cnt <= 4'd8;
								end
								else
									sda_do <= data_in[bit_cnt_dec[2:0]];
								process_cnt <= 2'd0;
							end
						endcase
				4'd7:
					if (strobe_400kHz == 1'b1)
						(* full_case, parallel_case *)
						case (process_cnt)
							2'd0: begin
								scl_do <= 1'b1;
								process_cnt <= 2'd1;
							end
							2'd1:
								if (scl_di == 1'b1)
									process_cnt <= 2'd2;
							2'd2: begin
								sda_do <= 1'b1;
								process_cnt <= 2'd3;
								register_done <= 1'b1;
							end
							2'd3: begin
								outer_counter <= pause_duration;
								inner_counter <= 9'd400;
								process_cnt <= 2'd0;
								register_done <= 1'b0;
								state <= 4'd9;
							end
						endcase
				4'd9:
					if (strobe_400kHz == 1'b1) begin
						scl_do <= 1'b1;
						sda_do <= 1'b1;
						if (outer_counter > 8'd0) begin
							if (inner_counter > 9'd0)
								inner_counter <= sv2v_cast_9(inner_counter - 9'sd1);
							else begin
								inner_counter <= 9'd400;
								outer_counter <= sv2v_cast_8(outer_counter - 8'sd1);
							end
						end
						else
							state <= 4'd0;
					end
				4'd8:
					if (strobe_400kHz == 1'b1)
						(* full_case, parallel_case *)
						case (process_cnt)
							2'd0: begin
								scl_do <= 1'b1;
								process_cnt <= 2'd1;
							end
							2'd1:
								if (scl_di == 1'b1)
									process_cnt <= 2'd2;
							2'd2: begin
								sda_do <= 1'b1;
								process_cnt <= 2'd3;
							end
							2'd3: state <= 4'd0;
						endcase
			endcase
endmodule
