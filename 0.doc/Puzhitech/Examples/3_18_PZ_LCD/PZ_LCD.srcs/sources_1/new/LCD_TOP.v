`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/28 14:21:36
// Design Name: 
// Module Name: LCD_TOP
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


module LCD_TOP(
    input                sys_clk_p,   //系统时钟
    input                sys_clk_n,   //系统时钟   
    input                rst_n,       //系统复位
    //RGB LCD接口
    output               lcd_hs,      //LCD 行同步信号
    output               lcd_vs,      //LCD 场同步信号
    output               lcd_clk,     //LCD 像素时钟
    inout        [23:0]  lcd_rgb      //LCD RGB888颜色数据
    );                                                      
    
//wire define    
wire          lcd_pclk  ;    //LCD像素时钟

   wire sys_clk ;
   wire sys_rst_n;
   clk_wiz_0 clk
   (
    // Clock out ports
    .clk_out1(lcd_pclk),     // output clk_out1    
    // Status and control signals
    .resetn(rst_n), // input resetn
    .locked(sys_rst_n),       // output locked
   // Clock in ports
    .clk_in1_p(sys_clk_p),    // input clk_in1_p
    .clk_in1_n(sys_clk_n));    // input clk_in1_n

//parameter define  
// 4.3' 480*272
parameter  H_SYNC   =  11'd41;     //行同步
parameter  H_BACK   =  11'd2;      //行显示后沿
parameter  H_DISP   =  11'd480;    //行有效数据
parameter  H_FRONT  =  11'd2;      //行显示前沿
parameter  H_TOTAL  =  11'd525;    //行扫描周期

parameter  V_SYNC   =  11'd10;     //场同步
parameter  V_BACK   =  11'd2;      //场显示后沿
parameter  V_DISP   =  11'd272;    //场有效数据
parameter  V_FRONT  =  11'd2;      //场显示前沿
parameter  V_TOTAL  =  11'd286;    //场扫描周期
   
//parameter define  
parameter WHITE = 24'hFFFFFF;  //白色
parameter BLACK = 24'h000000;  //黑色
parameter RED   = 24'hFF0000;  //红色
parameter GREEN = 24'h00FF00;  //绿色
parameter BLUE  = 24'h0000FF;  //蓝色

//reg define
reg  [10:0] h_sync ;
reg  [10:0] h_back ;
reg  [10:0] h_total;
reg  [10:0] v_sync ;
reg  [10:0] v_back ;
reg  [10:0] v_total;
reg  [10:0] h_cnt  ;
reg  [10:0] v_cnt  ;

//wire define    
wire        lcd_en;
wire        data_req;

reg       [23:0]  pixel_data;  //像素数据
wire      [10:0]  pixel_xpos;  //当前像素点横坐标
wire      [10:0]  pixel_ypos;  //当前像素点纵坐标   
reg       [10:0]  h_disp;      //LCD屏水平分辨率
reg       [10:0]  v_disp;      //LCD屏垂直分辨率  
//*****************************************************
//**                    main code
//*****************************************************
assign lcd_hs  = ( h_cnt < h_sync ) ? 1'b0 : 1'b1;  //行同步信号赋值
assign lcd_vs  = ( v_cnt < v_sync ) ? 1'b0 : 1'b1;  //场同步信号赋值
assign  lcd_clk = lcd_pclk;   //LCD像素时钟
//RGB888数据输出
assign lcd_rgb = lcd_en ? pixel_data : 24'd0;

//使能RGB888数据输出
assign  lcd_en = ((h_cnt >= h_sync + h_back) && (h_cnt < h_sync + h_back + h_disp)
                  && (v_cnt >= v_sync + v_back) && (v_cnt < v_sync + v_back + v_disp)) 
                  ? 1'b1 : 1'b0;

//请求像素点颜色数据输入  
assign data_req = ((h_cnt >= h_sync + h_back - 1'b1) && (h_cnt < h_sync + h_back + h_disp - 1'b1)
                  && (v_cnt >= v_sync + v_back) && (v_cnt < v_sync + v_back + v_disp)) 
                  ? 1'b1 : 1'b0;

//像素点坐标  
assign pixel_xpos = data_req ? (h_cnt - (h_sync + h_back - 1'b1)) : 11'd0;
assign pixel_ypos = data_req ? (v_cnt - (v_sync + v_back - 1'b1)) : 11'd0;

//行场时序参数
always @(*) begin
            h_sync  = H_SYNC; 
            h_back  = H_BACK; 
            h_disp  = H_DISP; 
            h_total = H_TOTAL;
            v_sync  = V_SYNC; 
            v_back  = V_BACK; 
            v_disp  = V_DISP; 
            v_total = V_TOTAL;   
end

//行计数器对像素时钟计数
always@ (posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n) 
        h_cnt <= 11'd0;
    else begin
        if(h_cnt == h_total - 1'b1)
            h_cnt <= 11'd0;
        else
            h_cnt <= h_cnt + 1'b1;           
    end
end

//场计数器对行计数
always@ (posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n) 
        v_cnt <= 11'd0;
    else begin
        if(h_cnt == h_total - 1'b1) begin
            if(v_cnt == v_total - 1'b1)
                v_cnt <= 11'd0;
            else
                v_cnt <= v_cnt + 1'b1;    
        end
    end    
end

//根据当前像素点坐标指定当前像素点颜色数据，在屏幕上显示彩条
always @(posedge lcd_pclk or negedge rst_n) begin
    if(!rst_n)
        pixel_data <= BLACK;
    else begin
        if((pixel_xpos >= 11'd0) && (pixel_xpos < h_disp/5*1))
            pixel_data <= WHITE;
        else if((pixel_xpos >= h_disp/5*1) && (pixel_xpos < h_disp/5*2))    
            pixel_data <= BLACK;
        else if((pixel_xpos >= h_disp/5*2) && (pixel_xpos < h_disp/5*3))    
            pixel_data <= RED;   
        else if((pixel_xpos >= h_disp/5*3) && (pixel_xpos < h_disp/5*4))    
            pixel_data <= GREEN;                
        else 
            pixel_data <= BLUE;      
    end    
end

endmodule

