# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "Component_Name" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_REFCLK_HZ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_CHANNELS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_NUM_BITS" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_MODE" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.C_CHANNELS { PARAM_VALUE.C_CHANNELS } {
	# Procedure called to update C_CHANNELS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_CHANNELS { PARAM_VALUE.C_CHANNELS } {
	# Procedure called to validate C_CHANNELS
	return true
}

proc update_PARAM_VALUE.C_MODE { PARAM_VALUE.C_MODE } {
	# Procedure called to update C_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_MODE { PARAM_VALUE.C_MODE } {
	# Procedure called to validate C_MODE
	return true
}

proc update_PARAM_VALUE.C_NUM_BITS { PARAM_VALUE.C_NUM_BITS } {
	# Procedure called to update C_NUM_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_NUM_BITS { PARAM_VALUE.C_NUM_BITS } {
	# Procedure called to validate C_NUM_BITS
	return true
}

proc update_PARAM_VALUE.C_REFCLK_HZ { PARAM_VALUE.C_REFCLK_HZ } {
	# Procedure called to update C_REFCLK_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_REFCLK_HZ { PARAM_VALUE.C_REFCLK_HZ } {
	# Procedure called to validate C_REFCLK_HZ
	return true
}


proc update_MODELPARAM_VALUE.C_CHANNELS { MODELPARAM_VALUE.C_CHANNELS PARAM_VALUE.C_CHANNELS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CHANNELS}] ${MODELPARAM_VALUE.C_CHANNELS}
}

proc update_MODELPARAM_VALUE.C_NUM_BITS { MODELPARAM_VALUE.C_NUM_BITS PARAM_VALUE.C_NUM_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_NUM_BITS}] ${MODELPARAM_VALUE.C_NUM_BITS}
}

proc update_MODELPARAM_VALUE.C_MODE { MODELPARAM_VALUE.C_MODE PARAM_VALUE.C_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_MODE}] ${MODELPARAM_VALUE.C_MODE}
}

proc update_MODELPARAM_VALUE.C_REFCLK_HZ { MODELPARAM_VALUE.C_REFCLK_HZ PARAM_VALUE.C_REFCLK_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_REFCLK_HZ}] ${MODELPARAM_VALUE.C_REFCLK_HZ}
}

