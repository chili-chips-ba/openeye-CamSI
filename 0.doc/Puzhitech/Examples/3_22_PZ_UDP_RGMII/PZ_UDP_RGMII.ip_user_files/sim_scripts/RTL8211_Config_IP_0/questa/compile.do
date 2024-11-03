vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 \
"../../../ip/RTL8211_Config_IP_0/src/mdio_ctrl.v" \
"../../../ip/RTL8211_Config_IP_0/src/mdio_dri.v" \
"../../../ip/RTL8211_Config_IP_0/src/mdio_rw_test.v" \
"../../../ip/RTL8211_Config_IP_0/sim/RTL8211_Config_IP_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

