#======================================================================== 
# openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
#  Common part of constraints
#======================================================================== 

#-------------------------------------------------------------------------
# Configuration options
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO        [current_design]

#-------------------------------------------------------------------------
# Clocks

# 100MHz external clock
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_ext]

# 720MHz CSI 4-lane clock
# create_clock -period 1.388 -name cam_dphy_clk -waveform {0.000 0.694} -add [get_ports {cam_dphy_clk[1]}]

# 456MHz CSI 2-lane clock
create_clock -period 2.193 -name cam_dphy_clk -waveform {0.000 1.095} -add [get_ports cam_dphy_clk[1]]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets u_csi_rx_top/u_phy_clk/dphy_clk_in]

#-------------------------------------------------------------------------
# Async
#set_false_path -from [get_pins u_clkrst_gen/u_pll_top/srst_reg/C] #               -to   [get_pins u_csi_rx_top/u_clk_det/byte_clk_fail_reg/PRE]

#set_false_path -from [get_pins {u_clkrst_gen/srst_reg[1]/C}] #               -to   [get_pins u_csi_rx_top/u_clk_det/reset_in_demet_reg/D]

#set_false_path -from [get_pins u_clkrst_gen/u_pll_top/srst_reg_replica/C] #               -to   [get_pins {u_clkrst_gen/srst_reg[1]/PRE}]


#-------------------------------------------------------------------------
# I/O delays
#FIXME--|  set_input_delay  -max 0 [all_inputs]
#FIXME--|  set_input_delay  -min 2 [all_inputs]
#FIXME--|
#FIXME--|  set_output_delay -max 0 [all_outputs]
#FIXME--|  set_output_delay -min 2 [all_outputs]


#======================================================================== 
# End-of-File
#======================================================================== 
