module clkrst_gen (
	reset_ext,
	clk_ext,
	clk_100,
	clk_180,
	clk_200,
	clk_1hz,
	strobe_400kHz,
	reset,
	cam_en,
	i2c_areset_n
);
	input wire reset_ext;
	input wire clk_ext;
	output wire clk_100;
	output wire clk_180;
	output wire clk_200;
	output reg clk_1hz;
	output reg strobe_400kHz;
	output reg reset;
	output reg cam_en;
	output reg i2c_areset_n;
	BUFG u_ibufio(
		.I(clk_ext),
		.O(clk_100)
	);
	wire srst0;
	reg srst1;
	fpga_pll_top u_pll_top(
		.areset(reset_ext),
		.clk_in(clk_100),
		.srst(srst0),
		.clk_out0(clk_200),
		.clk_out1(clk_180)
	);
	always @(posedge srst0 or posedge clk_100)
		if (srst0 == 1'b1) begin
			reset <= 1'b1;
			srst1 <= 1'b1;
		end
		else begin
			reset <= 1'b0;
			srst1 <= 1'b0;
		end
	localparam top_pkg_NUM_CLK_FOR_400kHZ = 250;
	reg [7:0] cnt_400khz;
	function automatic [7:0] sv2v_cast_E67DB;
		input reg [7:0] inp;
		sv2v_cast_E67DB = inp;
	endfunction
	always @(posedge srst1 or posedge clk_100)
		if (srst1 == 1'b1) begin
			cnt_400khz <= 1'sb0;
			strobe_400kHz <= 1'b0;
		end
		else if (cnt_400khz == sv2v_cast_E67DB(249)) begin
			cnt_400khz <= 1'sb0;
			strobe_400kHz <= 1'b1;
		end
		else begin
			cnt_400khz <= sv2v_cast_E67DB(cnt_400khz + sv2v_cast_E67DB(1));
			strobe_400kHz <= 1'b0;
		end
	localparam top_pkg_NUM_CLK_FOR_1HZ = 200000;
	reg [17:0] cnt_1hz;
	reg [3:0] rst_delay_cnt;
	function automatic [17:0] sv2v_cast_E0E78;
		input reg [17:0] inp;
		sv2v_cast_E0E78 = inp;
	endfunction
	function automatic [3:0] sv2v_cast_4;
		input reg [3:0] inp;
		sv2v_cast_4 = inp;
	endfunction
	always @(posedge srst1 or posedge clk_100)
		if (srst1 == 1'b1) begin
			cnt_1hz <= 1'sb0;
			clk_1hz <= 1'b0;
			rst_delay_cnt <= 1'sb0;
			cam_en <= 1'b0;
			i2c_areset_n <= 1'b0;
		end
		else if (strobe_400kHz == 1'b1) begin
			if (cnt_1hz != sv2v_cast_E0E78(199999))
				cnt_1hz <= sv2v_cast_E0E78(cnt_1hz + sv2v_cast_E0E78(1));
			else begin
				cnt_1hz <= 1'sb0;
				clk_1hz <= ~clk_1hz;
				if (rst_delay_cnt < 4'd8) begin
					rst_delay_cnt <= sv2v_cast_4(rst_delay_cnt + 4'sd1);
					cam_en <= rst_delay_cnt > 4'd1;
					i2c_areset_n <= rst_delay_cnt > 4'd3;
				end
			end
		end
	IDELAYCTRL u_idelayctrl(
		.RDY(),
		.REFCLK(clk_200),
		.RST(srst0)
	);
endmodule
