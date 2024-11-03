module ddr3_rw(  
        
    input           ui_clk               ,  //用户时钟
    input           ui_clk_sync_rst      ,  //复位,高有效
    input           init_calib_complete  ,  //DDR3初始化完成
    input           app_rdy              ,  //MIG IP核空闲
    input           app_wdf_rdy          ,  //MIG写FIFO空闲
    input           app_rd_data_valid    ,  //读数据有效
    input   [255:0] app_rd_data          ,  //读数据有效    
    input   [10:0]  wfifo_rcount_1       ,  //写端口FIFO1中的数据量
    input   [10:0]  rfifo_wcount_1       ,  //读端口FIFO1中的数据量
    input   [10:0]  wfifo_rcount_2       ,  //写端口FIFO2中的数据量
    input   [10:0]  rfifo_wcount_2       ,  //读端口FIFO2中的数据量
    input           wr_load_1            ,  //输入源1场信号   
    input           wr_load_2            ,  //输入源2场信号     
    input           rd_load              ,  //输出源场信号
    input           wr_clk_2             ,  //输入源1时钟 
    input           wr_clk_1             ,  //输入源2时钟  

    input   [27:0]  app_addr_rd_min      ,  //读DDR3的起始地址
    input   [27:0]  app_addr_rd_max      ,  //读DDR3的结束地址
    input   [7:0]   rd_bust_len          ,  //从DDR3中读数据时的突发长度
    input   [27:0]  app_addr_wr_min      ,  //写DDR3的起始地址
    input   [27:0]  app_addr_wr_max      ,  //写DDR3的结束地址
    input   [7:0]   wr_bust_len          ,  //从DDR3中写数据时的突发长度
        
    output          rfifo_wren_1         ,  //读端口FIFO1中的写使能 
    output          rfifo_wren_2         ,  //读端口FIFO1中的写使能 
    output  [255:0] rfifo_wdata_1        ,  //从ddr3读出的有效数据1  
    output  [255:0] rfifo_wdata_2        ,  //从ddr3读出的有效数据2 
    output          wfifo_rden_1         ,  //写端口FIFO1中的读使能
    output          wfifo_rden_2         ,  //写端口FIFO2中的读使能  
    output  [27:0]  app_addr             ,  //DDR3地址                 
    output          app_en               ,  //MIG IP核操作使能
    output          app_wdf_wren         ,  //用户写使能   
    output          app_wdf_end          ,  //突发写当前时钟最后一个数据 
    output  [2:0]   app_cmd                 //MIG IP核操作命令，读或者写                    
    );
    
//localparam 
localparam IDLE          = 7'b0000001;   //空闲状态
localparam DDR3_DONE     = 7'b0000010;   //DDR3初始化完成状态
localparam WRITE_1       = 7'b0000100;   //读FIFO保持状态
localparam READ_1        = 7'b0001000;   //写FIFO保持状态
localparam WRITE_2       = 7'b0010000;   //读FIFO保持状态
localparam READ_2        = 7'b0100000;   //写FIFO保持状态
localparam READ_WAIT     = 7'b1000000;   //写FIFO保持状态

