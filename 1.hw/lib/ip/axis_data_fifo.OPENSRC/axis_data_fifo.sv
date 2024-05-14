module axis_data_fifo #(
   parameter DEPTH = 8192,
   parameter DW    = 24
)(
   input  logic            s_axis_aresetn,
                           
 //Write side
   input  logic            s_axis_aclk,
   input  logic            s_axis_tvalid,
   output logic            s_axis_tready,
   input  logic [DW-1 : 0] s_axis_tdata,

 //Read side
   input  logic            m_axis_aclk,
   output logic            m_axis_tvalid,
   input  logic            m_axis_tready,
   output logic [DW-1 : 0] m_axis_tdata,

   output logic [31 : 0]   axis_rd_data_count
);

   localparam AW = $clog2(DEPTH);

//__1. Syncronize reset
   logic m_axis_aresetn_0, m_axis_aresetn;

   always_ff @(posedge m_axis_aclk or negedge s_axis_aresetn) begin
      if (s_axis_aresetn == 1'b0) begin
          {m_axis_aresetn, m_axis_aresetn_0} <= '0;
      end
      else begin
          {m_axis_aresetn, m_axis_aresetn_0} <= {m_axis_aresetn_0, 1'b1};
      end
   end   

//__2. Dan's Async FIFO - we are using just the control logic
   logic empty, full;
   logic wr, rd, rd_ext;
   logic [AW:0] waddr, raddr;
    
// verilator lint_off WIDTHEXPAND
   //always_comb axis_rd_data_count = 32'(waddr - raddr);
   always_comb axis_rd_data_count = 'hx;
// verilator lint_on WIDTHEXPAND

   always_comb wr = s_axis_tvalid & ~full;
   always_comb rd_ext = ~m_axis_tvalid | m_axis_tready;
   always_comb rd = ~empty & rd_ext;
   always_comb s_axis_tready = ~full;
    
   afifo #(.DSIZE(DW), .ASIZE(AW)) afifo(
      .i_wclk(s_axis_aclk),
      .i_wrst_n(s_axis_aresetn), 
      .i_wr(wr),
      .i_wdata('0),
      .o_wfull(full),
      .o_waddr(waddr),
    
      .i_rclk(m_axis_aclk),
      .i_rrst_n(m_axis_aresetn),
      .i_rd(rd),
      .o_rdata(),
      .o_rempty(empty),
      .o_raddr(raddr)
   );
    
    
//__3. Inferable BRAM
   DP_BRAM #(
      .D      (DEPTH), 
      .W      (DW)
   ) 
   ram (
    //Side-A 
     .clka   (s_axis_aclk),
     .ena    (wr),
     .addra  (waddr[AW-1:0]),
     .wea    ('1),
     .dina   (s_axis_tdata),
     .douta  (), // unused
    
    //Side-B
     .clkb   (m_axis_aclk),
     .enb    (rd),
     .addrb  (raddr[AW-1:0]),
     .web    ('0), // unused
     .dinb   ('0), // unused
     .doutb  (m_axis_tdata)
   );
    
    
//__4. m_axis_tvalid = delayed ~empty
   always_ff @(posedge m_axis_aclk) begin
      if (!m_axis_aresetn) 
          m_axis_tvalid <= '0;
      else if (rd_ext)
          m_axis_tvalid <= ~empty;
   end

endmodule: axis_data_fifo

