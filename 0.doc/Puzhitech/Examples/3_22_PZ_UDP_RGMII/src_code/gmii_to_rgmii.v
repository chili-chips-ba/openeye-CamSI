module gmii_to_rgmii#(
        parameter IDELAY_VALUE = 0 
    )
    (
    input              idelay_clk  , //IDELAY时钟
    input              rgmii_rxc   , //RGMII接收时钟
    input              rgmii_rx_ctl, //RGMII接收数据控制信号
    input       [3:0]  rgmii_rxd   , //RGMII接收数据
    output             rgmii_txc   , //RGMII发送时钟    
    output             rgmii_tx_ctl, //RGMII发送数据控制信号
    output      [3:0]  rgmii_txd   ,  //RGMII发送数据      
    output             gmii_rx_clk , //GMII接收时钟
    output             gmii_rx_en  , //GMII接收数据有效信号
    output      [7:0]  gmii_rxd    , //GMII接收数据
    output             gmii_tx_clk , //GMII发送时钟
    input              gmii_tx_en  , //GMII发送数据使能信号
    input       [7:0]  gmii_txd     //GMII发送数据                   
    );


///////////////////////main code////////////////////////////////
assign gmii_tx_clk = gmii_rx_clk;


rgmii_rx 
    #(
     .IDELAY_VALUE  (IDELAY_VALUE)
     )
    u_rgmii_rx(
    .idelay_clk    (idelay_clk),
    .gmii_rx_clk   (gmii_rx_clk),
    .rgmii_rxc     (rgmii_rxc   ),
    .rgmii_rx_ctl  (rgmii_rx_ctl),
    .rgmii_rxd     (rgmii_rxd   ),
    
    .gmii_rx_en    (gmii_rx_en ),
    .gmii_rxd      (gmii_rxd   )
    );


rgmii_tx u_rgmii_tx(
    .gmii_tx_clk   (gmii_tx_clk ),
    .gmii_tx_en    (gmii_tx_en  ),
    .gmii_txd      (gmii_txd    ),
              
    .rgmii_txc     (rgmii_txc   ),
    .rgmii_tx_ctl  (rgmii_tx_ctl),
    .rgmii_txd     (rgmii_txd   )
    );

endmodule