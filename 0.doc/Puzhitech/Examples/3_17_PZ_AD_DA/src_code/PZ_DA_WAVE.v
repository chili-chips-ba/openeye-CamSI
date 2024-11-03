`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/12 09:54:36
// Design Name: 
// Module Name: PZ_DA_WAVE
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
module PZ_DA_WAVE(
    input        		    clk,             
    input                   rst_n,    
	output          	    da_spi_clk_o,          
	output        	     	da_nsync,
	output        		    da_spi_mosi, 	          
    input                   da_spi_miso
    );
    

    wire locked;
    wire da_clk;
    
    assign da_clk=clk;
    assign locked=rst_n;

parameter wave_fre_value=4;

reg [9:0] rom_addr;
wire [11:0] rom_data; 

reg  da_en;
wire da_done;
wire [15:0]da_value_o;
reg  [15:0]da_value_i;
reg  [7:0] da_state;
reg  [31:0]wave_fre;

wire        da_spi_clk;
assign  da_spi_clk_o=clk;
assign  da_spi_clk=clk;
//控制dac输出
 always @(negedge da_spi_clk)
     if(!locked)begin
        rom_addr <= 0;
        da_en <=0;
        da_value_i<=0;
        da_state<=0;
     end
     else   begin
                case(da_state)
                    0:begin
                        if( da_done ) begin da_en <=0; da_state<=da_state+1; rom_addr <= 0;  end                   
                        else begin da_en <=1; da_value_i<={4'b1001,12'h00};end  
                    end
                    1:begin 
                        if( da_done ) begin
                             da_en <=0;
                             rom_addr <= rom_addr + 1'b1 ; 
                         end                   
                        else begin da_en <=1; da_value_i<={4'b1100,rom_data};end  
                    end                
                default:begin  da_state<=0;    end
               endcase   
         end	
//sin  rom    
sin_rom ROM1
    (
    .clka(da_spi_clk), // input clka
    .addra(rom_addr), // input [8 : 0] addra
    .douta(rom_data) // output [7 : 0] douta
    );  
  
//dac驱动模块         
PZ_dac  DAC(                 
    .rst_n(locked), 
    .da_en(da_en), 
    .da_value_i(da_value_i),
    .da_fre(1),   
    .da_value_o(da_value_o),  
    .da_done(da_done),             
	.da_spi_clk( da_spi_clk),          
	.da_nsync(da_nsync),
	.da_spi_mosi(da_spi_mosi), 	          
    .da_spi_miso(da_spi_miso)
    );    

    
    
endmodule
