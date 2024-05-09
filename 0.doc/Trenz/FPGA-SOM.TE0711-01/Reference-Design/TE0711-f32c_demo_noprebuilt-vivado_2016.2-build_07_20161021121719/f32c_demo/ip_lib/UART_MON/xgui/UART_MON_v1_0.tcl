# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"


}

proc update_PARAM_VALUE.C_INCLUDE_DEBUG { PARAM_VALUE.C_INCLUDE_DEBUG } {
	# Procedure called to update C_INCLUDE_DEBUG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_INCLUDE_DEBUG { PARAM_VALUE.C_INCLUDE_DEBUG } {
	# Procedure called to validate C_INCLUDE_DEBUG
	return true
}


proc update_MODELPARAM_VALUE.C_INCLUDE_DEBUG { MODELPARAM_VALUE.C_INCLUDE_DEBUG PARAM_VALUE.C_INCLUDE_DEBUG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_INCLUDE_DEBUG}] ${MODELPARAM_VALUE.C_INCLUDE_DEBUG}
}

