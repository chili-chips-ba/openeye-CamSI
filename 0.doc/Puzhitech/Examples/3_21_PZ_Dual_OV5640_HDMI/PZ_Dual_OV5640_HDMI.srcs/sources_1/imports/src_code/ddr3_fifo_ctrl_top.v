module ddr3_fifo_ctrl_top(
    input           rst_n              ,  //��λ�ź�    
    input           rd_clk             ,  //rfifoʱ��
    input           clk_100            ,  //�û�ʱ��
    //fifo1�ӿ��ź�
    input           wr_clk_1           ,  //wfifoʱ��    
    input           datain_valid_1     ,  //������Чʹ���ź�
    input  [15:0]   datain_1           ,  //��Ч����
    input           wr_load_1          ,  //����Դ���ź�    
    input  [255:0]  rfifo_din_1        ,  //�û�������
    input           rfifo_wren_1       ,  //��ddr3�������ݵ���Чʹ��
    input           wfifo_rden_1       ,  //wfifo��ʹ��
    output [10:0]   wfifo_rcount_1     ,  //rfifoʣ�����ݼ���
    output [10:0]   rfifo_wcount_1     ,  //wfifoд�����ݼ���    
    //fifo2�ӿ��ź�  
    input           wr_clk_2           ,  //wfifoʱ��    
    input           datain_valid_2     ,  //������Чʹ���ź�
    input  [15:0]   datain_2           ,  //��Ч����    
    input           wr_load_2          ,  //����Դ���ź�
    input  [255:0]  rfifo_din_2        ,  //�û�������
    input           rfifo_wren_2       ,  //��ddr3�������ݵ���Чʹ��
    input           wfifo_rden_2       ,  //wfifo��ʹ��    
    output [10:0]   wfifo_rcount_2     ,  //rfifoʣ�����ݼ���
    output [10:0]   rfifo_wcount_2     ,  //wfifoд�����ݼ���

    input  [12:0]   h_disp             ,
    input           rd_load            ,  //���Դ���ź�
    input           rdata_req          ,  //�������ص���ɫ��������     
    output [15:0]   pic_data           ,  //��Ч����  
    output [255:0]  wfifo_dout            //�û�д����  
       
    );

reg  [12:0]  rd_cnt;

wire         rdata_req_1;
wire         rdata_req_2;
wire [15:0]  pic_data_1;
wire [15:0]  pic_data_2;
wire [15:0]  pic_data;
wire [255:0] wfifo_dout;
wire [255:0] wfifo_dout_1;
wire [255:0] wfifo_dout_2;
wire [10:0]  wfifo_rcount_1;
wire [10:0]  wfifo_rcount_2;
wire [10:0]  rfifo_wcount_1;
wire [10:0]  rfifo_wcount_2;


//������ʾ�����ź��л�������ʾ���������FIFO1��ʾ���Ҳ�����FIFO2��ʾ
assign rdata_req_1  = (rd_cnt <= h_disp[12:1]-1) ? rdata_req :1'b0;
assign rdata_req_2  = (rd_cnt <= h_disp[12:1]-1) ? 1'b0 :rdata_req;

//��������ʾ����ʾλ�õ��л�������ʾ�������ʾFIFO0,�Ҳ���ʾFIFO1
assign pic_data =     (rd_cnt <= h_disp[12:1]) ? pic_data_1 : pic_data_2;

//д��DDR3�����������л�
assign wfifo_dout = wfifo_rden_1 ? wfifo_dout_1 : wfifo_dout_2; 

//�Զ������źż���
always @(posedge rd_clk or negedge rst_n) begin
    if(!rst_n)
        rd_cnt <= 13'd0;
    else if(rdata_req)
        rd_cnt <= rd_cnt + 1'b1;
    else
        rd_cnt <= 13'd0;
end



ddr3_fifo_ctrl u_ddr3_fifo_ctrl_1 (

    .rst_n               (rst_n )           ,  
    //����ͷ�ӿ�
    .wr_clk              (wr_clk_1)         ,
    .rd_clk              (rd_clk)           ,
    .clk_100             (clk_100)          ,    //�û�ʱ�� 
    .datain_valid        (datain_valid_1)   ,    //������Чʹ���ź�
    .datain              (datain_1)         ,    //��Ч���� 
    .rfifo_din           (rfifo_din_1)      ,    //�û������� 
    .rdata_req           (rdata_req_1)      ,    //�������ص���ɫ�������� 
    .rfifo_wren          (rfifo_wren_1)     ,    //ddr3�������ݵ���Чʹ�� 
    .wfifo_rden          (wfifo_rden_1)     ,    //ddr3 дʹ��         
    //�û��ӿ�
    .wfifo_rcount        (wfifo_rcount_1)   ,    //rfifoʣ�����ݼ���                 
    .rfifo_wcount        (rfifo_wcount_1)   ,    //wfifoд�����ݼ���                
    .wfifo_dout          (wfifo_dout_1)     ,    //�û�д���� 
    .rd_load             (rd_load)          ,    //lcd���ź�
    .wr_load             (wr_load_1)        ,    //����ͷ���ź�
    .pic_data            (pic_data_1)            //rfifo�������        
	
    );
    
ddr3_fifo_ctrl u_ddr3_fifo_ctrl_2 (

    .rst_n               (rst_n )           ,  
    //����ͷ�ӿ�                            
    .wr_clk              (wr_clk_2)         ,
    .rd_clk              (rd_clk)           ,
    .clk_100             (clk_100)          ,    //�û�ʱ�� 
    .datain_valid        (datain_valid_2)   ,    //������Чʹ���ź�
    .datain              (datain_2)         ,    //��Ч���� 
    .rfifo_din           (rfifo_din_2)      ,    //�û������� 
    .rdata_req           (rdata_req_2)      ,    //�������ص���ɫ�������� 
    .rfifo_wren          (rfifo_wren_2)     ,    //ddr3�������ݵ���Чʹ�� 
    .wfifo_rden          (wfifo_rden_2)     ,    //ddr3 дʹ��         
    //�û��ӿ�                              
    .wfifo_rcount        (wfifo_rcount_2)   ,    //rfifoʣ�����ݼ���                   
    .rfifo_wcount        (rfifo_wcount_2)   ,    //wfifoд�����ݼ���                  
    .wfifo_dout          (wfifo_dout_2)     ,    //�û�д���� 
    .rd_load             (rd_load)          ,    //lcd���ź�
    .wr_load             (wr_load_2)        ,    //����ͷ���ź�
    .pic_data            (pic_data_2)            //rfifo�������        
	
    );    

endmodule