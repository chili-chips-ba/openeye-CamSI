# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Beendorfer Str. 23      *
# --   *   32609 Hüllhorst         *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# -- $Author: Hartfiel, John $
# -- $Email: j.hartfiel@trenz-electronic.de $
# --------------------------------------------------------------------
# -- Change History:
# ------------------------------------------
# -- $Date: 2016/02/03 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2017/07/10  | $Author: Hartfiel, John
# -- - $modify "hw_get_fpga" -> check for empty string on [get_hw_devices] $
# ------------------------------------------
# -- $Date:  2017/09/04  | $Author: Hartfiel, John
# -- - add new document history style
# ------------------------------------------
# -- $Date:  2017/09/13  | $Author: Hartfiel, John
# -- - package trace length export
# ------------------------------------------
# -- $Date:  2017/10/04  | $Author: Hartfiel, John
# -- - "hw_get_fpga" bugfix for Artix/Kintex/Virtex device with only on device into the chain
# ------------------------------------------
# -- $Date:  2017/12/08  | $Author: Hartfiel, John
# -- - "export_blockdesign" ignore block designs from IPs (filter bd_*)
# ------------------------------------------
# -- $Date:  2017/12/12  | $Author: Hartfiel, John
# -- - "import_blockdesign" ignore block designs from IPs (filter bd_*)
# ------------------------------------------
# -- $Date:  2018/01/03  | $Author: Hartfiel, John
# -- - "import_blockdesign" add verilog wrapper option
# -- - "hw_set_bin_and_ltx_files" add modified fsbl for qspi boot.
# -- - "hw_get_fpga" rework to get fpga device (search != arm)
# -- - "hw_create_flash_device" change PROGRAM.* props
# -- - "hw_set_bit_and_ltx_files" change PROGRAM.* props
# -- - "hw_set_mcs_and_ltx_files" change PROGRAM.* props, add prm
# -- - "hw_program_fpga_flash" change PROGRAM.* props
# -- - update messages
# ------------------------------------------
# -- $Date: 2018/01/08  | $Author: Hartfiel, John
# -- - add disable syntheses generation on 'build_design'
# ------------------------------------------
# -- $Date: 2018/01/12  | $Author: Hartfiel, John
# -- - add 'create_ps_board_part' prototype
# ------------------------------------------
# -- $Date:  2018/05/22  | $Author: Hartfiel, John
# -- - add revision search sub folder on: export_blockdesign
# ------------------------------------------
# -- $Date:  2018/07/10  | $Author: Hartfiel, John
# -- - add support for hierarchal bd design with microblaze: import_elf
# ------------------------------------------
# -- $Date:  2018/08/23  | $Author: Hartfiel, John
# -- - change order of import_design. import hfl before block design
# ------------------------------------------
# -- $Date:  2018/12/18  | $Author: Hartfiel, John
# -- - import_hdl. add ignore empty folder
# ------------------------------------------
# -- $Date:  2019/02/15  | $Author: Hartfiel, John
# -- - modified export_blockdesign
# ------------------------------------------
# -- $Date:  2019/06/21  | $Author: Hartfiel, John
# -- - bugfix hw_program_fpga_device
# -- - bugfix hw_set_bit_and_ltx_files
# -- - add disconnect server on hw_close_jtag
# ------------------------------------------
# -- $Date:  2019/10/28  | $Author: Hartfiel, John
# -- - add import_tcl_ip
# ------------------------------------------
# -- $Date:  2019/11/25  | $Author: Hartfiel, John
# -- - add write_platform
# ------------------------------------------
# -- $Date:  2019/12/05  | $Author: Hartfiel, John
# -- -  export_blockdesign  IP version removed
# ------------------------------------------
# -- $Date:  2019/12/18  | $Author: Hartfiel, John
# -- -  replace filename variable  VPROJ_NAME with PB_FILENAME
# ------------------------------------------
# -- $Date:  2020/01/09  | $Author: Hartfiel, John
# -- -  modify restore_scriptprops create_project to check TE prod number for ID recovery 
# ------------------------------------------
# -- $Date:  2020/01/09  | $Author: Hartfiel, John
# -- -  update import_blockdesign --> set top level if wrapper should used and hdl
# ------------------------------------------
# -- $Date:  2020/02/24  | $Author: Hartfiel, John
# -- - import_blockdesign --> remove update_compile_order
# ------------------------------------------
# -- $Date:  2020/02/26  | $Author: Hartfiel, John
# -- - hw_programflash -->replace hw_program_fpga_flash, remove hw_set_mcs_and_ltx_files and  hw_set_bin_and_ltx_files
# ------------------------------------------
# -- $Date:  2020/03/17  | $Author: Hartfiel, John
# -- - hw_program_flash (add FULL_PROBES parameter),rework hw_reload_prope_file_device
# ------------------------------------------
# -- $Date:  2020/03/23  | $Author: Hartfiel, John
# -- - hw_program_flash and note in case file was not found
# ------------------------------------------
# -- $Date:  2020/04/20  | $Author: Hartfiel, John
# -- - hw_program_flash bugfix for flash configuration on native fpga 
# ------------------------------------------
# -- $Date:  2020/05/12  | $Author: Hartfiel, John
# -- - hw_program_flash bugfix for flash configuration for U Kintex FPGA
# ------------------------------------------
# -- $Date:  2020/05/26  | $Author: Hartfiel, John
# -- - hw_program_flash disable blank check for erase as default (use this one from parameter)
# ------------------------------------------
# -- $Date:  2020/06/29  | $Author: Hartfiel, John
# -- - hw_program_flash option to use def FSBL (bugfix for 19.2 and still programmed flash)
# ------------------------------------------
# -- $Date:  2020/07/10  | $Author: Hartfiel, John
# -- - optional additional xrt setup import in bd_import
# ------------------------------------------
# -- $Date:  2020/07/21  | $Author: Hartfiel, John
# -- - hw_open_jtag update xilinx  connect_hw_server with new   -allow_non_jtag option
# ------------------------------------------
# -- $Date:  2021/09/09  | $Author: Struecker, Manuela
# -- - hw_program_flash bugfix used default fsbl option in ZynqMP
# ------------------------------------------
# -- $Date:  2021/10/05  | $Author: Hartfiel, John
# -- - hw_program_flash increase size of  erase_flash.* dummy file 
# ------------------------------------------
# -- $Date:  2022/02/28  | $Author: Hartfiel, John
# -- - hw_program_flash add return value
# -- - hw_close_jtag and hw_open_jtag add option quiet
# ------------------------------------------
# -- $Date:  2022/03/02  | $Author: Hartfiel, John
# -- - hw_program_flash add return value
# -- - bugfix hw_program_flash for mcs erase, small changes for bin erase
# ------------------------------------------
# -- $Date:  2022/04/26  | $Author: Hartfiel, John
# -- - export_blockdesign add converion to unix style
# ------------------------------------------
# -- $Date:  2022/09/21  | $Author: Hartfiel, John
# -- - write_platform prepare for vitis ai export
# ------------------------------------------
# -- $Date:  2022/09/24  | $Author: Hartfiel, John
# -- - write_viv_cfgmem reusable for other paths
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# --------------------------------------------------------------------
namespace eval ::TE {
  namespace eval VIV {
    # -------------------------------------------------------
    # ----advanced functions are currently official not supported
    # -------------------------------------------------------
    #--------------------------------
    #--export_vivado_setting: 
    proc create_ps_board_part {{sourcename } {update_preset false} {create_ps false} {sourcepath "../../../../boards/board_files/_tcl_scripts"}} {
    # hidden function: official not supported
      set ::TE::VIV::bpf_ps_par [list]
      set ::TE::VIV::bpf_ps_spath $sourcepath
      set ::TE::VIV::bpf_ps_sname $sourcename
     
      set bd_files [list]
      if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
      }
      if {[llength $bd_files]>1} {
        TE::UTILS::te_msg TE_HW-111 ERROR "Generate Board part failed. Only one Block Design supported for this function."
        return -code error;
      } elseif {[llength $bd_files] == 0} {
        TE::UTILS::te_msg TE_HW-112 INFO "Create Dummy BD."
        create_bd_design "dummy"
        save_bd_design
      } else {
        foreach bd $bd_files {
          open_bd_design $bd
        }
      }
      if {$create_ps} {
        TE::UTILS::te_msg TE_UTIL-105 WARING "Delete existing Zynq or ZynqMP IPs and create default one";
        if { [catch {delete_bd_objs [get_bd_cells -hierarchical -filter {VLNV=~"*zynq_ultra_ps_e*"}]}]  } {}
        if { [catch {delete_bd_objs [get_bd_cells -hierarchical -filter {VLNV=~"*processing_system7*"}]}]  } {}
        if { [catch {create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0}] } {}
        if { [catch {create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7 processing_system7_0}]  } {}
      }
      
      if {[catch {source "${::TE::VIV::bpf_ps_spath}/$::TE::VIV::bpf_ps_sname"} result]} {TE::UTILS::te_msg TE_UTIL-106 ERROR " $result"; return -code error;} else {TE::UTILS::te_msg TE_UTIL-107 INFO "Source ${::TE::VIV::bpf_ps_spath}/$::TE::VIV::bpf_ps_sname"}


      set tmp [split $TE::BOARDPART ":"]
      set preset_path ""
      if {[file exists  "${TE::BOARDDEF_PATH}/[lindex $tmp 1]/[lindex $tmp 3]/preset.xml"]} { 
        set preset_path ${TE::BOARDDEF_PATH}/[lindex $tmp 1]/[lindex $tmp 3]
      } else {
        # fast solution remove name extension, if set.
        set tmp2 [string map [list _[lindex [split [lindex $tmp 1] "_"] [expr [llength [split [lindex $tmp 1] "_"]]-1]] ""] [lindex $tmp 1]]
        if {[file exists  "${TE::BOARDDEF_PATH}/$tmp2/[lindex $tmp 3]/preset.xml"]} { 
          set preset_path ${TE::BOARDDEF_PATH}/$tmp2/[lindex $tmp 3]
        } else {
          TE::UTILS::te_msg TE_UTIL-108 ERROR "Preset File (${TE::BOARDDEF_PATH}/$tmp2/[lindex $tmp 3]/preset.xml) not found.";
          return -code error;
        }
      }
      if {$update_preset} {
        set frd [open ${preset_path}/preset.xml r]
        
        # open output file
        set fwr [open ${preset_path}/preset.tmp w]
        set sp_start false;
        while { [gets $frd line] >= 0 } {
          if {[string match "<!-- ##TE Last Modification:*" $line]} {
              puts $fwr "<!-- ##TE Last Modification:[ clock format [clock seconds] -format "%Y.%m.%d"] -->"
          } elseif {[string match "*name=*zynq_ultra_ps_e*" $line] || [string match "*name=*processing_system7*" $line]} {
              set sp_start true;
              puts $fwr $line 
          }  elseif {[string match "*<user_parameter  name=*" $line] && $sp_start} {
              #ignore old parameter
          }  elseif {[string match "*</user_parameters>*" $line] && $sp_start} {
              foreach par $::TE::VIV::bpf_ps_par {
                puts $fwr "        $par" 
              }
              puts $fwr $line 
              set sp_start false
          } else {
              puts $fwr $line 
          }
          
        }
        # close files
        close $frd
        close $fwr
        
        file delete ${preset_path}/preset.xml
        file rename ${preset_path}/preset.tmp ${preset_path}/preset.xml
        TE::UTILS::Dos2Unix "${preset_path}/preset.xml"
        TE::UTILS::te_msg TE_UTIL-109 INFO "Create new PS settings on ${preset_path}/preset.xml"
      } else {
        #todo add to msg
        foreach par $::TE::VIV::bpf_ps_par {
          puts "$par"
        }
      }
      
    }
    #--------------------------------
    #--export_vivado_setting: 
    proc export_vivado_setting {} {
    # hidden function: official not supported
      set old_file_data ""
      if {![file exists $TE::SET_PATH]} {
        file mkdir ${TE::SET_PATH}/
      } elseif {[file exists ${TE::SET_PATH}/project_settings.tcl]} {
        # additional project settings
        set fp_r [open ${TE::SET_PATH}/project_settings.tcl "r"]
        set old_file_data [read $fp_r]
        close $fp_r
      }
      set fp_w [open ${TE::SET_PATH}/project_settings.tcl "w"]
      
      puts $fp_w "##############################"                                       
      puts $fp_w "# --------------------------------------------------------------------"
      puts $fp_w "# --   *****************************                                  "
      puts $fp_w "# --   *   Trenz Electronic GmbH   *                                  "
      puts $fp_w "# --   *   Holzweg 19A             *                                  "
      puts $fp_w "# --   *   32257 Bünde             *                                  "
      puts $fp_w "# --   *   Germany                 *                                  "
      puts $fp_w "# --   *****************************                                  "
      puts $fp_w "# --------------------------------------------------------------------"
      puts $fp_w "##############################"
      puts $fp_w "##Automatically exported settings:"
      puts $fp_w "##Creation time: [ clock format [clock seconds] -format "%Y-%m-%dT%H:%M:%S"]"
      puts $fp_w "##Board Part:    [get_property board_part [current_project]]"
      puts $fp_w "##Part:          [get_property part [current_project]]"
      puts $fp_w "#Export Settings currently not available."
      puts $fp_w "#This file will be read on project generation only."
      puts $fp_w "##############################"
      puts $fp_w "#Old file settings:"
      puts $fp_w $old_file_data
      puts $fp_w "##############################"
      puts $fp_w "#exported file settings:"
      puts $fp_w "puts \"Info:(TE) Automatically exported settings.\""
      puts $fp_w "#set_property \"board_part\" [get_property board_part [current_project]] \[current_project\]"
      puts $fp_w "#set_property \"part\" [get_property part [current_project]] \[current_project\]"
      close $fp_w
      TE::UTILS::te_msg TE_HW-0 STATUS "${TE::SET_PATH}/project_settings.tcl was created."
    } 
    #--------------------------------
    #--import_vivado_setting:     
    proc import_vivado_setting {} {
    # hidden function: official not supported
      if {[file exists ${TE::SET_PATH}/project_settings.tcl]} {
        # additional project settings
        TE::UTILS::te_msg TE_HW-1 INFO "Load additional project properties from ${TE::SET_PATH}/project_settings.tcl"
        source ${TE::SET_PATH}/project_settings.tcl
      }
    }  
    
