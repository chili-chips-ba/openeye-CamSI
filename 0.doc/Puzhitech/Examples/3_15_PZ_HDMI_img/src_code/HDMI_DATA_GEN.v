`timescale 1ns / 1ps

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


reg  [17 : 0] img_addra;
wire [23 : 0] img_douta;
reg[23:0]	color_bar;
always @(posedge pclk)
begin
    if(!rst)begin  img_addra<=0; color_bar<=0;end
    if(x_cnt >=H_Start+576 && x_cnt <H_Start+576+128 && y_cnt >=V_Start+324 && y_cnt <V_Start+324+72) begin 
        color_bar	<=	img_douta; 
        if(img_addra==9215)begin
            img_addra<=0;
         end
         else begin
            img_addra<=img_addra+1;
         end   
    end
    else if(x_cnt==260)
	   color_bar	<=	24'hff0000;
	else if(x_cnt==420)
	   color_bar	<=	24'h00ff00;
	else if(x_cnt==580)
	   color_bar	<=	24'h0000ff;
	else if(x_cnt==740)
	   color_bar	<=	24'hff00ff;
	else if((x_cnt>=900)&(x_cnt<1060))
	   color_bar	<=	24'hffff00;
	else if(x_cnt==1060)
	   color_bar	<=	24'h00ffff;
	else if(x_cnt==1220)
	   color_bar	<=	24'h0F55F5;
	else if(x_cnt==1380)
	   color_bar	<=	24'hffffff;
	else
	   color_bar	<=	color_bar;
end




assign VGA_R	=	(hs_de & vs_de)?color_bar[23:16]:8'h0;
assign VGA_G	=	(hs_de & vs_de)?color_bar[15:8]:8'h0;
assign VGA_B	=	(hs_de & vs_de)?color_bar[7:0]:8'h0;
assign VGA_HS	=	hsync_r;
assign VGA_VS	=	vsync_r;
assign VGA_DE	=	hs_de&vs_de;

blk_irom img_rom(
  .clka(pclk),    // input wire clka
  .addra(img_addra),  // input wire [16 : 0] addra
  .douta(img_douta)  // output wire [23 : 0] douta
);
endmodule
