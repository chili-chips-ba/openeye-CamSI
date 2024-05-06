//===========================================
// Filename: bus_driver.sv
//===========================================
`ifndef BUS_DRIVER
`define BUS_DRIVER

`timescale 1 ps / 1 ps

module bus_driver#(
   parameter   CH       = 0,
   parameter   DPHY_CLK = 2244
)(
   input logic clk_p_i
);

logic do_p_i, do_n_i;

initial begin
  do_p_i = 1;
  do_n_i = 1;
end

//--------------------------
task drive_datax(input [7:0] data);
   $display("%t Data[%0d] : Driving with data = %0x\n", $time, CH, data);
   for (int i = 0; i < 8; i++) begin
      @(clk_p_i);
      #(DPHY_CLK/4);
      do_p_i =  data[i];
      do_n_i = ~data[i];     
   end
endtask: drive_datax
   
//--------------------------
task drv_dat_st(input dp, input dn);
   do_p_i = dp;
   do_n_i = dn;
endtask: drv_dat_st
   
//--------------------------
task drv_trail();
   $display("%t Data[%0d] : Driving trail bytes", $time, CH);
   @(clk_p_i);
   #(DPHY_CLK/4);
   do_p_i = ~do_p_i;
   do_n_i = ~do_n_i;
endtask: drv_trail
   
//--------------------------
task drv_stop();
   $display("%t Data[%0d] : Driving stop", $time, CH);
   @(clk_p_i);
   #(DPHY_CLK/4);
   do_p_i = 1;
   do_n_i = 1;
endtask: drv_stop

endmodule: bus_driver
`endif
