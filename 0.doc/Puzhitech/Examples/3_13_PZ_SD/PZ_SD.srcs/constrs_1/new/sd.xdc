set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]

set_property -dict {PACKAGE_PIN R4 IOSTANDARD DIFF_SSTL15} [get_ports sys_clk_p]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports sys_rstn]

set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports sd_dclk]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports sd_ncs]
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports sd_mosi]
set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS33} [get_ports sd_miso]

set_property -dict {PACKAGE_PIN W22  IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN Y22  IOSTANDARD LVCMOS33} [get_ports {led[1]}]

set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports key]
