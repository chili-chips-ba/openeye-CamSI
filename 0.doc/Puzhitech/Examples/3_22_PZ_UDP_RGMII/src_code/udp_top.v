`timescale 1ns / 1ps


module udp_top(
    input              sys_clk_p   , //系统时钟
    input              sys_clk_n   , //系统时钟    
    input              sys_rst_n , //系统复位信号，低电平有效 
    //KSZ9031_RGMII接口   
    output             eth1_mdc  ,
    inout              eth1_mdio ,     
    input              net1_rxc   , //KSZ9031_RGMII接收数据时钟
    input              net1_rx_ctl, //KSZ9031RGMII输入数据有效信号
    input       [3:0]  net1_rxd   , //KSZ9031RGMII输入数据
    output             net1_txc   , //KSZ9031RGMII发送数据时钟    
    output             net1_tx_ctl, //KSZ9031RGMII输出数据有效信号
    output      [3:0]  net1_txd   , //KSZ9031RGMII输出数据          
    output             net1_rst_n , //KSZ9031芯片复位信号，低电平有效 
      
    output             eth2_mdc  ,
    inout              eth2_mdio ,     
    input              net2_rxc   , //KSZ9031_RGMII接收数据时钟
    input              net2_rx_ctl, //KSZ9031RGMII输入数据有效信号
    input       [3:0]  net2_rxd   , //KSZ9031RGMII输入数据
    output             net2_txc   , //KSZ9031RGMII发送数据时钟    
    output             net2_tx_ctl, //KSZ9031RGMII输出数据有效信号
    output      [3:0]  net2_txd   , //KSZ9031RGMII输出数据          
    output             net2_rst_n  //KSZ9031芯片复位信号，低电平有效   
    );
    
wire    clk_200m; 
wire    clk_50m;    
    //MMCM/PLL
clk_wiz_0 u_clk_wiz
(
    .clk_in1_p(sys_clk_p),    
    .clk_in1_n(sys_clk_n),    
    .clk_out1  (clk_200m  ),   
    .clk_out2  (clk_50m  ),     
    .reset     (~sys_rst_n)
);

(* IODELAY_GROUP = "rgmii_delay" *) 
IDELAYCTRL  IDELAYCTRL_inst (
    .RDY(),                      // 1-bit output: Ready output
    .REFCLK(clk_200m),         // 1-bit input: Reference clock input
    .RST(1'b0)                   // 1-bit input: Active high reset input
);


net_udp_loop  net_udp_loop_inst1(
   .clk_200m (clk_200m ) ,   
   .clk_50m  (clk_50m  ) ,  
   .sys_rst_n(sys_rst_n) , //系统复位信号，低电平有效 
    //KSZ9031_RGMII接口   
    .eth_mdc   (eth1_mdc),    // output wire eth_mdc
    .eth_mdio  (eth1_mdio), // inout wire eth_mdio    
    .net_rxc   (net1_rxc   ), //KSZ9031_RGMII接收数据时钟
    .net_rx_ctl(net1_rx_ctl), //KSZ9031RGMII输入数据有效信号
    .net_rxd   (net1_rxd   ), //KSZ9031RGMII输入数据
    .net_txc   (net1_txc   ), //KSZ9031RGMII发送数据时钟    
    .net_tx_ctl(net1_tx_ctl), //KSZ9031RGMII输出数据有效信号
    .net_txd   (net1_txd   ), //KSZ9031RGMII输出数据          
    .net_rst_n (net1_rst_n )  //KSZ9031芯片复位信号，低电平有效   
    );

net_udp_loop  net_udp_loop_inst2(
   .clk_200m (clk_200m ) ,   
   .clk_50m  (clk_50m  ) ,  
   .sys_rst_n(sys_rst_n) , //系统复位信号，低电平有效 
    //KSZ9031_RGMII接口   
    .eth_mdc   (eth2_mdc),    // output wire eth_mdc
    .eth_mdio  (eth2_mdio), // inout wire eth_mdio    
    .net_rxc   (net2_rxc   ), //KSZ9031_RGMII接收数据时钟
    .net_rx_ctl(net2_rx_ctl), //KSZ9031RGMII输入数据有效信号
    .net_rxd   (net2_rxd   ), //KSZ9031RGMII输入数据
    .net_txc   (net2_txc   ), //KSZ9031RGMII发送数据时钟    
    .net_tx_ctl(net2_tx_ctl), //KSZ9031RGMII输出数据有效信号
    .net_txd   (net2_txd   ), //KSZ9031RGMII输出数据          
    .net_rst_n (net2_rst_n )  //KSZ9031芯片复位信号，低电平有效   
    );    
endmodule
