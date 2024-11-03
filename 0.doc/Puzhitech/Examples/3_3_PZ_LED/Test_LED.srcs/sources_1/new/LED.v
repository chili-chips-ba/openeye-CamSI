`timescale 1ns / 1ps
/**********************************************************************************************************
*   例程名称 ：LED
*	例程版本 : V1.0
*   例程说明 ：
*	开发环境 : VIVADO 2019.1
*   发布日期 ：2019/10/21
*   修改作者 ：璞致电子科技（上海）有限公司
*   公司名称 ：璞致电子科技（上海）有限公司 ，Copyright (C), 2018-2025
*   公司网址 ：www.puzhitech.com
**********************************************************************************************************/
module LED(
input sys_clk_p,
input sys_clk_n,
input sys_rstn,
output reg   [1:0]led
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

reg [31:0]cnt;
always@(posedge clk)
    begin
    if(!sys_rstn)begin
        cnt<=0;
    end
    else begin
        if(cnt<50000000)begin
            cnt<=cnt+1;
        end
        else begin
            cnt<=0;
        end
    end
 end   
 
reg [5:0]i; 
always@(posedge clk)
    begin
    if(!sys_rstn)begin
        led<=2'b01;
        i<=0;
    end
    else begin
          if(cnt==49999999)begin
             if(i<2)begin
                i<=i+1;
                led<=led<<1;
             end
             else begin
                i<=0;
                led<=2'b01;
             end   
          end
          else begin
                led<=led;   
          end  
    end
 end 
   
endmodule
