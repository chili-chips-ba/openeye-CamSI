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
# ------------------------------------------
# -- $Date:  2021/07/07  | $Author: Hartfiel, John
# -- -  moved plx from external to own tcl
# ------------------------------------------
# -- $Date:  2021/11/26  | $Author: Hartfiel, John
# -- -  remove python variables on plx_run
# -- -  add notes
# ------------------------------------------
# -- $Date:  2021/12/01  | $Author: Hartfiel, John
# -- -  add uboot.dtb for prebuilt export in plx_run
# ------------------------------------------
# -- $Date:  2021/12/02  | $Author: Hartfiel, John
# -- -   plx_run, plx_device_tree
# ------------------------------------------
# -- $Date:  2021/12/06  | $Author: Hartfiel, John
# -- -   plx_kernel, plx_uboot remove devtool option for 21.2
# ------------------------------------------
# -- $Date:  2021/12/14  | $Author: Hartfiel, John
# -- -   add msg log number
# ------------------------------------------
# -- $Date:  2021/12/17  | $Author: Hartfiel, John
# -- -   moved plx_console as terminal to external
# -- -   add try catch for extern runnings
# -- $Date:  2021/12/06  | $Author: Hartfiel, John
# -- -   plx_kernel, plx_uboot remove  clean up
# ------------------------------------------
# -- $Date:  2022/01/11  | $Author: Hartfiel, John
# -- - add modify_config
# -- - add modify_config to plx_clear
# ------------------------------------------
# -- $Date:  2022/01/20  | $Author: Hartfiel, John
# -- - remove plx_bootsrc from default ran and add options to usrcommands.tcl 
# -- - add modify_config to plx_clear, plx_run, plx_config, plx_uboot, plx_kernel,plx_rootfs, plx_app
# -- - modify modify_config with local sstate as enviroment variable
# ------------------------------------------
# -- $Date:  2022/02/02  | $Author: Hartfiel, John
# -- - plx_clear remove hs_err*log
# ------------------------------------------
# -- $Date:  2022/10/20  | $Author: Kirberg, Markus
# -- - refactored store/restore_env to be only called when under vivado
# -- - plx_run takes .xsa from prebuilt now per default 
# ------------------------------------------
# -- $Date:  2022/11/16  | $Author: Kirberg, Markus
# -- - peatlinux: copy fsbls to prebuilt
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- -   
# --------------------------------------------------------------------
# --------------------------------------------------------------------

namespace eval ::TE {
  namespace eval PLX {
  
    variable t_PYTHONHOME
    variable t_LD_LIBRARY_PATH
    variable t_PYTHONPATH
    variable t_PYTHON
    
