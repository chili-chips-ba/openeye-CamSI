#======================================================================== 
# openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
#  Constraints for Artix7-100 and CRUVI_CC
#======================================================================== 


set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO        [current_design]

#-------------------------------------------------------------------------
# Clocks

# 100MHz external clock
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_ext]

# 720MHz CSI 4-lane clock
# create_clock -period 1.388 -name cam_dphy_clk -waveform {0.000 0.694} -add [get_ports {cam_dphy_clk[1]}]

# 456MHz CSI 2-lane clock
create_clock -period 2.190 -name cam_dphy_clk -waveform {0.000 1.095} -add [get_ports cam_dphy_clk[1]]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_ports u_csi_rx_top/u_phy_clk/dphy_clk_in]

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



#-------------------------------------------------------------------------
# clk, reset and misc
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clk_ext]

set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS25} [get_ports areset]
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS25} [get_ports cam_en]

#-------------------------------------------------------------------------
# I2C
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS25} [get_ports i2c_sda]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25} [get_ports i2c_scl]

#-------------------------------------------------------------------------
# CSI
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVDS_25}  [get_ports cam_dphy_clk[1]]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVDS_25}  [get_ports cam_dphy_clk[0]]
                                                          
#set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVDS_25}  [get_ports cam_dphy_dat[0][1]]
#set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25}  [get_ports cam_dphy_dat[0][0]]
                                                          
#set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVDS_25}  [get_ports cam_dphy_dat[1][1]]
#set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVDS_25}  [get_ports cam_dphy_dat[1][0]]

set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVDS_25}  [get_ports cam_dphy_dat[1]]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25}  [get_ports cam_dphy_dat[0]]
                                                          
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVDS_25}  [get_ports cam_dphy_dat[3]]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVDS_25}  [get_ports cam_dphy_dat[2]]

#-------------------------------------------------------------------------
# HDMI
set_property PACKAGE_PIN R1 [get_ports hdmi_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports hdmi_clk_p]


# HDMI Clock
set_property PACKAGE_PIN T1 [get_ports hdmi_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports hdmi_clk_n]


#set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVDS_25}  [get_ports hdmi_clk_p];
#set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVDS_25}  [get_ports hdmi_clk_n];

# HDMI Data 0
set_property PACKAGE_PIN V5 [get_ports hdmi_dat_p[0]]
set_property IOSTANDARD LVDS_25 [get_ports hdmi_dat_p[0]]
set_property PACKAGE_PIN V4 [get_ports hdmi_dat_n[0]]
set_property IOSTANDARD LVDS_25 [get_ports hdmi_dat_n[0]]

# HDMI Data 1
set_property PACKAGE_PIN N2 [get_ports hdmi_dat_p[1]]
set_property IOSTANDARD LVDS_25 [get_ports hdmi_dat_p[1]]
set_property PACKAGE_PIN N1 [get_ports hdmi_dat_n[1]]
set_property IOSTANDARD LVDS_25 [get_ports hdmi_dat_n[1]]

# HDMI Data 2
set_property PACKAGE_PIN T5 [get_ports hdmi_dat_p[2]]
set_property IOSTANDARD LVDS_25 [get_ports hdmi_dat_p[2]]
set_property PACKAGE_PIN T4 [get_ports hdmi_dat_n[2]]
set_property IOSTANDARD LVDS_25 [get_ports hdmi_dat_n[2]]
#-------------------------------------------------------------------------
# LED
set_property -dict {PACKAGE_PIN A8  IOSTANDARD LVCMOS33} [get_ports led[0]]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports led[1]]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports led[2]]

#-------------------------------------------------------------------------
# DEBUG pins
#set_property PACKAGE_PIN D3 [get_ports debug_pins[0]]
#set_property PACKAGE_PIN E3 [get_ports debug_pins[1]]
#set_property PACKAGE_PIN E5 [get_ports debug_pins[2]]
#set_property PACKAGE_PIN E6 [get_ports debug_pins[3]]
#set_property PACKAGE_PIN K2 [get_ports debug_pins[4]]
#set_property PACKAGE_PIN K1 [get_ports debug_pins[5]]
#set_property PACKAGE_PIN J2 [get_ports debug_pins[6]]
#set_property PACKAGE_PIN J3 [get_ports debug_pins[7]]
#set_property IOSTANDARD LVCMOS25 [get_ports debug_pins[*]]

#======================================================================== 
# End-of-File
#======================================================================== 
