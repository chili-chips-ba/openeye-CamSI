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
# -- $Date: 2016/02/05 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2017/06/13  | $Author: Hartfiel, John
# -- - add pmuf hsi support
# ------------------------------------------
# -- $Date:  2017/09/06  | $Author: Hartfiel, John
# -- - add new document history style
# -- - add remove test printout
# ------------------------------------------
# -- $Date:  2017/10/19  | $Author: Hartfiel, John
# -- - sear processor name to get correct pmu for ce devices
# ------------------------------------------
# -- $Date:  2018/06/28  | $Author: Hartfiel, John
# -- - only documentation link and some disabled tests
# ------------------------------------------
# -- $Date:  2018/07/04  | $Author: Hartfiel, John
# -- - modify ZynqMP compiler variables for 2018.2 
# ------------------------------------------
# -- $Date:  2018/07/11  | $Author: Hartfiel, John
# -- - small bugfix
# ------------------------------------------
# -- $Date:  2019/01/30  | $Author: Hartfiel, John
# -- - include settings.h and applist 
# ------------------------------------------
# -- $Date:  2019/02/19  | $Author: Hartfiel, John
# -- - removed compiler Flags for 2018.2 FSBL BUG
# ------------------------------------------
# -- $Date:  2019/05/2  | $Author: Hartfiel, John
# -- - create also FSBL_APP
# ------------------------------------------
# -- $Date:  2020/02/25  | $Author: Hartfiel, John
# -- - obsolete file replace  with vitis tcl
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# HSI documentation Xilinx(change url to correct version):
# - https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_2/ug1138-generating-basic-software-platforms.pdf
# --------------------------------------------------------------------
namespace eval ::TE {
  namespace eval HSI {
    # set setpath ../../scripts/script_settings.tcl
    # source $setpath
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # TE HSI variablen declaration
    # # -----------------------------------------------------------------------------------------------------------------------------------------
   # # puts "Test ${TE::SDEF::ID}"
    # variable HDF_NAME
    # variable LIB_PATH
    # variable SW_APPLIST
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # finished TE HSI variablen declaration
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # hsi hw functions
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # #--------------------------------
    # #--open_project: 
    # proc open_project {} {
      # if {[catch {set TE::HSI::HDF_NAME [glob -join -dir [pwd] *.hdf]} result]} { puts "Error:(TE) Script (TE::HSI::hsi_open_project) failed: $result."; return -code error}
      # #todo: eventuell mal extra verzeichnis erstellen, wie sdk
      # open_hw_design ${TE::HSI::HDF_NAME}
    # }
    # #--------------------------------
    # #--set_repopath: 
    # proc set_repopath {} {
      # set_repo_path ${TE::HSI::LIB_PATH}
    # } 
    # #--------------------------------
    # #--close_project: 
    # proc close_project {} {
      # close_hw_design [current_hw_design]
    # }  
    # #--------------------------------
    # #--get_processors:  
    # proc get_processor_id {name} {
      # set proc [get_cells  -filter {IP_TYPE==PROCESSOR}]
      # set p_id -1
      # set cnt 0
      # foreach s_proc $proc {
        # if {[string match *$name* $s_proc ]} {set p_id $cnt}
        # set cnt [expr $cnt+1]
      # }
      # if {$p_id == -1} {
        # return -code error "Error:(TE) No Processor with \"$name\" found in design ${TE::HSI::HDF_NAME}";
      # } else {
        # return $p_id
      # }
    # }
    # #--------------------------------
    # #--get_processors:
    # proc get_processors {PROCESSOR_ID} {
      # set proc [get_cells  -filter {IP_TYPE==PROCESSOR}]
      # if {[llength $proc] == 0} {
        # return -code error "Error:(TE) No Processor found in design ${TE::HSI::HDF_NAME}";
      # } else {
        # if {[llength $proc] > 1} {
          # puts "Info:(TE) Multiple Processors found."
        # }
        # if {[llength $proc] > $PROCESSOR_ID} {
          # puts "Info:(TE)  Processor [lindex $proc $PROCESSOR_ID] is used."
          # return [lindex $proc $PROCESSOR_ID]
        # } else {
          # return -code error "Error:(TE) Processor ID $PROCESSOR_ID not found in design ${TE::HSI::HDF_NAME}";
        # }
      # }
    # }
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # finished hw functions
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # hsi sw functions
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # #--------------------------------
    # #--create_sw_project: 
    # proc create_sw_project {app_name os uart {proc_id 0} {compilerflag NA}} {
      # set cpu [get_processors $proc_id]
      # set hwdesign [current_hw_design]
      # set swdesign [hsi::create_sw_design system -proc $cpu -app $app_name -os $os]
      # set os [hsi::get_os]