    # Utility Functions to store and restore env which is necessary under vivado
    proc store_env {} {
      # only do this if we are within vivado, otherwise not needed
      set cmdname create_bd_cell 
      if {$cmdname in [info commands $cmdname]} {
        set TE::PLX::t_PYTHONHOME $::env(PYTHONHOME)
        set TE::PLX::t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
        set TE::PLX::t_PYTHONPATH $::env(PYTHONPATH)
        set TE::PLX::t_PYTHON $::env(PYTHON)
        unset ::env(PYTHONHOME) 
        unset ::env(LD_LIBRARY_PATH) 
        unset ::env(PYTHONPATH)
        unset ::env(PYTHON)
      }
    }
    proc restore_env {} {
       set cmdname create_bd_cell 
       if {$cmdname in [info commands $cmdname]} {
         set ::env(PYTHONHOME) $TE::PLX::t_PYTHONHOME
         set ::env(LD_LIBRARY_PATH) $TE::PLX::t_LD_LIBRARY_PATH
         set ::env(PYTHONPATH) $TE::PLX::t_PYTHONPATH
         set ::env(PYTHON) $TE::PLX::t_PYTHON
       }
    }
    
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # petalinux functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--plx_config:
    proc plx_config {{refresh false}} {
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			# create project if missing
			if {![file exists ${TE::PETALINUX_PATH}] } {
				set ospath [file normalize ${TE::PETALINUX_PATH}/..]
				file mkdir ${ospath}
				cd ${ospath}
        
        store_env
         
        if { [catch {
          set command exec
          lappend command petalinux-create 
          lappend command --type project
          lappend command --name $prjname
          if {$TE::IS_ZUSYS} {
            lappend command --template zynqMP
          } elseif {$TE::IS_ZSYS} {
            lappend command --template zynq
          } elseif {$TE::IS_MSYS} {
            lappend command --template microblaze
          } else {
            restore_env
            return -code error "unkown system"
          }
          set result [eval $command]
          TE::UTILS::te_msg TE_PLX-0 INFO "Command results from petalinux \"$command\": \n \
              $result \n \
            ------" 
        } result ]  } {
          restore_env
          cd ${cur_path}
          return -code error $result
        }
        
        restore_env
			}
			cd ${TE::PETALINUX_PATH}
      #---- change to local sstate if possible
      modify_config 0 
      #----
			set xsafile  [list]
			if { [catch {set xsafile [glob -join -dir ${TE::PETALINUX_PATH}/ *.xsa]}] || $refresh} {
				#copy xsa
				TE::UTILS::generate_workspace_petalinux 
        
        store_env 
        
        if { [catch {
          # load xsa and start config
          set command exec
          # lappend command gnome-terminal
          lappend command xterm
          lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config --get-hw-description "
          # lappend command petalinux-config
          # lappend command --get-hw-description
          set result [eval $command]
          TE::UTILS::te_msg TE_PLX-1 INFO "Command results from petalinux \"$command\": \n \
              $result \n \
            ------" 
        } result ]  } {
          restore_env
          cd ${cur_path}
          return -code error $result
        }
        restore_env
			} else {
        store_env
        if { [catch {       
          # start config
          set command exec
          # lappend command gnome-terminal
          # lappend command -- unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config
          lappend command xterm
          lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config "
          # lappend command petalinux-config
          set result [eval $command]
          TE::UTILS::te_msg TE_PLX-2 INFO "Command results from petalinux \"$command\": \n \
              $result \n \
            ------" 
        } result ]  } {
          restore_env
          cd ${cur_path}
          return -code error $result
        }
        restore_env
			}
			cd $cur_path 
		}
    #--------------------------------
    #--plx_uboot: 
    proc plx_uboot {} {
      #---- change to local sstate if possible
      modify_config 0 
      #----
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			cd ${TE::PETALINUX_PATH}
      
      store_env
      if { [catch {       
        # start uboot config
        set command exec
        lappend command xterm
        lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config -c u-boot"
        # lappend command gnome-terminal
        # lappend command -e "petalinux-config -c u-boot"
        set result [eval $command]
        TE::UTILS::te_msg TE_PLX-3 INFO "Command results from petalinux \"$command\": \n \
            $result \n \
          ------" 
      } result ]  } {
        restore_env
        cd ${cur_path}
        return -code error $result
      }
      # #export to meta-user  not longer needed with 21.2
      # set command exec
      # lappend command xterm
      # lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-devtool finish u-boot-xlnx ${TE::PETALINUX_PATH}/project-spec/meta-user/ -f"
      # # lappend command gnome-terminal
      # # lappend command -e "petalinux-devtool finish u-boot-xlnx ${TE::PETALINUX_PATH}/project-spec/meta-user/ -f"
      # set result [eval $command]
      # TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
          # $result \n \
        # ------" 				
			#clean up project
			# if { $cleanup} {
        # if { [catch {       
          # set command exec
          # lappend command xterm
          # lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-build -x mrproper -f"
          # # lappend command gnome-terminal
          # # lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-build -x mrproper -f"
          # set result [eval $command]
          # TE::UTILS::te_msg TE_PLX-4 INFO "Command results from petalinux \"$command\": \n \
              # $result \n \
            # ------" 		
        # } result ]  } {
          # set ::env(PYTHONHOME) $t_PYTHONHOME
          # set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
          # set ::env(PYTHONPATH) $t_PYTHONPATH
          # set ::env(PYTHON) $t_PYTHON
          # cd ${cur_path}
          # return -code error $result
        # }
			# }				
      restore_env
			cd $cur_path 
		}
    #--------------------------------
    #--plx_kernel: 
    proc plx_kernel {} {
      #---- change to local sstate if possible
      modify_config 0 
      #----
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			cd ${TE::PETALINUX_PATH}
      store_env
      if { [catch {       
        # start kernel config
        set command exec
        lappend command xterm
        lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config -c kernel"
        # lappend command gnome-terminal
        # lappend command -e "petalinux-config -c kernel"
        set result [eval $command]
        TE::UTILS::te_msg TE_PLX-5 INFO "Command results from petalinux \"$command\": \n \
            $result \n \
          ------" 
      } result ]  } {
        restore_env
        cd ${cur_path}
        return -code error $result
      }
			#export to meta-user not longer needed with 21.2
			# set command exec
			# lappend command xterm
			# lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-devtool finish linux-xlnx ${TE::PETALINUX_PATH}/project-spec/meta-user/ -f"
			# # lappend command gnome-terminal
      # # lappend command -e "petalinux-devtool finish linux-xlnx ${TE::PETALINUX_PATH}/project-spec/meta-user/ -f"
			# set result [eval $command]
			# TE::UTILS::te_msg TE_PLX-??? INFO "Command results from petalinux \"$command\": \n \
					# $result \n \
				# ------" 			
			#clean up project
			# if { $cleanup} {
        # if { [catch {       
          # set command exec
          # lappend command xterm
          # lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-build -x mrproper -f"
          # # lappend command gnome-terminal
          # # lappend command -e "petalinux-build -x mrproper -f"
          # set result [eval $command]
          # TE::UTILS::te_msg TE_PLX-6 INFO "Command results from petalinux \"$command\": \n \
              # $result \n \
            # ------" 		
        # } result ]  } {
          # set ::env(PYTHONHOME) $t_PYTHONHOME
          # set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
          # set ::env(PYTHONPATH) $t_PYTHONPATH
          # set ::env(PYTHON) $t_PYTHON
          # cd ${cur_path}
          # return -code error $result
        # }      
			# }		
      restore_env
			cd $cur_path 
		}
    #--------------------------------
    #--plx_rootfs: 
    proc plx_rootfs {} {
      #---- change to local sstate if possible
      modify_config 0 
      #----
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			cd ${TE::PETALINUX_PATH}
      store_env
      if { [catch {       
        # # start rootfs config 
        set command exec
        #lappend command gnome-terminal
         lappend command xterm
        lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config -c rootfs"
        # lappend command petalinux-config
        # lappend command -c rootfs
        set result [eval $command]
        TE::UTILS::te_msg TE_PLX-7 INFO "Command results from petalinux \"$command\": \n \
            $result \n \
          ------" 
      } result ]  } {
        restore_env
        cd ${cur_path}
        return -code error $result
      }
      restore_env
			cd $cur_path 
		}
    #--------------------------------
    #--plx_device_tree: 
    proc plx_device_tree { {sel "system"}} {
    #--sel "system", "u-boot", "both"
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			cd ${TE::PETALINUX_PATH}
      store_env
      if { [catch {       
        #start device tree editor
        set command exec
        lappend command xterm
        # lappend command -e "gvim ${TE::PETALINUX_PATH}/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi"
        # lappend command gnome-terminal
        if {[string match -nocase $sel "u-boot"]} {
          lappend command -e "gvim ${TE::PETALINUX_PATH}/project-spec/meta-user/recipes-bsp/uboot-device-tree/files/system-user.dtsi"
        } else {
          lappend command -e "gvim ${TE::PETALINUX_PATH}/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi"
        }
        if {[string match -nocase $TE::TE_EDITOR ""] } {
          set result [eval $command]
          TE::UTILS::te_msg TE_PLX-8 INFO "Command results from petalinux \"$command\": \n \
              $result \n \
            ------" 
        } else {
          if {[string match -nocase $sel "u-boot"]} {
            TE::EXT::editor "${TE::PETALINUX_PATH}/project-spec/meta-user/recipes-bsp/uboot-device-tree/files/system-user.dtsi"
          } else {
            TE::EXT::editor "${TE::PETALINUX_PATH}/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi"
          }
          
        }
      } result ]  } {
        restore_env
        cd ${cur_path}
        return -code error $result
      }
      if {[string match -nocase $sel "both"]} {  
        [catch {file copy -force  ${TE::PETALINUX_PATH}/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi ${TE::PETALINUX_PATH}/project-spec/meta-user/recipes-bsp/uboot-device-tree/files/system-user.dtsi}]

      }
        
      restore_env
			cd $cur_path 
		}
    #--------------------------------
    #--plx_app: 
    proc plx_app { appname } {
      
      #---- change to local sstate if possible
      modify_config 0 
      #----
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
			cd ${TE::PETALINUX_PATH}
      store_env
      if { [catch {       
        #create empty app
        set command exec
        lappend command xterm
        # lappend command gnome-terminal
        lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-create -t apps -n ${appname} --enable"
        set result [eval $command]
        TE::UTILS::te_msg TE_PLX-9 INFO "Command results from petalinux \"$command\": \n \
            $result \n \
          ------" 
      } result ]  } {
        restore_env
        cd ${cur_path}
        return -code error $result
      }
      #maybe coppy app from template svn?
      restore_env
			cd $cur_path 
		}
    #--------------------------------
    #--plx_bootsrc: 
    proc plx_bootsrc { {type def} {imageub_addr 0x10000000} {imageub_flash_addr 0x200000} {imageub_flash_size 0xD90000}} {
      puts "todo template script version testen --> parameter mit in die settings aufnehmen und parameter aus dem sw csv uebergeben und das hier bei run ausfuehren" 
			#type= default --> create files without changes
			#type= ign --> do not create bootscr files on prebuilt folder
			#type= all others --> create bootscr files with parameters

      set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
      set posfolder ${TE::PREBUILT_OS_PATH}/petalinux/${TE::DDR_SIZE}/
			file mkdir ${posfolder}
			cd ${posfolder}
      
      if {[file exists ${TE::SCRIPT_PATH}/boot.script_template] && ![string match -nocase "ign" $type]} { 
        set fp_r [open ${TE::SCRIPT_PATH}/boot.script_template "r"]
        set file_data [read $fp_r]
        close $fp_r
        
        set tmp_date "[ clock format [clock seconds] -format "%Y_%m_%d %H_%M_%S"]"
        if {[string match -nocase $type "def"] } {
          TE::UTILS::te_msg TE_PLX-10 INFO "Use default Boot Source file ( ${posfolder}/boot.script ) without modification \n \
          ------" 
        } 
        set e1str "echo \[TE_BOOT-00\] Boot Source Script File creation date:  $tmp_date;"
        set e2str "echo \[TE_BOOT-00\] Automatically generated Trenz Electronic Boot Source file with setup $type;"
        set data [split $file_data "\n"]
        set data [linsert $data[set data {}] 0 "################"]
        set data [linsert $data[set data {}] 0 "$e1str"]
        set data [linsert $data[set data {}] 0 "$e2str"]
        set data [linsert $data[set data {}] 0 "################"]
        set data [linsert $data[set data {}] 0 ""]
        set line_index -1
        set mod_count 0
        foreach line $data {
          incr line_index
          #comment lines on tcl file, modified lines are ignored
          if {[string match "imageub_addr=*" $line] && ! [string match -nocase "def" $type]} {
            set data [lreplace $data[set data {}] $line_index $line_index "imageub_addr=$imageub_addr"]
            incr mod_count
          }
          if {[string match "imageub_flash_addr=*" $line]&& ! [string match -nocase "def" $type]} {
            set data [lreplace $data[set data {}] $line_index $line_index "imageub_flash_addr=$imageub_flash_addr"]
            incr mod_count
          }
          if {[string match "imageub_flash_size=*" $line]&& ! [string match -nocase "def" $type]} {
            set data [lreplace $data[set data {}] $line_index $line_index "imageub_flash_size=$imageub_flash_size"]
            incr mod_count
          }
        }
          
        
        
        if {[file exists ${posfolder}/boot.script]} { 
          TE::UTILS::te_msg TE_PLX-11 INFO "Existing Boot script file ( ${posfolder}/boot.script ) will be overwrite with new one \n \
          ------" 
        }
        set fp_w [open ${posfolder}/boot.script "w"]
        foreach line $data {
          puts $fp_w $line
        }
        close $fp_w
        store_env
        if { [catch {       
          #start 
          set command exec
          # lappend command xterm
          # lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;mkimage -c none -A arm -T script -d boot.script boot.scr"
          # lappend command gnome-terminal
          lappend command mkimage
          lappend command -c none
          lappend command -A arm
          lappend command -T script
          lappend command -d boot.script
          lappend command boot.scr
          
          set result ""
          if { [catch {set result [eval $command]}] } {
            TE::UTILS::te_msg TE_PLX-12 {CRITICAL WARNING} "Install mkimage with: \n \
              sudo apt-get update \n \
              sudo apt install u-boot-tools \n \
            ------" 
          }
          
          TE::UTILS::te_msg TE_PLX-13 INFO "Command results from mkimage \"$command\": \n \
              $result \n \
            ------" 
        } result ]  } {
          restore_env
          cd ${cur_path}
          return -code error $result
        }
        restore_env
        # delete timestamp on script file to see if customer has reused it        
        set fp_r [open ${posfolder}/boot.script "r"]
        set file_data [read $fp_r]
        close $fp_r 
        set data [split $file_data "\n"]
        set fp_w [open ${posfolder}/boot.script "w"]
        foreach line $data {
          if {[string match "*Boot Source Script File creation date:*" $line]} {
            puts $fp_w "echo \[TE_BOOT-00\] Boot Source Script File creation date: customer template version"
          } else {
            puts $fp_w $line
          }
        }
         close $fp_w
          
      } else {
        TE::UTILS::te_msg TE_PLX-14 WARNING "Boot source file generation skipped, customer must create correct file \n \
				------" 
      }
			cd $cur_path 
		}
    #--------------------------------
    #--plx_run: 
    proc plx_run {{refresh false}} {
			set cur_path [pwd]
			set prjname [file tail ${TE::PETALINUX_PATH}]
      store_env
			# create project if missing
			if {![file exists ${TE::PETALINUX_PATH}] } {
				set ospath [file normalize ${TE::PETALINUX_PATH}/..]
				file mkdir ${ospath}
				cd ${ospath}
        if { [catch {       
          set command exec
          lappend command petalinux-create 
          lappend command --type project
          
          
          lappend command --name $prjname
          if {$TE::IS_ZUSYS} {
            lappend command --template zynqMP
          } elseif {$TE::IS_ZSYS} {
            lappend command --template zynq
          } elseif {$TE::IS_MSYS} {
            lappend command --template microblaze
          } else {
            restore_env
            return -code error "unkown system"
          }
          set result [eval $command]
          TE::UTILS::te_msg TE_PLX-28 INFO "Command results from petalinux \"$command\": \n \
              $result \n \
            ------" 
            
        } result ]  } {
          restore_env
          cd ${cur_path}
          return -code error $result
        }
			}
			cd ${TE::PETALINUX_PATH}
			
      modify_config 0  
      
			set xsafile  [list]
			if { [catch {set xsafile [glob -join -dir ${TE::PETALINUX_PATH}/ *.xsa]}] || $refresh} {
				#copy xsa
				TE::UTILS::generate_workspace_petalinux $TE::SHORTDIR 
				# load xsa
        if { [catch {       
          set command exec
          lappend command petalinux-config 
          lappend command --get-hw-description 
          lappend command --silentconfig
          set result [eval $command]
          TE::UTILS::te_msg TE_PLX-15 INFO "Command results from petalinux \"$command\": \n \
              $result \n \
            ------" 
        } result ]  } {
          restore_env
          cd ${cur_path}
          return -code error $result
        }
			} 
			# build project
      if { [catch {       
        set command exec
        lappend command petalinux-build 
        set result [eval $command]
        TE::UTILS::te_msg TE_PLX-16 INFO "Command results from petalinux \"$command\": \n \
            $result \n \
          ------" 
      } result ]  } {
        restore_env
        cd ${cur_path}
        return -code error $result
      }
        
      restore_env
      
			#todo copy files to prebuilt(todo selection)
			set posfolder ${TE::PREBUILT_OS_PATH}/petalinux/${TE::DDR_SIZE}/
			file mkdir ${posfolder}
			
			# [catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/boot.scr ${posfolder}}]
			#
      puts "todo finaly use separate function for prebuilt export"      
			catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/image.ub     ${posfolder}}
			catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/u-boot.elf   ${posfolder}}
			catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/bl31.elf     ${posfolder}}
			catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/u-boot.dtb   ${posfolder}}
			catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/system.dtb   ${posfolder}}

      #if {$TE::IS_ZSYS} {
      #  catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/zynq_fsbl.elf   ${posfolder}}
      #} elseif {$TE::IS_ZUSYS} {
      #  catch {file copy -force  ${TE::PETALINUX_PATH}/images/linux/zynqmp_fsbl.elf   ${posfolder}}
      #}
			
			cd $cur_path
      #create Trenz boot.src file:
     
      # TE::PLX::plx_bootsrc
    }  
    #--------------------------------
    #--plx_clear: 
    proc plx_clear {} {
			set cur_path [pwd]
			cd ${TE::PETALINUX_PATH}
      if { [catch {       
        set command exec
        lappend command petalinux-build 
        lappend command -x mrproper
        lappend command -f
        set result [eval $command]
        TE::UTILS::te_msg TE_PLX-17 INFO "Command results from petalinux \"$command\": \n \
            $result \n \
          ------" 
      } result ]  } {
        restore_env
        cd ${cur_path}
        return -code error $result
      }
				
			# -----
			set delfiles  ${TE::PETALINUX_PATH}/components/yocto/
			if {[file exists $delfiles]} {
				puts "Delete: $delfiles"
				file delete -force -- $delfiles
			}				
			# -----
			set delfiles  ${TE::PETALINUX_PATH}/.xil/
      #todo hidden files will be not detect on linux  os
			if {[file exists $delfiles]} {
				puts "Delete: $delfiles"
				file delete -force -- $delfiles
			}
			# -----
			set delfiles  [list]
			catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/.petalinux/ *]}
			set idx [lsearch $delfiles "*metadata"]
			set delfiles [lreplace $delfiles $idx $idx]
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
			# -----
			set delfiles  [list]
			catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/project-spec/hw-description/ *]}
			set idx [lsearch $delfiles "*metadata"]
			set delfiles [lreplace $delfiles $idx $idx]
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
			# -----
			set delfiles  [list]
			catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/ *.xsa]}
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
			# -----
			set delfiles  [list]
			catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/ *.bit]}
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
			# -----
			set delfiles  [list]
			catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/ *.mmi]}
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
			# ----- (error from vivado under wsl which can be ignored at the moment)
			set delfiles  [list]
			catch {set delfiles [glob -join -dir ${TE::PETALINUX_PATH}/ hs_err*.log]}
			foreach df $delfiles {
				puts "Delete: $df"
				file delete $df
			}
      
      # ----
      #modify config back to default network sstate
      modify_config 1
      
			cd $cur_path 
    }  
    #--------------------------------
    #--modify_config:
    proc modify_config {{stage 1}} {
      #todo pfade als umgebungsvariablen als alternative
      set vivado_version  ${::env(VIVADO_VERSION)}
      set sstate_url $TE::PLX_SSTATE_CACHE_AARCH64
      set download_url $TE::PLX_SSTATE_CACHE_DOWNLOAD
      set system "aarch64"
      if {$TE::IS_ZUSYS} {
        set system "aarch64"
        set sstate_url $TE::PLX_SSTATE_CACHE_AARCH64
      } elseif {$TE::IS_ZSYS} {
        set system "arm"
        set sstate_url $TE::PLX_SSTATE_CACHE_ARM
      } elseif {$TE::IS_MSYS} {
        set system "mb-full"
        set sstate_url $TE::PLX_SSTATE_CACHE_MB_FULL
      }
      
      set file_name "${TE::PETALINUX_PATH}/project-spec/configs/config"
      if {[file exists ${file_name}]} {
        set fp_r [open ${file_name} "r"]
        set file_data [read $fp_r]
        close $fp_r
        set data [split $file_data "\n"]
        # modify
        set line_index -1
        set mod_count 0
        set temodifications [list]
        set date "[ clock format [clock seconds] -format "%Y_%m_%d %H_%M_%S"]"
        lappend  temodifications "# List of TE script modifications from $date:"
        
        if {$stage == 0 } {
          set data_new [list]
          #modification before building
          #delete old modification list
          
          set start_remove 0
          set line_check_startremove "# List of TE script modifications*"
          set line_check_endremove "# End of modifcation List*"
          foreach line $data {
            if {[string match $line_check_startremove $line]} {
               set start_remove 1
              TE::UTILS::te_msg TE_PLX-23 INFO "Start cleaning config"
            }
            if {$start_remove == 0} {
              lappend data_new $line
            }
            if {[string match $line_check_endremove $line]} {
               set start_remove 0
              TE::UTILS::te_msg TE_PLX-24 INFO "Finish cleaning config"
            }
          }
          #replace reduced list
          set data $data_new
          #add sstate and download if folder exists
          #remove local sstate in case its set
          set line_check_SSTATE_LOCAL "CONFIG_YOCTO_LOCAL_SSTATE_FEEDS_URL=*"
          #remove local downloads in case its set
          set line_check_downloads "CONFIG_PRE_MIRROR_URL=*"
          foreach line $data {
            incr line_index
            if {[string match $line_check_SSTATE_LOCAL $line]} {
              if {[file exists $sstate_url]} {
                set line_check_SSTATE_LOCAL "CONFIG_YOCTO_LOCAL_SSTATE_FEEDS_URL=\"${sstate_url}\"" 
                if {![string match $line_check_SSTATE_LOCAL $line]} {
                  set data [lreplace $data[set data {}] $line_index $line_index "CONFIG_YOCTO_LOCAL_SSTATE_FEEDS_URL=\"${sstate_url}\""]
                  incr mod_count
                  lappend  temodifications "#    Replace default sstate Mirror URL $line with $sstate_url"
                  TE::UTILS::te_msg TE_PLX-25 INFO "Replace default sstate Mirror URL $line with $sstate_url "
                }
              }
            }
            if {[string match $line_check_downloads $line]} { 
              if {[file exists $download_url]} {
                set line_check_downloads "CONFIG_PRE_MIRROR_URL=\"file://${download_url}\"" 
                if {![string match $line_check_downloads $line]} {
                  set data [lreplace $data[set data {}] $line_index $line_index "CONFIG_PRE_MIRROR_URL=\"file://${download_url}\""]
                  incr mod_count
                  lappend  temodifications "#    Replace default download mirror path $line with $download_url"
                  TE::UTILS::te_msg TE_PLX-26 INFO "Replace default download mirror path $line with $download_url"
                }
              }
            }
          }
          
        } else {
          #modification after building
          # remove memory setting to reload memory with xsa import
          # bugfix for petalinux to reload memory. todo check from time to time if it's still needed
          set line_check_ddrmod "CONFIG_SUBSYSTEM_MEMORY_*"
          #remove local sstate in case its set
          set line_check_SSTATE_LOCAL "CONFIG_YOCTO_LOCAL_SSTATE_FEEDS_URL=*"
          #remove local downloads in case its set
          set line_check_downloads "CONFIG_PRE_MIRROR_URL=*"
          foreach line $data {
            incr line_index
            if {[string match $line_check_ddrmod $line]} {
              set data [lreplace $data[set data {}] $line_index $line_index "# $line"]
              incr mod_count
              lappend  temodifications "#    Removed line $line"
            }
            if {[string match $line_check_SSTATE_LOCAL $line]} {
              set line_check_SSTATE_LOCAL "CONFIG_YOCTO_LOCAL_SSTATE_FEEDS_URL=\"\"*"
              if {![string match $line_check_SSTATE_LOCAL $line]} {
                set data [lreplace $data[set data {}] $line_index $line_index "CONFIG_YOCTO_LOCAL_SSTATE_FEEDS_URL=\"\""]
                incr mod_count
                lappend  temodifications "#    Replace local sstate Mirror URL $line with default"
                TE::UTILS::te_msg TE_PLX-26 INFO "Replace local sstate Mirror URL $download_url with default"
              }
            }
            if {[string match $line_check_downloads $line]} {
              set line_check_downloads "CONFIG_PRE_MIRROR_URL=*file*" 
              if {[string match $line_check_downloads $line]} {
                set data [lreplace $data[set data {}] $line_index $line_index "CONFIG_PRE_MIRROR_URL=\"http://petalinux.xilinx.com/sswreleases/rel-v\$\{PETALINUX_MAJOR_VER\}/downloads\""]
                incr mod_count
                lappend  temodifications "#    Replace local download mirror path $line with default"
                TE::UTILS::te_msg TE_PLX-27 INFO "Replace local download mirror path $download_url with default"
              }
            }
          }
        }
        
        TE::UTILS::te_msg TE_PLX-18 INFO "$mod_count lines was modified in \"$file_name\": \n \
        ------" 
        lappend  temodifications "# End of modifcation List from $date with $mod_count modified lines."
        set fp_w [open ${file_name} "w"]
        #save modifications list
        foreach line $temodifications {
          puts $fp_w $line
        }
        #save config
        foreach line $data {
          puts $fp_w $line
        }
        close $fp_w
      } else {
        TE::UTILS::te_msg TE_PLX-19 WARNING "File  is missing: \"$file_name\": \n \
          ------" 
      }
        

    
    }
    
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished plx functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # git patch functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--git_patch:
    proc git_patch {} {
      set cur_path [pwd]
      if {[file exists ${TE::TMP_PATH}] } {
        puts "Delete:  ${TE::TMP_PATH}"
        file delete -force --  ${TE::TMP_PATH}
      } 
      if {[catch {set ::TE::PLX::GPATH  ${::env(TE_GITCONFIG_PATH)}}]} {
        set ::TE::PLX::GPATH "../../../../../xilinx/XilinxGitPatch"
      }
      if {[file exists ${::TE::PLX::GPATH}/git_cfg.tcl]} {
        TE::UTILS::te_msg TE_PLX-20 INFO "Use GIT config from ${::TE::PLX::GPATH}/git_cfg.tcl"
        source ${::TE::PLX::GPATH}/git_cfg.tcl
        
        puts "Test TE_GIT_PATH_XILINX_EMBEDDED_ORIGIN: $::env(TE_GIT_PATH_XILINX_EMBEDDED_ORIGIN)"
        puts "Test TE_GIT_PATH_XILINX_LINUX_ORIGIN: $::env(TE_GIT_PATH_XILINX_LINUX_ORIGIN)"
        puts "Test TE_GIT_PATH_XILINX_UBOOT_ORIGIN: $::env(TE_GIT_PATH_XILINX_UBOOT_ORIGIN)"
      } else {
        TE::UTILS::te_msg TE_PLX-21 ERROR " GIT config is missing ${::TE::PLX::GPATH}/git_cfg.tcl"
      }
      file mkdir ${TE::TMP_PATH}
      cd ${TE::TMP_PATH}
      
      store_env
      
      if { [catch {       
        set command exec
        # lappend command xterm
        # lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;sudo git clone ${::TE::PLX::PATH_ORIGIN}"
        lappend command gnome-terminal
        lappend command -- "${::TE::SCRIPT_PATH}/run_XilinxGit.sh"
        lappend command &
        #gnome-terminal will not wait, so use pid for waiting
        set result [eval $command]
        set cnt 0
        while {[file exists /proc/$result]} {
          set running [file exists /proc/$result]
          if {[expr $cnt % 1000000] == 0} {
            puts "waiting for closing GUI with PID $running"
          }
           set cnt [expr $cnt + 1]
        }
        
        TE::UTILS::te_msg TE_PLX-22 INFO "Command results from petalinux \"$command\":($running) \n \
            $result \n \
          ------" 
      } result ]  } {
        restore_env
        cd ${cur_path}
        return -code error $result
      }
      restore_env
      cd $cur_path 

      # cd ${::TE::PLX::PATH_LOCAL}
      puts "Test TE_GIT_PARAMETER: $::env(TE_GIT_PARAMETER)"
      puts "Test TE_GIT_PATCH: $::env(TE_GIT_PATCH)"
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished git patch  functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  }
  puts "INFO:(TE) Load Vivado script finished"
}
