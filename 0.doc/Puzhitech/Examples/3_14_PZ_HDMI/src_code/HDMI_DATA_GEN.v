`timescale 1ns / 1ps
/**********************************************************************************************************
*   例程名称 ：HDMI_DATA_GEN
*	例程版本 : V1.0
*   例程说明 ：该模块编写了HDMI输出模式，1280*720  60HZ，每过1s左右切换测试画面
*	开发环境 : VIVADO 2019.1
*   发布日期 ：2019/10/21
*   修改作者 ：璞致电子科技（上海）有限公司
*   公司名称 ：璞致电子科技（上海）有限公司 ，Copyright (C), 2018-2025
*   公司网址 ：www.puzhitech.com
**********************************************************************************************************/


module HDMI_DATA_GEN(
	input				pclk,
	input               rst,
	output [7:0]	    VGA_R,
	output [7:0]	    VGA_G,
	output [7:0]	    VGA_B,
	output			    VGA_HS,
	output			    VGA_VS,
	output			    VGA_DE
	);

//---------------------------------//
//水平参数   1280*720  60HZ
//--------------------------------//
parameter H_Total		=	1650;
parameter H_Sync		=	40;
parameter H_Back		=	220;
parameter H_Active	    =	1280;
parameter H_Front		=	110;
parameter H_Start		=	260;
parameter H_End		=	1540;
//-------------------------------//
// 垂直参数     	
//-------------------------------//
parameter V_Total		=	750;
parameter V_Sync		=	5;
parameter V_Back		=	20;
parameter V_Active  	=	720;
parameter V_Front		=	5;
parameter V_Start		=	25;
parameter V_End		=	745;
reg[11:0]	x_cnt;



always @(posedge pclk)		//水平计数
begin
	if(!rst)
	   x_cnt	<=	1;
	else if(x_cnt==H_Total)
	   x_cnt	<=	1;
	else
	   x_cnt	<=	x_cnt	+	1;
end

reg	hsync_r;
reg	hs_de;
always @(posedge pclk)
begin
	if(!rst)
	   hsync_r	<=	1'b1;
	else if(x_cnt==1)
	   hsync_r	<=	1'b0;
	else if(x_cnt==H_Sync)
	   hsync_r	<=	1'b1;
end

always @(posedge pclk)
begin	
	if(!rst)
	   hs_de	<=	1'b0;
	else if(x_cnt==H_Start)
	   hs_de	<=	1'b1;
	else if(x_cnt==H_End)
	   hs_de	<=	1'b0;
end

reg[11:0]	y_cnt;
always @(posedge pclk)
begin
	if(!rst)
	   y_cnt	<=	1;
	else if(y_cnt==V_Total)
	   y_cnt	<=	1;
	else if(x_cnt==H_Total)
	   y_cnt	<=	y_cnt	+	1;
end

reg	vsync_r;
reg	vs_de;
always @(posedge pclk)
begin
	if(!rst)
	   vsync_r	<=	1'b1;
	else if(y_cnt==1)
	   vsync_r	<=	1'b0;
	else if(y_cnt==V_Sync)
	   vsync_r	<=	1'b1;
end

always @(posedge pclk)
begin	
	if(!rst)
	   vs_de	<=	1'b0;
	else if(y_cnt==V_Start)
	   vs_de	<=	1'b1;
	else if(y_cnt==V_End)
	   vs_de	<=	1'b0;
end



reg[23:0]	color_bar;
always @(posedge pclk)
begin
	if(x_cnt==260)
	   color_bar	<=	24'hff0000;
	else if(x_cnt==420)
	   color_bar	<=	24'h00ff00;
	else if(x_cnt==580)
	   color_bar	<=	24'h0000ff;
	else if(x_cnt==740)
	   color_bar	<=	24'hff00ff;
	else if(x_cnt==900)
	   color_bar	<=	24'hffff00;
	else if(x_cnt==1060)
	   color_bar	<=	24'h00ffff;
	else if(x_cnt==1220)
	   color_bar	<=	24'hffffff;
	else if(x_cnt==1380)
	   color_bar	<=	24'h000000;
	else
	   color_bar	<=	color_bar;
end


reg[3:0]	 dis_mode;
reg[31:0]    dis_mode_ti;
always @(posedge pclk)		
begin
    if(!rst)begin
        dis_mode<=0;
        dis_mode_ti<=0;
    end
    else  begin
          if(dis_mode_ti<100000000)begin
                dis_mode<=dis_mode;
                dis_mode_ti<=dis_mode_ti+1;
          end
          else begin
                if(dis_mode<10)begin
                    dis_mode<=dis_mode+ 1'b1;
                end
                else begin
                    dis_mode<=0;
                end 
                    dis_mode_ti<=0;
          end  
			
	end
end

reg[7:0]	VGA_R_reg;
reg[7:0]	VGA_G_reg;
reg[7:0]	VGA_B_reg;
always @(posedge pclk)
begin  
	if(!rst) 
		begin 
		VGA_R_reg<=0; 
	    VGA_G_reg<=0;
	    VGA_B_reg<=0;		 
		end
   else
     case(dis_mode)
            4'd0:begin
			     VGA_R_reg<=0;                           //LCD显示彩色条
                 VGA_G_reg<=0;
                 VGA_B_reg<=0;
			end
			4'd1:begin
			     VGA_R_reg<=8'b11111111;                 //LCD显示全白
                 VGA_G_reg<=8'b11111111;
                 VGA_B_reg<=8'b11111111;
			end
			4'd2:begin
			     VGA_R_reg<=8'b11111111;                //LCD显示全红
                 VGA_G_reg<=0;
                 VGA_B_reg<=0;  
             end			  
	        4'd3:begin
			     VGA_R_reg<=0;                          //LCD显示全绿
                 VGA_G_reg<=8'b11111111;
                 VGA_B_reg<=0; 
            end					  
           4'd4:begin     
			     VGA_R_reg<=0;                         //LCD显示全蓝
                 VGA_G_reg<=0;
                 VGA_B_reg<=8'b11111111;
			end
		   4'd5:begin     
			     VGA_R_reg<=x_cnt[7:0];                //LCD显示水平渐变色
                 VGA_G_reg<=x_cnt[7:0];
                 VGA_B_reg<=x_cnt[7:0];
			end
		   4'd6:begin     
			     VGA_R_reg<=y_cnt[8:1];                 //LCD显示垂直渐变色
                 VGA_G_reg<=y_cnt[8:1];
                 VGA_B_reg<=y_cnt[8:1];
			end
		   4'd7:begin     
			     VGA_R_reg<=x_cnt[7:0];                 //LCD显示红水平渐变色
                 VGA_G_reg<=0;
                 VGA_B_reg<=0;
			end
		   4'd8:begin     
			     VGA_R_reg<=0;                          //LCD显示绿水平渐变色
                 VGA_G_reg<=x_cnt[7:0];
                 VGA_B_reg<=0;
			end
		   4'd9:begin     
			     VGA_R_reg<=0;                          //LCD显示蓝水平渐变色
                 VGA_G_reg<=0;
                 VGA_B_reg<=x_cnt[7:0];			
			end
		   4'd10:begin     
			     VGA_R_reg<=color_bar[23:16];            //LCD显示彩色条
                 VGA_G_reg<=color_bar[15:8];
                 VGA_B_reg<=color_bar[7:0];			
			end
		   default:begin
			     VGA_R_reg<=8'b11111111;                //LCD显示全白
                 VGA_G_reg<=8'b11111111;
                 VGA_B_reg<=8'b11111111;
			end					  
         endcase
end


assign VGA_R	=	(hs_de & vs_de)?VGA_R_reg:8'h0;
assign VGA_G	=	(hs_de & vs_de)?VGA_G_reg:8'h0;
assign VGA_B	=	(hs_de & vs_de)?VGA_B_reg:8'h0;
assign VGA_HS	=	hsync_r;
assign VGA_VS	=	vsync_r;
assign VGA_DE	=	hs_de&vs_de;


endmodule