      # generate_app -hw $hwdesign -sw $swdesign -app $app_name -proc $cpu -dir $app_name -os $os
      # hsi::close_sw_design $swdesign
      # hsi::open_sw_design ${app_name}/${app_name}_bsp/system.mss
      # #reset old variables
      # set swdesign [get_sw_designs]
      # set os [hsi::get_os]
      # #set uart properties
      # if {$uart ne "NA"} {
        # #workaround to change uart -> currently generate_app will delete bsp and write default one
        # puts "Info:(TE) change UART to $uart"
        # common::set_property CONFIG.stdin $uart $os
        # common::set_property CONFIG.stdout $uart $os
      # }

      # #generate bsp
      # # common::report_property [hsi::get_sw_processor]
      # hsi::generate_bsp -dir ${app_name}/${app_name}_bsp/ -compile
      # cd ${app_name}
      # set result ""

      # set fileID [open "Makefile" r] 
      # set tmpwrite [open "tmp_file" w+] 
      # while {[eof $fileID] != 1} { 
          # gets $fileID lineInfo 
        
          # set temp $lineInfo
          # set temp2 $temp
          
          
          # # #modify CC flags for ZynyMP(FSBL bug with 18.2)
          # # if { ( $app_name eq "zynqmp_fsbl"  || $app_name eq "zynqmp_fsbl_flash" ) && [common::get_property  APP_COMPILER $swdesign] eq "aarch64-none-elf-gcc"} {
            # # if { [string match "*CC_FLAGS :=*" ${temp}] } {
              # # puts "Info:(TE) remove compiler flags \"-Os -flto -ffat-lto-objects\" from Makefile (18.2 bug with FSBL)"
              # # set temp2 [string map {"-Os -flto -ffat-lto-objects" ""} $temp ]
            # # }
          # # }
          # if {$compilerflag ne "NA"} {
            # if { [string match "*CFLAGS :=*" ${temp}] } {
              # puts "Info:(TE) add additional compiler flags $compilerflag (Beata Version, not flags all works)"
              # set temp2 "$temp2 $compilerflag"
            # }
          # }
          # # puts "Test: $temp2 "
          # puts $tmpwrite $temp2 
      # } 
      # close $fileID
      # close $tmpwrite

      # file delete -force Makefile 
      # file rename -force "tmp_file" Makefile
        