    #--------------------------------
    #--design_exclude_boarddef: 
    proc design_exclude_boarddef {temp_only} {
      # hidden function: official not supported
      #run only if board part is defined
      if {[get_property board_part [current_project]] ne ""} {
        #get bd files
        set bd_files [list]
        if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
        }
        if {[llength $bd_files]>1} {
          TE::UTILS::te_msg TE_HW-1 ERROR "Exclude Board part failed. Only one Block Design supported for this function."
          return -code error;
        }
        #run rtl for xdc export
        synth_design -rtl -name rtl_1
        set pjc_xdc_path "${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::CONST_NAME}"
        file mkdir $pjc_xdc_path
        #export io locs (needed if constrain in board part only)
        write_xdc -force -mode port  ${pjc_xdc_path}/_i_exclude_boardpart_io_loc.xdc
        #remove wrong properties
        set fp_r [open ${pjc_xdc_path}/_i_exclude_boardpart_io_loc.xdc "r"]
        set file_data [read $fp_r]
        close $fp_r
        set data [split $file_data "\n"]
        set fp_w [open ${pjc_xdc_path}/_i_exclude_boardpart_io_loc.xdc "w"]
        puts $fp_w "##############################"                                       
        puts $fp_w "# --------------------------------------------------------------------"
        puts $fp_w "# --   *****************************                                  "
        puts $fp_w "# --   *   Trenz Electronic GmbH   *                                  "
        puts $fp_w "# --   *   Holzweg 19A             *                                  "
        puts $fp_w "# --   *   32257 Buende            *                                  "
        puts $fp_w "# --   *   Germany                 *                                  "
        puts $fp_w "# --   *****************************                                  "
        puts $fp_w "# --------------------------------------------------------------------"
        puts $fp_w "##############################"
        puts $fp_w "##Automatically exported port constrains from exclude board part function:"
        puts $fp_w "##Creation time: [ clock format [clock seconds] -format "%Y-%m-%dT%H:%M:%S"]"
        puts $fp_w "##Board Part:    [get_property board_part [current_project]]"
        puts $fp_w "##Part:          [get_property part [current_project]]"
        puts $fp_w "##############################"
        foreach line $data {
          #ignore some properties
          if {![string match "*set_property DIRECTION*" $line] && ![string match "*set_property IBUF_LOW_PWR*" $line] && ![string match "*current_instance -quiet*" $line]} {
            puts $fp_w $line
          }
        }
        close $fp_w
        
        #add constrains file
        add_files -fileset ${TE::CONST_NAME} ${pjc_xdc_path}/_i_exclude_boardpart_io_loc.xdc
        set_property used_in_synthesis false [get_files ${pjc_xdc_path}/_i_exclude_boardpart_io_loc.xdc]
        #modify some ip setting manually
        set mig_project ""
        # set mig_addr_offset ""
        foreach bd $bd_files {
          open_bd_design $bd
          TE::UTILS::te_msg TE_HW-2 INFO "Exclude Board part: Remove Board Part settings from IPs in $bd"
          #-------------
          #mig
          if {[catch {[get_bd_cells -hierarchical -filter {VLNV=~"*mig_7series*"}]}]} {
            TE::UTILS::te_msg TE_HW-3 WARNING "Exclude Board part: MIG was found and modified. Check Settings after run in $bd"
            catch {set_property CONFIG.BOARD_MIG_PARAM Custom [get_bd_cells -hierarchical -filter {VLNV=~"*mig_7series*"}]}
            catch {set mig_project [get_property CONFIG.XML_INPUT_FILE [get_bd_cells -hierarchical -filter {VLNV=~"*mig_7series*"}]]}
            # catch {set mig_addr_offset [get_property range [get_bd_addr_segs -of_objects [get_bd_cells -hierarchical -filter {VLNV=~"*mig_7series*"}]]]}
          }
          #-------------
          #TE ASIO
          if {[catch {[get_bd_cells -hierarchical -filter {VLNV=~"*axis_asio_gpio*"}]}]} {
            TE::UTILS::te_msg TE_HW-4 WARNING "Exclude Board part: ASIO IP was found and modified. Check Settings after run in $bd"
            catch {set_property CONFIG.USE_BOARD_FLOW false [get_bd_cells -hierarchical -filter {VLNV=~"*axis_asio_gpio*"}]}
            catch {set_property CONFIG.P0_BOARD_INTERFACE Custom [get_bd_cells -hierarchical -filter {VLNV=~"*axis_asio_gpio*"}]}
          }
        }
        #disable board definition
        set_property "part" "[get_property part [current_project]]" [current_project]
        #update ip's
        set ip_names [get_ips]
        if {[llength $ip_names]>0 } {
          ::report_ip_status -name ip_status 
          foreach ip $ip_names {
            TE::UTILS::te_msg TE_HW-5 INFO "Exclude Board part: Upgrade IP: $ip_names"
            if {[catch {::upgrade_ip [get_ips  $ip]}] } {TE::UTILS::te_msg TE_HW-6 {CRITICAL WARNING} "Exclude Board part: Upgrade IP: $ip_names failed and will be ignored." }
          }
          ::report_ip_status -name ip_status 
        }
        #restore some ip setting manually
        foreach bd $bd_files {
          #-------------
          #mig
          if {[catch {[get_bd_cells -hierarchical -filter {VLNV=~"*mig_7series*"}]}]} {
            catch {set_property CONFIG.XML_INPUT_FILE $mig_project [get_bd_cells -hierarchical -filter {VLNV=~"*mig_7series*"}]}
            catch {assign_bd_address [get_bd_addr_segs -of_objects [get_bd_cells -hierarchical -filter {VLNV=~"*mig_7series*"}]]}
            # catch {set_property range $mig_addr_offset [get_bd_addr_segs -of_objects [get_bd_cells -hierarchical -filter {VLNV=~"*mig_7series*"}]]}
          }
          #-------------
          #TE ASIO
          if {[catch {[get_bd_cells -hierarchical -filter {VLNV=~"*axis_asio_gpio*"}]}]} {
          }
          #-------------
          validate_bd_design
          save_bd_design
          close_bd_design [current_bd_design] 
        }
        
        if {!$temp_only} {
          TE::UTILS::te_msg TE_HW-7 WARNING "Exclude Board part: Remove Board part on Backup files permanently."
          # -----------------------------------------------------------------
          #copy exported xdc fie
          file copy -force ${pjc_xdc_path}/exclude_boardpart_io_loc.xdc ${TE::XDC_PATH}/_i_exclude_boardpart_io_loc.xdc
          # -----------------------------------------------------------------
          #backup old block designs tcl files
          set bd_folder ${TE::BD_PATH}/
          if {[file exists ${TE::BD_PATH}/${TE::SHORTDIR}/]} {
            set bd_folder ${TE::BD_PATH}/${TE::SHORTDIR}/
          }
          set bd_names []
          if { ![catch {set bd_names [glob -join -dir ${bd_folder}/ *.tcl]}] } {
            foreach bd $bd_names {
              if {![file exists ${bd}_backup]} {
                TE::UTILS::te_msg TE_HW-8 STATUS "Exclude Board part: Write Backup file: ${bd}_backup"
                file copy -force ${bd} ${bd}_backup
              }
            }
          }
          # -----------------------------------------------------------------
          #write new bd file
          TE::hw_blockdesign_export_tcl
          # -----------------------------------------------------------------
          # write new board_files.
          set board_files ""
          if { [catch {set board_files [ glob $TE::BOARDDEF_PATH/*board_files.csv ] }] } {
            TE::UTILS::te_msg TE_HW-9 WARNING "Exclude Board part: Board Part CSV list doesn't exist. Create *board_file_mod.csv generation failed."
          } else {
            set fp [open "${board_files}" r]
            set file_data [read $fp]
            close $fp
            set data [split $file_data "\n"]
            set newdata []
            #boardname:3
            foreach line $data {
                if {[string match *#* $line] != 1 && [string match *CSV_VERSION* $line] } {
                  lappend newdata $line
                  lappend newdata "#Attention:This is a modified Board part CSV files."
                } elseif {[string match *#* $line] != 1 && [string length $line] > 7} {
                #remove spaces
                set line [string map {" " ""} $line]
                #remove tabs
                set line [string map {"\t" ""} $line]
                #split and replaced
                set tmp [split $line ","]
                set tmp [lreplace $tmp[set tmp {}] 3 3 NA]
                set newstring ""
                set first 1
                foreach el $tmp {
                  if {$first} {
                    set newstring "$el"
                    set first 0
                  } else {
                    set newstring "$newstring,$el"
                  }
                }
                lappend newdata $newstring
              } else {
                lappend newdata $line
              }
            }
            #write all list elements to file
            set new_name [file tail $board_files]
            set new_name [file rootname $new_name]
            set board_files "$TE::BOARDDEF_PATH/${new_name}_mod.csv"
            set fp_w [open ${board_files} "w"]
            foreach line $newdata {
              puts $fp_w $line
            }
            close $fp_w
          }
          #-----------------------------------------------------------------
        }
        TE::UTILS::te_msg TE_HW-10 INFO "Exclude Board Part is done."
      } else {
        TE::UTILS::te_msg TE_HW-11 WARNING "Exclude Board Part failed, Board Part is not specified."
      }
    }   
    #--------------------------------
    #--design_include_boarddef: 
    proc design_include_boarddef {} {
     TE::UTILS::te_msg TE_HW-12 WARNING "Sorry design_include_boarddef currently not available."
    }
        
    #--------------------------------
    #--import_hdl: 
    proc import_hdl {} {
    # hidden function: official not supported
      if {[file exists $TE::HDL_PATH]} {
        TE::UTILS::te_msg TE_HW-13 INFO "Import HDL files."
        set hdl_names [TE::UTILS::search_hdl_files]
        if { [llength $hdl_names] > 0 } {
          add_files $hdl_names
          if {[lsearch $hdl_names *${TE::VPROJ_NAME}_top.vhd*]==0} {
            #vhdl
            set_property top ${TE::VPROJ_NAME}_top [current_fileset]
            #overwrite bd_import toplevel_settings
            set TE::PR_TOPLEVELNAME ${TE::VPROJ_NAME}_top
            TE::UTILS::te_msg TE_HW-14 INFO "Set TE::PR_TOPLEVELNAME:$TE::PR_TOPLEVELNAME"
          } elseif {[lsearch $hdl_names *${TE::VPROJ_NAME}_top.v*]==0} {
            #Verilog
            set_property top ${TE::VPROJ_NAME}_top [current_fileset]
            #overwrite bd_import toplevel_settings
            set TE::PR_TOPLEVELNAME ${TE::VPROJ_NAME}_top
            TE::UTILS::te_msg TE_HW-15 INFO "Set TE::PR_TOPLEVELNAME:$TE::PR_TOPLEVELNAME"
          }
          # set attributes
          foreach hdl $hdl_names {
            set hdl_name [file tail [file rootname $hdl]]
            if {[string match "*_simonly_*" $hdl_name] } {
              set_property used_in_synthesis false [get_files  $hdl]
              TE::UTILS::te_msg TE_HW-16 INFO "Set $hdl_name synthesis property to false."
            }
            if {[string match "*_synonly_*" $hdl_name] } {
              set_property used_in_simulation false [get_files  $hdl]
              TE::UTILS::te_msg TE_HW-17 INFO "Set $hdl_name simulation property to false."
            }
          }
        }
      }
    }     
    
    #------------------------------------
    #--import_xci: import xci files
    proc import_xci {} {
    # hidden function: official not supported
      if {[file exists $TE::HDL_PATH/xci]} {
        TE::UTILS::te_msg TE_HW-18 INFO "Import XCI files."
        set ip_names [TE::UTILS::search_xci_files]
        import_ip  -files $ip_names
        catch {set ip_names [get_ips]}
        foreach ip $ip_names {
          ##ips without block design ips
          if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/ip/${ip}/${ip}.xci] } {
            TE::UTILS::te_msg TE_HW-19 INFO "Run out of context IP for: $ip"
            generate_target {instantiation_template} [get_files ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/ip/${ip}/${ip}.xci]
            update_compile_order -fileset ${TE::SOURCE_NAME}
            generate_target all [get_files ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/ip/${ip}/${ip}.xci]
            if {[get_property generate_synth_checkpoint [get_files ${ip}.xci]] == 1 && [get_property is_enabled [get_files ${ip}.xci]] == 1} {
              create_ip_run [get_files -of_objects [get_fileset ${TE::SOURCE_NAME}] ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/ip/${ip}/${ip}.xci]
              launch_run -jobs $TE::RUNNING_JOBS ${ip}_synth_1
            }
          }
        }
        foreach ip $ip_names {
          ##ips without ips from block design
          if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/ip/${ip}/${ip}.xci] } {
            if {[get_property generate_synth_checkpoint [get_files ${ip}.xci]] == 1  && [get_property is_enabled [get_files ${ip}.xci]] == 1} {
              wait_on_run -timeout ${TE::TIMEOUT} ${ip}_synth_1
            }
          }
        }
      }
    }    
    #------------------------------------
    #--import_tcl_ip: importtclxci files
    proc import_tcl_ip {} {
    # hidden function: official not supported
      if {[file exists $TE::HDL_PATH/tcl]} {
        TE::UTILS::te_msg TE_HW-91 INFO "Import TCL IP files."
        set ip_names [TE::UTILS::search_tcl_ip_files]
        file mkdir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/ip
        foreach ip $ip_names {
          source $ip

        }
      }
    }
    #------------------------------------
    #--export_xci: export xci files
    proc export_xci {} {
    # hidden function: official not supported
      set ip_names [list]
      catch {set ip_names [get_ips]}
      if {[llength $ip_names] > 0} {
        file mkdir $TE::HDL_PATH/xci/${TE::SHORTDIR}

        set ip_report ""
        foreach ip $ip_names {
          ##ips without block design ips
          if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/ip/${ip}/${ip}.xci] } {
            set ip_report "$ip_report \n $ip"
            file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/ip/${ip}/${ip}.xci $TE::HDL_PATH/xci/${TE::SHORTDIR}/${ip}.xci
          }
        }
        TE::UTILS::te_msg TE_HW-20 INFO "Export: \n \
          $ip_report \n \
          to folder $TE::HDL_PATH/xci/${TE::SHORTDIR}/ \n \
        ------"
      }
    }
    #------------------------------------
    #--export_trace_length: export package trace length
    proc export_trace_length {} {
    # hidden function: official not supported
      set partslist [get_property part [current_project]]
      foreach p $partslist {
        ::create_project -in_memory -part $p
        ::set_property design_mode PinPlanning [current_fileset]
        ::open_io_design -name io_1
        ::write_csv -force ${TE::DOC_PATH}/${p}.pkg
        ::close_project
         TE::UTILS::te_msg TE_HW-82 INFO "Create trace length files: ${TE::DOC_PATH}/${p}.pkg"
      }
    }
    # -------------------------------------------------------
    # finished advanced function
    # -------------------------------------------------------
    # -------------------------------------------------------
    
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # project creation functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #------------------------------------
    #--create_project: create vivado project, set board definition and ip path, set default vivado properties
    proc create_project {} {
      #write info file for easier recovery
      TE::UTILS::write_board_select
      #set board part file definition path
      TE::ENV::set_path_boarddef
      #create vivado project 
      ::create_project -force $TE::VPROJ_NAME $TE::VPROJ_PATH 
      #set local ip path
      TE::ENV::set_path_ip
      #set vivado properties
      set_vprops
      #disable auto update
      # set_property source_mgmt_mode DisplayOnly [current_project]
    }
    #------------------------------------
    #--open_project: open excisting vivado project and restore importent script variables with settings from project
    proc open_project {} {
      #set board part file definition path
      TE::ENV::set_path_boarddef
      #open vivado project
      ::open_project ${TE::VPROJ_NAME}.xpr
      #restore vivado properties to script variables
      restore_scriptprops
    }    
    #------------------------------------
    #--close_project: close excisting vivado project
    proc close_project {} {
      #close vivado project
      ::close_project
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished creation functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # project property functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #------------------------------------
    #--set_vprops: 
    proc set_vprops {} {
      #set std properties
      set_property "default_lib" "xil_defaultlib" [current_project]
      set_property "simulator_language" "Mixed" [current_project]
      set_property "target_language" "VHDL" [current_project]
      if {[info exists TE::PARTNAME]} {
        if {![string match $TE::PARTNAME "NA"]} {
          set_property "part" $TE::PARTNAME [current_project]
        }
      }                       
      if {[info exists TE::BOARDPART]} {
        if {![string match $TE::BOARDPART "NA"]} {
          set_property "board_part" $TE::BOARDPART [current_project]
        }
      }
      #----------------------------------------------------------
      #hidden function write settings
      import_vivado_setting
      #----------------------------------------------------------
      #overwrite xilinx defaults
      set_property name $TE::SIM_NAME     [get_filesets sim_1]
      set_property name $TE::SYNTH_NAME   [get_runs synth_1]
      set_property name $TE::IMPL_NAME    [get_runs impl_1]
      set_property name $TE::CONST_NAME   [get_filesets constrs_1]
      #----------------------------------------------------------
    } 
    #------------------------------------
    #--restore_scriptprops: 
    proc restore_scriptprops {} {
      set prod_id [TE::UTILS::read_board_select]
      if {[string match "NA" $prod_id] == 1} {
        set ID [get_property board_part [current_project]]
        if {$ID ne ""} {
          TE::INIT::init_board $ID $TE::BDEF::BOARDNAME
        } else {
          TE::INIT::init_part_only [get_property part [current_project]]
        }
      } else {
        TE::INIT::init_board $prod_id $TE::BDEF::PRODID
      }
      #check bd file names for some additional functions 
      if {[catch {TE::INIT::check_bdtyp} result]} {TE::UTILS::te_msg TE_HW-21 Error "Script (TE::INIT::check_bdtyp) failed: $result."; return -code error}
      #check board parts
      if { ![string equal $TE::PARTNAME [get_property part [current_project]]] } {
        TE::UTILS::te_msg TE_HW-22 {CRITICAL WARNING} "Current part name is set to [get_property part [current_project]], expect $TE::PARTNAME for board part definition file $TE::BOARDPART"
      }      
      #check top level name
      if { ![string equal $TE::PR_TOPLEVELNAME [get_property top  [current_fileset]]] } {
        TE::UTILS::te_msg TE_HW-23 WARNING "Current top level name is set to [get_property top  [current_fileset]], expect $TE::PR_TOPLEVELNAME from default initialisation. Set TE::PR_TOPLEVELNAME to [get_property top  [current_fileset]]."
        set TE::PR_TOPLEVELNAME [get_property top  [current_fileset]]
      }      
      #----------------------------------------------------------
      #set run paths
      set TE::SIM_NAME    [get_property name [get_filesets sim*]]
      set TE::SYNTH_NAME  [get_property name [get_runs syn*]]
      set TE::IMPL_NAME   [get_property name [get_runs imp*]]
      set TE::CONST_NAME  [get_property name [get_filesets con*]]

      TE::UTILS::te_msg TE_HW-24 INFO "Restore project parameters:\n \
        TE::SIM_NAME:         $TE::SIM_NAME  \n \
        TE::SYNTH_NAME:       $TE::SYNTH_NAME  \n \
        TE::IMPL_NAME:        $TE::IMPL_NAME  \n \
        TE::CONST_NAME:       $TE::CONST_NAME  \n \
        ------"
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished project property functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # project source functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--import_design: 
    proc import_design {} {
      TE::UTILS::te_msg TE_HW-25 STATUS "Start import design"


      #load backup constrains and block design
      set xdc_files [TE::UTILS::search_xdc_files]
      import_xdc $xdc_files
      set_xdcsetting $xdc_files
      import_hdl
      import_blockdesign
      import_xci
      import_tcl_ip
      import_elf
      #enable auto update
      # set_property source_mgmt_mode All [current_project]
      # update_compile_order -fileset ${TE::SOURCE_NAME}
      if {$TE::XRT_USED} {
        import_files
      }

    }
    #--------------------------------
    #--import_xdc: 
    proc import_xdc {xdc_files} {
      set target_file ""
      foreach xdc $xdc_files {
        read_xdc $xdc
        if {[file tail $xdc] eq "vivado_target.xdc"} {
          set target_file $xdc
        }
      }

      set_property target_constrs_file $target_file [current_fileset -constrset]
    }
    #--------------------------------
    #--set_xdcsetting: 
    proc set_xdcsetting {xdc_files} {
      #set xdc properties depending on xdc name: processing order an usage
      foreach xdc_file $xdc_files {
        if {[string match *_e_* $xdc_file] == 1} {
            set_property PROCESSING_ORDER EARLY [get_files $xdc_file]
            TE::UTILS::te_msg TE_HW-26 STATUS "Set processing order early for $xdc_file"
        } elseif {[string match *_l_* $xdc_file] == 1} {
            set_property PROCESSING_ORDER LATE [get_files $xdc_file]
            TE::UTILS::te_msg TE_HW-27 STATUS "Set processing order late for $xdc_file"
        } else {
          set_property PROCESSING_ORDER NORMAL [get_files $xdc_file]
            TE::UTILS::te_msg TE_HW-28 STATUS "Set processing order normal for $xdc_file"
        }
        if {[string match *_s_* $xdc_file] == 1} {
            set_property USED_IN_IMPLEMENTATION 0 [get_files $xdc_file]
            set_property USED_IN_SYNTHESIS 1 [get_files $xdc_file]
            TE::UTILS::te_msg TE_HW-29 STATUS "Set use for synthesis only for $xdc_file" 
        } elseif {[string match *_i_* $xdc_file] == 1} {
            set_property USED_IN_SYNTHESIS 0 [get_files $xdc_file]
            set_property USED_IN_IMPLEMENTATION 1 [get_files $xdc_file]
            TE::UTILS::te_msg TE_HW-30 STATUS "Set use for implementation only for $xdc_file" 
        } else {
          set_property USED_IN_SYNTHESIS 1 [get_files $xdc_file]
          set_property USED_IN_IMPLEMENTATION 1 [get_files $xdc_file]
          TE::UTILS::te_msg TE_HW-31 STATUS "Set use for synthesis and implementation for $xdc_file" 
        }
      }
    }
    #--------------------------------
    #--reload_blockdesign: delete all bd and load bd.tcl files from backup
    proc reload_blockdesign {} {
      set bd_files []
      if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
      }
      foreach bd $bd_files {
        TE::UTILS::te_msg TE_HW-32 STATUS "Remove:$bd" 
          remove_files $bd
          set bd_dir [file dirname $bd]
          file delete -force $bd_dir
      }
      import_blockdesign
    }
    #--------------------------------
    #--import_blockdesign: imports and compile bd designs for vivado
    proc import_blockdesign {} {
      #check bd filenames for some additional functions
      if {[catch {TE::INIT::check_bdtyp} result]} {TE::UTILS::te_msg TE_HW-33 ERROR "Script (TE::INIT::check_bdtyp) failed: $result."; return -code error}
       
      set bd_files [TE::UTILS::search_bd_files]
      if {[llength $bd_files]>0 } {
        #run bd tcl
        foreach bd $bd_files {
          # 
          if {[file extension $bd] eq ".tcl"} {
            source $bd
            set tmp [current_bd_design]

            if {$TE::XRT_USED} {
              set xrt_files [TE::UTILS::search_xrt_files]
              foreach xrt_f $xrt_files {
                source $xrt_f
              }
              save_bd_design
            }
            close_bd_design [current_bd_design]
          }
        }
        #compile bd
        set bd_files []
        if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
        }
        foreach bd $bd_files {
          if {[string match bd_* $bd]} {
            TE::UTILS::te_msg TE_BD-28 {CRITICAL WARNING} "Ignore generated Block Design from IP \"$bd\". Please check, if this is correct!"
          } else {
            open_bd_design $bd
            validate_bd_design -force
            generate_target all [get_files $bd]
            #check if hdf to exists
            set bd_name [current_bd_design]
            set tl_name "NA"
            if { [catch {set tl_name [glob -join -dir $TE::HDL_PATH/ ${TE::VPROJ_NAME}_top.*]}] & [catch {set tl_name [glob -join -dir $TE::HDL_PATH/${TE::SHORTDIR}/ ${TE::VPROJ_NAME}_top.*]}] } {
              TE::UTILS::te_msg TE_HW-34 INFO "Generate top level wrapper"
              make_wrapper -files [get_files $bd] -top
              if {[get_property target_language [current_project]] eq "VHDL"} {
                add_files -norecurse ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/$bd_name/hdl/${bd_name}_wrapper.vhd
              } else {
                add_files -norecurse ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/$bd_name/hdl/${bd_name}_wrapper.v
              }
              set_property top ${bd_name}_wrapper [current_fileset]
            } else {
              TE::UTILS::te_msg TE_HW-35 INFO "Use custom HDL top level file"
            }
            close_bd_design [current_bd_design]
            #todo: use more bd files -> currently its check on init function only one is allowed
          } 
        } 
        # update_compile_order -fileset ${TE::SOURCE_NAME}
        # update_compile_order -fileset ${TE::SIM_NAME}      
      }
    }
    #--------------------------------
    #--export_blockdesign: export bd designs to clear vivado folder (if folder ${TE::BD_PATH}/${TE::SHORTDIR} exist it will be export for this boardpart only)
    #--                    create pdf for each bd and sub hierarchy
    proc export_blockdesign {{args ""}} {
    #read args
      set bd_folder ${TE::BD_PATH}
      set no_mig ""
      set valid_bd true
      set this_boardpart_only false
      set mod_tcl false
      set args_cnt [llength $args]
      for {set option 0} {$option < $args_cnt} {incr option} {
          switch [lindex $args $option] { 
          "-no_mig_contents"  {set no_mig [lindex $args $option]}
          "-no_validate"		  {set valid_bd false}
          "-mod_tcl"		      {set mod_tcl true}
          "-board_part_only"  {set this_boardpart_only true}
          ""		  {}
            default    { TE::UTILS::te_msg TE_HW-36 {CRITICAL WARNING} "Unrecognised option [lindex $args $option]is ignored" }
          }
      }
      if {$this_boardpart_only} {
        file mkdir ${TE::BD_PATH}/${TE::SHORTDIR}/
      }
      set revDir [lindex [split ${TE::PCB_REV} "|"] 0]
      if {[file exists ${TE::BD_PATH}/${TE::SHORTDIR}/]} {
        set bd_folder ${TE::BD_PATH}/${TE::SHORTDIR}/
      } elseif {[file exists ${TE::BD_PATH}/${revDir}/]} {
        set bd_folder ${TE::BD_PATH}/${revDir}/
      } else {
        #use default
      }
      
      #search for open projects
      set bd_open false
      set bd_open_file ""
      set bd_open_name ""

      if {[current_bd_design -quiet] ne ""} {
        #save currend bd configuration
        # validate_bd_design -force
        save_bd_design
        set bd_open true
        set bd_open_name "[current_bd_design]"
        TE::UTILS::te_msg TE_BD-2 INFO "$bd_open_name was saved."
        set bd_open_file ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/${bd_open_name}/${bd_open_name}.bd
        # close_bd_design [get_bd_designs $bd_open_file]
      }
      set bd_files []
      if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
        TE::UTILS::te_msg TE_BD-3 WARNING "BD-File doesn't exist."
      }
      if {!$TE::BD_MULTI} {
        if {[llength $bd_files]>1 } {
          TE::UTILS::te_msg TE_BD-4 WARNING "Currently only one block design supported, deleted unused bd.tcl from  ${bd_folder}."
        }
      }

      foreach bd $bd_files {
       open_bd_design $bd
       if {$valid_bd} {
        TE::UTILS::te_msg TE_BD-5 INFO "Validate Design."
        validate_bd_design
        } else {
          TE::UTILS::te_msg TE_BD-6 WARNING "Validate Design disabled."
        }
      }
      set vivado_bd_design_name []
      if { [catch {set vivado_bd_design_name [get_bd_designs]}] } {
       TE::UTILS::te_msg TE_BD-7 {CRITICAL WARNING} "Block designs doesn't exist."
       
      } else {
        set txt "Stored Block Designs: \n "
        foreach bd $vivado_bd_design_name {
          if {[string match bd_* $bd]} {
            TE::UTILS::te_msg TE_BD-27 {CRITICAL WARNING} "Ignore generated Block Design from IP \"$bd\". Please check, if this is correct!"
          } else {
            # puts "-exclude Layout, IP-Version and MIG-content"
            # write_bd_tcl -force -exclude_layout -no_ip_version -no_mig_contents ${bd_folder}/${bd}_bd.tcl
            set bf_tcl_name ${bd_folder}/${bd}_bd.tcl
            set txt "${txt}  File: ${bf_tcl_name} \n"
            if {$no_mig eq ""} {
              write_bd_tcl -no_ip_version -force ${bf_tcl_name}
            } else {
              set txt "${txt}     -Option: Remove MIG-Contents \n"
              write_bd_tcl  -no_ip_version -force $no_mig ${bf_tcl_name}
            }
            # modify bd
             if {[catch {TE::UTILS::modify_block_design_tcl ${bf_tcl_name} ${mod_tcl}} result]} { TE::UTILS::te_msg TE_BD-8 ERROR "Script (TE::UTILS::modify_block_design_tcl) failed: $result."; return -code error}
            if {[catch {TE::UTILS::Dos2Unix ${bf_tcl_name} } result]} { TE::UTILS::te_msg TE_BD-8 ERROR "Script (TE::UTILS::modify_block_design_tcl) failed: $result."; return -code error}
            #export blockdesign as pdf
            #sel doc_path
            set doc_path ${TE::DOC_PATH}/
            if {[file exists ${TE::BD_PATH}/${TE::SHORTDIR}/]} {
              set doc_path ${TE::DOC_PATH}/${TE::SHORTDIR}/
            }
            file mkdir ${doc_path}/
            #delete old bd_*.pdf
            set old_pdfs []
             if { [catch {set old_pdfs [glob -join -dir ${doc_path}/ bd_*.pdf]}] } {
            } else {
              TE::UTILS::te_msg TE_BD-9 INFO "Delete old Block Design PDFs in ${doc_path}"
              foreach old_pdf $old_pdfs {
                if {[catch {file delete -force ${old_pdf}}]} {
                  TE::UTILS::te_msg TE_BD-10 WARNING "Delete ${old_pdf} failed."
                }
              }
            }
            set txt "${txt}     -Option: Write PDF-Layouts \n"
            set sname bd_${TE::VPROJ_NAME}_hier_top.pdf
            if {[catch {write_bd_layout -force -format pdf -scope all -orientation landscape  ${doc_path}/${sname}}]} {
              TE::UTILS::te_msg TE_BD-11 WARNING "Write ${doc_path}/${sname} failed."
            }
            set allsubs [get_bd_cells -filter {TYPE == hier}]
            foreach sub $allsubs {
              set tmp [string map {"/" ""} [join $sub]]
              set sname bd_${TE::VPROJ_NAME}_hier_${tmp}.pdf
              if {[catch {write_bd_layout -force -format pdf -hierarchy [get_bd_cells $sub] -orientation landscape  ${doc_path}/${sname}}]} {
                TE::UTILS::te_msg TE_BD-12 WARNING "Write ${doc_path}/${sname} failed."
              }
            }
            # save is needed because print subsystem mod bd file 
            save_bd_design
            #
            if { $bd ne $bd_open_name || !$bd_open} {
              close_bd_design [get_bd_designs ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/${bd}/${bd}.bd]
            }
          }
          
        }
        TE::UTILS::te_msg TE_BD-13 INFO "$txt"
      }
    }
    #--------------------------------
    #--import_elf: 
    proc import_elf {} {
      if {[file exists $TE::FIRMWARE_PATH]} {
        set elf_names [TE::UTILS::search_elf_files]
        # set microblaze elf
        foreach elf_f $elf_names {
          add_files -norecurse $elf_f
          set tmp [TE::UTILS::relTo $elf_f $TE::FIRMWARE_PATH]
          set tmp [split $tmp "/"]
          set tmpLength [llength $tmp]
          if {$tmpLength>2} {
            set elf_file [lindex $tmp [expr $tmpLength-1]]
            set m_name [lindex $tmp 1]
            for {set index 2} {$index <[expr $tmpLength-1]} {incr index} {
                set m_name "${m_name}/[lindex $tmp $index]"
                
            }
            set f_obj "*${m_name}/${elf_file}"
            #todo multi bd design
            set bd_files [list]
            if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
            }
            foreach bd $bd_files {
              set bd_name [file tail [file rootname $bd]]
              set_property SCOPED_TO_REF $bd_name [get_files -all -of_objects [get_fileset sources_1] ${f_obj}]
              #mcs only used if name contains SYSCONTROL or MCS
              if {[string match -nocase *SYSCONTROL*  $m_name] || [string match -nocase *MCS* $m_name]} {
                set_property SCOPED_TO_CELLS "${m_name}/U0/microblaze_I" [get_files -all -of_objects [get_fileset sources_1] ${f_obj}]
              } else {
                set_property SCOPED_TO_CELLS "${m_name}" [get_files -all -of_objects [get_fileset sources_1] ${f_obj}]
              }
            }
          }
        }
      }
    }    
    
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished project source functions
    # -----------------------------------------------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------------------------------------------
    # project new block design functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--creat_new_blockdesign: create empty block design with zynq initialisation: fsys,msys,zsys,zusys
    proc create_new_blockdesign {{type fsys} {msys_conf {local_mem "8KB" ecc "None" cache "None" debug_module "Debug Only" axi_periph "Enabled" axi_intc "0" clk "None"}}} {
      #check other bd files exists, currently only one is supported with this function
      set bd_files []
      if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
        create_bd_design $type
        if {$type eq "fsys"} {
          TE::UTILS::te_msg TE_BD-14 INFO "For fsys Block Design is currently no additional initialisation intended."
        } elseif {$type eq "zusys"} {
          create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0
          apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  [get_bd_cells zynq_ultra_ps_e_0]
          
          set tcl_ext []
          if { [catch {set tcl_ext [glob -join -dir ${TE::BOARDDEF_PATH}/carrier_extension/ *_preset.tcl]}] } {
          }
          foreach carrier_ext $tcl_ext {
            TE::UTILS::te_msg TE_BD-15 INFO "Import carrier_settings from:[file tail $carrier_ext]."
            source  $carrier_ext
          }
        } elseif {$type eq "zsys"} {
          create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7 processing_system7_0
          apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
          set tcl_ext []
          if { [catch {set tcl_ext [glob -join -dir ${TE::BOARDDEF_PATH}/carrier_extension/ *_preset.tcl]}] } {
          }
          foreach carrier_ext $tcl_ext {
            TE::UTILS::te_msg TE_BD-16 INFO "Import carrier_settings from:[file tail $carrier_ext]."
            source  $carrier_ext
          }
        } elseif {$type eq "msys"} {
          create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze microblaze_0
          #set test {local_mem "8KB" ecc "None" cache "None" debug_module "Debug Only" axi_periph "Enabled" axi_intc "0" clk "None"}
          apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config $msys_conf  [get_bd_cells microblaze_0]
        } else { 
          TE::UTILS::te_msg TE_BD-17 {CRITICAL WARNING} "Unknown Block-Design Type. No Type specific initialisation is done."
        }
      } else {
        TE::UTILS::te_msg TE_BD-18 ERROR "Currently TE-Scripts supports only one Block-Design. Generation is cancelled."
        return -code error
      }      
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished new block design functions
    # -----------------------------------------------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------------------------------------------
    # project build functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--build_design: 
    proc build_design {{synthgen true} {bitgen true} {mcsgen true} {reportgen true} {hdfgen true}} {
      if {$synthgen} {
        if {[catch {run_synth} result]} {TE::UTILS::te_msg TE_HW-37 ERROR "Script (TE::VIV::run_synth) failed: $result."; return -code error}
      } else {
        set_property needs_refresh false [get_runs $TE::SYNTH_NAME]
        TE::UTILS::te_msg TE_HW-84 WARNING "Syntheses is forced 'Up to Date'. Rerun Implementation only."
      }
      if {[catch {run_impl} result]} {TE::UTILS::te_msg TE_HW-38 ERROR "Script (TE::VIV::run_impl) failed: $result."; return -code error}
      if {$bitgen} {
        if {[catch {write_viv_bitfile} result]} {TE::UTILS::te_msg TE_HW-39 ERROR "Script (TE::VIV::write_viv_bitfile) failed: $result."; return -code error}
      } else {
        #delete old one if exists
        if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.bit]} {
          if {[catch {file delete -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.bit} result]} {TE::UTILS::te_msg TE_HW-40 WARNING "$result"}
        }
        TE::UTILS::te_msg TE_HW-41 WARNING "Bit-file generation is disabled on build design run."
      }
      if {$mcsgen} {
        if {[catch {write_viv_cfgmem} result]} {TE::UTILS::te_msg TE_HW-42 ERROR "Script (TE::VIV::write_viv_cfgmem) failed: $result."; return -code error}
      } else {
        #delete old one if exists
        if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mcs]} {
          if {[catch {file delete -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mcs} result]} {TE::UTILS::te_msg TE_HW-43 WARNING "$result"}
        }
        TE::UTILS::te_msg TE_HW-44 WARNING "MCS-file generation is disabled on build design run"
      }
      if {$reportgen} {
        if {[catch {report_design} result]} {TE::UTILS::te_msg TE_HW-45 ERROR "Script (TE::VIV::report_design) failed: $result."; return -code error}
      } else {
        #delete old one if exists
        if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_ip_status_report.txt]} {
          if {[catch {file delete -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_ip_status_report.txt} result]} {TE::UTILS::te_msg TE_HW-46 WARNING "$result"}
        }
        if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.txt]} {
          if {[catch {file delete -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.txt} result]} {TE::UTILS::te_msg TE_HW-47 WARNING "$result"}
        }
        if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.csv]} {
          if {[catch {file delete -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.csv} result]} {TE::UTILS::te_msg TE_HW-48 WARNING "$result"}
        }
        if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.xdc]} {
          if {[catch {file delete -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.xdc} result]} {TE::UTILS::te_msg TE_HW-49 WARNING "$result"}
        }
        TE::UTILS::te_msg TE_HW-50 WARNING "Report-files generation is disabled on build design run."
      }
      if {$hdfgen} {
        #is done automatically with bitgen -> *.sysdef on 2019.1 or older
        TE::VIV::write_platform
      } else {
        #delete old one if exists
        
        if {[file exists ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa]} {
          if {[catch {file delete -force ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa} result]} {TE::UTILS::te_msg TE_HW-54 WARNING "$result"}
        }        
        if {[file exists ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.hdf]} {
          if {[catch {file delete -force ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.hdf} result]} {TE::UTILS::te_msg TE_HW-51 STATUS "$result"}
        }
        TE::UTILS::te_msg TE_HW-52 WARNING "XSA-files generation is disabled on build design run."
      }
    }
    #--------------------------------
    #--run_synth: 
    proc run_synth {} {
      #syntheses
      reset_run $TE::SYNTH_NAME
      launch_runs $TE::SYNTH_NAME -jobs $TE::RUNNING_JOBS
      wait_on_run -timeout $TE::TIMEOUT $TE::SYNTH_NAME
    }
    #--------------------------------
    #--run_impl: 
    proc run_impl {} {
      #implementation and bitgen
      reset_run $TE::IMPL_NAME
      # launch_runs $TE::IMPL_NAME
      launch_runs $TE::IMPL_NAME -to_step route_design -jobs $TE::RUNNING_JOBS
      wait_on_run -timeout $TE::TIMEOUT $TE::IMPL_NAME
    }
   #--------------------------------
    #--write_viv_bitfile: 
    proc write_viv_bitfile {} {
      launch_runs $TE::IMPL_NAME -to_step write_bitstream -jobs $TE::RUNNING_JOBS
      wait_on_run -timeout $TE::TIMEOUT $TE::IMPL_NAME
    }
   #--------------------------------
    #--write_viv_bitfile: 
    proc write_platform {} {
     # if { [catch { write_hwdef  -file ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.hdf }] } {
       # TE::UTILS::te_msg TE_HW-52 STATUS "HDF generation failed (HDF not longer needed, use xsa)."
     # }
     if { [get_property platform.extensible [current_project]] } {
       TE::UTILS::te_msg TE_HW-99 INFO "Generate XSA for VITIS AI."
       if { [catch { write_hw_platform -hw -force  -file ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa }] } {
         TE::UTILS::te_msg TE_HW-98 WARNING "XSA generation failed."
       }
     } else {
       TE::UTILS::te_msg TE_HW-100 INFO "Generate XSA for Fixed Standard Flow."
       if { [catch { write_hw_platform -fixed -force  -include_bit -file ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa }] } {
         TE::UTILS::te_msg TE_HW-95 WARNING "XSA generation failed."
       }
     }
    }
    #--------------------------------
    #--write_viv_cfgmem: 
    proc write_viv_cfgmem {{bitfile NA} {mcsfile NA} } {
      set mcsfile_int $mcsfile
      if  {$mcsfile_int eq "NA"} {
        set mcsfile_int  ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mcs
      }
      set bitfile_int $bitfile
      if  {$bitfile_int eq "NA"} {
        set bitfile_int  ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.bit
      }
      #used only if bd name is no zynq design (without processor system)!
      if {[file exists ${mcsfile_int}]} { file delete -force ${mcsfile_int} }
      if {!$TE::IS_ZSYS && !$TE::IS_ZUSYS} {
        if {$TE::CFGMEM_MEMSIZE_MB ne "NA"} {
          #check supported from *board_files.csv
          #write mcs with *board_files.csv settings
          if {[catch { write_cfgmem -force -format mcs -interface $TE::CFGMEM_IF -size $TE::CFGMEM_MEMSIZE_MB \
                                    -loadbit "up 0x0 ${bitfile_int}" \
                                    -file ${mcsfile_int}\
          }]} {
          #if failed try SPIX1 (default ) (faster than open design)
            TE::UTILS::te_msg TE_HW-53 INFO "Generate MCS failed with $TE::CFGMEM_IF from *board_files.csv specification, try to generate SPIx1."
            if {[catch { write_cfgmem -force -format mcs -interface SPIX1 -size $TE::CFGMEM_MEMSIZE_MB \
                                      -loadbit "up 0x0 ${bitfile_int}" \
                                      -file ${mcsfile_int}\
            }]} {
              #if failed get propery from design (needs some time) 
              TE::UTILS::te_msg TE_HW-54 INFO "Generate MCS failed with SPIx1, try to get information from implemented Design."
              open_run $TE::IMPL_NAME
              set tmp_cfgmem_if "SPIx[get_property BITSTREAM.CONFIG.SPI_BUSWIDTH [current_design]]"
              close_design
              write_cfgmem -force -format mcs -interface $tmp_cfgmem_if -size $TE::CFGMEM_MEMSIZE_MB \
                           -loadbit "up 0x0 ${bitfile_int}" \
                           -file ${mcsfile_int}
              TE::UTILS::te_msg TE_HW-55 INFO "Generate MCS with  $tmp_cfgmem_if from current design setting (BITSTREAM.CONFIG.SPI_BUSWIDTH), but current Board Part supports $TE::CFGMEM_IF"
            } else {
              TE::UTILS::te_msg TE_HW-56 INFO "Generate MCS with  SPIX1 (BITSTREAM.CONFIG.SPI_BUSWIDTH 1) from Bitfile, but current Board Part supports $TE::CFGMEM_IF also!"
            }
          }
        } else {
          TE::UTILS::te_msg TE_HW-57 {CRITICAL WARNING} "FPGAFLASHTYP Mem Size in MB is not specified in *.board_files.csv. *.mcs file is not generated."
        }
      }
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished built functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # report functions (todo to utilities)
    # -----------------------------------------------------------------------------------------------------------------------------------------

    #--------------------------------
    #--report_design: 
    proc report_design {} {
      #-------------check toplevel name (if modified)
      if { ![string equal $TE::PR_TOPLEVELNAME [get_property top  [current_fileset]]] } {
        TE::UTILS::te_msg TE_HW-58 INFO "Top Level Name ([get_property top  [current_fileset]]) is not same then exspected from BD-File delivery ($TE::PR_TOPLEVELNAME). [get_property top  [current_fileset]] is used in Script settings now."
        set TE::PR_TOPLEVELNAME [get_property top  [current_fileset]]
      }  
      #-------------block design reports
      #-------------synthese reports
      #-------------implement reports
      open_run $TE::IMPL_NAME
      
      #todo:
      # report_debug_core -file ${TE::VPROJ_NAME}_debug_cores.txt
      report_ip_status -file ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_ip_status_report.txt
      report_io -force -file ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.txt -format text
      write_csv -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.csv
      write_xdc -force -mode port ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.xdc

      report_summary
      close_design
    }
    #--------------------------------
    #--report_run: 
    proc report_run {} {
      #todo eventuell auftrennen und dann noch report schreiben, wenn nicht alles durch geht
      set date "[ clock format [clock seconds] -format "%Y-%m-%dT%H:%M:%S"]"
      set status "Error"
      set founderror -1
      #synth
      set sythn_counts [extract_synth_summary]
      set sythn_counts_split [split $sythn_counts ","]
      set value [lindex $sythn_counts_split [expr [llength $sythn_counts_split]-1]]
      if {$value != 0} {set founderror 1}
      #impl
      set impl_counts [extract_impl_summary]
      set impl_counts_split [split $impl_counts ","]
      set value [lindex $impl_counts_split [expr [llength $impl_counts_split]-1]]
      if {$value != 0} {set founderror 1}
      #drc
      set drc_counts [extract_drc_summary]
      set drc_counts_split [split $drc_counts ","]
      set value [lindex $drc_counts_split [expr [llength $drc_counts_split]-1]]
      if {$value != 0} {set founderror 1}
      #timing
      set timing_counts [extract_timing_summary]
      set timing_counts_split [split $timing_counts ","]
      set value [lindex $timing_counts_split [expr [llength $timing_counts_split]-1]]
      if {[string compare "NA" $value ]==0} {set founderror 0} elseif {$value != 0} {set founderror 1}
      if {$founderror == -1} {set status "Ok"} elseif {$founderror == 0} {set status "Ok(NA)"}
      #write report
      set report "[format "%-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s," "$date" "$status" "$TE::VPROJ_NAME" "$TE::SHORTDIR" "$TE::BOARDPART" "$TE::SYNTH_NAME" "$TE::IMPL_NAME" "[lindex $sythn_counts_split 0]" "[lindex $sythn_counts_split 1]" "[lindex $sythn_counts_split 2]" "[lindex $sythn_counts_split 3]" "[lindex $impl_counts_split 0]" "[lindex $impl_counts_split 1]" "[lindex $impl_counts_split 2]" "[lindex $impl_counts_split 3]" "[lindex $drc_counts_split 0]" "[lindex $drc_counts_split 1]"  "[lindex $timing_counts_split 0]" "[lindex $timing_counts_split 1]" "[lindex $timing_counts_split 2]"]"
      return $report
    }
    #--------------------------------
    #--report_summary: 
    proc report_summary {} {
      set fp_w [open ${TE::VPROJ_PATH}/${TE::PB_FILENAME}_summary.csv "w"]
      #write header
      puts $fp_w [format "%-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s, %-40s," "Date" "Status" "ProjName" "BoardDefShortName" "BoardDefName" "SynthName" "ImplName" "SynthInfo" "SynthWarnings" "SynthCritWarnings" "SynthError" "ImplInfo" "ImplWarnings" "ImplCritWarnings" "ImplError" "ImplDRCWarnings" "ImplDRCError" "ImplTimingWNS" "ImplTimingFaildEndpoints" "ImplTimingTNS"]

      puts $fp_w [report_run]
      close $fp_w
    }    
    #--------------------------------
    #--extract_synth_summary: 
    proc extract_synth_summary {} {
      set synth_returns "0,0,0,FileNotFound" 
      
      set report_file ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::SYNTH_NAME}/${TE::PR_TOPLEVELNAME}.vds
      if { ![file exists ${report_file}]} {return $synth_returns}
      set fp_r [open ${report_file} "r"]
      set file_data [read $fp_r]
      set data [split $file_data "\n"]
      close $fp_r
      
      foreach line $data {
        if {[string match "*Infos*Warnings*Critical Warnings*Errors encountered*" $line]} {
          set tmp [string map {"and" "," " " "" "Infos" "" "Warnings" "" "Critical" "" "Errors" "" "encountered." ""} "$line"]
          #use only last log output
          #return Infos, Warnings, Critical Warnings , Errors
          set synth_returns $tmp
        }
      }
      return $synth_returns
    }   
    #--------------------------------
    #--extract_impl_summary: 
    proc extract_impl_summary {} {
      set impl_returns "0,0,0,FileNotFound"
      set report_file ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.vdi
      if { ![file exists ${report_file}]} {return $impl_returns}
      set fp_r [open ${report_file} "r"]
      set file_data [read $fp_r]
      set data [split $file_data "\n"]
      close $fp_r
      
      foreach line $data {
        if {[string match "*Infos*Warnings*Critical Warnings*Errors encountered*" $line]} {
          set tmp [string map {"and" "," " " "" "Infos" "" "Warnings" "" "Critical" "" "Errors" "" "encountered." ""} "$line"]
          #use only last log output
          #return Infos, Warnings, Critical Warnings , Errors
          set impl_returns $tmp
        }
      }
      return $impl_returns
    }  
    #--------------------------------
    #--extract_drc_summary: 
    proc extract_drc_summary {} {
      set drc_returns "0,FileNotFound"
      set report_file ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.vdi
      if { ![file exists ${report_file}]} {return $drc_returns}
      set fp_r [open ${report_file} "r"]
      set file_data [read $fp_r]
      set data [split $file_data "\n"]
      close $fp_r
      set err_count 0
      set warn_count 0
      
      foreach line $data {
        if {[string match "*DRC finished with*" $line]} {
          set index [string first "with" $line 0]
          set tmp [string range $line $index [string length $line]]
          set tmp [string map {" " "" "with" "" "Errors" "" "Warnings" "" "Advisories" ""} "$tmp"]
          set tmp [split $tmp ","]
          if {[llength $tmp]==1} {
            if {[string is integer [lindex $tmp 0]]} {
              set err_count [expr $err_count + [lindex $tmp 0]]
            } else {
              set err_count 999999
            }
          } else {
            if {[string is integer [lindex $tmp 0]]} {
              set err_count [expr $err_count + [lindex $tmp 0]]
            } else {
              set err_count 999999
            }
            if {[string is integer [lindex $tmp 1]]} {
              set warn_count [expr $warn_count + [lindex $tmp 1]]
            } else {
              set warn_count 999999
            }
          }
        }
      }
      #return Warnings, Errors
      set drc_returns "$warn_count, $err_count"
      return $drc_returns
    }  
    #--------------------------------
    #--extract_timing_summary:
    proc extract_timing_summary {} {
      set timing_returns "0,0,FileNotFound"
      set report_file ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}_timing_summary_routed.rpt
      if { ![file exists ${report_file}]} {return $timing_returns}
      set fp_r [open ${report_file} "r"]
      set file_data [read $fp_r]
      set data [split $file_data "\n"]
      close $fp_r
      
      set lineindex -1
      foreach line $data {
        incr lineindex
        if {[string match "*Design Timing Summary*" $line]} {
          break;
        }
      }
      set lineindex [expr $lineindex +6]
      set tmp [join [lindex $data $lineindex] " "]
      set timing_returns "[lindex $tmp 0],[lindex $tmp 2],[lindex $tmp 1]"
      #return WNS, Faild Endpoints, TNS
      return $timing_returns
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished report functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  }
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  namespace eval VLAB {
   # -----------------------------------------------------------------------------------------------------------------------------------------
    # vlab project functions
    # -----------------------------------------------------------------------------------------------------------------------------------------

    #--------------------------------
    #--create_project: 
    proc create_project {} {
      #create vivado lab project 
      ::create_project -force $TE::VPROJ_NAME $TE::VLABPROJ_PATH 
      #set props..
    }
    #--------------------------------
    #--open_project: 
    proc open_project {} {
      #open vivado lab project
      ::open_project ${TE::VPROJ_NAME}.lpr
    }    
    #--------------------------------
    #--close_project: 
    proc close_project {} {
      #close vivado project
      ::close_project
    }
    #--------------------------------
    #--hw_open_jtag: 
    proc hw_open_jtag {{quiet false}} {

      #start new session
      ::open_hw_manager
      if {[current_hw_server -quiet] eq ""} {
        if {$quiet} {
          ::connect_hw_server -allow_non_jtag -quiet
        } else {
          ::connect_hw_server -allow_non_jtag
        }
      }

      set devices [get_hw_devices ]
      foreach dev $devices {
        if {$quiet} {
          current_hw_device [get_hw_devices $dev] -quiet
          refresh_hw_device -update_hw_probes false [lindex [get_hw_devices $dev] 0] -quiet
        } else {
          current_hw_device [get_hw_devices $dev]
          refresh_hw_device -update_hw_probes false [lindex [get_hw_devices $dev] 0]
        }
      }
      if {[current_hw_device -quiet] eq ""} {
        if {$quiet} {
          ::open_hw_target -quiet
        } else {
          ::open_hw_target
        }
        return true
      } else {
        return false
      }
    }
    #--------------------------------
    #--hw_close_jtag: 
    proc hw_close_jtag {{quiet false}} {
      if {$quiet} {
        ::disconnect_hw_server [::get_hw_servers] -quiet
        ::close_hw_manager -quiet
      } else {
        ::disconnect_hw_server [::get_hw_servers]
        ::close_hw_manager 
      }
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished vlab project functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # device functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--hw_create_flash_device: 
    proc hw_create_flash_device {{fname ""} {setup 01100}} {
      set partname_int ""
      set flashtyp_int ""
      if {$fname ne ""} {
        set partname_int "[TE::BDEF::find_partname $fname]"
        set id "[TE::BDEF::find_id $fname]"
        set tmp [TE::BDEF::get_fpgaflashtyp $id 0]
        set tmp [split $tmp "|"]
        if {[llength $tmp] eq 3} {
          set flashtyp_int [lindex $tmp 0]
        } else {
          set flashtyp_int $tmp
        }
        
      } else {
        set partname_int $TE::PARTNAME
        set flashtyp_int $TE::FPGAFLASHTYP
      }
      set hw_fpga_name [hw_get_fpga $partname_int]
      set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
      #reset old propefiles
      set bc [string index $setup 0]
      set er [string index $setup 1]
      set cp [string index $setup 2]
      set vr [string index $setup 3]
      set cs [string index $setup 4]
      
      
      create_hw_cfgmem -hw_device  $hw_fpga_name -mem_dev  [lindex [get_cfgmem_parts ${flashtyp_int}] 0]
      set_property PROGRAM.BLANK_CHECK  $bc [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
      set_property PROGRAM.ERASE  $er [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
      set_property PROGRAM.CFG_PROGRAM  $cp [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
      set_property PROGRAM.VERIFY  $vr [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
      set_property PROGRAM.CHECKSUM  $cs [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
      

      if {[catch {after 500; refresh_hw_device $hw_fpga_name}] } {}
    }   
    #--------------------------------
    #--hw_get_fpga: 
    proc hw_get_fpga {{partname ""}} {
      set partname_int $partname
      if {$partname_int eq ""} {set partname_int $TE::PARTNAME}
      set hw_fpga_name NA
      set hw_fpga_found false
      set hw_devices [list]
      set hw_devices [get_hw_devices]
      #-- [lindex $hw_devices 0] is "" with 2017.4 so slit works
      if {[llength $hw_devices]==1} {
        set hw_devices [list]
        lappend hw_devices [get_hw_devices]
      }
      set tmp [split $hw_devices " "]
      foreach hwd $tmp {
        if {[string match *arm_dap* $hwd ] || [string match $hwd ""] } {
          set hw_fpga_found false
        } else {
          set hw_fpga_found true
        }
        if {$hw_fpga_found} {set hw_fpga_name $hwd;break;}
      }
      if {$hw_fpga_found} {
        # ::refresh_hw_device $hw_fpga_name
      } else {
        set rpt_txt "$partname_int FPGA Device not available. Available Devices: $hw_devices \n"
        TE::UTILS::te_msg TE_PR-0 WARNING "$rpt_txt"
      }
      return $hw_fpga_name
    }
    #--------------------------------
    #--hw_fpga_boot_from_memory: 
    proc hw_fpga_boot_from_memory {{fname ""}} {
      set partname_int ""
      if {$fname ne ""} {
        set partname_int "[TE::BDEF::find_partname $fname]"
      } else {
        set partname_int $TE::PARTNAME
      }
      set hw_fpga_name [hw_get_fpga $partname_int]
      if {$hw_fpga_name ne "NA"} {
        ::boot_hw_device $hw_fpga_name 
        TE::UTILS::te_msg TE_PR-1 INFO "Reboot Device is done (Note successfully software reboot depends also on devices design)."
        if {[catch {after 1000; refresh_hw_device $hw_fpga_name}] } {} else {
          TE::UTILS::te_msg TE_PR-2 INFO "Refresh Device is done."
        }
      } else {
        TE::UTILS::te_msg TE_PR-3 ERROR "Boot from Memory failed. Device doesn't exist."
      }
    }   
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished device functions
    # -----------------------------------------------------------------------------------------------------------------------------------------

    # -----------------------------------------------------------------------------------------------------------------------------------------
    # property functions
    # ----------------------------------------------------------------------------------------------------------------------------------------- 
    #--------------------------------
    #--hw_set_bit_and_ltx_files: setup for bitfile configuration via labtools/vivado   
    proc hw_set_bit_and_ltx_files {use_basefolder app_name {fname ""}} {
      set return_filename ""
      set partname_int ""
      set shortdir_int ""
      if {$fname ne ""} {
        set partname_int "[TE::BDEF::find_partname $fname]"
        set shortdir_int "[TE::BDEF::find_shortdir $fname]"
      } else {
        set partname_int $TE::PARTNAME
        set shortdir_int $TE::SHORTDIR
      }
     
      set hw_fpga_name [hw_get_fpga $partname_int]
      if {$hw_fpga_name ne "NA"} {
        if {$use_basefolder} {
         
          set bitfilename ""
          if { ![catch {set bitfilename [glob -join -dir ${TE::BASEFOLDER}/ *.bit]}] } {
            TE::UTILS::te_msg TE_PR-4 INFO "Used file:${bitfilename}"
            set return_filename  ${bitfilename}
            set_property PROGRAM.FILE ${bitfilename} [lindex [get_hw_devices $hw_fpga_name] 0]
          } else {
              TE::UTILS::te_msg TE_PR-5 ERROR "Bitfile doesn't exist in ${TE::BASEFOLDER}. Nothing is done."
              return -code error
          }
        } else {
          if {$app_name eq "" || $app_name eq "NA"} {
            if {[file exists ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.bit]} {
              #use bitfile from hardware folder (with bootloop for microblaze systems)
              set_property PROGRAM.FILE ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.bit [lindex [get_hw_devices $hw_fpga_name] 0]
              if {[file exists ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx]} {
                set_property PROBES.FILE ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx [get_hw_devices $hw_fpga_name]
              } else {
                TE::UTILS::te_msg TE_PR-6 INFO "Probes file (${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx)doesn't exist."
                set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
              }
              TE::UTILS::te_msg TE_PR-7 INFO "Used file:${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.bit"
              set return_filename  ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.bit
            } else {
              #use default bit from hardware folder (with bootloop for microblaze systems)
              if {[file exists ${TE::PREBUILT_HW_PATH}/default/${TE::PB_FILENAME}.bit]} {
                set_property PROGRAM.FILE ${TE::PREBUILT_HW_PATH}/default/${TE::PB_FILENAME}.bit [lindex [get_hw_devices $hw_fpga_name] 0]
                if {[file exists ${TE::PREBUILT_HW_PATH}/default/${TE::VPROJ_NAME}/${TE::PB_FILENAME}.ltx]} {
                  set_property PROBES.FILE ${TE::PREBUILT_HW_PATH}/default/${TE::PB_FILENAME}.ltx [get_hw_devices $hw_fpga_name]
                } else {
                  TE::UTILS::te_msg TE_PR-8 INFO "Probes file (${TE::PREBUILT_HW_PATH}/default/${TE::PB_FILENAME}.ltx) doesn't exist."
                  set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
                }
                TE::UTILS::te_msg TE_PR-9 INFO "Used file:${TE::PREBUILT_HW_PATH}/default/${TE::PB_FILENAME}.bit"
                set return_filename  ${TE::PREBUILT_HW_PATH}/default/${TE::PB_FILENAME}.bit
              } else {
                TE::UTILS::te_msg TE_PR-10 ERROR "${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.bit doesn't exist. Nothing is done."
                return -code error
              }
            }
          } else {
            #use bitfile from bootimage folder (with programmed apps for microblaze systems)
            set bitfilename ""
            if { ![catch {set bitfilename [glob -join -dir ${TE::PREBUILT_BI_PATH}/${shortdir_int}/${app_name}/ *.bit]}] } {
              set_property PROGRAM.FILE ${bitfilename}  [lindex [get_hw_devices $hw_fpga_name] 0]
              #search in hardware folder for ltx
              if {[file exists ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx]} {
                set_property PROBES.FILE ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx [get_hw_devices $hw_fpga_name]
              } else {
                TE::UTILS::te_msg TE_PR-11 INFO "Probes file (${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx)  doesn't exist."
                set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
              }
              TE::UTILS::te_msg TE_PR-12 INFO "Used file:${bitfilename}"
              set return_filename  ${bitfilename}
            } else {
              TE::UTILS::te_msg TE_PR-13 ERROR "${TE::PREBUILT_BI_PATH}/${shortdir_int}/${app_name}/*.bit doesn't exist. Nothing is done."
              return -code error
            }
          }
        }
      } else {
        TE::UTILS::te_msg TE_PR-14 ERROR "Program FPGA failed. Device doesn't exist."
        return -code error
      }
      return $return_filename
    }
    # #--------------------------------
    # #--hw_set_bin_and_ltx_files: setup for binfile configuration via labtools/vivado   
    # proc hw_set_bin_and_ltx_files {use_basefolder app_name fname} {
      # set return_filename ""
      # set partname_int ""
      # set shortdir_int ""
      # if {$fname ne ""} {
        # set partname_int "[TE::BDEF::find_partname $fname]"
        # set shortdir_int "[TE::BDEF::find_shortdir $fname]"
      # } else {
        # set partname_int $TE::PARTNAME
        # set shortdir_int $TE::SHORTDIR
      # }
      # set hw_fpga_name [hw_get_fpga $partname_int]
      # if {$hw_fpga_name ne "NA"} {
        # if {$use_basefolder} {
          # set binfilename ""
          # set ltxfilename ""
          # if { ![catch {set binfilename [glob -join -dir ${TE::BASEFOLDER}/ *.bin]}] } {
            # TE::UTILS::te_msg TE_PR-15 INFO "Used file:${binfilename}"
            # set return_filename  ${binfilename}
            # set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
            # set_property PROGRAM.FILES [list "${binfilename}" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
            # if {[file exists ${TE::BASEFOLDER}/fsbl_flash.elf]} {
              # set_property PROGRAM.ZYNQ_FSBL ${TE::BASEFOLDER}/fsbl_flash.elf [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]      
              
            # } elseif {[file exists ${TE::BASEFOLDER}/fsbl_flash.elf]} {
              # set_property PROGRAM.ZYNQ_FSBL ${TE::BASEFOLDER}/fsbl_flash.elf [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]              
            # } else {
              # TE::UTILS::te_msg TE_PR-85 {CRITICAL WARNING} "Zynq FSBL file (${TE::BASEFOLDER}/fsbl_flash.elf or fsbl_flash.elf) doesn't exist." 
            # }           
            # if { ![catch {set ltxfilename [glob -join -dir ${TE::BASEFOLDER}/ *.ltx]}] } {
              # set_property PROBES.FILE ${ltxfilename} [get_hw_devices $hw_fpga_name]
            # } else {
              # set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
            # }
          # } else {
            # TE::UTILS::te_msg TE_PR-16 {CRITICAL WARNING} "Bin file doesn't exist in ${TE::BASEFOLDER}. Nothing is done."
            # return -code error
          # }
        # } else {
          # set binfilename ""
          # if { ![catch {set binfilename [glob -join -dir ${TE::PREBUILT_BI_PATH}/${shortdir_int}/${app_name}/ *.bin]}] } {
            # set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
            # set_property PROGRAM.FILES [list "${binfilename}" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
            # if {[file exists ${TE::PREBUILT_SW_PATH}/${shortdir_int}/zynqmp_fsbl_flash.elf]}  {
              # set_property PROGRAM.ZYNQ_FSBL ${TE::PREBUILT_SW_PATH}/${shortdir_int}/zynqmp_fsbl_flash.elf [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]   
            # } elseif {[file exists ${TE::PREBUILT_SW_PATH}/${shortdir_int}/zynq_fsbl_flash.elf]} {
              # set_property PROGRAM.ZYNQ_FSBL ${TE::PREBUILT_SW_PATH}/${shortdir_int}/zynq_fsbl_flash.elf [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]            
            # } else {
              # TE::UTILS::te_msg TE_PR-86 {CRITICAL WARNING} "Zynq FSBL file (${TE::PREBUILT_SW_PATH}/${shortdir_int}/zynq_fsbl_flash.elf or zynqmp_fsbl_flash.elf) doesn't exist." 
            # } 
            # if {[file exists ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx]} {
              # set_property PROBES.FILE ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx [get_hw_devices $hw_fpga_name]
            # } else {
              # TE::UTILS::te_msg TE_PR-17 INFO "Probes file (${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx) doesn't exist."
              # set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
            # }
            # TE::UTILS::te_msg TE_PR-18 INFO "Used file: ${binfilename}"
            # set return_filename  ${binfilename}
          # } else {
            # TE::UTILS::te_msg TE_PR-19 ERROR "${TE::PREBUILT_BI_PATH}/${shortdir_int}/${app_name}/*.bin doesn't exist. Nothing is done."
            # return -code error
          # }
        # }
      # } else {
        # TE::UTILS::te_msg TE_PR-20 ERROR "Program FPGA failed. Device doesn't exist."
        # return -code error
      # }
      # return $return_filename
    # }
    # #--------------------------------
    # #--hw_set_mcs_and_ltx_files: setup for mcsfile configuration via labtools/vivado   
    # proc hw_set_mcs_and_ltx_files {use_basefolder term app_name fname} {
      # set return_filename ""
      # set partname_int ""
      # set shortdir_int ""
      # if {$fname ne ""} {
        # set partname_int "[TE::BDEF::find_partname $fname]"
        # set shortdir_int "[TE::BDEF::find_shortdir $fname]"
      # } else {
        # set partname_int $TE::PARTNAME
        # set shortdir_int $TE::SHORTDIR
      # }
      # set hw_fpga_name [hw_get_fpga $partname_int]
      # if {$hw_fpga_name ne "NA"} {
        # if {$use_basefolder} {
          # set mcsfilename ""
          # set prmfilename ""
          # set ltxfilename ""
          # if { ![catch {set mcsfilename [glob -join -dir ${TE::BASEFOLDER}/ *.mcs]}] } {
            # TE::UTILS::te_msg TE_PR-21 INFO "Used file:${mcsfilename}"
            # set return_filename  ${mcsfilename}
            # set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
            # set_property PROGRAM.FILES [list "${mcsfilename}" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]       
            # if { ![catch {set prmfilename [glob -join -dir ${TE::BASEFOLDER}/ *.prm]}] } {
              # set_property PROGRAM.PRM_FILE "${prmfilename}" [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
            # } else {
              # set_property PROGRAM.PRM_FILE "" [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
            # }
            # set_property PROGRAM.UNUSED_PIN_TERMINATION ${term} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]           
            # if { ![catch {set ltxfilename [glob -join -dir ${TE::BASEFOLDER}/ *.ltx]}] } {
              # set_property PROBES.FILE ${ltxfilename} [get_hw_devices $hw_fpga_name]
            # } else {
              # set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
            # }
          # } else {
            # TE::UTILS::te_msg TE_PR-22 ERROR "MCS-file doesn't exist in ${TE::BASEFOLDER}. Nothing is done."
            # return -code error
          # }
        # } else {
          # if {$app_name eq "" || $app_name eq "NA"} {
            # #use mcs from hardware folder (with bootloop for microblaze systems)
            # if {[file exists ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.mcs]} {
              # set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
              # set_property PROGRAM.FILES [list "${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.mcs" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
              # if {[file exists ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.prm]} {
                # set_property PROGRAM.PRM_FILE "${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.prm" [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
              # } else {
                # set_property PROGRAM.PRM_FILE "" [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
                # TE::UTILS::te_msg TE_PR-87 INFO "PRM file (${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.prm) doesn't exist."
              # }
              # set_property PROGRAM.UNUSED_PIN_TERMINATION ${term} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]       
              # if {[file exists ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx]} {
                # set_property PROBES.FILE ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx [get_hw_devices $hw_fpga_name]
              # } else {
                # TE::UTILS::te_msg TE_PR-23 INFO "Probes file (${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx) doesn't exist."
                # set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
              # }
              # TE::UTILS::te_msg TE_PR-24 INFO "Used file:${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.mcs"
              # set return_filename  ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.mcs
            # } else {
              # TE::UTILS::te_msg TE_PR-25 ERROR "${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.mcs doesn't exist. Nothing is done"
              # return -code error
            # }
          # } else {
            # #use mcs from bootimage folder (with configured app for microblaze systems)
            # set mcsfilename ""
            # set prmfilename ""
            # if { ![catch {set mcsfilename [glob -join -dir ${TE::PREBUILT_BI_PATH}/${shortdir_int}/${app_name}/ *.mcs]}] } {
              # set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
              # set_property PROGRAM.FILES [list "${mcsfilename}" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
              # if { ![catch {set prmfilename [glob -join -dir ${TE::PREBUILT_BI_PATH}/${shortdir_int}/${app_name}/ *.prm]}]} {
                # set_property PROGRAM.PRM_FILE "${prmfilename}" [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
              # } else {
                # set_property PROGRAM.PRM_FILE "" [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
                # TE::UTILS::te_msg TE_PR-88 INFO "PRM file (${prmfilename}) doesn't exist."
              # }
              # set_property PROGRAM.UNUSED_PIN_TERMINATION ${term} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
              # #search ltx from hardware folder
              # if {[file exists ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx]} {
                # set_property PROBES.FILE ${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx [get_hw_devices $hw_fpga_name]
              # } else {
                # TE::UTILS::te_msg TE_PR-26 INFO "Probes file (${TE::PREBUILT_HW_PATH}/${shortdir_int}/${TE::PB_FILENAME}.ltx) doesn't exist."
                # set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
              # }
              # TE::UTILS::te_msg TE_PR-27 INFO "Used file:${mcsfilename}"
              # set return_filename  ${mcsfilename}
            # } else {
              # TE::UTILS::te_msg TE_PR-28 ERROR "${TE::PREBUILT_BI_PATH}/${shortdir_int}/${app_name}/*.mcs doesn't exist. Nothing is done."
              # return -code error
            # }
          # }
        # }
      # } else {
        # TE::UTILS::te_msg TE_PR-29 ERROR "Program FPGA failed. Device doesn't exist."
        # return -code error
      # }
      # return $return_filename
    # }
    
    #--------------------------------
    #--hw_reload_prope_file_device: 
    proc hw_reload_prope_file_device {{appname ""} {fname ""}} {
      set partname_int ""
      set shortdir_int ""
      set ltxfilename ""
      if {$fname ne ""} {
        set partname_int "[TE::BDEF::find_partname $fname]"
        set shortdir_int "[TE::BDEF::find_shortdir $fname]"
      } else {
        set partname_int $TE::PARTNAME
        set shortdir_int $TE::SHORTDIR
      }
      set hw_fpga_name [hw_get_fpga $partname_int]
      
      if {$appname ne "" } {
        set ltxfilename [TE::UTILS::prebuilt_file_location false * .ltx NA NA NA false $shortdir_int]
        
        # puts "----------------------Test|$shortdir_int|$ltxfilename||||||||"
        
        
        set_property PROBES.FILE ${ltxfilename} [get_hw_devices $hw_fpga_name]
        if {[string match NA $ltxfilename]} {
          set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
          set_property FULL_PROBES.FILE "" [get_hw_devices $hw_fpga_name]
          
        }
      } elseif {$appname eq "" && ![catch {set ltxfilename [glob -join -dir ${TE::BASEFOLDER}/ *.ltx]}] } {
        set_property PROBES.FILE ${ltxfilename} [get_hw_devices $hw_fpga_name]
        set_property FULL_PROBES.FILE ${ltxfilename} [get_hw_devices $hw_fpga_name]
      } else {
        set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
        set_property FULL_PROBES.FILE "" [get_hw_devices $hw_fpga_name]
      }
      TE::UTILS::te_msg TE_PR-113 INFO "Add probe file ${ltxfilename}."
      
      
      if {[catch {after 1000; refresh_hw_device $hw_fpga_name}] } {}
      

    }  
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished property functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # programming functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--hw_program_fpga_device: 
    proc hw_program_fpga_device { use_basefolder appname {fname ""}} {
      #bitfile
      set return_filename ""
      set partname_int ""
      if {$fname ne ""} {
        set partname_int "[TE::BDEF::find_partname $fname]"
      } else {
        set partname_int $TE::PARTNAME
      }
      set hw_fpga_name [hw_get_fpga $partname_int]
      
      if {![catch {set return_filename [hw_set_bit_and_ltx_files $use_basefolder $appname $fname]}] } { 
        program_hw_devices  [get_hw_devices $hw_fpga_name]
        TE::UTILS::te_msg TE_PR-32 INFO "Programming BIT-file finished."
        if {[catch {after 500; refresh_hw_device $hw_fpga_name}] } {}
      } else {
        TE::UTILS::te_msg TE_PR-33 ERROR "Program FPGA failed."
        return -code error
      }
      return $return_filename
    }   
    #--------------------------------
    #--hw_program_fpga_flash: 
    proc hw_program_flash {{appname ""} {fname ""} {setup 011001} {erase false} {def_fsbl false}} {
      #empty app name means basefolder search
      #empty fname name means means current device selection
      set return_filename ""
      set partname_int ""
      set shortdir_int ""
      if {$fname ne ""} {
        set partname_int "[TE::BDEF::find_partname $fname]"
        set shortdir_int "[TE::BDEF::find_shortdir $fname]"
      } else {
        set partname_int $TE::PARTNAME
        set shortdir_int $TE::SHORTDIR
      }

      
      set ltxfilename ""
      
      
       
      
      set hw_fpga_name [hw_get_fpga $partname_int]
      
      #reset old propefiles
      set bc [string index $setup 0]
      set er [string index $setup 1]
      set cp [string index $setup 2]
      set vr [string index $setup 3]
      set cs [string index $setup 4]
      # native pga only
      set tr [string index $setup 5]
      if {$tr eq 2} {
        set tr "pull-down"
      } elseif {$tr eq 1} {
        set tr "pull-up"
      } else {
        set tr "pull-none"
      }
      
      #all
      set ar use_file
      if {$erase} {
        set ar entire_device
        set bc [string index $setup 0]
        set er 1
        set cp 0
        set vr 0
        set cs 0
        set tr "pull-up"
      } 
      # puts "Test|$bc||||||"

      set_property PROGRAM.BLANK_CHECK  $bc [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]

      set_property PROGRAM.ERASE  $er [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]

      set_property PROGRAM.CFG_PROGRAM  $cp [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]

      set_property PROGRAM.VERIFY  $vr [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]

      set_property PROGRAM.CHECKSUM  $cs [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]

      
     

      if {[string match -nocase *xc*7z* $hw_fpga_name] } {
        #zynq
        
          set binfilename [TE::UTILS::prebuilt_file_location false * .bin NA $appname NA false $shortdir_int]
          set fsbl  [TE::UTILS::prebuilt_file_location false fsbl_flash .elf NA NA NA false $shortdir_int]
          if {$def_fsbl} {
            set fsbl  [TE::UTILS::prebuilt_file_location false fsbl .elf NA NA NA false $shortdir_int]
          }
          if {$erase} {
            if {![file exists ${binfilename}]} {
              set binfilename ${TE::TMP_PATH}/erase_flash.bin
              file mkdir ${TE::TMP_PATH}/
              set fp_w [open ${binfilename} "w"]
              for {set i 0} {$i < 100000} {incr i} {
                  puts $fp_w "Dummy files for erase flash only option $i"
              }
              close $fp_w
            }
          } elseif {$appname eq "" } {
            if {[catch {set binfilename [glob -join -dir ${TE::BASEFOLDER}/ *.bin]}] } {
               TE::UTILS::te_msg TE_PR-97 {CRITICAL WARNING} "*.bin is not available on ${TE::BASEFOLDER}/"
                set binfilename ""
            }
            if {[catch {set fsbl [glob -join -dir ${TE::BASEFOLDER}/ fsbl_flash.elf]}] } {
               TE::UTILS::te_msg TE_PR-98 {CRITICAL WARNING} "fsbl_flash.elf is not available on ${TE::BASEFOLDER}/"
                set fsbl ""
                if {[catch {set fsbl [glob -join -dir ${TE::BASEFOLDER}/ fsbl.elf]}] } {
                   TE::UTILS::te_msg TE_PR-98 {CRITICAL WARNING} "fsbl.elf is not available on ${TE::BASEFOLDER}/"
                    set fsbl ""
                }
            }
          } elseif {$binfilename eq "NA"} {
            TE::UTILS::te_msg TE_PR-114 {CRITICAL WARNING} "*.bin is not available in the prebuilt folder."
          }

          set return_filename ${binfilename}
          set_property PROGRAM.FILES [list "${binfilename}" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]    
          set_property PROGRAM.ZYNQ_FSBL ${fsbl} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]      
            
      } elseif {[string match -nocase *xczu* $hw_fpga_name] }  {
        #zynqmp
        
          set binfilename [TE::UTILS::prebuilt_file_location false * .bin NA $appname NA false $shortdir_int]
          set fsbl  [TE::UTILS::prebuilt_file_location false fsbl_flash .elf NA NA NA false $shortdir_int]
          if {$def_fsbl} {
            set fsbl  [TE::UTILS::prebuilt_file_location false fsbl .elf NA NA NA false $shortdir_int]
          }
          if {$erase} {
            if {![file exists ${binfilename}]} {
              set binfilename ${TE::TMP_PATH}/erase_flash.bin
              file mkdir ${TE::TMP_PATH}/
              set fp_w [open ${binfilename} "w"]
              for {set i 0} {$i < 100000} {incr i} {
                  puts $fp_w "Dummy files for erase flash only option $i"
              }
              close $fp_w
            }
          } elseif {$appname eq "" } {
            if {[catch {set binfilename [glob -join -dir ${TE::BASEFOLDER}/ *.bin]}] } {
               TE::UTILS::te_msg TE_PR-99 {CRITICAL WARNING} "*.bin is not available on ${TE::BASEFOLDER}/"
                set binfilename ""
            }
            if {[catch {set fsbl [glob -join -dir ${TE::BASEFOLDER}/ fsbl_flash.elf]}] } {
               TE::UTILS::te_msg TE_PR-100 {CRITICAL WARNING} "*.bin is not available on ${TE::BASEFOLDER}/"
                set fsbl ""
            }
          } elseif {$binfilename eq "NA"} {
            TE::UTILS::te_msg TE_PR-115 {CRITICAL WARNING} "*.bin is not available in the prebuilt folder."
          }
          set return_filename ${binfilename}
          set_property PROGRAM.FILES [list "${binfilename}" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]    
          set_property PROGRAM.ZYNQ_FSBL ${fsbl} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]      
      } elseif {[string match -nocase *xc*7* $hw_fpga_name] || [string match -nocase *xc*u* $hw_fpga_name] }  {
        #7series fpga
          set mcsfilename [TE::UTILS::prebuilt_file_location false * .mcs NA $appname NA false $shortdir_int]
          #todo integrate prm in prebuilt_file_location, but it's optional
          # set prmfilename [TE::UTILS::prebuilt_file_location false * .prm NA NA NA false $shortdir_int]
          set prmfilename ""
          if {$erase} {
            if {![file exists ${mcsfilename}]} {
              set mcsfilename ${TE::TMP_PATH}/erase_flash.mcs
              file mkdir ${TE::TMP_PATH}/
              set fp_w [open ${mcsfilename} "w"]
              for {set i 0} {$i < 100000} {incr i} {
                  puts $fp_w "Dummy files for erase flash only option $i"
              }
              close $fp_w
            }
          } elseif {$appname eq "" } {
            if {[catch {set mcsfilename [glob -join -dir ${TE::BASEFOLDER}/ *.mcs]}] } {
               TE::UTILS::te_msg TE_PR-101 {CRITICAL WARNING} "*.mcs is not available on ${TE::BASEFOLDER}/"
                set mcsfilename ""
            }
            if { ![catch {set prmfilename [glob -join -dir ${TE::BASEFOLDER}/ *.prm]}]} {
                
            }

          }  elseif {$mcsfilename eq "NA"} {
            TE::UTILS::te_msg TE_PR-116 {CRITICAL WARNING} "*.mcs is not available in the prebuilt folder."
          }
          set return_filename ${mcsfilename}
          set_property PROGRAM.FILES [list "${mcsfilename}" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]    
          set_property PROGRAM.UNUSED_PIN_TERMINATION ${tr} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
          set_property PROGRAM.PRM_FILE "${prmfilename}" [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]  
          
          
          create_hw_bitstream -hw_device [lindex [get_hw_devices $hw_fpga_name] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices $hw_fpga_name] 0]]; program_hw_devices [lindex [get_hw_devices $hw_fpga_name] 0]; refresh_hw_device [lindex [get_hw_devices $hw_fpga_name] 0];

          
      } else {
        #unkown #todo versal
        TE::UTILS::te_msg TE_PR-102 ERROR "Unknown device $hw_fpga_name . Please configure manually"
      }

      set_property PROGRAM.ADDRESS_RANGE  $ar [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]

      
      if {$appname ne "" } {
        set ltxfilename [TE::UTILS::prebuilt_file_location false * .ltx NA NA NA false $shortdir_int]
        set_property PROBES.FILE ${ltxfilename} [get_hw_devices $hw_fpga_name]
        set_property FULL_PROBES.FILE ${ltxfilename} [get_hw_devices $hw_fpga_name]
        if {[string match NA $ltxfilename]} {
          set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
          set_property FULL_PROBES.FILE "" [get_hw_devices $hw_fpga_name]
        }
      } elseif {$appname eq "" && ![catch {set ltxfilename [glob -join -dir ${TE::BASEFOLDER}/ *.ltx]}] } {
        set_property PROBES.FILE ${ltxfilename} [get_hw_devices $hw_fpga_name]
        set_property FULL_PROBES.FILE ${ltxfilename} [get_hw_devices $hw_fpga_name]
      } else {
        set_property PROBES.FILE "" [get_hw_devices $hw_fpga_name]
        set_property FULL_PROBES.FILE "" [get_hw_devices $hw_fpga_name]
      }

      program_hw_cfgmem -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
      if {[catch {after 1000; refresh_hw_device $hw_fpga_name}] } {}
      return $return_filename
    }
    # #--------------------------------
    # #--hw_program_fpga_flash: 
    # proc hw_program_fpga_flash {use_basefolder term bin appname {fname ""}} {
      # set return_filename ""
      # set partname_int ""
      # if {$fname ne ""} {
        # set partname_int "[TE::BDEF::find_partname $fname]"
      # } else {
        # set partname_int $TE::PARTNAME
      # }
      # set hw_fpga_name [hw_get_fpga $partname_int]
      # if {$bin eq "bin"} {
        # #program bin file
        # if {![catch {set return_filename [hw_set_bin_and_ltx_files $use_basefolder $appname $fname]}] } {
          # program_hw_cfgmem -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
          # TE::UTILS::te_msg TE_PR-34 INFO "Programming BIN-file finished."
          # if {[catch {after 500; refresh_hw_device $hw_fpga_name}] } {}
        # } else {
          # TE::UTILS::te_msg TE_PR-35 ERROR "Program Flash failed."
          # return -code error
        # }
      # } else {
        # #program mcs file
        # if {![catch {set return_filename [hw_set_mcs_and_ltx_files $use_basefolder $term $appname $fname]}] } {
          # if {![string equal [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]] [get_property MEM_TYPE [get_property CFGMEM_PART [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]]]] }  { create_hw_bitstream -hw_device [lindex [get_hw_devices $hw_fpga_name] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [lindex [get_hw_devices $hw_fpga_name] 0]]; program_hw_devices [lindex [get_hw_devices $hw_fpga_name] 0]; };
          # program_hw_cfgmem -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $hw_fpga_name] 0]]
          # TE::UTILS::te_msg TE_PR-36 INFO "Programming MCS-file finished."
          # if {[catch {after 500; refresh_hw_device $hw_fpga_name}] } {}
        # } else {
          # TE::UTILS::te_msg TE_PR-37 ERROR "Program Flash failed."
          # return -code error
        # }
      # }
      # return $return_filename
    # }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished programming functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  }
  
  puts "INFO:(TE) Load Vivado script finished"
}


