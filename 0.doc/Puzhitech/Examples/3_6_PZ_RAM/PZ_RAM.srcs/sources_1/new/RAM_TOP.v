`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/03 13:40:59
// Design Name: 
// Module Name: RAM_TOP
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


module RAM_TOP(
input sys_clk_p,
input sys_clk_n,
input sys_rstn

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
   wire ena;
   reg [0 : 0] wea;
   reg [9 : 0] addra;
   reg [15 : 0] dina;
   wire [15 : 0] douta;  

assign ena=sys_rstn;



reg [2:0]ram_state;
always@(posedge clk )
    if(!sys_rstn)begin
        ram_state<=0;
        wea<=1;
        addra<=0;
        dina<=0;
    end
    else begin
        case(ram_state)
        0:begin
            if(addra<1023)begin
                wea<=1;
                addra<=addra+1;
                dina<=dina+1;
             end
             else begin
                ram_state<=1;
                wea<=0;
                addra<=0;
                dina<=0;             
             end   
        end
        1:begin
            if(addra<1023)begin
                wea<=0;
                addra<=addra+1;
             end
             else begin
                ram_state<=0;
                wea<=1;
                addra<=0;
                dina<=0;             
             end   
        end     
        default:begin
             ram_state<=0;
             wea<=0;
             addra<=0;
             dina<=0;       
        end
        endcase
    end



blk_mem_gen_0 u0(
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [9 : 0] addra
  .dina(dina),    // input wire [15 : 0] dina
  .douta(douta)  // output wire [15 : 0] douta
);  

ila_0 u1 (
	.clk(clk), // input wire clk
	.probe0(ena), // input wire [0:0]  probe0  
	.probe1(wea), // input wire [0:0]  probe1 
	.probe2(addra), // input wire [9:0]  probe2 
	.probe3(dina), // input wire [15:0]  probe3 
	.probe4(douta) // input wire [15:0]  probe4
);  
endmodule
