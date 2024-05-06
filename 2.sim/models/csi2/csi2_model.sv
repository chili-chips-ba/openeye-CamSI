//===========================================
// Filename: csi2_model.sv
//===========================================
`ifndef CSI2_MODEL
`define CSI2_MODEL

`timescale 1ps / 1ps

module csi2_model#(
   parameter NUM_FRAMES        = 2,
   parameter NUM_LINES         = 2,
   parameter NUM_PIXELS        = 200,
   parameter ACTIVE_DPHY_LANES = 4,
   parameter DATA_TYPE         = 6'h2b,
   parameter RX_CLK_MODE       = "HS_ONLY",
   parameter DATA_COUNT        = 700,

   parameter DPHY_CLK_PERIOD   = 1683, 
   parameter tLPX              = 68000,
   parameter tCLK_PREPARE      = 51000,
   parameter tCLK_ZERO         = 252503, 
   parameter tCLK_TRAIL        = 62000,
   parameter tCLK_POST         = 131000,
   parameter tCLK_PRE          = 10000,
   parameter tHS_PREPARE       = 55000,
   parameter tHS_ZERO          = 103543, 
   parameter tHS_TRAIL         = 80000,
   parameter tINIT             = 100000000,

   parameter LPS_GAP           = 100000,
   parameter FRAME_GAP         = 100000,
   parameter DPHY_CH           = 0,
   parameter DPHY_VC           = 0,
   parameter LONG_EVEN_LINE_EN = 0,
   parameter LS_LE_EN          = 0,
   parameter DEBUG             = 0,
   parameter FIXED_DATA        = 0
)(
   input  logic       refclk_i,
   input  logic       resetn,
   input  logic       pll_lock,
                       
   output logic       clk_p_i,
   output logic       clk_n_i,
   output logic [3:0] do_p_i,
   output logic [3:0] do_n_i,
   output logic       csi_valid_o
);

logic clk_p_w,      clk_n_w;
logic cont_clk_p_r, cont_clk_n_r;


logic [63:0] data_from_tb [DATA_COUNT-1:0];
int          d = 0;
logic        clk_en, cont_clk_en;
logic [1:0]  vc;
logic [5:0]  dt;
logic [15:0] wc;
logic [15:0] word_count_odd_r;
logic [15:0] iterations_r;
logic [15:0] BPC;
logic [7:0]  ecc;
logic [15:0] chksum;
logic [15:0] cur_crc;
logic        odd_even_line; 
logic        long_even_line;
logic        ls_le;
logic [15:0] lnum;

logic [1:0] fnum;

logic dphy_start;
logic dphy_active;

int i,j,k,l,m,n;
int f;                                     // File where write data transmitted from test
int h;                                     // File where write data transmitted from test
initial f = $fopen("DRIVEN_DATA.txt","w"); // File where write data transmitted from test 
initial h = $fopen("HEADERS.txt","w"); // File where write data transmitted from test 

logic [7:0] data [3:0];
logic       validator_r;
initial     validator_r = 1'b0;

logic [7:0] data0;
logic [7:0] data1;
logic [7:0] data2;
logic [7:0] data3;

clk_driver clk_drv();
bus_driver#(.ch(0), .dphy_clk(DPHY_CLK_PERIOD)) bus_drv0 (.clk_p_i(clk_p_w));
bus_driver#(.ch(1), .dphy_clk(DPHY_CLK_PERIOD)) bus_drv1 (.clk_p_i(clk_p_w));
bus_driver#(.ch(2), .dphy_clk(DPHY_CLK_PERIOD)) bus_drv2 (.clk_p_i(clk_p_w));
bus_driver#(.ch(3), .dphy_clk(DPHY_CLK_PERIOD)) bus_drv3 (.clk_p_i(clk_p_w));

assign clk_p_i     = (RX_CLK_MODE == "HS_LP")? clk_p_w : cont_clk_p_r; 
assign clk_n_i     = (RX_CLK_MODE == "HS_LP")? clk_n_w : cont_clk_n_r;
assign clk_p_w     = clk_drv.clk_p_i;
assign clk_n_w     = clk_drv.clk_n_i;
assign do_p_i[0]   = bus_drv0.do_p_i;
assign do_n_i[0]   = bus_drv0.do_n_i;
assign do_p_i[1]   = bus_drv1.do_p_i;
assign do_n_i[1]   = bus_drv1.do_n_i;
assign do_p_i[2]   = bus_drv2.do_p_i;
assign do_n_i[2]   = bus_drv2.do_n_i;
assign do_p_i[3]   = bus_drv3.do_p_i;
assign do_n_i[3]   = bus_drv3.do_n_i;
assign csi_valid_o = validator_r;

assign data0       = data[0];
assign data1       = data[1];
assign data2       = data[2];
assign data3       = data[3];

initial begin
   vc             = DPHY_VC;
   dt             = DATA_TYPE;
   wc             = NUM_PIXELS - (ACTIVE_DPHY_LANES == 3)*2;
   iterations_r   = 16'd0;
   fnum           = 1;
   chksum         = 16'hffff;
   dphy_active    = 0;
   cont_clk_p_r   = 1;
   cont_clk_n_r   = 1;
   long_even_line = LONG_EVEN_LINE_EN;
   ls_le          = LS_LE_EN;
   data[0]        = 0;
   data[1]        = 0;
   data[2]        = 0;
   data[3]        = 0;

   repeat (DATA_COUNT) begin
      data_from_tb[d] = 0;
      d = d + 1;
   end
   d = 0;

   $display("%t Word count = %0d\n", $time, NUM_PIXELS);

   if (RX_CLK_MODE == "HS_LP") begin
      @(posedge dphy_active);
      $display("%t DPHY [%0d] model activated\n", $time, DPHY_CH);
  
      #(tINIT);
   end

   fork
      begin
         drive_cont_clk;
      end
      begin
         if (RX_CLK_MODE == "HS_ONLY") begin
            @(posedge dphy_active);
            $display("%t DPHY [%0d] model activated\n", $time, DPHY_CH);

            #(tINIT);
         end

         repeat (NUM_FRAMES) begin
         // FS
         drive_fs;
   
         odd_even_line = 0; 
            //Drive data
            repeat (NUM_LINES) begin
               if (ls_le == 1) begin
                  #LPS_GAP;
                  drive_ls;
               end
               #LPS_GAP;
               if (long_even_line == 1) begin
                  if (odd_even_line == 0) begin
                     wc = NUM_PIXELS;
                  end else
                  if (odd_even_line == 1) begin
                     wc = NUM_PIXELS*2;
                  end
               end
               drive_data;

               if (ls_le == 1) begin
                  #LPS_GAP;
                  drive_le;
               end
               odd_even_line = ~odd_even_line;
            end
   
         //FE
         #LPS_GAP;
         drive_fe;
         #FRAME_GAP;
         end
   
         dphy_active = 0;
         cont_clk_en = 0;
      end
   join
end

//-------------------------
initial begin
   clk_en      = 0;
   cont_clk_en = 0;
end

//-------------------------
task drive_cont_clk();
   #1000;
   // HS-RQST
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK CONT : Driving HS-CLK-RQST", $time, DPHY_CH);
   end
   cont_clk_p_r = 0;
   cont_clk_n_r = 1;
   #tLPX;

   // HS-Prpr
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK CONT : Driving HS-Prpr", $time, DPHY_CH);
   end
   cont_clk_p_r = 0;
   cont_clk_n_r = 0;
   #tCLK_PREPARE;

   // HS-Go
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK CONT : Driving HS-Go", $time, DPHY_CH);
   end
   cont_clk_p_r = 0;
   cont_clk_n_r = 1;
   #tCLK_ZERO;

   cont_clk_en = 1;
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK CONT : Driving HS-0/HS-1", $time, DPHY_CH);
   end
   while (cont_clk_en) begin
      @(refclk_i);
      cont_clk_p_r = refclk_i;
      cont_clk_n_r = ~refclk_i;
   end

   // Trail HS-0
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK CONT : Driving CLK-Trail", $time, DPHY_CH);
   end
   #tCLK_TRAIL;

   // TX-Stop
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK CONT : Driving CLK-Stop", $time, DPHY_CH);
   end
   clk_drv.drv_clk_st(1, 1);
endtask: drive_cont_clk
   

//-------------------------
task drive_clk();
   #1000;
   // HS-RQST
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK : Driving HS-CLK-RQST", $time, DPHY_CH);
   end
   clk_drv.drv_clk_st(0, 1);
   #tLPX;

   // HS-Prpr
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK : Driving HS-Prpr", $time, DPHY_CH);
   end
   clk_drv.drv_clk_st(0, 0);
   #tCLK_PREPARE;

   // HS-Go
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK : Driving HS-Go", $time, DPHY_CH);
   end
   clk_drv.drv_clk_st(0, 1);
   #tCLK_ZERO;

   clk_en = 1;
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK : Driving HS-0/HS-1", $time, DPHY_CH);
   end
   while (clk_en) begin
      @(refclk_i);
      clk_drv.drv_clk_st(refclk_i, ~refclk_i);
   end

   // Trail HS-0
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK : Driving CLK-Trail", $time, DPHY_CH);
   end
   #tCLK_TRAIL;

   // TX-Stop
   if(DEBUG == 1) begin
      $display("%t DPHY [%0d] CLK : Driving CLK-Stop", $time, DPHY_CH);
   end
   clk_drv.drv_clk_st(1, 1);

endtask: drive_clk
   

//-------------------------
task drive_fs();
   fork
      begin
         drive_clk;
      end
      begin
         pre_data;

         // FS packet
         data[0] = {vc, 6'h00};
         data[1] = fnum;
         data[2] = 8'h00;
         data[3] = 8'h00;
         get_ecc({data[2], data[1], data[0]}, data[3]);
         //data[3] = 8'h15;

         $display("%t DPHY [%0d] DATA : Driving FS", $time, DPHY_CH);

         if (ACTIVE_DPHY_LANES == 1) begin
            for (i = 0 ; i < 4 ; i = i + 1) begin
               bus_drv0.drive_datax(data[i]);
            end
         end else 

         if (ACTIVE_DPHY_LANES == 2) begin
            for (i = 0 ; i < 4 ; i = i + 2) begin
            if(DEBUG) begin
               $display("%t DPHY [%0d] DATA : Driving data[%0d] = %0x", $time, DPHY_CH, i, data[i]);
               $display("%t DPHY [%0d] DATA : Driving data[%0d] = %0x", $time, DPHY_CH, i+1, data[i+1]);
            end
               fork
                  bus_drv0.drive_datax(data[i]);
                  bus_drv1.drive_datax(data[i+1]);
               join
               // $fwrite(f,"%0x\n",{data[1],data[0]});
            end
         end else
         if (ACTIVE_DPHY_LANES == 3) begin // RTL don't supports 3 lane mode
            if(DEBUG) begin
              $display("%t DPHY [%0d] DATA : Driving data[0] = %0x", $time, DPHY_CH, data[0]);
              $display("%t DPHY [%0d] DATA : Driving data[0] = %0x", $time, DPHY_CH, data[1]);
              $display("%t DPHY [%0d] DATA : Driving data[0] = %0x", $time, DPHY_CH, data[2]);
            end
            fork
               bus_drv0.drive_datax(data[0]);
               bus_drv1.drive_datax(data[1]);
               bus_drv2.drive_datax(data[2]);
            join
            fork
               bus_drv0.drive_datax(data[3]);
               bus_drv1.drv_trail;
               bus_drv2.drv_trail;
            join
         end 
         else if (ACTIVE_DPHY_LANES == 4) begin
            fork
               bus_drv0.drive_datax(data[0]);
               bus_drv1.drive_datax(data[1]);
               bus_drv2.drive_datax(data[2]);
               bus_drv3.drive_datax(data[3]);
            join
            // $fwrite(f,"%0x\n",{data[3],data[2],data[1],data[0]});
            // data_from_tb[d] <= {data[3],data[2],data[1],data[0]};
            // d = d + 1;
         end
           post_data;
         // reset line number
         lnum = 1;
      end
   join
endtask: drive_fs
   

//-------------------------
task drive_ls();
   fork
      begin
         drive_clk;
      end
      begin
         pre_data;

         // FS packet
         data[0] = {vc, 6'h02};
         data[1] = lnum[7:0];
         data[2] = lnum[15:8];
         data[3] = 8'h00;
         get_ecc({data[2], data[1], data[0]}, data[3]);

         $display("%t DPHY [%0d] DATA : Driving LS", $time, DPHY_CH);

         if (ACTIVE_DPHY_LANES == 1) begin
            for (i = 0 ; i < 4 ; i = i + 1) begin
               bus_drv0.drive_datax(data[i]);
            end
         end 
         else if (ACTIVE_DPHY_LANES == 2) begin
            for (i = 0 ; i < 4 ; i = i + 2) begin
            if(DEBUG) begin
               $display("%t DPHY [%0d] DATA : Driving data[%0d] = %0x", $time, DPHY_CH, i, data[i]);
               $display("%t DPHY [%0d] DATA : Driving data[%0d] = %0x", $time, DPHY_CH, i+1, data[i+1]);
            end
               fork
                  bus_drv0.drive_datax(data[i]);
                  bus_drv1.drive_datax(data[i+1]);
               join
               // $fwrite(f,"%0x\n",{data[1],data[0]});
            end
         end 
         else if (ACTIVE_DPHY_LANES == 3) begin
            if(DEBUG) begin
               $display("%t DPHY [%0d] DATA : Driving data[0] = %0x", $time, DPHY_CH, data[0]);
               $display("%t DPHY [%0d] DATA : Driving data[0] = %0x", $time, DPHY_CH, data[1]);
               $display("%t DPHY [%0d] DATA : Driving data[0] = %0x", $time, DPHY_CH, data[2]);
            end
               fork
                  bus_drv0.drive_datax(data[0]);
                  bus_drv1.drive_datax(data[1]);
                  bus_drv2.drive_datax(data[2]);
               join
               fork
                  bus_drv0.drive_datax(data[3]);
                  bus_drv1.drv_trail;
                  bus_drv2.drv_trail;
               join
         end 
         else if (ACTIVE_DPHY_LANES == 4) begin
            fork
               bus_drv0.drive_datax(data[0]);
               bus_drv1.drive_datax(data[1]);
               bus_drv2.drive_datax(data[2]);
               bus_drv3.drive_datax(data[3]);
            join
         end
           post_data;
      end
   join
endtask: drive_ls

//-------------------------
task drive_fe();
   fork
      begin
         drive_clk;
      end
      begin
         pre_data;

         // FE packet
         data[0] = {vc, 6'h01};
         data[1] = fnum;
         data[2] = 8'h00;
         data[3] = 8'h00;
         get_ecc({data[2], data[1], data[0]}, data[3]);

         $display("%t DPHY [%0d] DATA : Driving FE", $time, DPHY_CH);
         if (ACTIVE_DPHY_LANES == 1) begin
            for (i = 0 ; i < 4 ; i = i + 1) begin
               bus_drv0.drive_datax(data[i]);
            end
         end 
         else if (ACTIVE_DPHY_LANES == 2) begin
            for (i = 0 ; i < 4 ; i = i + 2) begin
               fork
                  bus_drv0.drive_datax(data[i]);
                  bus_drv1.drive_datax(data[i+1]);
               join
               // $fwrite(f,"%0x\n",{data[1],data[0]});
            end
         end 
         else if (ACTIVE_DPHY_LANES == 3) begin
            fork
               bus_drv0.drive_datax(data[0]);
               bus_drv1.drive_datax(data[1]);
               bus_drv2.drive_datax(data[2]);
            join
            fork
               bus_drv0.drive_datax(data[3]);
               bus_drv1.drv_trail;
               bus_drv2.drv_trail;
            join
         end 
         else if (ACTIVE_DPHY_LANES == 4) begin
            fork
               bus_drv0.drive_datax(data[0]);
               bus_drv1.drive_datax(data[1]);
               bus_drv2.drive_datax(data[2]);
               bus_drv3.drive_datax(data[3]);
            join
            // $fwrite(f,"%0x\n",{data[3],data[2],data[1],data[0]});
            // data_from_tb[d] <= {data[3],data[2],data[1],data[0]};
            // d = d + 1;
         end
         post_data;
         fnum = ~fnum;
      end
   join
endtask: drive_fe

//-------------------------
task drive_le();
   fork
      begin
         drive_clk;
      end
      begin
         pre_data;

         // LE packet
         data[0] = {vc, 6'h03};
         data[1] = lnum[7:0];
         data[2] = lnum[15:0];
         data[3] = 8'h00;
         get_ecc({data[2], data[1], data[0]}, data[3]);

         $display("%t DPHY [%0d] DATA : Driving LE", $time, DPHY_CH);
         if (ACTIVE_DPHY_LANES == 1) begin
            for (i = 0 ; i < 4 ; i = i + 1) begin
               bus_drv0.drive_datax(data[i]);
            end
         end 
         else if (ACTIVE_DPHY_LANES == 2) begin
            for (i = 0 ; i < 4 ; i = i + 2) begin
               fork
                  bus_drv0.drive_datax(data[i]);
                  bus_drv1.drive_datax(data[i+1]);
               join
               // $fwrite(f,"%0x\n",{data[1],data[0]});
            end
         end 
         else if (ACTIVE_DPHY_LANES == 3) begin
            fork
               bus_drv0.drive_datax(data[0]);
               bus_drv1.drive_datax(data[1]);
               bus_drv2.drive_datax(data[2]);
            join
            fork
               bus_drv0.drive_datax(data[3]);
               bus_drv1.drv_trail;
               bus_drv2.drv_trail;
            join
         end 
         else if (ACTIVE_DPHY_LANES == 4) begin
            fork
               bus_drv0.drive_datax(data[0]);
               bus_drv1.drive_datax(data[1]);
               bus_drv2.drive_datax(data[2]);
               bus_drv3.drive_datax(data[3]);
            join
            // $fwrite(f,"%0x\n",{data[3],data[2],data[1],data[0]});
            // data_from_tb[d] <= {data[3],data[2],data[1],data[0]};
            // d = d + 1;
         end

         post_data;
         lnum = lnum + 1;
      end
   join
endtask: drive_le
   

//-------------------------
task drive_data();
   word_count_odd_r = wc;
   fork
      begin
         drive_clk;
      end
      begin
         #tCLK_PREPARE;
         pre_data;
         validator_r = 1'd1;
         //drive header
         data[0] = {vc, dt};
         data[1] = {wc[7:0]};
         data[2] = {wc[15:8]};
         data[3] = 8'h00;
         get_ecc({data[2], data[1], data[0]}, data[3]);

         if (ACTIVE_DPHY_LANES == 1) begin
            for (i = 0 ; i < 4 ; i = i + 1) begin
               bus_drv0.drive_datax(data[i]);
            end
            $fwrite(h,"%0x\n",{data[3],data[2],data[1],data[0]});       
         end 
         else if (ACTIVE_DPHY_LANES == 2) begin
            for (i = 0 ; i < 4 ; i = i + 2) begin
               fork
                  bus_drv0.drive_datax(data[i]);
                  bus_drv1.drive_datax(data[i+1]);
               join
            end
            $fwrite(h,"%0x\n",{data[3],data[2],data[1],data[0]});
         end 
         else if (ACTIVE_DPHY_LANES == 3) begin
            fork
               bus_drv0.drive_datax(data[0]);
               bus_drv1.drive_datax(data[1]);
               bus_drv2.drive_datax(data[2]);
            join

            $fwrite(h,"%0x\n",{data[3],data[2],data[1],data[0]});
            data[0]        = $random;
            data[1]        = $random;

            fork
               bus_drv0.drive_datax(data[3]);
               bus_drv1.drive_datax(data[0]);
               bus_drv2.drive_datax(data[1]);
            join
            $fwrite(f,"%0x\n%0x\n",data[0],data[1]);            
         end 
         else if (ACTIVE_DPHY_LANES == 4) begin
            fork
               bus_drv0.drive_datax(data[0]);
               bus_drv1.drive_datax(data[1]);
               bus_drv2.drive_datax(data[2]);
               bus_drv3.drive_datax(data[3]);
            join
            $fwrite(h,"%0x\n",{data[3],data[2],data[1],data[0]}); // This line displays header for long packet
         end
         validator_r = 1'd0;
         // reset crc value
         chksum = 16'hffff;
      
         // temporary alternating data 8'h0 and 8'hFF
         data[0] = 0;
         data[1] = 0;
         data[2] = 0;
         data[3] = 0;

         // random data packet
         repeat (BPC) begin // use variable later
            if (word_count_odd_r >= ACTIVE_DPHY_LANES) begin
               iterations_r = ACTIVE_DPHY_LANES;
               word_count_odd_r = word_count_odd_r - ACTIVE_DPHY_LANES;
            end
            else begin
               iterations_r = word_count_odd_r;
            end            
            for (i = 0; i < iterations_r; i = i + 1) begin
               if (FIXED_DATA == 0) begin
                 data[i] = $random;
               end else
               begin
                 data[i] = ~data[i];
               end
               compute_crc16(data[i]);
            end

            $display("%t DPHY [%0d] Driving Data", $time, DPHY_CH);
            if (ACTIVE_DPHY_LANES == 1) begin
               for (i = 0 ; i < ACTIVE_DPHY_LANES ; i = i + 1) begin
                  bus_drv0.drive_datax(data[i]);
               end
               $fwrite(f,"%0x\n",data[0]);
            end 
            else if (ACTIVE_DPHY_LANES == 2) begin
               if (iterations_r == ACTIVE_DPHY_LANES) begin
                  fork
                     bus_drv0.drive_datax(data[0]);
                     bus_drv1.drive_datax(data[1]);
                  join
                  $fwrite(f,"%0x\n%0x\n",data[0],data[1]);
               end
               else begin
                  fork
                     bus_drv0.drive_datax(data[0]);
                     bus_drv1.drive_datax(chksum[7:0]);
                  join
                  $fwrite(f,"%0x\n",data[0]);
               end               
            end 
            else if (ACTIVE_DPHY_LANES == 3) begin
               if (iterations_r == ACTIVE_DPHY_LANES) begin
               fork
                  bus_drv0.drive_datax(data[0]);
                  bus_drv1.drive_datax(data[1]);
                  bus_drv2.drive_datax(data[2]);
               join
                  $fwrite(f,"%0x\n%0x\n%0x\n",data[0],data[1],data[2]);
               end
               else if (iterations_r == (ACTIVE_DPHY_LANES - 1)) begin
                  fork
                     bus_drv0.drive_datax(data[0]);
                     bus_drv1.drive_datax(data[1]);
                     bus_drv2.drive_datax(chksum[7:0]);
                  join
                  $fwrite(f,"%0x\n%0x\n",data[0],data[1]);
               end
               else if (iterations_r == (ACTIVE_DPHY_LANES - 2)) begin
                  fork
                     bus_drv0.drive_datax(data[0]);
                     bus_drv1.drive_datax(chksum[7:0]);
                     bus_drv2.drive_datax(chksum[15:8]);
                  join
                  $fwrite(f,"%0x\n",data[0]);
               end
            end
            else if (ACTIVE_DPHY_LANES == 4) begin
               if (iterations_r == ACTIVE_DPHY_LANES) begin
                  fork
                     bus_drv0.drive_datax(data[0]);
                     bus_drv1.drive_datax(data[1]);
                     bus_drv2.drive_datax(data[2]);
                     bus_drv3.drive_datax(data[3]);
                  join
                  $fwrite(f,"%0x\n%0x\n%0x\n%0x\n",data[0],data[1],data[2],data[3]);
               end
               else if (iterations_r == (ACTIVE_DPHY_LANES - 1)) begin
                  fork
                     bus_drv0.drive_datax(data[0]);
                     bus_drv1.drive_datax(data[1]);
                     bus_drv2.drive_datax(data[2]);
                     bus_drv3.drive_datax(chksum[7:0]);
                  join
                  $fwrite(f,"%0x\n%0x\n%0x\n",data[0],data[1],data[2]);
               end
               else if (iterations_r == (ACTIVE_DPHY_LANES - 2)) begin
                  fork
                     bus_drv0.drive_datax(data[0]);
                     bus_drv1.drive_datax(data[1]);
                     bus_drv2.drive_datax(chksum[7:0]);
                     bus_drv3.drive_datax(chksum[15:8]);
                  join
                  $fwrite(f,"%0x\n%0x\n",data[0],data[1]);
               end
               else if (iterations_r == (ACTIVE_DPHY_LANES - 3)) begin
                  fork
                     bus_drv0.drive_datax(data[0]);
                     bus_drv1.drive_datax(chksum[7:0]);
                     bus_drv2.drive_datax(chksum[15:8]);
                     bus_drv3.drv_trail;
                  join
                  $fwrite(f,"%0x\n",data[0]);
               end                  
               // data_from_tb[d] <= {data[3],data[2],data[1],data[0]};
               // d = d + 1;
            end
         end

         // drive crc data until end of packet
         $display("%t DPHY [%0d] Driving CRC[15:8] = %0x; CRC[7:0] = %0x", $time, DPHY_CH, chksum[15:8], chksum[7:0]);
         if (ACTIVE_DPHY_LANES == 1) begin
            bus_drv0.drive_datax(chksum[7:0]);
            bus_drv0.drive_datax(chksum[15:8]);
         end 
         else if (ACTIVE_DPHY_LANES == 2) begin
            if (iterations_r == ACTIVE_DPHY_LANES) begin
               fork
                  bus_drv0.drive_datax(chksum[7:0]);
                  bus_drv1.drive_datax(chksum[15:8]);
               join 
            end
            else begin
               fork
                  bus_drv0.drive_datax(chksum[15:8]);
                  bus_drv1.drv_trail;
               join
            end            
         end 
         else if (ACTIVE_DPHY_LANES == 3) begin
            if (iterations_r == ACTIVE_DPHY_LANES) begin
               fork
                  bus_drv0.drive_datax(chksum[7:0]);
                  bus_drv1.drive_datax(chksum[15:8]);
                  bus_drv2.drv_trail;
               join
            end
            else if (iterations_r == (ACTIVE_DPHY_LANES -1)) begin
              fork
                 bus_drv0.drive_datax(chksum[15:8]);
                 bus_drv1.drv_trail;
                 bus_drv2.drv_trail;
              join 
            end 
            else begin
               fork
                  bus_drv0.drv_trail;
                  bus_drv1.drv_trail;
                  bus_drv2.drv_trail; 
               join
            end
         end
         else if (ACTIVE_DPHY_LANES == 4) begin
            if (iterations_r == ACTIVE_DPHY_LANES) begin
               fork
                  bus_drv0.drive_datax(chksum[7:0]);
                  bus_drv1.drive_datax(chksum[15:8]);
                  bus_drv2.drv_trail;
                  bus_drv3.drv_trail;
               join
            end
            else if (iterations_r == (ACTIVE_DPHY_LANES -1)) begin
               fork
                  bus_drv0.drive_datax(chksum[15:8]);
                  bus_drv1.drv_trail;
                  bus_drv2.drv_trail;
                  bus_drv3.drv_trail;
               join 
            end 
            else begin
               fork
                  bus_drv0.drv_trail;
                  bus_drv1.drv_trail;
                  bus_drv2.drv_trail; 
                  bus_drv3.drv_trail; 
               join
               end
            end

         #tHS_TRAIL;

         // HS-Stop
         //@(clk_p_i);
         fork
            bus_drv0.drv_stop;
            begin
               if (ACTIVE_DPHY_LANES == 2) begin
                  bus_drv1.drv_stop;
               end
            end
            begin
               if (ACTIVE_DPHY_LANES == 3) begin
                  bus_drv1.drv_stop;
                  bus_drv2.drv_stop;
               end
            end
            begin
               if (ACTIVE_DPHY_LANES == 4) begin
                  fork
                     bus_drv1.drv_stop;
                     bus_drv2.drv_stop;
                     bus_drv3.drv_stop;
                  join
               end
            end
         join

         #tCLK_POST; // based from waveform
         clk_en = 0;

      
     end
   join
endtask: drive_data
   

//-------------------------
task compute_crc16(input [7:0] data);
   for (n = 0; n < 8; n = n + 1) begin
     cur_crc = chksum;
     cur_crc[15] = data[n]^cur_crc[0];
     cur_crc[10] = cur_crc[11]^cur_crc[15];
     cur_crc[3]  = cur_crc[4]^cur_crc[15]; 
     chksum = chksum >> 1;
     chksum[15] = cur_crc[15];
     chksum[10] = cur_crc[10];
     chksum[3] = cur_crc[3];
   end
endtask: compute_crc16
   

//-------------------------
task pre_data();
   @(posedge clk_en);

   #tCLK_PRE;

   // HS-RQST
   if(DEBUG) begin
     $display("%t DPHY [%0d] DATA : Driving HS-RQST", $time, DPHY_CH);
   end
    bus_drv0.drv_dat_st(0,1);
    if (ACTIVE_DPHY_LANES == 2) begin
    bus_drv1.drv_dat_st(0,1);
    end else
    if (ACTIVE_DPHY_LANES == 3) begin
    bus_drv1.drv_dat_st(0,1);
    bus_drv2.drv_dat_st(0,1);
    end else
    if (ACTIVE_DPHY_LANES == 4) begin
    bus_drv1.drv_dat_st(0,1);
    bus_drv2.drv_dat_st(0,1);
    bus_drv3.drv_dat_st(0,1);
    end
   #tLPX;

   // HS-Prpr
   if(DEBUG) begin
     $display("%t DPHY [%0d] DATA : Driving HS-Prpr", $time, DPHY_CH);
   end
    bus_drv0.drv_dat_st(0,0);
    if (ACTIVE_DPHY_LANES == 2) begin
    bus_drv1.drv_dat_st(0,0);
    end else
    if (ACTIVE_DPHY_LANES == 3) begin
    bus_drv1.drv_dat_st(0,0);
    bus_drv2.drv_dat_st(0,0);
    end else
    if (ACTIVE_DPHY_LANES == 4) begin
    bus_drv1.drv_dat_st(0,0);
    bus_drv2.drv_dat_st(0,0);
    bus_drv3.drv_dat_st(0,0);
    end
   #tHS_PREPARE;

   // HS-Go
   if(DEBUG) begin
     $display("%t DPHY [%0d] CLK : Driving HS-Go", $time, DPHY_CH);
   end
    bus_drv0.drv_dat_st(0,1);
    if (ACTIVE_DPHY_LANES == 2) begin
    bus_drv1.drv_dat_st(0,1);
    end else
    if (ACTIVE_DPHY_LANES == 3) begin
    bus_drv1.drv_dat_st(0,1);
    bus_drv2.drv_dat_st(0,1);
    end else
    if (ACTIVE_DPHY_LANES == 4) begin
    bus_drv1.drv_dat_st(0,1);
    bus_drv2.drv_dat_st(0,1);
    bus_drv3.drv_dat_st(0,1);
    end
   #tHS_ZERO;

   //sync with clock
   @(posedge clk_p_i);

   // HS-Sync
   // generate data
   for (i = 0; i < ACTIVE_DPHY_LANES; i = i + 1) begin
      data[i] = 8'hB8;
   end

   if(DEBUG) begin
      $display("%t DPHY [%0d] CLK : Driving SYNC Data", $time, DPHY_CH);
   end

   if (ACTIVE_DPHY_LANES == 1) begin
      bus_drv0.drive_datax(data[0]);
   end 
   else if (ACTIVE_DPHY_LANES == 2) begin
      fork
         bus_drv0.drive_datax(data[0]);
         bus_drv1.drive_datax(data[1]);
      join
   end 
   else if (ACTIVE_DPHY_LANES == 3) begin
      fork
         bus_drv0.drive_datax(data[0]);
         bus_drv1.drive_datax(data[1]);
         bus_drv2.drive_datax(data[2]);
      join
   end else if (ACTIVE_DPHY_LANES == 4) begin
      fork
         bus_drv0.drive_datax(data[0]);
         bus_drv1.drive_datax(data[1]);
         bus_drv2.drive_datax(data[2]);
         bus_drv3.drive_datax(data[3]);
      join
   end
endtask: pre_data
   

//-------------------------
task drive_trail();
   if(DEBUG) begin
      $display("%t DPHY [%0d] DATA : Driving HS-Trail", $time, DPHY_CH);
   end
   #tHS_TRAIL;

   // HS-Stop
   if(DEBUG) begin
      $display("%t DPHY [%0d] DATA : Driving HS-Stop", $time, DPHY_CH);
   end
   fork
      bus_drv0.drv_stop;

      begin
         if (ACTIVE_DPHY_LANES == 2) begin
            bus_drv1.drv_stop;
         end 
      end

      begin
         if (ACTIVE_DPHY_LANES == 3) begin
            bus_drv1.drv_stop;
            bus_drv2.drv_stop;
         end 
      end

      begin
         if (ACTIVE_DPHY_LANES == 4) begin
            fork
               bus_drv1.drv_stop;
               bus_drv2.drv_stop;
               bus_drv3.drv_stop;
            join
         end
      end
   join

   #tCLK_POST; // based from waveform
   clk_en = 0;
endtask: drive_trail
   

//-------------------------
task post_data();
   // HS-Trail
   if(DEBUG) begin
     $display("%t DPHY [%0d] DATA : Driving HS-Trail", $time, DPHY_CH);
   end
   fork
      bus_drv0.drv_trail;

      begin
         if (ACTIVE_DPHY_LANES == 2) begin
            bus_drv1.drv_trail;
         end
      end

      begin
         if (ACTIVE_DPHY_LANES == 3) begin
            bus_drv1.drv_trail;
            bus_drv2.drv_trail;
         end
      end

      begin
         if (ACTIVE_DPHY_LANES == 4) begin
            fork
               bus_drv1.drv_trail;
               bus_drv2.drv_trail;
               bus_drv3.drv_trail;
            join
         end
      end
   join
   #tHS_TRAIL;

   // HS-Stop
   if(DEBUG) begin
      $display("%t DPHY [%0d] DATA : Driving HS-Stop", $time, DPHY_CH);
   end

   fork
      bus_drv0.drv_stop;
      begin
         if (ACTIVE_DPHY_LANES == 2) begin
            bus_drv1.drv_stop;
         end 
      end
      begin
         if (ACTIVE_DPHY_LANES == 3) begin
            bus_drv1.drv_stop;
            bus_drv2.drv_stop;
         end 
      end
      begin
         if (ACTIVE_DPHY_LANES == 4) begin
            fork
               bus_drv1.drv_stop;
               bus_drv2.drv_stop;
               bus_drv3.drv_stop;
            join
         end
      end
   join

   #tCLK_POST; // based from waveform
   clk_en = 0;
endtask: post_data
   

//-------------------------
always @(wc) begin
   BPC = (wc % ACTIVE_DPHY_LANES == 0)? (wc)/ACTIVE_DPHY_LANES : (wc)/ACTIVE_DPHY_LANES + 1;
end

//-------------------------
task get_ecc (input [23:0] d, output [5:0] ecc_val);
   ecc_val[0] = d[0]^d[1]^d[2]^d[4]^d[5]^d[7]^d[10]^d[11]^d[13]^d[16]^d[20]^d[21]^d[22]^d[23];
   ecc_val[1] = d[0]^d[1]^d[3]^d[4]^d[6]^d[8]^d[10]^d[12]^d[14]^d[17]^d[20]^d[21]^d[22]^d[23];
   ecc_val[2] = d[0]^d[2]^d[3]^d[5]^d[6]^d[9]^d[11]^d[12]^d[15]^d[18]^d[20]^d[21]^d[22];
   ecc_val[3] = d[1]^d[2]^d[3]^d[7]^d[8]^d[9]^d[13]^d[14]^d[15]^d[19]^d[20]^d[21]^d[23];
   ecc_val[4] = d[4]^d[5]^d[6]^d[7]^d[8]^d[9]^d[16]^d[17]^d[18]^d[19]^d[20]^d[22]^d[23];
   ecc_val[5] = d[10]^d[11]^d[12]^d[13]^d[14]^d[15]^d[16]^d[17]^d[18]^d[19]^d[21]^d[22]^d[23];
endtask: get_ecc

endmodule: csi2_model

`endif
