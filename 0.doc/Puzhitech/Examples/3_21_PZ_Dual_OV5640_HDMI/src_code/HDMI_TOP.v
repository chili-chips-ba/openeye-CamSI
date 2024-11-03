module  hdmi_top(
    input           pixel_clk,
    input           pixel_clk_5x,    
    input           sys_rst_n,
   //hdmi接口
   output      HDMI_CLK_P,
   output      HDMI_CLK_N,
   output      HDMI_D0_P,
   output      HDMI_D0_N,
   output      HDMI_D1_P,
   output      HDMI_D1_N,
   output      HDMI_D2_P,
   output      HDMI_D2_N,
   
   output      HDMI_1_CLK_P,
   output      HDMI_1_CLK_N,
   output      HDMI_1_D0_P,
   output      HDMI_1_D0_N,
   output      HDMI_1_D1_P,
   output      HDMI_1_D1_N,
   output      HDMI_1_D2_P,
   output      HDMI_1_D2_N,      
   //用户接口 
    output          video_vs,       //HDMI场信号      
    output  [10:0]  h_disp,         //HDMI屏水平分辨率  
    input   [15:0]  data_in,        //输入数据
    output          data_req        //请求数据输入   
);

//wire define
wire          video_hs;
wire          video_de;
wire  [23:0]  video_rgb;
wire  [15:0]  video_rgb_565;

//将摄像头16bit数据转换为24bit的hdmi数据
assign video_rgb  = {video_rgb_565[15:11],3'b000,video_rgb_565[10:5],2'b00,
                    video_rgb_565[4:0],3'b000};  
 
//例化视频显示驱动模块
video_driver u_video_driver(
    .pixel_clk      (pixel_clk),
    .sys_rst_n      (sys_rst_n),

    .video_hs       (video_hs),
    .video_vs       (video_vs),
    .video_de       (video_de),
    .video_rgb      (video_rgb_565),
   
    .data_req       (data_req),
    .h_disp         (h_disp),
    .v_disp         (), 
    .pixel_data     (data_in)
    );
       
//例化HDMI驱动模块              
HDMI_IP U1(
        .PXLCLK_I           (pixel_clk),    
        .PXLCLK_5X_I        (pixel_clk_5x), 
        .LOCKED_I           (sys_rst_n),
        .RST_N              (1'b1),
        .VGA_RGB            (video_rgb), 
        .VGA_HS             (video_hs),  
        .VGA_VS             (video_vs),  
        .VGA_DE             (video_de),  
        .HDMI_CLK_P         (HDMI_CLK_P),
        .HDMI_CLK_N         (HDMI_CLK_N),
        .HDMI_D2_P          (HDMI_D2_P),
        .HDMI_D2_N          (HDMI_D2_N),
        .HDMI_D1_P          (HDMI_D1_P),
        .HDMI_D1_N          (HDMI_D1_N),
        .HDMI_D0_P          (HDMI_D0_P),
        .HDMI_D0_N          (HDMI_D0_N)
    );
 //例化HDMI驱动模块              
    HDMI_IP U2(
            .PXLCLK_I           (pixel_clk),    
            .PXLCLK_5X_I        (pixel_clk_5x), 
            .LOCKED_I           (sys_rst_n),
            .RST_N              (1'b1),
            .VGA_RGB            (video_rgb), 
            .VGA_HS             (video_hs),  
            .VGA_VS             (video_vs),  
            .VGA_DE             (video_de),  
            .HDMI_CLK_P         (HDMI_1_CLK_P),
            .HDMI_CLK_N         (HDMI_1_CLK_N),
            .HDMI_D2_P          (HDMI_1_D2_P),
            .HDMI_D2_N          (HDMI_1_D2_N),
            .HDMI_D1_P          (HDMI_1_D1_P),
            .HDMI_D1_N          (HDMI_1_D1_N),
            .HDMI_D0_P          (HDMI_1_D0_P),
            .HDMI_D0_N          (HDMI_1_D0_N)
        );   
endmodule 