//reg define
reg    [27:0] app_addr;               //DDR3地址 
reg    [27:0] app_addr_rd_1;          //DDR3读地址
reg    [27:0] app_addr_wr_1;          //DDR3写地址
reg    [27:0] app_addr_rd_2;          //DDR3读地址
reg    [27:0] app_addr_wr_2;          //DDR3写地址
reg    [6:0]  state_cnt;              //状态计数器
reg    [23:0] rd_addr_cnt_1;          //用户读地址计数
reg    [23:0] wr_addr_cnt_1;          //用户写地址计数  
reg    [23:0] rd_addr_cnt_2;          //用户读地址计数
reg    [23:0] wr_addr_cnt_2;          //用户写地址计数  
reg    [10:0] raddr_rst_h_cnt;        //输出源的帧复位脉冲进行计数
reg    [255:0]rfifo_wdata_1;          //从ddr3读出的有效数据1 
reg    [255:0]rfifo_wdata_2;          //从ddr3读出的有效数据2
reg    [7:0]  data_valid_cnt;         //从ddr3读出的有效数据使能计数器
reg           rd_load_d0;
reg           rd_load_d1;
reg           raddr_rst_h;            //输出源的帧复位脉冲
reg           wr_load_1_d0;
reg           wr_load_1_d1;
reg           wr_load_2_d0;
reg           wr_load_2_d1;
reg           wr_rst_1;               //输入源1帧复位标志
reg           wr_rst_2;               //输入源2帧复位标志
reg           rd_rst;                 //输出源帧复位标志
reg           raddr_page_1;           //ddr3源1读地址切换信号
reg           waddr_page_1;           //ddr3源1写地址切换信号
reg           raddr_page_2;           //ddr3源2读地址切换信号
reg           waddr_page_2;           //ddr3源2写地址切换信号
reg           rfifo_wren_1;           //读端口FIFO1中的写使能
reg           rfifo_wren_2;           //读端口FIFO2中的写使能
reg           rfifo_data_en_1;        //读端口FIFO1数据没有写完的使能信号
reg           rfifo_data_en_2;        //读端口FIFO2数据没有写完的使能信号 
reg           wr_load_1_d2;
reg           wr_load_2_d2;

//wire define
wire          rst_n;

 //*****************************************************
//**                    main code
//***************************************************** 

assign rst_n = ~ui_clk_sync_rst;

//在写状态MIG空闲且写有效,或者在读状态MIG空闲，此时使能信号为高，其他情况为低
assign app_en = ( ((state_cnt == READ_1 || state_cnt == READ_2 ) && app_rdy) 
                  || ((state_cnt == WRITE_1 || state_cnt == WRITE_2 ) 
                  && (app_rdy && app_wdf_rdy)) ) ? 1'b1:1'b0;
                
//在写状态,MIG空闲且写有效，此时拉高写使能
assign app_wdf_wren = ((state_cnt == WRITE_1 || state_cnt == WRITE_2 ) && (app_rdy && app_wdf_rdy)) ? 1'b1:1'b0;

assign wfifo_rden_1 = (state_cnt == WRITE_1  && (app_rdy && app_wdf_rdy)) ? 1'b1:1'b0;

assign wfifo_rden_2 = (state_cnt == WRITE_2 && (app_rdy && app_wdf_rdy)) ? 1'b1:1'b0;

//由于我们DDR3芯片时钟和用户时钟的分频选择4:1，突发长度为8，故两个信号相同
assign app_wdf_end = app_wdf_wren; 

//处于读的时候命令值为1，其他时候命令值为0
assign app_cmd = (state_cnt == READ_1 || state_cnt == READ_2 ) ? 3'd1 :3'd0; 

//对DDR读数据的输出端进行选择
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n || rd_rst)begin
        rfifo_wren_1 <= 0; 
        rfifo_wren_2 <= 0; 
        rfifo_wdata_1 <= 0;
        rfifo_wdata_2 <= 0;        
    end   
    else begin
        if(rfifo_data_en_1)begin
            rfifo_wren_1 <= app_rd_data_valid;
            rfifo_wdata_1 <= app_rd_data;
            rfifo_wren_2 <= 0;
            rfifo_wdata_2 <= 0;                        
        end
        else if(rfifo_data_en_2)begin
            rfifo_wren_2 <= app_rd_data_valid;
            rfifo_wdata_2 <= app_rd_data;           
            rfifo_wren_1 <= 0;
            rfifo_wdata_1 <= 0;                        
        end        
        else begin
            rfifo_wren_2 <= 0;
            rfifo_wdata_2 <= 0;
            rfifo_wren_1 <= 0;
            rfifo_wdata_1 <= 0;               
        end        
        
    end    
end 

