catch {TE::UTILS::te_msg TE_BD-0 INFO "This block design tcl-file was generate with Trenz Electronic GmbH Board Part:trenz.biz:te0821_3eg_1e:part0:2.0, FPGA: xczu3eg-sfvc784-1-e at 2022-12-02T12:39:39."}
catch {TE::UTILS::te_msg TE_BD-1 INFO "This block design tcl-file was modified by TE-Scripts. Modifications are labelled with comment tag  # #TE_MOD# on the Block-Design tcl-file."}

if { ![info exist TE::VERSION_CONTROL] } {
  namespace eval ::TE  {
    set ::TE::VERSION_CONTROL true
  }
}
################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2021.2
set current_vivado_version [version -short ]
if { [string first $scripts_vivado_version $current_vivado_version] == -1 &&  $TE::VERSION_CONTROL } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado < $scripts_vivado_version> and is being run in < $current_vivado_version> of Vivado. Please run the script in Vivado < $scripts_vivado_version> then open the design in Vivado < $current_vivado_version>. Upgrade the design by running "Tools => Report => Report IP Status...", then run write_bd_tcl to create an updated script."}
 return 1
}

################################################################
# This is a generated script based on design: zusys
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
set scripts_vivado_version 2021.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_gid_msg -ssname BD::TCL -id 2040 -severity "WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been major IP version changes between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the parameter settings of the IPs."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source zusys_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu3eg-sfvc784-1-e
   set_property BOARD_PART trenz.biz:te0821_3eg_1e:part0:2.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name zusys

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
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

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

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
trenz.biz:user:axi_reg32:*\
xilinx.com:ip:gmii_to_rgmii:*\
xilinx.com:ip:jtag_axi:*\
trenz.biz:user:labtools_fmeter:*\
xilinx.com:ip:proc_sys_reset:*\
xilinx.com:ip:util_ds_buf:*\
xilinx.com:ip:vio:*\
xilinx.com:ip:xlconcat:*\
xilinx.com:ip:zynq_ultra_ps_e:*\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set ETH2_RGMII [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 ETH2_RGMII ]

  set ETH_MDIO [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 ETH_MDIO ]

  set SI5338_CLK0_D [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 SI5338_CLK0_D ]

  set SI5338_CLK3_D [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 SI5338_CLK3_D ]

  set emio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 emio ]


  # Create ports
  set CR00200_Phy_CLK125 [ create_bd_port -dir I -type clk -freq_hz 125000000 CR00200_Phy_CLK125 ]
  set CR00200_Phy_INTn [ create_bd_port -dir I -type intr CR00200_Phy_INTn ]
  set x0 [ create_bd_port -dir O -from 0 -to 0 x0 ]
  set x1 [ create_bd_port -dir O -from 0 -to 0 x1 ]

  # Create instance: axi_reg32_0, and set properties
  set axi_reg32_0 [ create_bd_cell -type ip -vlnv trenz.biz:user:axi_reg32 axi_reg32_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_RO_REG {3} \
   CONFIG.C_NUM_WR_REG {0} \
 ] $axi_reg32_0

  # Create instance: gmii_to_rgmii_0, and set properties
  set gmii_to_rgmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gmii_to_rgmii gmii_to_rgmii_0 ]
  set_property -dict [ list \
   CONFIG.C_PHYADDR {4} \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Core} \
 ] $gmii_to_rgmii_0

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi jtag_axi_0 ]

  # Create instance: labtools_fmeter_0, and set properties
  set labtools_fmeter_0 [ create_bd_cell -type ip -vlnv trenz.biz:user:labtools_fmeter labtools_fmeter_0 ]
  set_property -dict [ list \
   CONFIG.C_CHANNELS {3} \
 ] $labtools_fmeter_0

  # Create instance: ps8_0_axi_periph, and set properties
  set ps8_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect ps8_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $ps8_0_axi_periph

  # Create instance: rst_ps8_0_100M, and set properties
  set rst_ps8_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_ps8_0_100M ]

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf util_ds_buf_0 ]

  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf util_ds_buf_1 ]

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio vio_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_IN {9} \
   CONFIG.C_NUM_PROBE_OUT {2} \
   CONFIG.C_PROBE_OUT1_INIT_VAL {0x1} \
   CONFIG.C_PROBE_OUT2_INIT_VAL {0x1} \
 ] $vio_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0 ]
