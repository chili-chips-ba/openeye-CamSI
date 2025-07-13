`define SIMULATION

module oserdes_shift (
    input wire clk_par,      
    input wire clk_ser,      
    input wire rst,          
    input wire [9:0] data,   
    output wire dout         
);
    reg [9:0] shift_reg;
    reg [9:0] data_latched;
    
    reg [2:0] bit_counter;
    reg load_flag;
    
    reg clk_par_d;
    wire clk_par_posedge;
    
    always @(posedge clk_ser or posedge rst) begin
        if (rst) begin
            clk_par_d <= 1'b0;
        end else begin
            clk_par_d <= clk_par;
        end
    end
    
    assign clk_par_posedge = clk_par & ~clk_par_d;
    
    always @(posedge clk_ser or posedge rst) begin
        if (rst) begin
            data_latched <= 10'b0;
            load_flag <= 1'b0;
        end else if (clk_par_posedge) begin
            data_latched <= data;
            load_flag <= 1'b1;
        end else if (bit_counter == 3'd0) begin
            load_flag <= 1'b0;
        end
    end
    
    always @(posedge clk_ser or posedge rst) begin
        if (rst) begin
            bit_counter <= 3'd0;
        end else begin
            if (bit_counter == 3'd4)
                bit_counter <= 3'd0;
            else
                bit_counter <= bit_counter + 3'd1;
        end
    end
    
    always @(posedge clk_ser or posedge rst) begin
        if (rst) begin
            shift_reg <= 10'b0;
        end else begin
            if (load_flag && bit_counter == 3'd0) begin
                shift_reg <= data_latched;
            end else begin
                shift_reg <= {2'b00, shift_reg[9:2]};
            end
        end
    end
    
    `ifdef SIMULATION
        reg dout_sim;
        always @(*) begin
            if (clk_ser)
                dout_sim = shift_reg[0];  
            else
                dout_sim = shift_reg[1];  
        end
        assign dout = dout_sim;
    `else
        wire dout_rise, dout_fall;
        
        assign dout_rise = shift_reg[0];  
        assign dout_fall = shift_reg[1];  
        
        ODDR #(
            .DDR_CLK_EDGE("SAME_EDGE"),  
            .INIT(1'b0),                     
            .SRTYPE("SYNC")                  
        ) ODDR_inst (
            .Q(dout),        
            .C(clk_ser),     
            .CE(1'b1),      
            .D1(dout_rise),  
            .D2(dout_fall),  
            .R(rst),         
            .S(1'b0)        
        );
    `endif
    
endmodule