      # #run make
      # if {[catch {set result [eval exec make]}]} {puts "Info:(TE) $result"}
      # # set result [eval exec make]
      # # puts "Info:(TE) $result"
      # cd ..
      # close_sw_design $swdesign
    # }  
    # #--------------------------------
    # #--create_devicetree_project: 
    # proc create_devicetree_project {app_name os} {
      # set cpu [get_processors 0]
      # set hwdesign [current_hw_design]
      # set swdesign [hsi::create_sw_design $app_name -proc $cpu -os $os]
      # generate_target -dir $app_name
      # close_sw_design $swdesign
    # }  
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # finished sw functions
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # hsi run functions
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # #--------------------------------
    # #--run_sw_apps: 
    # proc run_sw_apps {} {
      # #search and generate fsbl and device tree
      # foreach sw_applist_line ${TE::HSI::SW_APPLIST} {
        # #generate fsbl only
        # if {[lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "FSBL" || [lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "FSBL_APP" } {
          # set name [lindex $sw_applist_line ${TE::SDEF::APPNAME}]
          # set os [lindex $sw_applist_line ${TE::SDEF::OSNAME}]
          # set uart [lindex $sw_applist_line ${TE::SDEF::UART}]
          # set compilerflag [lindex $sw_applist_line ${TE::SDEF::CFLAGS}]
          # set proc_id 0
          # puts "Info:(TE) generate FSBL: $name os: $os Uart: $uart Processor ID: $proc_id Additional Compiler Flags(Beta): $compilerflag "
          # create_sw_project $name $os $uart $proc_id $compilerflag 
        # }
        # #generate pmu UynqMP only
        # if {[lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "PMU" } {
          # set name [lindex $sw_applist_line ${TE::SDEF::APPNAME}]
          # set os [lindex $sw_applist_line ${TE::SDEF::OSNAME}]
          # set uart [lindex $sw_applist_line ${TE::SDEF::UART}]
          # set compilerflag [lindex $sw_applist_line ${TE::SDEF::CFLAGS}]
          # #select pmu 
          # set proc_id [get_processor_id pmu]
          # puts "Info:(TE) generate PMU: $name os: $os Uart: $uart ID: $proc_id Additional Compiler Flags(Beta): $compilerflag "
          # create_sw_project $name $os $uart $proc_id $compilerflag 
        # }
        # #generate device tree only
        # if {[lindex $sw_applist_line ${TE::SDEF::STEPS}] eq "DTS" } {
          # set name [lindex $sw_applist_line ${TE::SDEF::APPNAME}]
          # set os [lindex $sw_applist_line ${TE::SDEF::OSNAME}]
          # puts "Info:(TE) generate Device-Tree: $name os: $os"
          # create_devicetree_project $name $os
        # }
      # }
      # #search and generate software apps
      # foreach sw_applist_line ${TE::HSI::SW_APPLIST} {
        # #generate *.bin only if app_list.csv->steps=0(generate all) or steps=3(*.elf only )
        # if {[lindex $sw_applist_line ${TE::SDEF::STEPS}] == 0 || [lindex $sw_applist_line ${TE::SDEF::STEPS}] == 3} {
          # set name [lindex $sw_applist_line ${TE::SDEF::APPNAME}]
          # set os [lindex $sw_applist_line ${TE::SDEF::OSNAME}]
          # set uart [lindex $sw_applist_line ${TE::SDEF::UART}]
          # set compilerflag [lindex $sw_applist_line ${TE::SDEF::CFLAGS}]
          # set proc_id 0
          # puts "Info:(TE) generate app: $name os: $os Uart: $uart Additional Compiler Flags(Beta): $compilerflag "
          # create_sw_project $name $os $uart $proc_id $compilerflag 
        # }
      # }
    # }
    # #--------------------------------
    # #--debug_sw_app_list:
    # proc debug_sw_app_list {} {
      # set TE::HSI::SW_APPLIST [list]
      # foreach lpath ${TE::HSI::LIB_PATH} {
        # if {[file exists  ${lpath}/apps_list.csv]} { 
          # puts "Info:(TE) Read Software list from ${lpath}/apps_list.csv"
          # set fp [open "${lpath}/apps_list.csv" r]
          # set file_data [read $fp]
          # close $fp
          # set data [split $file_data "\n"]
          # # set fsbl_name ""
          # foreach line $data {
            # #  check file version ignore comments and empty lines
            # if {[string match *#* $line] != 1 && [string match *CSV_VERSION* $line] } {
              # #remove spaces
              # set line [string map {" " ""} $line]
              # #remove tabs
              # set line [string map {"\t" ""} $line]
              # #check version
              # set tmp [split $line "="]
              # #version is ignored for debug only
            # } elseif {[string match *#* $line] != 1 && [string length $line] > 0} {
              # #remove spaces
              # set line [string map {" " ""} $line]
              # #remove tabs
              # set line [string map {"\t" ""} $line]
              # #splitt and append
              # set tmp [split $line ","]
              # lappend TE::HSI::SW_APPLIST $tmp
            # }
          # }
        # }
      # }
      # puts "------------------------------------------"
    # }
    # #--------------------------------
    # #--run_all:
    # proc run_all {} {
      # #todo: run all als option und hsi auch über batch separat startbar
      # puts "Info:(TE) HSI...run all..."
      # if {[catch {open_project} result]} { puts "Error:(TE) Script (TE::HSI::open_project) failed: $result.";  return -code error}
      # if {[catch {set_repopath} result]} { puts "Error:(TE) Script (TE::HSI::set_repopath) failed: $result.";  return -code error}
      # #----------------------------------------
      # if {[catch {run_sw_apps} result]} { puts "Error:(TE) Script (TE::HSI::run_sw_apps) failed: $result.";  return -code error}
      # #----------------------------------------
      # if {[catch {close_project} result]} { puts "Error:(TE) Script (TE::HSI::close_project) failed: $result.";  return -code error}
    # }
    # #--------------------------------
    # #--return_option: 
    # proc return_option {option argc argv} {
      # if { $argc <= [expr $option + 1]} { 
        # return -code error "Error:(TE) Read parameter failed"
      # } else {  
        # puts "Info:(TE) Parameter Option Value: [lindex $argv [expr $option + 1]]"
        # return [lindex $argv [expr $option + 1]]
      # }
    # }    
    # #--------------------------------
    # #--hsi_main: 
    # proc hsi_main {} {
      # global argc
      # global argv
      # set tmp_argc 0
      # set tmp_argv 0
      # if {$argc >= 1 } {
        # set tmp_argv [lindex $argv 0]
        # set tmp_argc [llength $tmp_argv]
      # }
      
      # set vivrun false
      # variable SW_APPLIST 
      # variable LIB_PATH 

      # for {set option 0} {$option < $tmp_argc} {incr option} {
        # puts "Info:(TE) Parameter Index: $option"
        # puts "Info:(TE) Parameter Option: [lindex $tmp_argv $option]"
        # switch [lindex $tmp_argv $option] {
          # "--sw_list"	        { set SW_APPLIST [return_option $option $tmp_argc $tmp_argv];incr option }    
          # "--lib"	            { set LIB_PATH [return_option $option $tmp_argc $tmp_argv];incr option }    
          # "--vivrun"		      { set vivrun true }
          # default             { puts "" }
        # }
      # }
      # if {$vivrun==true} {
        # if {[catch {run_all} result]} { puts "Error:(TE) Script (TE::HSI::run_all) failed: $result."; exit}
        # exit
      # }

    # }
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # finished run functions
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # hsi run scripts
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # if {[catch {hsi_main} result]} { puts "Error:(TE) Script (TE::HSI::hsi_main) failed: $result."; exit}
    # # -----------------------------------------------------------------------------------------------------------------------------------------
    # # finished hsi run scripts
    # # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  # # # -----------------------------------------------------------------------------------------------------------------------------------------
  }
 puts "Info: Load HSI scripts finished"
}


