module DP_BRAM (
	clka,
	ena,
	addra,
	wea,
	dina,
	douta,
	clkb,
	enb,
	addrb,
	web,
	dinb,
	doutb
);
	parameter W = 256;
	parameter D = 64;
	input wire clka;
	input wire ena;
	input wire [$clog2(D) - 1:0] addra;
	input wire [(W / 8) - 1:0] wea;
	input wire [W - 1:0] dina;
	output reg [W - 1:0] douta;
	input wire clkb;
	input wire enb;
	input wire [$clog2(D) - 1:0] addrb;
	input wire [(W / 8) - 1:0] web;
	input wire [W - 1:0] dinb;
	output reg [W - 1:0] doutb;
	reg [W - 1:0] mem [0:D - 1];
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < (W / 8); _gv_i_1 = _gv_i_1 + 1) begin : a
			localparam i = _gv_i_1;
			always @(posedge clka)
				if (ena == 1'b1) begin
					if (wea[i] == 1'b1)
						mem[addra][8 * i+:8] <= dina[8 * i+:8];
				end
		end
	endgenerate
	always @(posedge clka)
		if (ena == 1'b1)
			douta <= mem[addra];
	genvar _gv_j_1;
	generate
		for (_gv_j_1 = 0; _gv_j_1 < (W / 8); _gv_j_1 = _gv_j_1 + 1) begin : b
			localparam j = _gv_j_1;
			always @(posedge clkb)
				if (enb == 1'b1) begin
					if (web[j] == 1'b1)
						mem[addrb][8 * j+:8] <= dinb[8 * j+:8];
				end
		end
	endgenerate
	always @(posedge clkb)
		if (enb == 1'b1)
			doutb <= mem[addrb];
endmodule
