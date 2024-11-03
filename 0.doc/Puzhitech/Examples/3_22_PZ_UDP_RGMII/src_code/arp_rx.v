
module arp_rx
  #(
    parameter BOARD_MAC = 48'h00_11_22_33_44_55,  
    parameter BOARD_IP = {8'd192,8'd168,8'd1,8'd10}      
    )
   (
    input                clk        , //时钟信号
    input                rst_n      , //复位信号，低电平有效
                                    
    input                gmii_rx_en , //GMII输入数据有效信号
    input        [7:0]   gmii_rxd   , //GMII输入数据
    output  reg          arp_rx_done, //ARP接收完成信号
    output  reg          arp_rx_type, //ARP接收类型 0:请求  1:应答
    output  reg  [47:0]  src_mac    , //接收到的源MAC地址
    output  reg  [31:0]  src_ip       //接收到的源IP地址
    );

//parameter define
localparam  st_idle     = 5'b0_0001; //初始状态，等待接收前导码
localparam  st_preamble = 5'b0_0010; //接收前导码状态 
localparam  st_eth_head = 5'b0_0100; //接收以太网帧头
localparam  st_arp_data = 5'b0_1000; //接收ARP数据
localparam  st_rx_end   = 5'b1_0000; //接收结束

localparam  ETH_TPYE = 16'h0806;     //以太网帧类型 ARP

//reg define
reg    [4:0]   cur_state ;
reg    [4:0]   next_state;
                         
reg            skip_en   ; //控制状态跳转使能信号
reg            error_en  ; //解析错误使能信号
reg    [4:0]   cnt       ; //解析数据计数器
reg    [47:0]  des_mac_t ; //接收到的目的MAC地址
reg    [31:0]  des_ip_t  ; //接收到的目的IP地址
reg    [47:0]  src_mac_t ; //接收到的源MAC地址
reg    [31:0]  src_ip_t  ; //接收到的源IP地址
reg    [15:0]  eth_type  ; //以太网类型
reg    [15:0]  op_data   ; //操作码

///////////////////////main code////////////////////////////////

//(三段式状态机)同步时序描述状态转移
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cur_state <= st_idle;  
    else
        cur_state <= next_state;
end

//组合逻辑判断状态转移条件
always @(*) begin
    next_state = st_idle;
    case(cur_state)
        st_idle : begin                     //等待接收前导码
            if(skip_en) 
                next_state = st_preamble;
            else
                next_state = st_idle;    
        end
        st_preamble : begin                 //接收前导码
            if(skip_en) 
                next_state = st_eth_head;
            else if(error_en) 
                next_state = st_rx_end;    
            else
                next_state = st_preamble;   
        end
        st_eth_head : begin                 //接收以太网帧头
            if(skip_en) 
                next_state = st_arp_data;
            else if(error_en) 
                next_state = st_rx_end;
            else
                next_state = st_eth_head;   
        end  
        st_arp_data : begin                  //接收ARP数据
            if(skip_en)
                next_state = st_rx_end;
            else if(error_en)
                next_state = st_rx_end;
            else
                next_state = st_arp_data;   
        end                  
        st_rx_end : begin                   //接收结束
            if(skip_en)
                next_state = st_idle;
            else
                next_state = st_rx_end;          
        end
        default : next_state = st_idle;
    endcase                                          
end    

