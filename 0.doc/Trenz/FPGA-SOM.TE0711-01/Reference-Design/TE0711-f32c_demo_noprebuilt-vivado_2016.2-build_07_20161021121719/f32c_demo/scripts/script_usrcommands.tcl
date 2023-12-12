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
# --$Create Date:2016/02/16 $
# --$Modify Autor: Hartfiel, John $
# --$Modify Date: 2016/09/21 $
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# source in namespace of TE
namespace eval TE {
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # help functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  #--------------------------------
  #--help: 
  proc help {{args ""}} {
    set run_help false
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-help"		    { set run_help true; incr option }
          default    { puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    }
    if {$run_help} {
      puts "Description:\n\
            Display currently available user functions\n\
            "
      puts "Syntax:\n\
            help \[-help\]\n\
            "
      puts "Returns:\n\
              No return value.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-help\]     print help\n\
            "
      puts "Categories:\n \
            TE\n\
            "
    } else {
      TE::INIT::print_version
      puts "------------------------------------------"
      puts "Info:(TE) Available TE-Functions:"
      if {![catch {set projectname [get_projects]} result]} {
        puts "  ---------------------------------"
        puts "  Beta Test (advanced usage only!):"
        puts "    TE::ADV::beta_util_sdsoc_project \[-check_only\] \[-start_sdsoc\] \[-help\]"
        puts "    TE::ADV::beta_hw_remove_board_part \[-permanent\] \[-help\]"
        puts "    TE::ADV::beta_hw_export_rtl_ip \[-help\]"
      }
      puts "  ----------"
      puts "  Utilities:"
      puts "    TE::util_zip_project \[-save_all\] \[-remove_prebuilt\] \[-manual_filename <arg>\] \[-help\]"
      puts "  ------------"
      puts "  Programming:"
      puts "    TE::pr_init_hardware_manager \[-help\]"
      puts "    TE::pr_program_jtag_bitfile \[-used_board <arg>\] \[-swapp <arg>\] \[-available_apps\] \[-used_basefolder_bitfile\] \[-help\]"
      puts "    TE::pr_program_flash_binfile \[-no_reboot\] \[-used_board <arg>\] \[-swapp <arg>\] \[-available_apps\] \[-force_hw_manager\] \[-used_basefolder_binfile\] \[-help\]"
      puts "    TE::pr_program_flash_mcsfile \[-no_reboot\] \[-used_board <arg>\] \[-swapp <arg>\] \[-available_apps\] \[-used_basefolder_mcsfile\] \[-help\]"
      if {![catch {set projectname [get_projects]} result]} {
        # on vivado project
        puts "  ----------------"
        puts "  Software Design:"
        puts "    TE::sw_run_hsi \[-run_only\] \[-prebuilt_hdf <arg>\] \[-no_hsi\] \[-no_bif\] \[-no_bin\] \[-no_bitmcs\] \[-force_bin\]  \[-clear\] \[-help\]"
        puts "    TE::sw_run_sdk \[-open_only\] \[-update_hdf_only\] \[-prebuilt_hdf <arg>\] \[-clear\] \[-help\]"
        puts "  ----------------"
        puts "  Hardware Design:"
        puts "    TE::hw_blockdesign_create_bd \[-bd_name\] \[-msys_local_mem\] \[-msys_ecc\] \[-msys_cache\] \[-msys_debug_module\] \[-msys_axi_periph\] \[-msys_axi_intc\] \[-msys_clk\] \[-help\]"
        puts "    TE::hw_blockdesign_export_tcl \[-no_mig_contents\] \[-no_validate\] \[-mod_tcl\] \[-svntxt <arg>\]  \[-board_part_only\] \[-help\]"
        puts "    TE::hw_build_design \[-disable_bitgen\] \[-disable_hdf\] \[-disable_mcsgen\] \[-disable_reports\] \[-export_prebuilt\] \[-export_prebuilt_only\] \[-help\]"
      }
      puts "------------------------------------------"
      puts "Note:(TE) Run only predefined TE-functions from this list. Run other TE-functions directly may cause errors."
      puts "Note:(TE) For more Informations see Trenz Electronic Wiki: https://wiki.trenz-electronic.de/display/PD/Project+Delivery"
      puts "------------------------------------------"
    }
  }
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished help functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # hardware generation functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  #--------------------------------
  #--hw_blockdesign_create_new_bd:  
  proc hw_blockdesign_create_bd {{args ""}} {
    set bd_name "fsys"
    set msys_local_mem "8KB"
    set msys_ecc "None"
    set msys_cache "None"
    set msys_debug_module "Debug Only"
    set msys_axi_periph "Enabled"
    set msys_axi_intc "0"
    set msys_clk "None"
    

    set run_help false
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-bd_name"		          {incr option; set bd_name [lindex $args $option]}
        "-help"		              {set run_help true}
          default               {puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    }
    if {$run_help} {
      puts "Description:\n\
            Create new Block Design with given name. \n\
            Special Block Design names: \n\
            fsys  -> used for FPGA-Fabric Design only. Generate empty Block Design. \n\
            msys  -> used for Microblaze Design only. Generate Microblaze with defined parameters. \n\
            zsys  -> used for 7Series Zynq Design only. Generate 7 Series Zynq with Board Part configuration and Carrier Board extended settings (if available). \n\
            zusys -> used for UltraScale Plus Zynq Design only. Generate UltraScale Plus Zynq with Board Part configuration and Carrier Board extended settings (if available). \n\
            "
      puts "Syntax:\n\
            TE::hw_blockdesign_create_bd \[-bd_name\] \[-msys_local_mem\] \[-msys_ecc\] \[-msys_cache\] \[-msys_debug_module\] \[-msys_axi_periph\] \[-msys_axi_intc\] \[-msys_clk\] \[-help\]\n\
            "
      puts "Returns:\n\
              No return value.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-help\]               print help\n\
              \[-bd_name\]            Use one of the predefined names (def:fsys): fsys, msys, zsys, zusys \n\
              \[-msys_local_mem\]     Use one of the predefined values(def:8KB): None, 4KB, 8KB, 16KB, 32KB, 64KB, 128KB \n\
              \[-msys_ecc\]           Use one of the predefined values(def:None): None, Basic, Full \n\
              \[-msys_cache\]         Use one of the predefined values(def:None): None, 4KB, 8KB, 16KB, 32KB, 64KB \n\
              \[-msys_debug_module\]  Use one of the predefined values(def:Debug Only): None, Debug Only, \"Debug \& UART\", \"Extended Debug\" \n\
              \[-msys_axi_periph\]    Use one of the predefined values(def:Enabled): Disabled, Enabled \n\
              \[-msys_axi_intc\]      Use one of the predefined values(def:0): 0, 1 \n\
              \[-msys_clk\]           Use one of the predefined values(def:None): None, \"New Clocking Wizard (100 MHz)\", \"New External Port (100 MHz)\" \n\
            "
      puts "Categories:\n \
            TE::VIV\n\
            "
    } else {
      # m_settings only used for msys
      set m_settings {local_mem $msys_local_mem ecc $msys_ecc cache $msys_cache debug_module $msys_debug_module axi_periph $msys_axi_periph axi_intc $msys_axi_intc  clk $msys_clk}
      if {[catch {TE::VIV::create_new_blockdesign $bd_name $m_settings } result]} { puts "Error:(TE) Script (TE::VIV::create_new_blockdesign) failed: $result."; return -code error}
    }
  }
  #--------------------------------
  #--hw_blockdesign_export_tcl:  
  proc hw_blockdesign_export_tcl {{args ""}} {
    set no_mig ""
    set no_validate ""
    set boardpart_only ""
    set mod_tcl ""
    set svn_check false
    set svn_msg ""
    set run_help false
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-no_mig_contents"		  {set no_mig [lindex $args $option]}
        "-mod_tcl"		          {set mod_tcl [lindex $args $option]}
        "-no_validate"		      {set no_validate [lindex $args $option]}
        "-svntxt"		            {incr option; set svn_check true; set svn_msg [lindex $args $option]}
        "-board_part_only"		  {set boardpart_only [lindex $args $option]}
        "-help"		              {set run_help true}
          default               {puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    }
    if {$run_help} {
      puts "Description:\n\
            Export Block Design as tcl-file. \n\
            File destination is $TE::BD_PATH or ${TE::BD_PATH}/${TE::SHORTDIR}/, if sub-folder exists. \n\
            If ${TE::BD_PATH}/${TE::SHORTDIR}/  exists, Block Designs from $TE::BD_PATH are ignored on project creation. \n\
            Attention: Open block-design will be saved automatically before export is run.\
            "
      puts "Syntax:\n\
            TE::hw_blockdesign_export_tcl \[-no_mig_contents\] \[-no_validate\] \[-mod_tcl\] \[-svntxt <arg>\] \[-board_part_only\] \[-help\]\n\
            "
      puts "Returns:\n\
              No return value.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-help\]     print help\n\
              \[-no_mig_contents\]  Vivado specific option when MIG is used: MIG-Configuration is excluded from TCL-File. Referenz to mig.prj is used instead. Wrong usage will damaged design functionality!\n\
              \[-no_validate\]      Design is saved without validation.\n\
              \[-board_part_only\]  Export for this bord part only (tcl is stored in ${TE::BD_PATH}/${TE::SHORTDIR}/). \n\
              \[-mod_tcl\]          TCL Content would be modified with content from $TE::BD_PATH\\mod_bd.tcl. If mod_bd.tcl don't exist or all commands inside are commented, nothing is changed. Wrong usage will damaged design functionality!  \n\
              \[-svntxt <arg>\]     Send svn commit with Text <arg>if SVN-versioning is used for the files in $TE::BD_PATH.\n\
            "
      puts "Categories:\n \
            TE::VIV, TE::UTILS, TE::EXT\n\
            "
    } else {
      if {[catch {TE::VIV::export_blockdesign $no_mig $no_validate $boardpart_only $mod_tcl} result]} { puts "Error:(TE) Script (TE::VIV::export_blockdesign) failed: $result."; return -code error}
      if {$svn_check} {
        if {[catch {TE::EXT::svn_checkin ${TE::BD_PATH} $svn_msg} result]} { puts "Error:(TE) Script (TE::EXT::svn_checkin) failed: $result."; return -code error}
      }
    }
  }
  #--------------------------------
  #--hw_build_design:  
  proc hw_build_design {{args ""}} {
    set run_build true
    set bitgen true
    set mcsgen true
    set reportgen true
    set hdfgen true
    set export_prebuild false
    set run_help false
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-disable_bitgen"          { set bitgen false}
        "-disable_hdf"             { set hdfgen false}
        "-disable_mcsgen"          { set mcsgen false}
        "-disable_reports"         { set reportgen false}
        "-export_prebuilt_only"    { set export_prebuild true; set run_build false}
        "-export_prebuilt"         { set export_prebuild true}
        "-help"		                 { set run_help true}
          default    { puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    } 
    if {$run_help} {
      puts "Description:\n\
            Run Synthesises and Implementation. \n\
            Generate Bit-file on all BD-Names and MCS-File only on none Zynq/UltraScale Systems. \n\
            "
      puts "Syntax:\n\
            TE::hw_build_design \[-disable_bitgen\] \[-disable_hdf\] \[-disable_mcsgen\] \[-disable_reports\] \[-export_prebuilt\] \[-export_prebuilt_only\] \[-help\]\n\
            "
      puts "Returns:\n\
              No return value.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-disable_bitgen\]       Bit-File generation is disabled. \n\
              \[-disable_hdf\]         HDF-File generation is disabled(delete *.sysdef). \n\
              \[-disable_mcsgen\]       MCS-File generation for none Zynq/UltraScale Systems is disabled. \n\
              \[-disable_reports\]      Report-Files generation for prebuilt folder is disabled. \n\
              \[-export_prebuilt\]      Export generated HW-Files to the prebuilt folder (copy is done automatically, when hsi, sdk or jtag programming scripts starts in VIVADO). \n\
              \[-export_prebuilt_only\] Export generated HW-Files to the prebuilt folder without rebuild the design. \n\
              \[-help\]                 print help\n\
            "
      puts "Categories:\n \
            TE::VIV,TE::UTILS\n\
            "
    } else {
    
      if {$run_build} {
        if {[catch {TE::VIV::build_design $bitgen $mcsgen $reportgen $hdfgen} result]} { puts "Error:(TE) Script (TE::VIV::build_design) failed: $result."; return -code error}
      }
      # copy is done if hsi, sdk or jtag programming is started or
      if {$export_prebuild} {
        if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} { puts "Error:(TE) Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
        if {[catch {TE::UTILS::copy_hw_reports} result]} { puts "Info:(TE) No Hardware Reports found."}
      }
    }
  }
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished hardware generation functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # software generation functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  #--------------------------------
  #--sw_run_hsi:  
  proc sw_run_hsi {{args ""}} {
    set run_help false
    set run_copy true
    set run_clear false
    set run_prebuilt false
    set run_prebuilt_hdf_only false
    set run_hsi true
    set run_bif true
    set run_bin true
    set force_bin false
    set run_bitmcs true
    set prebuilt_name ""
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-run_only"  { set run_copy false}
        "-prebuilt_hdf"	  { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        "-prebuilt_hdf_only"	  { incr option; set run_prebuilt_hdf_only true; set prebuilt_name [lindex $args $option]}
        "-no_hsi"		  { set run_hsi false}
        "-no_bif"		  { set run_bif false}
        "-no_bin"		  { set run_bin false}
        "-no_bitmcs"  { set run_bitmcs false}
        "-force_bin"		  { set force_bin true}
        "-clear"		  { set run_clear true}
        "-help"		    { set run_help true}
          default     { puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    }
    if {$run_help} {
      puts "Description:\n\
            Start HSI and create all software apps (*elf) and corresponding boot.bif and boot.bin (for Zynq/UZynq only) or <app>.bit and <app>.mcs (for MicroBlaze only), which are specified in apps_list.csv\n\
            Copy HW File and reports from the vivado project to the prebuilt folder if -prebuild_hdf <arg> isn't set (default)\n\
            *.hdef and *.sysdef are ignored if BD-Name is fsys (Without processor system). \n\
            "
      puts "Syntax:\n\
            TE::sw_run_hsi \[-run_only\] \[-prebuilt_hdf <arg>\] \[-no_hsi\] \[-no_bif\] \[-no_bin\] \[-no_bitmcs\] \[-clear\] \[-help\]\n\
            "
      puts "Returns:\n\
              No return value.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-prebuilt_hdf <arg>\] used *.bit and *.hdf from prebuilt folder instead of vivado project. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used. \n\
              \[-run_only\]           used old data in workspace (*.bit and *.hdf)\n\
              \[-no_hsi\]             disable *.elf generation\n\
              \[-no_bif\]             disable boot.bif generation (for Zynq System only)\n\
              \[-no_bin\]             disable boot.bin generation (for Zynq System only)\n\
              \[-force_bin\]          disabllefor Zynq check for bif and bin generation\n\
              \[-no_bitmcs\]          disable {appname}.bit and <appname>.mcs (for MicroBlaze System only) generation\n\
              \[-clear\]              delete old data before workspace is created\n\
              \[-help\]               print help\n\
            "
      puts "Categories:\n \
            TE::UTILS, TE::EXT\n\
            "
    } else {
      if {$run_clear} {
        if {[catch {TE::UTILS::clean_workspace_hsi} result]} { puts "Error:(TE) Script (TE::UTILS::clean_workspace_hsi) failed: $result."; return -code error}
      }
      
      if {$run_hsi} {
        if {$run_copy} {
          if {$run_prebuilt} {
            if {[catch {TE::UTILS::generate_workspace_hsi $prebuilt_name} result]} { puts "Error:(TE) Script (TE::UTILS::generate_workspace_hsi) failed: $result."; return -code error}
          } elseif {$run_prebuilt_hdf_only} {
            if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} { puts "Error:(TE) Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
            if {[catch {TE::UTILS::copy_hw_reports} result]} { puts "Info:(TE) No Hardware Reports found. "}
            if {[catch {TE::UTILS::generate_workspace_hsi $prebuilt_name} result]} { puts "Error:(TE) Script (TE::UTILS::generate_workspace_hsi) failed: $result."; return -code error}
          } else {
            if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} { puts "Error:(TE) Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
            if {[catch {TE::UTILS::copy_hw_reports} result]} { puts "Info:(TE) No Hardware Reports found. "}
            if {[catch {TE::UTILS::generate_workspace_hsi} result]} { puts "Error:(TE) Script (TE::UTILS::generate_workspace_hsi) failed: $result."; return -code error}
          }
        }
        if {[catch {TE::EXT::run_hsi} result]} { puts "Error:(TE) Script (TE::EXT::run_hsi) failed: $result."; return -code error}
      }
      if {$TE::IS_ZSYS || $TE::IS_ZUSYS || $force_bin} {
        #.bif and .bin only on zynq systems
        if {$run_bif} {
          if {[catch {TE::EXT::generate_bif_files $prebuilt_name} result]} { puts "Error:(TE) Script (TE::EXT::generate_bif_files) failed: $result."; return -code error}
        }
        if {$run_bin} {
          if {[catch {TE::EXT::generate_bootbin $prebuilt_name} result]} { puts "Error:(TE) Script (TE::EXT::generate_bootbin) failed: $result."; return -code error}
        }
      } elseif {$TE::IS_MSYS} {
        if {$run_bitmcs} {
          if {[catch {TE::EXT::generate_app_bit_mcs $prebuilt_name} result]} { puts "Error:(TE) Script (TE::EXT::generate_app_bit_mcs) failed: $result."; return -code error}
        }
      } else {
          puts "Info:(TE) Boot.bif and Boot.bin only for Zynq-FPGAs available. <app>.bit and <app>.mcs only for MicroBlaze available. System will be checked with block design name, current BD file name is $TE::BD_TCLNAME .Use:"
          puts "\"zsys_bd.tcl\" for Systems with Zynq "
          puts "\"zusys_bd.tcl\" for Systems with UltraScale Zynq"
          puts "\"msys_bd.tcl\" for Systems with MicroBlaze"
          puts "\"fsys_bd.tcl\" for Systems with FPGA-Fabric design only"
      }
    }
  }
  #--------------------------------
  #--sw_run_sdk:  
  proc sw_run_sdk {{args ""}} {
    set run_help false
    set run_copy true
    set start_sdk true
    set run_clear false
    set run_prebuilt false
    set prebuilt_name ""
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-open_only"        { set run_copy false}
        "-update_hdf_only"  { set start_sdk false}
        "-prebuilt_hdf"     { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        "-clear"		        { set run_clear true}
        "-help"		          { set run_help true}
          default           { puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    }
    if {$run_help} {
      puts "Description:\n\
            Start SDK project in external folder $TE::WORKSPACE_SDK_PATH\n\
            Attention: If you use VIVADO GUI Command (File->Export-> Export Hardware..(Include Bit-file!) or File->Launch SDK) to Update or open SKD set new export path and workspace:  $TE::WORKSPACE_SDK_PATH\n\
            Copy HW File and reports from the vivado project to the prebuilt folder if -prebuild_hdf <arg> isn't set (default)\n\
            *.hdef and *.sysdef are ignored if BD-Name is fsys (Without processor system). \n\
            "
      puts "Syntax:\n\
            TE::sw_run_sdk \[-open_only\] \[-update_hdf_only\] \[-prebuilt_hdf <arg>\] \[-clear\] \[-help\]\n\
            "
      puts "Returns:\n\
              No return value.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-prebuilt_hdf <arg>\] used *.hdf from prebuilt folder instead of vivado project. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used. \n\
              \[-open_only\]          open SDK without update the *.hdf file \n\
              \[-update_hdf_only\]    copy the new *.hdf file into the SDK workspace without open SDK\n\
              \[-clear\]              delete old data before workspace is created\n\
              \[-help\]               print help\n\
            "
      puts "Categories:\n \
            TE::UTILS, TE::EXT\n\
            "
    } else {
      if {$run_clear} {
        if {[catch {TE::UTILS::clean_workspace_sdk} result]} { puts "Error:(TE) Script (TE::UTILS::clean_workspace_sdk) failed: $result."; return -code error}
      }
      if {$run_copy} {
        if {$run_prebuilt} {
          if {[catch {TE::UTILS::generate_workspace_sdk $prebuilt_name} result]} { puts "Error:(TE) Script (TE::UTILS::generate_workspace_sdk) failed: $result."; return -code error}
        } else {
          if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} { puts "Error:(TE) Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
          if {[catch {TE::UTILS::copy_hw_reports} result]} { puts "Info:(TE) No Hardware Reports found."}
          if {[catch {TE::UTILS::generate_workspace_sdk} result]} { puts "Error:(TE) Script (TE::UTILS::generate_workspace_sdk) failed: $result."; return -code error}
        }
      }
      if {$start_sdk} {
        if {[catch {TE::EXT::run_sdk} result]} { puts "Error:(TE) Script (TE::EXT::run_sdk) failed: $result."; return -code error}
      }
    }
  }
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished software generation functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # programming functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  #--------------------------------
  #--pr_program_flash_binfile:  
  proc pr_program_flash_binfile {{args ""}} {
    set return_filename ""
    set use_basefolder false
    set use_sdk_flash true
    set run_help false
    set run_prebuilt false
    set appname ""
    set prebuilt_name ""
    set print_available_apps false
    set reboot true
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-no_reboot"                { set reboot false}
        "-used_board"               { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        "-swapp"                    { incr option; set appname [lindex $args $option]}
        "-available_apps"           { set print_available_apps true}
        "-force_hw_manager"         { set use_sdk_flash false}
        "-used_basefolder_binfile"  {set use_basefolder true}
        "-help"		                  { set run_help true}
          default                   { puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    }
    if {$run_help} {
      puts "Description:\n\
            Programming specified FPGA-Flash with bin-file (Zynq-Processors only)-\n\
            "
      puts "Syntax:\n\
            TE::pr_program_flash_binfile \[-no_reboot\] \[-used_board <arg>\] \[-swapp <arg>\] \[-available_apps\] \[-used_basefolder_binfile\] \[-help\]\n\
            If -used_board <arg> isn't set, it will be program the boot.bin from the corresponding prebuilt folder which is set in the vivado project\n\
            "
      puts "Returns:\n\
              Programming file-name.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-no_reboot\]                Memory will be only configured, no JTag reboot is done.\n\
              \[-used_board <arg>\]         Used prebuilt folder board version instead of vivado project settings. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used.\n\
              \[-swapp <arg>\]              Software app name which should be programmed.\n\
              \[-available_apps\]           Return available software app names from selected the prebuilt boot_images folder.\n\
              \[-force_hw_manager\]         Force LabTools Hardware-Manager instead of SDK-Programmer. Boot.bin can be configured via SDK-Programmer or LabTools Hardware-Manager. If both availble SDK-Programmer is used default.\n\
              \[-used_basefolder_binfile\]  Use base-folder bin-file ($TE::BASEFOLDER). Should be only one *.bin!\n\
              \[-help\]                     Print help\n\
            "
      puts "Categories:\n \
            TE::EXT, TE::VLAB\n\
            "
    } else {
      set starttime [clock seconds]
      if {$print_available_apps} {
         if {[catch {TE::EXT::get_available_apps $prebuilt_name} result]} { puts "Error:(TE) Script (TE::EXT::get_available_apps) failed: $result."; return -code error}
      } else {
        if {$appname eq ""} { puts "Error:(TE) No App name is selected see \[pr_program_flash_binfile -help\]: $result."; return -code error}
        if {$prebuilt_name ne ""} {
          set id "[TE::BDEF::find_id $prebuilt_name]"
          set zynqflashtyp_int [TE::BDEF::get_zynqflashtyp $id 0]
        } else {
          set zynqflashtyp_int $TE::ZYNQFLASHTYP
        }
          
        set check_zynqflash false
        if {$zynqflashtyp_int ne "NA"} {
          set check_zynqflash true
        }
        
        if {$::env(SDK_AVAILABLE) && $check_zynqflash && $use_sdk_flash} {
          if {[catch {set return_filename [TE::EXT::excecute_zynq_flash_programming $use_basefolder $appname $prebuilt_name]} result]} { puts "Error:(TE) Script (TE::EXT::excecute_zynq_flash_programming) failed: $result."; return -code error}
          if {$reboot} {
            set hw_close true
            if {[catch {set hw_close [TE::VLAB::hw_open_jtag]} result]} { puts "Error:(TE) Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}
            if {[catch {TE::VLAB::hw_fpga_boot_from_memory $prebuilt_name} result]} { puts "Error:(TE) Script (TE::VLAB::hw_fpga_boot_from_memory) failed: $result."; return -code error}
            if {$hw_close} {
              if {[catch {TE::VLAB::hw_close_jtag} result]} { puts "Error:(TE) Script (TE::VLAB::hw_close_jtag) failed: $result."; return -code error}
            }
          }
        } else {
          set hw_close true
          if {[catch {set hw_close [TE::VLAB::hw_open_jtag]} result]} { puts "Error:(TE) Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}

          if {[catch {TE::VLAB::hw_create_flash_device $prebuilt_name} result]} { puts "Error:(TE) Script (TE::VLAB::hw_create_flash_device) failed: $result."; return -code error}
          if {[catch {set return_filename [TE::VLAB::hw_program_fpga_flash $use_basefolder "" bin $appname $prebuilt_name]} result]} { puts "Error:(TE) Script (TE::VLAB::hw_program_fpga_flash) failed: $result."; return -code error}
 
          if {$reboot} {
            if {[catch {TE::VLAB::hw_fpga_boot_from_memory $prebuilt_name} result]} { puts "Error:(TE) Script (TE::VLAB::hw_fpga_boot_from_memory) failed: $result."; return -code error}
          }
          if {$hw_close} {
            if {[catch {TE::VLAB::hw_close_jtag} result]} { puts "Error:(TE) Script (TE::VLAB::hw_close_jtag) failed: $result."; return -code error}
          }
        }
      }
      set stoptime [clock seconds]
      set timeelapsed [expr $stoptime -$starttime]
      puts "Info: (TE) Programming elapsed time: $timeelapsed seconds"
    }
    return $return_filename
  }
  #--------------------------------
  #--pr_program_flash_mcsfile:  
  proc pr_program_flash_mcsfile {{args ""}} {
    set return_filename ""
    set run_help false
    set run_prebuilt false
    set appname ""
    set prebuilt_name ""
    set print_available_apps false
    set reboot true
    set term "pull-none"
    set use_basefolder false
      #pull-none  (default)#pull-up #pull-down
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-no_reboot"                { set reboot false}
        "-used_board"               { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        "-unused_io_termination"    { incr option; set term [lindex $args $option]}
        "-swapp"                    { incr option; set appname [lindex $args $option]}
        "-available_apps"           { set print_available_apps true}
        "-used_basefolder_mcsfile"  {set use_basefolder true}
        "-help"		                  { set run_help true}
          default                   { puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    }
    if {$run_help} {
      puts "Description:\n\
            Programming specified FPGA-Flash with mcs-File (No Zynq-Processors only).\n\
            "
      puts "Syntax:\n\
            TE::pr_program_flash_mcsfile \[-no_reboot\] \[-used_board <arg>\] \[-unused_io_termination <arg>\] \[-swapp <arg>\] \[-available_apps\] \[-used_basefolder_mcsfile\] \[-help\]\n\
            If -used_board <arg> isn't set, it will be program the <project_name>.mcs from the corresponding prebuilt folder which is set in the vivado/labtool project\n\
            "
      puts "Returns:\n\
              Programming file-name.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-no_reboot\]                    Memory will be only configured, no JTag reboot is done.\n\
              \[-used_board <arg>\]             Used prebuilt folder board version instead of vivado project settings. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used.\n\
              \[-unused_io_termination <arg>\]  Set termination for unused Device IO-Pins Available Settings are: pull-none, pull-up or pull-down.   Default pull-none is used.\n\
              \[-swapp <arg>\]                  Software app name which should be programmed. (If app name isn't set, the mcs-file from the prebuilt hardware folder is used) \n\
              \[-available_apps\]               Return available software app names from selected the prebuilt boot_images folder.\n\
              \[-used_basefolder_mcsfile\]      Use base-folder mcs-file ($TE::BASEFOLDER). Should be only one *.mcs!\n\
              \[-help\]                         Print help\n\
            "
      puts "Categories:\n \
            TE::EXT, TE::VLAB\n\
            "
    } else {
      set starttime [clock seconds]
      if {$print_available_apps} {
        if {[catch {TE::EXT::get_available_apps $prebuilt_name} result]} { puts "Error:(TE) Script (TE::EXT::get_available_apps) failed: $result."; return -code error}
      } else {
        if {!$run_prebuilt} {
          if {![catch {set projectname [get_projects]} result]} {
            #copy only on vivado project
            if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} { puts "Error:(TE) Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
            if {[catch {TE::UTILS::copy_hw_reports} result]} { puts "Info:(TE) No Hardware Reports found. "}
          }
        }
        set hw_close true
        if {[catch {set hw_close [TE::VLAB::hw_open_jtag]} result]} { puts "Error:(TE) Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}

        if {[catch {TE::VLAB::hw_create_flash_device $prebuilt_name} result]} { puts "Error:(TE) Script (TE::VLAB::hw_create_flash_device) failed: $result."; return -code error}
        if {[catch {set return_filename [TE::VLAB::hw_program_fpga_flash $use_basefolder $term mcs $appname $prebuilt_name]} result]} { puts "Error:(TE) Script (TE::VLAB::hw_program_fpga_flash) failed: $result."; return -code error}

        if {$reboot} {
          if {[catch {TE::VLAB::hw_fpga_boot_from_memory $prebuilt_name} result]} { puts "Error:(TE) Script (TE::VLAB::hw_fpga_boot_from_memory) failed: $result."; return -code error}
        }
        if {$hw_close} {
          if {[catch {TE::VLAB::hw_close_jtag} result]} { puts "Error:(TE) Script (TE::VLAB::hw_close_jtag) failed: $result."; return -code error}
        }
      }
      set stoptime [clock seconds]
      set timeelapsed [expr $stoptime -$starttime]
      puts "Info: (TE) Programming elapsed time: $timeelapsed seconds"
    }
    return $return_filename
  }
  #--------------------------------
  #--pr_program_jtag_bitfile:  
  proc pr_program_jtag_bitfile {{args ""}} {
    set return_filename ""
    set print_available_apps false
    set run_help false
    set run_prebuilt false
    set use_basefolder false
    set prebuilt_name ""
    set appname ""
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-used_board"     { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        "-swapp"                    { incr option; set appname [lindex $args $option]}
        "-available_apps"           { set print_available_apps true}
        "-used_basefolder_bitfile"     {set use_basefolder true}
        "-help"		        { set run_help true}
          default         { puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    }
    if {$run_help} {
      puts "Description:\n\
            Programming FPGA with bit-file\n\
            Copy HW File and reports from the vivado project to the prebuilt folder if -used_board <arg> isn't set (default)\n\
            "
      puts "Syntax:\n\
            TE::pr_program_jtag_bitfile \[-used_board <arg>\] \[-used_basefolder_bitfile\] \[-help\]\n\
            "
      puts "Returns:\n\
              Programming file-name.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-used_board <arg>\]         Used prebuilt folder board version instead of vivado project settings. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used.\n\
              \[-swapp <arg>\]              Software app name which should be programmed. (If app name isn't set, the bit-file from the prebuilt hardware folder is used) \n\
              \[-available_apps\]           Return available software app names from selected the prebuilt boot_images folder.\n\
              \[-used_basefolder_bitfile\]  Use base-folder bit-file ($TE::BASEFOLDER). Should be only one *.bit!\n\
              \[-help\]                     Print help\n\
            "
      puts "Categories:\n \
            TE::VLAB\n\
            "
    } else {
      set starttime [clock seconds]
      if {$print_available_apps} {
        if {[catch {TE::EXT::get_available_apps $prebuilt_name} result]} { puts "Error:(TE) Script (TE::EXT::get_available_apps) failed: $result."; return -code error}
      } else {
        if {!$run_prebuilt} {
          if {![catch {set projectname [get_projects]} result]} {
            #copy only on vivado project
            if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} { puts "Error:(TE) Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
            if {[catch {TE::UTILS::copy_hw_reports} result]} { puts "Info:(TE) No Hardware Reports found. "}
          }
        }
        set hw_wasclosed false
        if {[current_hw_server] eq ""} {set hw_wasclosed true}
        if {[catch {TE::VLAB::hw_open_jtag} result]} { puts "Error:(TE) Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}
        if {[catch {set return_filename [TE::VLAB::hw_program_fpga_device $use_basefolder $appname $prebuilt_name]} result]} { puts "Error:(TE) Script (TE::VLAB::hw_program_fpga_device) failed: $result."; return -code error}
        if {$hw_wasclosed} {
          if {[catch {TE::VLAB::hw_close_jtag} result]} { puts "Error:(TE) Script (TE::VLAB::hw_close_jtag) failed: $result."; return -code error}
        }        
      }   
      set stoptime [clock seconds]
      set timeelapsed [expr $stoptime -$starttime]
      puts "Info: (TE) Programming elapsed time: $timeelapsed seconds"
    }
    return $return_filename
  }
  #--------------------------------
  #--pr_init_hardware_manager:  
  proc pr_init_hardware_manager {{args ""}} {
    set run_help false
    set run_prebuilt false
    set prebuilt_name ""
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-help"		        { set run_help true}
          default         { puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    }
    if {$run_help} {
      puts "Description:\n\
            Open Hardware-Manager, auto-connect target device and initialise flash memory with configuration from *_board_files.csv.  \n\
            If flash memory isn't specified, it will be ignored.  \n\
            "
      puts "Syntax:\n\
            TE::pr_init_hardware_manager \[-help\]\n\
            "
      puts "Returns:\n\
              No return value.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-help\]                 print help\n\
            "
      puts "Categories:\n \
            TE::VLAB\n\
            "
    } else {
    
        if {[catch {TE::VLAB::hw_open_jtag} result]} { puts "Error:(TE) Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}
        if {${TE::FPGAFLASHTYP} ne "NA"} {
          if {[catch {TE::VLAB::hw_create_flash_device} result]} { puts "Error:(TE) Script (TE::VLAB::hw_create_flash_device) failed: $result."; return -code error}
        }
   
    }
  }
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished programming functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # utilities functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  #--------------------------------
  #--util_zip_project:  
  proc util_zip_project {{args ""}} {
    set run_help false
    set manual_name false
    set tmp [split $TE::SHORTDIR "_"]
    set zipname ""
    
    #settings
    set remove_prebuilt false
    set save_all false
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-manual_filename"  { incr option; set zipname [lindex $args $option];set manual_name true}
        "-remove_prebuilt"  { set remove_prebuilt true}
        "-save_all"		      { set save_all true}
        "-help"		          { set run_help true}
          default    { puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
        }
    }
    if {!$manual_name} {
      #boardname
      set zipname [lindex $tmp 0]
      #projectname 
      set zipname "${zipname}-${TE::VPROJ_NAME}"
      if {$remove_prebuilt} {
      set zipname "${zipname}_noprebuilt"
      }
      if {$save_all} {
      set zipname "${zipname}_all"
      }
      #vivado version
      set zipname "${zipname}-vivado_$::env(VIVADO_VERSION)"
      #Scipt version (last id)
      set tmp [split $TE::SCRIPTVER "."]
      set scriptver [lindex $tmp [expr [llength $tmp]-1]]
      set zipname "${zipname}-build_${scriptver}"
      #timestamp
      set date "[ clock format [clock seconds] -format "%Y%m%d%H%M%S"]"
      set zipname "${zipname}_${date}"
    }
    if {$run_help} {
      puts "Description:\n\
            Generate Zip file from current project in folder $TE::BACKUP_PATH.\n\
            ./software/zip/zip.exe is needed to run.\n\
            "
      puts "Syntax:\n\
            TE::util_zip_project \[-save_all\] \[-remove_prebuilt\] \[-manual_filename <arg>\] \[-help\]\n\
            "
      puts "Returns:\n\
              No return value.\n\
            "
      puts "Usage:\n\
              Name          Description\n\
              -------------------------\n\
              \[-manual_filename <arg>\]  use this name instead auto-generate name\n\
              \[-remove_prebuilt\]        prebuilt is not saved (is ignored if -save_all is selected)\n\
              \[-save_all\]               save all, otherwise work path (vivado, workspace, vlog, run_prebuilt_all.cmd and mod_bd.csv) are excluded n\
              \[-help\]                   print help\n\
            "
      puts "Categories:\n \
            TE::EXT\n\
            "
    } else {
      if {$save_all} {
        if {[catch {TE::EXT::zip_project $zipname} result]} { puts "Error:(TE) Script (TE::EXT::zip_project) failed: $result."; return -code error}
      } else {
        #default list for old projects:
        set excludelist "vivado vivado_lab workspace v_log run_prebuilt_all.cmd block_design/mod_bd.csv scripts/.svn sdsoc settings/development_settings.tcl"
        #read ignore list from file
        if {[llength $TE::ZIP_IGNORE_LIST] > 0} {
          set excludelist []
          foreach entry $TE::ZIP_IGNORE_LIST {
            if {[lindex $entry 0]==0} {
              #only id0 objects
              lappend excludelist [lindex $entry 1]
            } elseif {[lindex $entry 0]==1} {
              #only id1 objects
              set find []
              catch {set find [glob -join -dir $TE::BASEFOLDER [lindex $entry 1]]}
              foreach el $find {
                set sl_start [expr [string length $TE::BASEFOLDER]+1]
                set sl_stop [string length $el] 
                lappend excludelist [string range $el $sl_start $sl_stop]
              }
            }
          }
        }
        if {$remove_prebuilt} {
          # set excludelist "$excludelist prebuilt"
          lappend excludelist "prebuilt"
        }
        if {[catch {TE::EXT::zip_project $zipname $excludelist} result]} { puts "Error:(TE) Script (TE::EXT::zip_project) failed: $result."; return -code error}
      }
    }
  }
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished utilities functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # beta test functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  namespace eval ADV {
    #--------------------------------
    #--beta_util_sdsoc_project: 
    proc beta_util_sdsoc_project {{args ""}} {
      set run_help false
      set start_sdsoc false
      set check_sdsoc false

      set args_cnt [llength $args]
      for {set option 0} {$option < $args_cnt} {incr option} {
          switch [lindex $args $option] { 
          "-check_only"		   { set check_sdsoc true}
          "-start_sdsoc"		  { set start_sdsoc true}
          "-help"		          { set run_help true}
            default    { puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
          }
      }
      
      if {$run_help} {
        puts "Description:\n\
              Beta Test (advanced usage only).\n\
              Generate SDSOC project structure in $TE::SDSOC_PATH.\n\
              ZIP-Program is required (see design_basic_settings.cmd).\n\
              Attention: This Project will be modified! To restore, close this Project after SDSOC generation an run create project batch file.\n\
              "
        puts "Syntax:\n\
              TE::ADV::beta_util_sdsoc_project \[-check_only\] \[-start_sdsoc\] \[-help\]\n\
              "
        puts "Returns:\n\
                No return value.\n\
              "
        puts "Usage:\n\
                Name          Description\n\
                -------------------------\n\
                \[-check_only\]        Check this project for SDSOC support (no modification are done).\n\
                \[-start_sdsoc\]       Start SDSOC with workspace: $TE::SDSOC_PATH \n\
                \[-help\]              print help\n\
              "
        puts "Categories:\n \
              TE::SDSOC, TE::EXT\n\
              "
      } else {
        if {$check_sdsoc} {
          if {[catch {TE::SDSOC::check_and_modify_vivado_project true} result]} { puts "Error:(TE) Script (TE::SDSOC::check_and_modify_vivado_project) failed: $result."; return -code error}
        } elseif {$start_sdsoc} {
          if {[catch {TE::EXT::run_sdsoc} result]} { puts "Error:(TE) Script (TE::EXT::run_sdsoc) failed: $result."; return -code error}
        } else {
          if {[catch {TE::SDSOC::create_sdsoc_structure} result]} { puts "Error:(TE) Script (TE::SDSOC::create_sdsoc_structure) failed: $result."; return -code error}
          if {[catch {TE::SDSOC::check_and_modify_vivado_project false} result]} { puts "Error:(TE) Script (TE::SDSOC::check_and_modify_vivado_project) failed: $result."; return -code error}
           #todo rebuild project files
          if {[catch {TE::SDSOC::export_vivado_sdsoc_project} result]} { puts "Error:(TE) Script (TE::SDSOC::export_vivado_sdsoc_project) failed: $result."; return -code error}
          if {[catch {TE::SDSOC::create_sdsoc_pfm} result]} { puts "Error:(TE) Script (TE::SDSOC::create_sdsoc_pfm) failed: $result."; return -code error}
          puts "Info:(TE) Create SDSOC project finished"
        }
      }
    }
    #--------------------------------
    #--beta_hw_remove_board_part
    proc beta_hw_remove_board_part {{args ""}} {
      set temp_only true
      set run_help false
      set args_cnt [llength $args]
      for {set option 0} {$option < $args_cnt} {incr option} {
          switch [lindex $args $option] { 
          "-permanent"		        {set temp_only false}
          "-help"		              {set run_help true}
            default               {puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
          }
      }
      if {$run_help} {
        puts "Description:\n\
              Remove board part from project. \n\
              Attention: \n\
                Function not supported for all Block-Design IPs. \n\
                User must check design after automatically modifications are done. \n\
              To restore project after permanent modification do: \n\
                Delete ${TE::BD_PATH}/*.tcl. \n\
                Rename ${TE::BD_PATH}/*.tcl_backup into ${TE::BD_PATH}/*.tcl. \n\
                Delete ${TE::BOARDDEF_PATH}/*_board_files_mod.csv. \n\
              "
        puts "Syntax:\n\
              TE::ADV::beta_hw_remove_board_part \[-permanent\] \[-help\]\n\
              "
        puts "Returns:\n\
                No return value.\n\
              "
        puts "Usage:\n\
                Name          Description\n\
                -------------------------\n\
                \[-permanent\]  Board Part is removed permanently for this vivado project.TCL-File is generated and alternative board_part.cvs is used on design creation.\n\              
                \[-help\]       print help\n\              "
        puts "Categories:\n \
              TE::VIV, TE::UTILS\n\
              "
      } else {
        if {[catch {TE::VIV::design_exclude_boarddef $temp_only} result]} { puts "Error:(TE) Script (TE::VIV::design_exclude_boarddef) failed: $result."; return -code error}
      }
    }
    #--------------------------------
    #--beta_hw_export_rtl_ip
    proc beta_hw_export_rtl_ip {{args ""}} {
      set run_help false
      set board_part_only false
      set args_cnt [llength $args]
      for {set option 0} {$option < $args_cnt} {incr option} {
          switch [lindex $args $option] { 
          "-help"		              {set run_help true}
            default               {puts "Warning:(TE) unrecognised option: [lindex $args $option]"; set run_help true;break }
          }
      }
      if {$run_help} {
        puts "Description:\n\
              Export RTL-IP Cores (*.xci), which are not included in a Block-Design to ${TE::HDL_PATH}/xci/${TE::SHORTDIR}. \n\
              HDL and *.xci files, which include in the folder $TE::HDL_PATH are load automatically on project creation. \n\
              "
        puts "Syntax:\n\
              TE::ADV::beta_hw_export_rtl_ip \[-help\]\n\
              "
        puts "Returns:\n\
                No return value.\n\
              "
        puts "Usage:\n\
                Name          Description\n\
                -------------------------\n\
                \[-help\]       print help\n\              "
        puts "Categories:\n \
              TE::VIV, TE::UTILS\n\
              "
      } else {
        if {[catch {TE::VIV::export_xci} result]} { puts "Error:(TE) Script (TE::VIV::export_xci) failed: $result."; return -code error}
      }
    }
  }
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished beta test functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
    
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  puts "Info:(TE) Load User Command scripts finished"
}