## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# clk
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clk_ext]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_ext]

# button
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS25} [get_ports reset]

# cam_en
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS25} [get_ports cam_en]

# led
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports led1]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports led2]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports led3]

#temp1, temp2
set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS25} [get_ports temp1]
#set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS25} [get_ports temp2]

# CRUVI CA
# sda, scl
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS25} [get_ports pad_sda]
set_property -dict {PACKAGE_PIN E7 IOSTANDARD LVCMOS25} [get_ports pad_scl]

#clk_p, clk_n
set_property -dict {PACKAGE_PIN C6 IOSTANDARD LVDS_25} [get_ports {dphy_clk[1]}]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVDS_25} [get_ports {dphy_clk[0]}]

#data0_p, data0_n
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVDS_25} [get_ports {dphy_d0[1]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVDS_25} [get_ports {dphy_d0[0]}]

#data1_p, data1_n
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVDS_25} [get_ports {dphy_d1[1]}]
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVDS_25} [get_ports {dphy_d1[0]}]

# CRUVI CC
# sda, scl
#set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS25} [get_ports pad_sda]
#set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25} [get_ports pad_scl]

#clk_p, clk_n
#set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_clk[1]}]
#set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_clk[0]}]

#data0_p, data0_n
#set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_d0[1]}]
#set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_d0[0]}]

#data1_p, data1_n
#set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_d1[1]}]
#set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {dphy_d1[0]}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets link/clkphy_inst/bit_clock_int_bufg]

# set_property IODELAY_GROUP group_name [get_cells {idelayctrl_inst link/d1phy/idelayctrl_inst link/d0phy/idelayctrl_inst}]






connect_debug_port u_ila_0/probe0 [get_nets [list {link/deser_data_8[0]} {link/deser_data_8[1]} {link/deser_data_8[2]} {link/deser_data_8[3]} {link/deser_data_8[4]} {link/deser_data_8[5]} {link/deser_data_8[6]} {link/deser_data_8[7]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {byte_valid[0]} {byte_valid[1]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {link/deser_data_0[0]} {link/deser_data_0[1]} {link/deser_data_0[2]} {link/deser_data_0[3]} {link/deser_data_0[4]} {link/deser_data_0[5]} {link/deser_data_0[6]} {link/deser_data_0[7]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list link/byte_packet_done]]
connect_debug_port u_ila_0/probe7 [get_nets [list word_valid]]


connect_debug_port u_ila_0/probe0 [get_nets [list {link/deser_data_8[0]} {link/deser_data_8[1]} {link/deser_data_8[2]} {link/deser_data_8[3]} {link/deser_data_8[4]} {link/deser_data_8[5]} {link/deser_data_8[6]} {link/deser_data_8[7]}]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 32768 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list temp/led1_OBUF]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {link/ba0_inst/curr_byte[0]} {link/ba0_inst/curr_byte[1]} {link/ba0_inst/curr_byte[2]} {link/ba0_inst/curr_byte[3]} {link/ba0_inst/curr_byte[4]} {link/ba0_inst/curr_byte[5]} {link/ba0_inst/curr_byte[6]} {link/ba0_inst/curr_byte[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {link/deser_data_0[0]} {link/deser_data_0[1]} {link/deser_data_0[2]} {link/deser_data_0[3]} {link/deser_data_0[4]} {link/deser_data_0[5]} {link/deser_data_0[6]} {link/deser_data_0[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {link/ba1_inst/curr_byte[0]} {link/ba1_inst/curr_byte[1]} {link/ba1_inst/curr_byte[2]} {link/ba1_inst/curr_byte[3]} {link/ba1_inst/curr_byte[4]} {link/ba1_inst/curr_byte[5]} {link/ba1_inst/curr_byte[6]} {link/ba1_inst/curr_byte[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 2 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {byte_valid[0]} {byte_valid[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list led2_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list led3_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list temp1_OBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets led1_OBUF]
