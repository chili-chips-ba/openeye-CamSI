`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/03 16:09:43
// Design Name: 
// Module Name: FIFO_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FIFO_TOP(
input sys_clk_p,
input sys_clk_n,
input sys_rstn
    );
    
   wire clk;
   IBUFDS #(
      .DIFF_TERM("FALSE"),       
      .IBUF_LOW_PWR("TRUE"),     
      .IOSTANDARD("DEFAULT")     
   ) IBUFDS_inst (
      .O(clk), 
      .I(sys_clk_p),  
      .IB(sys_clk_n) 
   );
   
 reg [15 : 0] din;
 reg wr_en;
 reg rd_en;
 wire [15 : 0] dout;
 wire full;
 wire empty;
 reg  [1:0]fifo_state;  
   
   always@(posedge clk)
        if(!sys_rstn)begin
            din<=0;
            wr_en<=0;
            rd_en<=0;
            fifo_state<=0;
        end
        else begin
            case(fifo_state)
            0:begin
                if(!full)begin
                    wr_en<=1;
                    din<=din+1;
                end
                else begin
                    wr_en<=0;
                    din<=0;
                    fifo_state<=1;
                end
            end
            1:begin
                if(!empty)begin
                    rd_en<=1;
                end
                else begin
                    rd_en<=0;
                    fifo_state<=0;
                end
            end            
            default:begin
                 din<=0;
                 wr_en<=0;
                 rd_en<=0;
                 fifo_state<=0;           
            end
            endcase
        end
   
fifo_generator_0 u0(
  .clk(clk),      // input wire clk
  .din(din),      // input wire [15 : 0] din
  .wr_en(wr_en),  // input wire wr_en
  .rd_en(rd_en),  // input wire rd_en
  .dout(dout),    // output wire [15 : 0] dout
  .full(full),    // output wire full
  .empty(empty)  // output wire empty
);    

ila_0 u1(
	.clk(clk), // input wire clk
	.probe0(din), // input wire [15:0]  probe0  
	.probe1(wr_en), // input wire [0:0]  probe1 
	.probe2(rd_en), // input wire [0:0]  probe2 
	.probe3(dout), // input wire [15:0]  probe3 
	.probe4(full), // input wire [0:0]  probe4 
	.probe5(empty) // input wire [0:0]  probe5
);    
endmodule
