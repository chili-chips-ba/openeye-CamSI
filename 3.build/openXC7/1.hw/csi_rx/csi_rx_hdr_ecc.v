module csi_rx_hdr_ecc (
	data,
	ecc
);
	reg _sv2v_0;
	input wire [23:0] data;
	output reg [7:0] ecc;
	always @(*) begin
		if (_sv2v_0)
			;
		ecc[7] = 1'b0;
		ecc[6] = 1'b0;
		ecc[5] = (((((((((((data[10] ^ data[11]) ^ data[12]) ^ data[13]) ^ data[14]) ^ data[15]) ^ data[16]) ^ data[17]) ^ data[18]) ^ data[19]) ^ data[21]) ^ data[22]) ^ data[23];
		ecc[4] = (((((((((((data[4] ^ data[5]) ^ data[6]) ^ data[7]) ^ data[8]) ^ data[9]) ^ data[16]) ^ data[17]) ^ data[18]) ^ data[19]) ^ data[20]) ^ data[22]) ^ data[23];
		ecc[3] = (((((((((((data[1] ^ data[2]) ^ data[3]) ^ data[7]) ^ data[8]) ^ data[9]) ^ data[13]) ^ data[14]) ^ data[15]) ^ data[19]) ^ data[20]) ^ data[21]) ^ data[23];
		ecc[2] = (((((((((((data[0] ^ data[2]) ^ data[3]) ^ data[5]) ^ data[6]) ^ data[9]) ^ data[11]) ^ data[12]) ^ data[15]) ^ data[18]) ^ data[20]) ^ data[21]) ^ data[22];
		ecc[1] = ((((((((((((data[0] ^ data[1]) ^ data[3]) ^ data[4]) ^ data[6]) ^ data[8]) ^ data[10]) ^ data[12]) ^ data[14]) ^ data[17]) ^ data[20]) ^ data[21]) ^ data[22]) ^ data[23];
		ecc[0] = ((((((((((((data[0] ^ data[1]) ^ data[2]) ^ data[4]) ^ data[5]) ^ data[7]) ^ data[10]) ^ data[11]) ^ data[13]) ^ data[16]) ^ data[20]) ^ data[21]) ^ data[22]) ^ data[23];
	end
	initial _sv2v_0 = 0;
endmodule
