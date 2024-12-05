#========================================================================
# openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
#  Constraints for Artix7-100, HDMI on CRUVI_CA, ETHERNET on CRUVI_B, CMOS on CRUVI_CC
#========================================================================

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
# HDMI - TEB0707 - CRUVI CA
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVDS_25} [get_ports hdmi_clk_p]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVDS_25} [get_ports hdmi_clk_n]

set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[0]}]
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[0]}]

set_property -dict {PACKAGE_PIN D8 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[1]}]
set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[1]}]

set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_p[2]}]
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVDS_25} [get_ports {hdmi_dat_n[2]}]

#-------------------------------------------------------------------------
# ETHERNET RGMII PHY - TEB0707 - CRUVI CB
set_property -dict {PACKAGE_PIN M1} [get_ports phy_rgmii_rx_clk]
set_property -dict {PACKAGE_PIN L1} [get_ports phy_rgmii_rx_ctl]
set_property -dict {PACKAGE_PIN R1} [get_ports phy_rgmii_int_n]

set_property -dict {PACKAGE_PIN U12} [get_ports {phy_rgmii_rxd[0]}]
set_property -dict {PACKAGE_PIN V12} [get_ports {phy_rgmii_rxd[1]}]
set_property -dict {PACKAGE_PIN P15} [get_ports {phy_rgmii_rxd[2]}]
set_property -dict {PACKAGE_PIN R15} [get_ports {phy_rgmii_rxd[3]}]

set_property -dict {PACKAGE_PIN V2  SLEW FAST DRIVE 16} [get_ports phy_rgmii_tx_clk]
set_property -dict {PACKAGE_PIN U2  SLEW FAST DRIVE 16} [get_ports phy_rgmii_tx_ctl]
set_property -dict {PACKAGE_PIN T1  DRIVE 12} [get_ports phy_rgmii_reset_n]

set_property -dict {PACKAGE_PIN T11 SLEW FAST DRIVE 16} [get_ports {phy_rgmii_txd[0]}]
set_property -dict {PACKAGE_PIN U11 SLEW FAST DRIVE 16} [get_ports {phy_rgmii_txd[1]}]
set_property -dict {PACKAGE_PIN T15 SLEW FAST DRIVE 16} [get_ports {phy_rgmii_txd[2]}]
set_property -dict {PACKAGE_PIN T14 SLEW FAST DRIVE 16} [get_ports {phy_rgmii_txd[3]}]

set_property PULLTYPE PULLUP [get_ports {phy_rgmii_*}]
set_property IOSTANDARD LVCMOS33 [get_ports phy_rgmii_*]

#set_property IOB TRUE [get_ports phy_rgmii_rx_clk]
set_property IOB TRUE [get_ports phy_rgmii_rx_ctl]
set_property IOB TRUE [get_ports {phy_rgmii_rxd[0]}]
set_property IOB TRUE [get_ports {phy_rgmii_rxd[1]}]
set_property IOB TRUE [get_ports {phy_rgmii_rxd[2]}]
set_property IOB TRUE [get_ports {phy_rgmii_rxd[3]}]

set_false_path -to [get_ports phy_rgmii_reset_n]
set_output_delay 0.000 [get_ports phy_rgmii_reset_n]
set_false_path -from [get_ports phy_rgmii_int_n]
set_input_delay 0.000 [get_ports phy_rgmii_int_n]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets phy_rgmii_rx_clk_IBUF]

# IDELAY on RGMII from PHY chip
#set_property IDELAY_VALUE 0 [get_cells {phy_rx_ctl_idelay phy_rxd_idelay_*}]

set_property -dict {PACKAGE_PIN U1 } [get_ports phy_mdio_io]
set_property -dict {PACKAGE_PIN V1 } [get_ports phy_mdio_mdc]
set_property SLEW FAST [get_ports {phy_mdio_*}]
set_property IOSTANDARD LVCMOS33 [get_ports phy_mdio_*]

set_false_path -to [get_ports {phy_mdio_io phy_mdio_mdc}]
set_output_delay 0.000 [get_ports {phy_mdio_io phy_mdio_mdc}]
set_false_path -from [get_ports phy_mdio_io]
set_input_delay 0.000 [get_ports phy_mdio_io]

set_property -dict {PACKAGE_PIN N14 } [get_ports phy_clk_in]
set_property IOSTANDARD LVCMOS33 [get_ports phy_clk_in]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets phy_clk_in_IBUF]

#-------------------------------------------------------------------------
# CSI - TEB0707 - CRUVI CC
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVDS_25} [get_ports {cam_dphy_clk[1]}]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVDS_25} [get_ports {cam_dphy_clk[0]}]

set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[0][1]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[0][0]}]

set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[1][1]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[1][0]}]

#-------------------------------------------------------------------------
# LED
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports {led[2]}]

#-------------------------------------------------------------------------
# DEBUG pins on CRUVI CA
#set_property PACKAGE_PIN D8 [get_ports debug_pins[0]] used by hdmi_dat_p[1]
#set_property PACKAGE_PIN C7 [get_ports debug_pins[1]] used by hdmi_dat_n[1]
#set_property PACKAGE_PIN H1 [get_ports debug_pins[2]] used by hdmi_dat_p[2]
#set_property PACKAGE_PIN G1 [get_ports debug_pins[3]] used by hdmi_dat_n[2]
set_property PACKAGE_PIN F1 [get_ports debug_pins[4]]
set_property PACKAGE_PIN E1 [get_ports debug_pins[5]]
set_property PACKAGE_PIN D7 [get_ports debug_pins[6]]
set_property PACKAGE_PIN E7 [get_ports debug_pins[7]]

# DEBUG pins on CRUVI CC
set_property PACKAGE_PIN A14 [get_ports {debug_pins[0]}]
set_property PACKAGE_PIN A13 [get_ports {debug_pins[1]}]
set_property PACKAGE_PIN B11 [get_ports {debug_pins[2]}]
set_property PACKAGE_PIN A11 [get_ports {debug_pins[3]}]
#set_property PACKAGE_PIN D15 [get_ports {debug_pins[4]}]
#set_property PACKAGE_PIN C15 [get_ports {debug_pins[5]}]
#set_property PACKAGE_PIN A15 [get_ports {debug_pins[6]}]
#set_property PACKAGE_PIN A16 [get_ports {debug_pins[7]}]

set_property IOSTANDARD LVCMOS25 [get_ports {debug_pins[*]}]


#========================================================================
# End-of-File
#========================================================================

