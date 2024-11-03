module top
(
// Inouts
inout [31:0]                       ddr3_dq,                     //ddr3 data
inout [3:0]                        ddr3_dqs_n,                  //ddr3 dqs negative
inout [3:0]                        ddr3_dqs_p,                  //ddr3 dqs positive
// Outputs
output [14:0]                     ddr3_addr,                    //ddr3 address
output [2:0]                      ddr3_ba,                      //ddr3 bank
output                            ddr3_ras_n,                   //ddr3 ras_n
output                            ddr3_cas_n,                   //ddr3 cas_n
output                            ddr3_we_n,                    //ddr3 write enable 
output                            ddr3_reset_n,                 //ddr3 reset,
output [0:0]                      ddr3_ck_p,                    //ddr3 clock negative
output [0:0]                      ddr3_ck_n,                    //ddr3 clock positive
output [0:0]                      ddr3_cke,                     //ddr3_cke,
output [0:0]                      ddr3_cs_n,                    //ddr3 chip select,
output [3:0]                      ddr3_dm,                      //ddr3_dm
output [0:0]                      ddr3_odt,                     //ddr3_odt
input                             sys_clk_p,                    //system clock positive on board
input                             sys_clk_n,                    //system clock negative on board
output                            error,                        //ddr3 test error high is active
input                             rst_n                         //reset ,low active
);

localparam nCK_PER_CLK           = 4;
localparam DQ_WIDTH              = 32;
localparam ADDR_WIDTH            = 29;
localparam DATA_WIDTH            = 32;
localparam PAYLOAD_WIDTH         = 32;

localparam APP_DATA_WIDTH        = 2 * nCK_PER_CLK * PAYLOAD_WIDTH;
localparam APP_MASK_WIDTH        = APP_DATA_WIDTH / 8;
wire init_calib_complete;
// Wire declarations
wire                            sys_clk_200MHz;                 //MIG IP clock input
wire                            wr_burst_data_req;              // write burst data request
wire                            wr_burst_finish;                // write burst finish flag
wire                            rd_burst_finish;                //read burst finish flag
wire                            rd_burst_req;                   //read burst request
wire                            wr_burst_req;                   //write burst request
wire[9:0]                       rd_burst_len;                   //read burst length
wire[9:0]                       wr_burst_len;                   //write burst length
wire[28:0]                      rd_burst_addr;                  //read burst address
wire[28:0]                      wr_burst_addr;                  //write burst address
wire                            rd_burst_data_valid;            //read burst data valid
wire[48* 8 - 1 : 0]             rd_burst_data;                  //read burst data
wire[48* 8 - 1 : 0]             wr_burst_data;                  //write burst data
// xilinx MIG IP application interface ports
wire [ADDR_WIDTH-1:0]           app_addr;
wire [2:0]                      app_cmd;
wire                            app_en;
wire                            app_rdy;
wire [APP_DATA_WIDTH-1:0]       app_rd_data;
wire                            app_rd_data_end;
wire                            app_rd_data_valid;
wire [APP_DATA_WIDTH-1:0]       app_wdf_data;
wire                            app_wdf_end;
wire [APP_MASK_WIDTH-1:0]       app_wdf_mask;
wire                            app_wdf_rdy;
wire                            app_sr_active;
wire                            app_ref_ack;
wire                            app_zq_ack;
wire                            app_wdf_wren;

wire                            clk;
wire                            rst;

IBUFDS sys_clk_ibufgds
(
.O                              (sys_clk_200MHz           ),
.I                              (sys_clk_p                ),
.IB                             (sys_clk_n                )
);
//call MIG IP
  mig_7series_0 u_ddr3
