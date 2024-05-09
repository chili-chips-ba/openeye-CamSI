# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_arch" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_clk_freq" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_arch { PARAM_VALUE.C_arch } {
	# Procedure called to update C_arch when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_arch { PARAM_VALUE.C_arch } {
	# Procedure called to validate C_arch
	return true
}

proc update_PARAM_VALUE.C_clk_freq { PARAM_VALUE.C_clk_freq } {
	# Procedure called to update C_clk_freq when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_clk_freq { PARAM_VALUE.C_clk_freq } {
	# Procedure called to validate C_clk_freq
	return true
}

proc update_PARAM_VALUE.C_mem_size { PARAM_VALUE.C_mem_size } {
	# Procedure called to update C_mem_size when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_mem_size { PARAM_VALUE.C_mem_size } {
	# Procedure called to validate C_mem_size
	return true
}


proc update_MODELPARAM_VALUE.C_arch { MODELPARAM_VALUE.C_arch PARAM_VALUE.C_arch } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_arch}] ${MODELPARAM_VALUE.C_arch}
}

proc update_MODELPARAM_VALUE.C_clk_freq { MODELPARAM_VALUE.C_clk_freq PARAM_VALUE.C_clk_freq } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_clk_freq}] ${MODELPARAM_VALUE.C_clk_freq}
}

proc update_MODELPARAM_VALUE.C_mem_size { MODELPARAM_VALUE.C_mem_size PARAM_VALUE.C_mem_size } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_mem_size}] ${MODELPARAM_VALUE.C_mem_size}
}

