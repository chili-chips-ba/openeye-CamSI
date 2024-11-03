set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE Yes [current_design]

set_property -dict {PACKAGE_PIN R4 IOSTANDARD DIFF_SSTL15} [get_ports sys_clk_p]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]


set_property -dict {PACKAGE_PIN V17  IOSTANDARD TMDS_33} [get_ports HDMI_D2_P]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD TMDS_33} [get_ports HDMI_D1_P]
set_property -dict {PACKAGE_PIN V18  IOSTANDARD TMDS_33} [get_ports HDMI_D0_P]
set_property -dict {PACKAGE_PIN Y18  IOSTANDARD TMDS_33} [get_ports HDMI_CLK_P]


#-----------------------------------SD¿¨----------------------------------------
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports sd_clk]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports sd_cs]
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports sd_mosi]
set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS33} [get_ports sd_miso]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets u_clk_wiz_0/inst/clk_in1_clk_wiz_0] 
