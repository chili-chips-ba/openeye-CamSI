set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]

set_property -dict {PACKAGE_PIN R4 IOSTANDARD DIFF_SSTL15} [get_ports sys_clk_p]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports sys_rstn]


set_property -dict {PACKAGE_PIN V17  IOSTANDARD TMDS_33} [get_ports HDMI_D2_P]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD TMDS_33} [get_ports HDMI_D1_P]
set_property -dict {PACKAGE_PIN V18  IOSTANDARD TMDS_33} [get_ports HDMI_D0_P]
set_property -dict {PACKAGE_PIN Y18  IOSTANDARD TMDS_33} [get_ports HDMI_CLK_P]
