# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_clk_freq" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_mem_size" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_simple_in" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_simple_out" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_gpio" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_clk_freq { PARAM_VALUE.C_clk_freq } {
	# Procedure called to update C_clk_freq when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_clk_freq { PARAM_VALUE.C_clk_freq } {
	# Procedure called to validate C_clk_freq
	return true
}

proc update_PARAM_VALUE.C_gpio { PARAM_VALUE.C_gpio } {
	# Procedure called to update C_gpio when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_gpio { PARAM_VALUE.C_gpio } {
	# Procedure called to validate C_gpio
	return true
}

proc update_PARAM_VALUE.C_mem_size { PARAM_VALUE.C_mem_size } {
	# Procedure called to update C_mem_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_mem_size { PARAM_VALUE.C_mem_size } {
	# Procedure called to validate C_mem_size
	return true
}

proc update_PARAM_VALUE.C_simple_in { PARAM_VALUE.C_simple_in } {
	# Procedure called to update C_simple_in when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_simple_in { PARAM_VALUE.C_simple_in } {
	# Procedure called to validate C_simple_in
	return true
}

proc update_PARAM_VALUE.C_simple_out { PARAM_VALUE.C_simple_out } {
	# Procedure called to update C_simple_out when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_simple_out { PARAM_VALUE.C_simple_out } {
	# Procedure called to validate C_simple_out
	return true
}


proc update_MODELPARAM_VALUE.C_clk_freq { MODELPARAM_VALUE.C_clk_freq PARAM_VALUE.C_clk_freq } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_clk_freq}] ${MODELPARAM_VALUE.C_clk_freq}
}

proc update_MODELPARAM_VALUE.C_mem_size { MODELPARAM_VALUE.C_mem_size PARAM_VALUE.C_mem_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_mem_size}] ${MODELPARAM_VALUE.C_mem_size}
}

proc update_MODELPARAM_VALUE.C_simple_in { MODELPARAM_VALUE.C_simple_in PARAM_VALUE.C_simple_in } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_simple_in}] ${MODELPARAM_VALUE.C_simple_in}
}

proc update_MODELPARAM_VALUE.C_simple_out { MODELPARAM_VALUE.C_simple_out PARAM_VALUE.C_simple_out } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_simple_out}] ${MODELPARAM_VALUE.C_simple_out}
}

proc update_MODELPARAM_VALUE.C_gpio { MODELPARAM_VALUE.C_gpio PARAM_VALUE.C_gpio } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_gpio}] ${MODELPARAM_VALUE.C_gpio}
}

