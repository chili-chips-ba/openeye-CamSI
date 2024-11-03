`timescale 1ns / 1ps

module net_rstn(
input clk,
input sysrstn,
output reg net_rst_n
    );


//PHY复位
reg [31:0]net_rst_cnt;
always @(posedge clk or negedge sysrstn) begin
    if(!sysrstn) begin
        net_rst_cnt<=0;
    end
    else if(net_rst_cnt<250000) begin
        net_rst_cnt<=net_rst_cnt+1;
    end
    else  begin
        net_rst_cnt<= net_rst_cnt;
    end  
end

always @(posedge clk or negedge sysrstn) begin
    if(!sysrstn) begin
        net_rst_n<=0;
    end
    else if(net_rst_cnt>249999) begin
        net_rst_n<=1;
    end
    else  begin
        net_rst_n<=0;
    end  
end 

endmodule
