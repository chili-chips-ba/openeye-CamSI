## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# clk
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clk_ext]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_ext]

# button
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS25} [get_ports reset]

# led
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports led1]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports led2]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports led3]

# CRUVI CA
# sda, scl
#set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS33} [get_ports pad_sda]
#set_property -dict {PACKAGE_PIN E7 IOSTANDARD LVCMOS33} [get_ports pad_scl]

#clk_p, clk_n
#set_property -dict {PACKAGE_PIN C6 IOSTANDARD LVDS_25} [get_ports dphy_clk[1]]
#set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVDS_25} [get_ports dphy_clk[0]]

#data0_p, data0_n
#set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVDS_25} [get_ports dphy_d0[1]]
#set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVDS_25} [get_ports dphy_d0[0]]

#data1_p, data1_n
#set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVDS_25} [get_ports dphy_d1[1]]
#set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVDS_25} [get_ports dphy_d1[0]]

# HDMI
set_property -dict { PACKAGE_PIN C4  IOSTANDARD LVDS_25 } [get_ports { hdmi_clk_p }];
set_property -dict { PACKAGE_PIN B4  IOSTANDARD LVDS_25 } [get_ports { hdmi_clk_n }];

set_property -dict { PACKAGE_PIN H1  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_p[0] }];
set_property -dict { PACKAGE_PIN G1  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_n[0] }];

set_property -dict { PACKAGE_PIN D8  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_p[1] }];
set_property -dict { PACKAGE_PIN C7  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_n[1] }];

set_property -dict { PACKAGE_PIN F4  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_p[2] }];
set_property -dict { PACKAGE_PIN F3  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_n[2] }];

# CRUVI CC
# cam_en
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS25} [get_ports cam_en]

# sda, scl
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS25} [get_ports pad_sda]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25} [get_ports pad_scl]

#clk_p, clk_n
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVDS_25} [get_ports {dphy_clk[1]}]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVDS_25} [get_ports {dphy_clk[0]}]

#data0_p, data0_n
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVDS_25} [get_ports {dphy_d0[1]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25} [get_ports {dphy_d0[0]}]

#data1_p, data1_n
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVDS_25} [get_ports {dphy_d1[1]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVDS_25} [get_ports {dphy_d1[0]}]

# HDMI
#set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVDS_25} [get_ports hdmi_clk_n]
#set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVDS_25} [get_ports hdmi_clk_p]

#set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[0]}]
#set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[0]}]

#set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[1]}]
#set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[1]}]

#set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[2]}]
#set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[2]}]

#DEBUG pins
set_property PACKAGE_PIN D3 [get_ports {debug_pins[0]}]
set_property PACKAGE_PIN E3 [get_ports {debug_pins[1]}]
set_property PACKAGE_PIN E5 [get_ports {debug_pins[2]}]
set_property PACKAGE_PIN E6 [get_ports {debug_pins[3]}]
set_property PACKAGE_PIN K2 [get_ports {debug_pins[4]}]
set_property PACKAGE_PIN K1 [get_ports {debug_pins[5]}]
set_property PACKAGE_PIN J2 [get_ports {debug_pins[6]}]
set_property PACKAGE_PIN J3 [get_ports {debug_pins[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {debug_pins[*]}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets u_csi_rx_top/link/clkphy/bit_clock_int_bufg]
