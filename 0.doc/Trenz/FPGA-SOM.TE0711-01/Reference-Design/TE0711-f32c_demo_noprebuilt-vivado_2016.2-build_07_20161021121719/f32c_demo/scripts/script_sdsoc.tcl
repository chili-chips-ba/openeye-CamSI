# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Holzweg 19A             *
# --   *   32257 Bünde             *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# --$Autor: Hartfiel, John $
# --$Email: j.hartfiel@trenz-electronic.de $
# --$Create Date:2016/04/11 $
# --$Modify Autor: Hartfiel, John $
# --$Modify Date: 2016/10/06 $
# --------------------------------------------------------------------
# --------------------------------------------------------------------
namespace eval TE {
  namespace eval SDSOC {
 
    #------------------------------------
    #--create_sdsoc_structure: ...
    proc create_sdsoc_structure {} {
      #clear old sdsoc
      puts "Info:(TE) Delete old SDSOC Project Structure (${TE::SDSOC_PATH})."
      TE::UTILS::clean_sdsoc
      puts "Info:(TE) Create new SDSOC Project Structure(${TE::SDSOC_PATH})."
      file mkdir ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
      #--------------------
      #old 2015.4
      # if {[file exists ${TE::SET_PATH}/sdsoc/arm-xilinx-eabi]} {
        # file copy -force ${TE::SET_PATH}/sdsoc/arm-xilinx-eabi ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
      # } else {
        # file mkdir ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/arm-xilinx-eabi
      # }
      # if {[file exists ${TE::SET_PATH}/sdsoc/arm-xilinx-linux-gnueabi]} {
        # file copy -force ${TE::SET_PATH}/sdsoc/arm-xilinx-linux-gnueabi ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
      # } else {
        # file mkdir ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/arm-xilinx-linux-gnueabi
      # }
      #new 2016.2
      #different settings between 7Series and UltraScaleZynq 
      if {$TE::IS_ZSYS || $TE::IS_MSYS } {
        if {[file exists ${TE::SET_PATH}/sdsoc/aarch32-none]} {
          file copy -force ${TE::SET_PATH}/sdsoc/aarch32-none ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
          #used for different memory versions
          if {[file exists ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch32-none/lscript.ld_${TE::SHORTDIR}]} {
            if {[file exists ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch32-none/lscript.ld]} {
              file delete -force ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch32-none/lscript.ld
            }
            file copy -force ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch32-none/lscript.ld_${TE::SHORTDIR} ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch32-none/lscript.ld
          }
        } else {
          file mkdir ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch32-none
        }
      } elseif {$TE::IS_ZUSYS} {
        if {[file exists ${TE::SET_PATH}/sdsoc/aarch64-none-elf]} {
          file copy -force ${TE::SET_PATH}/sdsoc/aarch64-none-elf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
          #used for different memory versions
          if {[file exists ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch64-none-elf/lscript.ld_${TE::SHORTDIR}]} {
            if {[file exists ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch64-none-elf/lscript.ld]} {
              file delete -force ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch64-none-elf/lscript.ld
            }
            file copy -force ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch64-none-elf/lscript.ld_${TE::SHORTDIR} ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch64-none-elf/lscript.ld
          }
        } else {
          file mkdir ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/aarch64-none-elf
        }
      }
      #--------------------
        if {[file exists ${TE::SET_PATH}/sdsoc/boot]} {
          file copy -force ${TE::SET_PATH}/sdsoc/boot ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
          set prebuit_pl_path ${TE::PREBUILT_OS_PATH}/petalinux/default/
          if {[file exists ${TE::PREBUILT_OS_PATH}/petalinux/${TE::SHORTDIR}]} {
            set prebuit_pl_path ${TE::PREBUILT_OS_PATH}/petalinux/${TE::SHORTDIR}
          }
          if {$TE::IS_ZSYS || $TE::IS_MSYS } {
            #search for petalinux generated fsbl.elf
            set elf_list []
            if { [catch {set elf_list [ glob ${prebuit_pl_path}/*.elf ] }] } {
            } else {
              foreach elf $elf_list {
                if {[string match *fsbl* $elf]} {
                  file copy -force $elf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/zynq_fsbl.elf
                }
              }
            }
            #search for sdk generated fsbl.elf -> overwrite petalinux fsbl.elf if exist
            set elf_list []
            if { [catch {set elf_list [ glob ${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR}/*.elf ] }] } {
            } else {
              foreach elf $elf_list {
                if {[string match *fsbl* $elf]} {
                  file copy -force $elf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/zynq_fsbl.elf
                }
              }
            }
            #copy rest of prebuilt files
            # if {[file exists ${prebuit_pl_path}/urootfs.cpio.gz]} {
              # file copy -force ${prebuit_pl_path}/urootfs.cpio.gz ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/uramdisk.image.gz
            # } 
            # if {[file exists ${prebuit_pl_path}/system.dtb]} {
              # file copy -force ${prebuit_pl_path}/system.dtb ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/devicetree.dtb
            # } 
            # if {[file exists ${prebuit_pl_path}/uImage]} {
              # file copy -force ${prebuit_pl_path}/uImage ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/
            # } 
            if {[file exists ${prebuit_pl_path}/image.ub]} {
              file copy -force ${prebuit_pl_path}/image.ub ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/
            } 
            if {[file exists ${prebuit_pl_path}/u-boot.elf]} {
              file copy -force ${prebuit_pl_path}/u-boot.elf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/
            } 
          } elseif {$TE::IS_ZUSYS} {
            #search for petalinux generated fsbl.elf
            set elf_list []
            if { [catch {set elf_list [ glob ${prebuit_pl_path}/*.elf ] }] } {
            } else {
              foreach elf $elf_list {
                if {[string match *fsbl* $elf]} {
                  file copy -force $elf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/fsbl.elf
                }
              }
            }
            #search for sdk generated fsbl.elf -> overwrite petalinux fsbl.elf if exist
            set elf_list []
            if { [catch {set elf_list [ glob ${TE::PREBUILT_SW_PATH}/${TE::SHORTDIR}/*.elf ] }] } {
            } else {
              foreach elf $elf_list {
                if {[string match *fsbl* $elf]} {
                  file copy -force $elf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/fsbl.elf
                }
              }
            }
            # #copy rest of prebuilt files
            # if {[file exists ${prebuit_pl_path}/urootfs.cpio.gz]} {
              # file copy -force ${prebuit_pl_path}/urootfs.cpio.gz ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/uramdisk.tar.gz
            # } 
            # if {[file exists ${prebuit_pl_path}/system.dtb]} {
              # file copy -force ${prebuit_pl_path}/system.dtb ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/
            # } 
            # if {[file exists ${prebuit_pl_path}/uImage]} {
              # file copy -force ${prebuit_pl_path}/uImage ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/
            # } 
            # if {[file exists ${prebuit_pl_path}/bl31.elf]} {
              # file copy -force ${prebuit_pl_path}/bl31.elf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/
            # } 
            # if {[file exists ${prebuit_pl_path}/u-boot.elf]} {
              # file copy -force ${prebuit_pl_path}/u-boot.elf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/
            # } 
            #copy rest of prebuilt files
            if {[file exists ${prebuit_pl_path}/image.ub]} {
              file copy -force ${prebuit_pl_path}/image.ub ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/
            } 
            if {[file exists ${prebuit_pl_path}/bl31.elf]} {
              file copy -force ${prebuit_pl_path}/bl31.elf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/
            } 
            if {[file exists ${prebuit_pl_path}/u-boot.elf]} {
              file copy -force ${prebuit_pl_path}/u-boot.elf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot/
            } 
          }
        } else {
          file mkdir ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/boot
        }
      #--------------------
      if {[file exists ${TE::SET_PATH}/sdsoc/samples]} {
        file copy -force ${TE::SET_PATH}/sdsoc/samples ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
      } else {
          # file mkdir ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/samples
      }
      #--------------------
      if {[file exists ${TE::SET_PATH}/sdsoc/hardware]} {
        file copy -force ${TE::SET_PATH}/sdsoc/hardware ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
        if {[file exists ${TE::PREBUILT_HW_PATH}/${TE::SHORTDIR}/${TE::VPROJ_NAME}.bit]} {
          file copy -force ${TE::PREBUILT_HW_PATH}/${TE::SHORTDIR}/${TE::VPROJ_NAME}.bit ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/hardware/prebuilt/bitstream.bit
        } 
        if {[file exists ${TE::PREBUILT_HW_PATH}/${TE::SHORTDIR}/${TE::VPROJ_NAME}.hdf]} {
          file copy -force ${TE::PREBUILT_HW_PATH}/${TE::SHORTDIR}/${TE::VPROJ_NAME}.hdf ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/hardware/prebuilt/export/${TE::PR_TOPLEVELNAME}.hdf
        }
      } else {
        file mkdir ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/hardware
      }
    }
    #------------------------------------
    #--check_vivado_project: ...
    proc check_and_modify_vivado_project {check_only} {
      if {$check_only} {
        puts "---------------------"
        puts "Info:(TE) Run SDSOC check:"
        puts "  Notes:"
        puts "    -Errors: could not fixed automaticly"
        puts "    -Warnings: can be fixed automaticly or can be ignored."
        puts "  Run:"
      } else { puts "Info:(TE) Run SDSOC check (modify project):"}
      #------------------
      #check sdsoc environment :
      #
      if {!$TE::SDSOC_AVAILABLE } {
        set txt "Error:(TE) SDSOC environment not set."
        if {!$check_only} {
          return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) SDSOC environment check passed";}
      #------------------
      #check zip program :
      #
      if {![file exists $TE::ZIP_PATH]} {
        set txt "Error:(TE) SDSOC ZIP program not found ($TE::ZIP_PATH)."
        if {!$check_only} {
          return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) SDSOC ZIP program check passed";}
      #------------------
      #check pfm settings :
      #file to generate  hw.pfm
      if {![file exists ${TE::SET_PATH}/sdsoc/sdsoc_pfm.tcl]} {
        set txt "Error:(TE) Project specific TCL-File for HW_PFM-generation not found (${TE::SET_PATH}/sdsoc_pfm.tcl)."
        if {!$check_only} {
          return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) HW PFM check passed";}
      #------------------
      #check pfm settings :
      #file to generate  sw.pfm (currently is only a copy)
      if {![file exists ${TE::SET_PATH}/sdsoc/sdsoc_sw.pfm]} {
        set txt "Error:(TE) Project specific File for SW_PFM-generation not found (${TE::SET_PATH}/sdsoc_sw.pfm)."
        if {!$check_only} {
          return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) SW PFM check passed";}
      #------------------
      #check project name:
      #must be  platform_name (${TE::VPROJ_NAME})
      if {![file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.xpr]} {
        set txt "Error:(TE) Vivado project name is not SDSOC compatible, should be: ${TE::VPROJ_NAME}.xpr"
        if {!$check_only} {
          return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) Vivado project name check passed";}
      #------------------
      #check toplevel name:
      #should be  <platform_name>_wrapper
      set toplevel [get_property top  [current_fileset]]
      if {![string match *_wrapper $toplevel]} {
        set txt "Error:(TE) Top level is not SDSOC compatible, should be: *_wrapper"
        if {!$check_only} {
          return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) Top Level Name check passed";}
      # if {![string match ${TE::VPROJ_NAME}* $toplevel]} {
        # set txt "Warning:(TE) Current top level should be: ${TE::VPROJ_NAME}*"
        # if {!$check_only} {
          # # currently nothing must be done
          # # return -code error $txt
        # } else {puts "    $txt";}
      # }
      #------------------
      #check processor system:
      #must be processor system
      if {!$TE::IS_ZSYS && !$TE::IS_ZUSYS && !$TE::IS_MSYS } {
        set txt "Error:(TE) Block Design contains no processor system (Checked with TE::INIT::check_bdtyp)."
        if {!$check_only} {
          return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) Processor check passed";}
      #------------------
      #check project language:
      #must be verilog
      if {[get_property target_language [current_project]] ne "Verilog"} {
        set txt "Warning:(TE) Vivado isn't a Verilog Project."
        if {!$check_only} {
          #change language
          set_property target_language Verilog [current_project] 
          puts "Info:(TE) Target Language check passed (Project Modify:Set target Language to Verilog)"
          # return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) Target Language check passed";}
      #------------------
      #check bd files:
      #currently only one bdfile supported (TE)
      set bd_files []
      if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
        set txt "Error:(TE) No Block Design found. Should be only one!"
        if {!$check_only} {
          return -code error $txt
        } else {puts "    $txt";}
      } elseif {[llength $bd_files]>1 } {
        set txt "Error:(TE) More than one Block Design found. Should be only one!"
        if {!$check_only} {
          return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) BD-Design count check passed";}
      #------------------
      #check top level file language:
      #must be verilog 
      set bd $bd_files
      # open_bd_design $bd -quiet
      # set bd_name [get_bd_designs]
      set bd_name [open_bd_design $bd -quiet]
      if {![file exists ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/$bd_name/hdl/${bd_name}_wrapper.v]} {
        set txt "Warning:(TE) Toplevel file should be Verilog."
        if {!$check_only} {
          #remove old vhdl toplevel
          remove_files ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/$bd_name/hdl/${bd_name}_wrapper.vhd
          file delete -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/$bd_name/hdl/${bd_name}_wrapper.vhd
          #make verilog top
          make_wrapper -files [get_files $bd] -top
          add_files -norecurse ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/$bd_name/hdl/${bd_name}_wrapper.v
          update_compile_order -fileset ${TE::SOURCE_NAME}
          update_compile_order -fileset ${TE::SIM_NAME}
          puts "Info:(TE) Top Level check passed (Project Modify: Regenerate Toplevel as Verilog file)"
        # return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) Top Level check passed";}
      close_bd_design [get_bd_designs $bd]
      #------------------
      #check board part :
      #board part not allowed
      if {[get_property board_part [current_project]] ne ""} {
        set txt "Warning:(TE) Board Part usage is not allowed for SDSOC."
        if {!$check_only} {
          TE::ADV::beta_hw_remove_board_part
          puts "Info:(TE) Board Part check passed (Project Modify: Remove Board Part properties)"
          # return -code error $txt
        } else {puts "    $txt";}
      } else {puts "    Info:(TE) Board Part check passed";}
      #------------------
        puts "---------------------"
    }

    #------------------------------------
    #--export_vivado_project: ...
    proc export_vivado_sdsoc_project {} {
      puts "Info:(TE) Create SDSOC Vivado Project on: ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/vivado"
      if { [file exists ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/vivado] } {
        file delete -force ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/vivado
      }
      archive_project ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/${TE::VPROJ_NAME}.xpr.zip -temp_dir ${TE::VPROJ_PATH}/.Xil/Vivado-xxxx- -force -include_config_settings
      TE::EXT::unzip_project ${TE::VPROJ_NAME}.xpr.zip ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
      file rename -force ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/${TE::VPROJ_NAME} ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/vivado
      file delete -force ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/${TE::VPROJ_NAME}.xpr.zip
    }
    #------------------------------------
    #--create_sdsoc_pfm: ...
    proc create_sdsoc_pfm {} {
      puts "Info:(TE) Create SDSOC Vivado Project pfm: ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/"
      #open bd design
      set bd_files []
      if { [catch {set bd_files [glob -join -dir ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.srcs/${TE::SOURCE_NAME}/bd/ * *.bd]}] } {
        puts "Warning:(TE) No BD-File found."
      }
      foreach bd $bd_files {
       open_bd_design $bd
      }
      #generate hw pfm 
      puts "Info:(TE) Generate ${TE::VPROJ_NAME}_hw.pfm"
      source -notrace ${TE::SET_PATH}/sdsoc/sdsoc_pfm.tcl
      file copy -force ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}_hw.pfm ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
      #generate sw pfm (todo generate  content from existing files)
      puts "Info:(TE) Generate ${TE::VPROJ_NAME}_sw.pfm"
      file copy -force ${TE::SET_PATH}/sdsoc/sdsoc_sw.pfm ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/${TE::VPROJ_NAME}_sw.pfm
    }
  # # -------------------------------------------------------
  }
  
  puts "Info:(TE) Load SDSOC script finished"
}


