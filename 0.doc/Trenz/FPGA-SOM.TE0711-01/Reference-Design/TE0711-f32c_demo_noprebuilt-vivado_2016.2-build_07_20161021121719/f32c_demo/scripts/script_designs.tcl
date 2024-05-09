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
# --$Create Date:2016/02/04 $
# --$Modify Autor: Hartfiel, John $
# --$Modify Date: 2016/06/09 $
# --------------------------------------------------------------------
# --------------------------------------------------------------------
namespace eval TE {
  namespace eval INIT {
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # initial functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--basic_inits: initial some variables and list 
    proc basic_inits {} {
      if {[catch {TE::INIT::print_version} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::print_version) failed: $result."; return -code error}
      if {[catch {TE::INIT::print_environment_settings} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::print_environment_settings) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_pathvar} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::init_pathvar) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_boardlist} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::init_boardlist) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_app_list} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::init_app_list) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_zip_ignore_list} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::init_zip_ignore_list) failed: $result."; return -code error}
      if {[catch {TE::INIT::init_mod_list} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::init_mod_list) failed: $result."; return -code error}
      if {[file exists ${TE::SET_PATH}/development_settings.tcl]} {
        puts "Info:(TE) Source development_settings.tcl"
        if {[catch {source ${TE::SET_PATH}/development_settings.tcl} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::source) failed: $result."; return -code error}
      }
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished initial functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # cmd functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--run_te_procedure: run tcl Function from cmd file
    proc run_te_procedure {TCL_PROCEDURE BOARD} {
      puts "Info:(TE) Run TE::INIT::run_te_procedure ..."
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      #Attenten not all Procedures can start directly from shell
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {[catch {init_board [TE::BDEF::find_id $BOARD] 0} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::init_board /[TE::BDEF::find_id/]) failed: $result."; return -code error}
      if {[catch {eval $TCL_PROCEDURE} result]} {abort_status "Error Run TE-TCLProcedure from batch file..."; create_allboardfiles_status; puts "Error:(TE) Script (${TCL_PROCEDURE}) failed: $result."; return -code error}
    }
    #--------------------------------
    #--clear_project_all:todo:use run_te_procedure
    proc clear_project_all {} {
      puts "Info:(TE) Run TE::INIT::clear_project_all ..."
      # if {[catch {TE::INIT::print_version} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::print_version) failed: $result."; return -code error}
      # if {[catch {TE::INIT::init_pathvar} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::init_pathvar) failed: $result."; return -code error}
      if {[catch {TE::UTILS::clean_all_generated_files} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::UTILS::clean_all_generated_files) failed: $result."; return -code error}
    }
    #--------------------------------
    #--run_labtools:todo:use run_te_procedure
    proc run_labtools {BOARD} {
      puts "Info:(TE) Run TE::INIT::run_labtools ..."
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {[catch {init_board [TE::BDEF::find_id $BOARD] 0} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::init_board /[TE::BDEF::find_id/]) failed: $result."; return -code error}
      if {[catch {TE::INIT::generate_labtools_project GUI} result]} {abort_status "Error Generate LabTools Project..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::generate_labtools_project) failed: $result."; return -code error}
    }
    #--------------------------------
    #--program_zynq_bin:
    proc program_zynq_bin {USE_BASEFOLDER BOARD SWAPP LABTOOLS} {
      puts "Info:(TE) Run TE::INIT::program_zynq_bin ..."
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      set return_filename ""
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {$LABTOOLS} {
        if {[catch {TE::INIT::generate_labtools_project} result]} {abort_status "Error Generate LabTools Project..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::generate_labtools_project) failed: $result."; return -code error}
        if {$USE_BASEFOLDER} {
          if {[catch {set return_filename [TE::pr_program_flash_binfile -used_board $BOARD -swapp $SWAPP -used_basefolder_binfile]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_flash_binfile) failed: $result."; return -code error}
        } else {
          if {[catch {set return_filename [TE::pr_program_flash_binfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_flash_binfile) failed: $result."; return -code error}
        }
      } else {
        #dummi project need for jtag reboot memory
        set curpath [pwd]
        if {[catch {TE::INIT::generate_dummi_project} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::generate_dummi_project) failed: $result."; return -code error}
        if {$USE_BASEFOLDER} {
          if {[catch {set return_filename [TE::pr_program_flash_binfile -used_board $BOARD -swapp $SWAPP -used_basefolder_binfile]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_flash_binfile) failed: $result."; return -code error}
        } else {
          if {[catch {set return_filename [TE::pr_program_flash_binfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_flash_binfile) failed: $result."; return -code error}
        }
        if {[catch {TE::INIT::delete_dummi_project $curpath} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::delete_dummi_project) failed: $result."; return -code error}
      }
      puts "-----------------------------------------"
      puts "-----------------------------------------"
      puts "Info:(TE) Programming Flash with $return_filename"
      puts "Info:(TE) Programming Flash finished without Error."
      puts "-----------------------------------------"
    }
    #--------------------------------
    #--program_fpga_mcs:
    proc program_fpga_mcs {USE_BASEFOLDER BOARD SWAPP LABTOOLS} {
      puts "Info:(TE) Run TE::INIT::program_fpga_mcs ..."
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      set return_filename ""
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {$LABTOOLS} {
        if {[catch {TE::INIT::generate_labtools_project} result]} {abort_status "Error Generate LabTools Project..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::generate_labtools_project) failed: $result."; return -code error}
        if {$USE_BASEFOLDER} {
          if {[catch {set return_filename [TE::pr_program_flash_mcsfile -used_board $BOARD -swapp $SWAPP -used_basefolder_mcsfile]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_flash_mcsfile) failed: $result."; return -code error}
        } else {
          if {[catch {set return_filename [TE::pr_program_flash_mcsfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_flash_mcsfile) failed: $result."; return -code error}
        }
      } else {
        #dummi project need for jtag reboot memory
        set curpath [pwd]
        if {[catch {TE::INIT::generate_dummi_project} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::generate_dummi_project) failed: $result."; return -code error}
        if {$USE_BASEFOLDER} {
          if {[catch {set return_filename [TE::pr_program_flash_mcsfile -used_board $BOARD -swapp $SWAPP -used_basefolder_mcsfile]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_flash_mcsfile) failed: $result."; return -code error}
        } else {
          if {[catch {set return_filename [TE::pr_program_flash_mcsfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Zynq Flash configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_flash_mcsfile) failed: $result."; return -code error}
        }
        if {[catch {TE::INIT::delete_dummi_project $curpath} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::delete_dummi_project) failed: $result."; return -code error}
      }
      puts "-----------------------------------------"
      puts "-----------------------------------------"
      puts "Info:(TE) Programming Flash with $return_filename"
      puts "Info:(TE) Programming Flash finished without Error."
      puts "-----------------------------------------"
    }
    #--------------------------------
    #--program_fpga_bit:
    proc program_fpga_bit {USE_BASEFOLDER BOARD SWAPP LABTOOLS} {
      puts "Info:(TE) Run TE::INIT::program_fpga_bit ..."
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      set return_filename ""
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {$LABTOOLS} {
        if {[catch {TE::INIT::generate_labtools_project} result]} {abort_status "Error Generate LabTools Project..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::generate_labtools_project) failed: $result."; return -code error}
          if {$USE_BASEFOLDER} {
            if {[catch {set return_filename [TE::pr_program_jtag_bitfile -used_board $BOARD -swapp $SWAPP -used_basefolder_bitfile]} result]} {abort_status "Error external Bitfile configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_jtag_bitfile) failed: $result."; return -code error}
          } else {
            if {[catch {set return_filename [TE::pr_program_jtag_bitfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Bitfile configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_jtag_bitfile) failed: $result."; return -code error}
          }
        } else {
        #dummi project need for jtag reboot memory
        set curpath [pwd]
        if {[catch {TE::INIT::generate_dummi_project} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::generate_dummi_project) failed: $result."; return -code error}
          if {$USE_BASEFOLDER} {
            if {[catch {set return_filename [TE::pr_program_jtag_bitfile -used_board $BOARD -swapp $SWAPP -used_basefolder_bitfile]} result]} {abort_status "Error external Bitfile configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_jtag_bitfile) failed: $result."; return -code error}
          } else {
            if {[catch {set return_filename [TE::pr_program_jtag_bitfile -used_board $BOARD -swapp $SWAPP]} result]} {abort_status "Error external Bitfile configuration..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::pr_program_jtag_bitfile) failed: $result."; return -code error}
          }
        if {[catch {TE::INIT::delete_dummi_project $curpath} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::delete_dummi_project) failed: $result."; return -code error}
      }
      puts "-----------------------------------------"
      puts "-----------------------------------------"
      puts "Info:(TE) Programming FPGA with $return_filename"
      puts "Info:(TE) Programming FPGA finished without Error."
      puts "-----------------------------------------"
    }
    #--------------------------------
    #--run_sdk:
    proc run_sdk {BOARD} {
      puts "Info:(TE) Run TE::INIT::run_sdk ..."
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::basic_inits) failed: $result."; return -code error}
      if {[catch {TE::sw_run_sdk -prebuilt_hdf $BOARD} result]} {abort_status "Error external SDK starting..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::sw_run_sdk) failed: $result."; return -code error}
    }
    #--------------------------------
    #--run_project: VIVADO project
    proc run_project {BOARD RUN GUI CLEAN} {
      puts "Info:(TE) Run TE::INIT::run_project ..."
      #--
      if {[catch {TE::INIT::remove_status_files} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::remove_status_files) failed: $result."; return -code error}
      #--
      if {[catch {TE::INIT::basic_inits} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::basic_inits) failed: $result."; return -code error}

      switch $CLEAN {
        0 {}
        1 {
            if {[catch {TE::UTILS::clean_vivado_project} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::UTILS::clean_vivado_project) failed: $result."; return -code error}
          }
        2 {
            if {[catch {TE::UTILS::clean_vivado_project} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::UTILS::clean_vivado_project) failed: $result."; return -code error}
            if {[catch {TE::UTILS::clean_workspace_hsi} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::UTILS::clean_workspace_hsi) failed: $result."; return -code error}
          }
        3 {
            if {[catch {TE::UTILS::clean_all_generated_files} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::UTILS::clean_all_generated_files) failed: $result."; return -code error}
          }
        4 {
            if {[catch {TE::UTILS::clean_all_generated_files;TE::UTILS::clean_prebuilt_all} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::UTILS::clean_all_generated_files or TE::UTILS::clean_prebuilt_all) failed: $result."; return -code error}
          }
        default {abort_status "Error Initialisation..."; create_allboardfiles_status; return -code error "Error: Design clean option $CLEAN not available, use [show_help]";}
      }
      if {$RUN > 0 } {
        if {[catch {init_board [TE::BDEF::find_id $BOARD] 0} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::init_board /[TE::BDEF::find_id/]) failed: $result."; return -code error}
      }
      switch $RUN {
        -1 {puts "Info:(TE) Clear only Mode selected..."}
        0 {start_existing_project $GUI }
        1 {generate_single_project $GUI }
        2 {generate_single_project_all $GUI }
        3 {generate_board_file_project_all $GUI }
        default {abort_status "Error Initialisation..."; create_allboardfiles_status; return -code error "Error: Design run option $OPT not available, use [show_help]";}
      }
      puts "-----------------------------------------"
      puts "-----------------------------------------"
      puts "Info:(TE) Run project finished without Error."
      puts "-----------------------------------------"
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished cmd functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # project design functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--generate_dummi_project: for external programming without labtools and sdk only 
    proc generate_dummi_project {} {
      file mkdir $TE::VPROJ_PATH/tmp 
      cd $TE::VPROJ_PATH/tmp 
      puts "Info:(TE) Create temporary vivado project in: [pwd]"
      ::create_project -force tmp $TE::VPROJ_PATH/tmp 
    }  
    #--------------------------------
    #--delete_dummi_project: for external programming without labtools and sdk only 
    proc delete_dummi_project {oldpath} {
      ::close_project
      puts "Info:(TE) Delete temporary vivado project in: [pwd]"
      cd $oldpath
      if {[catch {file delete -force -- $TE::VPROJ_PATH/tmp} result ]} {      
        # somtimes is locked from other process
        # puts "Info:(TE) Can't delete temporary folder."
      }
    }
    #--------------------------------
    #--start_existing_project: 
    proc start_existing_project {GUI} {
      if { [file exists $TE::VPROJ_PATH] } { 
        cd  $TE::VPROJ_PATH
        if { [file exists ${TE::VPROJ_NAME}.xpr] } { 
          puts "Info:(TE) open existing project: ${TE::VPROJ_PATH}/${TE::VPROJ_NAME}.xpr"
          if {[catch {TE::VIV::open_project} result]} { puts "Error:(TE) Script (TE::VIV::open_project) failed: $result."; return -code error}
          if {$GUI >= 1} {start_gui}
        } else {
            return -code error "Error: $TE::VPROJ_NAME.xpr not found in [pwd]";
          }
      } else {
        return -code error "Error: ${TE::VPROJ_PATH}/$TE::VPROJ_NAME.xpr not found";
      }	
      #---------------------------------------------
    }
    #--------------------------------
    #--generate_single_project: 
    proc generate_single_project {GUI } {
      if { [file exists $TE::VPROJ_PATH] } { 
        cd  $TE::VPROJ_PATH
        if { [file exists *.xpr] } { 
          return -code error "Error: Project folder not empty, clear [pwd]";
        }
      } else {
       puts "Info:(TE) Generate new project folder: $TE::VPROJ_PATH"
       file mkdir $TE::VPROJ_PATH
       cd  $TE::VPROJ_PATH
       if {[catch {TE::VIV::create_project} result]} { puts "Error:(TE) Script (TE::VIV::create_project) failed: $result."; return -code error}
        if {$GUI == 1} { start_gui }
        if {[catch {TE::VIV::import_design} result]} { puts "Error:(TE) Script (TE::VIV::import_design) failed: $result."; return -code error}
        if {$GUI == 2} { start_gui }
      }	
    }
    #--------------------------------
    #--generate_single_project_all: 
    proc generate_single_project_all {GUI} {
      if {$GUI == 1} { generate_single_project 1 } else {generate_single_project 0 }
      #--------------------------------------------------------
      run_current_project_all
      #--------------------------------------------------------
      if {$GUI == 2} { start_gui}
    }
    #--------------------------------
    #--generate_board_file_project_all: 
    proc generate_board_file_project_all {GUI} {
      foreach sublist $TE::BDEF::BOARD_DEFINITION {
        set id [lindex $sublist 0]
        if {$id ne "ID"} {
          puts "-----------------------------------------------"
          puts "-----------------------------------------------"
          puts "Info:(TE) run boardfile $id--"
          puts "Info:(TE) Path: [pwd]"
          puts "-----------------------------------------------"
          if {[catch {TE::UTILS::clean_vivado_project} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::UTILS::clean_vivado_project) failed: $result."; return -code error}
          if {[catch {TE::UTILS::clean_workspace_hsi} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::UTILS::clean_workspace_hsi) failed: $result."; return -code error}
          if {[catch {init_board $id 0} result]} {abort_status "Error Initialisation..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::init_board) failed: $result."; return -code error}
          if {[catch {generate_single_project_all  0} result]} {abort_status "Error generate projects..."; create_allboardfiles_status; puts "Error:(TE) Script (TE::INIT::generate_single_project_all) failed: $result."; return -code error}
           
          TE::VIV::close_project
        }
      }
      create_allboardfiles_status
    }
    #--------------------------------
    #--run_current_project_all: 
    proc run_current_project_all {} {
      # if {[catch {TE::VIV::build_design ${TE::GEN_HW_BIT} ${TE::GEN_HW_MCS} ${TE::GEN_HW_RPT}} result]} {TE::VIV::report_summary;set emessage "Error:(TE) Script (TE::VIV::build_design) failed: $result."; abort_status $emessage; puts $emessage; return -code error}
      set hw_options [list]
      if {!${TE::GEN_HW_BIT}} {lappend hw_options "-disable_bitgen"; puts "Warning:(TE) Auto-generation Bit-file generation disabled."}
      if {!${TE::GEN_HW_RPT}} {lappend hw_options "-disable_reports"; puts "Warning:(TE) Auto-generation report-file generation disabled."}
      if {!${TE::GEN_HW_HDF}} {lappend hw_options "-disable_hdf"; puts "Warning:(TE) Auto-generation Bit-file generation disabled."}
      if {!${TE::GEN_HW_MCS}} {lappend hw_options "-disable_mcsgen"; puts "Warning:(TE) Auto-generation MCS-file generation disabled."}
      if {[catch {eval TE::hw_build_design ${hw_options}} result]} {TE::VIV::report_summary;set emessage "Error:(TE) Script (TE::hw_build_design) failed: $result."; abort_status $emessage; puts $emessage; return -code error}
      #----------------------------------------------------------
      set sw_options [list]
      if {!${TE::GEN_SW_HSI}}     {lappend sw_options "-no_hsi"; puts "Warning:(TE) Auto-generation HSI generation disabled."}
      if {!${TE::GEN_SW_BIF}}     {lappend sw_options "-no_bif"; puts "Warning:(TE) Auto-generation bif-file generation disabled."}
      if {!${TE::GEN_SW_BIN}}     {lappend sw_options "-no_bin"; puts "Warning:(TE) Auto-generation bin-file generation disabled."}
      if {!${TE::GEN_SW_BITMCS}}  {lappend sw_options "-no_bitmcs"; puts "Warning:(TE) Auto-generation Bit-file, MCS-file generation disabled."}
      if {${TE::GEN_SW_USEPREBULTHDF}}  {lappend sw_options "-prebuilt_hdf_only"; lappend sw_options "$TE::SHORTDIR"; puts "Warning:(TE) Prebuilt HDF is used."}
      if {${TE::GEN_SW_FORCEBOOTGEN}}  {lappend sw_options "-force_bin"; puts "Warning:(TE) Force Boot.bin is used."}
      lappend sw_options "-clear"
      if {[catch {eval TE::sw_run_hsi ${sw_options}} result]} { set emessage "Error:(TE) Script (TE::sw_run_hsi) failed: $result."; abort_status $emessage; puts $emessage; return -code error}
      abort_status "Ok"
    }
    #--------------------------------
    #--generate_labtools_project: 
    proc generate_labtools_project { {gui ""} } {
      if { [file exists $TE::VLABPROJ_PATH] } { 
        cd  $TE::VLABPROJ_PATH
        if { [file exists ${TE::VPROJ_NAME}.lpr] } { 
          if {[catch {TE::VLAB::open_project} result]} { puts "Error:(TE) Script (TE::VLAB::open_project) failed: $result."; return -code error}
        } else {
          if {[catch {TE::VLAB::create_project} result]} { puts "Error:(TE) Script (TE::VLAB::create_project) failed: $result."; return -code error}
        }
      } else {
       puts "Info:(TE) generate new project folder: $TE::VLABPROJ_PATH"
       file mkdir $TE::VLABPROJ_PATH
       cd  $TE::VLABPROJ_PATH
       if {[catch {TE::VLAB::create_project} result]} { puts "Error:(TE) Script (TE::VLAB::create_project) failed: $result."; return -code error}
      }	
      if {$gui ne ""} {
        start_gui
      }
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished project design functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # status files functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--remove_status_files: 
    proc remove_status_files {} {
      if { [file exists ${TE::LOG_PATH}/allboardparts.txt] } {
        file delete -force ${TE::LOG_PATH}/allboardparts.txt
      }
      if { [file exists ${TE::LOG_PATH}/status.txt] } {
        file delete -force ${TE::LOG_PATH}/status.txt
      }
    }
    #--------------------------------
    #--create_allboardfiles_status: 
    proc create_allboardfiles_status {} {
      set report_file ${TE::LOG_PATH}/allboardparts.txt
      set fp_w [open ${report_file} "w"]
      puts $fp_w "it's generate only for powershell polling..."
      close $fp_w
    }
    #--------------------------------
    #--abort_status: 
    proc abort_status {message} {
      set report_file ${TE::LOG_PATH}/status.txt

      if { ![file exists ${report_file}]} {
        set fp_w [open ${report_file} "w"]
        puts $fp_w "Run ${TE::BOARDPART} with Status $message"
        close $fp_w
      } else {
        set fp_a [open ${report_file} "a"]
        puts $fp_a "Run ${TE::BOARDPART} with Status $message"
        close $fp_a
      }
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished status files functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  }
  puts "Info:(TE) Load Designs script finished"
}


