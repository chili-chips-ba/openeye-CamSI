`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/03 17:22:18
// Design Name: 
// Module Name: PLL_TOP
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


module PLL_TOP(
input sys_clk_p,
input sys_clk_n,
input sys_rstn
    );
  
  wire sys_clk_100m;
  wire sys_clk_20m;
  wire sys_clk_10m; 
   
  clk_wiz_0 u0
   (
    // Clock out ports
    .clk_out1(sys_clk_100m),     // output sys_clk_out1
    .clk_out2(sys_clk_20m),     // output sys_clk_out2
    .clk_out3(sys_clk_10m),     // output sys_clk_out3
    // Status and control signals
    .resetn(sys_rstn), // input resetn
    .locked(),       // output locked
   // Clock in ports
    .clk_in1_p(sys_clk_p),    // input sys_clk_in1_p
    .clk_in1_n(sys_clk_n));    // input sys_clk_in1_n    
    
ila_0 u1(
	.clk(sys_clk_100m), // input wire clk


	.probe0(sys_clk_20m), // input wire [0:0]  probe0  
	.probe1(sys_clk_10m)  // input wire [0:0]  probe1 
);    
  
    
endmodule
