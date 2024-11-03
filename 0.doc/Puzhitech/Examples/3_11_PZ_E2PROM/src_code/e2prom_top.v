module e2prom_top(
    input               sys_clk_p    ,      //系统时钟
    input               sys_clk_n    ,      //系统时钟
    input               sys_rstn  ,      //系统复位
    //eeprom interface
    output              iic_scl    ,      //eeprom的时钟线scl
    inout               iic_sda    ,      //eeprom的数据线sda
    //user interface
    output              led               //led显示
);

   wire sys_clk;
   IBUFDS #(
      .DIFF_TERM("FALSE"),       
      .IBUF_LOW_PWR("TRUE"),     
      .IOSTANDARD("DEFAULT")     
   ) IBUFDS_inst (
      .O(sys_clk), 
      .I(sys_clk_p),  
      .IB(sys_clk_n) 
   );


//parameter define
parameter    SLAVE_ADDR = 7'b1010000    ; //器件地址(SLAVE_ADDR)
parameter    BIT_CTRL   = 1'b1          ; //字地址位控制参数(16b/8b)
parameter    CLK_FREQ   = 32'd200_000_000; //i2c_dri模块的驱动时钟频率(CLK_FREQ)
parameter    I2C_FREQ   = 24'd250_000   ; //I2C的SCL时钟频率
parameter    L_TIME     = 17'd125_000   ; //led闪烁时间参数

//wire define
wire           dri_clk   ; //I2C操作时钟
wire           i2c_exec  ; //I2C触发控制
wire   [15:0]  i2c_addr  ; //I2C操作地址
wire   [ 7:0]  i2c_data_w; //I2C写入的数据
wire           i2c_done  ; //I2C操作结束标志
wire           i2c_ack   ; //I2C应答标志 0:应答 1:未应答
wire           i2c_rh_wl ; //I2C读写控制
wire   [ 7:0]  i2c_data_r; //I2C读出的数据
wire           rw_done   ; //E2PROM读写测试完成
wire           rw_result ; //E2PROM读写测试结果 0:失败 1:成功 

//*****************************************************
//**                    main code
//*****************************************************

//e2prom读写测试模块
e2prom_rw u_e2prom_rw(
    .clk         (dri_clk   ),  //时钟信号
    .rst_n       (sys_rstn ),  //复位信号
    //i2c interface
    .i2c_exec    (i2c_exec  ),  //I2C触发执行信号
    .i2c_rh_wl   (i2c_rh_wl ),  //I2C读写控制信号
    .i2c_addr    (i2c_addr  ),  //I2C器件内地址
    .i2c_data_w  (i2c_data_w),  //I2C要写的数据
    .i2c_data_r  (i2c_data_r),  //I2C读出的数据
    .i2c_done    (i2c_done  ),  //I2C一次操作完成
    .i2c_ack     (i2c_ack   ),  //I2C应答标志 
    //user interface
    .rw_done     (rw_done   ),  //E2PROM读写测试完成
    .rw_result   (rw_result )   //E2PROM读写测试结果 0:失败 1:成功
);

//i2c驱动模块
i2c_dri #(
    .SLAVE_ADDR  (SLAVE_ADDR),  //EEPROM从机地址
    .CLK_FREQ    (CLK_FREQ  ),  //模块输入的时钟频率
    .I2C_FREQ    (I2C_FREQ  )   //IIC_SCL的时钟频率
) u_i2c_dri(
    .clk         (sys_clk   ),  
    .rst_n       (sys_rstn ),  
    //i2c interface
    .i2c_exec    (i2c_exec  ),  //I2C触发执行信号
    .bit_ctrl    (BIT_CTRL  ),  //器件地址位控制(16b/8b)
    .i2c_rh_wl   (i2c_rh_wl ),  //I2C读写控制信号
    .i2c_addr    (i2c_addr  ),  //I2C器件内地址
    .i2c_data_w  (i2c_data_w),  //I2C要写的数据
    .i2c_data_r  (i2c_data_r),  //I2C读出的数据
    .i2c_done    (i2c_done  ),  //I2C一次操作完成
    .i2c_ack     (i2c_ack   ),  //I2C应答标志
    .scl         (iic_scl   ),  //I2C的SCL时钟信号
    .sda         (iic_sda   ),  //I2C的SDA信号
    //user interface
    .dri_clk     (dri_clk   )   //I2C操作时钟
);


led_alarm #(.L_TIME(L_TIME  )   //控制led闪烁时间
) u_led_alarm(
    .clk         (dri_clk   ),  
    .rst_n       (sys_rstn ), 
    
    .rw_done     (rw_done   ),  
    .rw_result   (rw_result ),
    .led         (led       )    
);

endmodule
