#========================================================================
# openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
#  Constraints for Artix7-100 (SOM - TE0710-03)
#
# Usage Note:
# - When using HDMI on CRUVI_CC, assign the following pins on HDMI and DEBUG pins:
#   - HDMI clock pins: G16, H16
#   - HDMI data pins: B11, A11, A13, A14, B13, B14
#   - DEBUG pins: D13, D12, D14, C14, D15, C15, A15, A16, G17, H17, F16, F15, H15, J14, B16, B17
#
# - When using the CRUVI_CC for debug purposes, assign the following pins on HDMI and DEBUG pins:
#   - HDMI clock pins: G17, H17
#   - HDMI data pins: D14, C14, D12, D13, B13, B14
#   - DEBUG pins: A14, A13, B11, A11, D15, C15, A15, A16, G16, H16, F16, F15, H15, J14, B16, B17
#========================================================================

#-------------------------------------------------------------------------
# clk and reset
set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports clk_ext]
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS25} [get_ports areset]

#-------------------------------------------------------------------------
## CAM EN 4 LANE - CRUVI_CA
#set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVCMOS25} [get_ports cam_en]

##-------------------------------------------------------------------------
## I2C 4 LANE - CRUVI_CA
#set_property -dict {PACKAGE_PIN N6 IOSTANDARD LVCMOS25} [get_ports i2c_sda]
#set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS25} [get_ports i2c_scl]

##-------------------------------------------------------------------------
## CSI 4 LANE - CRUVI_CA
#set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVDS_25} [get_ports {cam_dphy_clk[1]}]
#set_property -dict {PACKAGE_PIN P5 IOSTANDARD LVDS_25} [get_ports {cam_dphy_clk[0]}]

#set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[0][1]}]
#set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[0][0]}]

#set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[1][1]}]
#set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[1][0]}]

#set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[2][1]}]
#set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[2][0]}]

#set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[3][1]}]
#set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[3][0]}]

#-------------------------------------------------------------------------
#CAM EN 2 LANE - CRUVI_CA
set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVCMOS25} [get_ports cam_en]   

-------------------------------------------------------------------------
#If the OV2740 sensor is used, because the I2C communication lines SDA and SCL are swapped on the board
#I2C 2 LANE - CRUVI_CA
set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS25} [get_ports i2c_sda]
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS25} [get_ports i2c_scl]

#-------------------------------------------------------------------------
##I2C 2 LANE - CRUVI_CA
#set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS25} [get_ports i2c_sda]
#set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS25} [get_ports i2c_scl]

-------------------------------------------------------------------------
#CSI 2 LANE - CRUVI_CA

set_property -dict {PACKAGE_PIN L6 IOSTANDARD LVDS_25} [get_ports {cam_dphy_clk[1]}]
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVDS_25} [get_ports {cam_dphy_clk[0]}]

set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[0][1]}]
set_property -dict {PACKAGE_PIN V6 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[0][0]}]

set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[1][1]}]
set_property -dict {PACKAGE_PIN N6 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[1][0]}]


#HDMIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
#-------------------------------------------------------------------------
# HDMI - CRUVI_CC
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVDS_25} [get_ports hdmi_clk_n]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVDS_25} [get_ports hdmi_clk_p]

set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[0]}]
set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[0]}]

set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[1]}]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[1]}]

set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[2]}]
set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[2]}]

#-------------------------------------------------------------------------
# DEBUG pins - CRUVI_CC
set_property PACKAGE_PIN D13 [get_ports {debug_pins[0]}]
set_property PACKAGE_PIN D12 [get_ports {debug_pins[1]}]
set_property PACKAGE_PIN D14 [get_ports {debug_pins[2]}]
set_property PACKAGE_PIN C14 [get_ports {debug_pins[3]}]
set_property PACKAGE_PIN D15 [get_ports {debug_pins[4]}]
set_property PACKAGE_PIN C15 [get_ports {debug_pins[5]}]
set_property PACKAGE_PIN A15 [get_ports {debug_pins[6]}]
set_property PACKAGE_PIN A16 [get_ports {debug_pins[7]}]
set_property PACKAGE_PIN G17 [get_ports {debug_pins[8]}]
set_property PACKAGE_PIN H17 [get_ports {debug_pins[9]}]
set_property PACKAGE_PIN F16 [get_ports {debug_pins[10]}]
set_property PACKAGE_PIN F15 [get_ports {debug_pins[11]}]
set_property PACKAGE_PIN H15 [get_ports {debug_pins[12]}]
set_property PACKAGE_PIN J14 [get_ports {debug_pins[13]}]
set_property PACKAGE_PIN B16 [get_ports {debug_pins[14]}]
set_property PACKAGE_PIN B17 [get_ports {debug_pins[15]}]
set_property IOSTANDARD LVCMOS25 [get_ports {debug_pins[*]}]

###DEBUGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
###-------------------------------------------------------------------------
## HDMI - CRUVI_CC
#set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVDS_25} [get_ports hdmi_clk_n]
#set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVDS_25} [get_ports hdmi_clk_p]

#set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[0]}]
#set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[0]}]

#set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[1]}]
#set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[1]}]

#set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[2]}]
#set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[2]}]

##-------------------------------------------------------------------------
## DEBUG pins - CRUVI_CC
#set_property PACKAGE_PIN A14 [get_ports {debug_pins[0]}]
#set_property PACKAGE_PIN A13 [get_ports {debug_pins[1]}]
#set_property PACKAGE_PIN B11 [get_ports {debug_pins[2]}]
#set_property PACKAGE_PIN A11 [get_ports {debug_pins[3]}]
#set_property PACKAGE_PIN D15 [get_ports {debug_pins[4]}]
#set_property PACKAGE_PIN C15 [get_ports {debug_pins[5]}]
#set_property PACKAGE_PIN A15 [get_ports {debug_pins[6]}]
#set_property PACKAGE_PIN A16 [get_ports {debug_pins[7]}]
#set_property PACKAGE_PIN G16 [get_ports {debug_pins[8]}]
#set_property PACKAGE_PIN H16 [get_ports {debug_pins[9]}]
#set_property PACKAGE_PIN F16 [get_ports {debug_pins[10]}]
#set_property PACKAGE_PIN F15 [get_ports {debug_pins[11]}]
#set_property PACKAGE_PIN H15 [get_ports {debug_pins[12]}]
#set_property PACKAGE_PIN J14 [get_ports {debug_pins[13]}]
#set_property PACKAGE_PIN B16 [get_ports {debug_pins[14]}]
#set_property PACKAGE_PIN B17 [get_ports {debug_pins[15]}]
#set_property IOSTANDARD LVCMOS25 [get_ports {debug_pins[*]}]


#-------------------------------------------------------------------------
# LED - 2xCarrier + 1xSOM
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS25} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS25} [get_ports {led[2]}]

#========================================================================
# End-of-File
#========================================================================