(
// Memory interface ports
.ddr3_addr                      (ddr3_addr              ),
.ddr3_ba                        (ddr3_ba                ),
.ddr3_cas_n                     (ddr3_cas_n             ),
.ddr3_ck_n                      (ddr3_ck_n              ),
.ddr3_ck_p                      (ddr3_ck_p              ),
.ddr3_cke                       (ddr3_cke               ),
.ddr3_ras_n                     (ddr3_ras_n             ),
.ddr3_we_n                      (ddr3_we_n              ),
.ddr3_dq                        (ddr3_dq                ),
.ddr3_dqs_n                     (ddr3_dqs_n             ),
.ddr3_dqs_p                     (ddr3_dqs_p             ),
.ddr3_reset_n                   (ddr3_reset_n           ),
.init_calib_complete            (init_calib_complete    ),
.ddr3_cs_n                      (ddr3_cs_n              ),
.ddr3_dm                        (ddr3_dm                ),
.ddr3_odt                       (ddr3_odt               ),
// Application interface ports
.app_addr                       (app_addr               ),
.app_cmd                        (app_cmd                ),
.app_en                         (app_en                 ),
.app_wdf_data                   (app_wdf_data           ),
.app_wdf_end                    (app_wdf_end            ),
.app_wdf_wren                   (app_wdf_wren           ),
.app_rd_data                    (app_rd_data            ),
.app_rd_data_end                (app_rd_data_end        ),
.app_rd_data_valid              (app_rd_data_valid      ),
.app_rdy                        (app_rdy                ),
.app_wdf_rdy                    (app_wdf_rdy            ),
.app_sr_req                     (1'b0                   ),
.app_ref_req                    (1'b0                   ),
.app_zq_req                     (1'b0                   ),
.app_sr_active                  (app_sr_active          ),
.app_ref_ack                    (app_ref_ack            ),
.app_zq_ack                     (app_zq_ack             ),
.ui_clk                         (clk                    ),
.ui_clk_sync_rst                (rst                    ),

.app_wdf_mask                   (app_wdf_mask           ),

.sys_clk_i                      (sys_clk_200MHz         ),      // System Clock Ports    
.sys_rst                        (rst_n                  )
);
//Burst mode read and write MIG IP module
mem_burst
#(
.MEM_DATA_BITS                  (APP_DATA_WIDTH         ),
.ADDR_BITS                      (ADDR_WIDTH             )
)
mem_burst_m0
(
.rst                            (rst                    ),                                  
.mem_clk                        (clk                    ),                              
.rd_burst_req                   (rd_burst_req           ),                
.wr_burst_req                   (wr_burst_req           ),                
.rd_burst_len                   (rd_burst_len           ),                
.wr_burst_len                   (wr_burst_len           ),                 
.rd_burst_addr                  (rd_burst_addr          ),               
.wr_burst_addr                  (wr_burst_addr          ),               
.rd_burst_data_valid            (rd_burst_data_valid    ),   
.wr_burst_data_req              (wr_burst_data_req      ),       
.rd_burst_data                  (rd_burst_data          ),               
.wr_burst_data                  (wr_burst_data          ),               
.rd_burst_finish                (rd_burst_finish        ),           
.wr_burst_finish                (wr_burst_finish        ),           
.burst_finish                   (                       ),                             

.app_addr                       (app_addr               ),
.app_cmd                        (app_cmd                ),
.app_en                         (app_en                 ),
.app_wdf_data                   (app_wdf_data           ),
.app_wdf_end                    (app_wdf_end            ),
.app_wdf_mask                   (app_wdf_mask           ),
.app_wdf_wren                   (app_wdf_wren           ),
.app_rd_data                    (app_rd_data            ),
.app_rd_data_end                (app_rd_data_end        ),
.app_rd_data_valid              (app_rd_data_valid      ),
.app_rdy                        (app_rdy                ),
.app_wdf_rdy                    (app_wdf_rdy            ),
.ui_clk_sync_rst                (                       ),  
.init_calib_complete            (init_calib_complete    )
);
/*************************************************************************
Call memory test module
****************************************************************************/
mem_test
#(
.MEM_DATA_BITS                  (APP_DATA_WIDTH         ),
.ADDR_BITS                      (ADDR_WIDTH             )
)
mem_test_m0
(
.rst                            (rst                    ),                                 
.mem_clk                        (clk                    ),                               
.rd_burst_req                   (rd_burst_req           ),                         
.wr_burst_req                   (wr_burst_req           ),                         
.rd_burst_len                   (rd_burst_len           ),                     
.wr_burst_len                   (wr_burst_len           ),                    
.rd_burst_addr                  (rd_burst_addr          ),        
.wr_burst_addr                  (wr_burst_addr          ),        
.rd_burst_data_valid            (rd_burst_data_valid    ),                 
.wr_burst_data_req              (wr_burst_data_req      ),                   
.rd_burst_data                  (rd_burst_data          ),   
.wr_burst_data                  (wr_burst_data          ),    
.rd_burst_finish                (rd_burst_finish        ),                     
.wr_burst_finish                (wr_burst_finish        ),                      

.error                          (error                  )
);
/*************************************************************************
Probe define
****************************************************************************/
wire                            probe0;
wire                            probe1;
wire                            probe2;
wire                            probe3;
wire                            probe4;
wire                            probe5;
wire                            probe6;
wire                            probe7;
wire [255 : 0]                  probe8;
wire [255 : 0]                  probe9;
wire [28 : 0]                   probe10;
/*************************************************************************
Analyze data from user defined ports for the xilinx ila module
****************************************************************************/
ila_0 u_ila_0
(
.clk                            (clk                    ),
.probe0                         (probe0                 ),
.probe1                         (probe1                 ),
.probe2                         (probe2                 ),
.probe3                         (probe3                 ),
.probe4                         (probe4                 ),
.probe5                         (probe5                 ),
.probe6                         (probe6                 ),
.probe7                         (probe7                 ),
.probe8                         (probe8                 ),
.probe9                         (probe9                 ),
.probe10                        (probe10                )						
);
assign probe0 = rd_burst_req;
assign probe1 = wr_burst_req;
assign probe2 = rd_burst_data_valid;
assign probe3 = wr_burst_data_req;
assign probe4 = rd_burst_finish;
assign probe5 = wr_burst_finish;
assign probe6 = error;
assign probe7 = init_calib_complete;
assign probe8 = wr_burst_data[255:0];
assign probe9 = rd_burst_data[255:0];
assign probe10 = app_addr[28:0];
endmodule


module mem_burst
#(
parameter                                 MEM_DATA_BITS     =   64,
parameter                                 ADDR_BITS         =   24
)
(
input                                       rst,                            //reset
input                                       mem_clk,                        //clock
input                                       rd_burst_req,                   //read burst request
input                                       wr_burst_req,                   //write burst request
input[9:0]                                  rd_burst_len,                   //read burst length
input[9:0]                                  wr_burst_len,                   //write burst length
input[ADDR_BITS - 1:0]                      rd_burst_addr,                  //read burst address
input[ADDR_BITS - 1:0]                      wr_burst_addr,                  //write burst address
output                                      rd_burst_data_valid,            //read burst data valid
output                                      wr_burst_data_req,              // write burst data request
output[MEM_DATA_BITS - 1:0]                 rd_burst_data,                  //read burst data
input[MEM_DATA_BITS - 1:0]                  wr_burst_data,                  //write burst data
output                                      rd_burst_finish,                // read burst finish flag
output                                      wr_burst_finish,                // write burst finish flag
output                                      burst_finish,                   // write burst finish flag
/*************************************************************************
// xilinx MIG IP application interface ports
****************************************************************************/
output[ADDR_BITS-1:0]                       app_addr,
output[2:0]                                 app_cmd,
output                                      app_en,
output [MEM_DATA_BITS-1:0]                  app_wdf_data,
output                                      app_wdf_end,
output [MEM_DATA_BITS/8-1:0]                app_wdf_mask,
output                                      app_wdf_wren,
input [MEM_DATA_BITS-1:0]                   app_rd_data,
input                                       app_rd_data_end,
input                                       app_rd_data_valid,
input                                       app_rdy,
input                                       app_wdf_rdy,
input                                       ui_clk_sync_rst,  
input                                       init_calib_complete
);
assign app_wdf_mask = {MEM_DATA_BITS/8{1'b0}};
/*************************************************************************
Define the state of the state machine
****************************************************************************/
localparam      IDLE                    =   3'd0;
localparam      MEM_READ                =   3'd1;
localparam      MEM_READ_WAIT           =   3'd2;
localparam      MEM_WRITE               =   3'd3;
localparam      MEM_WRITE_WAIT          =   3'd4;
localparam      READ_END                =   3'd5;
localparam      WRITE_END               =   3'd6;
localparam      MEM_WRITE_FIRST_READ    =   3'd7;

reg[2:0]                                    state;	
reg[9:0]                                    rd_addr_cnt;                    //read address count
reg[9:0]                                    rd_data_cnt;                    //read data count
reg[9:0]                                    wr_addr_cnt;                    //write address count
reg[9:0]                                    wr_data_cnt;                    //write data count

reg[2:0]                                    app_cmd_r;
reg[ADDR_BITS-1:0]                          app_addr_r;
reg                                         app_en_r;
reg                                         app_wdf_end_r;
reg                                         app_wdf_wren_r;
assign app_cmd = app_cmd_r;
assign app_addr = app_addr_r;
assign app_en = app_en_r;
assign app_wdf_end = app_wdf_end_r;
assign app_wdf_data = wr_burst_data;
assign app_wdf_wren = app_wdf_wren_r & app_wdf_rdy;
assign rd_burst_finish = (state == READ_END);
assign wr_burst_finish = (state == WRITE_END);
assign burst_finish = rd_burst_finish | wr_burst_finish;

assign rd_burst_data = app_rd_data;
assign rd_burst_data_valid = app_rd_data_valid;

assign wr_burst_data_req = (state == MEM_WRITE) & app_wdf_rdy ;

always@(posedge mem_clk or posedge rst)
begin
	if(rst)
	begin
		app_wdf_wren_r <= 1'b0;
	end
	else if(app_wdf_rdy)
		app_wdf_wren_r <= wr_burst_data_req;
end
/*************************************************************************
Generate read and write burst state machine
****************************************************************************/
always@(posedge mem_clk or posedge rst)
begin
	if(rst)
	begin
		state <= IDLE;
		app_cmd_r <= 3'b000;
		app_addr_r <= 0;
		app_en_r <= 1'b0;
		rd_addr_cnt <= 0;
		rd_data_cnt <= 0;
		wr_addr_cnt <= 0;
		wr_data_cnt <= 0;
		app_wdf_end_r <= 1'b0;
	end
	else if(init_calib_complete ===  1'b1)//Jump to read and write state machine when ddr initialization completed
	begin
		case(state)
			IDLE:
			begin
				if(rd_burst_req)//jump to MEM_READ state when rd_burst_req is high
				begin
					state <= MEM_READ;
					app_cmd_r <= 3'b001;
					app_addr_r <= {rd_burst_addr,3'd0};
					app_en_r <= 1'b1;
				end
				else if(wr_burst_req)//jump to MEM_WRITE state when wr_burst_req is high
				begin
					state <= MEM_WRITE;
					app_cmd_r <= 3'b000;
					app_addr_r <= {wr_burst_addr,3'd0};
					app_en_r <= 1'b1;
					wr_addr_cnt <= 0;
					app_wdf_end_r <= 1'b1;
					wr_data_cnt <= 0;
				end
			end
			MEM_READ:
			begin
				if(app_rdy)
				begin
					app_addr_r <= app_addr_r + 8;
					if(rd_addr_cnt == rd_burst_len - 1)//wait after reading burst address end
					begin
						state <= MEM_READ_WAIT;
						rd_addr_cnt <= 0;
						app_en_r <= 1'b0;
					end
					else
						rd_addr_cnt <= rd_addr_cnt + 1;//read address count
				end
				
				if(app_rd_data_valid)
				begin
					if(rd_data_cnt == rd_burst_len - 1)
					begin
						rd_data_cnt <= 0;
						state <= READ_END;
					end
					else
					begin
						rd_data_cnt <= rd_data_cnt + 1;//read data count
					end
				end
			end
			MEM_READ_WAIT:
			begin
				if(app_rd_data_valid)
				begin
					if(rd_data_cnt == rd_burst_len - 1)//jump to READ_END state 
					begin
						rd_data_cnt <= 0;
						state <= READ_END;
					end
					else
					begin
						rd_data_cnt <= rd_data_cnt + 1;//data count
					end
				end
			end
			MEM_WRITE_FIRST_READ:
			begin
				app_en_r <= 1'b1;
				state <= MEM_WRITE;
				wr_addr_cnt <= 0;
			end
			MEM_WRITE:
			begin
				if(app_rdy)
				begin
					app_addr_r <= app_addr_r + 'b1000;
					if(wr_addr_cnt == wr_burst_len - 1)// write burst address end
					begin
						app_wdf_end_r <= 1'b0;
						app_en_r <= 1'b0;
					end
					else
					begin
						wr_addr_cnt <= wr_addr_cnt + 1;//write address count
					end
				end
					
				if(wr_burst_data_req)
				begin
					
					if(wr_data_cnt == wr_burst_len - 1)
					begin
						state <= MEM_WRITE_WAIT;
					end
					else
					begin
						wr_data_cnt <= wr_data_cnt + 1;//write data count
					end
				end
				
			end
			READ_END:
				state <= IDLE;
			MEM_WRITE_WAIT:
			begin
				if(app_rdy)
				begin
					app_addr_r <= app_addr_r + 'b1000;
					if(wr_addr_cnt == wr_burst_len - 1)//wait after writing burst address end
					begin
						app_wdf_end_r <= 1'b0;
						app_en_r <= 1'b0;
						if(app_wdf_rdy) 
							state <= WRITE_END;
					end
					else
					begin
						wr_addr_cnt <= wr_addr_cnt + 1;
					end
				end
				else if(~app_en_r & app_wdf_rdy)
					state <= WRITE_END;				
			end
			WRITE_END:
				state <= IDLE;
			default:
				state <= IDLE;
		endcase
	end
end
endmodule 

module mem_test
#(
parameter                     MEM_DATA_BITS   = 64,
parameter                     ADDR_BITS       = 24
)
(
input                                rst,                   //reset
input                                mem_clk,               //input clock
output reg                          rd_burst_req,           //read burst request
output reg                          wr_burst_req,           //write burst request
output reg[9:0]                     rd_burst_len,           //read burst length
output reg[9:0]                     wr_burst_len,           //write burst length
output reg[ADDR_BITS - 1:0]         rd_burst_addr,          //read burst address
output reg[ADDR_BITS - 1:0]         wr_burst_addr,          //write burst address
input                               rd_burst_data_valid,     //read burst data valid
input                               wr_burst_data_req,       // write burst data request
input[MEM_DATA_BITS - 1:0]          rd_burst_data,           //read burst data
output[MEM_DATA_BITS - 1:0]         wr_burst_data,           //write burst data
input                               rd_burst_finish,         // read burst finish flag
input                               wr_burst_finish,         // write burst finish flag
output reg error
);
localparam                          IDLE        =   3'd0;
localparam                          MEM_READ    =   3'd1;
localparam                          MEM_WRITE   =   3'd2;

reg[2:0]                            state;
reg[7:0]                            wr_cnt;
reg[MEM_DATA_BITS - 1:0]            wr_burst_data_reg;
assign wr_burst_data = wr_burst_data_reg;
reg[7:0]                            rd_cnt;
always@(posedge mem_clk or posedge rst)
begin
	if(rst)
		error <= 1'b0;
	else
		error <= (state == MEM_READ) && rd_burst_data_valid && (rd_burst_data != {(MEM_DATA_BITS/8){rd_cnt}});
end
/*************************************************************************
Generate write burst data  when writing burst data request is valid
****************************************************************************/
always@(posedge mem_clk or posedge rst)
begin
	if(rst)
	begin
		wr_burst_data_reg <= {MEM_DATA_BITS{1'b0}};
		wr_cnt <= 8'd0;
	end
	else if(state == MEM_WRITE)
	begin
		if(wr_burst_data_req)//Generate write burst data
			begin
				wr_burst_data_reg <= {(MEM_DATA_BITS/8){wr_cnt}};
				wr_cnt <= wr_cnt + 8'd1;
			end
		else if(wr_burst_finish)
			wr_cnt <= 8'd0;
	end
end
/*************************************************************************
reading burst data count when data is valid
****************************************************************************/
always@(posedge mem_clk or posedge rst)
begin
	if(rst)
	begin
		rd_cnt <= 8'd0;
	end
	else if(state == MEM_READ)
	begin
		if(rd_burst_data_valid)//reading burst data count
			begin
				rd_cnt <= rd_cnt + 8'd1;
			end
		else if(rd_burst_finish)
			rd_cnt <= 8'd0;
	end
	else
		rd_cnt <= 8'd0;
end
/*************************************************************************
Generate a state machine that cyclically reads and writes MIG ip
****************************************************************************/
always@(posedge mem_clk or posedge rst)
begin
	if(rst)
	begin
		state <= IDLE;
		wr_burst_req <= 1'b0;
		rd_burst_req <= 1'b0;
		rd_burst_len <= 10'd128;
		wr_burst_len <= 10'd128;
		rd_burst_addr <= 0;
		wr_burst_addr <= 0;
	end
	else
	begin
		case(state)
			IDLE:
			begin
				state <= MEM_WRITE;
				wr_burst_req <= 1'b1;
				wr_burst_len <= 10'd128;
			end
			MEM_WRITE:
			begin
				if(wr_burst_finish)//Start jumping to MEM_READ when writing burst finish
				begin
					state <= MEM_READ;
					wr_burst_req <= 1'b0;
					rd_burst_req <= 1'b1;
					rd_burst_len <= 10'd128;
					rd_burst_addr <= wr_burst_addr;
				end
			end
			MEM_READ:
			begin
				if(rd_burst_finish)//Start jumping to  MEM_WRITE when reading burst finish
				begin
					state <= MEM_WRITE;
					wr_burst_req <= 1'b1;
					wr_burst_len <= 10'd128;
					rd_burst_req <= 1'b0;
					wr_burst_addr <= wr_burst_addr + 128;
				end
			end
			default:
				state <= IDLE;
		endcase
	end
end

endmodule