//读端口FIFO1数据没有写完的使能信号 
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n || rd_rst)begin
        rfifo_data_en_1 <= 0;    
    end   
    else begin
        if(state_cnt == DDR3_DONE  )
           rfifo_data_en_1 <= 0;
        else if(state_cnt == READ_1 ) 
           rfifo_data_en_1 <= 1; 
        else
           rfifo_data_en_1 <= rfifo_data_en_1;         
    end    
end 

//读端口FIFO2数据没有写完的使能信号 
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n || rd_rst)begin
        rfifo_data_en_2 <= 0;    
    end   
    else begin
        if(state_cnt == DDR3_DONE)
           rfifo_data_en_2 <= 0;
        else if(state_cnt == READ_2 ) 
           rfifo_data_en_2 <= 1; 
        else
           rfifo_data_en_2 <= rfifo_data_en_2;         
    end    
end 

 //从ddr3读出的有效数据使能进行计数
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n || rd_rst )begin
       data_valid_cnt <= 0;    
    end   
    else begin
        if(state_cnt == DDR3_DONE ) 
           data_valid_cnt <= 0;     
        else if(app_rd_data_valid)
           data_valid_cnt <= data_valid_cnt + 1;
        else
           data_valid_cnt <= data_valid_cnt;            
    end    
end 

//将数据读写地址赋给ddr地址
always @(*)  begin
    if(~rst_n)
        app_addr <= 0;
    else if(state_cnt == READ_1 )
        app_addr <= {3'b0,raddr_page_1,1'b0,app_addr_rd_1[22:0]};
    else if(state_cnt == READ_2 )
        app_addr <= {3'b1,raddr_page_2,1'b0,app_addr_rd_2[22:0]};
    else if(state_cnt == WRITE_1 )
        app_addr <= {3'b0,waddr_page_1,1'b0,app_addr_wr_1[22:0]};        
    else
        app_addr <= {3'b1,waddr_page_2,1'b0,app_addr_wr_2[22:0]};
end  

//对信号进行打拍处理
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)begin
        rd_load_d0 <= 0;
        rd_load_d1 <= 0; 
        wr_load_1_d0 <= 0; 
        wr_load_1_d1 <= 0;   
        wr_load_2_d0 <= 0; 
        wr_load_2_d1 <= 0;        
    end   
    else begin
        rd_load_d0 <= rd_load;
        rd_load_d1 <= rd_load_d0; 
        wr_load_1_d0 <= wr_load_1; 
        wr_load_1_d1 <= wr_load_1_d0; 
        wr_load_2_d0 <= wr_load_2; 
        wr_load_2_d1 <= wr_load_2_d0;         
    end    
end 

//对输入源1做个帧复位标志
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)
        wr_rst_1 <= 0;                
    else if(wr_load_1_d0 && !wr_load_1_d1)
        wr_rst_1 <= 1;               
    else
        wr_rst_1 <= 0;           
end

//对输入源2做个帧复位标志
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)
        wr_rst_2 <= 0;                
    else if(wr_load_2_d0 && !wr_load_2_d1)
        wr_rst_2 <= 1;               
    else
        wr_rst_2 <= 0;           
end
 
//对输出源做个帧复位标志 
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)
        rd_rst <= 0;                
    else if(rd_load_d0 && !rd_load_d1)
        rd_rst <= 1;               
    else
        rd_rst <= 0;           
end

//对输出源的读地址做个帧复位脉冲 
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)
        raddr_rst_h <= 1'b0;
    else if(rd_load_d0 && !rd_load_d1)
        raddr_rst_h <= 1'b1;
    else if((state_cnt == READ_1) || (state_cnt == READ_2))   
        raddr_rst_h <= 1'b0;
    else
        raddr_rst_h <= raddr_rst_h;              
end 

//对输出源的帧复位脉冲进行计数 
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)
        raddr_rst_h_cnt <= 11'b0;
    else if(raddr_rst_h)
        if(raddr_rst_h_cnt >= 1000)
            raddr_rst_h_cnt <= raddr_rst_h_cnt; 
        else            
            raddr_rst_h_cnt <= raddr_rst_h_cnt + 1'b1;
    else
        raddr_rst_h_cnt <= 11'b0;            
