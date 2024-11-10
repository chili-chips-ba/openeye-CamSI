module i2c_top (
	clk,
	strobe_400kHz,
	areset_n,
	i2c_scl,
	i2c_sda
);
	parameter I2C_SLAVE_ADDR = 7'd16;
	input wire clk;
	input wire strobe_400kHz;
	input wire areset_n;
	inout wire i2c_scl;
	inout wire i2c_sda;
	wire i2c_enable;
	wire [15:0] i2c_reg_addr;
	reg [6:0] i2c_reg_cnt;
	wire i2c_reg_done;
	reg [23:0] i2c_data_init [0:64];
	wire [7:0] i2c_data_in;
	wire i2c_scl_do;
	wire i2c_scl_di;
	wire i2c_scl_oe;
	wire i2c_sda_do;
	wire i2c_sda_di;
	wire i2c_sda_oe;
	i2c_ctrl u_ctrl(
		.clk(clk),
		.strobe_400kHz(strobe_400kHz),
		.areset_n(areset_n),
		.enable(i2c_enable),
		.slave_address(I2C_SLAVE_ADDR),
		.register_address(i2c_reg_addr),
		.data_in(i2c_data_in),
		.register_done(i2c_reg_done),
		.scl_oe(i2c_scl_oe),
		.scl_di(i2c_scl_di),
		.sda_oe(i2c_sda_oe),
		.sda_di(i2c_sda_di)
	);
	initial $readmemh("i2c_init.mem", i2c_data_init);
	assign i2c_enable = i2c_reg_cnt < 7'd65;
	assign i2c_reg_addr = i2c_data_init[i2c_reg_cnt][23:8];
	assign i2c_data_in = i2c_data_init[i2c_reg_cnt][7:0];
	always @(negedge areset_n or posedge clk)
		if (areset_n == 1'b0)
			i2c_reg_cnt <= 1'sb0;
		else if ({strobe_400kHz, i2c_enable} == 2'b11) begin
			if (i2c_reg_done == 1'd1) begin
				if (i2c_reg_cnt < 7'd65)
					i2c_reg_cnt <= i2c_reg_cnt + 7'd1;
			end
		end
	IOBUF #(
		.DRIVE(12),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("DEFAULT"),
		.SLEW("SLOW")
	) u_i2c_iobuf[1:0](
		.IO({i2c_sda, i2c_scl}),
		.O({i2c_sda_di, i2c_scl_di}),
		.I(2'b00),
		.T({~i2c_sda_oe, ~i2c_scl_oe})
	);
endmodule
