module uart_top(
input                           sys_clk_p,      // Differentia system clock 200Mhz input on board
input                           sys_clk_n,
input                           sys_rstn,
input                           uart_rx,
output                          uart_tx
);

parameter                        CLK_FRE = 200;//Mhz
localparam                       IDLE =  0;
localparam                       SEND =  1;   
localparam                       WAIT =  2;   
reg[7:0]                         tx_data;
reg[7:0]                         tx_str;
reg                              tx_data_valid;
wire                             tx_data_ready;
reg[7:0]                         tx_cnt;
wire[7:0]                        rx_data;
wire                             rx_data_valid;
wire                             rx_data_ready;
reg[31:0]                        wait_cnt;
reg[3:0]                         state;


wire        sys_clk;
 IBUFGDS #
   (
    .DIFF_TERM    ("FALSE"),
    .IBUF_LOW_PWR ("FALSE")
    )
  u_ibufg_sys_clk
   (
    .I  (sys_clk_p),            
    .IB (sys_clk_n),          
    .O  (sys_clk  )        
    );  
assign rx_data_ready = 1'b1;
always@(posedge sys_clk or negedge sys_rstn)
begin
	if(sys_rstn == 1'b0)
	begin
		wait_cnt <= 32'd0;
		tx_data <= 8'd0;
		state <= IDLE;
		tx_cnt <= 8'd0;
		tx_data_valid <= 1'b0;
	end
	else
	case(state)
		IDLE:
			state <= SEND;
		SEND:
		begin
			wait_cnt <= 32'd0;
			tx_data <= tx_str;

			if(tx_data_valid == 1'b1 && tx_data_ready == 1'b1 && tx_cnt < 8'd12)
			begin
				tx_cnt <= tx_cnt + 8'd1; 
			end
			else if(tx_data_valid && tx_data_ready)
			begin
				tx_cnt <= 8'd0;
				tx_data_valid <= 1'b0;
				state <= WAIT;
			end
			else if(~tx_data_valid)
			begin
				tx_data_valid <= 1'b1;
			end
		end
		WAIT:
		begin
			wait_cnt <= wait_cnt + 32'd1;

			if(rx_data_valid == 1'b1)
			begin
				tx_data_valid <= 1'b1;
				tx_data <= rx_data;   
			end
			else if(tx_data_valid && tx_data_ready)
			begin
				tx_data_valid <= 1'b0;
			end
			else if(wait_cnt >= CLK_FRE * 1000000) 
				state <= SEND;
		end
		default:
			state <= IDLE;
	endcase
end


//Send "Hello PuZhi\r\n"
always@(*)
begin
	case(tx_cnt)
		8'd0 :  tx_str <= "H";
		8'd1 :  tx_str <= "e";
		8'd2 :  tx_str <= "l";
		8'd3 :  tx_str <= "l";
		8'd4 :  tx_str <= "o";
		8'd5 :  tx_str <= " ";
		8'd6 :  tx_str <= "P";
		8'd7 :  tx_str <= "u";
		8'd8 :  tx_str <= "Z";
		8'd9 :  tx_str <= "h";
		8'd10:  tx_str <= "i";
		8'd11:  tx_str <= "\r";
		8'd12:  tx_str <= "\n";
		default:tx_str <= 8'd0;
	endcase
end

uart_rx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(115200)
) uart_rx_inst
(
	.clk                        (sys_clk                  ),
	.rst_n                      (sys_rstn                 ),
	.rx_data                    (rx_data                  ),
	.rx_data_valid              (rx_data_valid            ),
	.rx_data_ready              (rx_data_ready            ),
	.rx_pin                     (uart_rx                  )
);

uart_tx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(115200)
) uart_tx_inst
(
	.clk                        (sys_clk                  ),
	.rst_n                      (sys_rstn                 ),
	.tx_data                    (tx_data                  ),
	.tx_data_valid              (tx_data_valid            ),
	.tx_data_ready              (tx_data_ready            ),
	.tx_pin                     (uart_tx                  )
);
endmodule