end 

//对输出源帧的读地址高位切换
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)
        raddr_page_1 <= 1'b0;
    else if(rd_rst)
        raddr_page_1 <= ~waddr_page_1;         
    else
        raddr_page_1 <= raddr_page_1;           
end 

//对输出源帧的读地址高位切换
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)
        raddr_page_2 <= 1'b0;
    else if(rd_rst)
        raddr_page_2 <= ~waddr_page_2;         
    else
        raddr_page_2 <= raddr_page_2;           
end
  
//对输入源1帧的写地址高位切换
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)
        waddr_page_1 <= 1'b1;
    else if(wr_rst_1)
        waddr_page_1 <= ~waddr_page_1 ;         
    else
        waddr_page_1 <= waddr_page_1;           
end   

//对输入源1帧的写地址高位切换
always @(posedge ui_clk or negedge rst_n)  begin
    if(~rst_n)
        waddr_page_2 <= 1'b1;
    else if(wr_rst_2)
        waddr_page_2 <= ~waddr_page_2 ;         
    else
        waddr_page_2 <= waddr_page_2;           
end 
  
 
//DDR3读写逻辑实现
always @(posedge ui_clk or negedge rst_n) begin
    if(~rst_n) begin 
        state_cnt    <= IDLE;              
        wr_addr_cnt_1  <= 24'd0;      
        rd_addr_cnt_1  <= 24'd0;       
        app_addr_wr_1  <= 28'd0;   
        app_addr_rd_1  <= 28'd0; 
        wr_addr_cnt_2  <= 24'd0;      
        rd_addr_cnt_2  <= 24'd0;       
        app_addr_wr_2  <= 28'd0;   
        app_addr_rd_2  <= 28'd0;         
    end
    else begin
        case(state_cnt)
            IDLE:begin
                if(init_calib_complete)
                    state_cnt <= DDR3_DONE ;
                else
                    state_cnt <= IDLE;
            end
            DDR3_DONE:begin  //当wfifo1存储数据超过一次突发长度时，跳到写操作1
                if(wfifo_rcount_1 >= wr_bust_len - 2 )begin  
                    state_cnt <= WRITE_1;                    
                end         //当wfifo2存储数据超过一次突发长度时，跳到写操作2 
                else if(wfifo_rcount_2 >= wr_bust_len - 2 )begin 
                    state_cnt <= WRITE_2;                    
                end                
                else if(raddr_rst_h)begin         //当帧复位到来时，对寄存器进行复位 
                    if(raddr_rst_h_cnt >= 1000 )begin 
                        state_cnt <= READ_1;      //保证读fifo在复位时不会进行读操作             
                    end
                    else begin
                        state_cnt <= DDR3_DONE;                      
                    end                                
                end //当rfifo1存储数据少于设定阈值时，并且输入源1已经写入ddr 1帧数据                                    
                else if(rfifo_wcount_1 < 5  )begin  //跳到读操作1 
                    state_cnt <= READ_1;                                                 
                end //当rfifo1存储数据少于设定阈值时，并且输入源1已经写入ddr 1帧数据                                    
                else if(rfifo_wcount_2 < 5  )begin  //跳到读操作2 
                    state_cnt <= READ_2;                                                                                        
                end  			                                                                                                
                else begin
                    state_cnt <= state_cnt;                      
                end
                              
                if(raddr_rst_h)begin        //当帧复位到来时，对信号进行复位        
                    rd_addr_cnt_1  <= 24'd0;      
                    app_addr_rd_1 <= app_addr_rd_min; 
                    rd_addr_cnt_2  <= 24'd0;      
                    app_addr_rd_2 <= app_addr_rd_min;                                                        
                end //当rfifo1存储数据少于设定阈值时，并且输入源1已经写入ddr 1帧数据 
                else if(rfifo_wcount_1 < 5 )begin             
                    rd_addr_cnt_1 <= 24'd0;            //计数器清零
                    app_addr_rd_1 <= app_addr_rd_1;    //读地址保持不变
                end //当rfifo1存储数据少于设定阈值时，并且输入源1已经写入ddr 1帧数据 
                else if(rfifo_wcount_2 < 5  )begin             
                    rd_addr_cnt_2 <= 24'd0;            //计数器清零
                    app_addr_rd_2 <= app_addr_rd_2;    //读地址保持不变
                end  			                                                                                                
                else begin
                    wr_addr_cnt_1  <= 24'd0;      
                    rd_addr_cnt_1  <= 24'd0;                     
                end                
  
                if(wr_rst_2)begin             //当帧复位到来时，对信号进行复位
                    wr_addr_cnt_2  <= 24'd0;	
                    app_addr_wr_2 <= app_addr_wr_min;					
			    end                    //当wfifo存储数据超过一次突发长度时
                else if(wfifo_rcount_2 >= wr_bust_len - 2 )begin  
                    wr_addr_cnt_2  <= 24'd0;                   //计数器清零    
                    app_addr_wr_2 <= app_addr_wr_2;            //写地址保持不变
                 end 
                 else begin
                    wr_addr_cnt_2  <= wr_addr_cnt_2;
                    app_addr_wr_2  <= app_addr_wr_2;                  
                 end 
  
                 if(wr_rst_1)begin               //当帧复位到来时，对信号进行复位
                    wr_addr_cnt_1  <= 24'd0;	
                    app_addr_wr_1 <= app_addr_wr_min;					
			    end                  //当wfifo存储数据超过一次突发长度时
                else if(wfifo_rcount_1 >= wr_bust_len - 2 )begin  
                    wr_addr_cnt_1  <= 24'd0;                   //计数器清零     
                    app_addr_wr_1 <= app_addr_wr_1;            //写地址保持不变
                 end 
                 else begin
                    wr_addr_cnt_1  <= wr_addr_cnt_1;
                    app_addr_wr_1  <= app_addr_wr_1;                  
                 end
                
            end    
            WRITE_1:   begin 
                if((wr_addr_cnt_1 == (wr_bust_len - 1)) && 
                   (app_rdy && app_wdf_rdy))begin        //写到设定的长度跳到等待状态                  
                    state_cnt    <= DDR3_DONE;           //写到设定的长度跳到等待状态               
                    app_addr_wr_1 <= app_addr_wr_1 + 8;   //一次性写进8个数，故加8
                end       
                else if(app_rdy && app_wdf_rdy)begin       //写条件满足
                    wr_addr_cnt_1  <= wr_addr_cnt_1 + 1'd1;//写地址计数器自加
                    app_addr_wr_1  <= app_addr_wr_1 + 8;   //一次性写进8个数，故加8
                end
                else begin                                 //写条件不满足，保持当前值     
                    wr_addr_cnt_1  <= wr_addr_cnt_1;
                    app_addr_wr_1  <= app_addr_wr_1; 
                end
            end
            WRITE_2:   begin 
                if((wr_addr_cnt_2 == (wr_bust_len - 1)) && 
                   (app_rdy && app_wdf_rdy))begin         //写到设定的长度跳到等待状态                  
                    state_cnt    <= DDR3_DONE;            //写到设定的长度跳到等待状态               
                    app_addr_wr_2 <= app_addr_wr_2 + 8;   //一次性写进8个数，故加8
                end       
                else if(app_rdy && app_wdf_rdy)begin      //写条件满足
                    wr_addr_cnt_2  <= wr_addr_cnt_2 + 1'd1; //写地址计数器自加
                    app_addr_wr_2  <= app_addr_wr_2 + 8; //一次性写进8个数，故加8
                end
                else begin                              //写条件不满足，保持当前值     
                    wr_addr_cnt_2  <= wr_addr_cnt_2;
                    app_addr_wr_2  <= app_addr_wr_2; 
                end
            end            
            READ_1:begin                                  //读到设定的地址长度    
                if((rd_addr_cnt_1 == (rd_bust_len - 1)) && app_rdy)begin
                    state_cnt   <= READ_WAIT;             //则跳到空闲状态 
                    app_addr_rd_1 <= app_addr_rd_1 + 8;
                end       
                else if(app_rdy)begin                   //若MIG已经准备好,则开始读
                    rd_addr_cnt_1 <= rd_addr_cnt_1 + 1'd1; //用户地址计数器每次加一
                    app_addr_rd_1 <= app_addr_rd_1 + 8; //一次性读出8个数,DDR3地址加8
                end
                else begin                               //若MIG没准备好,则保持原值
                    rd_addr_cnt_1 <= rd_addr_cnt_1;
                    app_addr_rd_1 <= app_addr_rd_1; 
                end
                
                if(wr_rst_2)begin                    //当帧复位到来时，对信号进行复位
                    wr_addr_cnt_2  <= 24'd0;	
                    app_addr_wr_2 <= app_addr_wr_min;					
			    end 
                 else begin
                    wr_addr_cnt_2  <= wr_addr_cnt_2;
                    app_addr_wr_2  <= app_addr_wr_2;                  
                 end 
 
                 if(wr_rst_1)begin                   //当帧复位到来时，对信号进行复位
                    wr_addr_cnt_1  <= 24'd0;	
                    app_addr_wr_1 <= app_addr_wr_min;					
			    end 
                 else begin
                    wr_addr_cnt_1  <= wr_addr_cnt_1;
                    app_addr_wr_1  <= app_addr_wr_1;                  
                 end			    
            end 
            READ_2:begin                         //读到设定的地址长度    
                if((rd_addr_cnt_2 == (rd_bust_len - 1)) && app_rdy)begin
                    state_cnt   <= READ_WAIT;             //则跳到空闲状态 
                    app_addr_rd_2 <= app_addr_rd_2 + 8;
                end       
                else if(app_rdy)begin                      //若MIG已经准备好,则开始读
                    rd_addr_cnt_2 <= rd_addr_cnt_2 + 1'd1; //用户地址计数器每次加一
                    app_addr_rd_2 <= app_addr_rd_2 + 8; //一次性读出8个数,DDR3地址加8
                end
                else begin                                 //若MIG没准备好,则保持原值
                    rd_addr_cnt_2 <= rd_addr_cnt_2;
                    app_addr_rd_2 <= app_addr_rd_2; 
                end
                
                 if(wr_rst_2)begin                  //当帧复位到来时，对信号进行复位
                    wr_addr_cnt_2  <= 24'd0;	
                    app_addr_wr_2 <= app_addr_wr_min;					
			    end 
                 else begin
                    wr_addr_cnt_2  <= wr_addr_cnt_2;
                    app_addr_wr_2  <= app_addr_wr_2;                  
                 end 
 
                 if(wr_rst_1)begin                   //当帧复位到来时，对信号进行复位
                    wr_addr_cnt_1  <= 24'd0;	
                    app_addr_wr_1 <= app_addr_wr_min;					
			    end 
                 else begin
                    wr_addr_cnt_1  <= wr_addr_cnt_1;
                    app_addr_wr_1  <= app_addr_wr_1;                  
                 end                
            end
            READ_WAIT:begin       //计到设定的地址长度    
                if((data_valid_cnt >= rd_bust_len - 1) && app_rd_data_valid)begin
                    state_cnt   <= DDR3_DONE;             //则跳到空闲状态 
                end       
                else begin                               
                    state_cnt   <= READ_WAIT;
                end
            end            
            default:begin
                    state_cnt    <= IDLE;              
                    wr_addr_cnt_1  <= 24'd0;      
                    rd_addr_cnt_1  <= 24'd0;       
                    app_addr_wr_1  <= 28'd0;   
                    app_addr_rd_1  <= 28'd0; 
                    wr_addr_cnt_2  <= 24'd0;      
                    rd_addr_cnt_2  <= 24'd0;       
                    app_addr_wr_2  <= 28'd0;   
                    app_addr_rd_2  <= 28'd0;   
            end
        endcase
    end
end                          

endmodule