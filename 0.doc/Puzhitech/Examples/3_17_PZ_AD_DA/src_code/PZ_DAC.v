`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/06 09:59:51
// Design Name: 
// Module Name: PZ_dac
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


module PZ_dac(  
	input       		    da_spi_clk,                
    input        		    rst_n, 
    input                   da_en, 
    input           [15:0]  da_value_i,
    input           [31:0]  da_fre,   
    output          [15:0]  da_value_o, 
    output  reg             da_done,                        
	output  reg      		da_nsync,
	output  reg      		da_spi_mosi, 	          
    input                   da_spi_miso
    );
     
    reg [7:0]i;
    reg [31:0]delay_cnt;
    reg [7:0]da_state; 
    reg [15:0]da_value_out;
    assign da_value_o= da_value_out;
always@(negedge da_spi_clk)
    begin    
        if(!rst_n)begin
            da_state<=0;
            da_value_out<=0;
            da_nsync<=1;
            da_done<=0;
            i<=0;
        end
        else begin
            case(da_state)
            0:begin
                if(!da_en)begin
                    da_nsync<=1;
                    da_state<=da_state;             
                end
                else begin
                    da_nsync<=0;
                    da_state<=da_state+1;
                end
            end   
            1:begin
                if(i<16)begin
                    da_spi_mosi<=da_value_i[15-i];
                    da_value_out<={da_value_out[14:0],da_spi_miso};
                    i<=i+1;
                end
                else begin
                    da_nsync<=1;
                    i<=0;
                    da_state<=da_state+1;
                end 
            end                
            2:begin
                if(i<16)begin
                    da_value_out<={da_value_out[14:0],da_spi_miso};
                    i<=i+1;
                end
                else begin
                    da_nsync<=1;
                    i<=0;
                    da_done<=1;
                    da_state<=da_state+1;
                end      
             end   
             3:begin
                 da_done<=0;
                if(delay_cnt<da_fre)begin
                    delay_cnt<=delay_cnt+1;
                end
                else begin
                    delay_cnt<=0;
                    da_state<=0;
                end      
             end               
            endcase
        end
    end
endmodule
