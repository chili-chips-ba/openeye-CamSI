module video_driver(
    input           pixel_clk,
    input           sys_rst_n,
    
    //RGB接口
    output          video_hs,     //行同步信号
    output          video_vs,     //场同步信号
    output          video_de,     //数据使能
    output  [15:0]  video_rgb,    //RGB888颜色数据
    
    input   [15:0]  pixel_data,   //像素点数据
    output  [10:0]  h_disp,       //像素点横坐标
    output  [10:0]  v_disp,       //像素点纵坐标   
    output          data_req
);

//parameter define

//800x600 40Mhz分辨率时序参数,60fps
parameter  H_SYNC   =  128;     //行同步
parameter  H_BACK   =  88;      //行显示后沿
parameter  H_DISP   =  800;    //行有效数据
parameter  H_FRONT  =  40;      //行显示前沿
parameter  H_TOTAL  =  1056;    //行扫描周期

parameter  V_SYNC   =  4;     //场同步
parameter  V_BACK   =  23;      //场显示后沿
parameter  V_DISP   =  600;    //场有效数据
parameter  V_FRONT  =  1;      //场显示前沿
parameter  V_TOTAL  =  628;    //场扫描周期

//reg define
reg  [10:0]  cnt_h;
reg  [10:0]  cnt_v;

//wire define
wire        video_en;
//*****************************************************
//**                    main code
//*****************************************************

assign video_de  = video_en;

assign video_hs  = ( cnt_h < H_SYNC ) ? 1'b0 : 1'b1;  //行同步信号赋值
assign video_vs  = ( cnt_v < V_SYNC ) ? 1'b0 : 1'b1;  //场同步信号赋值

//使能RGB数据输出
assign video_en  = (((cnt_h >= H_SYNC+H_BACK) && (cnt_h < H_SYNC+H_BACK+H_DISP))
                 &&((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                 ?  1'b1 : 1'b0;

//RGB888数据输出
assign video_rgb = video_en ? pixel_data : 24'd0;

//请求像素点颜色数据输入
assign data_req = (((cnt_h >= H_SYNC+H_BACK-1'b1) && 
                    (cnt_h < H_SYNC+H_BACK+H_DISP-1'b1))
                  && ((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                  ?  1'b1 : 1'b0;

//行场分辨率
assign h_disp = H_DISP;
assign v_disp = V_DISP; 

//行计数器对像素时钟计数
always @(posedge pixel_clk ) begin
    if (!sys_rst_n)
        cnt_h <= 11'd0;
    else begin
        if(cnt_h < H_TOTAL - 1'b1)
            cnt_h <= cnt_h + 1'b1;
        else 
            cnt_h <= 11'd0;
    end
end

//场计数器对行计数
always @(posedge pixel_clk ) begin
    if (!sys_rst_n)
        cnt_v <= 11'd0;
    else if(cnt_h == H_TOTAL - 1'b1) begin
        if(cnt_v < V_TOTAL - 1'b1)
            cnt_v <= cnt_v + 1'b1;
        else 
            cnt_v <= 11'd0;
    end
end

endmodule