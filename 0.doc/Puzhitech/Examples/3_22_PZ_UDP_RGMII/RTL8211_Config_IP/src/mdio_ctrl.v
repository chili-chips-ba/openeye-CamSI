
module mdio_ctrl#(
    parameter tx_delay=1'b1,
    parameter rx_delay=1'b1
)
(
    input                clk           ,
    input                rst_n         ,
    input                op_done       , //读写完成
    input        [15:0]  op_rd_data    , //读出的数据
    input                op_rd_ack     , //读应答信号 0:应答 1:未应答
    output  reg  [4:0]   phy_addr       ,
    output  reg          op_exec       , //触发开始信号
    output  reg          op_rh_wl      , //低电平写，高电平读
    output  reg  [4:0]   op_addr       , //寄存器地址
    output  reg  [15:0]  op_wr_data     //写入寄存器的数据
    );

//reg define

reg  [23:0]  timer_cnt;       //定时计数器 
reg          timer_done;      //定时完成信号
reg          link_error;      //链路断开或者自协商未完成
reg  [5:0]   flow_cnt;        //流程控制计数器 



//定时计数
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        timer_cnt <= 1'b0;
        timer_done <= 1'b0;
    end
    else begin
        if(timer_cnt == 24'd1_000_000 - 1'b1) begin
            timer_done <= 1'b1;
            timer_cnt <= 1'b0;
        end
        else begin
            timer_done <= 1'b0;
            timer_cnt <= timer_cnt + 1'b1;
        end
    end
end    

//根据软复位信号对MDIO接口进行软复位,并定时读取以太网的连接状态
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        flow_cnt <=0;
        phy_addr <=0;
        op_exec <= 1'b0; 
        op_rh_wl <= 1'b0; 
        op_addr <= 1'b0;       
        op_wr_data <= 1'b0; 
        link_error <= 1'b0;
    end
    else begin
        op_exec <= 1'b0;                     
        case(flow_cnt)
            0:begin
                op_exec <= 1'b1; 
                phy_addr<=0;
                op_rh_wl <= 1'b0; 
                op_addr <= 5'h00; 
                op_wr_data <= 16'hB100;    //Bit[15]=1'b1,表示软复位
                flow_cnt <= flow_cnt+1;    
            end
            1: begin if(op_done)  flow_cnt <= flow_cnt+1;  end  
            2:begin
                    op_exec <= 1'b1; 
                    op_rh_wl <= 1'b1; 
                    op_addr <= 5'h01; 
                    flow_cnt <= flow_cnt+1; 
            end   
            3: begin                       
                if(op_done) begin              //MDIO接口读操作完成
                    if(op_rd_ack == 1'b0 ) //读第一个寄存器，接口成功应答，
                       flow_cnt <= flow_cnt+1; 
                    else begin
                        flow_cnt <= 2;
                        phy_addr<=phy_addr+1;
                     end
                end    
            end
            4: begin      
                if(op_rd_data[5] == 1'b1 && op_rd_data[2] == 1'b1)begin
                    link_error <= 0;
                    flow_cnt <= flow_cnt+1; 
                end
                else begin
                    link_error <= 1'b1; 
                    flow_cnt <= 2;     
               end           
            end     
            5:begin
                    op_exec <= 1'b1; 
                    op_rh_wl <= 1'b1; 
                    op_addr <= 5'h02; 
                    flow_cnt <= flow_cnt+1; 
            end   
            6: begin                       
                if(op_done) begin             
                    if(op_rd_ack == 1'b0 ) 
                       flow_cnt <= flow_cnt+1; 
                    else begin
                        flow_cnt <= 0;
                     end
                end    
            end
            7: begin      
                if(op_rd_data== 16'h001c)begin
                     flow_cnt <= flow_cnt+1; 
                end
                else begin
                     flow_cnt <= 4;     
               end           
            end               
            8:begin
                op_exec <= 1'b1; 
                op_rh_wl <= 1'b0; 
                op_addr <= 5'h1f; 
                op_wr_data <= 16'h0d08;    
               flow_cnt <= flow_cnt+1; 
            end
             9: begin if(op_done)  flow_cnt <= flow_cnt+1;  end  
             10: begin
                op_exec <= 1'b1; 
                op_rh_wl <= 1'b0; 
                op_addr <= 5'h11; 
                op_wr_data <= {7'h0,tx_delay,8'h09}; 
               flow_cnt <= flow_cnt+1; 
            end             
            11: begin if(op_done)  flow_cnt <=flow_cnt+1;     end    
            12:begin
                op_exec <= 1'b1; 
                op_rh_wl <= 1'b0; 
                op_addr <= 5'h1f; 
                op_wr_data <= 16'h0d08;    
                flow_cnt <= flow_cnt+1;    
            end
             13: begin if(op_done) flow_cnt <= flow_cnt+1; end  
             14: begin
                op_exec <= 1'b1; 
                op_rh_wl <= 1'b0; 
                op_addr <= 5'h15; 
                op_wr_data <= {12'h01,rx_delay,3'h001}; 
                flow_cnt <= flow_cnt+1; 
            end             
            15: begin if(op_done)  flow_cnt <=flow_cnt+1;   end   
            16:begin
               if(timer_done) begin      //定时完成,获取以太网连接状态
                    op_exec <= 1'b1; 
                    op_rh_wl <= 1'b1; 
                    op_addr <= 5'h01; 
                    flow_cnt <= flow_cnt+1; 
                end 
            end   
            17: begin                       
                if(op_done) begin              //MDIO接口读操作完成
                    if(op_rd_ack == 1'b0 ) //读第一个寄存器，接口成功应答，
                       flow_cnt <= flow_cnt+1; 
                    else begin
                        flow_cnt <= 0;
                     end
                end    
            end
            18: begin      
                if(op_rd_data[5] == 1'b1 && op_rd_data[2] == 1'b1)begin
                    link_error <= 0;
                    flow_cnt <= 8;    
                end
                else begin
                    link_error <= 1'b1; 
                    flow_cnt <= 0;     
               end           
            end  
            default:begin
                 flow_cnt <=0;
                 phy_addr<=0;
                op_exec <= 1'b0; 
                op_rh_wl <= 1'b0; 
                op_addr <= 1'b0;       
                op_wr_data <= 1'b0; 
                link_error <= 1'b0;        
            end                      
        endcase
    end    
end 

    
endmodule
