`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/03 15:11:22
// Design Name: 
// Module Name: ROM_TOP
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


module ROM_TOP(
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
   
wire ena;
reg  [9:0]addra;
wire [15:0]douta;

assign ena=sys_rstn;


always@(posedge clk)
    begin
    if(!sys_rstn)begin
        addra<=0;
    end
    else begin
        if(addra<1023)begin
            addra<=addra+1;
        end
        else begin
            addra<=0;
        end
    end
 end

blk_mem_gen_0 u0 (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .addra(addra),  // input wire [9 : 0] addra
  .douta(douta)  // output wire [15 : 0] douta
); 
   
ila_0 u1 (
	.clk(clk), // input wire clk
	.probe0(ena), // input wire [0:0]  probe0  
	.probe1(addra), // input wire [9:0]  probe1 
	.probe2(douta) // input wire [15:0]  probe2
);
endmodule
