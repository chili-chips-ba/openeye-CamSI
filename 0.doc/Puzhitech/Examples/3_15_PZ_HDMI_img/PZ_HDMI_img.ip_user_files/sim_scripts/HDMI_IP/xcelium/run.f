-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../ipstatic/src/TMDSEncoder.vhd" \
  "../../../ipstatic/src/SerializerN_1.vhd" \
  "../../../ipstatic/src/DVITransmitter.vhd" \
  "../../../ipstatic/src/hdmi_tx.vhd" \
  "../../../ip/HDMI_IP/sim/HDMI_IP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

