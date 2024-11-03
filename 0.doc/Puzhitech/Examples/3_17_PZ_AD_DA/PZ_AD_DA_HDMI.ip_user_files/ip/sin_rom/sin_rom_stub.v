// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sat Jan 27 20:21:25 2024
// Host        : XH running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               E:/Zynq_2019_1/PZ_A7_Lite/PZ_A35T_Demo/1_FPGA/3_17_PZ_AD_DA/PZ_AD_DA_HDMI.runs/sin_rom_synth_1/sin_rom_stub.v
// Design      : sin_rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_3,Vivado 2019.1" *)
module sin_rom(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[9:0],douta[11:0]" */;
  input clka;
  input [9:0]addra;
  output [11:0]douta;
endmodule
