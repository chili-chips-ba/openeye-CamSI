`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 17:13:48
// Design Name: 
// Module Name: Top_ad_da_hdmi
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


module Top_ad_da(
        input        		     sys_clk_p,       
        input        		     sys_clk_n,        
        input                    sys_rstn,               
        input [15:0]             ad_data,          
        input                    ad_busy,          
        input                    first_data,       
        output [2:0]             ad_os,            
        output                   ad_cs,            
        output                   ad_rd,            
        output                   ad_reset,         
        output                   ad_convst,         
        output                   ad_range,
        output                   ad_par_mode,  
        output                   da_spi_clk_o,          
        output                   da_nsync,
        output                   da_spi_mosi,               
        input                    da_spi_miso         
    );
    
    

    wire clk;
    wire clk_spi;
    wire locked;
   clk_wiz_0   U0(
        .clk_in1_p          (sys_clk_p),    
        .clk_in1_n          (sys_clk_n),   
        .resetn             (sys_rstn),
        .clk_out1           (clk),
        .clk_out2           (clk_spi),
        .locked             (locked)
    );     
  
 AD7606  u_AD7606(              
    .clk         (clk        ),  
    .rst_n       (sys_rstn   ),         
    .ad_data     (ad_data    ),     
    .ad_busy     (ad_busy    ),     
    .first_data  (first_data ),     
    .ad_os       (ad_os      ),     
    .ad_cs       (ad_cs      ),     
    .ad_rd       (ad_rd      ),     
    .ad_reset    (ad_reset   ),     
    .ad_convst   (ad_convst  ),      
    .ad_range    (ad_range   ),
    .ad_par_mode (ad_par_mode)  ); 
   
   
PZ_DA_WAVE u_PZ_DA_WAVE(
   .clk          (clk_spi     ), 
   .rst_n        (sys_rstn    ),
   .da_spi_clk_o (da_spi_clk_o),        
   .da_nsync     (da_nsync    ),
   .da_spi_mosi  (da_spi_mosi ),             
   .da_spi_miso  (da_spi_miso ) );  
   
endmodule
