//===========================================
// Filename: clk_driver.sv
//===========================================
`ifndef CLK_DRIVER
`define CLK_DRIVER

`timescale 1 ps / 1 ps

module clk_driver();
  logic clk_p_i, clk_n_i;

initial begin
  clk_p_i = 1;
  clk_n_i = 1;
end

task drv_clk_st(input dp, input dn);
   clk_p_i = dp;
   clk_n_i = dn;
endtask: drv_clk_st
   
endmodule: clk_driver

`endif
