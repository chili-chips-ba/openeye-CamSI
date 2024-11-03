
module sd_card_test(
input           sys_clk_p,     
input           sys_clk_n,
input            sys_rstn,
input            key,
output           sd_ncs,
output           sd_dclk,
output           sd_mosi,
input            sd_miso,
output [1:0]     led
);
parameter S_IDLE         = 0;
parameter S_READ         = 1;
parameter S_WRITE        = 2;
parameter S_END          = 3;

reg[3:0] state;
wire             sd_init_done;
reg              sd_sec_read;
wire[31:0]       sd_sec_read_addr;
wire[7:0]        sd_sec_read_data;
wire             sd_sec_read_data_valid;
wire             sd_sec_read_end;
reg              sd_sec_write;
wire[31:0]       sd_sec_write_addr;
reg [7:0]        sd_sec_write_data;
wire             sd_sec_write_data_req;
wire             sd_sec_write_end;
reg[9:0]         wr_cnt;
reg[9:0]         rd_cnt;
wire             button_negedge;
reg[7:0]         read_data;
wire             rst_n;
assign  sd_sec_read_addr = 32'd0;
assign  sd_sec_write_addr = 32'd0;

assign  led = read_data[1:0];


wire        sys_clk;
/////////////////////PLL IP call////////////////////////////
clk_ref clk_sdcard_m0
   (// Clock in ports
    .clk_in1_p  (sys_clk_p ),               // Differentia  clock  200Mhz input
    .clk_in1_n  (sys_clk_n ),               
    // Clock out ports
    .clk_out1   (sys_clk   ),              // OUT 50Mhz
    // Status and control signals	 
    .resetn      (sys_rstn    ),         // RESET IN
    .locked     ( rst_n    ));      // OUT
ax_debounce ax_debounce_m0
(
	.clk             (sys_clk),
	.rst             (~rst_n),
	.button_in       (key),
	.button_posedge  (),
	.button_negedge  (button_negedge),
	.button_out      ()
);

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		wr_cnt <= 10'd0;
	else if(state == S_WRITE)
	begin
		if(sd_sec_write_data_req == 1'b1)
			wr_cnt <= wr_cnt + 10'd1;
	end
	else
		wr_cnt <= 10'd0;
end

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		rd_cnt <= 10'd0;
	else if(state == S_READ)
	begin
		if(sd_sec_read_data_valid == 1'b1)
			rd_cnt <= rd_cnt + 10'd1;
	end
	else
		rd_cnt <= 10'd0;
end

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		read_data <= 8'd0;
	else if(state == S_READ)
	begin
		if(sd_sec_read_data_valid == 1'b1 && rd_cnt == 10'd0)
			read_data <= sd_sec_read_data;
	end
	else if(state == S_END && button_negedge == 1'b1)
		read_data <= read_data + 8'd1;
end

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		sd_sec_write_data <= 8'd0;
	else if(sd_sec_write_data_req)
		sd_sec_write_data <= read_data + wr_cnt[7:0];
end

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		state <= S_IDLE;
		sd_sec_read <= 1'b0;
		sd_sec_write <= 1'b0;
	end
	else if(sd_init_done == 1'b0)
	begin
		state <= S_IDLE;
	end
	else
		case(state)
			S_IDLE:
			begin
				state <= S_READ;
			end
			S_WRITE:
			begin
				if(sd_sec_write_end == 1'b1)
				begin
					sd_sec_write <= 1'b0;
					state <= S_READ;
				end
				else
					sd_sec_write <= 1'b1;
			end
			
			S_READ:
			begin
				if(sd_sec_read_end == 1'b1)
				begin
					state <= S_END;
					sd_sec_read <= 1'b0;
				end
				else
				begin
					sd_sec_read <= 1'b1;
				end                 
			end         
			S_END:
			begin
				if(button_negedge == 1'b1)
					state <= S_WRITE;
			end
			default:
				state <= S_IDLE;
		endcase
end

sd_card_top  sd_card_top_m0(
	.clk                       (sys_clk                ),
	.rst                       (~rst_n                 ),
	.SD_nCS                    (sd_ncs                 ),
	.SD_DCLK                   (sd_dclk                ),
	.SD_MOSI                   (sd_mosi                ),
	.SD_MISO                   (sd_miso                ),
	.sd_init_done              (sd_init_done           ),
	.sd_sec_read               (sd_sec_read            ),
	.sd_sec_read_addr          (sd_sec_read_addr       ),
	.sd_sec_read_data          (sd_sec_read_data       ),
	.sd_sec_read_data_valid    (sd_sec_read_data_valid ),
	.sd_sec_read_end           (sd_sec_read_end        ),
	.sd_sec_write              (sd_sec_write           ),
	.sd_sec_write_addr         (sd_sec_write_addr      ),
	.sd_sec_write_data         (sd_sec_write_data      ),
	.sd_sec_write_data_req     (sd_sec_write_data_req  ),
	.sd_sec_write_end          (sd_sec_write_end       )
);

ila_0 ila_m0(
	.clk(sys_clk), 


	.probe0(sd_sec_read_data_valid),      
	.probe1(sd_sec_read_data),           
	.probe2(sd_sec_write_data_req),     
	.probe3(sd_sec_write_data)        
);
endmodule 