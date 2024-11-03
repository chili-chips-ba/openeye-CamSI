
`timescale 1 ns / 100 ps
module  ax_debounce 
(
    input       clk, 
    input       rst, 
    input       button_in,
    output reg  button_posedge,
    output reg  button_negedge,
    output reg  button_out
);
//// ---------------- internal constants --------------
parameter N = 32 ;           
parameter FREQ = 50;       
parameter MAX_TIME = 20;    
localparam TIMER_MAX_VAL =   MAX_TIME * 1000 * FREQ;
////---------------- internal variables ---------------
reg  [N-1 : 0]  q_reg;     
reg  [N-1 : 0]  q_next;
reg DFF1, DFF2;           
wire q_add;                
wire q_reset;
reg button_out_d0;
//// ------------------------------------------------------

assign q_reset = (DFF1  ^ DFF2);         
assign q_add = ~(q_reg == TIMER_MAX_VAL);
    
//// combo counter to manage q_next 
always @ ( q_reset, q_add, q_reg)
begin
    case( {q_reset , q_add})
        2'b00 :
                q_next <= q_reg;
        2'b01 :
                q_next <= q_reg + 1;
        default :
                q_next <= { N {1'b0} };
    endcase     
end

//// Flip flop inputs and q_reg update
always @ ( posedge clk or posedge rst)
begin
    if(rst == 1'b1)
    begin
        DFF1 <= 1'b0;
        DFF2 <= 1'b0;
        q_reg <= { N {1'b0} };
    end
    else
    begin
        DFF1 <= button_in;
        DFF2 <= DFF1;
        q_reg <= q_next;
    end
end

//// counter control
always @ ( posedge clk or posedge rst)
begin
	if(rst == 1'b1)
		button_out <= 1'b1;
    else if(q_reg == TIMER_MAX_VAL)
        button_out <= DFF2;
    else
        button_out <= button_out;
end

always @ ( posedge clk or posedge rst)
begin
	if(rst == 1'b1)
	begin
		button_out_d0 <= 1'b1;
		button_posedge <= 1'b0;
		button_negedge <= 1'b0;
	end
	else
	begin
		button_out_d0 <= button_out;
		button_posedge <= ~button_out_d0 & button_out;
		button_negedge <= button_out_d0 & ~button_out;
	end	
end
endmodule


