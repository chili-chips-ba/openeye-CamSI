module e2prom_rw(
    input                 clk        , //时钟信号
    input                 rst_n      , //复位信号

    //i2c interface
    output   reg          i2c_rh_wl  , //I2C读写控制信号
    output   reg          i2c_exec   , //I2C触发执行信号
    output   reg  [15:0]  i2c_addr   , //I2C器件内地址
    output   reg  [ 7:0]  i2c_data_w , //I2C要写的数据
    input         [ 7:0]  i2c_data_r , //I2C读出的数据
    input                 i2c_done   , //I2C一次操作完成
    input                 i2c_ack    , //I2C应答标志

    //user interface
    output   reg          rw_done    , //E2PROM读写测试完成
    output   reg          rw_result    //E2PROM读写测试结果 0:失败 1:成功
);



parameter      WR_WAIT_TIME = 14'd5000; 
parameter      MAX_BYTE     = 16'd256 ; 


reg   [1:0]    cntf  ; 
reg   [13:0]   cntw  ; 


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cntf <= 2'b0;
        i2c_rh_wl <= 1'b0;
        i2c_exec <= 1'b0;
        i2c_addr <= 16'b0;
        i2c_data_w <= 8'b0;
        cntw <= 14'b0;
        rw_done <= 1'b0;
        rw_result <= 1'b0;        
    end
    else begin
        i2c_exec <= 1'b0;
        rw_done <= 1'b0;
        case(cntf)
            2'd0 : begin                                  
                cntw <= cntw + 1'b1;               
                if(cntw == WR_WAIT_TIME - 1'b1) begin  
                    cntw <= 1'b0;
                    if(i2c_addr == MAX_BYTE - 1'b1) begin  
                        i2c_addr <= 1'b0;
                        i2c_rh_wl <= 1'b1;
                        cntf <= 2'd2;
                    end
                    else begin
                        cntf <= cntf + 1'b1;
                        i2c_exec <= 1'b1;
                    end
                end
            end
            2'd1 : begin
                if(i2c_done == 1'b1) begin               
                    cntf <= 2'd0;
                    i2c_addr <= i2c_addr + 1'b1;           
                    i2c_data_w <= i2c_data_w + 1'b1;       
                end    
            end
            2'd2 : begin                                   
                cntf <= cntf + 1'b1;
                i2c_exec <= 1'b1;
            end    
            2'd3 : begin
                if(i2c_done == 1'b1) begin                 
              
                    if((i2c_addr[7:0] != i2c_data_r) || (i2c_ack == 1'b1)) begin
                        rw_done <= 1'b1;
                        rw_result <= 1'b0;
                    end
                    else if(i2c_addr == MAX_BYTE - 1'b1) begin 
                        rw_done <= 1'b1;
                        rw_result <= 1'b1;
                    end    
                    else begin
                        cntf <= 2'd2;
                        i2c_addr <= i2c_addr + 1'b1;
                    end
                end                 
            end
        endcase    
    end
end    

endmodule
