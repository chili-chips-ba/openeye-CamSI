module rgmii_rx#(
        parameter IDELAY_VALUE = 0 
    )
    (
    input              idelay_clk  , 
    input              rgmii_rxc   , //RGMII接收时钟
    input              rgmii_rx_ctl, //RGMII接收数据控制信号
    input       [3:0]  rgmii_rxd   , //RGMII接收数据    
    output             gmii_rx_clk , //GMII接收时钟
    output             gmii_rx_en  , //GMII接收数据有效信号
    output      [7:0]  gmii_rxd      //GMII接收数据   
    );

//wire define
wire         rgmii_rxc_bufg;     
wire  [3:0]  rgmii_rxd_delay;  
wire         rgmii_rx_ctl_delay;
wire  [1:0]  gmii_rxdv_w;         


///////////////////////main code////////////////////////////////
assign gmii_rx_clk = rgmii_rxc_bufg;
assign gmii_rx_en = gmii_rxdv_w[1]&gmii_rxdv_w[0];



BUFG BUFG_inst (
  .I            (rgmii_rxc),     // 1-bit input: Clock input
  .O            (rgmii_rxc_bufg) // 1-bit output: Clock output
);


(* IODELAY_GROUP = "rgmii_delay" *) 
IDELAYE2 #(
  .DELAY_SRC       ("IDATAIN"),           // Delay input (IDATAIN, DATAIN) 
  .IDELAY_TYPE     ("FIXED"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
  .IDELAY_VALUE    (IDELAY_VALUE),      // Input delay tap setting (0-31)
  .REFCLK_FREQUENCY(200.0)              // IDELAYCTRL clock input frequency in MHz 
)
u_delay_rx_ctrl (
  .CNTVALUEOUT     (),                  // 5-bit output: Counter value output
  .DATAOUT         (rgmii_rx_ctl_delay),// 1-bit output: Delayed data output
  .C               (1'b0),              // 1-bit input: Clock input
  .CE              (1'b0),              // 1-bit input: enable increment/decrement
  .CINVCTRL        (1'b0),              // 1-bit input: Dynamic clock inversion input
  .CNTVALUEIN      (0),              // 5-bit input: Counter value input
  .DATAIN          (1'b0),              // 1-bit input: Internal delay data input
  .IDATAIN         (rgmii_rx_ctl),      // 1-bit input: Data input from the I/O
  .INC             (1'b0),              // 1-bit input: Increment / Decrement tap delay
  .LD              (1'b0),              // 1-bit input: Load IDELAY_VALUE input
  .LDPIPEEN        (1'b0),              // 1-bit input: Enable PIPELINE register
  .REGRST          (1'b0)               // 1-bit input: Active-high reset tap-delay input
);


IDDR #(
    .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"),// "OPPOSITE_EDGE", "SAME_EDGE" 
                                        //    or "SAME_EDGE_PIPELINED" 
    .INIT_Q1  (1'b0),                   // Initial value of Q1: 1'b0 or 1'b1
    .INIT_Q2  (1'b0),                   // Initial value of Q2: 1'b0 or 1'b1
    .SRTYPE   ("SYNC")                  // Set/Reset type: "SYNC" or "ASYNC" 
) u_iddr_rx_ctl (
    .Q1       (gmii_rxdv_w[0]),         // 1-bit output for positive edge of clock
    .Q2       (gmii_rxdv_w[1]),         // 1-bit output for negative edge of clock
    .C        (rgmii_rxc_bufg),        // 1-bit clock input
    .CE       (1'b1),                   // 1-bit clock enable input
    .D        (rgmii_rx_ctl_delay),     // 1-bit DDR data input
    .R        (1'b0),                   // 1-bit reset
    .S        (1'b0)                    // 1-bit set
);


genvar i;
generate for (i=0; i<4; i=i+1)
    (* IODELAY_GROUP = "rgmii_delay" *) 
    begin : rxdata
        //输入延时           
        (* IODELAY_GROUP = "rgmii_delay" *) 
        IDELAYE2 #(
          .DELAY_SRC       ("IDATAIN"),           // Delay input (IDATAIN, DATAIN)        
          .IDELAY_TYPE      ("FIXED"),           // FIXED,VARIABLE,VAR_LOAD,VAR_LOAD_PIPE
          .IDELAY_VALUE     (IDELAY_VALUE),      // Input delay tap setting (0-31)    
          .REFCLK_FREQUENCY (200.0)              // IDELAYCTRL clock input frequency in MHz
        )
        u_delay_rxd (
          .CNTVALUEOUT     (),                  // 5-bit output: Counter value output
          .DATAOUT         (rgmii_rxd_delay[i]),// 1-bit output: Delayed data output
          .C               (1'b0),              // 1-bit input: Clock input
          .CE              (1'b0),              // 1-bit input: enable increment/decrement
          .CINVCTRL        (1'b0),              // 1-bit input: Dynamic clock inversion
          .CNTVALUEIN      (0),              // 5-bit input: Counter value input
          .DATAIN          (1'b0),              // 1-bit input: Internal delay data input
          .IDATAIN         (rgmii_rxd[i]),      // 1-bit input: Data input from the I/O
          .INC             (1'b0),              // 1-bit input: Inc/Decrement tap delay
          .LD              (1'b0),              // 1-bit input: Load IDELAY_VALUE input
          .LDPIPEEN        (1'b0),              // 1-bit input: Enable PIPELINE register 
          .REGRST          (1'b0)               // 1-bit input: Active-high reset tap-delay
        );
          
        IDDR #(
            .DDR_CLK_EDGE("SAME_EDGE_PIPELINED"),// "OPPOSITE_EDGE", "SAME_EDGE" 
                                                //    or "SAME_EDGE_PIPELINED" 
            .INIT_Q1  (1'b0),                   // Initial value of Q1: 1'b0 or 1'b1
            .INIT_Q2  (1'b0),                   // Initial value of Q2: 1'b0 or 1'b1
            .SRTYPE   ("SYNC")                  // Set/Reset type: "SYNC" or "ASYNC" 
        ) u_iddr_rxd (
            .Q1       (gmii_rxd[i]),            // 1-bit output for positive edge of clock
            .Q2       (gmii_rxd[4+i]),          // 1-bit output for negative edge of clock
            .C        (rgmii_rxc_bufg),        // 1-bit clock input rgmii_rxc_bufio
            .CE       (1'b1),                   // 1-bit clock enable input
            .D        (rgmii_rxd_delay[i]),     // 1-bit DDR data input
            .R        (1'b0),                   // 1-bit reset
            .S        (1'b0)                    // 1-bit set
        );
    end
endgenerate


endmodule