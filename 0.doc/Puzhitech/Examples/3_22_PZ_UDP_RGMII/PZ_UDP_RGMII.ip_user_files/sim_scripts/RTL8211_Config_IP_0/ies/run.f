-makelib ies_lib/xil_defaultlib -sv \
  "D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../ip/RTL8211_Config_IP_0/src/mdio_ctrl.v" \
  "../../../ip/RTL8211_Config_IP_0/src/mdio_dri.v" \
  "../../../ip/RTL8211_Config_IP_0/src/mdio_rw_test.v" \
  "../../../ip/RTL8211_Config_IP_0/sim/RTL8211_Config_IP_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

