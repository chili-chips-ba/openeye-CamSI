set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]

create_clock -period 8.000 -name eth_rxc [get_ports net_rxc]

set_property -dict {PACKAGE_PIN R4 IOSTANDARD DIFF_SSTL135} [get_ports sys_clk_p]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]


set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33}  [get_ports   net1_rst_n]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports   eth1_mdc]
set_property -dict {PACKAGE_PIN N15  IOSTANDARD LVCMOS33} [get_ports   eth1_mdio]

set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports   net1_rxc]
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33} [get_ports  net1_rx_ctl]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {net1_rxd[0]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports {net1_rxd[1]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {net1_rxd[2]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports {net1_rxd[3]}]

set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports  net1_txc]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports  net1_tx_ctl]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports {net1_txd[0]}]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports {net1_txd[1]}]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {net1_txd[2]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {net1_txd[3]}]

set_property SLEW FAST [get_ports  net1_txc]
set_property SLEW FAST [get_ports  net1_tx_ctl]
set_property SLEW FAST [get_ports {net1_txd[*]}]


