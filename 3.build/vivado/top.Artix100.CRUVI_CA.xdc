#======================================================================== 
# openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
#  Constraints for Artix7-100 and CRUVI_CA position
#======================================================================== 

#-------------------------------------------------------------------------
# clk, reset and misc
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clk_ext]

set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS25} [get_ports areset]
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS25} [get_ports cam_en]

#-------------------------------------------------------------------------
# I2C
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS33}  [get_ports i2c_sda]
set_property -dict {PACKAGE_PIN E7 IOSTANDARD LVCMOS33}  [get_ports i2c_scl]

#-------------------------------------------------------------------------
# CSI
set_property -dict {PACKAGE_PIN C6 IOSTANDARD LVDS_25}   [get_ports cam_dphy_clk[1]]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVDS_25}   [get_ports cam_dphy_clk[0]]
                                                           
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVDS_25}   [get_ports cam_dphy_dat[0][1]]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVDS_25}   [get_ports cam_dphy_dat[0][0]]
                                                           
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVDS_25}   [get_ports cam_dphy_dat[1][1]]
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVDS_25}   [get_ports cam_dphy_dat[1][0]]

#-------------------------------------------------------------------------
# HDMI
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVDS_25}  [get_ports hdmi_clk_n]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVDS_25}  [get_ports hdmi_clk_p]
                                                          
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVDS_25}  [get_ports hdmi_dat_p[0]]
set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVDS_25}  [get_ports hdmi_dat_n[0]]
                                                          
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVDS_25}  [get_ports hdmi_dat_p[1]]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVDS_25}  [get_ports hdmi_dat_n[1]]
                                                          
set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVDS_25}  [get_ports hdmi_dat_p[2]]
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVDS_25}  [get_ports hdmi_dat_n[2]]

#-------------------------------------------------------------------------
# LED
set_property -dict {PACKAGE_PIN A8  IOSTANDARD LVCMOS33} [get_ports led[0]]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports led[1]]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports led[2]]

#-------------------------------------------------------------------------
# DEBUG pins
set_property PACKAGE_PIN D3 [get_ports debug_pins[0]]
set_property PACKAGE_PIN E3 [get_ports debug_pins[1]]
set_property PACKAGE_PIN E5 [get_ports debug_pins[2]]
set_property PACKAGE_PIN E6 [get_ports debug_pins[3]]
set_property PACKAGE_PIN K2 [get_ports debug_pins[4]]
set_property PACKAGE_PIN K1 [get_ports debug_pins[5]]
set_property PACKAGE_PIN J2 [get_ports debug_pins[6]]
set_property PACKAGE_PIN J3 [get_ports debug_pins[7]]
set_property IOSTANDARD LVCMOS25 [get_ports debug_pins[*]]

#======================================================================== 
# End-of-File
#======================================================================== 

