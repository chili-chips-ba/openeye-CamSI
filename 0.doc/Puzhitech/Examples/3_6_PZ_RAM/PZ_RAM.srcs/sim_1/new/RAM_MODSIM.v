`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/03 14:24:25
// Design Name: 
// Module Name: RAM_MODSIM
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


module RAM_MODSIM(

    );
    
    reg clk_p;
    wire clk_n;
    reg sysrstn;
    
    initial begin
    
    #10
        clk_p=1;
        sysrstn=0;
    #10
        clk_p=1;
        sysrstn=1;    
        
    end
    
        always #2.5 clk_p=!clk_p;
        assign clk_n=!clk_n;


RAM_TOP  u0(
.clk_p(clk_p),
.clk_n(clk_n),
.sysrstn(sysrstn)

    );    
    
    
    
    
endmodule
