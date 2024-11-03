
module arp_tx( 
    input                clk        , //时钟信号
    input                rst_n      , //复位信号，低电平有效
    
    input                arp_tx_en  , //ARP发送使能信号
    input                arp_tx_type, //ARP发送类型 0:请求  1:应答
    input        [47:0]  des_mac    , //发送的目标MAC地址
    input        [31:0]  des_ip     , //发送的目标IP地址
    input        [31:0]  crc_data   , //CRC校验数据
    input         [7:0]  crc_next   , //CRC下次校验完成数据
    output  reg          tx_done    , //以太网发送完成信号
    output  reg          gmii_tx_en , //GMII输出数据有效信号
    output  reg  [7:0]   gmii_txd   , //GMII输出数据
    output  reg          crc_en     , //CRC开始校验使能
    output  reg          crc_clr      //CRC数据复位信号 
    );

//parameter define
parameter  BOARD_MAC = 48'h99_00_33_11_00_00;     
parameter  BOARD_IP  = {8'd192,8'd168,8'd1,8'd10};  
parameter  DES_MAC   = 48'hff_ff_ff_ff_ff_ff;       
parameter  DES_IP    = {8'd192,8'd168,8'd1,8'd112};  

localparam  st_idle      = 5'b0_0001; //初始状态，等待开始发送信号
localparam  st_preamble  = 5'b0_0010; //发送前导码+帧起始界定符
localparam  st_eth_head  = 5'b0_0100; //发送以太网帧头
localparam  st_arp_data  = 5'b0_1000; //
localparam  st_crc       = 5'b1_0000; //发送CRC校验值

localparam  ETH_TYPE     = 16'h0806 ; //以太网帧类型 ARP协议
localparam  HD_TYPE      = 16'h0001 ; //硬件类型 以太网
localparam  PROTOCOL_TYPE= 16'h0800 ; //上层协议为IP协议
localparam  MIN_DATA_NUM = 16'd46   ;    

//reg define
reg  [4:0]  cur_state     ;
reg  [4:0]  next_state    ;
                          
reg  [7:0]  preamble[7:0] ; //前导码+SFD
reg  [7:0]  eth_head[13:0]; //以太网首部
reg  [7:0]  arp_data[27:0]; //ARP数据
                            
reg         tx_en_d0      ; //arp_tx_en信号延时
reg         tx_en_d1      ; 
reg         skip_en       ; //控制状态跳转使能信号
reg  [5:0]  cnt           ; 
reg  [4:0]  data_cnt      ; //发送数据个数计数器
reg         tx_done_t     ; 
                                
//wire define                   
wire        pos_tx_en     ; //arp_tx_en信号上升沿

///////////////////////main code////////////////////////////////

assign  pos_tx_en = (~tx_en_d1) & tx_en_d0;
                           
//对arp_tx_en信号延时打拍两次,用于采arp_tx_en的上升沿
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        tx_en_d0 <= 1'b0;
        tx_en_d1 <= 1'b0;
    end    
    else begin
        tx_en_d0 <= arp_tx_en;
        tx_en_d1 <= tx_en_d0;
    end
end 

//状态机
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
        st_idle : begin                     //空闲状态
            if(skip_en)                
                next_state = st_preamble;
            else
                next_state = st_idle;
        end                          
        st_preamble : begin                 //发送前导码+帧起始界定符
            if(skip_en)
                next_state = st_eth_head;
            else
                next_state = st_preamble;      
        end
        st_eth_head : begin                 //发送以太网首部
            if(skip_en)
                next_state = st_arp_data;
            else
                next_state = st_eth_head;      
        end              
        st_arp_data : begin                 //发送ARP数据                      
            if(skip_en)
                next_state = st_crc;
            else
                next_state = st_arp_data;      
        end
        st_crc: begin                       //发送CRC校验值
            if(skip_en)
                next_state = st_idle;
            else
                next_state = st_crc;      
        end
        default : next_state = st_idle;   
    endcase
end                      

