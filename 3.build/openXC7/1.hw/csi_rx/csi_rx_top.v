module csi_rx_top (
	ref_clock,
	reset,
	clk_1hz,
	cam_dphy_clk,
	cam_dphy_dat,
	cam_en,
	csi_byte_clk,
	csi_unpack_raw_dat,
	csi_unpack_raw_dat_vld,
	csi_in_line,
	csi_in_frame,
	debug_pins
);
	input wire ref_clock;
	input wire reset;
	input wire clk_1hz;
	input wire [1:0] cam_dphy_clk;
	localparam top_pkg_NUM_LANE = 2;
	input wire [3:0] cam_dphy_dat;
	input wire cam_en;
	output wire csi_byte_clk;
	output wire [15:0] csi_unpack_raw_dat;
	output wire csi_unpack_raw_dat_vld;
	output wire csi_in_line;
	output wire csi_in_frame;
	output wire [7:0] debug_pins;
	wire bit_clock;
	wire dphy_clk_reset;
	wire csi_reset;
	csi_rx_phy_clk u_phy_clk(
		.dphy_clk(cam_dphy_clk),
		.reset(reset),
		.reset_out(dphy_clk_reset),
		.bit_clock(bit_clock),
		.byte_clock(csi_byte_clk)
	);
	csi_rx_clk_det u_clk_det(
		.ref_clock(ref_clock),
		.byte_clock(csi_byte_clk),
		.reset_in(dphy_clk_reset),
		.enable(cam_en),
		.reset_out(csi_reset)
	);
	wire [15:0] deser_data;
	reg [9:0] delay;
	always @(posedge clk_1hz) delay <= (delay == 10'd1023 ? 10'd0 : delay + 10'd1);
	genvar _gv_i_3;
	localparam [1:0] top_pkg_DINVERT = 2'b01;
	localparam [9:0] top_pkg_DSKEW = 10'h063;
	generate
		for (_gv_i_3 = 0; _gv_i_3 < top_pkg_NUM_LANE; _gv_i_3 = _gv_i_3 + 1) begin : lane
			localparam i = _gv_i_3;
			csi_rx_phy_dat #(
				.INVERT(top_pkg_DINVERT[i]),
				.DELAY(top_pkg_DSKEW[i * 5+:5])
			) u_phy_dat(
				.delay(delay[i * 5+:5]),
				.reset(csi_reset),
				.bit_clock(bit_clock),
				.byte_clock(csi_byte_clk),
				.dphy_hs(cam_dphy_dat[i * 2+:2]),
				.deser_out(deser_data[i * 8+:8])
			);
		end
	endgenerate
	wire wait_for_sync;
	wire byte_packet_done;
	wire packet_done;
	wire [15:0] byte_align_data;
	wire [1:0] byte_valid;
	wire [15:0] word_data;
	wire word_valid;
	csi_rx_align_byte u_align_byte[1:0](
		.clock(csi_byte_clk),
		.reset(csi_reset),
		.enable(cam_en),
		.deser_in(deser_data),
		.wait_for_sync(wait_for_sync),
		.packet_done(byte_packet_done),
		.data_out(byte_align_data),
		.data_vld(byte_valid)
	);
	csi_rx_align_word u_align_word(
		.byte_clock(csi_byte_clk),
		.reset(csi_reset),
		.enable(cam_en),
		.packet_done(packet_done),
		.wait_for_sync(wait_for_sync),
		.word_in(byte_align_data),
		.valid_in(byte_valid),
		.packet_done_out(byte_packet_done),
		.word_out(word_data),
		.valid_out(word_valid)
	);
	/*wire [15:0] csi_unpack_dat;
	wire csi_unpack_dat_vld;
	wire csi_sync_seq;
	wire [1:0] debug_pkt;
	csi_rx_packet_handler u_depacket(
		.clock(csi_byte_clk),
		.reset(csi_reset),
		.enable(cam_en),
		.data(word_data),
		.data_valid(word_valid),
		.sync_wait(wait_for_sync),
		.packet_done(packet_done),
		.payload_out(csi_unpack_dat),
		.payload_valid(csi_unpack_dat_vld),
		.sync_seq(csi_sync_seq),
		.in_frame(csi_in_frame),
		.in_line(csi_in_line),
		.ecc_out(),
		.debug_out(debug_pkt)
	);
	assign csi_unpack_raw_dat = csi_unpack_dat;
	assign csi_unpack_raw_dat_vld = csi_unpack_dat_vld;
	assign debug_pins = {csi_in_frame, csi_in_line, csi_unpack_dat_vld, packet_done, word_valid, wait_for_sync, byte_valid[0], csi_reset};*/
endmodule
