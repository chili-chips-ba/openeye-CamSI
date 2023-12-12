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
# --$Create Date:2016/02/11 $
# --$Modify Autor: Hartfiel, John $
# --$Modify Date: 2016/07/13 $
# --------------------------------------------------------------------
# --------------------------------------------------------------------
namespace eval TE {
  namespace eval EXT {
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # *elf generation functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--run_sdk:  
    proc run_sdk {} {
        set cur_path [pwd]
        cd $TE::WORKSPACE_SDK_PATH
        set tmplist [list]
        if {[file exists ${TE::XILINXGIT_DEVICETREE}]} {
          puts "Info:(TE) Include Xilinx Devicetree git clone."
          lappend tmplist "-lp" $TE::LIB_PATH
          lappend tmplist "-lp" ${TE::XILINXGIT_DEVICETREE}
        } else {
          puts "Warning:(TE) Xilinx Devicetree git clone path not found (${TE::XILINXGIT_DEVICETREE})."
          lappend tmplist "-lp" $TE::LIB_PATH
        }
        set command exec
        lappend command xsdk
        lappend command -workspace ${TE::WORKSPACE_SDK_PATH}
        set hdffilename ""
        [catch {set hdffilename [glob -join -dir ${TE::WORKSPACE_SDK_PATH}/ *.hdf]}]
        if {[file exists ${TE::WORKSPACE_SDK_PATH}/${TE::PR_TOPLEVELNAME}.hdf]} {
          lappend command -hwspec ${TE::WORKSPACE_SDK_PATH}/${TE::PR_TOPLEVELNAME}.hdf
        } elseif {[file exists ${TE::WORKSPACE_SDK_PATH}/${TE::VPROJ_NAME}.hdf]} {
          lappend command -hwspec ${TE::WORKSPACE_SDK_PATH}/${TE::VPROJ_NAME}.hdf
        } else {
          lappend command -hwspec ${hdffilename}
        }
        # lappend command -hwspec ${TE::WORKSPACE_SDK_PATH}/${TE::VPROJ_NAME}.hdf
        # lappend command -bit ${TE::WORKSPACE_SDK_PATH}/${TE::VPROJ_NAME}.bit
        lappend command {*}$tmplist
        # lappend command --vivrun 
        puts "Info:(TE) Run \"$command\" in $TE::WORKSPACE_SDK_PATH"
        puts "Info:(TE) Please Wait.."
        set result [eval $command]
        puts "Info:(TE) Commands from batch......................................."
        puts $result
        puts ".......................................finished"
        cd $cur_path
    }
    #--------------------------------
    #--run_hsi:  
    proc run_hsi {} {
      # list 0 for table header
      if { [llength $TE::SW_APPLIST] > 1} {
        set cur_path [pwd]
        cd $TE::WORKSPACE_HSI_PATH
        set tmp_libpath [list]
        lappend tmp_libpath $TE::LIB_PATH 
        if {[file exists ${TE::XILINXGIT_DEVICETREE}]} {
          puts "Info:(TE) Include Xilinx Devicetree git clone."
          lappend tmp_libpath ${TE::XILINXGIT_DEVICETREE}
        } else {
          puts "Warning:(TE) Xilinx Devicetree git clone path not found (${TE::XILINXGIT_DEVICETREE})."
        }
        set tmp_sw_liblist [list]
        lappend tmp_sw_liblist $tmp_libpath
        set tmp_sw_applist [list]
        lappend tmp_sw_applist $TE::SW_APPLIST
        #
        set command exec
        lappend command HSI
        lappend command -source  ${TE::SCRIPT_PATH}/script_hsi.tcl
        lappend command -tclargs
        lappend command "--sw_list ${tmp_sw_applist} --lib $tmp_sw_liblist --vivrun"
        # lappend command --vivrun 
        puts "Info:(TE) Run \"$command\" in $TE::WORKSPACE_HSI_PATH"
        puts "Info:(TE) Please Wait.."
        set result [eval $command]
        puts "Info:(TE) Commands from batch......................................."
        puts $result
        puts ".......................................finished"
        cd $cur_path
        TE::UTILS::copy_sw_files
      }
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
      puts "Test: [pwd]"
      #run only if *.mmi exists
      if {[file exists  ${TE::PREBUILT_HW_PATH}/${int_shortdir}/${TE::VPROJ_NAME}.mmi]} { 
        # read processor from mmi
        set fp [open "${TE::PREBUILT_HW_PATH}/${int_shortdir}/${TE::VPROJ_NAME}.mmi" r]
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
              return -code error "Error:(TE) Found no Processor in ${TE::PREBUILT_HW_PATH}/${int_shortdir}/${TE::VPROJ_NAME}.mmi..";
            }
          }
        }
        #---------------
        foreach sw_applist_line ${TE::SW_APPLIST} {
          #generate modified mcs or bit only if app_list.csv->steps=0(generate all), add file to mcs use "FIRM"
          set app_name [lindex $sw_applist_line 1]
          if {[lindex $sw_applist_line 2] eq "0"} {
            #read app name
            #delete old one
            if {[file exists ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/${app_name}.bit]} {
              file delete -force ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/${app_name}.bit
            }
            #make folder if not exists
            file mkdir ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}
            #
            #todo:hier noch in default suche?
            puts "Info:(TE) generate ${app_name}.bit with app: ${app_name}"
            set command exec
            lappend command updatemem
            lappend command -force
            lappend command -meminfo ${TE::PREBUILT_HW_PATH}/${int_shortdir}/${TE::VPROJ_NAME}.mmi
            lappend command -data ${TE::PREBUILT_SW_PATH}/${int_shortdir}/${app_name}.elf
            lappend command -bit ${TE::PREBUILT_HW_PATH}/${int_shortdir}/${TE::VPROJ_NAME}.bit
            lappend command -proc $hitval
            lappend command -out ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/${app_name}.bit
            puts "Info:(TE) Run \"$command\" in ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}"
            puts "Info:(TE) Please Wait.."
            set result [eval $command]
            puts "Info:(TE) Commands from batch......................................."
            puts $result
            puts ".......................................finished"                 
          }
          #write mcs
          if {[lindex $sw_applist_line 2] eq "0" || [lindex $sw_applist_line 2] eq "FIRM"} {
           if {$TE::CFGMEM_MEMSIZE_MB ne "NA"} {
              #todo generate relativ path from absolute paths
            set rel_bitfile  "../prebuilt/hardware"
            set rel_bitfile2 "../prebuilt/boot_images"
            set rel_data_file ".."
              #make folder if not exists
              file mkdir ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}
              #
              puts "Info:(TE) generate ${app_name}.mcs with app: ${app_name}"
              #set bitfile to mcs load
              if {[lindex $sw_applist_line 2] eq "FIRM"} {
                set load_data "up 0x0 ${rel_bitfile}/${int_shortdir}/${TE::VPROJ_NAME}.bit "
              } else {
                set load_data "up 0x0 ${rel_bitfile2}/${int_shortdir}/${app_name}/${app_name}.bit "
              }
              #get upload data 01:
              set data_index 5
              while {$data_index < [llength $sw_applist_line] } {
                if {[lindex $sw_applist_line 5] ne "NA"} {
                  set load_data "$load_data up [lindex $sw_applist_line [expr $data_index+1]] ${rel_data_file}/[lindex $sw_applist_line $data_index] "
                }
                set data_index [expr $data_index+3]
              }
              #write mcs
              # -loadbit $load_bit 
              write_cfgmem -force -format mcs -checksum FF -interface $TE::CFGMEM_IF -size $TE::CFGMEM_MEMSIZE_MB \
              -loaddata $load_data \
              -file ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/${app_name}.mcs
            } else {
              puts "Warning:(TE) FPGAFLASHTYP not specified in *.board_files.csv. *.mcs file is not generated."
            }  
          }
        }
      } else {
        puts "Info:(TE) ${TE::PREBUILT_HW_PATH}/${int_shortdir}/${TE::VPROJ_NAME}.mmi not found. nothing done."
      }
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
      #todo generate relativ path from absolute paths
      set checkfile ""
      set fsbl_name ""
      set rel_bif_bitfile "../../../hardware"
      set rel_bif_fsbl    "../../../software"
      set rel_bif_data01_file "../../../../"
      set rel_bif_appfile "../../../"
      set bif_bitfile ""
      set bif_fsbl    ""
      set bif_date01_file ""
      set bif_appfile ""
      
      #check bitfile
      if {![file exists ${TE::PREBUILT_HW_PATH}/${int_shortdir}/${TE::VPROJ_NAME}.bit]} { 
        # search default
        if {![file exists ${TE::PREBUILT_HW_PATH}/default/${TE::VPROJ_NAME}.bit]} {
        # default  not found
          return -code error "Error:(TE) No project bit-file found (${TE::PREBUILT_HW_PATH}/${int_shortdir}/${TE::VPROJ_NAME}.bit or ${TE::PREBUILT_HW_PATH}/default/${TE::VPROJ_NAME}.bit)";
        } else {
          set bif_bitfile "${rel_bif_bitfile}/default/${TE::VPROJ_NAME}.bit"
        }
      } else {
        set bif_bitfile "${rel_bif_bitfile}/${int_shortdir}/${TE::VPROJ_NAME}.bit"
      }         
      #search for fsbl
      foreach sw_applist_line ${TE::SW_APPLIST} {
        #read fsbl name
        if {[lindex $sw_applist_line 2] eq "FSBL" || [lindex $sw_applist_line 2] eq "FSBL_EXT"} {
          set fsbl_name [lindex $sw_applist_line 1]
          if {![file exists ${TE::PREBUILT_SW_PATH}/${int_shortdir}/${fsbl_name}.elf]} { 
            # generate fsbl not found search default
            if {![file exists ${TE::PREBUILT_SW_PATH}/default/default_fsbl.elf]} {
            # default fsbl not found
              return -code error "Error:(TE) No FSBL elf-File found  (${TE::PREBUILT_SW_PATH}/${int_shortdir}/${fsbl_name}.elf or ${TE::PREBUILT_SW_PATH}/default/default_fsbl.elf)";
            } else {
              set bif_fsbl "${rel_bif_fsbl}/default/default_fsbl.elf"
              puts "Info:(TE) Use FSBL from: ${bif_fsbl}"
            }
          } else {
              set bif_fsbl "${rel_bif_fsbl}/${int_shortdir}/${fsbl_name}.elf"
              puts "Info:(TE) Use FSBL from: ${bif_fsbl}"
          }
        }
      }
      foreach sw_applist_line ${TE::SW_APPLIST} {
        #generate *.bif only if app_list.csv->steps=0(generate all) or steps=1(*.bif and *.bin use *.elf from prebuild folders )
        if {[lindex $sw_applist_line 2] eq "0" || [lindex $sw_applist_line 2] eq "1" || [lindex $sw_applist_line 2] eq "FSBL_APP"} {
          #set correct folders
          switch [lindex $sw_applist_line 3] {
              "petalinux" {
                        set checkfile "${TE::PREBUILT_OS_PATH}/petalinux"
                        set bif_appfile "${rel_bif_appfile}os/petalinux"
                          }
              default   {#standalone
                        set checkfile "${TE::PREBUILT_SW_PATH}"
                        set bif_appfile "${rel_bif_appfile}software"
                         } 
          }
          #read fsbl name
          #read app name and additional configs
          set app_name [lindex $sw_applist_line 1]
          set data01_file [lindex $sw_applist_line 5]
          set data01_load [lindex $sw_applist_line 6]
          set data01_offset [lindex $sw_applist_line 7]
          puts "Info:(TE) generate bif-file for: ${app_name}"
          #delete old folder
          if {[file exists ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}]} {
            file delete -force ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}
          }
          #make new one
          file mkdir ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}
          #replace na with ""
          if {[string match $data01_file "NA"]} { set bif_date01_file ""} else { set bif_date01_file "${rel_bif_data01_file}${data01_file}"}
          if {[string match $data01_load "NA"]} { set data01_load ""}
          if {[string match $data01_offset "NA"]} { set data01_offset ""}
          
          if {![file exists ${checkfile}/${int_shortdir}/${app_name}.elf]} { 
            if { [lindex $sw_applist_line 2] eq "FSBL_APP"} {
              # fsbl boot.bin only
              set bif_appfile ""
            } elseif {![file exists ${checkfile}/default/${app_name}.elf]} {
            # search default
            # default  not found
              return -code error "Error:(TE) No App elf-File found (${checkfile}/${int_shortdir}/${app_name}.elf or ${checkfile}/default/${app_name}.elf) ";
            } else {
              set bif_appfile "${bif_appfile}/default/${app_name}.elf"
            }
            
          } else {
            set bif_appfile "${bif_appfile}/${int_shortdir}/${app_name}.elf"
          }
          write_bif ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/boot.bif  $bif_fsbl $bif_bitfile $bif_appfile $bif_date01_file $data01_load $data01_offset "" "" ""
        }
      }
    }
    #--------------------------------
    #--write_bif:  
    proc write_bif { biffile {fsblfile "zynq_fsbl.elf"} {bitfile ""} {elffile ""} {data01_file ""} {data01_load ""} {data01_offset ""} {dtbfile ""} {intfile ""} {ssblfile ""} } {

      set bif_fp [open "$biffile" w]

      puts $bif_fp "the_ROM_image:\n\u007B"
      #
      # init data
      #
      if {$intfile!=""} { puts -nonewline $bif_fp {    [init]}}
      if {$intfile!=""} { puts $bif_fp $intfile}
      if {$intfile == ""} { puts "INT FILE NOT DEFINED..."}
      #
      # FSBL
      #
      if {$fsblfile!=""} { puts -nonewline $bif_fp {    [bootloader]}}
      if {$fsblfile!=""} { puts $bif_fp $fsblfile}
      if {$fsblfile == ""} { puts "FSBL FILE NOT DEFINED..."}
      #
      # BIT file
      #
      if {$bitfile!=""} { puts $bif_fp "    $bitfile"}
      if {$bitfile == ""} { puts "BIT FILE NOT DEFINED..."}
      #
      # .ELF file
      #
      if {$elffile!=""} { puts $bif_fp "    $elffile"}
      if {$elffile == ""} { puts "ELF FILE NOT DEFINED..."}
      #
      # SSBL
      #
      if {$ssblfile!=""} { puts $bif_fp "    $ssblfile"}
      if {$ssblfile == ""} { puts "SSBL FILE NOT DEFINED..."}
      #
      # DTB file
      #
      if {$dtbfile!=""} { puts $bif_fp "    $dtbfile"}
      if {$dtbfile == ""} { puts "DTB FILE NOT DEFINED..."}
      #
      # image.ub ore IMAGE file
      #

      if {$data01_load!="" || $data01_offset!=""} { puts -nonewline $bif_fp {    [}}
      if {$data01_load!="" } { puts -nonewline $bif_fp {load = };puts -nonewline $bif_fp "$data01_load"}
      if {$data01_load!="" && $data01_offset!=""} { puts -nonewline $bif_fp { , }}
      if {$data01_offset!="" } { puts -nonewline $bif_fp {offset = };puts -nonewline $bif_fp "$data01_offset"}
      if {$data01_load!="" || $data01_offset!=""} { puts -nonewline $bif_fp {]}}
      if {$data01_file!=""} { puts $bif_fp $data01_file}
      
      if {$data01_load == ""} { puts "FILE01 LOAD NOT DEFINED..."}
      if {$data01_offset == ""} { puts "FILE01 OFFSET NOT DEFINED..."}
      if {$data01_file == ""} { puts "FILE01 FILE NOT DEFINED..."}


      puts $bif_fp "\u007D"

      close $bif_fp

    }
    #--------------------------------
    #--generate_bootbin:  
    proc generate_bootbin {{fname ""}} {
      set int_shortdir ${TE::SHORTDIR}
      if {$fname ne ""} {
        set int_shortdir "[TE::BDEF::find_shortdir $fname]"
      }
      foreach sw_applist_line ${TE::SW_APPLIST} {
        #generate *.bin only if app_list.csv->steps=0(generate all) or steps=1(*.bif and *.bin use *.elf from prebuild folders ) or steps=2(*.bin use *.elf and *.bif from prebuild folders)
        if {[lindex $sw_applist_line 2]==0 || [lindex $sw_applist_line 2]==1 || [lindex $sw_applist_line 2]==2 || [lindex $sw_applist_line 2] eq "FSBL_APP"} {
          #read app name
          set app_name [lindex $sw_applist_line 1]
          #delete old one
          if {[file exists ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/boot.bin]} {
            file delete -force ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/boot.bin
          }
          #
          if {![file exists  ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/boot.bif]} { 
            return -code error "Error:(TE) No App bif-File found (${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/boot.bif) ";
          }
          #todo:hier noch in default suche?
          puts "Info:(TE) generate Boot.bin for app: ${app_name}"
          set cur_path [pwd]
          cd ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}
          set command exec
          lappend command bootgen
          lappend command -image boot.bif
          lappend command -w -o BOOT.bin
          # puts $command
          puts "Info:(TE) Run \"$command\" in ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}"
          puts "Info:(TE) Please Wait.."
          set result [eval $command]
          puts "Info:(TE) Commands from batch......................................."
          puts $result
          puts ".......................................finished"
          cd $cur_path          
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
      if {$fname ne ""} {
        set int_shortdir "[TE::BDEF::find_shortdir $fname]"
      }
      set applist []
      [catch {set applist [glob -join -dir ${TE::PREBUILT_BI_PATH}/${int_shortdir}/ *]}]
      puts "----------------------------"
      puts "Info:(TE) Following Apps are found for this board:"
      foreach app $applist {
        set tmp [split $app "/"]
        puts [lindex $tmp [expr [llength $tmp]-1]]
      }
      puts "----------------------------"
    }
    #--------------------------------
    #--excecute_zynq_flash_programming: 
    proc excecute_zynq_flash_programming {use_basefolder app_name {fname ""}} {
      set return_filename ""
      set int_shortdir ${TE::SHORTDIR}
      set int_flashtyp $TE::ZYNQFLASHTYP
      set run_path ""
      set bootbinname BOOT.bin
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
            puts "Info:(TE) Used file:${binfilename}"
            set return_filename ${binfilename}
            set run_path $TE::BASEFOLDER
            set nameonly [file tail [file rootname $binfilename]]
            set bootbinname ${nameonly}.bin
          } else {
            return -code error "Error:(TE) No bin-File found (${TE::BASEFOLDER}) ";
          }
          cd ${TE::BASEFOLDER}
        } else {
          if {![file exists  ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/BOOT.bin]} { 
            return -code error "Error:(TE) No App bin-File found (${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/BOOT.bin) ";
          }
          cd ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}
          set run_path ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}
          set bootbinname BOOT.bin
          puts "Info:(TE) Used file:${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/Boot.bin"
          set return_filename ${TE::PREBUILT_BI_PATH}/${int_shortdir}/${app_name}/Boot.bin
        }
        set command exec
        
        # lappend command zynq_flash
        lappend command program_flash
        lappend command -f $bootbinname
        lappend command -flash_type $int_flashtyp
        puts "Info:(TE) Run \"$command\" in ${run_path}"
        puts "Info:(TE) Please Wait.."
        set result [eval $command]
        puts "Info:(TE) Commands from batch......................................."
        puts $result
        puts ".......................................finished"
        cd $cur_path 
      } else {
        puts "Warning:(TE) Programming faild: Zynq Flash Typ is not specified for this board part. See ${TE::BOARDDEF_PATH}/..._board_files.csv"
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
    #--svn_checkin: 
    proc svn_checkin {foldername {mgs ""}} {
      set message $mgs
      if {![file exists $foldername]} { 
        set message "Error: Folder not found ( $foldername)"
      } else {
      set cur_path [pwd]
      cd ${foldername}
      set command exec
      lappend command svn
      lappend command ci
      lappend command -m $message
      puts "Info:(TE) Run $command"
      puts "Info:(TE) Please Wait.."
      set result [eval $command]
      puts "Info:(TE) Commands from batch......................................."
      puts $result
      puts ".......................................finished"
      cd $cur_path 
      }
    }    
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
        puts "Info:(TE) Run $command"
        puts "Info:(TE) Please Wait.."
        set result [eval $command]
        puts "Info:(TE) Commands from batch......................................."
        puts $result
        puts ".......................................finished"
        } else {
          "Warning:(TE) Zip not specified. set zip path and *exe of the zip program in  design_basic_settings.cmd file : example 7zip: @set ZIP_PATH=C:/Program Files (x86)/7-Zip/7z.exe"
        }
    }
    #--------------------------------
    #--zip_project: 
    proc zip_project {zipname {excludelist ""}} {
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
          puts "Info:(TE) $el not found"
        } else {
          puts "Info:(TE) Excluded from backup:$find"
          file delete -force $find
        }
      }
      set command exec
      if {${TE::ZIP_PATH} ne ""} {
        if {[file tail [file rootname ${TE::ZIP_PATH}]] eq "7z"} {
          lappend command ${TE::ZIP_PATH}
          lappend command a -tzip "$zipname.zip"
          lappend command "./${TE::VPROJ_NAME}/"
          lappend command -r 
        } else {
          lappend command ${TE::ZIP_PATH}
          lappend command -r
          lappend command "$zipname.zip"
          lappend command "./${TE::VPROJ_NAME}/*.*"
        }
        puts "Info:(TE) Run $command"
        puts "Info:(TE) Please Wait.."
        set result [eval $command]
        puts "Info:(TE) Commands from batch......................................."
        puts $result
        puts ".......................................finished"
        } else {
          "Warning:(TE) Zip not specified. set zip path and *exe of the zip program in  design_basic_settings.cmd file : example 7zip: @set ZIP_PATH=C:/Program Files (x86)/7-Zip/7z.exe"
        }
      #remove project copy
      if {[file exists ${destinationpath}]} { 
        file delete -force ${destinationpath}  
      }
      cd $cur_path
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished utilities functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # sdsoc functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--run_sdsoc: 
    proc run_sdsoc {} {
      set cur_path [pwd]
      cd ${TE::SDSOC_PATH}
      set command exec
      lappend command sdsoc 
      lappend command -workspace ${TE::SDSOC_PATH}
      # lappend command -lp ${TE::SDSOC_PATH}/${TE::VPROJ_NAME}/
      puts "Info:(TE) Run $command"
      puts "Info:(TE) Please Wait.."
      set result [eval $command]
      puts "Info:(TE) Commands from batch......................................."
      puts $result
      puts ".......................................finished"
      cd $cur_path 
    }   
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished sdsoc functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  }
  puts "Info:(TE) Load Vivado script finished"
}


