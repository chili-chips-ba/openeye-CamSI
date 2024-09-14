#SI5338
set_property PACKAGE_PIN E5 [get_ports {SI5338_CLK0_D_clk_p[0]}]
set_property IOSTANDARD LVDS [get_ports {SI5338_CLK0_D_clk_p[0]}]
set_property PACKAGE_PIN C3 [get_ports {SI5338_CLK3_D_clk_p[0]}]
set_property IOSTANDARD LVDS [get_ports {SI5338_CLK3_D_clk_p[0]}]


#CPLD
set_property PACKAGE_PIN B1 [get_ports {x0[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {x0[0]}]
set_property PACKAGE_PIN C1 [get_ports {x1[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {x1[0]}]


#Ethernet
#IO Placement
set_property PACKAGE_PIN R7 [get_ports {emio_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {emio_tri_io[0]}]

set_property PACKAGE_PIN T7 [get_ports {CR00200_Phy_INTn}]
set_property IOSTANDARD LVCMOS18 [get_ports {CR00200_Phy_INTn}]

set_property PACKAGE_PIN L3 [get_ports {CR00200_Phy_CLK125}]
set_property IOSTANDARD LVCMOS18 [get_ports {CR00200_Phy_CLK125}]

#CR00200 --> TEB0707 J11 --> TE0821
set_property PACKAGE_PIN N9 [get_ports {ETH2_RGMII_txc}]
set_property PACKAGE_PIN N8 [get_ports {ETH2_RGMII_tx_ctl}]
set_property PACKAGE_PIN M8 [get_ports {ETH2_RGMII_td[0]}]
set_property PACKAGE_PIN L8 [get_ports {ETH2_RGMII_td[1]}]
set_property PACKAGE_PIN K7 [get_ports {ETH2_RGMII_td[2]}]
set_property PACKAGE_PIN K8 [get_ports {ETH2_RGMII_td[3]}]
set_property PACKAGE_PIN K4 [get_ports {ETH2_RGMII_rxc}]
set_property PACKAGE_PIN K3 [get_ports {ETH2_RGMII_rx_ctl}]
set_property PACKAGE_PIN M6 [get_ports {ETH2_RGMII_rd[0]}]
set_property PACKAGE_PIN L5 [get_ports {ETH2_RGMII_rd[1]}]
set_property PACKAGE_PIN P7 [get_ports {ETH2_RGMII_rd[2]}]
set_property PACKAGE_PIN P6 [get_ports {ETH2_RGMII_rd[3]}]

set_property PACKAGE_PIN Y8 [get_ports {ETH_MDIO_mdc}]
set_property PACKAGE_PIN W8 [get_ports {ETH_MDIO_mdio_io}]

set_property IOSTANDARD LVCMOS18 [get_ports {ETH2_RGMII_*}]
set_property IOSTANDARD LVCMOS18 [get_ports {ETH_MDIO_*}]

set_property PULLTYPE PULLUP [get_ports {ETH2_RGMII_*}]
set_property PULLTYPE PULLUP [get_ports {ETH_MDIO_*}]

#set_property slew FAST [get_ports {ETH2_RGMII_*}]
#set_property slew FAST [get_ports {ETH_MDIO_*}]


# Clock Period Constraints
create_clock -period 8.000 -name ETH2_RGMII_rxc -add [get_ports ETH2_RGMII_rxc]

## Use these constraints to modify output delay on RGMII signals if 2ns delay is added by external PHY
#set_output_delay -clock [get_clocks ETH2_RGMII_txc] -max -1.0 [get_ports {ETH2_RGMII_td[*] ETH2_RGMII_txc}]
#set_output_delay -clock [get_clocks ETH2_RGMII_txc] -min -2.6 [get_ports {ETH2_RGMII_td[*] ETH2_RGMII_txc}] -add_delay
#set_output_delay -clock [get_clocks ETH2_RGMII_txc] -clock_fall -max -1.0 [get_ports {ETH2_RGMII_td[*] ETH2_RGMII_txc}] 
#set_output_delay -clock [get_clocks ETH2_RGMII_txc] -clock_fall -min -2.6 [get_ports {ETH2_RGMII_td[*] ETH2_RGMII_txc}]

#clock setting
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports ETH2_RGMII_td[1]]
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports ETH_MDIO_mdio_io]


##clock setting
##set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets zusys_i/gmii_to_rgmii_0/U0/i_gmii_to_rgmii_block/rgmii_rxc_ibuf_i/O]
#set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports ETH2_RGMII_td[1]]


##False path constraints to async inputs coming directly to synchronizer
#set_false_path -to [get_pins -hier -filter {name =~ *idelayctrl_reset_gen/*reset_sync*/PRE }]
#set_false_path -to [get_pins -of [get_cells -hier -filter { name =~ *i_MANAGEMENT/SYNC_*/data_sync* }] -filter { name =~ *D }]
#set_false_path -to [get_pins -hier -filter {name =~ *reset_sync*/PRE }]

##False path constraints from Control Register outputs 
#set_false_path -from [get_pins -hier -filter {name =~ *i_MANAGEMENT/DUPLEX_MODE_REG*/C }]
#set_false_path -from [get_pins -hier -filter {name =~ *i_MANAGEMENT/SPEED_SELECTION_REG*/C }]

## constraint valid if parameter C_EXTERNAL_CLOCK = 0
#set_case_analysis 0 [get_pins -hier -filter {name =~ *i_bufgmux_gmii_clk/CE0}]
#set_case_analysis 0 [get_pins -hier -filter {name =~ *i_bufgmux_gmii_clk/S0}]
#set_case_analysis 1 [get_pins -hier -filter {name =~ *i_bufgmux_gmii_clk/CE1}]
#set_case_analysis 1 [get_pins -hier -filter {name =~ *i_bufgmux_gmii_clk/S1}]

## constraint valid if parameter C_EXTERNAL_CLOCK = 0 and clock skew on TXC is through MMCM
#set_case_analysis 0 [get_pins -hier -filter {name =~ *i_bufgmux_gmii_90_clk/CE0}]
#set_case_analysis 0 [get_pins -hier -filter {name =~ *i_bufgmux_gmii_90_clk/S0}]
#set_case_analysis 1 [get_pins -hier -filter {name =~ *i_bufgmux_gmii_90_clk/CE1}]
#set_case_analysis 1 [get_pins -hier -filter {name =~ *i_bufgmux_gmii_90_clk/S1}]

##These constraints are for non-Versal devices
##To Adjust GMII Rx Input Setup/Hold Timing
#set_property IDELAY_VALUE 16 [get_cells *delay_rgmii_rx_ctl]
#set_property IDELAY_VALUE 16 [get_cells -hier -filter {name =~ *delay_rgmii_rxd*}]
#set_property IODELAY_GROUP gpr1 [get_cells *delay_rgmii_rx_ctl]
#set_property IODELAY_GROUP gpr1 [get_cells -hier -filter {name =~ *delay_rgmii_rxd*}]
#set_property IODELAY_GROUP gpr1 [get_cells *idelayctrl]

#set_property slew FAST [get_ports [list {ETH2_RGMII_td[3]} {ETH2_RGMII_td[2]} {ETH2_RGMII_td[1]} {ETH2_RGMII_td[0]} ETH2_RGMII_txc ETH2_RGMII_tx_ctl]]

#clock setting
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets zusys_i/gmii_to_rgmii_0/U0/i_gmii_to_rgmii_block/rgmii_rxc_ibuf_i/O]