module i2c_top (
	clk,
	strobe_400kHz,
	areset_n,
	i2c_scl,
	i2c_sda,
	debug_pins
);
	parameter [6:0] I2C_SLAVE_ADDR = 7'd26;
	parameter signed [31:0] NUM_REGISTERS = 58;
	input wire clk;
	input wire strobe_400kHz;
	input wire areset_n;
	inout wire i2c_scl;
	inout wire i2c_sda;
	output wire [7:0] debug_pins;
	localparam CNT_WIDTH = $clog2(NUM_REGISTERS);
	wire i2c_enable;
	wire [15:0] i2c_reg_addr;
	reg [CNT_WIDTH - 1:0] i2c_reg_cnt;
	wire i2c_reg_done;
	reg [31:0] i2c_data_init [0:NUM_REGISTERS - 1];
	wire [7:0] i2c_data_in;
	wire i2c_scl_do;
	wire i2c_scl_di;
	wire i2c_scl_oe;
	wire i2c_sda_do;
	wire i2c_sda_di;
	wire i2c_sda_oe;
	wire [7:0] i2c_pause;
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
		.sda_di(i2c_sda_di),
		.pause_duration(i2c_pause)
	);
	localparam top_pkg_I2C_INIT_MEM_FILE = "i2c_init_IMX219.mem";
	initial $readmemh(top_pkg_I2C_INIT_MEM_FILE, i2c_data_init);
	function automatic [CNT_WIDTH - 1:0] sv2v_cast_1924C;
		input reg [CNT_WIDTH - 1:0] inp;
		sv2v_cast_1924C = inp;
	endfunction
	assign i2c_enable = i2c_reg_cnt < sv2v_cast_1924C(NUM_REGISTERS);
	assign i2c_reg_addr = i2c_data_init[i2c_reg_cnt][31:16];
	assign i2c_data_in = i2c_data_init[i2c_reg_cnt][15:8];
	assign i2c_pause = i2c_data_init[i2c_reg_cnt][7:0];
	always @(negedge areset_n or posedge clk)
		if (areset_n == 1'b0)
			i2c_reg_cnt <= 1'sb0;
		else if ({strobe_400kHz, i2c_enable, i2c_reg_done} == 3'b111)
			i2c_reg_cnt <= sv2v_cast_1924C(i2c_reg_cnt + sv2v_cast_1924C(1));
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
	assign debug_pins = {i2c_sda_di, i2c_scl_di, i2c_sda_oe, i2c_scl_oe, i2c_enable, areset_n, i2c_reg_done, strobe_400kHz};
endmodule