//时序电路描述状态输出,解析以太网数据
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        skip_en <= 1'b0;
        error_en <= 1'b0;
        cnt <= 5'd0;
        des_mac_t <= 48'd0;
        des_ip_t <= 32'd0;
        src_mac_t <= 48'd0;
        src_ip_t <= 32'd0;        
        eth_type <= 16'd0;
        op_data <= 16'd0;
        arp_rx_done <= 1'b0;
        arp_rx_type <= 1'b0;
        src_mac <= 48'd0;
        src_ip <= 32'd0;
    end
    else begin
        skip_en <= 1'b0;
        error_en <= 1'b0;  
        arp_rx_done <= 1'b0;
        case(next_state)
            st_idle : begin                                  //检测到第一个8'h55
                if((gmii_rx_en == 1'b1) && (gmii_rxd == 8'h55)) 
                    skip_en <= 1'b1;
            end
            st_preamble : begin
                if(gmii_rx_en) begin                         //解析前导码
                    cnt <= cnt + 5'd1;
                    if((cnt < 5'd6) && (gmii_rxd != 8'h55))  //7个8'h55  
                        error_en <= 1'b1;
                    else if(cnt==5'd6) begin
                        cnt <= 5'd0;
                        if(gmii_rxd==8'hd5)                  //1个8'hd5
                            skip_en <= 1'b1;
                        else
                            error_en <= 1'b1;    
                    end  
                end  
            end
            st_eth_head : begin
                if(gmii_rx_en) begin
                    cnt <= cnt + 5'b1;
                    if(cnt < 5'd6) 
                        des_mac_t <= {des_mac_t[39:0],gmii_rxd};
                    else if(cnt == 5'd6) begin
                        //判断MAC地址是否为开发板MAC地址或者公共地址
                        if((des_mac_t != BOARD_MAC)
                            && (des_mac_t != 48'hff_ff_ff_ff_ff_ff))           
                            error_en <= 1'b1;
                    end
                    else if(cnt == 5'd12) 
                        eth_type[15:8] <= gmii_rxd;          //以太网协议类型
                    else if(cnt == 5'd13) begin
                        eth_type[7:0] <= gmii_rxd;
                        cnt <= 5'd0;
                        if(eth_type[15:8] == ETH_TPYE[15:8]  //判断是否为ARP协议
                            && gmii_rxd == ETH_TPYE[7:0])
                            skip_en <= 1'b1; 
                        else
                            error_en <= 1'b1;                       
                    end        
                end  
            end
            st_arp_data : begin
                if(gmii_rx_en) begin
                    cnt <= cnt + 5'd1;
                    if(cnt == 5'd6) 
                        op_data[15:8] <= gmii_rxd;           //操作码       
                    else if(cnt == 5'd7)
                        op_data[7:0] <= gmii_rxd;
                    else if(cnt >= 5'd8 && cnt < 5'd14)      //源MAC地址
                        src_mac_t <= {src_mac_t[39:0],gmii_rxd};
                    else if(cnt >= 5'd14 && cnt < 5'd18)     //源IP地址
                        src_ip_t<= {src_ip_t[23:0],gmii_rxd};
                    else if(cnt >= 5'd24 && cnt < 5'd28)     //目标IP地址
                        des_ip_t <= {des_ip_t[23:0],gmii_rxd};
                    else if(cnt == 5'd28) begin
                        cnt <= 5'd0;
                        if(des_ip_t == BOARD_IP) begin       //判断目的IP地址和操作码
                            if((op_data == 16'd1) || (op_data == 16'd2)) begin
                                skip_en <= 1'b1;
                                arp_rx_done <= 1'b1;
                                src_mac <= src_mac_t;
                                src_ip <= src_ip_t;
                                src_mac_t <= 48'd0;
                                src_ip_t <= 32'd0;
                                des_mac_t <= 48'd0;
                                des_ip_t <= 32'd0;
                                if(op_data == 16'd1)         
                                    arp_rx_type <= 1'b0;     //ARP请求
                                else
                                    arp_rx_type <= 1'b1;     //ARP应答
                            end
                            else
                                error_en <= 1'b1;
                        end 
                        else
                            error_en <= 1'b1;
                    end
                end                                
            end
            st_rx_end : begin     
                cnt <= 5'd0;
                //单包数据接收完成   
                if(gmii_rx_en == 1'b0 && skip_en == 1'b0)
                    skip_en <= 1'b1; 
            end    
            default : ;
        endcase                                                        
    end
end


endmodule