# #TE_MOD#_Add next line#
  apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  [get_bd_cells zynq_ultra_ps_e_0]
# #TE_MOD#_Add next line#
  set tcl_pr_ext [];if { [catch {set tcl_pr_ext [glob -join -dir ${TE::BOARDDEF_PATH}/preset_extension/ *_preset.tcl]}] } {};foreach preset_ext $tcl_pr_ext { source  $preset_ext};
# #TE_MOD#   set_property -dict [ list \
# #TE_MOD#  ] $zynq_ultra_ps_e_0

# #TE_MOD#    CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
# #TE_MOD#    CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS33} \
# #TE_MOD#    CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
# #TE_MOD#    CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS18} \
# #TE_MOD#    CONFIG.PSU_DDR_RAM_HIGHADDR {0x7FFFFFFF} \
# #TE_MOD#    CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x00000002} \
# #TE_MOD#    CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
# #TE_MOD#    CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {0} \
# #TE_MOD#    CONFIG.PSU_MIO_0_DIRECTION {out} \
# #TE_MOD#    CONFIG.PSU_MIO_0_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_0_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_10_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_10_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_11_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_11_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_12_DIRECTION {out} \
# #TE_MOD#    CONFIG.PSU_MIO_12_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_12_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_13_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_13_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_14_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_14_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_15_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_15_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_16_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_16_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_17_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_17_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_18_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_18_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_19_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_19_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_1_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_1_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_20_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_20_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_21_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_21_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_22_DIRECTION {out} \
# #TE_MOD#    CONFIG.PSU_MIO_22_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_22_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_23_DIRECTION {out} \
# #TE_MOD#    CONFIG.PSU_MIO_23_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_23_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_24_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_24_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_25_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_2_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_2_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_30_DIRECTION {in} \
# #TE_MOD#    CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
# #TE_MOD#    CONFIG.PSU_MIO_30_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_30_SLEW {fast} \
# #TE_MOD#    CONFIG.PSU_MIO_31_DIRECTION {out} \
# #TE_MOD#    CONFIG.PSU_MIO_31_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_31_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_38_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_38_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_39_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_39_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_3_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_3_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_46_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_46_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_46_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_46_PULLUPDOWN {disable} \
# #TE_MOD#    CONFIG.PSU_MIO_47_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_47_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_47_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_47_PULLUPDOWN {disable} \
# #TE_MOD#    CONFIG.PSU_MIO_48_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_48_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_48_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_48_PULLUPDOWN {disable} \
# #TE_MOD#    CONFIG.PSU_MIO_49_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_49_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_49_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_49_PULLUPDOWN {disable} \
# #TE_MOD#    CONFIG.PSU_MIO_4_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_4_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_50_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_50_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_50_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_50_PULLUPDOWN {disable} \
# #TE_MOD#    CONFIG.PSU_MIO_51_DIRECTION {out} \
# #TE_MOD#    CONFIG.PSU_MIO_51_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_51_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_51_PULLUPDOWN {disable} \
# #TE_MOD#    CONFIG.PSU_MIO_52_DIRECTION {in} \
# #TE_MOD#    CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
# #TE_MOD#    CONFIG.PSU_MIO_52_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_52_SLEW {fast} \
# #TE_MOD#    CONFIG.PSU_MIO_53_DIRECTION {in} \
# #TE_MOD#    CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
# #TE_MOD#    CONFIG.PSU_MIO_53_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_53_SLEW {fast} \
# #TE_MOD#    CONFIG.PSU_MIO_54_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_54_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_55_DIRECTION {in} \
# #TE_MOD#    CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
# #TE_MOD#    CONFIG.PSU_MIO_55_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_55_SLEW {fast} \
# #TE_MOD#    CONFIG.PSU_MIO_56_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_56_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_57_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_57_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_58_DIRECTION {out} \
# #TE_MOD#    CONFIG.PSU_MIO_58_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_58_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_59_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_59_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_5_DIRECTION {out} \
# #TE_MOD#    CONFIG.PSU_MIO_5_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_5_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_60_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_60_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_61_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_61_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_62_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_62_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_63_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_63_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_64_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_64_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_64_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_65_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_65_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_65_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_66_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_66_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_66_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_67_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_67_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_67_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_68_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_68_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_68_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_69_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_69_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_69_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_6_DIRECTION {out} \
# #TE_MOD#    CONFIG.PSU_MIO_6_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_6_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_70_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
# #TE_MOD#    CONFIG.PSU_MIO_70_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_70_SLEW {fast} \
# #TE_MOD#    CONFIG.PSU_MIO_71_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
# #TE_MOD#    CONFIG.PSU_MIO_71_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_71_SLEW {fast} \
# #TE_MOD#    CONFIG.PSU_MIO_72_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
# #TE_MOD#    CONFIG.PSU_MIO_72_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_72_SLEW {fast} \
# #TE_MOD#    CONFIG.PSU_MIO_73_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
# #TE_MOD#    CONFIG.PSU_MIO_73_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_73_SLEW {fast} \
# #TE_MOD#    CONFIG.PSU_MIO_74_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
# #TE_MOD#    CONFIG.PSU_MIO_74_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_74_SLEW {fast} \
# #TE_MOD#    CONFIG.PSU_MIO_75_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
# #TE_MOD#    CONFIG.PSU_MIO_75_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_75_SLEW {fast} \
# #TE_MOD#    CONFIG.PSU_MIO_76_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_76_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_76_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_77_DIRECTION {<Select>} \
# #TE_MOD#    CONFIG.PSU_MIO_77_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_7_DIRECTION {out} \
# #TE_MOD#    CONFIG.PSU_MIO_7_INPUT_TYPE {cmos} \
# #TE_MOD#    CONFIG.PSU_MIO_7_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_8_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_8_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_9_DIRECTION {inout} \
# #TE_MOD#    CONFIG.PSU_MIO_9_POLARITY {Default} \
# #TE_MOD#    CONFIG.PSU_MIO_TREE_PERIPHERALS {\
# #TE_MOD# Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad\
# #TE_MOD# SPI Flash#Feedback Clk#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI\
# #TE_MOD# Flash#Quad SPI Flash#Quad SPI Flash#SD 0#SD 0#SD 0#SD 0#GPIO0 MIO#GPIO0\
# #TE_MOD# MIO#GPIO0 MIO#GPIO0 MIO#SD 0#SD 0#SD 0#GPIO0 MIO#USB0 Reset#####UART 0#UART\
# #TE_MOD# 0#######I2C 0#I2C 0#######SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB\
# #TE_MOD# 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0##############} \
# #TE_MOD#    CONFIG.PSU_MIO_TREE_SIGNALS {\
# #TE_MOD# sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#sdio0_data_out[0]#sdio0_data_out[1]#sdio0_data_out[2]#sdio0_data_out[3]#gpio0[17]#gpio0[18]#gpio0[19]#gpio0[20]#sdio0_cmd_out#sdio0_clk_out#sdio0_bus_pow#gpio0[24]#reset#####rxd#txd#######scl_out#sda_out#######sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]##############} \
# #TE_MOD#    CONFIG.PSU_SD0_INTERNAL_BUS_WIDTH {4} \
# #TE_MOD#    CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {4} \
# #TE_MOD#    CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__ACT_DDR_FREQ_MHZ {1200.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1200.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {250.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {250.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {600.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1200} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {72} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {3} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {63} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {6} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {10} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {600.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {2} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {5} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {525.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {63} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
# #TE_MOD#    CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {2} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {500.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {50.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {500.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {250.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1500.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__ACT_FREQMHZ {125.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {125.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {250.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {266.666656} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {3} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {500.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.500000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {8} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {375.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {4} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {375} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {300.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {5} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {48} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {2} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {200.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {4} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {200.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {4} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {7} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {33.333332} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {250.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {20.000000} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
# #TE_MOD#    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
# #TE_MOD#    CONFIG.PSU__DDRC__ADDR_MIRROR {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
# #TE_MOD#    CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
# #TE_MOD#    CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
# #TE_MOD#    CONFIG.PSU__DDRC__BUS_WIDTH {32 Bit} \
# #TE_MOD#    CONFIG.PSU__DDRC__CL {17} \
# #TE_MOD#    CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
# #TE_MOD#    CONFIG.PSU__DDRC__COMPONENTS {Components} \
# #TE_MOD#    CONFIG.PSU__DDRC__CWL {12} \
# #TE_MOD#    CONFIG.PSU__DDRC__DDR3L_T_REF_RANGE {NA} \
# #TE_MOD#    CONFIG.PSU__DDRC__DDR3_T_REF_RANGE {NA} \
# #TE_MOD#    CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {1} \
# #TE_MOD#    CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DDR4_T_REF_MODE {1} \
# #TE_MOD#    CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
# #TE_MOD#    CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} \
# #TE_MOD#    CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
# #TE_MOD#    CONFIG.PSU__DDRC__ECC {Disabled} \
# #TE_MOD#    CONFIG.PSU__DDRC__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__FGRM {1X} \
# #TE_MOD#    CONFIG.PSU__DDRC__LPDDR3_T_REF_RANGE {NA} \
# #TE_MOD#    CONFIG.PSU__DDRC__LPDDR4_T_REF_RANGE {NA} \
# #TE_MOD#    CONFIG.PSU__DDRC__LP_ASR {manual normal} \
# #TE_MOD#    CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
# #TE_MOD#    CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16} \
# #TE_MOD#    CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
# #TE_MOD#    CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2400P} \
# #TE_MOD#    CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
# #TE_MOD#    CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
# #TE_MOD#    CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
# #TE_MOD#    CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
# #TE_MOD#    CONFIG.PSU__DDRC__T_FAW {30.0} \
# #TE_MOD#    CONFIG.PSU__DDRC__T_RAS_MIN {32.0} \
# #TE_MOD#    CONFIG.PSU__DDRC__T_RC {46.16} \
# #TE_MOD#    CONFIG.PSU__DDRC__T_RCD {17} \
# #TE_MOD#    CONFIG.PSU__DDRC__T_RP {17} \
# #TE_MOD#    CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
# #TE_MOD#    CONFIG.PSU__DDRC__VREF {1} \
# #TE_MOD#    CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__DDR__INTERFACE__FREQMHZ {600.000} \
# #TE_MOD#    CONFIG.PSU__DLL__ISUSED {1} \
# #TE_MOD#    CONFIG.PSU__ENET2__FIFO__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__ENET2__GRP_MDIO__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__ENET2__GRP_MDIO__IO {EMIO} \
# #TE_MOD#    CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__ENET2__PERIPHERAL__IO {EMIO} \
# #TE_MOD#    CONFIG.PSU__ENET2__PTP__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__ENET2__TSU__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__ENET3__GRP_MDIO__IO {<Select>} \
# #TE_MOD#    CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__ENET3__PERIPHERAL__IO {<Select>} \
# #TE_MOD#    CONFIG.PSU__ENET3__PTP__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__ENET3__TSU__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
# #TE_MOD#    CONFIG.PSU__FPGA_PL1_ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__GEM2_COHERENCY {0} \
# #TE_MOD#    CONFIG.PSU__GEM2_ROUTE_THROUGH_FPD {0} \
# #TE_MOD#    CONFIG.PSU__GEM3_COHERENCY {0} \
# #TE_MOD#    CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
# #TE_MOD#    CONFIG.PSU__GEM__TSU__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
# #TE_MOD#    CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__GPIO_EMIO_WIDTH {1} \
# #TE_MOD#    CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {1} \
# #TE_MOD#    CONFIG.PSU__HIGH_ADDRESS__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 38 .. 39} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {100.000000} \
# #TE_MOD#    CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
# #TE_MOD#    CONFIG.PSU__PL_CLK1_BUF {TRUE} \
# #TE_MOD#    CONFIG.PSU__PRESET_APPLIED {1} \
# #TE_MOD#    CONFIG.PSU__PROTECTION__MASTERS {\
# #TE_MOD# USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;0|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;1|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;0|GEM2:NonSecure;1|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;0|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
# #TE_MOD#    CONFIG.PSU__PROTECTION__SLAVES {\
# #TE_MOD# LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;0|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;1|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;0|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;0|LPD;GEM2;FF0D0000;FF0DFFFF;1|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display\
# #TE_MOD# Port;FD4A0000;FD4AFFFF;0|FPD;DPDMA;FD4C0000;FD4CFFFF;0|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;800000000;0|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1} \
# #TE_MOD#    CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333333} \
# #TE_MOD#    CONFIG.PSU__QSPI_COHERENCY {0} \
# #TE_MOD#    CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
# #TE_MOD#    CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
# #TE_MOD#    CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
# #TE_MOD#    CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
# #TE_MOD#    CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
# #TE_MOD#    CONFIG.PSU__SD0_COHERENCY {0} \
# #TE_MOD#    CONFIG.PSU__SD0_ROUTE_THROUGH_FPD {0} \
# #TE_MOD#    CONFIG.PSU__SD0__CLK_100_SDR_OTAP_DLY {0x0} \
# #TE_MOD#    CONFIG.PSU__SD0__CLK_200_SDR_OTAP_DLY {0x3} \
# #TE_MOD#    CONFIG.PSU__SD0__CLK_50_DDR_ITAP_DLY {0x12} \
# #TE_MOD#    CONFIG.PSU__SD0__CLK_50_DDR_OTAP_DLY {0x6} \
# #TE_MOD#    CONFIG.PSU__SD0__CLK_50_SDR_ITAP_DLY {0x15} \
# #TE_MOD#    CONFIG.PSU__SD0__CLK_50_SDR_OTAP_DLY {0x6} \
# #TE_MOD#    CONFIG.PSU__SD0__DATA_TRANSFER_MODE {4Bit} \
# #TE_MOD#    CONFIG.PSU__SD0__GRP_CD__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__SD0__GRP_POW__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__SD0__GRP_POW__IO {MIO 23} \
# #TE_MOD#    CONFIG.PSU__SD0__GRP_WP__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__SD0__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__SD0__PERIPHERAL__IO {MIO 13 .. 16 21 22} \
# #TE_MOD#    CONFIG.PSU__SD0__RESET__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__SD0__SLOT_TYPE {eMMC} \
# #TE_MOD#    CONFIG.PSU__SD1_COHERENCY {0} \
# #TE_MOD#    CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
# #TE_MOD#    CONFIG.PSU__SD1__CLK_100_SDR_OTAP_DLY {0x0} \
# #TE_MOD#    CONFIG.PSU__SD1__CLK_200_SDR_OTAP_DLY {0x0} \
# #TE_MOD#    CONFIG.PSU__SD1__CLK_50_DDR_ITAP_DLY {0x0} \
# #TE_MOD#    CONFIG.PSU__SD1__CLK_50_DDR_OTAP_DLY {0x0} \
# #TE_MOD#    CONFIG.PSU__SD1__CLK_50_SDR_ITAP_DLY {0x15} \
# #TE_MOD#    CONFIG.PSU__SD1__CLK_50_SDR_OTAP_DLY {0x5} \
# #TE_MOD#    CONFIG.PSU__SD1__DATA_TRANSFER_MODE {4Bit} \
# #TE_MOD#    CONFIG.PSU__SD1__GRP_CD__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 46 .. 51} \
# #TE_MOD#    CONFIG.PSU__SD1__RESET__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__SD1__SLOT_TYPE {SD 2.0} \
# #TE_MOD#    CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
# #TE_MOD#    CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__UART0__BAUD_RATE {115200} \
# #TE_MOD#    CONFIG.PSU__UART0__MODEM__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 30 .. 31} \
# #TE_MOD#    CONFIG.PSU__USB0_COHERENCY {0} \
# #TE_MOD#    CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
# #TE_MOD#    CONFIG.PSU__USB0__RESET__ENABLE {1} \
# #TE_MOD#    CONFIG.PSU__USB0__RESET__IO {MIO 25} \
# #TE_MOD#    CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {0} \
# #TE_MOD#    CONFIG.PSU__USB__RESET__MODE {Separate MIO Pin} \
# #TE_MOD#    CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
# #TE_MOD#    CONFIG.SUBPRESET1 {Custom} \
# #TE_MOD# #Empty Line
  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports SI5338_CLK3_D] [get_bd_intf_pins util_ds_buf_1/CLK_IN_D]
  connect_bd_intf_net -intf_net CLK_IN_D_1 [get_bd_intf_ports SI5338_CLK0_D] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net gmii_to_rgmii_0_MDIO_PHY [get_bd_intf_ports ETH_MDIO] [get_bd_intf_pins gmii_to_rgmii_0/MDIO_PHY]
  connect_bd_intf_net -intf_net gmii_to_rgmii_0_RGMII [get_bd_intf_ports ETH2_RGMII] [get_bd_intf_pins gmii_to_rgmii_0/RGMII]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins jtag_axi_0/M_AXI] [get_bd_intf_pins ps8_0_axi_periph/S01_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins axi_reg32_0/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GMII_ENET2 [get_bd_intf_pins gmii_to_rgmii_0/GMII] [get_bd_intf_pins zynq_ultra_ps_e_0/GMII_ENET2]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_GPIO_0 [get_bd_intf_ports emio] [get_bd_intf_pins zynq_ultra_ps_e_0/GPIO_0]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_MDIO_ENET2 [get_bd_intf_pins gmii_to_rgmii_0/MDIO_GEM] [get_bd_intf_pins zynq_ultra_ps_e_0/MDIO_ENET2]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_LPD [get_bd_intf_pins ps8_0_axi_periph/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD]

  # Create port connections
  connect_bd_net -net CR00200_Phy_CLK125_1 [get_bd_ports CR00200_Phy_CLK125] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net CR00200_Phy_INTn_1 [get_bd_ports CR00200_Phy_INTn] [get_bd_pins vio_0/probe_in8]
  connect_bd_net -net Net [get_bd_pins gmii_to_rgmii_0/rx_reset] [get_bd_pins gmii_to_rgmii_0/tx_reset] [get_bd_pins rst_ps8_0_100M/peripheral_reset]
  connect_bd_net -net X0_Enable_User_LED_N [get_bd_ports x0] [get_bd_pins vio_0/probe_out0]
  connect_bd_net -net X1_User_LED [get_bd_ports x1] [get_bd_pins vio_0/probe_out1]
  connect_bd_net -net fm_SI5338_CLK0_D [get_bd_pins axi_reg32_0/RR0] [get_bd_pins labtools_fmeter_0/F0] [get_bd_pins vio_0/probe_in0]
  connect_bd_net -net gmii_to_rgmii_0_clock_speed [get_bd_pins gmii_to_rgmii_0/clock_speed] [get_bd_pins vio_0/probe_in5]
  connect_bd_net -net gmii_to_rgmii_0_duplex_status [get_bd_pins gmii_to_rgmii_0/duplex_status] [get_bd_pins vio_0/probe_in6]
  connect_bd_net -net gmii_to_rgmii_0_link_status [get_bd_pins gmii_to_rgmii_0/link_status] [get_bd_pins vio_0/probe_in4]
  connect_bd_net -net gmii_to_rgmii_0_speed_mode [get_bd_pins gmii_to_rgmii_0/speed_mode] [get_bd_pins vio_0/probe_in7]
  connect_bd_net -net labtools_fmeter_0_F1 [get_bd_pins axi_reg32_0/RR1] [get_bd_pins labtools_fmeter_0/F1] [get_bd_pins vio_0/probe_in1]
  connect_bd_net -net labtools_fmeter_0_F2 [get_bd_pins axi_reg32_0/RR2] [get_bd_pins labtools_fmeter_0/F2] [get_bd_pins vio_0/probe_in2]
  connect_bd_net -net labtools_fmeter_0_update [get_bd_pins labtools_fmeter_0/update] [get_bd_pins vio_0/probe_in3]
  connect_bd_net -net rst_ps8_0_100M_peripheral_aresetn [get_bd_pins axi_reg32_0/s_axi_aresetn] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins ps8_0_axi_periph/ARESETN] [get_bd_pins ps8_0_axi_periph/M00_ARESETN] [get_bd_pins ps8_0_axi_periph/S00_ARESETN] [get_bd_pins ps8_0_axi_periph/S01_ARESETN] [get_bd_pins rst_ps8_0_100M/peripheral_aresetn]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net util_ds_buf_1_IBUF_OUT [get_bd_pins util_ds_buf_1/IBUF_OUT] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins labtools_fmeter_0/fin] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk1 [get_bd_pins axi_reg32_0/s_axi_aclk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins labtools_fmeter_0/refclk] [get_bd_pins ps8_0_axi_periph/ACLK] [get_bd_pins ps8_0_axi_periph/M00_ACLK] [get_bd_pins ps8_0_axi_periph/S00_ACLK] [get_bd_pins ps8_0_axi_periph/S01_ACLK] [get_bd_pins rst_ps8_0_100M/slowest_sync_clk] [get_bd_pins vio_0/clk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk2 [get_bd_pins gmii_to_rgmii_0/clkin] [get_bd_pins zynq_ultra_ps_e_0/pl_clk1]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins rst_ps8_0_100M/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_reg32_0/S_AXI/S_AXI_reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_reg32_0/S_AXI/S_AXI_reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



