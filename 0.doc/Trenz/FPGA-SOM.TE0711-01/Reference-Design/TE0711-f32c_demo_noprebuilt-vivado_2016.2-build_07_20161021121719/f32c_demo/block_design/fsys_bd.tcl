puts "Info:(TE) This block design file has been exported with Reference-Design Scripts from Trenz Electronic GmbH for Board Part:trenz.biz:te0711_100_2i:part0:1.0 with FPGA xc7a100tcsg324-2 at 2016-10-20T16:31:40."

################################################################
# This is a generated script based on design: fsys
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source fsys_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a100tcsg324-2
   set_property BOARD_PART trenz.biz:te0711_100_2i:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name fsys

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set LED0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 LED0 ]
  set UART0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART0 ]

  # Create ports
  set sys_clock [ create_bd_port -dir I -type clk sys_clock ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {100000000} \
CONFIG.PHASE {0.000} \
 ] $sys_clock

  # Create instance: CLK_100MHz, and set properties
  set CLK_100MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 CLK_100MHz ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {130.958} \
CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
CONFIG.CLKOUT2_JITTER {209.588} \
CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {10.000} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
CONFIG.CLK_IN2_BOARD_INTERFACE {Custom} \
CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
CONFIG.MMCM_CLKOUT1_DIVIDE {100} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {2} \
CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
CONFIG.RESET_BOARD_INTERFACE {Custom} \
CONFIG.USE_BOARD_FLOW {true} \
CONFIG.USE_RESET {false} \
 ] $CLK_100MHz

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT1_PHASE_ERROR.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKFBOUT_MULT_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_COMPENSATION.VALUE_SRC {DEFAULT} \
 ] $CLK_100MHz

  # Create instance: F32C, and set properties
  set F32C [ create_bd_cell -type ip -vlnv trenz.biz:user:F32C_bram:1.0 F32C ]
  set_property -dict [ list \
CONFIG.C_clk_freq {100} \
CONFIG.C_gpio {32} \
CONFIG.C_simple_in {32} \
CONFIG.C_simple_out {32} \
 ] $F32C

  # Create instance: UART_Monitor, and set properties
  set UART_Monitor [ create_bd_cell -type ip -vlnv trenz.biz:user:UART_MON:1.0 UART_Monitor ]

  # Create instance: ila_UART, and set properties
  set ila_UART [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.1 ila_UART ]
  set_property -dict [ list \
CONFIG.C_DATA_DEPTH {131072} \
CONFIG.C_ENABLE_ILA_AXI_MON {false} \
CONFIG.C_MONITOR_TYPE {Native} \
CONFIG.C_NUM_OF_PROBES {2} \
 ] $ila_UART

  # Create instance: simple_out_LED0, and set properties
  set simple_out_LED0 [ create_bd_cell -type ip -vlnv trenz.biz:user:vector_led:1.0 simple_out_LED0 ]

  # Create instance: vio_MISC, and set properties
  set vio_MISC [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_MISC ]
  set_property -dict [ list \
CONFIG.C_NUM_PROBE_IN {4} \
CONFIG.C_NUM_PROBE_OUT {0} \
 ] $vio_MISC

  # Create interface connections
  connect_bd_intf_net -intf_net F32C_UART0 [get_bd_intf_ports UART0] [get_bd_intf_pins F32C/UART0]
connect_bd_intf_net -intf_net [get_bd_intf_nets F32C_UART0] [get_bd_intf_ports UART0] [get_bd_intf_pins UART_Monitor/UART]
  connect_bd_intf_net -intf_net vector_led_0_LED0 [get_bd_intf_ports LED0] [get_bd_intf_pins simple_out_LED0/LED0]

  # Create port connections
  connect_bd_net -net UART_RXD [get_bd_pins UART_Monitor/mon_RXD] [get_bd_pins ila_UART/probe0] [get_bd_pins vio_MISC/probe_in0]
  connect_bd_net -net UART_TXD [get_bd_pins UART_Monitor/mon_TXD] [get_bd_pins ila_UART/probe1] [get_bd_pins vio_MISC/probe_in1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins CLK_100MHz/clk_out1] [get_bd_pins F32C/clk] [get_bd_pins vio_MISC/clk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins CLK_100MHz/clk_out2] [get_bd_pins ila_UART/clk]
  connect_bd_net -net locked [get_bd_pins CLK_100MHz/locked] [get_bd_pins vio_MISC/probe_in2]
  connect_bd_net -net simple_out [get_bd_pins F32C/simple_out] [get_bd_pins simple_out_LED0/vector_i] [get_bd_pins vio_MISC/probe_in3]
  connect_bd_net -net sys_clock_1 [get_bd_ports sys_clock] [get_bd_pins CLK_100MHz/clk_in1]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.12  2016-01-29 bk=1.3547 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port LED0 -pg 1 -y 40 -defaultsOSRD
preplace port sys_clock -pg 1 -y 280 -defaultsOSRD
preplace port UART0 -pg 1 -y 370 -defaultsOSRD
preplace inst UART_Monitor -pg 1 -lvl 3 -y 310 -defaultsOSRD
preplace inst vio_MISC -pg 1 -lvl 4 -y 160 -defaultsOSRD
preplace inst simple_out_LED0 -pg 1 -lvl 4 -y 40 -defaultsOSRD
preplace inst ila_UART -pg 1 -lvl 4 -y 300 -defaultsOSRD
preplace inst CLK_100MHz -pg 1 -lvl 1 -y 280 -defaultsOSRD
preplace inst F32C -pg 1 -lvl 2 -y 210 -defaultsOSRD
preplace netloc vector_led_0_LED0 1 4 1 NJ
preplace netloc F32C_UART0 1 2 3 410 370 NJ 370 NJ
preplace netloc locked 1 1 3 180 100 NJ 100 NJ
preplace netloc UART_TXD 1 3 1 650
preplace netloc sys_clock_1 1 0 1 N
preplace netloc clk_wiz_0_clk_out1 1 1 3 190 120 NJ 120 NJ
preplace netloc clk_wiz_0_clk_out2 1 1 3 190 300 NJ 250 NJ
preplace netloc simple_out 1 2 2 NJ 200 620
preplace netloc UART_RXD 1 3 1 630
levelinfo -pg 1 0 100 300 530 760 880 -top 0 -bot 390
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



