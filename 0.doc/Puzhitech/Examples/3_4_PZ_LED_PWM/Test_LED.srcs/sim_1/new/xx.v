`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/26 09:56:27
// Design Name: 
// Module Name: xx
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


module xx(

    );
    
  wire [4:0]led;  
    reg clk;
    reg sysrst;
 LED  u1(
.clk(clk),
.sysrst(sysrst),
.led(led)
    );
    initial begin
    #10
    clk<=0;
    sysrst<=0;
    #10
     sysrst<=1;
    end
    always #10 clk=!clk;
    
endmodule
