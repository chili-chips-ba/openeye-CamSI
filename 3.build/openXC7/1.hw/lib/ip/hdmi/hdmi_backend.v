module hdmi_backend (
	clk_ext,
	clk_pix,
	srst_n,
	hcount,
	vcount,
	pix,
	fifo_empty,
	hdmi_reset_n,
	hdmi_frame,
	blank,
	vsync,
	hsync,
	hdmi_clk_p,
	hdmi_clk_n,
	hdmi_dat_p,
	hdmi_dat_n
);
	reg _sv2v_0;
	input wire clk_ext;
	output wire clk_pix;
	output wire srst_n;
	output reg [10:0] hcount;
	output reg [10:0] vcount;
	input wire [23:0] pix;
	input wire fifo_empty;
	input wire hdmi_reset_n;
	output reg hdmi_frame;
	output reg blank;
	output reg vsync;
	output reg hsync;
	output wire hdmi_clk_p;
	output wire hdmi_clk_n;
	output wire [2:0] hdmi_dat_p;
	output wire [2:0] hdmi_dat_n;
	wire clk_pix5;
	fpga_pll_hdmi u_fpga_pll_hdmi(
		.clk_ext(clk_ext),
		.srst_n(srst_n),
		.clk_pix5(clk_pix5),
		.clk_pix(clk_pix)
	);
	wire internal_srst_n;
	assign internal_srst_n = srst_n & ~fifo_empty;
	localparam signed [31:0] hdmi_pkg_HFRAME = 1687;
	localparam signed [31:0] hdmi_pkg_HSCREEN = 1280;
	localparam signed [31:0] hdmi_pkg_HSYNC_SIZE = 407;
	localparam signed [31:0] hdmi_pkg_HSYNC_START = hdmi_pkg_HSCREEN;
	localparam signed [31:0] hdmi_pkg_HSYNC_END = hdmi_pkg_HSYNC_START + hdmi_pkg_HSYNC_SIZE;
	localparam [0:0] hdmi_pkg_HSYNC_POLARITY = 1'b1;
	localparam signed [31:0] hdmi_pkg_VFRAME = 850;
	localparam signed [31:0] hdmi_pkg_VSCREEN = 720;
	localparam [0:0] hdmi_pkg_VSYNC_POLARITY = 1'b1;
	function automatic signed [10:0] sv2v_cast_11_signed;
		input reg signed [10:0] inp;
		sv2v_cast_11_signed = inp;
	endfunction
	function automatic [10:0] sv2v_cast_11;
		input reg [10:0] inp;
		sv2v_cast_11 = inp;
	endfunction
	always @(posedge clk_pix) begin : _tbase_gen
		if (&{internal_srst_n, hdmi_reset_n} == 1'b0) begin
			hcount <= 1'sb0;
			vcount <= 1'sb0;
			hsync <= hdmi_pkg_HSYNC_POLARITY;
			vsync <= hdmi_pkg_VSYNC_POLARITY;
			blank <= 1'b1;
			hdmi_frame <= 1'b0;
		end
		else begin
			if (hcount == sv2v_cast_11_signed(1686)) begin
				hcount <= 1'sb0;
				if (vcount == sv2v_cast_11_signed(849))
					vcount <= 1'sb0;
				else
					vcount <= sv2v_cast_11(vcount + 11'sd1);
			end
			else
				hcount <= sv2v_cast_11(hcount + 11'sd1);
			if ((hcount >= sv2v_cast_11_signed(hdmi_pkg_HSYNC_START)) && (hcount < sv2v_cast_11_signed(hdmi_pkg_HSYNC_END)))
				hsync <= hdmi_pkg_HSYNC_POLARITY;
			else
				hsync <= ~hdmi_pkg_HSYNC_POLARITY;
			if (vcount < 11'd3)
				vsync <= hdmi_pkg_VSYNC_POLARITY;
			else
				vsync <= ~hdmi_pkg_VSYNC_POLARITY;
			blank <= (((hcount == 11'd0) | (hcount >= sv2v_cast_11_signed(1281))) | (vcount < 11'd3)) | (vcount >= sv2v_cast_11_signed(723));
			hdmi_frame <= (vcount < 11'd3) | (vcount >= sv2v_cast_11_signed(723));
		end
	end
	reg srst;
	reg [29:0] tdms_pix;
	wire [29:0] tdms_enc;
	wire [2:0] tdms_sdat;
	wire tdms_sclk;
	always @(*) begin : _comb
		if (_sv2v_0)
			;
		srst = ~internal_srst_n;
		tdms_pix[29-:2] = {vsync, hsync};
		tdms_pix[19-:2] = {vsync, hsync};
		tdms_pix[9-:2] = {vsync, hsync};
		tdms_pix[27-:8] = pix[23-:8];
		tdms_pix[17-:8] = pix[15-:8];
		tdms_pix[7-:8] = pix[7-:8];
	end


	genvar _gv_i_2;

	generate
		for (_gv_i_2 = 0; _gv_i_2 < 3; _gv_i_2 = _gv_i_2 + 1) begin : _tdms_sdat
			localparam i = _gv_i_2;
			hdmi_tdms_enc u_tmds(
				.clk(clk_pix),
				.blank(blank),
				.raw(tdms_pix[i * 10+:10]),
				.encoded(tdms_enc[i * 10+:10])
			);

			fpga_oser10 u_oser_dat(
				.arst(srst),
				.clk_par(clk_pix),
				.clk_ser(clk_pix5),
				.d(tdms_enc[i * 10+:10]),
				.q(tdms_sdat[i])
			);
			fpga_olvds u_obuf_dat(
				.i(tdms_sdat[i]),
				.o(hdmi_dat_p[i]),
				.ob(hdmi_dat_n[i])
			);
		end
	endgenerate
	fpga_oser10 u_oser_clk(
		.arst(srst),
		.clk_par(clk_pix),
		.clk_ser(clk_pix5),
		.d(10'b0000011111),
		.q(tdms_sclk)
	);
	fpga_olvds u_obuf_clk(
		.i(tdms_sclk),
		.o(hdmi_clk_p),
		.ob(hdmi_clk_n)
	);
	initial _sv2v_0 = 0;
endmodule
