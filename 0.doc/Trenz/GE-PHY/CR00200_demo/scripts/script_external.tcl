# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Holzweg 19A             *
# --   *   32257 Bünde             *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# -- $Author: Hartfiel, John $
# -- $Email: j.hartfiel@trenz-electronic.de $
# --------------------------------------------------------------------
# -- Change History:
# ------------------------------------------
# -- $Date: 2016/02/1 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2017/05/12  | $Author: Hartfiel, John
# -- - bugfix missing bracket
# ------------------------------------------
# -- $Date: 2017/05/18  | $Author: Hartfiel, John
# -- - add pmuf to zynqmp bif
# ------------------------------------------
# -- $Date: 2017/06/13  | $Author: Hartfiel, John
# -- - add pmuf hsi/sdk support
# ------------------------------------------
# -- $Date:  2017/09/04  | $Author: Hartfiel, John
# -- - add new document history style
# ------------------------------------------
# -- $Date:  2017/09/21  | $Author: Hartfiel, John
# -- - add TE::UTILS::create_prebuilt_report
# ------------------------------------------
# -- $Date:  2018/01/05  | $Author: Hartfiel, John
# -- - add TE::UTILS::excecute_zynq_flash_programming add fsbl
# -- - update messages
# ------------------------------------------
# -- $Date:  2018/05/08  | $Author: Hartfiel, John
# -- - bugfix check csv for apps: generate_app_bit_mcs
# -- - add short variable short dir to mcs content: generate_app_bit_mcs
# -- - add add generate srec from elf: generate_app_bit_mcs
# -- - update messages
# ------------------------------------------
# -- $Date:  2018/05/16  | $Author: Hartfiel, John
# -- - add zip_general
# ------------------------------------------
# -- $Date:  2018/05/22  | $Author: Hartfiel, John
# -- - optional short variable  also check default: generate_app_bit_mcs
# ------------------------------------------
# -- $Date:  2018/06/19  | $Author: Hartfiel, John
# -- - bugfix : generate_app_bit_mcs
# ------------------------------------------
# -- $Date:  2018/06/20  | $Author: Kohout, Lukas
# -- - add linux host support into zip_general
# ------------------------------------------
# -- $Date:  2018/07/02  | $Author: Hartfiel, John
# -- - change ZynqMP BIF
# ------------------------------------------
# -- $Date:  2018/07/05  | $Author: Hartfiel, John
# -- - index update for new applist csv 2.1
# ------------------------------------------
# -- $Date:  2019/02/04  | $Author: Hartfiel, John
# -- - rework generate_bif_files, write_zusys_bif
# ------------------------------------------
# -- $Date:  2019/02/14  | $Author: Hartfiel, John
# -- - rework generate_app_bit_mcs
# ------------------------------------------
# -- $Date:  2019/04/08  | $Author: Hartfiel, John
# -- - add run_putty
# ------------------------------------------
# -- $Date:  2019/05/22  | $Author: Hartfiel, John
# -- - changed option to generate FSBL app
# ------------------------------------------
# -- $Date:  2019/10/??  | $Author: Hartfiel, John
# -- - add autolog to run_putty
# ------------------------------------------
# -- $Date:  2019/11/11  | $Author: Hartfiel, John
# -- - bugfix on generate_app_bit_mcs
# ------------------------------------------
# -- $Date:  2019/11/12  | $Author: Hartfiel, John
# -- - merge files change run_putty and zip_project
# ------------------------------------------
# -- $Date:  2019/11/28  | $Author: Hartfiel, John
# -- - add run_vitis_gui run_xsct
# -- - obsolete run_sdk run_hsi
# ------------------------------------------
# -- $Date:  2019/12/18  | $Author: Hartfiel, John
# -- -  replace filename variable  VPROJ_NAME with PB_FILENAME
# ------------------------------------------
# -- $Date:  2020/01/21  | $Author: Hartfiel, John
# -- -  run_vitis_gui add parameter to start vitis on linux without blocking vivado
# ------------------------------------------
# -- $Date:  2020/04/06  | $Author: Hartfiel, John
# -- -  add run_serial
# ------------------------------------------
# -- $Date:  2020/05/05  | $Author: Hartfiel, John
# -- -  modify run_putty
# ------------------------------------------
# -- $Date:  2020/12/02  | $Author: Hartfiel, John
# -- -  modify run_xsct
# ------------------------------------------
# -- $Date:  2020/11/12  | $Author: Hartfiel, John
# -- -  modify zip_project
# ------------------------------------------
# -- $Date:  2021/01/08  | $Author: Hartfiel, John
# -- -  modify run_xsct
# ------------------------------------------
# -- $Date:  2021/02/04  | $Author: Hartfiel, John
# -- -  modify zip_project 
# ------------------------------------------
# -- $Date:  2021/02/13  | $Author: Hartfiel, John
# -- -  add plx_run and plx_clear
# ------------------------------------------
# -- $Date:  2021/02/17  | $Author: Hartfiel, John
# -- -  modify generate_bif_files, write_bif and write_zusys_bif replace with script_te_utils.tcl vitis_z_bif vitis_zmp_bif
# ------------------------------------------
# -- $Date:  2021/02/18  | $Author: Hartfiel, John
# -- -  add new plx functions
# ------------------------------------------
# -- $Date:  2021/04/28  | $Author: Hartfiel, John
# -- -  plx_clear add microblaze files
# ------------------------------------------
# -- $Date:  2021/05/28  | $Author: Hartfiel, John
# -- -  plx_device_tree , use gvim instead of vim
# ------------------------------------------
# -- $Date:  2021/05/28  | $Author: Hartfiel, John
# -- -  plx_device_tree , use gvim instead of vim
# ------------------------------------------
# -- $Date:  2021/07/02  | $Author: Hartfiel, John
# -- -  plx_clear , use modify config file
# ------------------------------------------
# -- $Date:  2021/07/07  | $Author: Hartfiel, John
# -- -  add plx_app and plx_bootsrc
# ------------------------------------------
# -- $Date:  2021/07/26  | $Author: Hartfiel, John
# -- -  move plx function to script_petalinux.tcl
# ------------------------------------------
# -- $Date:  2021/11/1  | $Author: Hartfiel, John
# -- -  run_putty bugfix after  windows update
# ------------------------------------------
# -- $Date:  2021/11/1  | $Author: Hartfiel, John
# -- -  generate_bif_files add boot.scr and u-boot.dtb usage
# ------------------------------------------
# -- $Date:  2021/12/12  | $Author: Hartfiel, John
# -- -  generate_app_bit_mcs add boot.scr and u-boot.dtb usage
# ------------------------------------------
# -- $Date:  2021/12/12  | $Author: Hartfiel, John
# -- -  rework zip_project
# ------------------------------------------
# -- $Date:  2021/12/15  | $Author: Hartfiel, John
# -- - add svn_status svn_update svn_add svn_commit
# ------------------------------------------
# -- $Date:  2021/12/16  | $Author: Hartfiel, John
# -- - modify run_serial and run_putty for wsl
# ------------------------------------------
# -- $Date:  2022/01/04  | $Author: Hartfiel, John
# -- - modify svn_commit, svn_add
# -- - add svn_remove
# ------------------------------------------
# -- $Date:  2022/01/18  | $Author: Hartfiel, John
# -- - bugfix svn_remove, svn remove
# ------------------------------------------
# -- $Date:  2022/02/02  | $Author: Hartfiel, John
# -- - bugfix zip_general  to add empty folder
# ------------------------------------------
# -- $Date:  2022/02/13  | $Author: Hartfiel, John
# -- - extend run_serial
# ------------------------------------------
# -- $Date:  2022/05/04  | $Author: Hartfiel, John
# -- - zip_project add rev and remove .svn from prod extention
# ------------------------------------------
# -- $Date:  2022/09/17  | $Author: Hartfiel, John
# -- - generate_bif_files add offset to bootscr and uboot_dtb
# -- - bugfix data load and offset was mixed
# ------------------------------------------
# -- $Date:  2022/09/20  | $Author: Hartfiel, John
# -- - prepared to remove bootscr and uboot_dtb on next updates...(infos must be add to data)
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# --------------------------------------------------------------------

