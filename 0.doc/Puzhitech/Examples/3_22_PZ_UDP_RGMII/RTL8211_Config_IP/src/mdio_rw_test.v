
module RTL8211_Config_IP(
    input          sys_clk  ,  
    input          sys_rstn,
    //MDIO接口
    output         eth_mdc  , //PHY管理接口的时钟信号
    inout          eth_mdio , //PHY管理接口的双向数据信号

    output  [1:0]  led        //LED连接速率指示
    );
    
    
    parameter CLK_DIV       =6'd60;  
    parameter tx_delay_en   =1'b1;
    parameter rx_delay_en   =1'b1;
    
//wire define
wire          op_exec    ;  //触发开始信号
wire          op_rh_wl   ;  //低电平写，高电平读
wire  [4:0]   op_addr    ;  //寄存器地址
wire  [15:0]  op_wr_data ;  //写入寄存器的数据
wire  [4:0]   phy_addr   ;
wire          op_done    ;  //读写完成
wire  [15:0]  op_rd_data ;  //读出的数据
wire          op_rd_ack  ;  //读应答信号 0:应答 1:未应答
wire          dri_clk    ;  //驱动时钟
wire  [5:0]   cur_state ;


//MDIO接口驱动
mdio_dri #(
    .CLK_DIV    (CLK_DIV)     //分频系数
    )
    u_mdio_dri(
    .clk        (sys_clk),
    .rst_n      (sys_rstn),
    .op_exec    (op_exec   ),
    .op_rh_wl   (op_rh_wl  ),   
    .op_addr    (op_addr   ),   
    .op_wr_data (op_wr_data),   
    .phy_addr   (phy_addr),
    .op_done    (op_done   ),   
    .op_rd_data (op_rd_data),   
    .op_rd_ack  (op_rd_ack ),   
    .dri_clk    (dri_clk   ),  
                 
    .eth_mdc    (eth_mdc   ),   
    .eth_mdio   (eth_mdio  )
);      

//MDIO接口读写控制    
mdio_ctrl #(
    .tx_delay(tx_delay_en),
    .rx_delay(rx_delay_en)
)
  u_mdio_ctrl(
    .clk           (dri_clk),  
    .rst_n         (sys_rstn ),  
    .op_done       (op_done   ),  
    .op_rd_data    (op_rd_data),  
    .op_rd_ack     (op_rd_ack ),  
    .phy_addr      (phy_addr),    
    .op_exec       (op_exec   ),  
    .op_rh_wl      (op_rh_wl  ),  
    .op_addr       (op_addr   ),  
    .op_wr_data    (op_wr_data)
);      

endmodule
