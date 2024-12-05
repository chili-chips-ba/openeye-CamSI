#========================================================================
# openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
#  Constraints for Artix7-35, Puzhi board
#========================================================================

#-------------------------------------------------------------------------
# clk, reset and misc
set_property -dict {PACKAGE_PIN R4 IOSTANDARD DIFF_SSTL135} [get_ports sys_clk_p]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]

#set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports cam_en]

set_property PACKAGE_PIN D19 [get_ports cam_en]
set_property IOSTANDARD LVCMOS25 [get_ports cam_en]
#-------------------------------------------------------------------------
# I2C
#set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports i2c_scl]
#set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports i2c_sda]
set_property PACKAGE_PIN A20 [get_ports i2c_scl]
set_property IOSTANDARD LVCMOS25 [get_ports i2c_scl]
set_property PACKAGE_PIN B20 [get_ports i2c_sda]
set_property IOSTANDARD LVCMOS25 [get_ports i2c_sda]
#-------------------------------------------------------------------------
# CSI
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVDS_25} [get_ports {cam_dphy_clk[1]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25} [get_ports {cam_dphy_clk[0]}]

set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[0][1]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[0][0]}]

set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[1][1]}]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVDS_25} [get_ports {cam_dphy_dat[1][0]}]

#-------------------------------------------------------------------------
# HDMI
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD TMDS_33} [get_ports hdmi_clk_p]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD TMDS_33} [get_ports hdmi_clk_n]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD TMDS_33} [get_ports {hdmi_dat_p[0]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD TMDS_33} [get_ports {hdmi_dat_n[0]}]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD TMDS_33} [get_ports {hdmi_dat_p[1]}]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD TMDS_33} [get_ports {hdmi_dat_n[1]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD TMDS_33} [get_ports {hdmi_dat_p[2]}]
set_property -dict {PACKAGE_PIN W17 IOSTANDARD TMDS_33} [get_ports {hdmi_dat_n[2]}]

#-------------------------------------------------------------------------
# ETHERNET RGMII PHY
set_property -dict {PACKAGE_PIN W19} [get_ports phy_rgmii_rx_clk]
set_property -dict {PACKAGE_PIN W20} [get_ports phy_rgmii_rx_ctl]
set_property -dict {PACKAGE_PIN U18} [get_ports {phy_rgmii_rxd[0]}]
set_property -dict {PACKAGE_PIN R19} [get_ports {phy_rgmii_rxd[1]}]
set_property -dict {PACKAGE_PIN R18} [get_ports {phy_rgmii_rxd[2]}]
set_property -dict {PACKAGE_PIN P20} [get_ports {phy_rgmii_rxd[3]}]

set_property -dict {PACKAGE_PIN T20 DRIVE 12} [get_ports phy_rgmii_reset_n]
set_property -dict {PACKAGE_PIN P17 SLEW FAST DRIVE 16} [get_ports phy_rgmii_tx_clk]
set_property -dict {PACKAGE_PIN R16 SLEW FAST DRIVE 16} [get_ports phy_rgmii_tx_ctl]
set_property -dict {PACKAGE_PIN P19 SLEW FAST DRIVE 16} [get_ports {phy_rgmii_txd[0]}]
set_property -dict {PACKAGE_PIN P16 SLEW FAST DRIVE 16} [get_ports {phy_rgmii_txd[1]}]
set_property -dict {PACKAGE_PIN N17 SLEW FAST DRIVE 16} [get_ports {phy_rgmii_txd[2]}]
set_property -dict {PACKAGE_PIN R17 SLEW FAST DRIVE 16} [get_ports {phy_rgmii_txd[3]}]

set_property PULLTYPE PULLUP [get_ports {phy_rgmii_rxd[3]}]
set_property PULLTYPE PULLUP [get_ports {phy_rgmii_rxd[2]}]
set_property PULLTYPE PULLUP [get_ports {phy_rgmii_rxd[1]}]
set_property PULLTYPE PULLUP [get_ports {phy_rgmii_rxd[0]}]
set_property PULLTYPE PULLUP [get_ports {phy_rgmii_txd[3]}]
set_property PULLTYPE PULLUP [get_ports {phy_rgmii_txd[2]}]
set_property PULLTYPE PULLUP [get_ports {phy_rgmii_txd[1]}]
set_property PULLTYPE PULLUP [get_ports {phy_rgmii_txd[0]}]
set_property PULLTYPE PULLUP [get_ports phy_rgmii_reset_n]
set_property PULLTYPE PULLUP [get_ports phy_rgmii_rx_clk]
set_property PULLTYPE PULLUP [get_ports phy_rgmii_rx_ctl]
set_property PULLTYPE PULLUP [get_ports phy_rgmii_tx_clk]
set_property PULLTYPE PULLUP [get_ports phy_rgmii_tx_ctl]
set_property IOSTANDARD LVCMOS33 [get_ports phy_rgmii_*]

#set_property IOB TRUE [get_ports phy_rgmii_rx_clk]
#set_property IOB TRUE [get_ports phy_rgmii_rx_ctl]
#set_property IOB TRUE [get_ports {phy_rgmii_rxd[0]}]
#set_property IOB TRUE [get_ports {phy_rgmii_rxd[1]}]
#set_property IOB TRUE [get_ports {phy_rgmii_rxd[2]}]
#set_property IOB TRUE [get_ports {phy_rgmii_rxd[3]}]

set_false_path -to [get_ports phy_rgmii_reset_n]
set_output_delay 0.000 [get_ports phy_rgmii_reset_n]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets phy_rgmii_rx_clk_IBUF]

# IDELAY on RGMII from PHY chip
#set_property IDELAY_VALUE 0 [get_cells {phy_rx_ctl_idelay phy_rxd_idelay_*}]

set_property -dict {PACKAGE_PIN N15} [get_ports phy_mdio_io]
set_property -dict {PACKAGE_PIN T18} [get_ports phy_mdio_mdc]
set_property SLEW FAST [get_ports phy_mdio_*]
set_property IOSTANDARD LVCMOS33 [get_ports phy_mdio_*]

set_false_path -to [get_ports {phy_mdio_io phy_mdio_mdc}]
set_output_delay 0.000 [get_ports {phy_mdio_io phy_mdio_mdc}]
set_false_path -from [get_ports phy_mdio_io]
set_input_delay 0.000 [get_ports phy_mdio_io]

#-------------------------------------------------------------------------
# LED
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN Y22 IOSTANDARD LVCMOS33} [get_ports {led[1]}]

#-------------------------------------------------------------------------
# DEBUG pins
set_property PACKAGE_PIN H22 [get_ports {debug_pins[0]}]
set_property PACKAGE_PIN J22 [get_ports {debug_pins[1]}]
set_property PACKAGE_PIN K22 [get_ports {debug_pins[2]}]
set_property PACKAGE_PIN K21 [get_ports {debug_pins[3]}]
set_property PACKAGE_PIN G20 [get_ports {debug_pins[4]}]
set_property PACKAGE_PIN H20 [get_ports {debug_pins[5]}]
set_property PACKAGE_PIN L21 [get_ports {debug_pins[6]}]
set_property PACKAGE_PIN M21 [get_ports {debug_pins[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {debug_pins[*]}]


#========================================================================
# End-of-File
#========================================================================