namespace eval ::TE {
  namespace eval EXT {
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # *elf generation functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--run_sdk:  
    proc run_sdk {} {
        # set cur_path [pwd]
        # cd $TE::WORKSPACE_SDK_PATH
        # set tmplist [list]
        # if {[file exists ${TE::XILINXGIT_DEVICETREE}]} {
          # TE::UTILS::te_msg TE_SW-0 STATUS "Include Xilinx Device Tree git clone."
          # lappend tmplist "-lp" $TE::LIB_PATH
          # lappend tmplist "-lp" ${TE::XILINXGIT_DEVICETREE}
        # } else {
          # TE::UTILS::te_msg TE_SW-1 INFO "Xilinx Device Tree git clone path (${TE::XILINXGIT_DEVICETREE}) doesn't exist."
          # lappend tmplist "-lp" $TE::LIB_PATH
        # }
        # set command exec
        # lappend command vitis
        # lappend command -workspace ${TE::WORKSPACE_SDK_PATH}
        # #set hdffilename ""
        # #[catch {set hdffilename [glob -join -dir ${TE::WORKSPACE_SDK_PATH}/ *.xsa]}]
        # #todo vitis has TCL like vivado --> create Vitis tcl initilaisation
        # # if {[file exists ${TE::WORKSPACE_SDK_PATH}/${TE::PR_TOPLEVELNAME}.hdf]} {
          # # lappend command -hwspec ${TE::WORKSPACE_SDK_PATH}/${TE::PR_TOPLEVELNAME}.hdf
        # # } elseif {[file exists ${TE::WORKSPACE_SDK_PATH}/${TE::PB_FILENAME}.hdf]} {
          # # lappend command -hwspec ${TE::WORKSPACE_SDK_PATH}/${TE::PB_FILENAME}.hdf
        # # } else {
          # # lappend command -hwspec ${hdffilename}
        # # }
         # # lappend command -hwspec ${hdffilename}
        # # lappend command -hwspec ${TE::WORKSPACE_SDK_PATH}/${TE::PB_FILENAME}.hdf
        # # lappend command -bit ${TE::WORKSPACE_SDK_PATH}/${TE::PB_FILENAME}.bit
        # lappend command {*}$tmplist
        # # lappend command -source  ${TE::SCRIPT_PATH}/script_vitis.tcl
        # # lappend command -tclargs
        # # lappend command "--vivrun"
        
        
        # # lappend command --vivrun 
        # TE::UTILS::te_msg TE_SW-2 INFO "Start SKD: \n \
          # Run \"$command\" in $TE::WORKSPACE_SDK_PATH \n \
          # Please Wait.. \n \
        # ------"

        # #note todo check. error is not detected if return text(result) is set
        # if { [catch {eval $command} result ]  } {
          # TE::UTILS::te_msg TE_EXT-15 ERROR "Command results from SDK \"$command\": \n \
            # $result \n \
          # ------"
        # } else {
          # TE::UTILS::te_msg TE_EXT-9 INFO "Command results from SDK \"$command\": \n \
            # $result \n \
          # ------"
        # }

        # cd $cur_path
    }
        #--------------------------------
    #--run_vitis_gui:  
    proc run_vitis_gui {} {        #--------------------------------
      #--> open empty workspace --> need run_xsct before.
      set cur_path [pwd]
      cd $TE::WORKSPACE_SDK_PATH
      set tmplist [list]
      if {[file exists ${TE::XILINXGIT_DEVICETREE}]} {
        TE::UTILS::te_msg TE_SW-79 STATUS "Include Xilinx Device Tree git clone."
        lappend tmplist "-lp" $TE::LIB_PATH
        lappend tmplist "-lp" ${TE::XILINXGIT_DEVICETREE}
      } else {
        TE::UTILS::te_msg TE_SW-80 INFO "Xilinx Device Tree git clone path (${TE::XILINXGIT_DEVICETREE}) doesn't exist."
        lappend tmplist "-lp" $TE::LIB_PATH
      }
      
      set command exec
      lappend command vitis
      lappend command -workspace ${TE::WORKSPACE_SDK_PATH}
      lappend command {*}$tmplist
      switch [TE::UTILS::get_host_os] {
        "windows" {

        }
        "unix" {
          lappend command "&"

        }
      }
      # lappend command --vivrun 
      TE::UTILS::te_msg TE_SW-78 INFO "Start VITIS: \n \
        Run \"$command\" in $TE::WORKSPACE_SDK_PATH \n \
        Please Wait..and close Welcome tab when Vitis is opened \n \
      ------"

      if { [catch {eval $command} result ]  } {
        TE::UTILS::te_msg TE_EXT-17 ERROR "Command results from VITIS \"$command\": \n \
          $result \n \
        ------\n \
          Close Welcome tab in Vitis to see the project \n \
        ------"
      } else {
        TE::UTILS::te_msg TE_EXT-18 INFO "Command results from VITIS \"$command\": \n \
          $result \n \
        ------\n \
          Close Welcome tab in Vitis to see the project \n \
        ------"
      }
      
      cd $cur_path
      
    }
    #--run_xsct:  
    proc run_xsct {{worspace_only false} {platform_only false}} {
        set cur_path [pwd]
        if {! [file exists ${TE::WORKSPACE_SDK_PATH}] } {
          file mkdir ${TE::WORKSPACE_SDK_PATH}/
        }
        cd $TE::WORKSPACE_SDK_PATH

        
        set config "--vivrun*--id*$TE::ID"
        
        if {$worspace_only} {
          set config "${config}*--worspace_only"
        }
        
        if {$platform_only} {
          set config "${config}*--platform_only"
        }
        
        set command exec
        lappend command xsct
        lappend command  ${TE::SCRIPT_PATH}/script_vitis.tcl

        lappend command $config
        # lappend command "--vivrun*--id*$TE::ID"

        TE::UTILS::te_msg TE_SW-2 INFO "Create workspace and compile app: \n \
          Run \"$command\" in $TE::WORKSPACE_SDK_PATH \n \
          Please Wait...this may take some minutes...Please Wait... \n \
        ------"

        #note todo fsbl generation creates error first time bit it generates all files --try catch will be ignored in xsct todo find out why
        if { [catch {eval $command} result ]  } {
          # puts "TE_TEST_A"
          # TE::UTILS::te_msg TE_EXT-15 {CRITICAL WARNING} "Command results from SDK \"$command\": \n \
            # $result \n \
          # ------"
        } else {
          # puts "TE_TEST_B"
          # TE::UTILS::te_msg TE_EXT-9 INFO "Command results from SDK \"$command\": \n \
            # $result \n \
          # ------"
        }

        # workaround currently always error return
        #set copy of all TE prints to the end of the return value
        set log_split [split  $result "\n"]
        # puts "TE_TEST [llength $log_split]"
        set te_log " ------  \n "
        set te_log " TE XSCT LOG only:  \n"
        foreach element $log_split {
          if {[string match "*(TE)*" $element]} {
            # puts "TE_TEST A $element"
            set te_log "$te_log \n $element"
          } else {
             # puts "TE_TEST B $element"
          }
        }
         
        
        if {[string match *TE_MESSAGE_PASSED* $result] == 1} {
          TE::UTILS::te_msg TE_EXT-18 INFO "Command results from VITIS \"$command\": \n \
            $result \n \
          ------  \n \
           $te_log \n \
          ------"
        } else {
          TE::UTILS::te_msg TE_EXT-17 {CRITICAL WARNING} "Command results from VITIS \"$command\": \n \
            $result \n \
          ------  \n \
           $te_log \n \
          ------"
        }


        cd $cur_path
    }
    #--------------------------------
    #--run_hsi:  
    proc run_hsi {} {
      # # --> check xsct
      # # list 0 for table header
      # if { [llength $TE::SDEF::SW_APPLIST] > 1} {
        # set cur_path [pwd]
        # cd $TE::WORKSPACE_HSI_PATH
        # set tmp_libpath [list]
        # lappend tmp_libpath $TE::LIB_PATH 
        # if {[file exists ${TE::XILINXGIT_DEVICETREE}]} {
          # TE::UTILS::te_msg TE_SW-3 STATUS "Include Xilinx Device Tree git clone."
          # lappend tmp_libpath ${TE::XILINXGIT_DEVICETREE}
        # } else {
          # TE::UTILS::te_msg TE_SW-4 INFO "Xilinx Device Tree git clone path (${TE::XILINXGIT_DEVICETREE}) doesn't exist."
        # }
        # set tmp_sw_liblist [list]
        # lappend tmp_sw_liblist $tmp_libpath
        # set tmp_sw_applist [list]
        # lappend tmp_sw_applist $TE::SDEF::SW_APPLIST
        # #
        # set command exec
        # lappend command hsi
        # lappend command -source  ${TE::SCRIPT_PATH}/script_hsi.tcl
        # lappend command -tclargs
        # lappend command "--sw_list ${tmp_sw_applist} --lib $tmp_sw_liblist --vivrun"
        # # lappend command --vivrun 
        # TE::UTILS::te_msg TE_SW-5 INFO "Start HSI: \n \
          # Run \"$command\" in $TE::WORKSPACE_HSI_PATH \n \
          # Please Wait.. \n \
        # ------"
        # #set result ""
        # #note todo check. error is not detected if return text(result) is set
        # if { [catch {eval $command} result ]  } {
          # TE::UTILS::te_msg TE_EXT-14 ERROR "Command results from HSI \"$command\": \n \
            # $result \n \
          # ------"
        # } else {
          # TE::UTILS::te_msg TE_EXT-1 INFO "Command results from HSI \"$command\": \n \
            # $result \n \
          # ------"
        # }
        
        # cd $cur_path
        # TE::UTILS::copy_sw_files
      # }
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished *elf generation
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # *bit/*mcs generation functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--generate_app_bit_mcs:  
    proc generate_app_bit_mcs {{fname ""}} {
      #microblaze
      set int_shortdir ${TE::SHORTDIR}
      if {$fname ne ""} {
        set int_shortdir "[TE::BDEF::find_shortdir $fname]"
      }
      #run only if *.mmi exists     
      set checkfile [TE::UTILS::prebuilt_file_location false ${TE::PB_FILENAME} .mmi NA NA NA false]
      if {! [string match "NA" $checkfile] } { 
        # read processor from mmi
        set fp [open "${checkfile}" r]
        set file_data [read $fp]
        close $fp
        set tmp [split $file_data "\n"]
        foreach t $tmp {
          if {[string match *InstPath=* $t] } {
            set splittstring [split $t "="]
            set next false
            set hitval "NA"
            foreach part $splittstring {
              if {$next} {
                set hitval $part
                break
              }
              if {[string match *InstPath* $part] } {
                set next true
              }
            }
            set hitval [string map {">" ""} $hitval]
            set hitval [string map {"\"" ""} $hitval]
            if { $hitval eq "NA"} {
              TE::UTILS::te_msg TE_SW-6 ERROR "Processor doesn't exist in ${checkfile}."
              return -code error "Processor doesn't exist in ${checkfile}.";
            }
          }
        }
        #---------------
        set os_selected "NA"
        set bi_folder_abs "NA"
        set mmi_abs "NA"
        set elf_abs "NA"
        set bit_abs "NA"
        set temp_rel "NA"
        set curr_dir [pwd]
        foreach sw_applist_line ${TE::SDEF::SW_APPLIST} {
          set os_selected [lindex $sw_applist_line ${TE::SDEF::OSNAME}]
          #generate modified mcs or bit only if app_list.csv->steps=0(generate all), add file to mcs use "FIRM"
          set app_name [lindex $sw_applist_line ${TE::SDEF::APPNAME}]
          if {[lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "0"} {
            #read app name
            #delete old one
            set checkfile [TE::UTILS::prebuilt_file_location false ${app_name} .mcs NA ${app_name} NA false]
            if {[file exists $checkfile]} {
              set bi_folder_abs [TE::UTILS::prebuilt_file_location false ${app_name} .mcs NA ${app_name} NA true]                                                                                                   
              set test_path [TE::UTILS::regex_map $checkfile ".mcs" ".bit" ]
              if {[file exists $test_path]} {
                TE::UTILS::te_msg TE_SW-136 INFO "Delete  $checkfile"
                file delete -force ${test_path}
              }
            } else {
              #make folder if not exists
              set bi_folder_abs ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name} 
              file mkdir $bi_folder_abs        
            }

            #
            set mmi_abs [TE::UTILS::prebuilt_file_location false ${TE::PB_FILENAME} .mmi NA NA NA false]
            set elf_abs [TE::UTILS::prebuilt_file_location false ${app_name} .elf NA NA NA false]
            set bit_abs [TE::UTILS::prebuilt_file_location false ${TE::PB_FILENAME} .bit NA NA NA false]
            
            
            TE::UTILS::te_msg TE_SW-7 STATUS "Generate ${app_name}.bit with app: ${app_name}."
            set command exec
            lappend command updatemem
            lappend command -force
            lappend command -meminfo ${mmi_abs}
            lappend command -data ${elf_abs}
            lappend command -bit ${bit_abs}
            lappend command -proc $hitval
            lappend command -out ${bi_folder_abs}/${app_name}.bit
            TE::UTILS::te_msg TE_SW-8 INFO "Start Update Memory: \n \
              Run \"$command\" in ${bi_folder_abs} \n \
              Please Wait.. \n \
            ------"
            set result [eval $command]
            TE::UTILS::te_msg TE_EXT-2 INFO "Command results from Update Memory \"$command\": \n \
              $result \n \
            ------"     
          }
          #write mcs
          if {[lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "0" || [lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "FIRM"} {
           if {$TE::CFGMEM_MEMSIZE_MB ne "NA"} {
              #todo generate relativ path from absolute paths
              # set rel_bitfile  "../prebuilt/hardware"
              # set rel_bitfile2 "../prebuilt/boot_images"
              # set rel_data_file ".."
              #make folder if not exists
              set checkfile [TE::UTILS::prebuilt_file_location false ${app_name} .mcs NA ${app_name} NA true]
              if {[file exists $checkfile]} {
                set bi_folder_abs [TE::UTILS::prebuilt_file_location false ${app_name} .mcs NA ${app_name} NA true]
                set checkfile [TE::UTILS::prebuilt_file_location false ${app_name} .mcs NA ${app_name} NA false]
                if {[file exists $checkfile]} {
                  TE::UTILS::te_msg TE_SW-135 INFO "Delete  $checkfile"
                  file delete -force ${checkfile}
                }
              } else {
                #make folder if not exists
                set bi_folder_abs ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name} 
                file mkdir ${bi_folder_abs}        
              }

              #
              TE::UTILS::te_msg TE_SW-8 STATUS "Generate ${app_name}.mcs with app: ${app_name}."
              #set bitfile to mcs load
              if {[lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "FIRM"} {
              set temp_rel [TE::UTILS::prebuilt_file_location true ${TE::PB_FILENAME} .bit NA NA ${curr_dir} false]
              set load_data "up 0x0 ${temp_rel} "
              } else {
                set temp_rel  "NA"
                set load_data "up 0x0  ${bi_folder_abs}/${app_name}.bit "
              }
              #dtb
              if {[lindex $sw_applist_line ${TE::SDEF::UBOOT_DTB_LOAD}] ne "NA"} {
                set checkfile [TE::UTILS::prebuilt_file_location true "u-boot" .dtb $os_selected NA ${curr_dir} false]
                if {[string match "NA" $checkfile]} { 
                  TE::UTILS::te_msg TE_SW-96 WARNING "u-boot.dtb  doesn't exist in the prebuilt folders."
                } else {
                  set load_data "$load_data up [lindex $sw_applist_line ${TE::SDEF::UBOOT_DTB_LOAD}] $checkfile"
                }
              }
              #bootscr
              if {[lindex $sw_applist_line ${TE::SDEF::BOOTSCR_LOAD}] ne "NA"} {

                set checkfile [TE::UTILS::prebuilt_file_location true "boot" .scr $os_selected NA ${curr_dir} false]
                if {[string match "NA" $checkfile]} { 
                  TE::UTILS::te_msg TE_SW-97 WARNING "boot.scr  doesn't exist in the prebuilt folders."
                } else {
                  set load_data "$load_data up [lindex $sw_applist_line ${TE::SDEF::BOOTSCR_LOAD}] $checkfile"
                }
              }
              #get upload data 01:
              set data_index ${TE::SDEF::MB_DATA01_FILE}
              while {$data_index < [llength $sw_applist_line] } {
                #read list
                if {[lindex $sw_applist_line $data_index] ne "NA"} {
                  set temp_path "[lindex $sw_applist_line $data_index]"
                  #!!!todo file search rework like on Zynq/ZynqMP
                  #change "<short_dir>" folder to correct short dir of the device
                  set temp_path [TE::UTILS::regex_map $temp_path "<short_dir>" ${int_shortdir} ]
                  if {[string match *.srec* $temp_path]} {
                    set test_path [TE::UTILS::regex_map $temp_path ".srec" ".elf" ]
                  } else {
                   set test_path $temp_path
                  }
                  # if not exist used default folder
                  if {![file exists ${TE::BASEFOLDER}/${test_path}]} { 
                    set file_tmp [file tail ${test_path}]
                    set file_ext [file extension ${test_path}]
                    set file_name [file rootname ${test_path}]
                    set checkfile [TE::UTILS::prebuilt_file_location true ${file_name} ${file_ext} ${os_selected} NA  ${curr_dir} false]
                    if {[string match "NA" $checkfile]} {
                      TE::UTILS::te_msg TE_SW-76 {ERROR} "${file_tmp} was not found."
                      set temp_rel "NA"
                    } else {
                      set temp_rel $checkfile
                    }
                  } else {
                    set temp_rel [TE::UTILS::relTo ${TE::BASEFOLDER}/${test_path} ${curr_dir}]
                  }
                  #check if srec is required and generate srec from elf
                  if {[string match *.srec* $temp_path]} {
                    set tmp [TE::UTILS::regex_map $temp_rel ".elf" ".srec" ]
                    generate_srec ${temp_rel} ${tmp}
                    set temp_rel ${tmp}
                  }
                  # set load_data "$load_data up [lindex $sw_applist_line [expr $data_index+1]] ${rel_data_file}/[lindex $sw_applist_line $data_index] "
                  set load_data "$load_data up [lindex $sw_applist_line [expr $data_index+1]] ${temp_rel}"
                }
                set data_index [expr $data_index+3]
              }
              #write mcs
              # -loadbit $load_bit 
              write_cfgmem -force -format mcs -checksum FF -interface $TE::CFGMEM_IF -size $TE::CFGMEM_MEMSIZE_MB \
              -loaddata $load_data \
              -file ${bi_folder_abs}/${app_name}.mcs
              
              TE::UTILS::create_prebuilt_report BI ${app_name}
            } else {
              TE::UTILS::te_msg TE_SW-9 {CRITICAL WARNING} "FPGA FLASH TYP  is not specified in *.board_files.csv. *.mcs file is not generated."
            }  
          }
        }
      } else {
        TE::UTILS::te_msg TE_SW-10 WARNING "${TE::PREBUILT_HW_PATH}/${int_shortdir}/${TE::PB_FILENAME}.mmi doesn't exist. Nothing is done."
      }
    }
    
    proc generate_srec {{elf_file ""} {srec_file ""} } {
      set command exec
      lappend command mb-objcopy
      lappend command -O srec ${elf_file} ${srec_file}


      TE::UTILS::te_msg TE_SW-67 INFO "Start generate srec: \n \
        Run \"$command\"  \n \
        Please Wait.. \n \
      ------"
      set result [eval $command]
        TE::UTILS::te_msg TE_EXT-3 INFO "Command results from Srec \"$command\": \n \
          $result \n \
        ------" 
    }  
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished *bit/*mcs generation functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # *bin/*bif generation functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--generate_bif_files:  
    proc generate_bif_files {{fname ""}} {
      set int_shortdir ${TE::SHORTDIR}
      if {$fname ne ""} {
        set int_shortdir "[TE::BDEF::find_shortdir $fname]"
      }
      set os_selected "NA"
      set app_name "NA"
      set checkfile "NA"
      
      set fsbl_abs ""
      set bitfile_abs ""
      set bif_folder ""
      set bif_appfile ""
      set bif_bitfile ""
      set bif_fsbl ""
      
      
      #check if bitfile exists
      set checkfile [TE::UTILS::prebuilt_file_location false ${TE::PB_FILENAME} .bit NA NA NA false]
      if {[string match "NA" $checkfile] } { 
        TE::UTILS::te_msg TE_SW-11 ERROR "Bit-file (${TE::PB_FILENAME}.bit)  doesn't exist in the prebuilt folders."
        return -code error "Bit-file (${TE::PB_FILENAME}.bit) doesn't exist in the prebuilt folders.";

      } 
      set bitfile_abs $checkfile
      
      #check if fsbl exists
      foreach sw_applist_line ${TE::SDEF::SW_APPLIST} {
        #read fsbl name
        if {[lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "FSBL" || [lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "FSBL_EXT"} {
          set fsbl_name [lindex $sw_applist_line ${TE::SDEF::APPNAME}]
          set os_selected [lindex $sw_applist_line ${TE::SDEF::OSNAME}]
          set checkfile [TE::UTILS::prebuilt_file_location false ${fsbl_name} .elf $os_selected NA NA false]
          if {[string match "NA" $checkfile] } { 
            TE::UTILS::te_msg TE_SW-12 ERROR "FSBL ELF-file (${fsbl_name}.elf)  doesn't exist in the prebuilt folders."
            return -code error "FSBL ELF-file (${fsbl_name}.elf) doesn't exist in the prebuilt folders.";
          }  
          set fsbl_abs [TE::UTILS::prebuilt_file_location false ${fsbl_name} .elf $os_selected NA NA false]
        }
      }
      
      #create bif
      foreach sw_applist_line ${TE::SDEF::SW_APPLIST} {
        #generate *.bif only if app_list.csv->steps=0(generate all) or steps=1(*.bif and *.bin use *.elf from prebuild folders )
        if {[lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "0" || [lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "1" || [lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "FSBL_APP"} {
          #set correct folders
          set os_selected [lindex $sw_applist_line ${TE::SDEF::OSNAME}]

          #read fsbl name
          #read app name and additional configs
          set app_name [lindex $sw_applist_line ${TE::SDEF::APPNAME}]
          TE::UTILS::te_msg TE_SW-15 STATUS "Generate BIF-file for: ${app_name}"
          
          #delete old prebuilt folder 
          set checkfile [TE::UTILS::prebuilt_file_location false BOOT .bin NA $app_name NA true]
          if {[file exists $checkfile]} {
            TE::UTILS::te_msg TE_SW-68 INFO "Delete  $checkfile"
            file delete -force $checkfile
            #make new one and set bif folder
            file mkdir $checkfile   
            set bif_folder $checkfile                
          } else {
            #make new one with shortdir and set bif folder
            file mkdir ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}          
            set bif_folder ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}                   
          }

          #relative location of the elf file
          set checkfile [TE::UTILS::prebuilt_file_location true ${app_name} .elf $os_selected NA $bif_folder false]
          if {[string match "NA" $checkfile] } { 
            TE::UTILS::te_msg TE_SW-69 ERROR "Elf-file (${app_name}.elf)  doesn't exist in the prebuilt folders."
            return -code error "Elf-file (${app_name}.elf)  doesn't exist in the prebuilt folders.";
          }  
          #set relative paths
          set bif_fsbl [TE::UTILS::relTo $fsbl_abs $bif_folder]
          set bif_bitfile [TE::UTILS::relTo $bitfile_abs $bif_folder]
          set bif_appfile $checkfile
          if { [lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "FSBL_APP"} {
            # fsbl boot.bin only no additional app is needed
            set bif_fsbl $checkfile
            set bif_appfile ""
          }
          
          # set data01_file ""
          # set data01_load ""
          # set data01_offset ""

          # if {$TE::IS_ZSYS} {
            # # data files
            # set data01_file [lindex $sw_applist_line ${TE::SDEF::ZYNQ_DATA01_FILE}]
            # set data01_load [lindex $sw_applist_line ${TE::SDEF::ZYNQ_DATA01_LOAD}]
            # set data01_offset [lindex $sw_applist_line ${TE::SDEF::ZYNQ_DATA01_OFFSET}]
          # } elseif {$TE::IS_ZUSYS} {
            # # data files
            # set data01_file [lindex $sw_applist_line ${TE::SDEF::ZYNQMP_DATA01_FILE}]
            # set data01_load [lindex $sw_applist_line ${TE::SDEF::ZYNQMP_DATA01_LOAD}]
            # set data01_offset [lindex $sw_applist_line ${TE::SDEF::ZYNQMP_DATA01_OFFSET}]
          # }

          # #replace na with ""
          # if {[string match $data01_file "NA"]} { set data01_file ""
          # } else { 
            # # check different possible places 
            # if {![file exists ${TE::BASEFOLDER}/${data01_file}]} {    
              # set temp_path [TE::UTILS::regex_map $data01_file "<short_dir>" ${int_shortdir} ]  
              # if {![file exists ${TE::BASEFOLDER}/${temp_path}]} { 
                  # set file_tmp [file tail ${data01_file}]
                  # set file_ext [file extension ${file_tmp}]
                  # set file_name [file rootname ${file_tmp}]
                  # set checkfile [TE::UTILS::prebuilt_file_location true ${file_name} ${file_ext} $os_selected NA $bif_folder false]
                  # if {[string match "NA" $checkfile]} {
                    # TE::UTILS::te_msg TE_SW-75 {CRITICAL WARNING} "${file_tmp} was not found and will be ignored."
                    # set data01_file ""
                  # } else {
                    # set data01_file $checkfile
                  # }
              # } else {
                # set data01_file $temp_path
              # }
            # } else {
              # set data01_file [TE::UTILS::relTo ${TE::BASEFOLDER}/${data01_file} $bif_folder] 
            # }
          # }
          # if {[string match $data01_load "NA"]} { set data01_load ""}
          # if {[string match $data01_offset "NA"]} { set data01_offset ""}
					
					#data list for zynqMP todo also bifgen with multiple files for zynq
          set data_index [llength $sw_applist_line]
					if {$TE::IS_ZSYS} {
						set data_index ${TE::SDEF::ZYNQ_DATA01_FILE}
					} elseif {$TE::IS_ZUSYS} {
						set data_index ${TE::SDEF::ZYNQMP_DATA01_FILE}
					}

					set data_file 	""
					set data_load 	""
					set data_offset ""
					while {$data_index < [llength $sw_applist_line] } {
						set tmp_data_file 	[lindex $sw_applist_line [expr $data_index+0]]
						set tmp_data_load 	[lindex $sw_applist_line [expr $data_index+1]]
						set tmp_data_offset [lindex $sw_applist_line [expr $data_index+2]]
						
						if {[string match $tmp_data_load "NA"]} { set tmp_data_load ""}
						if {[string match $tmp_data_offset "NA"]} { set tmp_data_offset ""}
						
						#replace na with ""
						if {[string match $tmp_data_file "NA"]} { set tmp_data_file ""
						} else { 
							# check different possible places 
							if {![file exists ${TE::BASEFOLDER}/${tmp_data_file}]} {    
								set temp_path [TE::UTILS::regex_map $tmp_data_file "<short_dir>" ${int_shortdir} ]  
								if {![file exists ${TE::BASEFOLDER}/${temp_path}]} { 
										set file_tmp [file tail ${tmp_data_file}]
										set file_ext [file extension ${file_tmp}]
										set file_name [file rootname ${file_tmp}]
										set checkfile [TE::UTILS::prebuilt_file_location true ${file_name} ${file_ext} $os_selected NA $bif_folder false]
										if {[string match "NA" $checkfile]} {
											TE::UTILS::te_msg TE_SW-75 {CRITICAL WARNING} "${file_tmp} was not found and will be ignored."
											set tmp_data_file ""
										} else {
											set tmp_data_file $checkfile
										}
								} else {
									set tmp_data_file $temp_path
								}
							} else {
								set tmp_data_file [TE::UTILS::relTo ${TE::BASEFOLDER}/${data01_file} $bif_folder] 
							}
						}
						set data_file 	"${data_file}${tmp_data_file}|"
						set data_load 	"${data_load}${tmp_data_load}|"
						set data_offset	"${data_offset}${tmp_data_offset}|"
						
						set data_index [expr $data_index+3]
          }
					
					set islinux false
					if {[string match $os_selected "petalinux"] || [string match $os_selected "linux"]} {
						set islinux true
					} 
					set isapp false
					if {![string match $bif_appfile "NA"] && ![string match $bif_appfile ""]} {
						set isapp true
					} 
					
          set uboot_dtb_used true
          set uboot_dtb_load [lindex $sw_applist_line ${TE::SDEF::UBOOT_DTB_LOAD}]
          set uboot_dtb_offset [lindex $sw_applist_line ${TE::SDEF::UBOOT_DTB_OFFSET}]
          set testid [lindex $sw_applist_line ${TE::SDEF::ID}]
          if {[string match $uboot_dtb_offset "$testid"]} { 
            # only to be currently backward compatible,, will be removed on the next update...data part is more general usable
            set uboot_dtb_offset "NA"
          }
          if {[string match $uboot_dtb_load "$testid"]} { 
            # only to be currently backward compatible,, will be removed on the next update...data part is more general usable
            set uboot_dtb_load "NA"
          }
          if {[string match $uboot_dtb_offset "NA"]} { 
            set uboot_dtb_offset ""
          }
          
          if {[string match $uboot_dtb_load "NA"]} { 
            set uboot_dtb_load ""
          } 
          
          
          set uboot_dtb ""
          if {![string match $uboot_dtb_load ""] || ![string match $uboot_dtb_offset ""]} { 
            set checkfile [TE::UTILS::prebuilt_file_location true "u-boot" .dtb $os_selected NA $bif_folder false]
            if {[string match "NA" $checkfile]} { 
              TE::UTILS::te_msg TE_SW-95 WARNING "u-boot.dtb  doesn't exist in the prebuilt folders."
              set uboot_dtb ""
            } else {
              set uboot_dtb ${checkfile}
            }
          } else {
            set uboot_dtb_used false
          }
          
          
          set bootscr_used true
          set bootscr_load [lindex $sw_applist_line ${TE::SDEF::BOOTSCR_LOAD}]
          set bootscr_offset [lindex $sw_applist_line ${TE::SDEF::BOOTSCR_OFFSET}]
          set testid [lindex $sw_applist_line ${TE::SDEF::ID}]
          if {[string match $bootscr_offset "$testid"]} { 
            # only to be currently backward compatible, will be removed on the next update...data part is more general usable
            set bootscr_offset "NA"
          }
          if {[string match $bootscr_load "$testid"]} { 
            # only to be currently backward compatible,  will be removed on the next update...data part is more general usable
            set bootscr_load "NA"
          }
          if {[string match $bootscr_offset "NA"]} { 
            set bootscr_offset ""
          }
          
          if {[string match $bootscr_load "NA"]} { 
            set bootscr_load ""
          }
          
          set bootscr ""
          if {![string match $bootscr_load ""] || ![string match $bootscr_offset ""]} { 
            set checkfile [TE::UTILS::prebuilt_file_location true "boot" .scr $os_selected NA $bif_folder false]
            if {[string match "NA" $checkfile]} { 
              TE::UTILS::te_msg TE_SW-95 WARNING "boot.scr  doesn't exist in the prebuilt folders."
              set bootscr ""
            } else {
              set bootscr ${checkfile}
            }
          } else {
            set bootscr_used false
          }
            
          
          if {$TE::IS_ZSYS} {
            #Zynq
            # write_bif ${bif_folder}/boot.bif  $bif_fsbl $bif_bitfile $bif_appfile $data01_file $data01_load $data01_offset "" "" ""
						TE::UTILS::vitis_z_bif -biffile ${bif_folder}/boot.bif -linux $islinux \
						-bootloader $bif_fsbl \
						-bitfile_use true -bitfile $bif_bitfile \
						-app_use $isapp -app $bif_appfile \
						-uboot_dtb_use $uboot_dtb_used  -uboot_dtb_load $uboot_dtb_load -uboot_dtb_offset $uboot_dtb_offset -uboot_dtb $uboot_dtb \
						-bscr_use $bootscr_used  -bscr_load $bootscr_load  -bscr_offset $bootscr_offset -bscr $bootscr \
						-data_f $data_file -data_o $data_offset -data_l $data_load

          } elseif {$TE::IS_ZUSYS} {
            #uzynq
            set fsbl_config [lindex $sw_applist_line ${TE::SDEF::ZYNQMP_FSBL_CONFIG}]
            if {[string match $fsbl_config "NA"]} { set fsbl_config ""}
            set destination_cpu [lindex $sw_applist_line ${TE::SDEF::DESTINATION_CPU}]
            if {[string match $destination_cpu "NA"]} { set destination_cpu ""}
            

            set exception_level [lindex $sw_applist_line ${TE::SDEF::ZYNQMP_EXCEPTION_LEVEL}]
            if {[string match $exception_level "NA"]} { set exception_level ""}
            #check atf (bl31.elf)
            set atf  [lindex $sw_applist_line ${TE::SDEF::ZYNQMP_ATF}]
            set checkfile [TE::UTILS::prebuilt_file_location true ${atf} .elf $os_selected NA $bif_folder false]
            if {[string match $atf "NA"]} { set atf ""} elseif {[string match "NA" $checkfile]} { 
              TE::UTILS::te_msg TE_SW-70 WARNING "ATF-file (${atf}.elf)  doesn't exist in the prebuilt folders."
              set atf ""
            } else {
              set atf ${checkfile}
            }
            #check pmu (zynqmp_pmufw.elf,pmufw.elf)
            set pmu  [lindex $sw_applist_line ${TE::SDEF::ZYNQMP_PMU}]
						set ispmu false
            set checkfile [TE::UTILS::prebuilt_file_location true ${pmu} .elf $os_selected NA $bif_folder false]
            if {[string match $pmu "NA"]} { set pmu ""} elseif {[string match "NA" $checkfile]} { 
              TE::UTILS::te_msg TE_SW-71 WARNING "PMU-file (${pmu}.elf)  doesn't exist in the prebuilt folders."
              set pmu ""
            } else {
							set ispmu true
              set pmu ${checkfile}
            }

						set isatf false
            if {![string match $atf "NA"] && ![string match $atf ""]} {
							set isatf true
						} 
									    
						
            # write_zusys_bif -biffile $bif_folder/boot.bif -fsbl_config $fsbl_config -bootloader $bif_fsbl -pmu $pmu -bitfile $bif_bitfile -app $bif_appfile -destination_cpu $destination_cpu -exception_level $exception_level -atf $atf -data01_f $data01_file -data01_o $data01_offset  -data01_l $data01_load
						TE::UTILS::vitis_zmp_bif -biffile ${bif_folder}/boot.bif -linux $islinux \
						-bootloader_cpu $fsbl_config -bootloader $bif_fsbl \
						-pmu_use $ispmu -pmu $pmu \
						-bitfile_use true -bitfile $bif_bitfile \
						-atf_use $isatf -atf_cpu $destination_cpu -atf_exception_level el-3 -atf $atf \
						-app_use $isapp -app_cpu $destination_cpu -app_exception_level $exception_level -app $bif_appfile \
						-uboot_dtb_use $uboot_dtb_used  -uboot_dtb_load $uboot_dtb_load -uboot_dtb_offset $uboot_dtb_offset -uboot_dtb $uboot_dtb \
						-bscr_use $bootscr_used  -bscr_load $bootscr_load -bscr_offset $bootscr_offset -bscr $bootscr \
						-data_f $data_file -data_o $data_offset -data_l $data_load

          } else {
            #error
            TE::UTILS::te_msg TE_SW-18 ERROR "ZSYS or ZUSYS is not defined."
          }
        }
      }
    }
    #--------------------------------
    #--write_bif:   replace with script_te_utils.tcl vitis_z_bif
    # proc write_bif { biffile {fsblfile "zynq_fsbl.elf"} {bitfile ""} {elffile ""} {data01_file ""} {data01_load ""} {data01_offset ""} {dtbfile ""} {intfile ""} {ssblfile ""} } {

      # set bif_fp [open "$biffile" w]

      # puts $bif_fp "the_ROM_image:\n\u007B"
      # #
      # # init data
      # #
      # if {$intfile!=""} { puts -nonewline $bif_fp {    [init]}}
      # if {$intfile!=""} { puts $bif_fp $intfile}
      # if {$intfile == ""} {TE::UTILS::te_msg TE_SW-19 STATUS "INT FILE NOT DEFINED..."}
      # #
      # # FSBL
      # #
      # if {$fsblfile!=""} { puts -nonewline $bif_fp {    [bootloader]}}
      # if {$fsblfile!=""} { puts $bif_fp $fsblfile}
      # if {$fsblfile == ""} {TE::UTILS::te_msg TE_SW-21 STATUS "FSBL FILE NOT DEFINED..."}
      # #
      # # BIT file
      # #
      # if {$bitfile!=""} { puts $bif_fp "    $bitfile"}
      # if {$bitfile == ""} {TE::UTILS::te_msg TE_SW-22 STATUS "BIT FILE NOT DEFINED..."}
      # #
      # # .ELF file
      # #
      # if {$elffile!=""} { puts $bif_fp "    $elffile"}
      # if {$elffile == ""} {TE::UTILS::te_msg TE_SW-23 STATUS "ELF FILE NOT DEFINED..."}
      # #
      # # SSBL
      # #
      # if {$ssblfile!=""} { puts $bif_fp "    $ssblfile"}
      # if {$ssblfile == ""} {TE::UTILS::te_msg TE_SW-24 STATUS "SSBL FILE NOT DEFINED..."}
      # #
      # # DTB file
      # #
      # if {$dtbfile!=""} { puts $bif_fp "    $dtbfile"}
      # if {$dtbfile == ""} {TE::UTILS::te_msg TE_SW-25 STATUS "DTB FILE NOT DEFINED..."}
      # #
      # # image.ub ore IMAGE file
      # #

      # if {$data01_load!="" || $data01_offset!=""} { puts -nonewline $bif_fp {    [}}
      # if {$data01_load!="" } { puts -nonewline $bif_fp {load = };puts -nonewline $bif_fp "$data01_load"}
      # if {$data01_load!="" && $data01_offset!=""} { puts -nonewline $bif_fp { , }}
      # if {$data01_offset!="" } { puts -nonewline $bif_fp {offset = };puts -nonewline $bif_fp "$data01_offset"}
      # if {$data01_load!="" || $data01_offset!=""} { puts -nonewline $bif_fp {]}}
      # if {$data01_file!=""} { puts $bif_fp $data01_file}
      
      # if {$data01_load == ""} {TE::UTILS::te_msg TE_SW-26 STATUS "FILE01 LOAD NOT DEFINED..."}
      # if {$data01_offset == ""} {TE::UTILS::te_msg TE_SW-27 STATUS "FILE01 OFFSET NOT DEFINED..."}
      # if {$data01_file == ""} {TE::UTILS::te_msg TE_SW-28 STATUS "FILE01 FILE NOT DEFINED..."}


      # puts $bif_fp "\u007D"

      # close $bif_fp

    # }
    #--------------------------------
    #--write_zusys_bif:   replace with script_te_utils.tcl vitis_zmb_bif
    # proc write_zusys_bif {{args ""}} {
      # set biffile ""
      # set fsbl_config ""
      # set bootloader ""
      # set pmu ""
      # set bitfile ""
      # set destination_cpu ""
      # set exception_level ""
      # #bl31.elf
      # set atf ""
      # set app ""
      # set data01_load ""
      # set data01_offset ""
      # set data01_file ""
      
      # set args_cnt [llength $args]
      # for {set option 0} {$option < $args_cnt} {incr option} {
        # switch [lindex $args $option] { 
          # "-biffile"                { incr option; set biffile [lindex $args $option]}
          # "-fsbl_config"            { incr option; set fsbl_config [lindex $args $option]}
          # "-bootloader"             { incr option; set bootloader [lindex $args $option]}
          # "-pmu"                    { incr option; set pmu [lindex $args $option]}
          # "-bitfile"     { incr option; set bitfile [lindex $args $option]}
          # "-destination_cpu"        { incr option; set destination_cpu [lindex $args $option]}
          # "-exception_level"        { incr option; set exception_level [lindex $args $option]}
          # "-atf"                    { incr option; set atf [lindex $args $option]}
          # "-app"                    { incr option; set app [lindex $args $option]}
          # "-data01_f"               { incr option; set data01_file [lindex $args $option]}
          # "-data01_o"               { incr option; set data01_offset [lindex $args $option]}
          # "-data01_l"               { incr option; set data01_load [lindex $args $option]}
          # default                   {TE::UTILS::te_msg TE_SW-29 ERROR "unrecognised option for BIF generation: [lindex $args $option]";return -code error }
        # }
      # }
      # set bif_fp [open "$biffile" w]

      # puts $bif_fp "//arch = zynqmp; split = false; format = BIN"
      # puts $bif_fp "the_ROM_image:\n\u007B"
      # #fsbl_config
      # # if {$fsbl_config!=""} { puts -nonewline $bif_fp {  [fsbl_config]}}
      # # if {$fsbl_config!=""} { puts $bif_fp $fsbl_config}
      # if {$fsbl_config == ""} {TE::UTILS::te_msg TE_SW-30 STATUS "FSBL_CONFIG NOT DEFINED..."}
      # #bootloader
      # if {$bootloader!=""} { puts -nonewline $bif_fp {  [bootloader, destination_cpu=}}
      # if {$bootloader!=""} { puts -nonewline $bif_fp $fsbl_config}
      # if {$bootloader!=""} { puts -nonewline $bif_fp {]}}
      # if {$bootloader!=""} { puts $bif_fp $bootloader}
      # if {$bootloader == ""} {TE::UTILS::te_msg TE_SW-31 STATUS "BOOTLOADER NOT DEFINED..."}
      # #pmuf
      # if {$pmu!=""} { puts -nonewline $bif_fp {  [pmufw_image]}}
      # if {$pmu!=""} { puts $bif_fp $pmu}
      # if {$pmu == ""} {TE::UTILS::te_msg TE_SW-31 STATUS "PMU NOT DEFINED..."}
      # #bitfile
      # if {$bitfile!=""} { puts -nonewline $bif_fp {  [destination_device = pl]}}
      # if {$bitfile!=""} { puts $bif_fp $bitfile}
      # if {$bitfile == ""} {TE::UTILS::te_msg TE_SW-32 STATUS "BITFILE NOT DEFINED..."}
      # #atf
      # if {$atf!=""} { puts -nonewline $bif_fp {  [}}
      # if {$atf!=""} { puts -nonewline $bif_fp "destination_cpu =$destination_cpu"}
      # if {$atf!=""} { puts -nonewline $bif_fp ", exception_level =el-3"}
      # if {$atf!=""} { puts -nonewline $bif_fp ", trustzone"}
      # if {$atf!=""} { puts -nonewline $bif_fp {]}}
      # if {$atf!=""} { puts $bif_fp $atf}
      # if {$atf == ""} {TE::UTILS::te_msg TE_SW-33 STATUS "ATF BL31 ELF NOT DEFINED..."}
      # #elf
      # if {$app!=""} { puts -nonewline $bif_fp {  [}}
      # if {$app!=""} { puts -nonewline $bif_fp "destination_cpu =$destination_cpu"}
      # if {$app!="" && $exception_level!=""} { puts -nonewline $bif_fp ", exception_level =$exception_level"}
      # if {$app!=""} { puts -nonewline $bif_fp {]}}
      # if {$app!=""} { puts $bif_fp $app}
      # if {$app == ""} {TE::UTILS::te_msg TE_SW-34 STATUS "APPLICATION ELF NOT DEFINED..."}
      # #file
      # if {$data01_file!=""} { puts -nonewline $bif_fp {  [}}
      # if {$data01_file!="" && $data01_offset!=""} { puts -nonewline $bif_fp {load = };puts -nonewline $bif_fp "$data01_offset"}
      # if {$data01_file!="" && $data01_load!=""} { puts -nonewline $bif_fp {offset = };puts -nonewline $bif_fp "$data01_load"}
      # if {$data01_file!=""} { puts -nonewline $bif_fp ", destination_cpu =$destination_cpu"}
      # if {$data01_file!=""} { puts -nonewline $bif_fp {]}}
      # if {$data01_file!=""} { puts $bif_fp $data01_file}
      # if {$data01_file == ""} {TE::UTILS::te_msg TE_SW-72 STATUS "FILE NOT DEFINED..."}
      # if {$data01_offset == "" && $data01_file != "" && $data01_load == ""} {TE::UTILS::te_msg TE_SW-73 STATUS "FILE OFFSET NOT DEFINED..."}
      # if {$data01_load == "" && $data01_file != "" && $data01_offset == ""} {TE::UTILS::te_msg TE_SW-74 STATUS "FILE LOAD NOT DEFINED..."}
      
      # puts $bif_fp "\u007D"

      # close $bif_fp

    # }
    #--------------------------------
    #--generate_bootbin:  
    proc generate_bootbin {{fname ""}} {
      set int_shortdir ${TE::SHORTDIR}
      if {$fname ne ""} {
        set int_shortdir "[TE::BDEF::find_shortdir $fname]"
      }
      foreach sw_applist_line ${TE::SDEF::SW_APPLIST} {
        #generate *.bin only if app_list.csv->steps=0(generate all) or steps=1(*.bif and *.bin use *.elf from prebuild folders ) or steps=2(*.bin use *.elf and *.bif from prebuild folders)
        if {[lindex $sw_applist_line ${TE::SDEF::STEPS}]==0 || [lindex $sw_applist_line ${TE::SDEF::STEPS}]==1 || [lindex $sw_applist_line ${TE::SDEF::STEPS}]==2 || [lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "FSBL_APP"} {
          #read app name
          set app_name [lindex $sw_applist_line ${TE::SDEF::APPNAME}]
          #delete old one
          if {[file exists ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/boot.bin]} {
            file delete -force ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/boot.bin
          }
          #
          if {![file exists  ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/boot.bif]} { 
            TE::UTILS::te_msg TE_SW-35 ERROR "Application BIF-File found (${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/boot.bif)."
            return -code error "Application BIF-File found (${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/boot.bif).";
          }
          #todo:hier noch in default suche?
          TE::UTILS::te_msg TE_SW-36 STATUS "Generate Boot.bin for Application: ${app_name}"
          set cur_path [pwd]
          cd ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}
          set command exec
          lappend command bootgen
          lappend command -image boot.bif
          #Ultrascale+Zynq
          if {$TE::IS_ZUSYS} {
            lappend command -arch zynqmp
          }
          lappend command -w on -o BOOT.bin
          # puts $command
          TE::UTILS::te_msg TE_SW-37 INFO "Start BootGen: \n \
            Run \"$command\" in ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name} \n \
            Please Wait.. \n \
          ------"
          set result [eval $command]
          TE::UTILS::te_msg TE_EXT-4 INFO "Command results from BootGen \"$command\": \n \
            $result \n \
          ------"    
          cd $cur_path   
          TE::UTILS::create_prebuilt_report BI ${app_name}
          #todo better solution for linux
          if {[string match "$app_name" "u-boot"]} {
            TE::UTILS::create_prebuilt_report OS
          }
        }
      }
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished  *bin/*bif generation functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # programming functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--get_available_apps: 
    proc get_available_apps {{fname ""}} {
      set int_shortdir ${TE::SHORTDIR}
      set avapps [list]
      if {$fname ne ""} {
        set int_shortdir "[TE::BDEF::find_shortdir $fname]"
      }
      set applist []
      [catch {set applist [glob -join -dir ${TE::PREBUILT_BI_PATH}/${int_shortdir}/ *]}]
      set app_txt "Following Applications are available: \n"
      foreach app $applist {
        set tmp [split $app "/"]
        set app_txt "$app_txt [lindex $tmp [expr [llength $tmp]-1]]\n"
        lappend avapps [lindex $tmp [expr [llength $tmp]-1]]
      }
      TE::UTILS::te_msg TE_PR-38 INFO "$app_txt ------"
      return $avapps
    }
    #--------------------------------
    #--excecute_zynq_flash_programming: 
    proc excecute_zynq_flash_programming {use_basefolder app_name {fname ""}} {
      set return_filename ""
      set int_shortdir ${TE::SHORTDIR}
      set int_flashtyp $TE::ZYNQFLASHTYP
      set run_path ""
      set bootbinname BOOT.bin
      set fsblfile ""
      if {$fname ne ""} {
        set int_shortdir "[TE::BDEF::find_shortdir $fname]"
        #get flashtyp form shortdir
        set int_flashtyp "[TE::BDEF::get_zynqflashtyp $int_shortdir 4]"
      }
      if {![string match $int_flashtyp "NA"]} {
        set cur_path [pwd]
        if {$use_basefolder} {
          set binfilename ""
          if { ![catch {set binfilename [glob -join -dir ${TE::BASEFOLDER}/ *.bin]}] } {
            TE::UTILS::te_msg TE_PR-39 STATUS "Used file:${binfilename}"
            set return_filename ${binfilename}
            set run_path $TE::BASEFOLDER
            set nameonly [file tail [file rootname $binfilename]]
            set bootbinname ${nameonly}.bin
            if {[file exists ${TE::BASEFOLDER}/fsbl_flash.elf]} {
              set fsblfile ${TE::BASEFOLDER}/fsbl_flash.elf           
            } else {
              TE::UTILS::te_msg TE_PR-89 {CRITICAL WARNING} "Zynq FSBL file (${TE::BASEFOLDER}/fsbl_flash.elf) doesn't exist." 
            }  
          } else {
            TE::UTILS::te_msg TE_PR-40 ERROR "Bin-File doesn't exist in ${TE::BASEFOLDER}."
            return -code error "Bin-File doesn't exist in ${TE::BASEFOLDER}.";
          }
          cd ${TE::BASEFOLDER}
        } else {
          if {![file exists  ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/BOOT.bin]} { 
            TE::UTILS::te_msg TE_PR-41 ERROR "Application Bin-File (${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/BOOT.bin) doesn't exist."
            return -code error "Application Bin-File (${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/BOOT.bin) doesn't exist.";
          }
          cd ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}
          set run_path ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}
          set bootbinname BOOT.bin
          if {[file exists ${TE::PREBUILT_SW_PATH}/${int_shortdir}/fsbl_flash.elf]} {
            set fsblfile ${TE::PREBUILT_SW_PATH}/${int_shortdir}/fsbl_flash.elf            
          } else {
            TE::UTILS::te_msg TE_PR-90 {CRITICAL WARNING} "Zynq FSBL file (${TE::PREBUILT_SW_PATH}/${int_shortdir}/fsbl_flash.elf) doesn't exist." 
          } 
          TE::UTILS::te_msg TE_PR-40 STATUS "Used file:${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/Boot.bin"
          set return_filename ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/Boot.bin
        }
        set command exec
        
        # lappend command zynq_flash
        lappend command program_flash
        lappend command -f $bootbinname
        lappend command -fsbl $fsblfile
        lappend command -flash_type $int_flashtyp
        TE::UTILS::te_msg TE_PR-41 INFO "Start program flash: \n \
          Run \"$command\" in ${run_path} \n \
          Please Wait.. \n \
        ------"
        set result [eval $command]
        TE::UTILS::te_msg TE_EXT-5 INFO "Command results from program flash \"$command\": \n \
          $result \n \
        ------"  
        cd $cur_path 
      } else {
        TE::UTILS::te_msg TE_PR-42 ERROR "Programming failed: Zynq Flash Typ is not specified for this board part. See ${TE::BOARDDEF_PATH}/..._board_files.csv"
      }
      return $return_filename
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished programming functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # utilities functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
 
    #--------------------------------
    #--unzip_project: 
    proc unzip_project {zipname file_location} {
      set command exec
      if {${TE::ZIP_PATH} ne ""} {
        if {[file tail [file rootname ${TE::ZIP_PATH}]] eq "7z"} {
          lappend command ${TE::ZIP_PATH}
          lappend command x  ${file_location}/${zipname}
          lappend command -o${file_location}
        } else {
          lappend command ${TE::ZIP_PATH}
          lappend command -help
          # lappend command -e ${file_location}/${zipname}
          # lappend command ${file_location}
        }
        TE::UTILS::te_msg TE_UTIL-73 INFO "Start UNZIP: \n \
          Run \"$command\" \n \
          Please Wait.. \n \
        ------"
        set result [eval $command]
        TE::UTILS::te_msg TE_EXT-7 INFO "Command results from UNZIP \"$command\": \n \
          $result \n \
        ------"  
        } else {
          TE::UTILS::te_msg TE_UTIL-74 {CRITICAL WARNING} "Zip not specified. Set zip path and *exe of the zip program in \"design_basic_settings.cmd\" file : example 7zip: @set ZIP_PATH=C:/Program Files (x86)/7-Zip/7z.exe"
        }
    }
    #--------------------------------
    #--zip_project: 
    proc zip_project {zipname {excludelist ""} {initials "NA"} {dest "NA"} {typ "NA"} {btyp "NA"} {pext "NA"} {rev "NA"}} {
      set tmp_series [lindex [split $TE::PRODID "-"] 0]
      set tmp_projectname "-${TE::VPROJ_NAME}"
      set tmp_without_prebuilt "_noprebuilt"
      set tmp_vivado_ver "-vivado_$::env(VIVADO_VERSION)"
      set tmp_script_ver "-build_[lindex [split $TE::SCRIPTVER "."] [expr [llength [split $TE::SCRIPTVER "."]]-1]]"
      set tmp_date "_[ clock format [clock seconds] -format "%Y%m%d%H%M%S"]"
      
      set pname ${TE::VPROJ_NAME}
      set ptool "Vivado-$::env(VIVADO_VERSION)"
      set release [ clock format [clock seconds] -format "%Y.%m.%d %H:%M:%S"]
      #revision is reserved
      set revision $rev
      
      
      set zipname  $zipname
      if {![string match ${dest} "NA"]} {
        set zipname  "${tmp_series}${tmp_projectname}${tmp_vivado_ver}${tmp_script_ver}${tmp_date}"
      }

      #todo mit übergabeparameter prebuilt weglassen oder so
      #remove old backup project copy
      set sourcepath [string trim $TE::VPROJ_PATH "vivado"]
      set destinationpath ${TE::BACKUP_PATH}/${TE::VPROJ_NAME}
      if {[file exists ${destinationpath}]} { 
        file delete -force ${destinationpath}  
      }
      #create new destination folder
      file mkdir ${destinationpath}
      set cur_path [pwd]
      cd ${TE::BACKUP_PATH}
      #get all files
      set filelist [ glob ${sourcepath}*]
      #remove backup folder
      set findex [lsearch $filelist *backup]
      set filelist [lreplace $filelist[set filelist {}] $findex $findex]
      
      foreach el $filelist {
      file copy -force ${el} ${destinationpath}
      }
      set excludelist
      foreach el $excludelist {
        set find ""
        if {[catch {set find [glob -join -dir $destinationpath $el]}]} {
          TE::UTILS::te_msg TE_UTIL-75 INFO "$el doesn't exist."
        } else {
          TE::UTILS::te_msg TE_UTIL-76 INFO "Excluded from backup:$find"
          file delete -force $find
        }
      }

      # remove .svn folders (.svn are ignored in globe)
        if {[file exists $destinationpath/console/.svn]} {
          file delete -force $destinationpath/console/.svn
        }
        
        if {[file exists $destinationpath/scripts/.svn]} {
          file delete -force $destinationpath/scripts/.svn
        }
        set svnsearch [list]
        [catch { set svnsearch [glob -join -type {d} -dir $destinationpath/board_files/  *]}]
        foreach f $svnsearch {
          if {[file exists $f/.svn]} {
            file delete -force $f/.svn
          }
        }
        set svnsearch [list]
        [catch { set svnsearch [glob -join -type {d} -dir  -dir $destinationpath/ip_lib/  *]}]
        foreach f $svnsearch {
          if {[file exists $f/.svn]} {
            file delete -force $f/.svn
          }
        }

      # write metadata file  
      TE::UTILS::write_zip_info "${destinationpath}/settings" "$zipname" "$initials" "$dest" "$typ" "$btyp" "$pname" "$ptool" "$release" "$revision"
      # set command exec
      if {${TE::ZIP_PATH} ne ""} {
        zip_general "./${TE::VPROJ_NAME}" $zipname
      } else {
       TE::UTILS::te_msg TE_UTIL-78 {CRITICAL WARNING} "Zip not specified or not installed. On WinOs install 7zip, on linux install zip (apt-get install zip) Set zip path and *exe of the zip program in \"design_basic_settings.cmd\" file : example 7zip: @set ZIP_PATH=C:/Program Files (x86)/7-Zip/7z.exe"
      }
      # in case with production extentions:
      if {[string match "yes" ${pext}]} {
        #remove project copy
        if {[file exists ${destinationpath}]} { 
          file delete -force ${destinationpath}  
        }
        set destinationpath "${TE::BACKUP_PATH}/Produktionstest"
        if {[file exists ${destinationpath}]} { 
          file delete -force ${destinationpath}  
        }
        file mkdir ${destinationpath}
        file copy -force ${zipname}.zip ${destinationpath}
        file delete -force ${zipname}.zip 
        file copy -force "${TE::BASEFOLDER}/../prod_cfg_list.csv" ${destinationpath}
        file copy -force "${TE::BASEFOLDER}/../cfg_init" ${destinationpath}
        if {[file exists ${destinationpath}/cfg_init/external/.svn]} {
          file delete -force  ${destinationpath}/cfg_init/external/.svn
        }
        
        set zipname "${zipname}_extended"
        zip_general "./Produktionstest" $zipname
      }
      # in case of public_doc, create both with and without prebuilt
      if {[string match "PublicDoc" ${dest}]} {
      
        if {[catch {set find [glob -join -dir $destinationpath "prebuilt"]}]} {
          TE::UTILS::te_msg TE_UTIL-159 INFO "prebuilt doesn't exist."
        } else {
          TE::UTILS::te_msg TE_UTIL-160 INFO "Excluded from backup:$find"
          file delete -force $find
        }
        set zipname  "${tmp_series}${tmp_projectname}${tmp_without_prebuilt}${tmp_vivado_ver}${tmp_script_ver}${tmp_date}"
        TE::UTILS::write_zip_info "${destinationpath}/settings" "$zipname" "$initials" "$dest" "$typ" "$btyp" "$pname" "$ptool" "$release" "$revision"
        if {${TE::ZIP_PATH} ne ""} {
          zip_general "./${TE::VPROJ_NAME}" $zipname
        } else {
         TE::UTILS::te_msg TE_UTIL-161 {CRITICAL WARNING} "Zip not specified. Set zip path and *exe of the zip program in \"design_basic_settings.cmd\" file : example 7zip: @set ZIP_PATH=C:/Program Files (x86)/7-Zip/7z.exe"
        }
      }
      
      
      #remove project copy
      if {[file exists ${destinationpath}]} { 
        file delete -force ${destinationpath}  
      }
      cd $cur_path
    }
    
    #--------------------------------
    #--zip_general: 
    proc zip_general {path zipname} {
      set command exec
      if {${TE::ZIP_PATH} ne ""} {
      
        switch [TE::UTILS::get_host_os] {
          "windows" {
            if {[file tail [file rootname ${TE::ZIP_PATH}]] eq "7z"} {
              lappend command ${TE::ZIP_PATH}
              lappend command a -tzip "$zipname.zip"
              lappend command "${path}/"
              lappend command -r 
            } else {
              lappend command ${TE::ZIP_PATH}
              lappend command -r
              lappend command "$zipname.zip"
              lappend command "${path}/*.*"
            }
          }
          "unix" {
            lappend command ${TE::ZIP_PATH} 
            lappend command -q -r
            lappend command "$zipname.zip"
            # lappend command . -i
            # lappend command "${path}/*.*"
            lappend command "${path}"
          }
        }
            
        TE::UTILS::te_msg TE_EXT-9 INFO "Start ZIP: \n \
          Run \"$command\" \n \
          Please Wait.. \n \
        ------"
        set result [eval $command]
        TE::UTILS::te_msg TE_EXT-10 INFO "Command results from ZIP \"$command\": \n \
          $result \n \
        ------"  
        
      } else {
        switch [TE::UTILS::get_host_os] {
          "windows" {
            TE::UTILS::te_msg TE_EXT-11 {CRITICAL WARNING} "Zip not specified. Set zip path and *exe of the zip program in \"design_basic_settings.cmd\" file : example 7zip: @set ZIP_PATH=C:/Program Files (x86)/7-Zip/7z.exe"
          }
          "unix" {
            TE::UTILS::te_msg TE_EXT-12 {CRITICAL WARNING} "Zip not specified. Set zip path and executable binary of the zip program in \"design_basic_settings.sh\" file : example zip: export ZIP_PATH=`which zip` \n \
            Note : \n \
            - tested OS : Ubuntu 16.04 \n \
            - to install zip : sudo apt install zip \n \
            - `which zip` returns complete path including binary file, it should be /usr/bin/zip"
          }
        }
      }
    }
    #--------------------------------
    #--run_putty: under development
    proc run_putty {{COM_LIST false} {filename ""}} {
      if { ([string match "unix" [TE::UTILS::get_host_os] ] &&  ${TE::TE_WSL_USAGE} == 1) || [string match "windows" [TE::UTILS::get_host_os] ]} {
        set command exec
        # lappend command chgport  
        # chgport is replaced: https://docs.microsoft.com/de-de/windows-server/administration/windows-commands/chgport
        if { ${TE::TE_WSL_USAGE} == 0 } {
          lappend command  change
          
        } else {
          lappend command  change.exe 
        }
        lappend command  port
        set result ""
         #error but works since changed since https://support.microsoft.com/de-de/topic/9-november-2021-kb5007186-betriebssystembuilds-19041-1348-19042-1348-und-19043-1348-033ee59c-e9b7-4eaf-8ee7-b3512bb1a0aa
        # set result [eval $command]
        if {[catch {set result [eval $command]} result]} {
          puts "Windows bug still availabel..."
        }
        set tmplist [list]
        set com_av false
        
        foreach line $result {
          # if {[string match "COM*" $line]  && ![string match "COM1" $line]} {
          # }
         # filter com ports and remove error messages from list
          if {[string match "COM*" $line] && ![string match "COM-*" $line]  } {
            lappend tmplist $line
            if { [lsearch  $TE::COM_IGNORE_LIST $line] == -1} {
              if {[string match "${TE::DESIGN_UART_COM}" $line]} {
                set com_av true
              }
            
            }
          }
        }
          
        if { ${com_av} eq false} {
            set TE::DESIGN_UART_COM [lindex $tmplist [expr [llength $tmplist]-1]]
            TE::UTILS::te_msg TE_EXT-16 INFO "Set COM Port to ${TE::DESIGN_UART_COM}"
        }
        if {$COM_LIST ne false} {
          return $tmplist
        } else {
        # putty -serial com12 -sercfg 115200,8,n,1,N
        
          set command exec
          
          if { [file exists ${TE::COM_PATH}/putty.exe] } {
            lappend command ${TE::COM_PATH}/putty.exe
          } else {
            lappend command putty
          }
          lappend command -serial ${TE::DESIGN_UART_COM} 
          lappend command -sercfg ${TE::DESIGN_UART_SPEED},8,n,1,N
          if {[llength $filename] > 4} {
            lappend command -sessionlog ${TE::LOG_PATH}/$filename
          } elseif {$filename eq "d"} {
          } else {
            lappend command -sessionlog ${TE::LOG_PATH}/putty-${TE::PRODID}-&y&m&d-&t.log
          }
          lappend command &
          set pid [eval $command]
           # puts "Start with $command" 
           # puts "Console runs with PID:$pid" 
          return $pid
          # terminate existing console needs admin rights:
            # #taskkill /F /PID <pid>
            # set command taskkill
            # lappend command  /F /PID $pid
            # set result [eval exec $command]
            # puts Terminate PID:$pid : $result" 
        
        }
      } else {
        return "Not supported on this OS"
      }

      
    }
    
    #--run_serial: 
    proc run_serial {{serial NA}  {metadata 0} {factoryorder 0}} {
    
      set tmpdir [pwd]
      cd $TE::LOG_PATH 
      set val "Scanning not available"
      set command exec
      if { ${TE::TE_WSL_USAGE} == 0 } {
        lappend command powershell 
        
      } else {
        lappend command powershell.exe 
      }
      lappend command -file  
      lappend command ${TE::SERIAL_PATH}/getartikelbyserial.ps1
      lappend command $serial
      lappend command ${TE::SERIAL_PATH}
      lappend command ${metadata}
      lappend command ${factoryorder}
      lappend command "0"
      
      
      if { [string match "unix" [TE::UTILS::get_host_os] ]  } {
        # lappend command "&"
        if { ${TE::TE_WSL_USAGE} == 1 } {
          if {[catch {set val [eval $command]} result]} {set val "$result"}
        }
      } else {
        if {[catch {set val [eval $command]} result]} {set val "$result"}
      }

      cd $tmpdir 
      return $val
    }   
    
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished utilities functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # SVN functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--svn_status: 
    proc svn_status {} {
      set cur_path [pwd]
      cd ${TE::BASEFOLDER}
      set command exec
      lappend command svn 
      lappend command status
      TE::UTILS::te_msg TE_EXT-19 INFO "Start SVN status: \n \
        Run \"$command\" in ${TE::BASEFOLDER} \n \
        Please Wait.. \n \
      ------"
      set result [eval $command]
        TE::UTILS::te_msg TE_EXT-20 INFO "Command results from SVN \"$command\": \n \
          $result \n \
        ------" 
      cd $cur_path 
    } 
    
    #--svn_update: 
    proc svn_update {} {
      set cur_path [pwd]
      cd ${TE::BASEFOLDER}
      set command exec
      lappend command svn 
      lappend command update
      TE::UTILS::te_msg TE_EXT-21 INFO "Start SVN Update: \n \
        Run \"$command\" in ${TE::BASEFOLDER} \n \
        Please Wait.. \n \
      ------"
      set result [eval $command]
        TE::UTILS::te_msg TE_EXT-22 INFO "Command results from SVN \"$command\": \n \
          $result \n \
        ------" 
      cd $cur_path 
    }   
    #--svn_add: 
    proc svn_add {{pathname ""}} {
      TE::EXT::svn_update
      set abpath [file normalize $pathname]
      if { ([file exists $abpath]) && (![string match -nocase "" $pathname ] )} { 
        set cur_path [pwd]
        cd ${TE::BASEFOLDER}
        set command exec
        lappend command svn 
        lappend command add 
        lappend command $abpath
        lappend command --force 
        TE::UTILS::te_msg TE_EXT-23 INFO "Start SVN ADD folder $abpath: \n \
          Run \"$command\" in ${TE::BASEFOLDER} \n \
          Please Wait.. \n \
        ------"
        set result [eval $command]
          TE::UTILS::te_msg TE_EXT-24 INFO "Command results from SVN \"$command\": \n \
            $result \n \
          ------" 
        cd $cur_path 
      } else {
        TE::UTILS::te_msg TE_EXT-35 ERROR "Path ($abpath) not specified or not available\n "
      }
    }  
    #--svn_remove: 
    proc svn_remove {{pathname ""}} {
      TE::EXT::svn_update
      set abpath [file normalize $pathname]
      if { ([file exists $abpath]) && (![string match -nocase "" $abpath ] )} { 
        set cur_path [pwd]
        cd ${TE::BASEFOLDER}
        set command exec
        lappend command svn 
        lappend command delete  
        lappend command $abpath
        lappend command --force 
        TE::UTILS::te_msg TE_EXT-23 INFO "Start SVN Delete folder $abpath: \n \
          Run \"$command\" in ${TE::BASEFOLDER} \n \
          Please Wait.. \n \
        ------"
        set result [eval $command]
          TE::UTILS::te_msg TE_EXT-24 INFO "Command results from SVN \"$command\": \n \
            $result \n \
          ------" 
        cd $cur_path 
      } else {
        TE::UTILS::te_msg TE_EXT-34 ERROR "Path ($abpath) not specified or not available\n "
      }
    }  
    
    #--svn_commit: 
    proc svn_commit {{mgs ""}} {
      TE::EXT::svn_update
      set cur_path [pwd]
      cd ${TE::BASEFOLDER}
      set command exec
      lappend command svn 
      lappend command commit 
      lappend command --include-externals 
      lappend command -m $mgs
      TE::UTILS::te_msg TE_EXT-25 INFO "Start SVN Commit: \n \
        Run \"$command\" in ${TE::BASEFOLDER} \n \
        Please Wait.. \n \
      ------"
      set result [eval $command]
        TE::UTILS::te_msg TE_EXT-26 INFO "Command results from SVN \"$command\": \n \
          $result \n \
        ------" 
      cd $cur_path 
    }  
    
    #--svn_checkin: (older version) 
    proc svn_checkin {foldername {mgs ""}} {
      set message $mgs
      if {![file exists $foldername]} { 
        set message "Error: Folder ( $foldername) doesn't exist."
      } else {
      set cur_path [pwd]
      cd ${foldername}
      set command exec
      lappend command svn
      lappend command ci
      lappend command -m $message
      TE::UTILS::te_msg TE_EXT-27 INFO "Start SVN Checkin: \n \
        Run \"$command\" in ${foldername} \n \
        Please Wait.. \n \
      ------"
      set result [eval $command]
      TE::UTILS::te_msg TE_EXT-28 INFO "Command results from SVN check in \"$command\": \n \
        $result \n \
      ------"  
      cd $cur_path 
      }
    }   
    
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished SVN functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    proc editor {{filename ""}} {
      if {! [string match -nocase $TE::TE_EDITOR ""] } {
        set cur_path [pwd]
        
        # set t_PYTHONHOME $::env(PYTHONHOME)
        # set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
        # set t_PYTHONPATH $::env(PYTHONPATH)
        # set t_PYTHON $::env(PYTHON)
        # unset ::env(PYTHONHOME) 
        # unset ::env(LD_LIBRARY_PATH) 
        # unset ::env(PYTHONPATH)
        # unset ::env(PYTHON) 
        
        # start config
        set command exec
        # lappend command gnome-terminal
        # lappend command -- unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config
        lappend command ${TE::TE_EDITOR}
        lappend command $filename
        # lappend command petalinux-config
        TE::UTILS::te_msg TE_EXT-29 INFO "Start ${TE::TE_EDITOR} Editor: \n "
        set result [eval $command]
        TE::UTILS::te_msg TE_EXT-30 INFO "Command results from \"$command\": \n \
            $result \n \
          ------" 
        
        # set ::env(PYTHONHOME) $t_PYTHONHOME
        # set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
        # set ::env(PYTHONPATH) $t_PYTHONPATH
        # set ::env(PYTHON) $t_PYTHON
          
        cd $cur_path 
      } else {
        TE::UTILS::te_msg TE_EXT-31 {CRITICAL WARNING} "Editor not defined\n "
      }
    }
    
     proc terminal {} {
        switch [TE::UTILS::get_host_os] {
          "windows" {

          }
          "unix" {
            # set t_PYTHONHOME $::env(PYTHONHOME)
            # set t_LD_LIBRARY_PATH $::env(LD_LIBRARY_PATH)
            # set t_PYTHONPATH $::env(PYTHONPATH)
            # set t_PYTHON $::env(PYTHON)
            # unset ::env(PYTHONHOME) 
            # unset ::env(LD_LIBRARY_PATH) 
            # unset ::env(PYTHONPATH)
            # unset ::env(PYTHON) 
            
            # start config
            set command exec
            # lappend command gnome-terminal
            # lappend command -- unset PYTHONHOME; unset PYTHONPATH; unset PYTHON ;petalinux-config
            lappend command xterm
            # lappend command -e "unset PYTHONHOME; unset PYTHONPATH; unset PYTHON"
            lappend command "&"
            TE::UTILS::te_msg TE_EXT-32 INFO "Start terminal: \n "
            set result [eval $command]
            TE::UTILS::te_msg TE_EXT-33 INFO "Command results from \"$command\": \n \
                $result \n \
              ------" 
            
            # set ::env(PYTHONHOME) $t_PYTHONHOME
            # set ::env(LD_LIBRARY_PATH) $t_LD_LIBRARY_PATH
            # set ::env(PYTHONPATH) $t_PYTHONPATH

          }
        }
          
          # set ::env(PYTHON) $t_PYTHON
            
      }
  
  
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # SDSoC functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--run_sdsoc: 
    proc run_sdsoc {} {
		  puts "run_sdsoc is obsolete and will be removed in the next releases"
      # set cur_path [pwd]
      # cd ${TE::SDSOC_PATH}
      # set command exec
      # lappend command sdsoc 
      # lappend command -workspace ${TE::SDSOC_PATH}
      # # lappend command -lp ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
      # TE::UTILS::te_msg TE_SW-38 INFO "Start SDSoC: \n \
        # Run \"$command\" in ${TE::SDSOC_PATH} \n \
        # Please Wait.. \n \
      # ------"
      # set result [eval $command]
        # TE::UTILS::te_msg TE_EXT-13 INFO "Command results from SDSoC \"$command\": \n \
          # $result \n \
        # ------" 
      # cd $cur_path 
    }   
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished sdsoc functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  }
  puts "INFO:(TE) Load Vivado script finished"
}
