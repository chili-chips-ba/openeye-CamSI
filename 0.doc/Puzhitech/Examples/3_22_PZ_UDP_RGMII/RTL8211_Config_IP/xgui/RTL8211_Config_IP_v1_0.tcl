# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CLK_DIV" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "rx_delay_en" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "tx_delay_en" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.CLK_DIV { PARAM_VALUE.CLK_DIV } {
	# Procedure called to update CLK_DIV when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_DIV { PARAM_VALUE.CLK_DIV } {
	# Procedure called to validate CLK_DIV
	return true
}

proc update_PARAM_VALUE.rx_delay_en { PARAM_VALUE.rx_delay_en } {
	# Procedure called to update rx_delay_en when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.rx_delay_en { PARAM_VALUE.rx_delay_en } {
	# Procedure called to validate rx_delay_en
	return true
}

proc update_PARAM_VALUE.tx_delay_en { PARAM_VALUE.tx_delay_en } {
	# Procedure called to update tx_delay_en when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tx_delay_en { PARAM_VALUE.tx_delay_en } {
	# Procedure called to validate tx_delay_en
	return true
}


proc update_MODELPARAM_VALUE.CLK_DIV { MODELPARAM_VALUE.CLK_DIV PARAM_VALUE.CLK_DIV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLK_DIV}] ${MODELPARAM_VALUE.CLK_DIV}
}

proc update_MODELPARAM_VALUE.tx_delay_en { MODELPARAM_VALUE.tx_delay_en PARAM_VALUE.tx_delay_en } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tx_delay_en}] ${MODELPARAM_VALUE.tx_delay_en}
}

proc update_MODELPARAM_VALUE.rx_delay_en { MODELPARAM_VALUE.rx_delay_en PARAM_VALUE.rx_delay_en } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.rx_delay_en}] ${MODELPARAM_VALUE.rx_delay_en}
}