//时序电路描述状态输出，发送以太网数据
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        skip_en <= 1'b0; 
        cnt <= 6'd0;
        data_cnt <= 5'd0;
        crc_en <= 1'b0;
        gmii_tx_en <= 1'b0;
        gmii_txd <= 8'd0;
        tx_done_t <= 1'b0; 
        
        //初始化数组    
        //前导码 7个8'h55 + 1个8'hd5 
        preamble[0] <= 8'h55;                
        preamble[1] <= 8'h55;
        preamble[2] <= 8'h55;
        preamble[3] <= 8'h55;
        preamble[4] <= 8'h55;
        preamble[5] <= 8'h55;
        preamble[6] <= 8'h55;
        preamble[7] <= 8'hd5;
        //以太网帧头 
        eth_head[0] <= DES_MAC[47:40];      //目的MAC地址
        eth_head[1] <= DES_MAC[39:32];
        eth_head[2] <= DES_MAC[31:24];
        eth_head[3] <= DES_MAC[23:16];
        eth_head[4] <= DES_MAC[15:8];
        eth_head[5] <= DES_MAC[7:0];        
        eth_head[6] <= BOARD_MAC[47:40];    //源MAC地址
        eth_head[7] <= BOARD_MAC[39:32];    
        eth_head[8] <= BOARD_MAC[31:24];    
        eth_head[9] <= BOARD_MAC[23:16];    
        eth_head[10] <= BOARD_MAC[15:8];    
        eth_head[11] <= BOARD_MAC[7:0];     
        eth_head[12] <= ETH_TYPE[15:8];     //以太网帧类型
        eth_head[13] <= ETH_TYPE[7:0];      
        //ARP数据                           
        arp_data[0] <= HD_TYPE[15:8];       //硬件类型
        arp_data[1] <= HD_TYPE[7:0];
        arp_data[2] <= PROTOCOL_TYPE[15:8]; //上层协议类型
        arp_data[3] <= PROTOCOL_TYPE[7:0];
        arp_data[4] <= 8'h06;               //硬件地址长度,6
        arp_data[5] <= 8'h04;               //协议地址长度,4
        arp_data[6] <= 8'h00;               //OP,操作码 8'h01：ARP请求 8'h02:ARP应答
        arp_data[7] <= 8'h01;
        arp_data[8] <= BOARD_MAC[47:40];    //发送端(源)MAC地址
        arp_data[9] <= BOARD_MAC[39:32];
        arp_data[10] <= BOARD_MAC[31:24];
        arp_data[11] <= BOARD_MAC[23:16];
        arp_data[12] <= BOARD_MAC[15:8];
        arp_data[13] <= BOARD_MAC[7:0];
        arp_data[14] <= BOARD_IP[31:24];    //发送端(源)IP地址
        arp_data[15] <= BOARD_IP[23:16];
        arp_data[16] <= BOARD_IP[15:8];
        arp_data[17] <= BOARD_IP[7:0];
        arp_data[18] <= DES_MAC[47:40];     //接收端(目的)MAC地址
        arp_data[19] <= DES_MAC[39:32];
        arp_data[20] <= DES_MAC[31:24];
        arp_data[21] <= DES_MAC[23:16];
        arp_data[22] <= DES_MAC[15:8];
        arp_data[23] <= DES_MAC[7:0];  
        arp_data[24] <= DES_IP[31:24];      //接收端(目的)IP地址
        arp_data[25] <= DES_IP[23:16];
        arp_data[26] <= DES_IP[15:8];
        arp_data[27] <= DES_IP[7:0];
    end
    else begin
        skip_en <= 1'b0;
        crc_en <= 1'b0;
        gmii_tx_en <= 1'b0;
        tx_done_t <= 1'b0;
        case(next_state)
            st_idle : begin
                if(pos_tx_en) begin
                    skip_en <= 1'b1;  
                    //如果目标MAC地址和IP地址已经更新,则发送正确的地址
                    if((des_mac != 48'b0) || (des_ip != 32'd0)) begin
                        eth_head[0] <= des_mac[47:40];
                        eth_head[1] <= des_mac[39:32];
                        eth_head[2] <= des_mac[31:24];
                        eth_head[3] <= des_mac[23:16];
                        eth_head[4] <= des_mac[15:8];
                        eth_head[5] <= des_mac[7:0];  
                        arp_data[18] <= des_mac[47:40];
                        arp_data[19] <= des_mac[39:32];
                        arp_data[20] <= des_mac[31:24];
                        arp_data[21] <= des_mac[23:16];
                        arp_data[22] <= des_mac[15:8];
                        arp_data[23] <= des_mac[7:0];  
                        arp_data[24] <= des_ip[31:24];
                        arp_data[25] <= des_ip[23:16];
                        arp_data[26] <= des_ip[15:8];
                        arp_data[27] <= des_ip[7:0];
                    end
                    if(arp_tx_type == 1'b0)
                        arp_data[7] <= 8'h01;            //ARP请求 
                    else 
                        arp_data[7] <= 8'h02;            //ARP应答
                end    
            end                                                                   
            st_preamble : begin                          //发送前导码+帧起始界定符
                gmii_tx_en <= 1'b1;
                gmii_txd <= preamble[cnt];
                if(cnt == 6'd7) begin                        
                    skip_en <= 1'b1;
                    cnt <= 1'b0;    
                end
                else    
                    cnt <= cnt + 1'b1;                     
            end
            st_eth_head : begin                          //发送以太网首部
                gmii_tx_en <= 1'b1;
                crc_en <= 1'b1;
                gmii_txd <= eth_head[cnt];
                if (cnt == 6'd13) begin
                    skip_en <= 1'b1;
                    cnt <= 1'b0;
                end    
                else    
                    cnt <= cnt + 1'b1;    
            end                    
            st_arp_data : begin                          //发送ARP数据  
                crc_en <= 1'b1;
                gmii_tx_en <= 1'b1;
                //至少发送46个字节
                if (cnt == MIN_DATA_NUM - 1'b1) begin    
                    skip_en <= 1'b1;
                    cnt <= 1'b0;
                    data_cnt <= 1'b0;
                end    
                else    
                    cnt <= cnt + 1'b1;  
                if(data_cnt <= 6'd27) begin
                    data_cnt <= data_cnt + 1'b1;
                    gmii_txd <= arp_data[data_cnt];
                end    
                else
                    gmii_txd <= 8'd0;                    //Padding,填充0
            end
            st_crc      : begin                          //发送CRC校验值
                gmii_tx_en <= 1'b1;
                cnt <= cnt + 1'b1;
                if(cnt == 6'd0)
                    gmii_txd <= {~crc_next[0], ~crc_next[1], ~crc_next[2],~crc_next[3],
                                 ~crc_next[4], ~crc_next[5], ~crc_next[6],~crc_next[7]};
                else if(cnt == 6'd1)
                    gmii_txd <= {~crc_data[16], ~crc_data[17], ~crc_data[18],
                                 ~crc_data[19], ~crc_data[20], ~crc_data[21], 
                                 ~crc_data[22],~crc_data[23]};
                else if(cnt == 6'd2) begin
                    gmii_txd <= {~crc_data[8], ~crc_data[9], ~crc_data[10],
                                 ~crc_data[11],~crc_data[12], ~crc_data[13], 
                                 ~crc_data[14],~crc_data[15]};                              
                end
                else if(cnt == 6'd3) begin
                    gmii_txd <= {~crc_data[0], ~crc_data[1], ~crc_data[2],~crc_data[3],
                                 ~crc_data[4], ~crc_data[5], ~crc_data[6],~crc_data[7]};  
                    tx_done_t <= 1'b1;
                    skip_en <= 1'b1;
                    cnt <= 1'b0;
                end                                                                                                                                            
            end                          
            default :;  
        endcase                                             
    end
end            

//发送完成信号及crc值复位信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        tx_done <= 1'b0;
        crc_clr <= 1'b0;
    end
    else begin
        tx_done <= tx_done_t;
        crc_clr <= tx_done_t;
    end
end

endmodule