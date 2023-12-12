# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Beendorfer Str. 23      *
# --   *   32609 Hüllhorst         *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# -- $Author :  Hartfiel, John $
# -- $Email :   j.hartfiel@trenz-electronic.de$
# --------------------------------------------------------------------
# -- Change History:
# ------------------------------------------
# -- $Date: 2016/04/11 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2016/10/06  | $Author: Hartfiel, John
# -- - miscellaneous
# ------------------------------------------
# -- $Date: 2017/05/05  | $Author: Pohl, Zdenek
# -- -sdsoc 2016.4 platform export support, new platform directory structure and new master metafile
# ------------------------------------------
# -- $Date: 2017/07/02  | $Author: Pohl, Zdenek
# -- - sdsoc 2017.1 modifications. Platform utility now used for creating platform
# ------------------------------------------
# -- $Date: 2017/09/07  | $Author: Hartfiel, John
# -- - add new document history style
# -- - create messages ids
# -- - clean-up script
# -- - add new SDSoC predefined path structure
# -- - split zynqmp and zynq devices 
# -- - new folder structure 
# ------------------------------------------
# -- $Date: 2007/09/25  | $Author: Hartfiel, John
# -- - bugfix check_and_modify_vivado_project messages status only
# ------------------------------------------
# -- $Date: 2017/09/27  | $Author: Pohl, Zdenek
# -- - removed generation of linux target when preparing platform 
# --   for collection of prebuilt files (speed optimization)
# -- - added detection of platform dependent libraries, if detected 
# --   one library for each target, they are included to platform
# -- - moved some comments to better track process of platform creation
# ------------------------------------------
# -- $Date: 2017/10/04  | $Author: Pohl, Zdenek
# -- - Fixed sdsoc platform generation for Zynq family devices
# --    - using name zynq_fsbl.elf instead of fsbl.elf (ZU+ uses zynqmp_fsbl.elf)
# --    - project design name check now has 2 branches first for zynq (ZSYS) second for zynqmp (ZUSYS)
# --    - fixed typo in linux_path for zynq target
# ------------------------------------------
# -- $Date: 2018/02/01  | $Author: Pohl, Zdenek
# -- - new hardware platform export, from 2017.4 generates .dsa archive for sdsoc
# -- - new software platform export, now uses tcl files to command xsct to export the platform (as explained in UG1146)
# -- - board part is now not removed before platform export
# -- - sdsoc export supports only zusys with no software libraries
# -- - TODO: support libraries for platform, support zsys systems
# ------------------------------------------
# -- $Date: 2018/03/29  | $Author: Pohl, Zdenek
# -- - automatically add bsp headers from hsi generated helloworld app to platform (hio uses them to directly talk with video chain through mmaped I/O)
# --   sdsoc export now reqires to generate helloworld application to get the right bsp headers for each assembly
# --   the header are added to platform only if .a library is found, otherwise they are prepared but not used in platform
# ------------------------------------------
# -- $Date: 2018/04/12  | $Author: Pohl, Zdenek
# -- - fixed platform export branch for zynq systems
# ------------------------------------------
# -- $Date: 2018/05/17  | $Author: Hartfiel, John
# -- - change platform export path
# -- - add zip file (optional)
# ------------------------------------------
# -- $Date: 2018/06/21  | $Author: Kohout, Lukas
# -- - include folder for platform export now created explicitly before collecting files to it, fixes Linux flow
# -- - added actual OS info message to log
# -- - xsct calls for platform export now differs for win and linux OS, fixes Linux flow
# -- - before platform is exported the old one in target location is deleted first
# -- - zip file export now differs for Linux and Win flow, fixes linux flow
# ------------------------------------------
# -- $Date: 2018/08/23  | $Author: Pohl, Zdenek
# -- - xsct call is now not OS dependent, branches removed
# -- - tcl console messages fixed
# ------------------------------------------
# -- $Date: 2019/08/12  | $Author: Pohl, Zdenek
# -- - added empty repository folder for generation of prebuids for platform
# --   it is required for the case when in platform is used IP core with 
# --   drivers folder
# ------------------------------------------
# -- $Date: 2019/08/21  | $Author: Pohl, Zdenek
# -- - check helloworld aplication was compiled (required to get bsp for generated platform)
# --   adds bsp headers also to the standalone platform
# --   platform export script is now identical for zsys and zusys
# --   
# --------------------------------------------------------------------
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- -
# --------------------------------------------------------------------
# --------------------------------------------------------------------
namespace eval ::TE {
  namespace eval SDSOC {
    #------------------------------------
    #--create_sdsoc_structure: ...
    proc create_sdsoc_structure {} {
    #clear old sdsoc
      # file mkdir ${TE::SDSOC_PATH}
      TE::UTILS::te_msg TE_SDSOC-0 STATUS "Create new SDSOC Platform Output Folder (${TE::SDSOC_PATH})."
      if {[file exists ${TE::TMP_PATH}]} { 
        if {[catch {file delete -force ${TE::TMP_PATH}} result]} {TE::UTILS::TE_SDSOC-1 ERROR " $result"}
      }
      if {![file exists ${TE::SDSOC_PATH}]} { 
        file mkdir ${TE::SDSOC_PATH}
      }
      if {[file exists ${TE::SDSOC_PATH}/${TE::SHORTDIR}]} { 
        if {[catch {file delete -force ${TE::SDSOC_PATH}/${TE::SHORTDIR}} result]} {TE::UTILS::TE_SDSOC-2 ERROR " $result"}
      }

	  # creating tmp directory for sdsoc platform generator 
      #copy default sdsoc source to tmp
      if {[file exists ${TE::SET_PATH}/sdsoc/predefined]} {
        file copy -force ${TE::SET_PATH}/sdsoc/predefined ${TE::TMP_PATH}
      } else {
         TE::UTILS::te_msg TE_SDSOC-3 ERROR "Predefined SDSoC sources not found on ${TE::SET_PATH}/sdsoc/predefined."
         return -code error;
      }
      
      #check if  hello world application exist
      set hello_world [glob -nocomplain -directory "${TE::WORKSPACE_HSI_PATH}" hello_*]
      set hello_world_name [file tail $hello_world]
      if {[llength $hello_world] == 1} {
	  TE::UTILS::te_msg TE_SDSOC-4 INFO "Hello_world application found, using BSP headers"
      } else {
	  TE::UTILS::te_msg TE_SDSOC-5 ERROR "Hello_world application NOT found, platform cannot be exported"
	  return -code error;
      }
      

      # create bsp_include folder and copy headers from hello world app compiled by hsi
      if {$TE::IS_ZSYS} {
	  set linux_path a9_linux
	  set cpu_type ps7_cortexa9
	  set standalone_path a9_standalone
      }
      if {$TE::IS_ZUSYS} {
	  set linux_path a53_linux
	  set cpu_type psu_cortexa53
	  set standalone_path a53_standalone
      }
      if {[file exists $hello_world]} {
	  set files [glob -directory "${hello_world}/${hello_world_name}_bsp/${cpu_type}_0/include" *]

	  # create linux "include" folder before writing its content
      if {![file exists ${TE::TMP_PATH}/sw/${linux_path}/include/]} {
         file mkdir ${TE::TMP_PATH}/sw/${linux_path}/include/
      }  
	  # create standalone "include" folder before writing its content
	  if {![file exists ${TE::TMP_PATH}/sw/${standalone_path}/include/]} {
	      file mkdir ${TE::TMP_PATH}/sw/${standalone_path}/include/
	  } 
 
	  # copy all headers from BSP but sleep.h for linux
	  foreach fname $files {
	      file copy -force $fname ${TE::TMP_PATH}/sw/${linux_path}/include
	  }
	  file delete -force ${TE::TMP_PATH}/sw/${linux_path}/include/sleep.h

	  #copy all headers for standalone
	  foreach fname $files {
	      file copy -force $fname ${TE::TMP_PATH}/sw/${standalone_path}/include
	  }
      } else { 
	  TE::UTILS::te_msg TE_SDSOC-6 ERROR "Platform cannot be exported without BSP headers"
	  return -code error;
      }
      
      if {$TE::IS_ZUSYS} { #zynqMP
        # --------------------------------------------
        #linker scripts for standalone apps (default or for special for assembly variant)
        set linker_script ${TE::SET_PATH}/sdsoc/generic/sw/a53_standalone/lscript.ld_default
        if {[file exists ${TE::SET_PATH}/sdsoc/generic/sw/a53_standalone/lscript.ld_${TE::SHORTDIR}]} {
          set linker_script ${TE::SET_PATH}/sdsoc/generic/sw/a53_standalone/lscript.ld_${TE::SHORTDIR}
        }
        if {[file exists ${linker_script}]} {
          file copy -force ${linker_script} ${TE::TMP_PATH}/sw/a53_standalone/lscript.ld
        } else {
         TE::UTILS::te_msg TE_SDSOC-7  {CRITICAL WARNING} "Predefined Linker Script not found on ${TE::SET_PATH}/sdsoc/generic/sw/a53_standalone/."
        }
        # --------------------------------------------
        # prebuilt files
        # set search paths
        set prebuilt_pl_path ${TE::PREBUILT_OS_PATH}/petalinux/default
        if {[file exists ${TE::PREBUILT_OS_PATH}/petalinux/${TE::SHORTDIR}]} {
            set prebuilt_pl_path ${TE::PREBUILT_OS_PATH}/petalinux/${TE::SHORTDIR}
        }
        set prebuilt_sw_path ${TE::PREBUILT_SW_PATH}/default
        if {[file exists ${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR}]} {
            set prebuilt_sw_path ${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR}
        }
        # ---------------
        # fsbl
        set elf_list []
        if { [catch {set elf_list [ glob ${prebuilt_pl_path}/*.elf ] }] } {
	      } else {
          foreach elf $elf_list {
              # if found copy fsbl
              if {[string match *fsbl* $elf]} {
                file copy -force $elf ${TE::TMP_PATH}/sw/a53_linux/boot/zynqmp_fsbl.elf
                file copy -force $elf ${TE::TMP_PATH}/sw/a53_standalone/boot/zynqmp_fsbl.elf
              }
          }
	      }
        # sdk prebuilt overwrites petalinux prebuilt
        set elf_list []
	      if { [catch {set elf_list [ glob ${prebuilt_sw_path}/*.elf ] }] } {
	      } else {
          foreach elf $elf_list {
              # if found copy fsbl
              if {[string match *fsbl* $elf]} {
                file copy -force $elf ${TE::TMP_PATH}/sw/a53_linux/boot/zynqmp_fsbl.elf
                file copy -force $elf ${TE::TMP_PATH}/sw/a53_standalone/boot/zynqmp_fsbl.elf
              }
          }
	      }
        #todo message if file not found
        # ---------------
        # pmufw (for linux only)
        set elf_list []
        if { [catch {set elf_list [ glob ${prebuilt_pl_path}/*.elf ] }] } {
	      } else {
          foreach elf $elf_list {
              if {[string match *pmufw* $elf]} {
                file copy -force $elf ${TE::TMP_PATH}/sw/a53_linux/boot/zynqmp_pmufw.elf
                file copy -force $elf ${TE::TMP_PATH}/sw/a53_standalone/boot/zynqmp_pmufw.elf
              }
          }
	      }
        # sdk prebuilt overwrites petalinux prebuilt
        set elf_list []
	      if { [catch {set elf_list [ glob ${prebuilt_sw_path}/*.elf ] }] } {
	      } else {
          foreach elf $elf_list {
              if {[string match *pmufw* $elf]} {
                file copy -force $elf ${TE::TMP_PATH}/sw/a53_linux/boot/zynqmp_pmufw.elf
                file copy -force $elf ${TE::TMP_PATH}/sw/a53_standalone/boot/zynqmp_pmufw.elf
              }
          }
	      }
        #todo message if file not found
        # ---------------
        # bl31 (ATF) (for linux only)
        set elf_list []
        if { [catch {set elf_list [ glob ${prebuilt_pl_path}/*.elf ] }] } {
	      } else {
          foreach elf $elf_list {
              if {[string match *bl31* $elf]} {
                file copy -force $elf ${TE::TMP_PATH}/sw/a53_linux/boot/bl31.elf
                # file copy -force $elf ${TE::TMP_PATH}/sw/a53_standalone/boot/bl31.elf
              }
          }
	      }
        #todo message if file not found
        # ---------------
        # u-boot (for linux only)
        set elf_list []
        if { [catch {set elf_list [ glob ${prebuilt_pl_path}/*.elf ] }] } {
	      } else {
          foreach elf $elf_list {
              if {[string match *u-boot* $elf]} {
                file copy -force $elf ${TE::TMP_PATH}/sw/a53_linux/boot/u-boot.elf
                # file copy -force $elf ${TE::TMP_PATH}/sw/a53_standalone/boot/u-boot.elf
              }
          }
	      }
        #todo message if file not found
        # ---------------
        # image.ub (for linux only)
        set image_list []
        if { [catch {set image_list [ glob ${prebuilt_pl_path}/*.ub ] }] } {
	      } else {
          foreach img $image_list {
              if {[string match *image* $img]} {
                file copy -force $image_list ${TE::TMP_PATH}/sw/a53_linux/image/image.ub
              }
          }
	      }
        #todo message if file not found
      } elseif {$TE::IS_ZSYS} { #zynq 7000
        # --------------------------------------------
        #linker scripts for standalone apps (default or for special for assembly variant)
        set linker_script ${TE::SET_PATH}/sdsoc/generic/sw/a9_standalone/lscript.ld_default
        if {[file exists ${TE::SET_PATH}/sdsoc/generic/sw/a9_standalone/lscript.ld_${TE::SHORTDIR}]} {
          set linker_script ${TE::SET_PATH}/sdsoc/generic/sw/a9_standalone/lscript.ld_${TE::SHORTDIR}
        }
        if {[file exists ${linker_script}]} {
          file copy -force ${linker_script} ${TE::TMP_PATH}/sw/a9_standalone/lscript.ld
        } else {
         TE::UTILS::te_msg TE_SDSOC-8  {CRITICAL WARNING} "Predefined Linker Script not found on ${TE::SET_PATH}/sdsoc/generic/sw/a9_standalone/."
        }
        # --------------------------------------------
        # prebuilt files
        # set search paths
        set prebuilt_pl_path ${TE::PREBUILT_OS_PATH}/petalinux/default
        if {[file exists ${TE::PREBUILT_OS_PATH}/petalinux/${TE::SHORTDIR}]} {
            set prebuilt_pl_path ${TE::PREBUILT_OS_PATH}/petalinux/${TE::SHORTDIR}
        }
        set prebuilt_sw_path ${TE::PREBUILT_SW_PATH}/default
        if {[file exists ${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR}]} {
            set prebuilt_sw_path ${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR}
        }
        # ---------------
        # fsbl
        set elf_list []
        if { [catch {set elf_list [ glob ${prebuilt_pl_path}/*.elf ] }] } {
	      } else {
          foreach elf $elf_list {
              # if found copy fsbl
              if {[string match *fsbl* $elf]} {
                file copy -force $elf ${TE::TMP_PATH}/sw/a9_linux/boot/zynq_fsbl.elf
                file copy -force $elf ${TE::TMP_PATH}/sw/a9_standalone/boot/zynq_fsbl.elf
              }
          }
	      }
        # sdk prebuilt overwrites petalinux prebuilt
        set elf_list []
	      if { [catch {set elf_list [ glob ${prebuilt_sw_path}/*.elf ] }] } {
	      } else {
          foreach elf $elf_list {
              # if found copy fsbl
              if {[string match *fsbl* $elf]} {
                file copy -force $elf ${TE::TMP_PATH}/sw/a9_linux/boot/zynq_fsbl.elf
                file copy -force $elf ${TE::TMP_PATH}/sw/a9_standalone/boot/zynq_fsbl.elf
              }
          }
	      }
        #todo message if file not found
        # ---------------
        # u-boot (for linux only)
        set elf_list []
        if { [catch {set elf_list [ glob ${prebuilt_pl_path}/*.elf ] }] } {
	      } else {
          foreach elf $elf_list {
              if {[string match *u-boot* $elf]} {
                file copy -force $elf ${TE::TMP_PATH}/sw/a9_linux/boot/u-boot.elf
                # file copy -force $elf ${TE::TMP_PATH}/sw/a9_standalone/boot/u-boot.elf
              }
          }
	      }
        #todo message if file not found
        # ---------------
        # image.ub (for linux only)
        set image_list []
        if { [catch {set image_list [ glob ${prebuilt_pl_path}/*.ub ] }] } {
	      } else {
          foreach img $image_list {
              if {[string match *image* $img]} {
                file copy -force $image_list ${TE::TMP_PATH}/sw/a9_linux/image/image.ub
              }
          }
	      }
        #todo message if file not found
      } else {
        TE::UTILS::te_msg TE_SDSOC-9 Error "Script only for Zynq or ZynqMP systems"
        return -code error;
      }
    }
      
    #---------------------------------------------------------------------------  
      
      
      
    #------------------------------------
    #--check_vivado_project: ...
    proc check_and_modify_vivado_project {check_only} {
      set er_det false
      set war_det false
      set te_txt  "SDSOC design check: \n\
      \ Notes: \n\
      \   -Errors: could not fixed automatically.\n\
      \   -Warnings: will be fixed automatically and can be ignored.\n\
      \ Check design: starts:\n"
      if {!$check_only} { TE::UTILS::te_msg TE_SDSOC-10 STATUS "Start project modification for SDSoC."}
      
      #------------------
      #check sdsoc environment :
      #
      set te_txt "$te_txt\   - Check SDSOC environment:"
      if {!$TE::SDSOC_AVAILABLE} {
          set te_txt "$te_txt\ failed.\n"
          set er_det true
          if {!$check_only} {
            TE::UTILS::te_msg TE_SDSOC-11 ERROR $te_txt
            return -code error $te_txt
          }
      } else {set te_txt "$te_txt\ passed.\n";}
      #------------------
      # check project name (TE Script restriction)
      #
      set te_txt "$te_txt\   - Check Project Design Name:"
      if {$TE::IS_ZUSYS} {
	# check project design name for Zynq Ultrascale device family
        if {![string match *zusys*  ${TE::VPROJ_NAME}]} {
          set te_txt "$te_txt\ failed (Name must contain *zusys*).\n";
          set er_det true
          if {!$check_only} {

            TE::UTILS::te_msg TE_SDSOC-12 ERROR $te_txt
            return -code error $te_txt
          }
        } else {set te_txt "$te_txt\ passed.\n";}
      } elseif {$TE::IS_ZSYS} {  
	# check project design name for Zynq device family
        if {![string match *zsys*  ${TE::VPROJ_NAME}]} {
          set te_txt "$te_txt\ failed (Name must contain *zsys*).\n";
          set er_det true
          if {!$check_only} {

            TE::UTILS::te_msg TE_SDSOC-13 ERROR $te_txt
            return -code error $te_txt
          }
        } else {set te_txt "$te_txt\ passed.\n";}
      }
      #------------------
      #check #of bd files:
      #currently only one bdfile supported (TE restriction)
      set te_txt "$te_txt\   - Check Block Design quantity:"
      set bd_files []
      if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
          set te_txt "$te_txt\ failed (BD not available).\n";
          set er_det true
          if {!$check_only} {
            TE::UTILS::te_msg TE_SDSOC-14 ERROR $te_txt
            return -code error $te_txt
          } 
      } elseif {[llength $bd_files]>1 } {
          set te_txt "$te_txt\ failed (more than one BD).\n";
          set er_det true
          if {!$check_only} {
            TE::UTILS::te_msg TE_SDSOC-15 ERROR $te_txt
            return -code error $te_txt
          }
      } else {set te_txt "$te_txt\ passed.\n";}

      #------------------
      # check top block design name equal VPROJ_NAME
      #
      set te_txt "$te_txt\   - Check Block Design Name:"
      set bd $bd_files
      # open_bd_design $bd -quiet
      # set bd_name [get_bd_designs]
      set bd_name [open_bd_design $bd -quiet]
      if {![string match ${TE::VPROJ_NAME} $bd_name]} {
        set te_txt "$te_txt\ failed (BD (${bd_name}) unequal PRJ(${TE::VPROJ_NAME})).\n";
        set er_det true
        # set war_det true  --> change to er to war, if rename is complete implemented
        if {!$check_only} {
          #Note: TODO reload bd without close project. This is possible on this step. At the moment only failed
          # change block design name in tcl file
          # if {[file exists "${TE::BD_PATH}/${bd_name}_bd.tcl"]} {
              # #file exists, replace add correct platform name at the first line of the file
              # # open file for reading
              # set frd [open "${TE::BD_PATH}/${bd_name}_bd.tcl" r]
              
              # # open output file
              # set fwr [open "${TE::BD_PATH}/${bd_name}_bd.tcl.temp" w]
              
              # # read lines, replace required string and write result to file
              # while { [gets $frd line] >= 0 } {
            # if {[string match "set design_name *" $line]} {
                # set res "set design_name ${TE::VPROJ_NAME}"
            # } else {
                # set res $line
            # }
            # puts $fwr $res 
              # }
              
              # # close files
              # close $frd
              # close $fwr
              
              # #delete old file
              # file rename -force "${TE::BD_PATH}/${bd_name}_bd.tcl.temp" "${TE::BD_PATH}/${bd_name}_bd.tcl"
              # #Note: TODO reload bd without close project. This is possible on this step. At the moment only failed
            
           
              # return -code error "Follow steps above to setup design with new name"
          # } else {
              # return -core error "Block design TCL backup file (${TE::BD_PATH}/${bd_name}_bd.tcl) not found."
          # }	
          TE::UTILS::te_msg TE_SDSOC-16 ERROR $te_txt
          return -code error $te_txt
        }
      } else {set te_txt "$te_txt\ passed.\n";}
      close_bd_design [get_bd_designs $bd]

    }

    #------------------------------------
    #--export_vivado_project: ...
    proc export_vivado_sdsoc_project {} {
          TE::UTILS::te_msg TE_SDSOC-17 STATUS "Start SDSoC export."
	
	#find constrain files 
	set xdc_files [TE::UTILS::search_xdc_files]  
	#add constrain files localy to .srcs folder, this way dsa export will include them correctly for use in sdsoc
	import_files -force -fileset constrs_1 ${xdc_files}


	#write hw project archive
	write_dsa -verbose -force -include_bit ${TE::TMP_PATH}/hw/${TE::VPROJ_NAME}.dsa
	#run dsa archive validator
	validate_dsa -verbose ${TE::TMP_PATH}/hw/${TE::VPROJ_NAME}.dsa

    }

    #------------------------------------
    #--create_sdsoc_pfm: ...
    proc create_sdsoc_pfm {} {
      TE::UTILS::te_msg TE_SDSOC-18 STATUS "Create SDSoC Platform Project."

      # Get host OS
      set host_os [TE::UTILS::get_host_os]
      switch ${host_os} {
          "windows" {
              TE::UTILS::te_msg TE_SDSOC-19 INFO "Host OS: Windows"	
          }
          "unix" {
              TE::UTILS::te_msg TE_SDSOC-20 INFO "Host OS: Linux/Unix"	
          }
      }
      
      
      # set correct architecture dependent paths and files
      if {$TE::IS_ZSYS} {

          set standalone_path a9_standalone
          set linux_path a9_linux
          set ps_type zsys
      } elseif {$TE::IS_ZUSYS} {

          set standalone_path a53_standalone
          set linux_path a53_linux
          set ps_type zusys
      } else {
          TE::UTILS::te_msg TE_SDSOC-21 ERROR "Unknown system architecture, only ZYNQ and ZynqMP supported."
      }
      
      file mkdir ${TE::TMP_PATH}/PF

      # create platform export settings file 
      # open output file
      set fwr [open ${TE::TMP_PATH}/pfm_settings.tcl w]
      puts $fwr "set design_name ${TE::VPROJ_NAME}"
      puts $fwr "set tmp_path ${TE::TMP_PATH}"
      puts $fwr "set standalone_path ${standalone_path}"
      puts $fwr "set linux_path ${linux_path}"
      puts $fwr "set is_zsys ${TE::IS_ZSYS}"
      puts $fwr "set is_zusys ${TE::IS_ZUSYS}"
      close $fwr

      file copy -force ${TE::SET_PATH}/sdsoc/generic/pfm_description.tcl ${TE::TMP_PATH}

      TE::UTILS::te_msg TE_SDSOC-22 INFO "Exporting SDSoC platform takes a long time, do not interrupt."
      #call platform utility
      TE::UTILS::te_msg TE_SDSOC-23 INFO "Preparing prebuilt files (Note: can take long time) "

      set old_dir [pwd]	

      cd ${TE::TMP_PATH}
      exec xsct -sdx ${TE::SET_PATH}/sdsoc/generic/sdsoc_simple_pfm.tcl
      #add empty drivers folder, it is searched when platform is compiled when IP core in vivado have drivers packed inside
      file mkdir ${TE::TMP_PATH}/PF/${TE::VPROJ_NAME}/export/${TE::VPROJ_NAME}/hw/drivers
      TE::UTILS::te_msg TE_SDSOC-24 INFO "Prepared simple standalone platform"

      #--------------------
      # build platform for the first time to get files for prebuilt section of the platform. Do not generate bitstream (we already have one from step TE::hw_build_design -export_prebuilt)
      cd ${TE::TMP_PATH}/empty_app
      TE::UTILS::te_msg TE_SDSOC-25 INFO "Cleaning prebuilt files for platfrom"	
      exec make OS=STANDALONE PLATFORM=../PF/${TE::VPROJ_NAME}/export/${TE::VPROJ_NAME} clean
      TE::UTILS::te_msg TE_SDSOC-26 INFO "Generating platform prebuilt files"	
      exec make OS=STANDALONE PLATFORM=../PF/${TE::VPROJ_NAME}/export/${TE::VPROJ_NAME} >make.log 2>make.errlog

      TE::UTILS::te_msg TE_SDSOC-27 INFO "Collecting prebuilt files."
      # clean all and collect prebuilt files from compiled empty sw application
      file mkdir ${TE::TMP_PATH}/prebuilt
      file copy\
          "${TE::TMP_PATH}/empty_app/_sds/swstubs/portinfo.c"\
          "${TE::TMP_PATH}/empty_app/_sds/swstubs/portinfo.h"\
          "${TE::TMP_PATH}/empty_app/_sds/.llvm/apsys_0.xml"\
          "${TE::TMP_PATH}/empty_app/_sds/.llvm/partitions.xml"\
          "${TE::TMP_PATH}/empty_app/_sds/p0/vpl/system.hdf"\
          "${TE::TMP_PATH}/prebuilt"

      #rename hdf to platform name
      file rename -force "${TE::TMP_PATH}/prebuilt/system.hdf" "${TE::TMP_PATH}/prebuilt/${TE::VPROJ_NAME}.hdf"

      # add bitstream to prebuilt files
      file copy "${TE::PREBUILT_HW_PATH}/${TE::SHORTDIR}/${TE::VPROJ_NAME}.bit" "${TE::TMP_PATH}/prebuilt/bitstream.bit"

      TE::UTILS::te_msg TE_SDSOC-28 INFO "Creating SDSoC platform with prebuilt files and libraries."	

      cd ${TE::TMP_PATH}
      exec xsct -sdx ${TE::SET_PATH}/sdsoc/generic/sdsoc_pfm.tcl

      # change directory back
      cd ${old_dir}

      # cp SDSoC from tmp to SDSoC 
      
      set splitt_prod_id [split $TE::PRODID "-"]
      set series_name "Test-01"
      set assembly_option "others"
      if { [llength $splitt_prod_id] >2} {
        set series_name "[lindex $splitt_prod_id 0]-[lindex $splitt_prod_id 1]"
        set assembly_option [lindex $splitt_prod_id 2]
        for {set x 3} {$x < [llength $splitt_prod_id]} {incr x} {
            set assembly_option "$assembly_option-[lindex $splitt_prod_id $x]"
        }
      } else {
        set series_name "[lindex $splitt_prod_id 0]"
        set assembly_option "[lindex $splitt_prod_id 1]"
      }
      
      TE::UTILS::te_msg TE_SDSOC-29 INFO "Export SDSoC platform"	
      set platform_path ${TE::SDSOC_PATH}/${series_name}/${assembly_option}
      # delete previously generated platform folder
      if { [file exists ${platform_path}] } {
          if {[catch {file delete -force ${platform_path}} result]} {TE::UTILS::te_msg TE_SDSOC-30 ERROR " $result"}
      }      
      file mkdir ${platform_path}
      if {[catch {file copy -force ${TE::TMP_PATH}/PF/${TE::VPROJ_NAME}/export/${TE::VPROJ_NAME} ${platform_path}} result]} {TE::UTILS::te_msg TE_SDSOC-31 ERROR " $result"}

      #delete tmp dir
      if {[file exists ${TE::TMP_PATH}]} { 
        if {[catch {file delete -force ${TE::TMP_PATH}} result]} {TE::UTILS::te_msg TE_SDSOC-32 ERROR " $result"}
      }

      #zip file
      set cur_path [pwd]
      cd ${TE::SDSOC_PATH}/${series_name}
      set date "[ clock format [clock seconds] -format "%Y%m%d%H%M%S"]"
      set zipname "SDSoC_PFM_${TE::PRODID}_${date}"
      #ignore if zip not works
      switch ${host_os} {
          "windows" {
              if {[catch [TE::EXT::zip_general $platform_path $zipname]]} {
                  TE::UTILS::te_msg TE_SDSOC-33 INFO "Generate platform zip failed"
              }
          }
          "unix" {
              if {[catch [TE::EXT::zip_general $assembly_option $zipname]]} {
                  TE::UTILS::te_msg TE_SDSOC-34 INFO "Generate platform zip failed"
              }
          }
      }
      
      cd $cur_path
    }
  }
  puts "INFO:(TE) Load SDSoC script finished"
}

