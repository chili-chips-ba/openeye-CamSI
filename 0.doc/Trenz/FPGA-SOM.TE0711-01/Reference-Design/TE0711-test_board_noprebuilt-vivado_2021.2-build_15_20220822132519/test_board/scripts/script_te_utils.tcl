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
# -- $Date: 2016/02/04 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2017/05/18  | $Author: Hartfiel, John
# -- - miscellaneous
# ------------------------------------------
# -- $Date:  2017/09/07  | $Author: Hartfiel, John
# -- - add new document history style
# -- - changed modify bd priority
# -- - bugfix to remove all properties
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2017/09/13  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2017/09/21  | $Author: Hartfiel, John
# -- - add TE::UTILS::create_prebuilt_report
# ------------------------------------------
# -- $Date:  2017/09/25  | $Author: Hartfiel, John
# -- - Bugfix TE::UTILS::search_hdl_files
# ------------------------------------------
# -- $Date: 2017/10/04  | $Author:Pohl, Zdenek
# -- - incremented te_msg counter for TE_SDSOC to reflect
# --   changes in script_sdsoc.tcl
# ------------------------------------------
# -- $Date: 2017/10/13  | $Author:Pohl, Zdenek
# -- - add catch block to tcl export commant 
# ------------------------------------------
# -- $Date:  2017/11/23  | $Author: Hartfiel, John
# -- - disable delete SDSoC Basefolder in clean_all_generated_files
# ------------------------------------------
# -- $Date:  2017/12/08  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2017/12/12  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2018/01/05  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2018/01/08  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2018/01/11  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2018/01/12  | $Author: Hartfiel, John
# -- - add Dos2Unix
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2018/01/15  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2018/03/14  | $Author: Hartfiel, John
# -- - search_hdl_files add folder search on vhd/folder
# ------------------------------------------
# -- $Date:  2018/03/26  | $Author: Hartfiel, John
# -- - add copy_prod_export {boot app} for production export
# -- - rise te_msg cnt
# -- - changed readme_file_location.txt  to file_location.txt 
# ------------------------------------------
# -- $Date:  2018/05/08  | $Author: Hartfiel, John
# -- - add regex_map
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2018/05/16  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2018/05/22  | $Author: Hartfiel, John
# -- - add revision search sub folder on: search_bd_files
# -- - changed export path of copy_prod_export
# ------------------------------------------
# -- $Date:  2018/05/23  | $Author: Hartfiel, John
# -- - changed txt file content: search_bd_files
# ------------------------------------------
# -- $Date:  2018/06/19  | $Author: Kohout, Lukas
# -- - add procedure TE::UTILS::get_host_os
# -- - te_msg counts updated
# -- - te_msg numbers fixed
# ------------------------------------------
# -- $Date:  2018/07/05  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2018/07/10  | $Author: Hartfiel, John
# -- - add comments
# -- - add findFiles recursive
# -- - modify search_elf_files with findFiles
# ------------------------------------------
# -- $Date:  2018/09/18  | $Author: Hartfiel, John
# -- - modify namespace of findFiles
# ------------------------------------------
# -- $Date:  2018/11/16  | $Author: Hartfiel, John
# -- -add additional sd content to copy_prod_export (/misc/sd)
# ------------------------------------------
# -- $Date:  2018/11/22  | $Author: Hartfiel, John
# -- -copy_prod_export, add second note for qspi flash
# ------------------------------------------
# -- $Date:  2018/11/23  | $Author: Hartfiel, John
# -- -copy_prod_export bugfix sd content file names
# ------------------------------------------
# -- $Date:  2018/11/26  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2019/02/12  | $Author: Hartfiel, John
# -- - rise te_msg cnt, add prebuilt_file_location
# -- - updated create_prebuilt_report with prebuilt_file_location, create_prebuilt_report
# -- - add mod_configfile, print_boardlist
# -- - rework search_bd_files --> search for revision folder from first REV parameter
# ------------------------------------------
# -- $Date:  2019/02/14  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2019/03/14  | $Author: Hartfiel, John
# -- - add clean_prebuilt_sw_single
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2019/04/08  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2019/05/29  | $Author: Hartfiel, John
# -- -copy_prod_export, bugfix readme export
# ------------------------------------------
# -- $Date:  2019/06/21  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2019/07/25  | $Author: Hartfiel, John
# -- -copy_prod_export,  absolute or relative path possible
# ------------------------------------------
# -- $Date:  2019/08/21  | $Author: Hartfiel, John
# -- -mod_configfile,  changes for internal usage only
# ------------------------------------------
# -- $Date:  2019/09/13  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2019/10/28  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# -- - add search_tcl_ip_files
# ------------------------------------------
# -- $Date:  2019/12/10  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# -- - hdf/xsa export 
# -- - generate_workspace_hsi, generate_workspace_sdk, copy_hw_files, copy_sw_files
# -- - setinfo_to_block_design_tcl add additional version control
# ------------------------------------------
# -- $Date:  2019/12/18  | $Author: Hartfiel, John
# -- -  replace filename variable  VPROJ_NAME with PB_FILENAME
# ------------------------------------------
# -- $Date:  2020/01/06  | $Author: Hartfiel, John
# -- -  add get_bd_vivado_version
# ------------------------------------------
# -- $Date:  2020/01/09  | $Author: Hartfiel, John
# -- -  add read_board_select write_board_select copy_user_export
# ------------------------------------------
# -- $Date:  2020/01/13  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# -- -  add vitis_z_bif and vitis_zmp_bif
# -- -  copy_sw_files --> skip u-boot, bl31.elf
# ------------------------------------------
# -- $Date:  2020/01/31  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# -- - add clean temp, binary and backup folder
# ------------------------------------------
# -- $Date:  2020/02/05  | $Author: Hartfiel, John
# -- -  copy_sw_files --> skip resources folder(is copy from prebuilt for linux)
# ------------------------------------------
# -- $Date:  2020/02/05  | $Author: Hartfiel, John
# -- -  setinfo_to_block_design_tcl version remove patch version number
# ------------------------------------------
# -- $Date:  2020/03/02  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2020/03/06  | $Author: Hartfiel, John
# -- - copy_user_export add bitstrean
# ------------------------------------------
# -- $Date:  2020/04/07  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2020/06/30  | $Author: Hartfiel, John
# -- -  add prod_config, modify copy_user_export
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2020/07/10  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# -- - add search_xrt_files
# ------------------------------------------
# -- $Date:  2020/09/23  | $Author: Hartfiel, John
# -- - setinfo_to_block_design_tcl modified to use exported tcl without TE scripts
# ------------------------------------------
# -- $Date:  2020/12/15  | $Author: Hartfiel, John
# -- - add board store to  mod_configfile 
# ------------------------------------------
# -- $Date:  2020/12/18  | $Author: Hartfiel, John
# -- - modify_block_design_add_designprops bugfix, change comment order 
# ------------------------------------------
# -- $Date:  2020/12/23  | $Author: Hartfiel, John
# -- - copy_sw_files add additional ignore elf 
# ------------------------------------------
# -- $Date:  2021/02/13  | $Author: Hartfiel, John
# -- - add generate_workspace_petalinux
# ------------------------------------------
# -- $Date:  2021/02/17  | $Author: Hartfiel, John
# -- - modify vitis_z_bif vitis_zmp_bif for multi file extention
# ------------------------------------------
# -- $Date:  2021/03/09  | $Author: Hartfiel, John
# -- - rise te_msg cnt
# ------------------------------------------
# -- $Date:  2021/04/20  | $Author: Hartfiel, John
# -- - print_boardlist add TBD as ignore files
# ------------------------------------------
# -- $Date:  2021/07/13  | $Author: Hartfiel, John
# -- - prod_config add possibility to use wildcard in prod_cfg_list.csv
# ------------------------------------------
# -- $Date:  2021/11/30  | $Author: Hartfiel, John
# -- - extend vitis_z_bif and vitis_zmp_bif  with uboot.dtb and boot.scr option
# -- - extend prebuilt_file_location  with uboot.dtb and boot.scr option
# -- - update te_msg cnt
# ------------------------------------------
# ------------------------------------------
# -- $Date:  2021/12/12  | $Author: Hartfiel, John
# -- - update te_msg cnt
# ------------------------------------------
# -- $Date:  2021/12/13  | $Author: Hartfiel, John
# -- - add write_zip_info print_zip_info
# ------------------------------------------
# -- $Date:  2021/12/14  | $Author: Hartfiel, John
# -- - add write_zip_info add version number
# -- - update te_msg cnt and petalinx
# ------------------------------------------
# -- $Date:  2021/12/17  | $Author: Hartfiel, John
# -- - update te_msg cnt 
# ------------------------------------------
# -- $Date:  2022/01/06  | $Author: Hartfiel, John
# -- - update te_msg cnt 
# ------------------------------------------
# -- $Date:  2022/01/11  | $Author: Hartfiel, John
# -- - update te_msg cnt 
# ------------------------------------------
# -- $Date:  2022/01/20  | $Author: Hartfiel, John
# -- - update te_msg cnt 
# ------------------------------------------
# -- $Date:  2022/01/27..28  | $Author: Hartfiel, John
# -- - update te_msg cnt 
# ------------------------------------------
# -- $Date:  2022/02/07  | $Author: Hartfiel, John
# -- - notes prod_config
# -- - update te_msg cnt 
# ------------------------------------------
# -- $Date:  2022/02/09  | $Author: Hartfiel, John
# -- - te_msg modify backup messages in case of error
# ------------------------------------------
# -- $Date:  2022/02/11  | $Author: Hartfiel, John
# -- - removed copy_user_export  and prod_config
# ------------------------------------------
# -- $Date:  2022/04/26  | $Author: Hartfiel, John
# -- -  update te_msg cnt 
# ------------------------------------------
# -- $Date:  2022/05/06  | $Author: Hartfiel, John
# -- -  update te_msg cnt 
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# --------------------------------------------------------------------
namespace eval ::TE {
  namespace eval UTILS {
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # report functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--------------------------------
    #--te_msg: 
    proc te_msg {vmsg_id  vmsg_sev vmsg_msg} {
      # vmsg_id: TE_INIT, TE_UT, TE_EXT, TE_BD, TE_HW, TE_SW, TE_PR 
      #last vmsg_nr:
        #TE_INIT 245        -> TE initialization
        #TE_UTIL 172        -> TE utilities
        #TE_EXT 35          -> External
        #TE_PS 1            -> PS modification 0,1-> external tcl-scripts with settings!
        #TE_BD 29           -> Block Design
        #TE_HW 97           -> HW Design
        #TE_SW 113           -> SW Design
        #TE_PR 116          -> Programming
        #TE_PLX 28           -> Petalinux
        #TE_SDSoC 34        -> SDSoC
      # vmsg_sev: STATUS, INFO, WARNING, {CRITICAL WARNING}, ERROR 
      # set vmsg_id TE_DEF;set vmsg_sev STATUS;set vmsg_msg "Info";
      # common::send_msg_id "$vmsg_id" $vmsg_sev $vmsg_msg

      if {[catch {common::send_msg_id "$vmsg_id" $vmsg_sev $vmsg_msg}] } {
        puts "${vmsg_sev}: ($vmsg_id) $vmsg_msg"
        if {[string match -nocase "ERROR" $vmsg_msg] } {
          return -code error
        }
      }
      #Info: Do not start Text with: --
      #TE::UTILS::te_msg TE_INIT-2 WARNING "SDK settings are overwritten by SDSOC settings."
      #TE::UTILS::te_msg TE_INIT-0 INFO "Script Info: \n \
      #  ------"
      
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished report functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # search source files functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--search_bd_files: search in TE::BD_PATH for *.tcl files return list
    proc search_xrt_files {} { 
      set xrt_vivado []
      if { [catch {set xrt_vivado [glob -join -dir ${TE::XRT_PATH}/xilinx *.tcl]}] } {
         set xrt_vivado []
      } else {
        foreach xrt_f $xrt_vivado {
          file copy -force $xrt_f ${TE::VPROJ_PATH}
        }
      }

      set xrt_files []
      if { [catch {set xrt_files [glob -join -dir $TE::XRT_PATH *_extention.tcl]}] } {
         set xrt_files []
      }
      
      return $xrt_files
    }
    #--------------------------------
    #--search_bd_files: search in TE::BD_PATH for *.tcl files return list
    proc search_bd_files {} {
      # search for block design for the board part only  (folder with tcl must exist, otherwise base BD_Path is used!)
      #currently only on bd.tcl is allowed
      set bd_files []
      if { [catch {set bd_files [glob -join -dir ${TE::BD_PATH}/${TE::SHORTDIR} *.tcl]}] } {
        #search for revision folder only 
        set revDir [lindex [split ${TE::PCB_REV} "|"] 0]
        if { [catch {set bd_files [glob -join -dir ${TE::BD_PATH}/${revDir} *.tcl]}] } {
         #search  base folder
          if { [catch {set bd_files [glob -join -dir ${TE::BD_PATH}/ *.tcl]}] } {
            #check current project
            if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
              TE::UTILS::te_msg TE_UTIL-0 WARNING "No external Block-Design Export was found in ${TE::BD_PATH}, start vivado without bd-design"
            } else {
              TE::UTILS::te_msg TE_UTIL-1 WARNING "No external Block-Design Export was found, use current Vivado project Block-Designs from:${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ ."
            }
          } 
        } 
      }
      set bd_names ""
      foreach bd $bd_files {
        set bd_names "$bd_names $bd \n"
      }
      TE::UTILS::te_msg TE_UTIL-2 INFO "Following block designs were found: \n \
        $bd_names \
        ------"
      if {!$TE::BD_MULTI} {
        if {[llength $bd_files]>1 } {
            TE::UTILS::te_msg TE_UTIL-3 WARNING "Currently only one Block-Design is supported with TE-scripts, deleted or rename file-extension from unused *.tcl in ${TE::BD_PATH} or ${TE::BD_PATH}/${TE::SHORTDIR}."
            return -code error "Currently only one Block-Design is supported with TE-scripts, deleted or rename file-extension from unused *.tcl in ${TE::BD_PATH} or ${TE::BD_PATH}/${TE::SHORTDIR}."
        }
      }
      return $bd_files
    }
    #--------------------------------
    #--search_xdc_files: search in TE::XDC_PATH for *xdc files return list
    proc search_xdc_files {} {
      # search for xdc file if bord part folder exist, this used too
      set xdc_files []
      set base_xdc_files []
      set bp_xdc_files []
      if { [catch {set base_xdc_files [ glob $TE::XDC_PATH/*.xdc ] }] } {
        TE::UTILS::te_msg TE_UTIL-4 WARNING "*.xdc search: ${TE::XDC_PATH}/ is empty."
      }
      if {[file exists ${TE::XDC_PATH}/${TE::SHORTDIR}/]} {
        if { [catch {set bp_xdc_files [ glob $TE::XDC_PATH/${TE::SHORTDIR}/*.xdc ] }] } {
          TE::UTILS::te_msg TE_UTIL-5 WARNING "*.xdc search: ${TE::XDC_PATH}/${TE::SHORTDIR}/ is empty."
        }
        #generate empty target xdc for gui constrains
        if { ![file exists ${TE::XDC_PATH}/${TE::SHORTDIR}/vivado_target.xdc]} {
          TE::UTILS::te_msg TE_UTIL-6 INFO "Generate ${TE::XDC_PATH}/${TE::SHORTDIR}/vivado_target.xdc"
          close [ open ${TE::XDC_PATH}/${TE::SHORTDIR}/vivado_target.xdc w ]
          lappend bp_xdc_files ${TE::XDC_PATH}/${TE::SHORTDIR}/vivado_target.xdc
        }
        set xdc_files [concat $base_xdc_files $bp_xdc_files]
      } else {
        set xdc_files $base_xdc_files
        #generate empty target xdc for gui constrains
        if { ![file exists ${TE::XDC_PATH}/vivado_target.xdc]} {
          TE::UTILS::te_msg TE_UTIL-7 INFO "Generate ${TE::XDC_PATH}/vivado_target.xdc"
          close [ open ${TE::XDC_PATH}/vivado_target.xdc w ]
          lappend xdc_files ${TE::XDC_PATH}/vivado_target.xdc
        }
      }

      set xdc_names ""
      foreach xdc $xdc_files {
        set xdc_names "$xdc_names $xdc \n"
      }
      TE::UTILS::te_msg TE_UTIL-8 INFO "Following xdc files were found: \n \
        $xdc_names \
        ------"

      return $xdc_files
    }
    #--------------------------------
    #--search_xci_files: search in TE::HDL_PATH for *.xci files return list
    proc search_xci_files {} {
      set xci_files [list]
      set xci_files_main [list]
      set xci_files_sub [list]
      catch {set xci_files_main [glob -join -dir $TE::HDL_PATH/xci/ *.xci]}
      catch {set xci_files_sub [glob -join -dir $TE::HDL_PATH/xci/${TE::SHORTDIR}/ *.xci]}
      set xci_files [concat $xci_files_main $xci_files_sub]
      set xci_names ""
      foreach xci_f $xci_files {
        set xci_names "$xci_names $xci_f \n"
      }
      TE::UTILS::te_msg TE_UTIL-9 INFO "Following xci files were found: \n \
        $xci_names \
        ------"
        
      return $xci_files
    }
    #--------------------------------
    #--search_tcl_ip_files: search in TE::HDL_PATH for *_preset.tcl files return list
    proc search_tcl_ip_files {} {
      set tclip_files [list]
      set tclip_files_main [list]
      set tclip_files_sub [list]
      catch {set tclip_files_main [glob -join -dir $TE::HDL_PATH/tcl/ *_preset.tcl]}
      catch {set tclip_files_sub [glob -join -dir $TE::HDL_PATH/tcl/${TE::SHORTDIR}/ *_preset.tcl]}
      set tclip_files [concat $tclip_files_main $tclip_files_sub]
      set tclip_names ""
      foreach xci_f $tclip_files {
        set tclip_names "$tclip_names $xci_f \n"
      }
      TE::UTILS::te_msg TE_UTIL-146 INFO "Following TCL IP files were found: \n \
        $tclip_names \
        ------"
        
      return $tclip_files
    }
    #--------------------------------
    #--search_elf_files: search in TE::FIRMWARE_PATH for *.elf files return list
    proc search_elf_files {} {
      set elf_files_sub [list]
      
      set elf_files_sub [findFiles ${TE::FIRMWARE_PATH} "*.elf"]
      
      set elf_names ""
      foreach elf_f $elf_files_sub {
        set elf_names "$elf_names $elf_f \n"
      }
      TE::UTILS::te_msg TE_UTIL-10 INFO "Following elf files were found: \n \
        $elf_names \
        ------"
        
      return $elf_files_sub
    }
    #--------------------------------
    #--search_hdl_files: search in TE::HDL_PATH for *.vhd and *.v files return list
    proc search_hdl_files {} {
      set hdl_files [list]
      set vhd_files [list]
      set vhd_files_grp1 [list]
      set vhd_files_grp2 [list]
      set vhd_files_sub1 [list]
      set vhd_files_sub2 [list]
      set v_files [list]
      set v_files_grp1 [list]
      set v_files_grp2 [list]
      set v_files_sub1 [list]
      set v_files_sub2 [list]
      set sv_files [list]
      set sv_files_grp1 [list]
      set sv_files_grp2 [list]
      set sv_files_sub1 [list]
      set sv_files_sub2 [list]
      catch {set vhd_files [glob -join -dir ${TE::HDL_PATH} *.vhd]}
      catch {set vhd_files_grp1 [glob -join -dir ${TE::HDL_PATH}/folder *.vhd]}
      catch {set vhd_files_grp2 [glob -join -dir ${TE::HDL_PATH}/folder/ */*.vhd]}
      catch {set vhd_files_sub1 [glob -join -dir ${TE::HDL_PATH}/${TE::SHORTDIR}/ *.vhd]}
      catch {set vhd_files_sub2 [glob -join -dir ${TE::HDL_PATH}/${TE::SHORTDIR}/ */*.vhd]}
      catch {set v_files [glob -join -dir ${TE::HDL_PATH} *.v]}
      catch {set v_files_grp1 [glob -join -dir ${TE::HDL_PATH}/folder *.v]}
      catch {set v_files_grp2 [glob -join -dir ${TE::HDL_PATH}/folder/ */*.v]}
      catch {set v_files_sub1 [glob -join -dir ${TE::HDL_PATH}/${TE::SHORTDIR}/ *.v]}
      catch {set v_files_sub2 [glob -join -dir ${TE::HDL_PATH}/${TE::SHORTDIR}/ */*.v]}
      catch {set sv_files [glob -join -dir ${TE::HDL_PATH} *.sv]}
      catch {set sv_files_grp1 [glob -join -dir ${TE::HDL_PATH}/folder *.sv]}
      catch {set sv_files_grp2 [glob -join -dir ${TE::HDL_PATH}/folder/ */*.sv]}
      catch {set sv_files_sub1 [glob -join -dir ${TE::HDL_PATH}/${TE::SHORTDIR}/ *.sv]}
      catch {set sv_files_sub2 [glob -join -dir ${TE::HDL_PATH}/${TE::SHORTDIR}/ */*.sv]}
      set hdl_files [concat $vhd_files $vhd_files_grp1 $vhd_files_grp2 $vhd_files_sub1 $vhd_files_sub2 $v_files $v_files_grp1 $v_files_grp2 $v_files_sub1 $v_files_sub2 $sv_files $sv_files_grp1 $sv_files_grp2 $sv_files_sub1 $sv_files_sub2]

      set hdl_names ""
      foreach hdl_f $hdl_files {
        set hdl_names "$hdl_names $hdl_f \n"
      }
      TE::UTILS::te_msg TE_UTIL-11 INFO "Following hdl files were found: \n \
        $hdl_names \
        ------"
      
      return $hdl_files
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished search source files functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # modify block design functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--setinfo_to_block_design_tcl:
    proc get_bd_vivado_version {} {
      set bdfiles [TE::UTILS::search_bd_files]
      set file_data [list]
      set bd_version NA
      if {[llength $bdfiles] > 0 } {
        foreach file_name $bdfiles {
            #read file to string list
          set fp_r [open ${file_name} "r"]
          set file_data [read $fp_r]
          close $fp_r
        }
        set data [split $file_data "\n"]
        foreach line $data {
          if {[string match "*set scripts_vivado_version*" $line]} {
            set bd_version [split $line " "]
            set bd_version [lindex $bd_version 2]
            break;
          }
        }
      }
      return $bd_version
    }
    #--setinfo_to_block_design_tcl:
    proc setinfo_to_block_design_tcl {datalist mod_file} {
      TE::UTILS::te_msg TE_UTIL-12 INFO "Block Design tcl: info lines were added."
      set scriptversion "[lindex [split [version -short ] "."]  0].[lindex [split [version -short ] "."]  1]"
      
      set data $datalist
      set data [linsert $data[set data {}] 0 "\}"]
      set data [linsert $data[set data {}] 0 " return 1"]
      set data [linsert $data[set data {}] 0 "   catch \{common::send_msg_id \"BD_TCL-109\" \"ERROR\" \"This script was generated using Vivado < \$scripts_vivado_version> and is being run in < \$current_vivado_version> of Vivado. Please run the script in Vivado < \$scripts_vivado_version> then open the design in Vivado < \$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script.\"\}"]
      set data [linsert $data[set data {}] 0 "   puts \"\""]
      set data [linsert $data[set data {}] 0 "if \{ \[string first \$scripts_vivado_version \$current_vivado_version\] == -1 &&  \$TE::VERSION_CONTROL \} \{"]
      set data [linsert $data[set data {}] 0 "set current_vivado_version \[version -short \]"]
      set data [linsert $data[set data {}] 0 "set scripts_vivado_version $scriptversion"]
      set data [linsert $data[set data {}] 0 "################################################################"]
      set data [linsert $data[set data {}] 0 "# Check if script is running in correct Vivado version."]
      set data [linsert $data[set data {}] 0 "################################################################"]
      set data [linsert $data[set data {}] 0 "\}"]
      set data [linsert $data[set data {}] 0 "  \}"]
      set data [linsert $data[set data {}] 0 "    set ::TE::VERSION_CONTROL true"]
      set data [linsert $data[set data {}] 0 "  namespace eval ::TE  \{"]
      set data [linsert $data[set data {}] 0 "if \{ !\[info exist TE::VERSION_CONTROL\] \} \{"]
      set data [linsert $data[set data {}] 0 ""]
      
      if {$mod_file} {
        # set data [linsert $data[set data {}] 0 "puts \"Info:(TE) This block design file has been modified. Modifications labelled with comment tag  # #TE_MOD# on the Block-Design tcl-file.\""]
        set data [linsert $data[set data {}] 0 "catch \{TE::UTILS::te_msg TE_BD-1 INFO \"This block design tcl-file was modified by TE-Scripts. Modifications are labelled with comment tag  # #TE_MOD# on the Block-Design tcl-file.\"\}"]
      }
      # set data [linsert $data[set data {}] 0 "puts \"Info:(TE) This block design file has been exported with Reference-Design Scripts from Trenz Electronic GmbH for Board Part:${TE::BOARDPART} with FPGA ${TE::PARTNAME} at [ clock format [clock seconds] -format "%Y-%m-%dT%H:%M:%S"].\""]
      set data [linsert $data[set data {}] 0 "catch \{TE::UTILS::te_msg TE_BD-0 INFO \"This block design tcl-file was generate with Trenz Electronic GmbH Board Part:${TE::BOARDPART}, FPGA: ${TE::PARTNAME} at [ clock format [clock seconds] -format "%Y-%m-%dT%H:%M:%S"].\"\}"]
     
      return $data
    }
    #--------------------------------
    #--modify_block_design_tcl: load and save block design tcl (sub functions used for modifications) 
    proc modify_block_design_tcl {file_name mod_file} {
      TE::UTILS::te_msg TE_UTIL-13 STATUS "Open bd design export [file tail [file rootname $file_name]]"
      #read file to string list
      set fp_r [open ${file_name} "r"]
      set file_data [read $fp_r]
      close $fp_r
      
      set data [split $file_data "\n"]
      
      #modify list elements ()
      if {$mod_file} {
        if {[catch {set data [modify_block_design_commentlines $data]} result]} { TE::UTILS::te_msg TE_UTIL-14 ERROR "Script (TE::UTILS::modify_block_design_commentlines) failed: $result."; return -code error}
        if {[catch {set data [modify_block_design_add_lines $data]} result]} { TE::UTILS::te_msg TE_UTIL-15 ERROR "Script (TE::UTILS::modify_block_design_add_lines) failed: $result."; return -code error}
        if {[catch {set data [modify_block_design_commentdesignprops $data]} result]} { TE::UTILS::te_msg TE_UTIL-16 ERROR "Script (TE::UTILS::modify_block_design_commentdesignprops) failed: $result."; return -code error}
        if {[catch {set data [modify_block_design_add_designprops $data]} result]} { TE::UTILS::te_msg TE_UTIL-17 ERROR "Script (TE::UTILS::modify_block_design_add_designprops) failed: $result."; return -code error}
      }
      # write info header
       if {[catch {set data [TE::UTILS::setinfo_to_block_design_tcl $data $mod_file]} result]} { TE::UTILS::te_msg TE_UTIL-18 ERROR "Script (TE::UTILS::setinfo_to_block_design_tcl) failed: $result."; return -code error}
      #write all list elements to file
      set fp_w [open ${file_name} "w"]
      foreach line $data {
        puts $fp_w $line
      }
      close $fp_w
    } 
    #--------------------------------
    #--modify_block_design_commentlines: 
    proc modify_block_design_commentlines {datalist} {
      #data=tcl content
      set data $datalist
      #modify list elements
      set line_index -1
      set mod_count 0
      foreach line $data {
        incr line_index
        foreach cname $TE::BD_MOD_COMMENT {
          set line_check [lindex $cname 1]
          #comment lines on tcl file, modified lines are ignored
          if {[string match $line_check $line]  && ![string match *#TE_MOD#* $line]} {
            set data [lreplace $data[set data {}] $line_index $line_index "# #TE_MOD# $line"]
            incr mod_count
          }
        }
      }
      TE::UTILS::te_msg TE_UTIL-19 INFO "Block Design tcl: $mod_count lines were commented out."
      return $data
    }
    #--------------------------------
    #--modify_block_design_commentdesignprops: 
    proc modify_block_design_commentdesignprops {datalist} {
      #data=tcl content
      set data $datalist
      #modify list elements
      set mod_count 0
      foreach cname $TE::BD_MOD_PCOMMENT {
        set prop_start_name "set_property -dict"
        #get instant name
        set inst_name [lindex $cname 1]
        set prop_stop_name  "\] \$$inst_name"
        #modify list elements
        set line_index -1
        set prop_start -1
        set prop_stop -1
        #search for property boundaries
        foreach line $data {
          incr line_index
          if {[string match *$prop_start_name* $line] && ![string match *#TE_MOD#* $line]} {
            set prop_start $line_index
          }
          if {[string match *$prop_stop_name $line] && ![string match *#TE_MOD#* $line]} {
            set prop_stop $line_index
            break;
          }
        }
        #only if component found
        if {$prop_start>=0 && $prop_stop>$prop_start} {
          
          set removed_items [list]
          set item_cnt -1
          #removed items
          foreach item $cname {
            incr item_cnt
            #ignore id and line_check
            if {$item_cnt>1} {
              set i $prop_stop
              while {$i > $prop_start+1} {
                set i [expr $i-1]
                set newline "[lindex $data $i]"
                if {[string match *$item* $newline] && ![string match *#TE_MOD#* $newline]} {
                  lappend removed_items "# #TE_MOD# $newline"
                  set data [lreplace $data[set data {}] $i $i]
                  incr mod_count
                }
              }
            }
          }
          # if all properties are removed, clear empty property container
          if {[expr $prop_stop-($prop_start+1)]==[llength $removed_items]} {
            set tmp "# #TE_MOD# [lindex $data $prop_start]"
            set data [lreplace $data[set data {}] $prop_start $prop_start $tmp]
            set tmp "# #TE_MOD# [lindex $data [expr $prop_start+1]]"
            set data [lreplace $data[set data {}] [expr $prop_start+1] [expr $prop_start+1] $tmp]
          }
          #add removed items as comment after the component list
          set inserpos [expr $prop_stop + 2 - [llength $removed_items]]
          set data [linsert $data[set data {}] $inserpos "# #TE_MOD# #Empty Line"]  
          # foreach el [lreverse $removed_items] { 
            # set data [linsert $data[set data {}] $inserpos $el]  
          # }
          foreach el  $removed_items { 
            set data [linsert $data[set data {}] $inserpos $el]  
          }
        }
      }
      TE::UTILS::te_msg TE_UTIL-20 INFO "Block Design tcl: $mod_count properties were commented out."
      return $data
    }
    #--------------------------------
    #--modify_block_design_add_lines: 
    proc modify_block_design_add_lines {datalist} {
      #data=tcl content
      set data $datalist
      #modify list elements
      set line_index -1
      set mod_count 0
      foreach cname $TE::BD_MOD_ADD {
        set line_check [lindex $cname 1]
        set line_index -1
        foreach line $data {
          incr line_index
          #add lines on tcl file, modified lines are ignored
          if {[string match $line_check $line]  && ![string match *#TE_MOD#* $line]} {
            # set data [lreplace $data[set data {}] $line_index $line_index "# #TE_MOD# $line"]
            set data [linsert $data[set data {}] [expr $line_index+1]  "# #TE_MOD#_Add next line#"]
            set data [linsert $data[set data {}] [expr $line_index+2]  [lindex $cname 2]]
            incr mod_count
            break
          }
        }
      }
      TE::UTILS::te_msg TE_UTIL-21 INFO "Block Design tcl: $mod_count lines were added."
      return $data
    }
    #--------------------------------
    #--modify_block_design_add_designprops: 
    proc modify_block_design_add_designprops {datalist} {
      #data=tcl content
      set data $datalist
      #modify list elements
      set mod_count 0
      foreach cname $TE::BD_MOD_PADD {
        #get instant name
        set inst_name [lindex $cname 1]
        set prop_stop_name  "\] \$$inst_name"
        #modify list elements
        set line_index -1
        set prop_start -1
        set prop_stop -1
        set all_props_removed -1
        #search for property boundaries
        foreach line $data {
          incr line_index
          if {[string match *$prop_stop_name $line]} {
            if {![string match *#TE_MOD#* $line] } {
              set prop_stop $line_index
            } else {
              set all_props_removed $line_index
            }
            break;
          }
        }
        #if component props found
        if {$prop_stop>-1} {
          #add removed items as comment after the component list
          set inserpos [expr $prop_stop + 1]
          set el_index -1
          #add property as comment
          foreach el $cname { 
            incr el_index
            #ignore id and line_check
            if {$el_index>1} {
              set data [linsert $data[set data {}] $inserpos "# #TE_MOD#_add_property# $el"]  
            }
          }
          #add property
          set inserpos [expr $prop_stop + -1]
          set el_index -1
          foreach el $cname { 
            incr el_index
            #ignore id and line_check
            if {$el_index>1} {
              set data [linsert $data[set data {}] $inserpos "$el \\"]  
              incr mod_count
            }
          }
        } elseif {$all_props_removed>-1} {
          #add removed items as comment after the component list
          set inserpos [expr $all_props_removed + 1]
          set el_index -1
          #add property as comment
          foreach el $cname { 
            incr el_index
            #ignore id and line_check
            if {$el_index>1} {
              set data [linsert $data[set data {}] $inserpos "# #TE_MOD#_add_property# $el"]  
            }
          }
          #add property
          set inserpos [expr $all_props_removed + 1]
          set el_index -1
          set data [linsert $data[set data {}] $inserpos "  set_property -dict \[ list \\"]  
          incr inserpos
          foreach el $cname { 
            incr el_index
            #ignore id and line_check
            if {$el_index>1} {
              set data [linsert $data[set data {}] $inserpos "$el \\"]  
              incr inserpos
              incr mod_count
            }
          }
          set data [linsert $data[set data {}] $inserpos " \] \$[lindex $cname 1]"]  
        }
      }
      TE::UTILS::te_msg TE_UTIL-22 INFO "Block Design tcl: $mod_count properties were added."
      return $data
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished modify block design functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # generate workspace functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--workspace_info: 
    proc workspace_info {infofile info} {
      set report_file ${infofile}
      set fp_w [open ${report_file} "w"]
      puts $fp_w "$info"
      close $fp_w
    }
    #--------------------------------
    #--generate_workspace_hsi: 
    proc generate_workspace_hsi {{fname ""}} {
      # if {$fname eq ""} {
      # #use generated vivado data for workspace
        # if {[file exists ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa]} {
          # file mkdir ${TE::WORKSPACE_HSI_PATH}/
          # file copy -force ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa ${TE::WORKSPACE_HSI_PATH}/${TE::PB_FILENAME}.xsa
          # workspace_info "${TE::WORKSPACE_PATH}/hsi_info.txt" "HSI Data used from ${TE::VPROJ_PATH}"
        # } else {TE::UTILS::te_msg TE_UTIL-148 WARNING "${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa not found."}
        # if {[file exists ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.hdf]} {
          # file mkdir ${TE::WORKSPACE_HSI_PATH}/
          # file copy -force ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.hdf ${TE::WORKSPACE_HSI_PATH}/${TE::PB_FILENAME}.hdf
          # workspace_info "${TE::WORKSPACE_PATH}/hsi_info.txt" "HSI Data used from ${TE::VPROJ_PATH}"
        # } else {TE::UTILS::te_msg TE_UTIL-23 STATUS "${TE::VPROJ_PATH}/${TE::PB_FILENAME}.hdf not found (not longer needed, use xsa)."}
      # } else {
        # #use prebuilt data for workspace
        # set shortname "[TE::BDEF::find_shortdir $fname]"
        # if {[file exists ${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.xsa]} {
          # file mkdir ${TE::WORKSPACE_HSI_PATH}/
          # file copy -force ${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.xsa ${TE::WORKSPACE_HSI_PATH}/${TE::PB_FILENAME}.xsa
          # workspace_info "${TE::WORKSPACE_PATH}/hsi_info.txt" "HSI Data used from  ${TE::PREBUILT_HW_PATH}/${shortname}"
        # } else {TE::UTILS::te_msg TE_UTIL-147 WARNING "${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.xsa not found."}
        # if {[file exists ${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.hdf]} {
          # file mkdir ${TE::WORKSPACE_HSI_PATH}/
          # file copy -force ${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.hdf ${TE::WORKSPACE_HSI_PATH}/${TE::PB_FILENAME}.hdf
          # workspace_info "${TE::WORKSPACE_PATH}/hsi_info.txt" "HSI Data used from  ${TE::PREBUILT_HW_PATH}/${shortname}"
        # } else {TE::UTILS::te_msg TE_UTIL-24 STATUS "${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.hdf not found (not longer needed use xsa)."}
      # }
    }    
    #--------------------------------
    #--generate_workspace_sdk:     
    proc generate_workspace_sdk {{fname ""}} {
      #todo mal schauen ob vorher gelöcht werden muss oder ob überschreiben reicht
      if {$fname eq ""} {
        #use generated vivado data for workspace
        if {[file exists ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa]} {
           file mkdir ${TE::WORKSPACE_SDK_PATH}/
           #use Toplevelname instead of Project name -> export from Vivado GUI can used to 
           file copy -force ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa ${TE::WORKSPACE_SDK_PATH}/${TE::PB_FILENAME}.xsa
            workspace_info "${TE::WORKSPACE_PATH}/sdk_info.txt" "SDK Data used from ${TE::VPROJ_PATH}"
        } else {
           if {[catch {TE::VIV::write_platform} result]} {TE::UTILS::te_msg TE_UTIL-25 WARNING "${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa not found."}
           file mkdir ${TE::WORKSPACE_SDK_PATH}/
           #use Toplevelname instead of Project name -> export from Vivado GUI can used to 
           file copy -force ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa ${TE::WORKSPACE_SDK_PATH}/${TE::PB_FILENAME}.xsa
            workspace_info "${TE::WORKSPACE_PATH}/sdk_info.txt" "SDK Data used from ${TE::VPROJ_PATH}"
        }
      } else {
        #use prebuilt data for workspace
        set shortname "[TE::BDEF::find_shortdir $fname]"
        if {[file exists ${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.xsa]} {
          file mkdir ${TE::WORKSPACE_SDK_PATH}/
          file copy -force ${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.xsa ${TE::WORKSPACE_SDK_PATH}/${TE::PB_FILENAME}.xsa
          workspace_info "${TE::WORKSPACE_PATH}/sdk_info.txt" "SDK Data used from  ${TE::PREBUILT_HW_PATH}/${shortname}"
        } else {TE::UTILS::te_msg TE_UTIL-26 WARNING "${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.xsa not found."}
      }
    }     
    #--------------------------------
    #--generate_workspace_sdk:     
    proc generate_workspace_petalinux {{fname ""}} {
      #copy only xsa to existing project external plx_run will generate new project in kind template is missing
      if {$fname eq ""} {
        #use generated vivado data for workspace
        if {[file exists ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa]} {
           file mkdir ${TE::PETALINUX_PATH}/
           #use Toplevelname instead of Project name -> export from Vivado GUI can used to 
           file copy -force ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa ${TE::PETALINUX_PATH}/${TE::PB_FILENAME}.xsa
        } else {
           if {[catch {TE::VIV::write_platform} result]} {TE::UTILS::te_msg TE_UTIL-25 WARNING "${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa not found."}
           file mkdir ${TE::PETALINUX_PATH}/
           #use Toplevelname instead of Project name -> export from Vivado GUI can used to 
           file copy -force ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa ${TE::PETALINUX_PATH}/${TE::PB_FILENAME}.xsa
        }
      } else {
        #use prebuilt data for workspace
        set shortname "[TE::BDEF::find_shortdir $fname]"
        if {[file exists ${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.xsa]} {
          file mkdir ${TE::PETALINUX_PATH}/
          file copy -force ${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.xsa ${TE::PETALINUX_PATH}/${TE::PB_FILENAME}.xsa
        } else {TE::UTILS::te_msg TE_UTIL-??? WARNING "${TE::PREBUILT_HW_PATH}/${shortname}/${TE::PB_FILENAME}.xsa not found."}
      }
    }      
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished generate workspace functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # copy files functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
   
    #--------------------------------
    #--prebuilt_file_location:   
    proc prebuilt_file_location { {rel  true} {name *} {typ NA} {os NA} {app NA} {dest_path NA} {path_only false} {ushortdir NA} {uddr NA} {urev NA}} {   
    
    # puts "Test Debug(1): |$rel|$name|$typ|$os|$app|$dest_path|$path_only|||$|$|$|$|"
    # rel relative or absolute path
    # rel relative or absolute path
    
    # use path_only true to write files
    # use path_only false to search for files
    
    #note for wildcard name, use first hit
    #typ: .bit, .elf, .rec, .ub, .bin, .mcs .ltx, .dtb, .scr
    # check prio: short_dir, Revision(multiple possible | separator), GB(RAM Size), default
    
    # with OS prefix first search on OS folder and if not found on SW, renamed some special files

    #use current directory for rel if dest_path does not exists
    
    set filename NA
    set filename [file tail $name]
    set filename [file rootname $filename]
    
    
    set destPath [pwd]
    if { ! [string match "NA" $dest_path]} {
      set destPath ${dest_path}
    }
    set baseFolder NA
    set absPath NA
    set absPathOnly NA
    set shortDir ${TE::SHORTDIR}
    set revDir [lindex [split ${TE::PCB_REV} "|"] 0]
    set ddrDir ${TE::DDR_SIZE}
    set defDir default

    if { ! [string match "NA" $ushortdir]} {
      set shortDir ${ushortdir}
    }
    if { ! [string match "NA" $uddr]} {
      set ddrDir ${uddr}
    }
    if { ! [string match "NA" $urev]} {
      set revDir ${urev}
    }
    
    set useOSPath false
    
    if {! [string match "NA" $os] && ! [string match "standalone" $os] } {
      set useOSPath true
    }
    # for os subfolder
    set osPath .
    if {$useOSPath } {
      set osPath $os
    }

    # for app subfolder
    set appPath .
    if {! [string match "NA" $app]} {
      set appPath $app
    }
    if {[string match $typ ".bit"]  || [string match $typ ".mmi"] || [string match $typ ".ltx"]} {
      set baseFolder ${TE::PREBUILT_HW_PATH}
    } elseif {$useOSPath} {
      # with OS prefix first search on linux folder and if not found on SW
      set baseFolder ${TE::PREBUILT_OS_PATH}
    } elseif {[string match $typ ".elf"] || [string match $typ ".srec"]} {
      set baseFolder ${TE::PREBUILT_SW_PATH}
        # appfolder not used at the moment for sw--> sw has app name
       set appPath .
    } elseif {[string match $typ ".bin"] || [string match $typ ".mcs"] || [string match $typ ".bif"] } {
      set baseFolder ${TE::PREBUILT_BI_PATH}
      if {[string match $typ ".mcs"] && [string match "NA" $app] } {
        set baseFolder ${TE::PREBUILT_HW_PATH}
      }
    } else {
     TE::UTILS::te_msg TE_UTIL-129 {CRITICAL WARNING} "Search prebuilt: $typ not defined."
      return "NA"
    }


    #default folder
    if {[file exists ${baseFolder}/${osPath}/${defDir}/${appPath}]} {set absPathOnly  ${baseFolder}/${osPath}/${defDir}/${appPath} } 
    #ddr folder
    if {[file exists ${baseFolder}/${osPath}/${ddrDir}/${appPath}]} {set absPathOnly  ${baseFolder}/${osPath}/${ddrDir}/${appPath} } 
    #rev folder
    if {[file exists ${baseFolder}/${osPath}/${revDir}/${appPath}]} {set absPathOnly  ${baseFolder}/${osPath}/${revDir}/${appPath} } 
    #short folder
    if {[file exists ${baseFolder}/${osPath}/${shortDir}/${appPath}]} {set absPathOnly  ${baseFolder}/${osPath}/${shortDir}/${appPath} } 

   # puts "----------Test:$typ | [file exists ${baseFolder}/${osPath}/${shortDir}/${appPath}]|${baseFolder}/${osPath}/${shortDir}/${appPath} "
    

    if { (! $path_only) || ([string match "NA" $absPathOnly])} {
      #file 
      if { [catch {set absPath [lindex [ glob  ${absPathOnly}/$filename$typ ] 0]}] } {
        if { $useOSPath  } {
          TE::UTILS::te_msg TE_UTIL-130 {INFO} "Search prebuilt: Additional search in software folder"
          #extra search for u-boot.elf, zynqmp_pmufw.elf, bl31.elf,  zynqmp_fsbl.elf, zynq_fsbl.elf
          # sdk name          = petalinux name
          # ---               = boot.elf
          # ---               = bl31.elf
          # zynqmp_pmufw.elf  = pmufw.elf
          # zynqmp_fsbl.elf   = zynqmp_fsbl.elf
          # zynq_fsbl.elf     = zynq_fsbl.elf
          set tmpname $filename
          # if {[string match $filename "pmufw"]} {
            # # rename petalinux pmu to SDk default pmu name
            # set tmpname zynqmp_pmufw
            # TE::UTILS::te_msg TE_UTIL-132 {INFO} "Search prebuilt: Rename $filename to $tmpname"
          # }
          if {$path_only} {
             set absPathOnly [prebuilt_file_location false $tmpname $typ NA $app $dest_path $path_only]
          } else {
             set absPath [prebuilt_file_location false $tmpname $typ NA $app $dest_path $path_only]
          }
        } 
      
      }
    }
     
   
    #use first hit, if more than one file was found in one folder, maybe later return list
    if {[llength $absPath] > 1} {
      TE::UTILS::te_msg TE_UTIL-131 {CRITICAL WARNING} "Search prebuilt: More than one file was found ($absPath),  first ([lindex $absPath 0]) is used "}
      set absPath [lindex $absPath 0]
      
     if {$path_only} {
       if {[string match "NA" $absPathOnly] } {
        return "NA"
       }
      if {$rel} {
        #create relative path
        return [TE::UTILS::relTo $absPathOnly $destPath]
       } else {
       
        return [TE::UTILS::regex_map $absPathOnly "/./" "/"]
       }
     } else {
       if {[string match "NA" $absPath] } {
        return "NA"
       }
      if {$rel} {
        #create relative path
        return [TE::UTILS::relTo $absPath $destPath]
       } else {
       
        return [TE::UTILS::regex_map $absPath "/./" "/"]
       }
     }
    }    
    #--------------------------------
    #--copy_hw_files:   
    proc copy_hw_files { {deleteOldFile  true}} {
      #make new one
      set hw_path [TE::UTILS::prebuilt_file_location false * .bit NA NA NA true]
      if {[string match "NA" $hw_path] } { 
        set hw_path ${TE::PREBUILT_HW_PATH}/${TE::SHORTDIR}
        file mkdir $hw_path
      }
      if {${TE::PR_TOPLEVELNAME} eq "NA" } {
        TE::UTILS::te_msg TE_UTIL-27 {CRITICAL WARNING} "Script variable TE::PR_TOPLEVELNAME was not set, script properties will be reload."
        TE::VIV::restore_scriptprops
      }
      #copy files only if bitfiles exists
      if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.bit]} {
        #delete old prebuilt bitfile
        if {[file exists ${hw_path}/${TE::PB_FILENAME}.bit] && $deleteOldFile } {
          if {[catch {file delete -force ${hw_path}/${TE::PB_FILENAME}.bit} result]} {TE::UTILS::te_msg TE_UTIL-28 {CRITICAL WARNING} " $result"}
        }
        #copy and rename bitfile
        file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.bit ${hw_path}/${TE::PB_FILENAME}.bit
        TE::UTILS::te_msg TE_UTIL-29 INFO "${hw_path}/${TE::PB_FILENAME}.bit was replaced with ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.bit"
        #--------------------------------
        #delete old prebuilt lpr
        if {[file exists ${hw_path}/${TE::PB_FILENAME}.lpr] && $deleteOldFile } {
          if {[catch {file delete -force ${hw_path}/${TE::PB_FILENAME}.lpr} result]} {TE::UTILS::te_msg TE_UTIL-30 {CRITICAL WARNING} " $result"}
        }
        #copy and rename lpr
        file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.hw/${TE::VPROJ_NAME}.lpr ${hw_path}/${TE::PB_FILENAME}.lpr
        TE::UTILS::te_msg TE_UTIL-31 INFO "${hw_path}/${TE::PB_FILENAME}.lpr was replaced with ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.hw/${TE::VPROJ_NAME}.lpr"
        #--------------------------------
        #delete old prebuilt ltx_file
        if {[file exists ${hw_path}/${TE::PB_FILENAME}.ltx] && $deleteOldFile } {
          if {[catch {file delete -force ${hw_path}/${TE::PB_FILENAME}.ltx} result]} {TE::UTILS::te_msg TE_UTIL-32 {CRITICAL WARNING} " $result"}
        }
        if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/debug_nets.ltx]} {
          file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/debug_nets.ltx ${hw_path}/${TE::PB_FILENAME}.ltx
          TE::UTILS::te_msg TE_UTIL-33 INFO "${hw_path}/${TE::PB_FILENAME}.ltx was replaced with ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.runs/${TE::IMPL_NAME}/debug_nets.ltx"
        } else {TE::UTILS::te_msg TE_UTIL-34 INFO "${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/debug_nets.ltx does not exist."}
        #delete old prebuilt hdf_file (hdf only on processor systems)
        if {[file exists ${hw_path}/${TE::PB_FILENAME}.hdf]  && $deleteOldFile } {
          if {[catch {file delete -force ${hw_path}/${TE::PB_FILENAME}.hdf} result]} {TE::UTILS::te_msg TE_UTIL-35 STATUS " $result"}
        }
        if {[file exists ${hw_path}/${TE::PB_FILENAME}.xsa]  && $deleteOldFile } {
          if {[catch {file delete -force ${hw_path}/${TE::PB_FILENAME}.xsa} result]} {TE::UTILS::te_msg TE_UTIL-149 {CRITICAL WARNING} " $result"}
        }
        if {!$TE::IS_FSYS} {
          if {[file exists ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa]} {
            #optional only on processor system: check bd file name --> for fsys no *hwdef and *sydef files needed
            file copy -force  ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa ${hw_path}/${TE::PB_FILENAME}.xsa
            TE::UTILS::te_msg TE_UTIL-36 INFO "${hw_path}/${TE::PB_FILENAME}.xsa was replaced with ${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa"
          } else {TE::UTILS::te_msg TE_UTIL-37 {CRITICAL WARNING} "${TE::VPROJ_PATH}/${TE::PB_FILENAME}.xsa does not exist."}
          # if {[file exists ${TE::VPROJ_PATH}/${TE::PR_TOPLEVELNAME}.hdf]} {
            # #optional only on processor system: check bd file name --> for fsys no *hwdef and *sydef files needed
            # file copy -force  ${TE::VPROJ_PATH}/${TE::PR_TOPLEVELNAME}.hdf ${hw_path}/${TE::PB_FILENAME}.hdf
            # TE::UTILS::te_msg TE_UTIL-36 INFO "${hw_path}/${TE::PB_FILENAME}.hdf was replaced with ${TE::VPROJ_PATH}/${TE::PR_TOPLEVELNAME}.hdf"
          # } else {TE::UTILS::te_msg TE_UTIL-37 STATUS "${TE::VPROJ_PATH}/${TE::PR_TOPLEVELNAME}.hdf does not exist(not longer needed use xsa)."}
        } 
        #delete old prebuilt mmi (not for zynq systems)
        if {[file exists ${hw_path}/${TE::PB_FILENAME}.mmi]  && $deleteOldFile } {
          if {[catch {file delete -force ${hw_path}/${TE::PB_FILENAME}.mmi} result]} {TE::UTILS::te_msg TE_UTIL-38 {CRITICAL WARNING} " $result"}
        }
        #copy mmi
        if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mmi]} {
          file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mmi ${hw_path}/${TE::PB_FILENAME}.mmi
          TE::UTILS::te_msg TE_UTIL-41 INFO "${hw_path}/${TE::PB_FILENAME}.mmi was replaced with ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mmi"
        } else {TE::UTILS::te_msg TE_UTIL-42 WARNING "${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mmi does not exist."}
        if {!$TE::IS_ZSYS && ! $TE::IS_ZUSYS} {
          #delete old prebuilt mcs_file (not for zynq systems)
          if {[file exists ${hw_path}/${TE::PB_FILENAME}.mcs]  && $deleteOldFile } {
            if {[catch {file delete -force ${hw_path}/${TE::PB_FILENAME}.mcs} result]} {TE::UTILS::te_msg TE_UTIL-39 {CRITICAL WARNING} " $result"}
          }
          #delete old prebuilt prm_file (not for zynq systems)
          if {[file exists ${hw_path}/reports/${TE::PB_FILENAME}.prm]  && $deleteOldFile } {
            if {[catch {file delete -force ${hw_path}/reports/${TE::PB_FILENAME}.prm} result]} {TE::UTILS::te_msg TE_UTIL-40 {CRITICAL WARNING} " $result"}
          }
          #copy mcs
          if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mcs]} {
            #optional only on systems without processor used see TE::VIV::write_cfgmem for selection
            #compare timestamps, if mcs is older than bitfile, rerun write mcs_file --> if gui is used to generate bitfile mcs will not recreate
            set bittime [file mtime ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.bit] 
            set mcstime [file mtime ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mcs] 
            if {$mcstime < $bittime} {
              TE::UTILS::te_msg TE_UTIL-43 INFO "${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mcs is older as ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.bit . Regenerate mcs."
              
              if {[catch {TE::VIV::write_viv_cfgmem} result]} { TE::UTILS::te_msg TE_UTIL-44 ERROR "Script (TE::VIV::write_viv_cfgmem) failed: $result."; return -code error}
            }
            file mkdir ${hw_path}/reports
            file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.prm ${hw_path}/reports/${TE::PB_FILENAME}.prm
            TE::UTILS::te_msg TE_UTIL-45 INFO "${hw_path}/reports/${TE::PB_FILENAME}.prm was replaced with ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.prm"
            file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mcs ${hw_path}/${TE::PB_FILENAME}.mcs
            TE::UTILS::te_msg TE_UTIL-46 INFO "${hw_path}/reports/${TE::PB_FILENAME}.mcs was replaced with ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mcs"
          } else {TE::UTILS::te_msg TE_UTIL-47 WARNING "${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.mcs does not exist."}
        }  
        TE::UTILS::create_prebuilt_report HW
      } else {TE::UTILS::te_msg TE_UTIL-48 {CRITICAL WARNING} "${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.bit does not exist. Nothing was copied to prebuilt folder."}     
    }  
    #--------------------------------
    #--copy_sw_files:   
    proc copy_sw_files {} {
      # set dirs [glob -directory $TE::WORKSPACE_SDK_PATH *]
      set applications [TE::UTILS::findFiles $TE::WORKSPACE_SDK_PATH *.elf]
      set sw_path [TE::UTILS::prebuilt_file_location false * .elf NA NA NA true]
      if {[string match "NA" $sw_path] } { 
        set sw_path ${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR}
        file mkdir ${sw_path}
      } 
      if { [llength $applications] eq 0} {
        TE::UTILS::te_msg TE_UTIL-55 {CRITICAL WARNING} "$TE::WORKSPACE_SDK_PATH was empty. Nothing was copied to prebuilt folder."
      }
      foreach app $applications {
        set filenameonly [file tail $app] 
        
        #not all temp elf areused deleted
        if {![string match  "executable.elf" ${filenameonly}] && ![string match */resources/* ${app}] && ![string match */zynqmp_pmufw/* ${app}] && ![string match */zynqmp_fsbl/* ${app}] && ![string match */qemu/* ${app}] && ![string match "u-boot.elf" ${filenameonly}]  && ![string match "bl31.elf" ${filenameonly}]} {
          if {[file exists ${sw_path}/${filenameonly}]} {
            if {[catch {file delete -force ${sw_path}/${filenameonly}} result]} {TE::UTILS::te_msg TE_UTIL-49 {CRITICAL WARNING} " $result"}
          }
          TE::UTILS::te_msg TE_UTIL-150 STATUS " Copy $app"
          if {[catch {file copy  -force $app ${sw_path}/} result]} {TE::UTILS::te_msg TE_UTIL-49 {CRITICAL WARNING} " $result"}
        } else {
          TE::UTILS::te_msg TE_UTIL-49 STATUS " Skip $app"
        }
      }
    } 
    #--------------------------------
    #--copy_hw_reports:   
    proc copy_hw_reports {} {
        set hw_path [TE::UTILS::prebuilt_file_location false * .bit NA NA NA true]
        if {[string match "NA" $hw_path] } { 
          set hw_path ${TE::PREBUILT_HW_PATH}/${TE::SHORTDIR}
          file mkdir ${hw_path}
        }
        TE::UTILS::te_msg TE_UTIL-56 STATUS "Create reports in ${hw_path}/reports"
        file mkdir ${hw_path}/reports
        #copy only if new bitfile exists
        if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PR_TOPLEVELNAME}.bit]} {
          if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_ip_status_report.txt]} {
            file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_ip_status_report.txt ${hw_path}/reports
          }
          if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.txt]} {
            file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.txt ${hw_path}/reports
          }
          if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.csv]} {
          file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.csv ${hw_path}/reports
          }
          if {[file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.xdc]} {
          file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.runs/${TE::IMPL_NAME}/${TE::PB_FILENAME}_io_report.xdc ${hw_path}/reports
          }
        }
        #create allways summary 
        create_prebuilt_hw_summary
    }
    #--------------------------------
    #--prod_config:
    proc prod_config { {typ 1}} {
      #todo remove will be obsolete in future. it's implemented in script_settings.tcl and extened tcl file
      # if {[file exists  ${TE::BASEFOLDER}/../prod_cfg_list.csv]} {
        # set fp [open "${TE::BASEFOLDER}/../prod_cfg_list.csv" r]
        # set file_data [read $fp]
        # close $fp
        # set data [split $file_data "\n"]
        # foreach line $data {
          # #  check file version ignore comments and empty lines
          # if {[string match *#* $line] != 1 && [string match *CSV_VERSION* $line] } {
            # # in case somebody has save csv with other programm add comma can be add
            # set linetmp [lindex $[split $line ";"] 0]
            # #remove spaces
            # set linetmp [string map {" " ""} $linetmp]
            # #remove tabs
            # set linetmp [string map {"\t" ""} $linetmp]
            # #check version
            # set tmp [split $linetmp "="]
            # if {[string match [lindex $tmp 1] $TE::PROD_CFG_CSV] != 1} {
              # TE::UTILS::te_msg TE_INIT-203 ERROR "Wrong Prod Definition CSV Version (${TE::BASEFOLDER}/../prod_cfg_list.csv) get [lindex $tmp 1] expected ${TE::PROD_CFG_CSV}."
              # return -code error "Wrong Prod Definition CSV Version (${TE::BASEFOLDER}/../prod_cfg_list.csv) get [lindex $tmp 1] expected $TE::PROD_CFG_CSV"
            # } else {
              # set version_check true
            # }
          # } elseif {[string match *#* $line] != 1 && [string length $line] > 0} {
            
            # #remove spaces
            # set line [string map {" " ""} $line]
            # #remove tabs
            # set line [string map {"\t" ""} $line]
            # #splitt and append
            # set tmp [split $line ";"]
            # # puts "Test||$TE::VPROJ_NAME|[lindex $tmp 0]|"
            # if {[string match -nocase $TE::VPROJ_NAME [lindex $tmp 0]] == 1} {
              # if {[string match $typ [lindex $tmp 1]] == 1} {
                # set listname [lindex $tmp 2]
                # if {[string match -nocase $listname $TE::PRODID ] == 1 || [string match "all" [lindex $tmp 2]]} {
                  # return [lindex $tmp 3]
                # }
              # }
            # }
          # }
        # }
      # }  
      return "NA"
    }
    #--------------------------------
    #--user_export:   
    proc copy_user_export {} {
      set linux_path [TE::UTILS::prebuilt_file_location true  * *.ub petalinux NA [pwd] true]
      set add_files [glob -nocomplain -join -dir ${TE::ADD_SD_PATH} *]
      # set prod_path [TE::UTILS::prod_config 1]
      # if {[file exists  ${TE::BASEFOLDER}/${prod_path}]} { 
        # TE::UTILS::te_msg TE_INIT-204 INFO "Use additional files from ${TE::BASEFOLDER}/${prod_path}"
        # set add_files [glob -nocomplain -join -dir ${TE::BASEFOLDER}/${prod_path} *]
      # }
      set applist []
      set elflist []
      set hwlist []
      [catch {set applist [glob -join -dir ${TE::PREBUILT_BI_PATH}/${TE::SHORTDIR}/ *]}]
      [catch {set elflist [glob -join -dir ${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR}/ *]}]
      [catch {set hwlist  [TE::UTILS::findFiles ${TE::PREBUILT_HW_PATH}/${TE::SHORTDIR}/ *]}]
      
      set basepath ${TE::BASEFOLDER}/_binaries_${TE::PRODID}
      set bif_loc  ${basepath}/res_bif
      set boot_loc  ${basepath}/res_elf
      set hw_loc  ${basepath}/res_hw
      file mkdir  ${basepath}
      file mkdir  ${bif_loc}
      file mkdir  ${boot_loc}
      file mkdir  ${hw_loc}
      TE::UTILS::write_board_select  ${basepath}
      set base_app_loc  ${basepath}/
      foreach app $applist {
        set appname [file tail $app]
        set appfolder "${basepath}/boot_${appname}"
        if {[string match -nocase "u-boot" $appname]} {
          set appname "linux"
          set appfolder "${basepath}/boot_linux"
          file mkdir ${appfolder}  
          if {![string match "NA" $linux_path]} {
            set linux_files [glob -nocomplain -join -dir ${linux_path} *]
            foreach file $linux_files {
              if {![string match *.elf $file]} { 
                #linux image.ub or other files
                file copy -force ${file} ${appfolder}  
              } else {
                #elf files like uboot, atf and pmu 
                file copy -force ${file} ${boot_loc} 
              }
            }
          }
          foreach file $add_files {
            file copy -force ${file} ${appfolder}  
          }
        } 
        file mkdir ${appfolder}        

        set bif_file [glob -nocomplain -join -dir ${app} *.bif]
        set prm_file [glob -nocomplain -join -dir ${app} *.prm]
        set bin_file [glob -nocomplain -join -dir ${app} *.bin]
        set mcs_file [glob -nocomplain -join -dir ${app} *.mcs]
        [catch {file copy -force ${bif_file} ${bif_loc}/${appname}.bif }]
        [catch {file copy -force ${prm_file} ${bif_loc}/${appname}.prm }]
        [catch {file copy -force ${bin_file} ${appfolder} }]
        [catch {file copy -force ${mcs_file} ${appfolder} }]
      }
      foreach elf $elflist {
        file copy -force ${elf} ${boot_loc}
      }
      foreach hw $hwlist {
        file copy -force ${hw} ${hw_loc}
      }
      return $basepath
    }
    #--copy_prod_export:   
    #can be used but obsolete ...todo remove and check dependencies
    proc copy_prod_export {boot app {prod PROD} {uprodid NA}  {ushortdir NA} {uddr NA} {urev NA} {uflashfpga NA}  {uflashzynq NA}} {
      #boot 0 Bitfile 1 QSPI, 2 SD, 3 Both (Boot.bin on QSPI, image.ub on SD )
      #app appname, for example u-boot
      #assopt index of the variant if empty  current project --> todo
      set date "[ clock format [clock seconds] -format "%Y_%m_%d"]"
      
      ## current project
      set prod_id  ${TE::PRODID}
      set shortdir ${TE::SHORTDIR}
      set ddr ${TE::DDR_SIZE}
      set rev ${TE::PCB_REV}
      set series_name "Test-01"
      set assembly_option "others"
      set project ${TE::VPROJ_NAME}
      set fpga_flash ${TE::FPGAFLASHTYP}
      set zynq_flash ${TE::ZYNQFLASHTYP}
      
      
      ## other variant
      if { ! [string match "NA" $uprodid]} {
        set prod_id ${uprodid}
      }      
      if { ! [string match "NA" $ushortdir]} {
        set shortdir ${ushortdir}
      }    
      if { ! [string match "NA" $uddr]} {
        set ddr ${uddr}
      }    
      if { ! [string match "NA" $urev]} {
        set rev ${urev}
      }    
      if { ! [string match "NA" $uflashfpga]} {
        set fpga_flash ${uflashfpga}
      }  
      if { ! [string match "NA" $uflashzynq]} {
        set zynq_flash ${uflashzynq}
      }
      
      ##
      
      ## split name
      set splitt_prod_id [split $prod_id "-"]
      if { [llength $splitt_prod_id] >2} {
        set series_name "[lindex $splitt_prod_id 0]"
        set assembly_option [lindex $splitt_prod_id 2]
        for {set x 3} {$x < [llength $splitt_prod_id]} {incr x} {
            set assembly_option "$assembly_option-[lindex $splitt_prod_id $x]"
        }
      } else {
        set series_name "[lindex $splitt_prod_id 0]"
        set assembly_option "[lindex $splitt_prod_id 1]"
      }
      # use first one in case of more REV in the list
      set rev [lindex [split ${rev} "|"] 0]
      # set rev [regex_map $rev "REV" ""]
      
      #production folder
      #file_dir ${TE::PREBUILT_EXPORT_PATH}/${date}/${series_name+rev}/<type_1>/<type_2>/${assembly_option}/${TE::VPROJ_NAME}_<type_3>
      #type_1:test, shipping(normally not used, change manually at the moment)
      #type_2:Flash, SD, Bitstream (note Flash boot with SD content has subfolder SD on the las subfolder of Flash)
      #type_3:default (currently app name) 
      
      set type_1 "test"         
      set type_2 "bitstream"
      #default 0
      if {$boot == 1  || $boot == 3}  {
        set type_2 "flash"
      } elseif  {$boot == 2}  {
        set type_2 "sd"
      }
      set type_3 $app
      
      
      set file_dir "${TE::PREBUILT_EXPORT_PATH}/dummy"
      if { [string match "PROD" $prod] } {
        set file_dir "${TE::PREBUILT_EXPORT_PATH}/${date}/${series_name}/${rev}/${type_1}/${type_2}/${assembly_option}/${TE::VPROJ_NAME}_${type_3}"
      } else { 
        set sdfilepath ""
        if { [string match -nocase "absolute" [file pathtype ${prod}]]} {
           set file_dir ${prod}
        } else {
           set file_dir ${TE::BASEFOLDER}/${prod}
        }
      
      }
      if { [file exists ${file_dir}] } {
        if {[catch {file delete -force ${file_dir}} result]} {TE::UTILS::te_msg TE_UTIL-144 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-145 INFO "${file_dir} was deleted."}
      }
      file mkdir ${file_dir}
      #create readme:
      set viv_version "NA"
      if {[catch {set viv_version [lindex [split [::version] "\n"] 0]}]} { set viv_version "NA" }
      set logfile_date [list]
        lappend logfile_date "-------------------------------------"
        lappend logfile_date "!Do not delete this file!"
        lappend logfile_date "!Use Wiki Documentation for additional instructions!"
        lappend logfile_date "-------------------------------------"
        lappend logfile_date "Export Date:  $date"
        lappend logfile_date "-------------------------------------"
        lappend logfile_date "-------------------------------------"
        lappend logfile_date "----Programming Notes:"


      
      
      TE::UTILS::te_msg TE_UTIL-57 STATUS "Create production export in ${file_dir}"
      set cp_file NA
      set file_tmp NA
      if {$boot == 0} {
        set cp_file [TE::UTILS::prebuilt_file_location false * .bit NA NA NA false  ${shortdir} ${ddr} ${rev}]
        if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
          set file_tmp [file tail ${cp_file}]
          file copy -force ${cp_file} ${file_dir}
          set xtime [file mtime ${cp_file} ]
          set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
          lappend logfile_date "-Use ./${file_tmp} on Vivado/SDK Bitfile programing setup ($date)"
        } else {
          TE::UTILS::te_msg TE_UTIL-58 {CRITICAL WARNING} "PR-export: Bitfile does not exist."
        }
        set cp_file [TE::UTILS::prebuilt_file_location false * .ltx NA NA NA false  ${shortdir} ${ddr} ${rev}]
        if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
          file copy -force ${cp_file} ${file_dir}
          lappend logfile_date "-Select ./${TE::PB_FILENAME}.ltx on Vivado HW Manager after power up to get Debug Cores visible"
        } else {
          TE::UTILS::te_msg TE_UTIL-59 {WARNING} "PR-export: optional probe definition file does not exist."
        }
      }
      if {$boot == 1 || $boot == 3} {
        lappend logfile_date "-Set Module Boot Mode to QSPI"
        set cp_file [TE::UTILS::prebuilt_file_location false * .bin NA ${app} NA false  ${shortdir} ${ddr} ${rev}]
        if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
          set file_tmp [file tail ${cp_file}]
          file copy -force ${cp_file} ${file_dir}
          set xtime [file mtime  ${cp_file} ]
          set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
          lappend logfile_date "-Use ./${file_tmp} on Vivado/SDK Flash programming setup ($date)"
          lappend logfile_date "-Use $fpga_flash ($zynq_flash) on Vivado/SDK Flash programming setup"
          set cp_file [TE::UTILS::prebuilt_file_location false zynqmp_fsbl_flash .elf NA ${app} NA false  ${shortdir} ${ddr} ${rev}]
          if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
            set file_tmp [file tail ${cp_file}]
            file copy -force ${cp_file} ${file_dir}
            set xtime [file mtime  ${cp_file} ]
            set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
            lappend logfile_date "-Use ${file_tmp} on Vivado/SDK Flash programming setup($date)"
          }
          set cp_file [TE::UTILS::prebuilt_file_location false zynq_fsbl_flash .elf NA ${app} NA false  ${shortdir} ${ddr} ${rev}]
          if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
            set file_tmp [file tail ${cp_file}]
            file copy -force ${cp_file} ${file_dir}
            set xtime [file mtime  ${cp_file} ]
            set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
            lappend logfile_date "-Use ${file_tmp} on Vivado/SDK Flash programming setup($date)"
          }
          
        } else {
          set cp_file [TE::UTILS::prebuilt_file_location false * .mcs NA ${app} NA false  ${shortdir} ${ddr} ${rev}]
          if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
            set file_tmp [file tail ${cp_file}]
            file copy -force ${cp_file} ${file_dir}
            set xtime [file mtime  ${cp_file} ]
            set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
            lappend logfile_date "-Use ./${file_tmp} on Vivado/SDK Flash programming setup ($date)"
          } else {
            set cp_file [TE::UTILS::prebuilt_file_location false * .mcs NA NA NA false  ${shortdir} ${ddr} ${rev}]
            if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
              set file_tmp [file tail ${cp_file}]
              file copy -force ${cp_file} ${file_dir}
              set xtime [file mtime  ${cp_file} ]
              set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
              lappend logfile_date "-Use ./${file_tmp} on Vivado/SDK Flash programming setup ($date)"
            } else {
              TE::UTILS::te_msg TE_UTIL-61 {CRITICAL WARNING} "PR-export: ${TE::PB_FILENAME}.mcs / Boot.bin does not exist."
            }
          }
        }

        set cp_file [TE::UTILS::prebuilt_file_location false * .ltx NA NA NA false  ${shortdir} ${ddr} ${rev}]
        if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
          set file_tmp [file tail ${cp_file}]
          file copy -force ${cp_file} ${file_dir}
          set xtime [file mtime  ${cp_file} ]
          set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
          lappend logfile_date "-Use ./${file_tmp} on Vivado HW Manager after power up to get Debug Cores visible ($date)"
        } else {
          TE::UTILS::te_msg TE_UTIL-62 {WARNING} "PR-export: optional probe definition file does not exist."
        }
          
      }
      if {$boot == 2} {
        file mkdir ${file_dir}
        lappend logfile_date "-Set Module Boot Mode to SD"
        
        set cp_file [TE::UTILS::prebuilt_file_location false * .bin NA ${app} NA false  ${shortdir} ${ddr} ${rev}]
        if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
          set file_tmp [file tail ${cp_file}]
          file copy -force ${cp_file} ${file_dir}
          set xtime [file mtime  ${cp_file} ]
          set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
          lappend logfile_date "-Put ./BOOT.bin (${app}) on SD-Card ($date)"
        } else {
          TE::UTILS::te_msg TE_UTIL-63 {CRITICAL WARNING} "PR-export: Boot.bin does not exist."
        }
        set cp_file [TE::UTILS::prebuilt_file_location false * .ltx NA NA NA false  ${shortdir} ${ddr} ${rev}]
        if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
          set file_tmp [file tail ${cp_file}]
          file copy -force ${cp_file} ${file_dir}
          set xtime [file mtime  ${cp_file} ]
          set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
          lappend logfile_date "-Use ./${file_tmp} on Vivado HW Manager after power up to get Debug Cores visible ($date)"
        } else {
          TE::UTILS::te_msg TE_UTIL-64 {WARNING} "PR-export: optional probe definition file does not exist."
        }
        
        set cp_file [TE::UTILS::prebuilt_file_location false * .ub petalinux NA NA false  ${shortdir} ${ddr} ${rev}]
        if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
          set file_tmp [file tail ${cp_file}]
          file copy -force ${cp_file} ${file_dir}
          set xtime [file mtime  ${cp_file} ]
          set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
          lappend logfile_date "-Put ./${file_tmp} on SD-Card ($date)"
        } else {
          TE::UTILS::te_msg TE_UTIL-65 {CRITICAL WARNING} "PR-export: image.ub does not exist."
        }
        
        if {[file exists ${TE::BASEFOLDER}/misc/sd/ ]} {
          foreach f [glob -directory ${TE::BASEFOLDER}/misc/sd/ -nocomplain *] {
            file copy -force $f ${file_dir}
            lappend logfile_date "-Put ./[file rootname [file tail $f]] on SD-Card "
          } 
        }
        
      }
      if {$boot == 3}  {
        # file mkdir ${file_dir}/Flash --> done with Flash option
        file mkdir ${file_dir}/SD
        
        set cp_file [TE::UTILS::prebuilt_file_location false * .ub petalinux NA NA false  ${shortdir} ${ddr} ${rev}]
        if {[file exists ${cp_file}] && ! [string match "NA" $cp_file]} {
          set file_tmp [file tail ${cp_file}]
          file copy -force ${cp_file} ${file_dir}
          set xtime [file mtime  ${cp_file} ]
          set date "[ clock format $xtime -format "%Y%m%d%H%M%S"]"
          lappend logfile_date "-Put ./SD/${file_tmp} on SD-Card ($date)"
        } else {
          TE::UTILS::te_msg TE_UTIL-66 {CRITICAL WARNING} "PR-export: image.ub does not exist."
        }
        
        if {[file exists ${TE::BASEFOLDER}/misc/sd/ ]} {
          foreach f [glob -directory ${TE::BASEFOLDER}/misc/sd/ -nocomplain *] {
            file copy -force $f ${file_dir}
            lappend logfile_date "-Put ./SD/[file rootname [file tail $f]] on SD-Card "
          } 
        }
        
      }
      lappend logfile_date "-------------------------------------"
      lappend logfile_date "----Important Design Notes for Developer:"
      lappend logfile_date "-Design Name:            $TE::VPROJ_NAME"
      lappend logfile_date "-Vivado Version:         $viv_version"
      lappend logfile_date "-TE Script Version:      $TE::SCRIPTVER"
      lappend logfile_date "-Used CSV Product ID:    $prod_id"
      lappend logfile_date "-------------------------------------"
      lappend logfile_date "-QSPI Flash: $fpga_flash ($zynq_flash)"
      lappend logfile_date "-------------------------------------"
      
      set filename "error.txt"
      if {$boot == 0} {
        set file_dir ${file_dir}
        set filename "Notes_JTAG_Boot.txt"
      } elseif {$boot == 1} {
        set file_dir ${file_dir}
      set filename "Notes_QSPI_Boot.txt"
      } elseif {$boot == 2} {
        set file_dir ${file_dir}
      set filename "Notes_SD_Boot.txt"
      } elseif {$boot == 3} {
        set file_dir ${file_dir}
        set filename "Notes_QSPI_Boot_with_SD.txt"
      }
      set fp_w [open ${file_dir}/$filename w]
      foreach line $logfile_date {
        puts $fp_w $line
      }
      close $fp_w
      # if {$boot == 3} { 
        # file copy -force ${file_dir}/$filename ${file_dir}/../SD
      # }
    } 
    
    
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished copy files  functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # report functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--write_zip_info: 
    proc write_zip_info {{path "NA"}  {zipname "NA"} {initials "NA"} {dest "NA"} {typ "NA"} {btyp "NA"} {pname "NA"} {ptool "NA"} {release "NA"} {revision "NA"}} { 
      #Destination: Production, PublicDoc, Development, Preliminary
      #ExporterInitials: 
      #typ: Prod: MT,HT,ATS, others "NA"
      #BoardTyp: Module, Carrier, Motherboard, FMC-Card, PCIe-Card, Others
      #ProjectName: project base folder name
      #ProjectToolName: "Vivado-xxxx.y"
      #ReleaseDate: Date
      #Revision: NA (Futures usage)
      if {![string match "NA" $path ]} {
        set infofile ${path}/zip.teinfo
        set fp_w [open ${infofile} "w"] 
        puts $fp_w "#-----------------------------------------------#"
        puts $fp_w "#--Automatically generated file. Do not modify--#"
        puts $fp_w "#-----------------------------------------------#"
        puts $fp_w "ZIPINFO_CSV=        ${TE::ZIPINFO_CSV}"
        puts $fp_w "ExporterInitials=   $initials"
        puts $fp_w "ZIPName=            $zipname"
        puts $fp_w "Destination=        $dest"
        puts $fp_w "Typ=                $typ"
        puts $fp_w "BoardTyp=           $btyp"
        puts $fp_w "ProjectName=        $pname"
        puts $fp_w "ProjectToolName=    $ptool"
        puts $fp_w "ReleaseDate=        $release"
        puts $fp_w "Revision=           $revision"
        close $fp_w
      } else {
      #to nothing...
      }
    }
    #--print_zip_info: 
    proc print_zip_info {} { 
      if {[file exists "$TE::SET_PATH/zip.teinfo"]} {
        set fp_r [open $TE::SET_PATH/zip.teinfo "r"]
        set file_data [read $fp_r]
        set data [split $file_data "\n"]
        close $fp_r
        TE::UTILS::te_msg TE_INIT-207 INFO "Delivered Project"
        foreach line $data {
          if {[string match "*=*" $line]} {
            TE::UTILS::te_msg TE_INIT-207 INFO "$line"
          }
        }
      } else {
        TE::UTILS::te_msg TE_INIT-208 INFO "Development Project"
      }
    }
    #--write_board_select: 
    proc write_board_select {{path "NA"}} {  
      set infofile ${TE::VPROJ_PATH}/${TE::PRODID}.teinfo
      if {![string match "NA" $path ]} {
        set infofile ${path}/${TE::PRODID}.teinfo
      }
      set fp_w [open ${infofile} "w"] 
      puts $fp_w "Creation Date:      [ clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]"
      puts $fp_w "TE::ID:             $TE::ID           "
      puts $fp_w "TE::PRODID:         $TE::PRODID       "
      puts $fp_w "TE::PARTNAME:       $TE::PARTNAME     "
      puts $fp_w "TE::BOARDPART:      $TE::BOARDPART    "
      puts $fp_w "TE::SHORTDIR:       $TE::SHORTDIR     "
      puts $fp_w "TE::ZYNQFLASHTYP:   $TE::ZYNQFLASHTYP "
      puts $fp_w "TE::FPGAFLASHTYP:   $TE::FPGAFLASHTYP "
      puts $fp_w "TE::PCB_REV:        $TE::PCB_REV      "
      puts $fp_w "TE::DDR_SIZE:       $TE::DDR_SIZE     "
      puts $fp_w "TE::FLASH_SIZE:     $TE::FLASH_SIZE   "
      puts $fp_w "TE::EMMC_SIZE:      $TE::EMMC_SIZE    "
      puts $fp_w "TE::OTHERS:         $TE::OTHERS       "
      puts $fp_w "TE::NOTES:          $TE::NOTES        "
      close $fp_w
    }
    #--------------------------------
    #--read_board_select: 
    proc read_board_select {} { 
      set infofile [glob -nocomplain -join -dir ${TE::VPROJ_PATH}/ *.teinfo]
      foreach info $infofile {
        set prodid [file tail $info]
        set prodid [file rootname $prodid]
         # first hit wins
        return $prodid
        # set fp_r [open ${info} "r"]
        # set file_data [read $info]
        # set data [split $file_data "\n"]
        # close $fp_r
      }
      return "NA"
    }

    #--------------------------------
    #--create_prebuilt_hw_summary: 
    proc create_prebuilt_hw_summary {} {
      set report_file ${TE::VPROJ_PATH}/${TE::PB_FILENAME}_summary.csv
      set prebuilt_file ${TE::PREBUILT_HW_PATH}/hardware_summary.csv
      #todo hardware_summary.csv erase of to large
      set fp_r [open ${report_file} "r"]
      set file_data [read $fp_r]
      set data [split $file_data "\n"]
      close $fp_r
      if { ![file exists ${prebuilt_file}]} {
        set fp_w [open ${prebuilt_file} "w"]
        puts $fp_w [lindex $data 0]
        puts $fp_w [lindex $data 1]
        close $fp_w
      } else {
        set fp_a [open ${prebuilt_file} "a"]
        puts $fp_a [lindex $data 1]
        close $fp_a
      }
      TE::UTILS::te_msg TE_UTIL-67 INFO "Add HW report to: ${TE::PREBUILT_HW_PATH}/hardware_summary.csv"
    }
    #--------------------------------
    #--create_prebuilt_report: 
    proc create_prebuilt_report { type {app "unknown"}} {
      set sw_type "$type"
      if {![string match "$app" "unknown"]} {
        set sw_type "$sw_type ($app)"
      }
      TE::UTILS::te_msg TE_UTIL-68 STATUS "Create prebuilt $sw_type report"
      
      #reduce list
      set board_list [print_boardlist $TE::BDEF::BOARD_DEFINITION ${TE::BDEF::SHORTNAME} ${TE::SHORTDIR} false true]
      set board_list [lreplace $board_list 0 0]
      set article_list ""
      foreach line $board_list {
        set article_list "[lindex $line ${TE::BDEF::PRODID}]|${article_list}"
      }
      # puts "Test:$article_list|||$board_list"
      
      #time stamp
      set date "[ clock format [clock seconds] -format "%Y_%m_%d:%H_%M_%S"]"

      set data_path "unknown path"
      if {[string match "$type" BI]} {
        #*.mcs or *.bin
         
        set file_check [TE::UTILS::prebuilt_file_location false BOOT .bin NA ${app} $TE::PREBUILT_PATH false]
        if {![string match "NA" $file_check]} {
          set xtime [file mtime $file_check ]
          set date "[ clock format $xtime -format "%Y_%m_%d:%H_%M_%S"]"
          set data_path "[TE::UTILS::prebuilt_file_location true BOOT .bin NA ${app} $TE::PREBUILT_PATH true]"
        }   
        set file_check [TE::UTILS::prebuilt_file_location false ${app} .mcs NA ${app} $TE::PREBUILT_PATH false]
        if {![string match "NA" $file_check]} {
          set xtime [file mtime $file_check ]
          set date "[ clock format $xtime -format "%Y_%m_%d:%H_%M_%S"]"
          set data_path "[TE::UTILS::prebuilt_file_location true ${app} .mcs NA ${app} $TE::PREBUILT_PATH true]"
        }       

      } elseif {[string match "$type" HW]} {
        #*.bit
        set file_check [TE::UTILS::prebuilt_file_location false ${TE::PB_FILENAME} .bit NA NA $TE::PREBUILT_PATH false]
        if {![string match "NA" $file_check]} {
          set xtime [file mtime $file_check ]
          set date "[ clock format $xtime -format "%Y_%m_%d:%H_%M_%S"]"
          set data_path "[TE::UTILS::prebuilt_file_location true ${TE::PB_FILENAME} .bit NA NA $TE::PREBUILT_PATH true]"
        }   
      
      } elseif {[string match "$type" SW]} {
        #*.elf
        set file_check [TE::UTILS::prebuilt_file_location false ${app} .elf NA ${app} $TE::PREBUILT_PATH false]
        if {![string match "NA" $file_check]} {
          set xtime [file mtime $file_check ]
          set date "[ clock format $xtime -format "%Y_%m_%d:%H_%M_%S"]"
          set data_path "[TE::UTILS::prebuilt_file_location true ${app} .elf NA ${app} $TE::PREBUILT_PATH true]"
        }   
      
      } elseif {[string match "$type" OS]} {
        #*.os files
        set file_check [TE::UTILS::prebuilt_file_location false image .ub petalinux NA $TE::PREBUILT_PATH false]

        if {![string match "NA" $file_check]} {
          set xtime [file mtime $file_check ]
          set date "[ clock format $xtime -format "%Y_%m_%d:%H_%M_%S"]"
          set data_path "[TE::UTILS::prebuilt_file_location true image .ub petalinux NA $TE::PREBUILT_PATH true]"
        }   
      }
      #type: HW,SW,OS,BI
      
      set header [format "%-20s,%-12s,%-80s,," "${TE::SHORTDIR}" "ARTICLE_LIST"  "${article_list}" ]
      set content [format "%-20s,%-12s,%-8s,%-40s,%-22s" "${TE::SHORTDIR}" "FILE_LIST" "$type" "$data_path" "$date"]
      set separator [format "%-20s,%-12s,%-80s,," "--------------------" "------------" "--------------------------------------------------------------------------------" ]
      
      # create file
      set file_path ${TE::PREBUILT_PATH}/file_location.txt 
      set file_data ""
      set data [list]
      if {[file exists ${file_path}]} {
        set fp_r [open ${file_path} r]
        set file_data [read $fp_r]
        close $fp_r
        set data [split $file_data "\n"]
      }
      # set data [lreplace $data[set data {}] 0 0]  
      
      set found_header false
      set found_line false
      set line_index -1
      
      foreach line $data {
        incr line_index
        if {[string length $line] == 0 } {
          # remove empty lines
          set data [lreplace $data[set data {}] $line_index $line_index]
          incr line_index -1 
        }
        if {[string match "*--------------------*" $line] } {
          # remove separator lines
          set data [lreplace $data[set data {}] $line_index $line_index]
          incr line_index -1 
        }
        if {[string match "*Short Dir*Group*" $line] } {
          # remove separator header
          set data [lreplace $data[set data {}] $line_index $line_index]
          incr line_index -1 
        }
        if {[string match "*${TE::SHORTDIR}*ARTICLE_LIST*" $line] } {
          set found_header true
          set data [lreplace $data[set data {}] $line_index $line_index $header]
        }
        if {[string match "*${TE::SHORTDIR}*FILE_LIST*$type*" $line] } {
          set found_line true
          set data [lreplace $data[set data {}] $line_index $line_index $content]
        }
      }
      if { !$found_header } {
        lappend data $header
      }
      if { !$found_line } {
        lappend data $content
      }

      # sort
      set data [lsort $data]
      if { [llength $data] > 0} {
        set check_short [string map {" " ""} [lindex [split [lindex $data 0] ","] 0]]
        for {set line_index 1} {$line_index < [llength $data] } {incr line_index} {

          if { ! [string match "*${check_short}*" [lindex $data $line_index]] && ! [string match "*--------------------*" [lindex $data $line_index]] && [llength [lindex $data $line_index]] > 0} {
            set data [linsert $data $line_index $separator]
            incr line_index
          }
          if { $line_index < [llength $data] } {
            set check_short [string map {" " ""} [lindex [split [lindex $data $line_index] ","] 0]]
          }
        }
      }
      #todo include header and separator

      if {![file exists ${file_path}]} {
        set fp_w [open ${file_path} w]
        close $fp_w
      }
      ##write back
      set fp_w [open ${file_path} "w"]
      puts $fp_w $separator
      puts $fp_w [format "%-20s,%-12s,%-80s" "Short Dir" "Group" "Article Numbers (Typ, Path, Update Time)"]
      puts $fp_w $separator
      foreach line $data {
        if {[string length $line] > 0 } {
          #remove empty lines
          puts $fp_w $line
        }
      }
      # close files
      close $fp_w
      set data_path ""

      
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished report functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # clear functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--clean_vivado_project: 
    proc clean_vivado_project {} {
      if { [file exists $TE::VPROJ_PATH] } {
        if {[catch {file delete -force $TE::VPROJ_PATH} result]} {TE::UTILS::te_msg TE_UTIL-69 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-70 INFO "$TE::VPROJ_PATH was deleted."}
      }
    }   
    #--------------------------------
    #--clean_labtools_project:     
    proc clean_labtools_project {} {
      if { [file exists $TE::VLABPROJ_PATH] } {
        if {[catch {file delete -force $TE::VLABPROJ_PATH} result]} {TE::UTILS::te_msg TE_UTIL-71 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-72 INFO "$TE::VLABPROJ_PATH was deleted."}
      }
    }    
    #--------------------------------
    #--clean_workspace_hsi:  
    proc clean_workspace_hsi {} {
      if { [file exists ${TE::WORKSPACE_HSI_PATH}] } {
        if {[catch {file delete -force $TE::WORKSPACE_HSI_PATH} result]} {TE::UTILS::te_msg TE_UTIL-73 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-74 INFO "$TE::WORKSPACE_HSI_PATH was deleted."}
      }
    } 
    #--------------------------------
    #--clean_workspace_sdk:  
    proc clean_workspace_sdk {} {
      if { [file exists ${TE::WORKSPACE_SDK_PATH}] } {
        if {[catch {file delete -force $TE::WORKSPACE_SDK_PATH} result]} {TE::UTILS::te_msg TE_UTIL-75 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-76 INFO "$TE::WORKSPACE_SDK_PATH was deleted."}
      }
    }
    #--------------------------------
    #--clean_workspace_all:  
    proc clean_workspace_all {} {
      if { [file exists ${TE::WORKSPACE_PATH}] } {
        if {[catch {file delete -force $TE::WORKSPACE_PATH} result]} {TE::UTILS::te_msg TE_UTIL-77 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-78 INFO "$TE::WORKSPACE_PATH was deleted."}
      }
    }
    #--------------------------------
    #--clean_sdsoc:  
    proc clean_sdsoc {} {
      if { [file exists ${TE::SDSOC_PATH}] } {
        if {[catch {file delete -force $TE::SDSOC_PATH} result]} {TE::UTILS::te_msg TE_UTIL-79 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-80 INFO "$TE::SDSOC_PATH was deleted."}
      }
    }
    #--------------------------------
    #--clean_export:  
    proc clean_export {} {
      set binary_export [list]
      if { [catch {set binary_export [glob -join -dir ${TE::BASEFOLDER} -type d "_binaries_*"]}] } {
      } else {
        puts $binary_export
        foreach binary $binary_export {
          puts  "--------------Test |$binary|"
          if {[catch {file delete -force $binary} result]} {TE::UTILS::te_msg TE_UTIL-151 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-152 INFO "$binary was deleted."}
        }
      } 
    }
    #--------------------------------
    #--clean_backup:  
    proc clean_backup {} {
      if { [file exists ${TE::BACKUP_PATH}] } {
        if {[catch {file delete -force $TE::BACKUP_PATH} result]} {TE::UTILS::te_msg TE_UTIL-153 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-154 INFO "$TE::BACKUP_PATH was deleted."}
      }
    }
    #--------------------------------
    #--clean_temp:  
    proc clean_temp {} {
      if { [file exists ${TE::TMP_PATH}] } {
        if {[catch {file delete -force $TE::TMP_PATH} result]} {TE::UTILS::te_msg TE_UTIL-155 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-156 INFO "$TE::TMP_PATH was deleted."}
      }
    }
    #--------------------------------
    #--clean_all_generated_files:  
    proc clean_all_generated_files {} {
      clean_vivado_project
      clean_labtools_project
      clean_workspace_hsi
      clean_workspace_sdk
      clean_workspace_all
      clean_export
      clean_backup
      clean_temp
      TE::UTILS::te_msg TE_UTIL-81 INFO "Clean all generated files finished."
    }
    #--------------------------------
    #--clean_prebuilt_all:  
    proc clean_prebuilt_all {} {
      if { [file exists ${TE::PREBUILT_PATH}] } {
        if {[catch {file delete -force $TE::PREBUILT_PATH} result]} {TE::UTILS::te_msg TE_UTIL-82 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-83 INFO "$TE::PREBUILT_PATH was deleted."}
      }
    }
    #--------------------------------
    #--clean_prebuilt_all:  
    proc clean_prebuilt_sw_single {} {
      if { [file exists ${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR}] } {
        if {[catch {file delete -force ${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR}} result]} {TE::UTILS::te_msg TE_UTIL-137 {CRITICAL WARNING} " $result"} else {TE::UTILS::te_msg TE_UTIL-137 INFO "${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR} was deleted."}
      }
    }
    #todo clean prebuilt single part -> bi hw ,sw, os
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished clear functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # Additional functions 
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--mod_configfile: modify design_basic_settings.cmd/sh 
    #-- returns
    proc mod_configfile { {id NA} {vivmod false}} { 
      set host_id [TE::UTILS::get_host_os]
      set file_name "design_basic_settings.cmd"
      set b_commend "@REM"
      set b_xildir "@set XILDIR="
      set b_viv "@set VIVADO_VERSION="
      set b_part "@set PARTNUMBER="
      set b_sdsoc "@set ENABLE_SDSOC="
      set b_boardstore "@set USE_XILINX_BOARD_STORE="
      if {[string match -nocase "unix" $host_id ]} {
        set file_name "design_basic_settings.sh"
        set b_commend "#"
        set b_xildir "export XILDIR="
        set b_viv "export VIVADO_VERSION="
        set b_part "export PARTNUMBER="
        set b_sdsoc "export ENABLE_SDSOC="
        set b_boardstore "export USE_XILINX_BOARD_STORE="
      }
      if {![file exists ${TE::BASEFOLDER}/${file_name}]} {
        TE::UTILS::te_msg TE_INIT-180 ERROR "${TE::BASEFOLDER}/${file_name} doesn't exist"
         return -code error;
      }
      
      set fp_r [open ${file_name} "r"]
      set file_data [read $fp_r]
      close $fp_r
      
      set data [split $file_data "\n"]
      set newdata [list]
      

      
      foreach line $data {

        if {[string match -nocase "*${b_xildir}*" $line]  && ![string match -nocase "*${b_commend}*" $line] } {
          lappend newdata "${b_xildir}$::env(XILDIR)"
        } elseif {[string match -nocase "*${b_viv}*" $line] && ![string match -nocase "*${b_commend}*" $line]} {
          if {$vivmod} {
            #not default only for some internal usage
            lappend newdata "${b_viv}$::env(VIVADO_VERSION)"
          } else {
          #currently only predefined todo error if not match
          lappend newdata $line
          }
        } elseif {[string match -nocase "*${b_part}*" $line]  && ![string match -nocase "*${b_commend}*" $line] } {
          lappend newdata "${b_part}$id"
        } elseif {[string match -nocase "*${b_sdsoc}*" $line]  && ![string match -nocase "*${b_commend}*" $line] } {
          lappend newdata "${b_sdsoc}$::env(ENABLE_SDSOC)"
        } elseif {[string match -nocase "*${b_boardstore}*" $line]  && ![string match -nocase "*${b_commend}*" $line] } {
          lappend newdata "${b_boardstore}$::env(USE_XILINX_BOARD_STORE)"
        } else {
          lappend newdata $line
        }
      }
      
      set fp_w [open ${file_name} "w"]
      foreach line $newdata {
       # puts "Test2: [string length $line]"
        #remove empty lines
        if {[string length $line] > 0 } {
          puts $fp_w $line
        }
      }
      close $fp_w
      
    }
    #--------------------------------
    #--print_boardlist:  
    #-- returns list of the board which included the selected parameter only
    proc print_boardlist { {boardlist NA} {filter_id 0} {filter_value NA } {small_list false} {silence false} } {
      set tmpList $boardlist
      set hit false
      set newtmpList [list]
      if {[llength $boardlist] < 2 } {
        set tmpList $TE::BDEF::BOARD_DEFINITION
      }
      
      set index 0
      foreach sublist $tmpList {
        if {$index == 0} {
          lappend newtmpList $sublist
        } else {
           # puts "Test|[string equal "NA" $filter_value]|$filter_id|$filter_value|[lindex $sublist $filter_id]| [string match -nocase "${filter_value}" [lindex $sublist $filter_id]]|[string equal "TBD" $filter_value]||"
          if { ( [string equal "NA" $filter_value] || [string match -nocase "${filter_value}" [lindex $sublist $filter_id]] ) && ( ![string match -nocase "TBD" [lindex $sublist $filter_id]]) } {
            if {! ${silence} } {
              if {!$hit} {
                if {$small_list} {
                  puts [format "------------------------------------------------------------------------------"]
                  puts [format "|%-3s|%-20s|%-20s|%-30s|" "ID" "Product ID" "SHORT DIR" "Notes" ]
                  puts [format "------------------------------------------------------------------------------"]
                } else {
                  puts [format "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"]
                  puts [format "|%-3s|%-20s|%-30s|%-20s|%-40s|%-10s|%-10s|%-10s|%-30s|%-30s|" "ID" "Product ID" "SoC/FPGA Typ" "SHORT DIR" "PCB REV" "DDR Size" "Flash Size" "EMMC Size" "Others" "Notes" ]
                  puts [format "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"]
                }
              }
              if {$small_list} {
                puts [format "|%-3s|%-20s|%-20s|%-30s|" "[lindex $sublist ${TE::BDEF::ID}]" "[lindex $sublist ${TE::BDEF::PRODID}]" "[lindex $sublist ${TE::BDEF::SHORTNAME}]" "[lindex $sublist ${TE::BDEF::NOTES}]"]
                puts [format "------------------------------------------------------------------------------"]
              } else {
                puts [format "|%-3s|%-20s|%-30s|%-20s|%-40s|%-10s|%-10s|%-10s|%-30s|%-30s|" "[lindex $sublist ${TE::BDEF::ID}]" "[lindex $sublist ${TE::BDEF::PRODID}]" "[lindex $sublist ${TE::BDEF::PARTNAME}]" "[lindex $sublist ${TE::BDEF::SHORTNAME}]"  "[lindex $sublist ${TE::BDEF::PCB_REV}]" "[lindex $sublist ${TE::BDEF::DDR_SIZE}]" "[lindex $sublist ${TE::BDEF::FLASH_SIZE}]" "[lindex $sublist ${TE::BDEF::EMMC_SIZE}]" "[lindex $sublist ${TE::BDEF::OTHERS}]" "[lindex $sublist ${TE::BDEF::NOTES}]"]
                puts [format "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"]
              }
            }
            lappend newtmpList $sublist
            set hit true
          }
        }
        set index [expr $index +1 ]
     }

     return $newtmpList

    }
    #--------------------------------
    #--relTo:  
    #-- returns relative path from current folder to selected file
    proc relTo {targetfile currentpath} {
      set cc [file split [file normalize $currentpath]]
      set tt [file split [file normalize $targetfile]]
      if {![string equal [lindex $cc 0] [lindex $tt 0]]} {
          # not on *n*x then
          return -code error "$targetfile not on same volume as $currentpath"
      }
      while {[string equal [lindex $cc 0] [lindex $tt 0]] && [llength $cc] > 0} {
          # discard matching components from the front
          set cc [lreplace $cc 0 0]
          set tt [lreplace $tt 0 0]
      }
      set prefix ""
      if {[llength $cc] == 0} {
          # just the file name, so targetfile is lower down (or in same place)
          set prefix "."
      }
      # step up the tree
      for {set i 0} {$i < [llength $cc]} {incr i} {
          append prefix " .."
      }
      # stick it all together (the eval is to flatten the targetfile list)
      return [eval file join $prefix $tt]
    }
    
    #--------------------------------
    #--Dos2Unix:
    #-- translate style from dos to unix
    proc Dos2Unix {f} {
      # puts $f
      if {[file isdirectory $f]} {
        foreach g [glob [file join $f *]] {
          Dos2Unix $g
        }
      } else {
        set in [open $f]
        set out [open $f.new w]
        fconfigure $out -translation lf
        puts -nonewline $out [read $in]
        close $out
        close $in
        file rename -force $f.new $f
      }
    }
    #--------------------------------
    #--regex_map:
    #-- # replace part of the string with new string --> regex_map String alt_part new_part 
    proc regex_map { str args } {
        if { [llength $args] % 2 == 1} {
            set msg "wrong \# args: should be "
            append msg "regex value ?regex value?...\""
            return -code error $msg
        }
        
        foreach {regex value} $args {
            regsub -all $regex $str $value str
        }
        
        return $str
    }
    #--------------------------------
    #--findFiles:
    #-- Find recursive files in folders and return list with full path
    proc findFiles { baseDir pattern } {
      set dirs [ glob -nocomplain -type d [ file join $baseDir * ] ]
      set files {}
      foreach dir $dirs { 
        lappend files {*}[ findFiles $dir $pattern ] 
      }
      lappend files {*}[ glob -nocomplain -type f [ file join $baseDir $pattern ] ] 
      return $files
    }

    #--------------------------------
    #--get_host_os:  
    #-- Get host OS
    #-- returns string: "windows", "unix", ...
    proc get_host_os {} {
        global tcl_platform env
        return ${tcl_platform(platform)}
    }
    
    #--------------------------------
    #--vitis_z_bif:  
    #-- generate generic zynq Vitis bif
    #-- returns string: 
    proc vitis_z_bif {{args ""}} {
      set biffile [pwd]/boot.bif
      set linux_bif true
      #default vitis generic 
      set bootloader "<fsbl.elf>"
      
      
      set bitfile_use true
      set bitfile "<bitstream>"


      #app
      set app_use true
      set app "<elf,ps7_cortexa9_0>"
      
      # extention for 21.2 linux
      set uboot_dtb_use false
      set uboot_dtb_load "0x00100000"
      set uboot_dtb "<u-boot.dtb>"
      #boot.scr only for usage without sd
      set bscr_use false
      set bscr_load "0x00200000"
      set bscr "<boot.scr>"
      
      #list (important must always add all three parts, not use is "")
      set data_load [list]
      set data_offset [list]
      set data_file [list]
      
      set args_cnt [llength $args]
      for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
          "-biffile"                { incr option; set biffile [lindex $args $option]}
          "-linux"                  { incr option; set linux_bif [lindex $args $option]}
          "-bootloader"             { incr option; set bootloader [lindex $args $option]}
          "-bitfile_use"            { incr option; set bitfile_use [lindex $args $option]}
          "-bitfile"                { incr option; set bitfile [lindex $args $option]}
          "-app_use"                { incr option; set app_use [lindex $args $option]}
          "-app"                    { incr option; set app [lindex $args $option]}
          "-uboot_dtb_use"          { incr option; set uboot_dtb_use [lindex $args $option]}
          "-uboot_dtb_load"         { incr option; set uboot_dtb_load [lindex $args $option]}
          "-uboot_dtb"              { incr option; set uboot_dtb [lindex $args $option]}
          "-bscr_use"               { incr option; set bscr_use [lindex $args $option]}
          "-bscr_load"              { incr option; set bscr_load [lindex $args $option]}
          "-bscr"                   { incr option; set bscr [lindex $args $option]}
          "-data_f"                     { incr option; lappend data_file   [lindex $args $option]}
          "-data_o"                 { incr option; lappend data_offset [lindex $args $option]}
          "-data_l"                 { incr option; lappend data_load   [lindex $args $option]}
          default                   {TE::UTILS::te_msg TE_SW-94 ERROR "unrecognized option for BIF generation: [lindex $args $option]";return -code error }
        }
      }
    

      if { $linux_bif==true && [string match $app "<elf,ps7_cortexa9_0>"]} {
        set app "<u-boot.elf>"
      }
      set bif_fp [open "$biffile" w]

      if { $linux_bif==true} {
        puts $bif_fp "/* linux */"
      } else {
        puts $bif_fp "/* bare-metal */"
      }
      puts $bif_fp "/*auto-generated on [ clock format [clock seconds] -format "%Y/%m/%d %H:%M:%S"] */"
      
      puts $bif_fp "//arch = zynq; split = false; format = BIN"
      puts $bif_fp "the_ROM_image:\n\u007B"
      #bootloader and bootloader_cpu
      puts -nonewline $bif_fp "  \[bootloader\]"
      puts $bif_fp $bootloader
      #bitfile
      if {$bitfile_use == true  } {
        puts $bif_fp "  $bitfile"
      }

      #app
      if {$linux_bif == true  ||$app_use == true } {
        puts $bif_fp "  $app"
      }
      
      #app extention(uboot device tree todo test)
      if {$linux_bif == true  && $uboot_dtb_use == true } {
        puts -nonewline $bif_fp "  \[load = $uboot_dtb_load\]"
        puts $bif_fp $uboot_dtb
      }
      #boot.scr for linux (todo test)
      if {$linux_bif == true  && $bscr_use == true } {
        puts -nonewline $bif_fp "  \[load = $bscr_load\]"
        puts $bif_fp $bscr
      }
      
      #file 
			set data_file [split $data_file "|"]
			set data_load [split $data_load "|"]
			set data_offset [split $data_offset "|"]
			
      for {set i 0} {$i < [llength $data_file]} {incr i} {
        if {![string match "" "[lindex $data_file $i]"] && ![string match "NA" "[lindex $data_file $i]"]} {
					if {[string match "" "[lindex $data_offset $i]"]} {
					puts -nonewline $bif_fp "  \[load =  [lindex $data_load $i]\]"
					} else {
					puts -nonewline $bif_fp "  \[offset =  [lindex $data_offset $i]\]"
					}    
					puts $bif_fp  [lindex $data_file $i]
				}
      }
       
      puts $bif_fp "\u007D"

      close $bif_fp
       
    }
    #--------------------------------
    #--vitis_zmp_linux_bif:  
    #-- generate generic zynqMP Vitis bif
    #-- returns string:
    proc vitis_zmp_bif {{args ""}} {
      set biffile [pwd]/boot.bif
      set linux_bif true
      #default vitis generic 
      set bootloader_cpu "a53-0"
      set bootloader "<fsbl.elf>"
      
      set pmu_use false
      set pmu "<pmufw.elf>"
      
      set bitfile_use true
      set bitfile "<bitstream>"

      set atf_use false
      set atf_cpu "a53-0"
      set atf_exception_level "el-3"
      set atf "<bl31.elf>"
      

      #app
      set app_use true
      set app_cpu "a53-0"
      set app_exception_level "el-3"
      set app "<elf,psu_cortexa53_0>"
      # extention for 21.2 linux
      set uboot_dtb_use false
      set uboot_dtb_load "0x00100000"
      set uboot_dtb "<u-boot.dtb>"
      #boot.scr only for usage without sd
      set bscr_use false
      set bscr_load "0x00200000"
      set bscr "<boot.scr>"
      #list (important must always add all three parts, not use is "")
      set data_load [list]
      set data_offset [list]
      set data_file [list]
      
      set args_cnt [llength $args]
      for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
          "-biffile"                { incr option; set biffile [lindex $args $option]}
          "-linux"                  { incr option; set linux_bif [lindex $args $option]}
          "-bootloader_cpu"            { incr option; set bootloader_cpu [lindex $args $option]}
          "-bootloader"             { incr option; set bootloader [lindex $args $option]}
          "-pmu_use"                { incr option; set pmu_use [lindex $args $option]}
          "-pmu"                    { incr option; set pmu [lindex $args $option]}
          "-bitfile_use"            { incr option; set bitfile_use [lindex $args $option]}
          "-bitfile"                { incr option; set bitfile [lindex $args $option]}
          "-atf_use"                { incr option; set atf_use [lindex $args $option]}
          "-atf_cpu"                { incr option; set atf_cpu [lindex $args $option]}
          "-atf_exception_level"    { incr option; set atf_exception_level [lindex $args $option]}
          "-atf"                    { incr option; set atf [lindex $args $option]}
          "-app_use"                { incr option; set app_use [lindex $args $option]}
          "-app_cpu"                { incr option; set app_cpu [lindex $args $option]}
          "-app_exception_level"    { incr option; set app_exception_level [lindex $args $option]}
          "-app"                    { incr option; set app [lindex $args $option]}
          "-uboot_dtb_use"          { incr option; set uboot_dtb_use [lindex $args $option]}
          "-uboot_dtb_load"         { incr option; set uboot_dtb_load [lindex $args $option]}
          "-uboot_dtb"              { incr option; set uboot_dtb [lindex $args $option]}
          "-bscr_use"               { incr option; set bscr_use [lindex $args $option]}
          "-bscr_load"              { incr option; set bscr_load [lindex $args $option]}
          "-bscr"                   { incr option; set bscr [lindex $args $option]}
          "-data_f"                 { incr option; lappend data_file   [lindex $args $option]}
          "-data_o"                 { incr option; lappend data_offset [lindex $args $option]}
          "-data_l"                 { incr option; lappend data_load   [lindex $args $option]}
          default                   {TE::UTILS::te_msg TE_SW-93 ERROR "unrecognized option for BIF generation: [lindex $args $option]";return -code error }
        }
      }
    

      if { $linux_bif==true && [string match $app "<elf,psu_cortexa53_0>"]} {
        set app_exception_level "el-2"
        set app "<u-boot.elf>"
      }
      set bif_fp [open "$biffile" w]

      if { $linux_bif==true} {
        puts $bif_fp "/* linux */"
      } else {
        puts $bif_fp "/* bare-metal */"
      }
      puts $bif_fp "/*auto-generated on [ clock format [clock seconds] -format "%Y/%m/%d %H:%M:%S"] */"
      
      puts $bif_fp "//arch = zynqmp; split = false; format = BIN"
      puts $bif_fp "the_ROM_image:\n\u007B"
      #bootloader and bootloader_cpu
      puts -nonewline $bif_fp "  \[bootloader, destination_cpu= $bootloader_cpu \]"
      puts $bif_fp $bootloader
      #pmuf
      if { $linux_bif == true ||$pmu_use == true } {
        puts -nonewline $bif_fp {  [pmufw_image]}
        puts $bif_fp $pmu
      }
      #bitfile
      if {$bitfile_use == true  } {
        puts -nonewline $bif_fp "  \[destination_device = pl\]"
        puts $bif_fp $bitfile
      }
      #atf 
      if {$linux_bif == true ||$atf_use == true } {
        puts -nonewline $bif_fp "  \[destination_cpu = $atf_cpu, exception_level = $atf_exception_level, trustzone\]"
        puts $bif_fp $atf
      }
      #app
      if {$linux_bif == true  ||$app_use == true } {
				if {$app_exception_level == ""  ||$app_exception_level == "NA" } {
					puts -nonewline $bif_fp "  \[destination_cpu = $app_cpu\]"
					puts $bif_fp $app
				} else {
					puts -nonewline $bif_fp "  \[destination_cpu = $app_cpu, exception_level = $app_exception_level\]"
					puts $bif_fp $app
				}
      }
      #app extention(uboot device tree)
      if {$linux_bif == true  && $uboot_dtb_use == true } {
        puts -nonewline $bif_fp "  \[destination_cpu = $app_cpu, load = $uboot_dtb_load\]"
        puts $bif_fp $uboot_dtb
      }
      #boot.scr for linux (todo test)
      if {$linux_bif == true  && $bscr_use == true } {
        puts -nonewline $bif_fp "  \[load = $bscr_load\]"
        puts $bif_fp $bscr
      }
      #file 
			set data_file [split $data_file "|"]
			set data_load [split $data_load "|"]
			set data_offset [split $data_offset "|"]

      for {set i 0} {$i < [llength $data_file]} {incr i} {
				if {![string match "" "[lindex $data_file $i]"] && ![string match "NA" "[lindex $data_file $i]"]} {
					if {[string match "" "[lindex $data_offset $i]"] || [string match "NA" "[lindex $data_offset $i]"]} {
					puts -nonewline $bif_fp "  \[load =  [lindex $data_load $i]\]"
					} else {
					puts -nonewline $bif_fp "  \[offset =  [lindex $data_offset $i]\]"
					}    
					puts $bif_fp  [lindex $data_file $i]
				}
      }
       
      puts $bif_fp "\u007D"

      close $bif_fp
       
    }
    
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished additional functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    
  }
  puts "INFO:(TE) Load Utilities script finished"
}


