## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# clk
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clk_ext]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_ext]

# button
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS25} [get_ports reset]

# cam_en
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS25} [get_ports cam_en]

# led
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports led1]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports led2]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports led3]

#temp1, temp2
set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS25} [get_ports temp1]
#set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS25} [get_ports temp2]

# CRUVI CA
# sda, scl
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS25} [get_ports pad_sda]
set_property -dict {PACKAGE_PIN E7 IOSTANDARD LVCMOS25} [get_ports pad_scl]

#clk_p, clk_n
set_property -dict {PACKAGE_PIN C6 IOSTANDARD LVDS_25} [get_ports {dphy_clk[1]}]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVDS_25} [get_ports {dphy_clk[0]}]

#data0_p, data0_n
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVDS_25} [get_ports {dphy_d0[1]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVDS_25} [get_ports {dphy_d0[0]}]

#data1_p, data1_n
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVDS_25} [get_ports {dphy_d1[1]}]
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVDS_25} [get_ports {dphy_d1[0]}]

# CRUVI CC
# sda, scl
#set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS25} [get_ports pad_sda]
#set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25} [get_ports pad_scl]

#clk_p, clk_n
#set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_clk[1]}]
#set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_clk[0]}]

#data0_p, data0_n
#set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_d0[1]}]
#set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_d0[0]}]

#data1_p, data1_n
#set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_d1[1]}]
#set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_d1[0]}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets link/clkphy_inst/bit_clock_int_bufg]

# set_property IODELAY_GROUP group_name [get_cells {idelayctrl_inst link/d1phy/idelayctrl_inst link/d0phy/idelayctrl_inst}]
