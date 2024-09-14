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
# -- $Date: 2016/02/16 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2017/02/06  | $Author: Hartfiel, John
# -- - miscellaneous
# ------------------------------------------
# -- $Date:  2017/09/07  | $Author: Hartfiel, John
# -- - add new document history style
# -- - remove start SDSoC option
# ------------------------------------------
# -- $Date:  2017/09/13  | $Author: Hartfiel, John
# -- - add package trace length export
# ------------------------------------------
# -- $Date:  2017/09/15  | $Author: Hartfiel, John
# -- - use first part of ID Name instead of Short Name for zip file name
# ------------------------------------------
# -- $Date:  2017/09/21  | $Author: Hartfiel, John
# -- - bugfix trace length path example
# ------------------------------------------
# -- $Date: 2018/01/08  | $Author: Hartfiel, John
# -- - add disable syntheses on 'hw_build_design'
# ------------------------------------------
# -- $Date: 2018/01/15  | $Author: Hartfiel, John
# -- - add "beta_hw_create_board_part" --> internal usage only, need external scripts
# ------------------------------------------
# -- $Date: 2018/01/18  | $Author: Hartfiel, John
# -- - add TE0820 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/01/18  | $Author: Hartfiel, John
# -- - add TE0726 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/02/18  | $Author: Hartfiel, John
# -- - add TE0723 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/05/09  | $Author: Hartfiel, John
# -- - add "beta_hw_export_binary"
# ------------------------------------------
# -- $Date: 2018/05/28  | $Author: Hartfiel, John
# -- - add TE0783 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/07/13  | $Author: Hartfiel, John
# -- - add TE0729 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/07/18  | $Author: Hartfiel, John
# -- - add TEB0911 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/08/10  | $Author: Hartfiel, John
# -- - add TE0720 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/08/14  | $Author: Hartfiel, John
# -- - add TE0722 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/08/16  | $Author: Hartfiel, John
# -- - add TEC0850 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/08/28  | $Author: Hartfiel, John
# -- - add TE0724 to "beta_hw_create_board_part"
# -- - update descriptions "hw_build_design"
# ------------------------------------------
# -- $Date: 2018/09/28  | $Author: Hartfiel, John
# -- - add TE0715 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/10/01  | $Author: Hartfiel, John
# -- - add TE0782 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/11/22  | $Author: Hartfiel, John
# -- - add TE0745 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2018/11/26  | $Author: Hartfiel, John
# -- - "beta_hw_export_binary" add all board files export
# ------------------------------------------
# -- $Date: 2018/12/05  | $Author: Hartfiel, John
# -- - add TE0728 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2019/02/19  | $Author: Hartfiel, John
# -- -  modified beta_hw_export_binary
# ------------------------------------------
# -- $Date: 2019/03/14  | $Author: Hartfiel, John
# -- -  modified sw_run_hsi (clear function clears also prebuilt SW)
# ------------------------------------------
# -- $Date: 2019/04/08  | $Author: Hartfiel, John
# -- -  add pr_putty
# ------------------------------------------
# -- $Date: 2019/05/13  | $Author: Hartfiel, John
# -- - add TEB0912 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2019/05/22  | $Author: Hartfiel, John
# -- -  modified beta_hw_export_binary
# ------------------------------------------
# -- $Date: 2019/06/21  | $Author: Hartfiel, John
# -- -  modified pr_init_hardware_manager
# ------------------------------------------
# -- $Date: 2019/08/27  | $Author: Hartfiel, John
# -- - add TE0802 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2019/10/31  | $Author: Hartfiel, John
# -- - modify "pr_putty"
# ------------------------------------------
# -- $Date: 2019/12/11  | $Author: Hartfiel, John
# -- - add sw_run_vitis, sw_run_sdk and sw_run_hsi is obsolete and removed
# ------------------------------------------
# -- $Date:  2019/12/17  | $Author: Hartfiel, John
# -- - changed default vitis parameter setup
# ------------------------------------------
# -- $Date:  2019/12/18  | $Author: Hartfiel, John
# -- -  replace filename variable  VPROJ_NAME with PB_FILENAME
# ------------------------------------------
# -- $Date:  2020/01/10  | $Author: Hartfiel, John
# -- -  update sw_run_vitis
# ------------------------------------------
# -- $Date:  2020/01/16  | $Author: Hartfiel, John
# -- -  update sw_run_vitis
# ------------------------------------------
# -- $Date: 2020/02/04  | $Author: Hartfiel, John
# -- - add TE0835 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2020/02/26  | $Author: Hartfiel, John
# -- - rework pr_init_hardware_manager, replace pr_program_flash_mcs and pr_program_flash_bin with pr_program_flash
# ------------------------------------------
# -- $Date: 2020/03/11  | $Author: Hartfiel, John
# -- - add TE0823 to "beta_hw_create_board_part"
# ------------------------------------------
# -- $Date: 2020/03/16  | $Author: Hartfiel, John
# -- - beta_hw_create_board_part bugfix
# ------------------------------------------
# -- $Date: 2020/06/08  | $Author: Hartfiel, John
# -- - beta_hw_create_board_part TE0830_Z and optional path
# ------------------------------------------
# -- $Date: 2020/06/12  | $Author: Hartfiel, John
# -- - beta_hw_create_board_part TE0830_ZU and optional path
# ------------------------------------------
# -- $Date: 2020/06/29  | $Author: Hartfiel, John
# -- - pr_program_flash new parameter --> option to use def FSBL (bugfix for 19.2 and still programmed flash)
# ------------------------------------------
# -- $Date: 2020/07/10  | $Author: Hartfiel, John
# -- - add TE::INIT::init_app_list to sw_run_vitis so csv file changes will be updated directly
# ------------------------------------------
# -- $Date: 2021/12/13  | $Author: Hartfiel, John
# -- - add no_gui mode to util_zip_project
# ------------------------------------------
# -- $Date: 2021/12/14  | $Author: Hartfiel, John
# -- - add sw_run_plx as betaversion
# -- - removed beta_util_sdsoc_project
# ------------------------------------------
# -- $Date: 2021/12/17  | $Author: Hartfiel, John
# -- - add util_terminal util_editor
# ------------------------------------------
# -- $Date: 2022/01/04  | $Author: Hartfiel, John
# -- - modify sw_run_plx
# ------------------------------------------
# -- $Date: 2022/01/06  | $Author: Hartfiel, John
# -- - modify util_editor
# ------------------------------------------
# -- $Date: 2022/01/17  | $Author: Hartfiel, John
# -- - modify sw_run_plx
# ------------------------------------------
# -- $Date: 2022/01/20  | $Author: Hartfiel, John
# -- - modify sw_run_plx with bootscr_opt parameter
# ------------------------------------------
# -- $Date: 2022/01/21  | $Author: Hartfiel, John
# -- - pr_program_flash use default FSBL for programming. special fsbl only with -flash_fsbl arg.
# ------------------------------------------
# -- $Date: 2022/02/28  | $Author: Hartfiel, John
# -- - pr_init_hardware_manager add quiet option
# ------------------------------------------
# -- $Date: 2022/05/04  | $Author: Hartfiel, John
# -- - util_zip_project add customer export with project revision
# ------------------------------------------
# -- $Date: 2022/07/27  | $Author: Hartfiel, John
# -- - pr_program_jtag_bitfile disable hw copy from vivado
# ------------------------------------------
# -- $Date: 2022/10/26  | $Author: Kirberg, Markus
# -- - sw_run_vitis: rerurn check_bdtyp to allow running standalone
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# source in namespace of TE
namespace eval ::TE {
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
        
          default    {TE::UTILS::te_msg TE_UTIL-79 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    if {$run_help} {
      set te_txt "TE Script Help: \n\
      Description:\n\
      \  Display currently available user functions\n\
      Syntax:\n\
      \  help \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-help\]     Print help.\n\
      Categories:\n\
      \  TE\n\
      "
      TE::UTILS::te_msg TE_INIT-93 STATUS $te_txt
    } else {
      TE::INIT::print_version
      set te_txt "TE Script Help:\n\
      Available TE-Functions:"
      if {![catch {set projectname [get_projects]} result]} {
        set te_txt "$te_txt\n\
        \  ---------------------------------\n\
        \  Beta Test (advanced usage only!):\n\
        \    TE::ADV::beta_hw_remove_board_part \[-permanent\] \[-help\]\n\
        \    TE::ADV::beta_hw_export_rtl_ip \[-help\]\n\
        \    TE::ADV::beta_hw_create_board_part \[-series  <arg>\] \[-all\] \[-preset\] \[-existing_ps\] \[-help\]\n\
        \    TE::ADV::beta_hw_export_binary \[-mode  <arg>\] \[-app  <arg>\] \[-folder   <arg>\] \[-all\] \[-help\]"
      }
      set te_txt "$te_txt\n\
      \  ----------\n\
      \  Utilities:\n\
      \    TE::util_zip_project \[-save_all\] \[-remove_prebuilt\] \[-manual_filename <arg>\] \[-help\]\n\
      \    TE::util_editor \[-file <arg>\] \[-help\]\n\
      \    TE::util_terminal \[-help\]\n\
      \    TE::util_package_length \[-help\]\n\
      \  ------------\n\
      \  Programming:\n\
      \    TE::pr_init_hardware_manager \[-disconnect\] \[-setup <arg>\] \[-help\]\n\
      \    TE::pr_program_jtag_bitfile \[-used_board <arg>\] \[-swapp <arg>\] \[-available_apps\] \[-used_basefolder_bitfile\] \[-help\]\n\
      \    TE::pr_program_flash \[-swapp <arg>\] \[-swapp_av\] \[-reboot\] \[-erase\] \[-setup\] \[-used_board\] \[-basefolder\] \[-def_fsbl\] \[-flash_fsbl\] \[-help\]\n\
      \    TE::pr_putty \[-available_com\] \[-com\] \[-speed\] \[-help\]"
      if {![catch {set projectname [get_projects]} result]} {
        # # on vivado project
        set te_txt "$te_txt\n\
        \  ----------\n\
        \  Software Design:\n\
        \    TE::sw_run_plx \[-run\] \[-config\] \[-u-boot\] \[-kernel\] \[-rootfs\] \[-bootscr_opt <arg1> <arg2> <arg3> <arg4>\] \[-devicetree  <arg>\] \[-app  <arg>\] \[-disable_clear\] \[-clear\] \[-help\]\n\
        \    TE::sw_run_vitis \[-all\] \[-gui_only\] \[-no_gui\] \[-workspace_only\] \[-prebuilt_xsa_only\] \[-prebuilt_xsa <arg>\] \[-clear\] \[-help\]\n\
        \  ----------\n\
        \  Hardware Design:\n\
        \    TE::hw_blockdesign_create_bd \[-bd_name\] \[-msys_local_mem\] \[-msys_ecc\] \[-msys_cache\] \[-msys_debug_module\] \[-msys_axi_periph\] \[-msys_axi_intc\] \[-msys_clk\] \[-help\]\n\
        \    TE::hw_blockdesign_export_tcl \[-no_mig_contents\] \[-no_validate\] \[-mod_tcl\] \[-svntxt <arg>\]  \[-board_part_only\] \[-help\]\n\
        \    TE::hw_build_design \[-disable_synth\] \[-disable_bitgen\] \[-disable_hdf\] \[-disable_mcsgen\] \[-disable_reports\] \[-export_prebuilt\] \[-export_prebuilt_only\] \[-help\]"
      }
      set te_txt "$te_txt\n\
      ------------------------------------------\n\
      Note:Run only predefined TE-functions from this list. Run other TE-functions directly may cause errors.\n\
      Note:For more Informations see Trenz Electronic Wiki: https://wiki.trenz-electronic.de/display/PD/Project+Delivery \n\
      ------------------------------------------\n\
      "  
       TE::UTILS::te_msg TE_INIT-94 STATUS $te_txt
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
          default               {TE::UTILS::te_msg TE_UTIL-80 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    if {$run_help} {
      set te_txt "TE Script Create Block Design: \n\
      Description:\n\
      \  Create new Block Design with specified name. \n\
      \  Special Block Design names: \n\
      \  fsys  -> used for FPGA-Fabric Design only. Generate empty Block Design. \n\
      \  msys  -> used for Microblaze Design only. Generate Microblaze with defined parameters. \n\
      \  zsys  -> used for 7Series Zynq Design only. Generate 7 Series Zynq with Board Part configuration and Carrier Board extended settings (if available). \n\
      \  zusys -> used for UltraScale Plus Zynq Design only. Generate UltraScale Plus Zynq with Board Part configuration and Carrier Board extended settings (if available). \n\
      Syntax:\n\
      \  TE::hw_blockdesign_create_bd \[-bd_name\] \[-msys_local_mem\] \[-msys_ecc\] \[-msys_cache\] \[-msys_debug_module\] \[-msys_axi_periph\] \[-msys_axi_intc\] \[-msys_clk\] \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-help\]               Print help.\n\
      \  \[-bd_name\]            Use one of the predefined names (def:fsys): fsys, msys, zsys, zusys \n\
      \  \[-msys_local_mem\]     Use one of the predefined values(def:8KB): None, 4KB, 8KB, 16KB, 32KB, 64KB, 128KB \n\
      \  \[-msys_ecc\]           Use one of the predefined values(def:None): None, Basic, Full \n\
      \  \[-msys_cache\]         Use one of the predefined values(def:None): None, 4KB, 8KB, 16KB, 32KB, 64KB \n\
      \  \[-msys_debug_module\]  Use one of the predefined values(def:Debug Only): None, Debug Only, \"Debug \& UART\", \"Extended Debug\" \n\
      \  \[-msys_axi_periph\]    Use one of the predefined values(def:Enabled): Disabled, Enabled \n\
      \  \[-msys_axi_intc\]      Use one of the predefined values(def:0): 0, 1 \n\
      \  \[-msys_clk\]           Use one of the predefined values(def:None): None, \"New Clocking Wizard (100 MHz)\", \"New External Port (100 MHz)\" \n\
      Categories:\n\
      \  TE::VIV\n\
      "
      TE::UTILS::te_msg TE_BD-19 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_BD-20 STATUS "Start Create Block Design."
      # m_settings only used for msys
      set m_settings {local_mem $msys_local_mem ecc $msys_ecc cache $msys_cache debug_module $msys_debug_module axi_periph $msys_axi_periph axi_intc $msys_axi_intc  clk $msys_clk}
      if {[catch {TE::VIV::create_new_blockdesign $bd_name $m_settings } result]} {TE::UTILS::te_msg TE_BD-21 ERROR "Script (TE::VIV::create_new_blockdesign) failed: $result."; return -code error}
      TE::UTILS::te_msg TE_BD-22 STATUS "Create Block Design finished."
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
          default               {TE::UTILS::te_msg TE_UTIL-81 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    if {$run_help} {
      set te_txt "TE Script Export Block Design: \n\
      Description:\n\
      \  Export Block Design as TCL-file. \n\
      \  File destination is $TE::BD_PATH or ${TE::BD_PATH}/${TE::SHORTDIR}/, if sub-folder exists. \n\
      \  If ${TE::BD_PATH}/${TE::SHORTDIR}/  exists, Block Designs from $TE::BD_PATH are ignored on project creation. \n\
      \  Attention: Open block-design will be saved automatically before export is run.\n\
      Syntax:\n\
      \  TE::hw_blockdesign_export_tcl \[-no_mig_contents\] \[-no_validate\] \[-mod_tcl\] \[-svntxt <arg>\] \[-board_part_only\] \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-no_mig_contents\]  Vivado specific option when MIG is used: MIG-Configuration is excluded from TCL-File. Reference to mig.prj is used instead. Wrong usage will damaged design functionality!\n\
      \  \[-no_validate\]      Design is saved without validation.\n\
      \  \[-board_part_only\]  Export for this bord part only (tcl is stored in ${TE::BD_PATH}/${TE::SHORTDIR}/). \n\
      \  \[-mod_tcl\]          TCL Content would be modified with content from $TE::BD_PATH\\mod_bd.tcl. If mod_bd.tcl don't exist or all commands inside are commented, nothing is changed. Wrong usage will damaged design functionality!  \n\
      \  \[-svntxt <arg>\]     Send svn commit with Text <arg>if SVN-versioning is used for the files in $TE::BD_PATH.\n\
      \  \[-help\]             Print help.\n\
      Categories:\n\
      \  TE::VIV, TE::UTILS, TE::EXT\n\
      "
      TE::UTILS::te_msg TE_BD-23 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_BD-24 STATUS "Start Export Block Design."
      if {[catch {TE::VIV::export_blockdesign $no_mig $no_validate $boardpart_only $mod_tcl} result]} {TE::UTILS::te_msg TE_BD-24 ERROR "Script (TE::VIV::export_blockdesign) failed: $result."; return -code error}
      if {$svn_check} {
        if {[catch {TE::EXT::svn_checkin ${TE::BD_PATH} $svn_msg} result]} {TE::UTILS::te_msg TE_BD-25 ERROR "Script (TE::EXT::svn_checkin) failed: $result."; return -code error}
      }
      TE::UTILS::te_msg TE_BD-26 STATUS "Export Block Design finished."
    }
  }
  #--------------------------------
  #--hw_build_design:  
  proc hw_build_design {{args ""}} {
    set run_build true
    set synthgen true
    set bitgen true
    set mcsgen true
    set reportgen true
    set hdfgen true
    set export_prebuild false
    set run_help false
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-disable_synth"           { set synthgen false}
        "-disable_bitgen"          { set bitgen false}
        "-disable_hdf"             { set hdfgen false}
        "-disable_mcsgen"          { set mcsgen false}
        "-disable_reports"         { set reportgen false}
        "-export_prebuilt_only"    { set export_prebuild true; set run_build false}
        "-export_prebuilt"         { set export_prebuild true}
        "-help"		                 { set run_help true}
          default    {TE::UTILS::te_msg TE_UTIL-82 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    } 
    if {$run_help} {
      set te_txt "TE Script Build Design: \n\
      Description:\n\
      \  Run Synthesises and Implementation with Bitstream generation. \n\
      \  Generate BIT-File on all BD-Names and MCS-File only on none Zynq/UltraScale Systems. \n\
      Syntax:\n\
      \  TE::hw_build_design \[-disable_bitgen\] \[-disable_hdf\] \[-disable_mcsgen\] \[-disable_reports\] \[-export_prebuilt\] \[-export_prebuilt_only\] \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-disable_synth\]        Syntheses is disabled and forced up to date. \n\
      \  \[-disable_bitgen\]       Bit-File generation is disabled. \n\
      \  \[-disable_hdf\]          HDF-File generation is disabled(delete *.sysdef). \n\
      \  \[-disable_mcsgen\]       MCS-File generation for none Zynq/UltraScale Systems is disabled. \n\
      \  \[-disable_reports\]      Report-Files generation for prebuilt folder is disabled. \n\
      \  \[-export_prebuilt\]      Export generated HW-Files to the prebuilt folder (copy is done automatically, when hsi, sdk or jtag programming scripts starts in VIVADO). \n\
      \  \[-export_prebuilt_only\] Export generated HW-Files to the prebuilt folder without rebuild the design. \n\
      \  \[-help\]                 Print help.\n\
      Categories:\n\
      \  TE::VIV,TE::UTILS\n\
      "
      TE::UTILS::te_msg TE_HW-59 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_HW-60 STATUS "Start Build Design."
      if {$run_build} {
        if {[catch {TE::VIV::build_design $synthgen $bitgen $mcsgen $reportgen $hdfgen} result]} {TE::UTILS::te_msg TE_HW-61 ERROR "Script (TE::VIV::build_design) failed: $result."; return -code error}
      }
      # copy is done if hsi, sdk or jtag programming is started or
      if {$export_prebuild} {
        if {[catch {TE::VIV::write_platform} result]} {TE::UTILS::te_msg TE_HW-97 ERROR "Script (TE::VIV::write_platform) failed: $result."; return -code error}
        if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} {TE::UTILS::te_msg TE_HW-62 ERROR "Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
        if {[catch {TE::UTILS::copy_hw_reports} result]} {TE::UTILS::te_msg TE_HW-63 INFO "No Hardware Reports found."}
      }
      TE::UTILS::te_msg TE_HW-64 STATUS "Build Design finished."
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
  # proc sw_run_hsi {{args ""}} {
    # set run_help false
    # set run_copy true
    # set run_clear false
    # set run_prebuilt false
    # set run_prebuilt_hdf_only false
    # set run_hsi true
    # set run_bif true
    # set run_bin true
    # set force_bin false
    # set run_bitmcs true
    # set prebuilt_name ${TE::ID}
    # set args_cnt [llength $args]
    # for {set option 0} {$option < $args_cnt} {incr option} {
        # switch [lindex $args $option] { 
        # "-run_only"  { set run_copy false}
        # "-prebuilt_hdf"	  { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        # "-prebuilt_hdf_only"	  { incr option; set run_prebuilt_hdf_only true}
        # "-no_hsi"		  { set run_hsi false}
        # "-no_bif"		  { set run_bif false}
        # "-no_bin"		  { set run_bin false}
        # "-no_bitmcs"  { set run_bitmcs false}
        # "-force_bin"		  { set force_bin true}
        # "-clear"		  { set run_clear true}
        # "-help"		    { set run_help true}
          # default     {TE::UTILS::te_msg TE_UTIL-83 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        # }
    # }
    # if {$run_help} {
      # set te_txt "TE Script Run HSI: \n\
      # Description:\n\
      # \  Start HSI and create all software apps (*elf) and corresponding boot.bif and boot.bin (for Zynq/UZynq only) or <app>.bit and <app>.mcs (for MicroBlaze only), which are specified in apps_list.csv\n\
      # \  Copy HW File and reports from the vivado project to the prebuilt folder if -prebuild_hdf <arg> isn't set (default)\n\
      # \  *.hdef and *.sysdef are ignored if BD-Name is fsys (Without processor system). \n\
      # \  Attention: Need SDK installation! \n\
      # Syntax:\n\
      # \  TE::sw_run_hsi \[-run_only\]  \[-prebuilt_hdf_only\] \[-prebuilt_hdf <arg>\] \[-no_hsi\] \[-no_bif\] \[-no_bin\] \[-no_bitmcs\] \[-clear\] \[-help\]\n\
      # Returns:\n\
        # No return value.\n\
      # Usage:\n\
      # \  Name          Description\n\
      # \  -------------------------\n\
      # \  \[-prebuilt_hdf_only\]  used *.bit and *.hdf from prebuilt folder from the current board selection instead of vivado project \n\
      # \  \[-prebuilt_hdf <arg>\] used *.bit and *.hdf from prebuilt folder instead of vivado project. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used. \n\
      # \  \[-run_only\]           used old data in workspace (*.bit and *.hdf)\n\
      # \  \[-no_hsi\]             disable *.elf generation\n\
      # \  \[-no_bif\]             disable boot.bif generation (for Zynq System only)\n\
      # \  \[-no_bin\]             disable boot.bin generation (for Zynq System only)\n\
      # \  \[-force_bin\]          disabllefor Zynq check for bif and bin generation\n\
      # \  \[-no_bitmcs\]          disable {appname}.bit and <appname>.mcs (for MicroBlaze System only) generation\n\
      # \  \[-clear\]              delete old data (prebuilt SW and workspace) before workspace is created\n\
      # \  \[-help\]               Print help.\n\
      # Categories:\n\
      # \  TE::UTILS, TE::EXT\n\
      # "
      # TE::UTILS::te_msg TE_SW-39 STATUS $te_txt
    # } else {
      # TE::UTILS::te_msg TE_SW-40 STATUS "Start HSI."
      # if {$run_clear} {
        # if {[catch {TE::UTILS::clean_workspace_hsi} result]} {TE::UTILS::te_msg TE_SW-41 ERROR "Script (TE::UTILS::clean_workspace_hsi) failed: $result."; return -code error}
        # if {[catch {TE::UTILS::clean_prebuilt_sw_single} result]} {TE::UTILS::te_msg TE_UTIL-138 ERROR "Script (TE::UTILS::clean_prebuilt_sw_single) failed: $result."; return -code error}
      # }
      
      # if {$run_hsi} {
        # if {$run_copy} {
          # if {$run_prebuilt} {
            # if {[catch {TE::UTILS::generate_workspace_hsi $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-42 ERROR "Script (TE::UTILS::generate_workspace_hsi) failed: $result."; return -code error}
          # } elseif {$run_prebuilt_hdf_only} {
            # # if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} {TE::UTILS::te_msg TE_SW-43 ERROR "Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
            # # if {[catch {TE::UTILS::copy_hw_reports} result]} {TE::UTILS::te_msg TE_SW-44 INFO "No Hardware Reports found. "}
            # if {[catch {TE::UTILS::generate_workspace_hsi $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-45 ERROR "Script (TE::UTILS::generate_workspace_hsi) failed: $result."; return -code error}
          # } else {
            # if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} {TE::UTILS::te_msg TE_SW-46 ERROR "Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
            # if {[catch {TE::UTILS::copy_hw_reports} result]} {TE::UTILS::te_msg TE_SW-47 INFO "No Hardware Reports found. "}
            # if {[catch {TE::UTILS::generate_workspace_hsi} result]} {TE::UTILS::te_msg TE_SW-48 ERROR "Script (TE::UTILS::generate_workspace_hsi) failed: $result."; return -code error}
          # }
        # }
        # if {[catch {TE::EXT::run_hsi} result]} {TE::UTILS::te_msg TE_SW-49 ERROR "Script (TE::EXT::run_hsi) failed: $result."; return -code error}
      # }
      # if {$TE::IS_ZSYS || $TE::IS_ZUSYS || $force_bin} {
        # #.bif and .bin only on zynq systems
        # if {$run_bif} {
          # if {[catch {TE::EXT::generate_bif_files $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-50 ERROR "Script (TE::EXT::generate_bif_files) failed: $result."; return -code error}
        # }
        # if {$run_bin} {
          # if {[catch {TE::EXT::generate_bootbin $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-51 ERROR "Script (TE::EXT::generate_bootbin) failed: $result."; return -code error}
        # }
      # } elseif {$TE::IS_MSYS} {
        # if {$run_bitmcs} {
          # if {[catch {TE::EXT::generate_app_bit_mcs $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-52 ERROR "Script (TE::EXT::generate_app_bit_mcs) failed: $result."; return -code error}
        # }
      # } else {
      # set te_txt "Boot.bif and Boot.bin only for Zynq-FPGAs available. <app>.bit and <app>.mcs only for MicroBlaze available. System will be checked with block design name, current BD file name is $TE::BD_TCLNAME .Use:\n\
      # \  \"zsys_bd.tcl\" for Systems with Zynq \n\
      # \  \"zusys_bd.tcl\" for Systems with UltraScale Zynq\n\
      # \  \"msys_bd.tcl\" for Systems with MicroBlaze\n\
      # \  \"fsys_bd.tcl\" for Systems with FPGA-Fabric design only\n\
      # "
      # TE::UTILS::te_msg TE_SW-53 INFO $te_txt
      # }
      # TE::UTILS::te_msg TE_SW-54 STATUS "HSI finished."
    # }
  # }
  #--------------------------------
  #--sw_run_sdk:  
  # proc sw_run_sdk {{args ""}} {
    # set run_help false
    # set run_copy true
    # set start_sdk true
    # set run_clear false
    # set run_prebuilt false
    # set run_prebuilt_only false
    # set prebuilt_name ${TE::ID}
    # set args_cnt [llength $args]
    # for {set option 0} {$option < $args_cnt} {incr option} {
        # switch [lindex $args $option] { 
        # "-open_only"          { set run_copy false}
        # "-update_hdf_only"    { set start_sdk false}
        # "-prebuilt_hdf"       { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        # "-prebuilt_hdf_only"  { incr option; set run_prebuilt_only true}
        # "-clear"		          { set run_clear true}
        # "-help"		            { set run_help true}
          # default             {TE::UTILS::te_msg TE_UTIL-84 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        # }
    # }
    # if {$run_help} {
      # set te_txt "TE Script Run SDK: \n\
      # Description:\n\
      # \  Start SDK project in external folder $TE::WORKSPACE_SDK_PATH\n\
      # \  Copy HW File and reports from the vivado project to the prebuilt folder if -prebuild_hdf <arg> isn't set (default)\n\
      # \  *.hdef and *.sysdef are ignored if BD-Name is fsys (Without processor system). \n\
      # \  Attention: If you use VIVADO GUI Command (File->Export-> Export Hardware..(Include Bit-file!) or File->Launch SDK) to Update or open SKD set new export path and workspace: $TE::WORKSPACE_SDK_PATH\n\
      # \  Attention: Need SDK installation! \n\
      # Syntax:\n\
      # \  TE::sw_run_sdk \[-open_only\] \[-update_hdf_only\] \[-prebuilt_hdf_only\] \[-prebuilt_hdf <arg>\] \[-clear\] \[-help\]\n\
      # Returns:\n\
      # \  No return value.\n\
      # Usage:\n\
      # \  Name          Description\n\
      # \  -------------------------\n\
      # \  \[-prebuilt_hdf_only\]  used *.bit and *.hdf from prebuilt folder from the current board selection instead of vivado project. \n\
      # \  \[-prebuilt_hdf <arg>\] used *.hdf from prebuilt folder instead of vivado project. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used. \n\
      # \  \[-open_only\]          open SDK without update the *.hdf file \n\
      # \  \[-update_hdf_only\]    copy the new *.hdf file into the SDK workspace without open SDK\n\
      # \  \[-clear\]              delete old data before workspace is created\n\
      # \  \[-help\]               Print help.\n\
      # Categories:\n\
      # \  TE::UTILS, TE::EXT\n\
      # "
      # TE::UTILS::te_msg TE_SW-55 STATUS $te_txt
    # } else {
      # TE::UTILS::te_msg TE_SW-56 STATUS "Start SDK"
      # if {$run_clear} {
        # if {[catch {TE::UTILS::clean_workspace_sdk} result]} {TE::UTILS::te_msg TE_SW-57 ERROR "Script (TE::UTILS::clean_workspace_sdk) failed: $result."; return -code error}
      # }
      # if {$run_copy} {
        # if {$run_prebuilt} {
          # if {[catch {TE::UTILS::generate_workspace_sdk $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-58 ERROR "Script (TE::UTILS::generate_workspace_sdk) failed: $result."; return -code error}
        # } elseif {$run_prebuilt_only} {
          # if {[catch {TE::UTILS::generate_workspace_sdk $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-77 ERROR "Script (TE::UTILS::generate_workspace_sdk) failed: $result."; return -code error}
        # } else {
          # if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} {TE::UTILS::te_msg TE_SW-59 ERROR "Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
          # if {[catch {TE::UTILS::copy_hw_reports} result]} {TE::UTILS::te_msg TE_SW-60 INFO "No Hardware Reports found."}
          # if {[catch {TE::UTILS::generate_workspace_sdk} result]} {TE::UTILS::te_msg TE_SW-61 ERROR "Script (TE::UTILS::generate_workspace_sdk) failed: $result."; return -code error}
        # }
      # }
      # if {$start_sdk} {
        # if {[catch {TE::EXT::run_sdk} result]} {TE::UTILS::te_msg TE_SW-62 ERROR "Script (TE::EXT::run_sdk) failed: $result."; return -code error}
      # }
      # TE::UTILS::te_msg TE_SW-63 STATUS "SDK finished."
    # }
  # }
  #--------------------------------
  #--sw_run_vitis:  
  proc sw_run_vitis {{args ""}} {
    set run_help false
    set run_gui true
    set run_copy true
    set prepare_sdk true
    set workspace_only false
    set platform_only true
    set start_sdk true
    
    set run_xsct true
    set run_bif false
    set run_bin false
    set run_bitmcs false
    set force_bin false
    
    set run_clear true
    set run_prebuilt false
    set run_prebuilt_only false
    set prebuilt_name ${TE::ID}
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-no_gui"             { set start_sdk false}
        "-gui_only"           { set run_copy false; set prepare_sdk false; set run_clear false}
        "-workspace_only"     { set workspace_only true}
        "-all"                { set platform_only false;set run_xsct true; set run_bif true;  set run_bin true; set run_bitmcs true}
        "-prebuilt_xsa"       { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        "-prebuilt_xsa_only"  { incr option; set run_prebuilt_only true}
        "-bootgen_only"		    { set run_xsct false; set run_clear false; set run_bif true; set run_bin true; set start_sdk false}
        "-en_xsct"		        { set run_xsct true}
        "-en_bif"		          { set run_bif true}
        "-en_bin"		          { set run_bin true}
        "-en_bitmcs"		      { set run_bitmcs true}
        "-dis_xsct"		        { set run_xsct false}
        "-dis_bif"		        { set run_bif false}
        "-dis_bin"		        { set run_bin false}
        "-dis_bitmcs"		      { set run_bitmcs false}
        "-force_bin"		      { set force_bin true}
        "-clear"		          { set run_clear true}
        "-keep"		            { set run_clear false}
        "-help"		            { set run_help true}
          default             {TE::UTILS::te_msg TE_UTIL-84 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    # puts "Test: |${prebuilt_name}|run_prebuilt_only${run_prebuilt_only}|run_prebuilt${run_prebuilt}|run_clear${run_clear}|force_bin${force_bin}|run_bitmcs${run_bitmcs}|run_bin${run_bin}|run_bif${run_bif}|run_xsct${run_xsct}|start_sdk${start_sdk}|platform_only${platform_only}|workspace_only${workspace_only}|prepare_sdk${prepare_sdk}|run_copy${run_copy}|run_gui${run_gui}|run_help${run_help}"

    if { [ string match "" $prebuilt_name ]} {
      # in case -prebuilt_xsa is used as last arg without parameter --> same like -prebuilt_xsa_only
       set prebuilt_name ${TE::ID}
    }

    
    if {$run_help} {
      set te_txt "TE Script run Vitis: \n\
      Description:\n\
      \  Start Vitis project in external folder $TE::WORKSPACE_SDK_PATH\n\
      \  Copy HW File and reports from the vivado project to the prebuilt folder if -prebuild_xsa <arg> isn't set (default)\n\
      \  Attention: If you use VIVADO GUI Command (File->Export-> Export Hardware..(Include Bit-file!)) to update or open Vitis set new export path and workspace to: $TE::WORKSPACE_SDK_PATH\n\
      \  Attention: Need VITIS installation! \n\
      Syntax:\n\
      \  TE::sw_run_vitis \[-all\] \[-gui_only\] \[-no_gui\] \[-workspace_only\] \[-prebuilt_xsa_only\] \[-prebuilt_xsa <arg>\] \[-clear\] \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-all\]                create platform and all apps from CSV files\n\
      \  \[-gui_only\]           open VITIS on $TE::WORKSPACE_SDK_PATH without any other task\n\
      \  \[-no_gui\]             Vitis GUI disable --> use for background generation \n\
      \  \[-workspace_only\]     open VITIS with *.xsa file on $TE::WORKSPACE_SDK_PATH  \n\
      \  \[-prebuilt_xsa_only\]  used *.bit and *.xsa from prebuilt folder from the current board selection instead of vivado project. \n\
      \  \[-prebuilt_xsa <arg>\] used *.xsa from prebuilt folder instead of vivado project. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used. \n\
      \  \[-bootgen_only\]       regenerate Boot.bin only (same like TE::sw_run_vitis -dis_xsct -keep -en_bif -en_bin -no_gui)\n\
      \  \[-en_xsct\]            enable vitis project generation\n\
      \  \[-en_bif\]             enable bif file generation\n\
      \  \[-en_bin\]             enable bin file generation\n\
      \  \[-en_bitmcs\]          enable mcs file generation\n\
      \  \[-dis_xsct\]           disable vitis project generation\n\
      \  \[-dis_bif\]            disable bif file generation\n\
      \  \[-dis_bin\]            disable bin file generation\n\
      \  \[-dis_bitmcs\]         disable mcs file generation\n\
      \  \[-force_bin\]          force bin file generation\n\
      \  \[-clear\]              delete old data before workspace is created\n\
      \  \[-keep\]               do not delete older project(pay attention)\n\
      \  \[-help\]               Print help.\n\
      Categories:\n\
      \  TE::UTILS, TE::EXT\n\
      "
      TE::UTILS::te_msg TE_SW-81 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_SW-82 STATUS "Start SDK"
      
      if {[catch {TE::INIT::init_app_list} result]} {TE::UTILS::te_msg TE_INIT-205 ERROR "Script (TE::INIT::init_app_list) failed: $result."; return -code error}
      
      if {$run_clear} {
        if {[catch {TE::UTILS::clean_workspace_sdk} result]} {TE::UTILS::te_msg TE_SW-83 ERROR "Script (TE::UTILS::clean_workspace_sdk) failed: $result."; return -code error}
      }
      if {$run_copy} {
        if {$run_prebuilt} {
          if {[catch {TE::UTILS::generate_workspace_sdk $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-84 ERROR "Script (TE::UTILS::generate_workspace_sdk) failed: $result."; return -code error}
        } elseif {$run_prebuilt_only} {
          if {[catch {TE::UTILS::generate_workspace_sdk $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-85 ERROR "Script (TE::UTILS::generate_workspace_sdk) failed: $result."; return -code error}
        } else {
          if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} {TE::UTILS::te_msg TE_SW-86 ERROR "Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
          if {[catch {TE::UTILS::copy_hw_reports} result]} {TE::UTILS::te_msg TE_SW-87 INFO "No Hardware Reports found."}
          if {[catch {TE::UTILS::generate_workspace_sdk} result]} {TE::UTILS::te_msg TE_SW-88 ERROR "Script (TE::UTILS::generate_workspace_sdk) failed: $result."; return -code error}
        }
      }
      if {$prepare_sdk} {
        if {$run_xsct} {
          if {[catch {TE::EXT::run_xsct $workspace_only $platform_only} result]} {TE::UTILS::te_msg TE_SW-89 ERROR "Script (TE::EXT::run_xsct) failed: $result."; return -code error}
          if {[catch {TE::UTILS::copy_sw_files} result]} {TE::UTILS::te_msg TE_SW-92 ERROR "Script (TE::EXT::copy_sw_files) failed: $result."; return -code error}
        }
        #check bd file names for some additional functions 
        if {[catch {TE::INIT::check_bdtyp} result]} {TE::UTILS::te_msg TE_SW-21 Error "Script (TE::INIT::check_bdtyp) failed: $result."; return -code error}
        #check if this can be done directly with vitis
        if {$TE::IS_ZSYS || $TE::IS_ZUSYS || $force_bin} {
          #.bif and .bin only on zynq systems
          if {$run_bif} {
            if {[catch {TE::EXT::generate_bif_files $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-50 ERROR "Script (TE::EXT::generate_bif_files) failed: $result."; return -code error}
          }
          if {$run_bin} {
            if {[catch {TE::EXT::generate_bootbin $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-51 ERROR "Script (TE::EXT::generate_bootbin) failed: $result."; return -code error}
          }
        } elseif {$TE::IS_MSYS} {
          if {$run_bitmcs} {
            if {[catch {TE::EXT::generate_app_bit_mcs $prebuilt_name} result]} {TE::UTILS::te_msg TE_SW-52 ERROR "Script (TE::EXT::generate_app_bit_mcs) failed: $result."; return -code error}
          }
        } else {
          set te_txt "Boot.bif and Boot.bin only for Zynq-FPGAs available. <app>.bit and <app>.mcs only for MicroBlaze available. System will be checked with block design name, current BD file name is $TE::BD_TCLNAME .Use:\n\
          \  \"zsys_bd.tcl\" for Systems with Zynq \n\
          \  \"zusys_bd.tcl\" for Systems with UltraScale Zynq\n\
          \  \"msys_bd.tcl\" for Systems with MicroBlaze\n\
          \  \"fsys_bd.tcl\" for Systems with FPGA-Fabric design only\n\
          "
          TE::UTILS::te_msg TE_SW-53 INFO $te_txt
        }
      }
      if {$start_sdk} {
        if {[catch {TE::EXT::run_vitis_gui} result]} {TE::UTILS::te_msg TE_SW-90 ERROR "Script (TE::EXT::run_vitis_gui) failed: $result."; return -code error}
      }
      TE::UTILS::te_msg TE_SW-91 STATUS "Vitis finished."
    }
  }
  
  #--------------------------------
  #--sw_run_plx:  
  proc sw_run_plx {{args ""}} {
    set run_help false
    set run_plx false
    set config_plx false
    set uboot_plx false
    set kernel_plx false
    set rootfs_plx false
    set bootscr_plx false
    set devicetree_plx false
    set devicetree_typ "system"
    set app_plx false
    set app_name ""
    set clear_plx true
    
    #todo die default aus csv nehmen später
    set bootscr_type "def"
    set bootscr_imageub_addr "0x10000000"
    set bootscr_imageub_flash_addr "0x200000"
    set bootscr_imageub_flash_size "0xD90000"
    
    set prebuilt_name ${TE::ID}
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-run"               { set run_plx true;set bootscr_plx true;}
        "-config"            { set config_plx true;set clear_plx false}
        "-devicetree"        { set clear_plx false;incr option; set devicetree_plx true; set devicetree_typ [lindex $args $option]}
        "-u-boot"            { set clear_plx false; set uboot_plx true}
        "-kernel"            { set clear_plx false; set kernel_plx true}
        "-app"               { set clear_plx false; incr option; set app_plx true; set app_name [lindex $args $option]}
        "-rootfs"            { set clear_plx false; set rootfs_plx true}
        "-bootscr_opt"       { incr option; set bootscr_type [lindex $args $option]; if {[string match -nocase $bootscr_type "def"] } { set bootscr_plx true; } elseif {[string match -nocase $bootscr_type "ign"]} {set bootscr_plx false;} else {set bootscr_plx true; incr option; set bootscr_imageub_addr [lindex $args $option];incr option; set bootscr_imageub_flash_addr [lindex $args $option];incr option; set bootscr_imageub_flash_size [lindex $args $option];}}
        "-clear"             { set clear_plx true}
        "-disable_clear"     { set clear_plx false}
        "-help"		           { set run_help true}
          default             {TE::UTILS::te_msg TE_UTIL-?? ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    # puts "Test: |${prebuilt_name}|run_prebuilt_only${run_prebuilt_only}|run_prebuilt${run_prebuilt}|run_clear${run_clear}|force_bin${force_bin}|run_bitmcs${run_bitmcs}|run_bin${run_bin}|run_bif${run_bif}|run_xsct${run_xsct}|start_sdk${start_sdk}|platform_only${platform_only}|workspace_only${workspace_only}|prepare_sdk${prepare_sdk}|run_copy${run_copy}|run_gui${run_gui}|run_help${run_help}"

    if { [ string match "" $prebuilt_name ]} {
      # in case -prebuilt_xsa is used as last arg without parameter --> same like -prebuilt_xsa_only
       set prebuilt_name ${TE::ID}
    }

    #check bd file names for some additional functions 
    if {[catch {TE::INIT::check_bdtyp} result]} {TE::UTILS::te_msg TE_SW-21 Error "Script (TE::INIT::check_bdtyp) failed: $result."; return -code error}

    
    if {$run_help} {
      set te_txt "TE Script run Petalinux: \n\
      Description:\n\
      \  Start Petalinux project in external folder ${TE::PETALINUX_PATH}\n\
      \  Attention: This is a betaversion, on problems run petalinux commands independed from trenz scripts\n\
      \  Attention: Need petalinux and gvim installation and linux OS! \n\
      Syntax:\n\
      \  TE::sw_run_plx \[-run\] \[-config\] \[-u-boot\] \[-kernel\] \[-rootfs\] \[-devicetree  <arg>\] \[-app  <arg>\] \[-disable_clear\] \[-clear\] \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-run\]                                     Run whole petalinux project and export binaries to prebuilt os folder\n\
      \  \[-config\]                                  run petalinux-config\n\
      \  \[-devicetree <arg>\]                        open device tree with gvim  unse <arg>=system for linux and <arg>=u-boot for u-boot device tree\n\
      \  \[-u-boot\]                                  run petalinux-config -c u-boot\n\
      \  \[-kernel\]                                  run petalinux-config -c kernel\n\
      \  \[-app  <arg>\]                              run petalinux-create -t apps -n <arg> --enable Note this generates only simple hello world project which must be modified manually\n\
      \  \[-rootfs\]                                  run petalinux-config -c rootfs\n\
      \  \[-bootscr_opt <arg1> <arg2> <arg3> <arg4>\] change bootscr option(default will be run if not defined). arg1=def,ign,mod, if arg1=mod add also arg2=imageub_addr arg3=imageub_flash_addr arg4=imageub_flash_size \n\
      \  \[-clear\]                                   run project clearing\n\
      \  \[-disable_clear\]                           disable automatically project clearing after run\n\
      \  \[-help\]                                    Print help.\n\
      Categories:\n\
      \  TE::UTILS, TE::EXT\n\
      "
      TE::UTILS::te_msg TE_SW-98 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_SW-99 STATUS "Start Petalinux"
      #ask if linux env
      if {[string match [TE::UTILS::get_host_os] "unix"]} {
        if {$config_plx} {
          if {[catch {TE::::PLX::plx_config}  result]} {TE::UTILS::te_msg TE_SW-100 ERROR "Script (TE::::PLX::plx_config) failed: $result."; return -code error}
        }
        if {$devicetree_plx} {
          if {[string match "system" $devicetree_typ] || [string match "u-boot" $devicetree_typ]} {
            if {[catch {TE::::PLX::plx_device_tree  $devicetree_typ} result]} {TE::UTILS::te_msg TE_SW-101 ERROR "Script (TE::::PLX::plx_device_tree) failed: $result."; return -code error}
          } else {
            TE::UTILS::te_msg TE_SW-102 ERROR " Device type ($devicetree_typ), only system or u-boot are valid"
          }
        }
        if {$uboot_plx} {
          if {[catch {TE::::PLX::plx_uboot}  result]} {TE::UTILS::te_msg TE_SW-103 ERROR "Script (TE::::PLX::plx_uboot) failed: $result."; return -code error}
        }
        if {$kernel_plx} {
          if {[catch {TE::::PLX::plx_kernel}  result]} {TE::UTILS::te_msg TE_SW-104 ERROR "Script (TE::::PLX::plx_kernel) failed: $result."; return -code error}
        }
        if {$app_plx} {
          if {[catch {TE::::PLX::plx_app  $app_name} result]} {TE::UTILS::te_msg TE_SW-105 ERROR "Script (TE::::PLX::plx_app) failed: $result."; return -code error}
          
        }
        if {$rootfs_plx} {
          if {[catch {TE::::PLX::plx_rootfs}  result]} {TE::UTILS::te_msg TE_SW-106 ERROR "Script (TE::::PLX::plx_rootfs) failed: $result."; return -code error}
        }
        if {$run_plx} {
          TE::UTILS::te_msg TE_SW-111 INFO "Please wait building petalinux takes a long time"
          if {$clear_plx} {
            if {[catch {TE::::PLX::plx_clear}  result]} {TE::UTILS::te_msg TE_SW-112 ERROR "Script (TE::::PLX::plx_clear) failed: $result."; return -code error}
          }
          if {[catch {TE::::PLX::plx_run}  result]} {TE::UTILS::te_msg TE_SW-107 ERROR "Script (TE::::PLX::plx_run) failed: $result."; return -code error}
        }
        if {$bootscr_plx } {
          if {[catch {TE::::PLX::plx_bootsrc $bootscr_type $bootscr_imageub_addr $bootscr_imageub_flash_addr $bootscr_imageub_flash_size}  result]} {TE::UTILS::te_msg TE_SW-113 ERROR "Script (TE::::PLX::plx_bootsrc) failed: $result."; return -code error}
        }
        #clear (always only it's disabled)
        if {$clear_plx} {
          if {[catch {TE::::PLX::plx_clear}  result]} {TE::UTILS::te_msg TE_SW-108 ERROR "Script (TE::::PLX::plx_clear) failed: $result."; return -code error}
        }
      } else {
        TE::UTILS::te_msg TE_SW-109 {CRITICAL WARNING} "OS [TE::UTILS::get_host_os] is not supported for this functions, use linux OS. Petalinux generation will be skipped"
      }

      TE::UTILS::te_msg TE_SW-110 STATUS "Petalinux finished."
    }
  }
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished software generation functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # programming functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  #--------------------------------
  # #--pr_program_flash_binfile:  
  # proc pr_program_flash_binfile {{args ""}} {
    # set return_filename ""
    # set use_basefolder false
    # set use_sdk_flash true
    # set run_help false
    # set run_prebuilt false
    # set appname ""
    # set prebuilt_name ""
    # set print_available_apps false
    # set reboot true
    # set args_cnt [llength $args]
    # for {set option 0} {$option < $args_cnt} {incr option} {
        # switch [lindex $args $option] { 
        # "-no_reboot"                { set reboot false}
        # "-used_board"               { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        # "-swapp"                    { incr option; set appname [lindex $args $option]}
        # "-available_apps"           { set print_available_apps true}
        # "-force_hw_manager"         { set use_sdk_flash false}
        # "-used_basefolder_binfile"  {set use_basefolder true}
        # "-help"		                  { set run_help true}
          # default                   {TE::UTILS::te_msg TE_UTIL-85 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        # }
    # }
    # if {$run_help} {
      # set te_txt "TE Script Program Flash with Bin-File: \n\
      # Description:\n\
      # \  Programming specified FPGA-Flash with bin-file (Zynq-Processors only).\n\
      # \  It will be program the boot.bin from the corresponding prebuilt folder, which is set in the vivado project, if -used_board <arg> isn't set.\n\
      # Syntax:\n\
      # \ TE::pr_program_flash_binfile \[-no_reboot\] \[-used_board <arg>\] \[-swapp <arg>\] \[-available_apps\] \[-used_basefolder_binfile\] \[-help\]\n\
      # Returns:\n\
      # \  Programming file-name.\n\
      # Usage:\n\
      # \  Name          Description\n\
      # \  -------------------------\n\
      # \  \[-no_reboot\]                Memory will be only configured, no JTag reboot is done.\n\
      # \  \[-used_board <arg>\]         Used prebuilt folder board version instead of Vivado project settings. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used.\n\
      # \  \[-swapp <arg>\]              Software APP name which should be programmed.\n\
      # \  \[-available_apps\]           Return available software APP names from selected the prebuilt boot_images folder.\n\
      # \  \[-force_hw_manager\]         Force LabTools Hardware-Manager instead of SDK-Programmer. Boot.bin can be configured via SDK-Programmer or LabTools Hardware-Manager. If both available SDK-Programmer is used default. \n\
      # \  \[-used_basefolder_binfile\]  Use base-folder bin-file ($TE::BASEFOLDER). Should be only one *.bin!\n\
      # \  \[-help\]                     Print help.\n\
      # Categories:\n\
      # \  TE::EXT, TE::VLAB\n\
      # "
      # TE::UTILS::te_msg TE_PR-43 STATUS $te_txt
    # } else {
      # TE::UTILS::te_msg TE_PR-44 STATUS "Start Flash Programming with BIN File"
      # set starttime [clock seconds]
      # if {$print_available_apps} {
         # if {[catch {TE::EXT::get_available_apps $prebuilt_name} result]} {TE::UTILS::te_msg TE_PR-45 ERROR "Script (TE::EXT::get_available_apps) failed: $result."; return -code error}
      # } else {
        # if {$appname eq ""} {TE::UTILS::te_msg TE_PR-46 ERROR "No APP name is selected see \[pr_program_flash_binfile -help\]: $result."; return -code error}
        # if {$prebuilt_name ne ""} {
          # set id "[TE::BDEF::find_id $prebuilt_name]"
          # set zynqflashtyp_int [TE::BDEF::get_zynqflashtyp $id 0]
        # } else {
          # set zynqflashtyp_int $TE::ZYNQFLASHTYP
        # }
          
        # set check_zynqflash false
        # if {$zynqflashtyp_int ne "NA"} {
          # set check_zynqflash true
        # }
        
        # if {$::env(SDK_AVAILABLE) && $check_zynqflash && $use_sdk_flash} {
          # if {[catch {set return_filename [TE::EXT::excecute_zynq_flash_programming $use_basefolder $appname $prebuilt_name]} result]} {TE::UTILS::te_msg TE_PR-47 ERROR "Script (TE::EXT::excecute_zynq_flash_programming) failed: $result."; return -code error}
          # if {$reboot} {
            # set hw_close true
            # if {[catch {set hw_close [TE::VLAB::hw_open_jtag]} result]} {TE::UTILS::te_msg TE_PR-48 ERROR "Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}
            # if {[catch {TE::VLAB::hw_fpga_boot_from_memory $prebuilt_name} result]} {TE::UTILS::te_msg TE_PR-49 ERROR "Script (TE::VLAB::hw_fpga_boot_from_memory) failed: $result."; return -code error}
            # if {$hw_close} {
              # if {[catch {TE::VLAB::hw_close_jtag} result]} {TE::UTILS::te_msg TE_PR-50 ERROR "Script (TE::VLAB::hw_close_jtag) failed: $result."; return -code error}
            # }
          # }
        # } else {
          # set hw_close true
          # if {[catch {set hw_close [TE::VLAB::hw_open_jtag]} result]} {TE::UTILS::te_msg TE_PR-51 ERROR "Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}

          # if {[catch {TE::VLAB::hw_create_flash_device $prebuilt_name} result]} {TE::UTILS::te_msg TE_PR-52 ERROR "Script (TE::VLAB::hw_create_flash_device) failed: $result."; return -code error}
          # if {[catch {set return_filename [TE::VLAB::hw_program_fpga_flash $use_basefolder "" bin $appname $prebuilt_name]} result]} {TE::UTILS::te_msg TE_PR-53 ERROR "Script (TE::VLAB::hw_program_fpga_flash) failed: $result."; return -code error}
 
          # if {$reboot} {
            # if {[catch {TE::VLAB::hw_fpga_boot_from_memory $prebuilt_name} result]} {TE::UTILS::te_msg TE_PR-54 ERROR "Script (TE::VLAB::hw_fpga_boot_from_memory) failed: $result."; return -code error}
          # }
          # if {$hw_close} {
            # if {[catch {TE::VLAB::hw_close_jtag} result]} {TE::UTILS::te_msg TE_PR-55 ERROR "Script (TE::VLAB::hw_close_jtag) failed: $result."; return -code error}
          # }
        # }
      # }
      # set stoptime [clock seconds]
      # set timeelapsed [expr $stoptime -$starttime]
      # TE::UTILS::te_msg TE_PR-56 INFO "Programming elapsed time: $timeelapsed seconds"
      # TE::UTILS::te_msg TE_PR-57 STATUS "Flash Programming with BIN File finished"
    # }
    # return $return_filename
  # }
  # #--------------------------------
  # #--pr_program_flash_mcsfile:  
  # proc pr_program_flash_mcsfile {{args ""}} {
    # set return_filename ""
    # set run_help false
    # set run_prebuilt false
    # set appname ""
    # set prebuilt_name ""
    # set print_available_apps false
    # set reboot true
    # set term "pull-none"
    # set use_basefolder false
      # #pull-none  (default)#pull-up #pull-down
    # set args_cnt [llength $args]
    # for {set option 0} {$option < $args_cnt} {incr option} {
        # switch [lindex $args $option] { 
        # "-no_reboot"                { set reboot false}
        # "-used_board"               { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        # "-unused_io_termination"    { incr option; set term [lindex $args $option]}
        # "-swapp"                    { incr option; set appname [lindex $args $option]}
        # "-available_apps"           { set print_available_apps true}
        # "-used_basefolder_mcsfile"  {set use_basefolder true}
        # "-help"		                  { set run_help true}
          # default                   {TE::UTILS::te_msg TE_UTIL-86 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        # }
    # }
    # if {$run_help} {
      # set te_txt "TE Script Program Flash with MCS File: \n\
      # Description:\n\
      # \  Programming specified FPGA-Flash with mcs-File (No Zynq-Processors only).\n\
      # \  It will be program the <project_name>.mcs from the corresponding prebuilt folder which is set in the vivado/labtool project, if -used_board <arg> isn't set. \n\
      # Syntax:\n\
      # \  TE::pr_program_flash_mcsfile \[-no_reboot\] \[-used_board <arg>\] \[-unused_io_termination <arg>\] \[-swapp <arg>\] \[-available_apps\] \[-used_basefolder_mcsfile\] \[-help\]\n\
      # Returns:\n\
      # \  Programming file-name.\n\
      # Usage:\n\
      # \  Name          Description\n\
      # \  -------------------------\n\
      # \  \[-no_reboot\]                    Memory will be only configured, no JTag reboot is done.\n\
      # \  \[-used_board <arg>\]             Used prebuilt folder board version instead of vivado project settings. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used.\n\
      # \  \[-unused_io_termination <arg>\]  Set termination for unused Device IO-Pins Available Settings are: pull-none, pull-up or pull-down. Default pull-none is used.\n\
      # \  \[-swapp <arg>\]                  Software app name which should be programmed(If app name isn't set, the mcs-file from the prebuilt hardware folder is used). \n\
      # \  \[-available_apps\]               Return available software app names from selected the prebuilt boot_images folder.\n\
      # \  \[-used_basefolder_mcsfile\]      Use base-folder mcs-file ($TE::BASEFOLDER). Should be only one *.mcs!\n\
      # \  \[-help\]                         Print help.\n\
      # Categories:\n\
      # \  TE::EXT, TE::VLAB\n\
      # "
      # TE::UTILS::te_msg TE_PR-58 STATUS $te_txt
    # } else {
      # TE::UTILS::te_msg TE_PR-59 STATUS "Start Flash Programming with BIN File"
      # set starttime [clock seconds]
      # if {$print_available_apps} {
        # if {[catch {TE::EXT::get_available_apps $prebuilt_name} result]} {TE::UTILS::te_msg TE_PR-60 ERROR "Script (TE::EXT::get_available_apps) failed: $result."; return -code error}
      # } else {
        # if {!$run_prebuilt} {
          # if {![catch {set projectname [get_projects]} result]} {
            # #copy only on vivado project
            # if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} {TE::UTILS::te_msg TE_PR-61 ERROR "Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
            # if {[catch {TE::UTILS::copy_hw_reports} result]} {TE::UTILS::te_msg TE_PR-62 INFO "No Hardware Reports found."}
          # }
        # }
        # set hw_close true
        # if {[catch {set hw_close [TE::VLAB::hw_open_jtag]} result]} {TE::UTILS::te_msg TE_PR-63 ERROR "Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}

        # if {[catch {TE::VLAB::hw_create_flash_device $prebuilt_name} result]} {TE::UTILS::te_msg TE_PR-64 ERROR "Script (TE::VLAB::hw_create_flash_device) failed: $result."; return -code error}
        # if {[catch {set return_filename [TE::VLAB::hw_program_fpga_flash $use_basefolder $term mcs $appname $prebuilt_name]} result]} {TE::UTILS::te_msg TE_PR-65 ERROR "Script (TE::VLAB::hw_program_fpga_flash) failed: $result."; return -code error}

        # if {$reboot} {
          # if {[catch {TE::VLAB::hw_fpga_boot_from_memory $prebuilt_name} result]} {TE::UTILS::te_msg TE_PR-66 ERROR "Script (TE::VLAB::hw_fpga_boot_from_memory) failed: $result."; return -code error}
        # }
        # if {$hw_close} {
          # if {[catch {TE::VLAB::hw_close_jtag} result]} {TE::UTILS::te_msg TE_PR-67 ERROR "Script (TE::VLAB::hw_close_jtag) failed: $result."; return -code error}
        # }
      # }
      # set stoptime [clock seconds]
      # set timeelapsed [expr $stoptime -$starttime]
      # TE::UTILS::te_msg TE_PR-68 INFO "Programming elapsed time: $timeelapsed seconds"
      # TE::UTILS::te_msg TE_PR-69 STATUS "Flash Programming with BIN File finished."
    # }
    # return $return_filename
  # }
  #--------------------------------
  #--pr_program_flash:  
  proc pr_program_flash {{args ""}} {
    set return_filename ""
    set prebuilt_name ""
    
    set run_help false
    set def_fsbl true
    set swreboot false
    set setup 011001
    set swapp ""
    set swapp_av true
    set force_sdk false  
    #todo vitis as alternative
    set erase false
    set use_basefolder false
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-setup"		      {incr option; set setup [lindex $args $option]}
        "-swapp"		      {incr option; set swapp [lindex $args $option]; set swapp_av false}
        "-swapp_av"       {}
        "-reboot"		      {set swreboot true}
        "-force_vitis"	  {set force_sdk true}
        "-erase"	        {set erase true; set swapp_av false}
        "-basefolder"	    {set use_basefolder true; set swapp_av false}
        "-used_board"     { incr option; set run_prebuilt true; set prebuilt_name [lindex $args $option]}
        "-help"		        { set run_help true}
        "-def_fsbl"	      { set def_fsbl true}
        "-flash_fsbl"	      { set def_fsbl false}
          default         {TE::UTILS::te_msg TE_UTIL-157 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    if {$run_help} {
      set te_txt "TE Script Program Flash: \n\
      Description:\n\
      \  Program Flash, with *.bin for Zynq device and *.mcs for native FPGA.\n\

      Syntax:\n\
      \  TE::pr_program_flash \[-swapp <arg>\] \[-swapp_av\] \[-reboot\] \[-erase\] \[-setup\] \[-used_board\] \[-basefolder\] \[-def_fsbl\] \[-flash_fsbl\] \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\

      \  \[-swapp\]         Software application name for boot files which should be programmed (see -swapp_av for available apps).\n\
      \  \[-swapp_av\]      Show available applications which can be programmed\n\
      \  \[-reboot\]        Start Software reboot after programming(see also Xilinx notes to SW reboot)\n\
      \  \[-erase\]         Erase whole flash.\n\
      \  \[-setup\]         Default program parameter Blank Check, Erase, CFG_Program, Verify,checksum and unused pin termination( termination for native fpga only, 0 pull-none, 1 pull-up, 2 pull-down), default 011001 (erase and program only).\n\
      \  \[-used_board\]    Use files from other board as currently set in the project.\n\
      \  \[-basefolder\]    Use files from basefolder, depending on System, *.mcs,  *.ltx or *.bin , fsbl_flash.elf and  *.ltx must be available on basefolder.\n\
      \  \[-def_fsbl\]      Use default FSBL instead of FSBL Flash (will be used as default, if not set).\n\
      \  \[-flash_fsbl\]    Use special FSBL for flash programming instead of default FSBL (usable for Vivado 17.3 up to 19.2, sometimes up to 20.2) Will be removed in later versions.\n\
      \  \[-help\]          Print help.\n\
      Categories:\n\
      \  TE::VLAB\n\
      "
      TE::UTILS::te_msg TE_PR-103 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_PR-104 STATUS "Start Flash Programming "
      set starttime [clock seconds]
      
      if {$swapp_av} {
        TE::UTILS::te_msg TE_PR-?? INFO "Please specify application with parameter -swapp <application name>"
        if {[catch {TE::EXT::get_available_apps $prebuilt_name} result]} {TE::UTILS::te_msg TE_PR-105 ERROR "Script (TE::EXT::get_available_apps) failed: $result."; return -code error}
      } else {
        set hw_close true
        if {[catch {set hw_close [TE::VLAB::hw_open_jtag]} result]} {TE::UTILS::te_msg TE_PR-106 ERROR "Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}
        
        if {[catch {TE::VLAB::hw_create_flash_device "" $setup} result]} {TE::UTILS::te_msg TE_PR-107 ERROR "Script (TE::VLAB::hw_create_flash_device) failed: $result."; return -code error}
        
        
        if {[catch {set return_filename [TE::VLAB::hw_program_flash $swapp $prebuilt_name $setup $erase $def_fsbl]} result]} {TE::UTILS::te_msg TE_PR-108 ERROR "Script (TE::VLAB::hw_program_flash) failed: $result."; return -code error}
        
        if {!$erase} {
          if {$swreboot} {
            if {[catch {TE::VLAB::hw_fpga_boot_from_memory $prebuilt_name} result]} {TE::UTILS::te_msg TE_PR-109 ERROR "Script (TE::VLAB::hw_fpga_boot_from_memory) failed: $result."; return -code error}
          }
        }
  
        if {$hw_close} {
          if {[catch {TE::VLAB::hw_close_jtag} result]} {TE::UTILS::te_msg TE_PR-?? ERROR "Script (TE::VLAB::hw_close_jtag) failed: $result."; return -code error}
        }
      }
      set stoptime [clock seconds]
      set timeelapsed [expr $stoptime -$starttime]
      TE::UTILS::te_msg TE_PR-110 INFO "Programming elapsed time: $timeelapsed seconds"
      TE::UTILS::te_msg TE_PR-111 STATUS "Flash Programming with $return_filename finished."
    }
        
      
    return $return_filename
  }
  
  #--------------------------------
  #--pr_program_jtag_bitfile:  
  proc pr_program_jtag_bitfile {{args ""}} {
    set return_filename ""
    set print_available_apps false
    set run_help false
    set run_prebuilt true
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
          default         {TE::UTILS::te_msg TE_UTIL-87 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    if {$run_help} {
      set te_txt "TE Script Program FPGA with Bit File: \n\
      Description:\n\
      \  Programming FPGA with BIT-File.\n\
      \  Copy HW File and reports from the Vivado project to the prebuilt folder, if -used_board <arg> isn't set (default)\n\
      Syntax:\n\
      \  TE::pr_program_jtag_bitfile \[-used_board <arg>\] \[-used_basefolder_bitfile\] \[-help\]\n\
      Returns:\n\
      \  Programming file-name.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-used_board <arg>\]         Used prebuilt folder board version instead of vivado project settings. Available <arg> is ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list. If name not found, \"default\" is used.\n\
      \  \[-swapp <arg>\]              Software app name which should be programmed. (If app name isn't set, the bit-file from the prebuilt hardware folder is used)\n\
      \  \[-available_apps\]           Return available software app names from selected the prebuilt boot_images folder.\n\
      \  \[-used_basefolder_bitfile\]  Use base-folder bit-file ($TE::BASEFOLDER). Should be only one *.bit!\n\
      \  \[-help\]                     Print help.\n\
      Categories:\n\
      \  TE::VLAB\n\
      "
      TE::UTILS::te_msg TE_PR-70 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_PR-71 STATUS "Start FPGA Programming with Bit File"
      set starttime [clock seconds]
      if {$print_available_apps} {
        if {[catch {TE::EXT::get_available_apps $prebuilt_name} result]} {TE::UTILS::te_msg TE_PR-72 ERROR "Script (TE::EXT::get_available_apps) failed: $result."; return -code error}
      } else {
        if {!$run_prebuilt} {
          if {![catch {set projectname [get_projects]} result]} {
            #copy only on vivado project
            if {[catch {TE::UTILS::copy_hw_files $TE::GEN_HW_DELETEOLDFILES} result]} {TE::UTILS::te_msg TE_PR-73 ERROR "Script (TE::UTILS::copy_hw_files) failed: $result."; return -code error}
            if {[catch {TE::UTILS::copy_hw_reports} result]} {TE::UTILS::te_msg TE_PR-74 INFO "No Hardware Reports found. "}
          }
        }
        set hw_wasclosed false
        if {[current_hw_server] eq ""} {set hw_wasclosed true}
        if {[catch {TE::VLAB::hw_open_jtag} result]} {TE::UTILS::te_msg TE_PR-75 ERROR "Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}
        if {[catch {set return_filename [TE::VLAB::hw_program_fpga_device $use_basefolder $appname $prebuilt_name]} result]} {TE::UTILS::te_msg TE_PR-76 ERROR "Script (TE::VLAB::hw_program_fpga_device) failed: $result."; return -code error}
        if {$hw_wasclosed} {
          if {[catch {TE::VLAB::hw_close_jtag} result]} {TE::UTILS::te_msg TE_PR-77 ERROR "Script (TE::VLAB::hw_close_jtag) failed: $result."; return -code error}
        }        
      }   
      set stoptime [clock seconds]
      set timeelapsed [expr $stoptime -$starttime]
      TE::UTILS::te_msg TE_PR-78 INFO "Programming elapsed time: $timeelapsed seconds"
      TE::UTILS::te_msg TE_PR-79 STATUS "FPGA Programming with BIT File finished."
    }
    return $return_filename
  }
  
  #--------------------------------
  #--pr_init_hardware_manager:  
  proc pr_init_hardware_manager {{args ""}} {
    set run_help false
    set run_prebuilt false
    set prebuilt_name ""
    set disconnect false
    set probe_file false
    set quiet false
    set setup 01100
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-disconnect"		  {set disconnect true}
        "-setup"		      {incr option; set setup [lindex $args $option]}
        "-quiet"		      { set quiet true}
        "-probe"		      { set probe_file true}
        "-help"		        { set run_help true}
          default         {TE::UTILS::te_msg TE_UTIL-88 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    if {$run_help} {
      set te_txt "TE Script Initialise Hardware Manager: \n\
      Description:\n\
      \  Open Hardware-Manager, auto-connect target device and initialise flash memory with configuration from *_board_files.csv.\n\
      \  If flash memory isn't specified, it will be ignored. \n\
      Syntax:\n\
      \  TE::pr_init_hardware_manager \[-disconnect\] \[-setup <arg>\]  \[-probe\] \[-help\]   \n\

      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-disconnect\]     disconnect JTAG \n\
      \  \[-setup <arg>\]    default program parameter Blank Check, Erase, CFG_Program, Verify and checksum, default 01100 (erase and program only)\n\
      \  \[-quiet\]          disable most Trenz and Xilinx messages. Xilinx functions return always TCL_OK.\n\
      \  \[-probe\]          add Probe from prebuilt folder if exist.\n\
      \  \[-help\]           Print help.\n\
      Categories:\n\
      \  TE::VLAB\n\
      "
      TE::UTILS::te_msg TE_PR-80 STATUS $te_txt
    } else {
        if {$disconnect} {
          TE::UTILS::te_msg TE_PR-96 STATUS "Close Hardware Manager"
          if {[catch {TE::VLAB::hw_close_jtag $quiet} result]} {TE::UTILS::te_msg TE_PR-95 ERROR "Script (TE::VLAB::hw_close_jtag) failed: $result."; return -code error}
        } else {
          TE::UTILS::te_msg TE_PR-81 STATUS "Start Init Hardware Manager"
          if {[catch {TE::VLAB::hw_open_jtag $quiet} result]} {TE::UTILS::te_msg TE_PR-82 ERROR "Script (TE::VLAB::hw_open_jtag) failed: $result."; return -code error}
          if {${TE::FPGAFLASHTYP} ne "NA"} {
            if {[catch {TE::VLAB::hw_create_flash_device "" $setup} result]} {TE::UTILS::te_msg TE_PR-83 ERROR "Script (TE::VLAB::hw_create_flash_device) failed: $result."; return -code error}
          }
          if {$probe_file} {
            if {[catch {TE::VLAB::hw_reload_prope_file_device NA } result]} {TE::UTILS::te_msg TE_PR-112 ERROR "Script (TE::VLAB::hw_reload_prope_file_device) failed: $result."; return -code error}
          }
        }
        TE::UTILS::te_msg TE_PR-84 STATUS "Initialize Hardware Manager finished."
    }
  }  
  #--------------------------------
  #--pr_putty:  
  proc pr_putty {{args ""}} {
    set run_help false
    set display_com false
    set logname ""

    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-available_com"	{ set display_com true}
        "-com"        { incr option; set TE::DESIGN_UART_COM [lindex $args $option]}
        "-speed"      { incr option; set TE::DESIGN_UART_SPEED [lindex $args $option]}
        "-log"        { incr option; set TE::logname [lindex $args $option]}
        "-help"		        { set run_help true}
          default         {TE::UTILS::te_msg TE_UTIL-88 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    if {$run_help} {
      set te_txt "TE Script Initialise Hardware Manager: \n\
      Description:\n\
      \  Requires Putty installation.\n\
      \  Open Putty console. \n\
      Syntax:\n\
      \  TE::pr_putty \[-available_com\] \[-com\] \[-speed\] \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-available_com\]   Prints list of available COM ports.\n\
      \  \[-com <arg>\]       Set COM Port, which should be used for example \"COM12\".\n\
      \  \[-speed <arg>\]     Set Speed: mostly used for zynq, zynqMP: 115200, mostly used  for FPGA: 9600\n\
      \  \[-log <arg>\]       Default Log is (vlog/putty-<articlename>-<timestamp>.log), use \"d\" option to disable log or use other files name(more than 4 char).\n\
      \  \[-help\]            Print help.\n\
      Categories:\n\
      \  TE::EXT\n\
      "
      TE::UTILS::te_msg TE_PR-91 STATUS $te_txt
    } else {
        TE::UTILS::te_msg TE_PR-92 STATUS "Start Putty console"
        if {${display_com}} {
          set printout [TE::EXT::run_putty true $logname]
          if {[llength $printout] >0 } {
            TE::UTILS::te_msg TE_UTIL-141 INFO "Available COM Ports: $printout"
          } 
        } else {
          if {${TE::DESIGN_UART_COM} eq "NA"} {
            TE::UTILS::te_msg TE_UTIL-140 WARNING "Scripts try auto detect of COM port, if failed, specify UART COM Port with TE::pr_putty -set_com <arg> or add COM Port to design_settings.tcl and reinitialize scripts. "
          }        
          if {${TE::DESIGN_UART_SPEED} eq "NA"} {
            TE::UTILS::te_msg TE_UTIL-139 ERROR "Specify UART speed with TE::pr_putty -set_speed <arg> or add speed to design_settings.tcl and reinitialize scripts"
            return -code error
          }
          if {[catch {   
            TE::UTILS::te_msg TE_UTIL-142 INFO "Open Putty on ${TE::DESIGN_UART_COM} with speed ${TE::DESIGN_UART_SPEED}"
            set printout [TE::EXT::run_putty false $logname]
            TE::UTILS::te_msg TE_UTIL-143 INFO "Putty is opened with PID: $printout"
            } result]} {TE::UTILS::te_msg TE_PR-94 ERROR "Script (TE::EXT::run_putty ) failed: $result."; return -code error}
        }

        TE::UTILS::te_msg TE_PR-93 STATUS "Start Putty console finished."
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
    # set tmp [split $TE::SHORTDIR "_"]
    set tmp [split $TE::PRODID "-"]
    set zipname ""
    
    #settings
    set remove_prebuilt false
    set save_all false
    set no_gui false
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-manual_filename"  { incr option; set zipname [lindex $args $option];set manual_name true}
        "-remove_prebuilt"  { set remove_prebuilt true}
        "-save_all"		      { set save_all true}
        "-help"		          { set run_help true}
        "-no_gui"		        { set no_gui true}
          default    {TE::UTILS::te_msg TE_UTIL-89 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
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
      set te_txt "TE Script Backup Project: \n\
      Description:\n\
      \  Generate Zip file from current project in folder $TE::BACKUP_PATH.\n\
      \  Supported ZIP-Programs:7z.exe (7 zip) and zip.exe (Info ZIP) \n\
      \  Did not save files, which are specified in /settings/zip_ignore_list.csv.\n\
      Syntax:\n\
      \  TE::util_zip_project \[-save_all\] \[-remove_prebuilt\] \[-manual_filename <arg>\] \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-manual_filename <arg>\]  Specify name instead auto-generate name.\n\
      \  \[-remove_prebuilt\]        Save backup without prebuilt(Command is ignored if -save_all is selected).\n\
      \  \[-save_all\]               Save all, otherwise work path like vivado, workspace, vlog and other specified folders/files are excluded.\n\
      \  \[-help\]                   Print help.\n\
      Categories:\n\
      \  TE::EXT\n\
      "
      TE::UTILS::te_msg TE_UTIL-95 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_UTIL-96 STATUS "Start Backup Project:"
      if {$save_all} {
        if {[catch {TE::EXT::zip_project $zipname} result]} {TE::UTILS::te_msg TE_UTIL-97 ERROR "Script (TE::EXT::zip_project) failed: $result."; return -code error}
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
          lappend excludelist "prebuilt"
        }
        
        if {$no_gui} {
          set initials "NA"
          set dest "NA"
          set typ "NA"
          set btyp "NA"
          set pext "NA"
          set rev "NA"
          
          set someVar "NA"
          puts "---------------------------------------------"
          puts "--Additional Information for ZIP are required"
          puts "---------------------------------------------"
          puts "Insered Initials(optional):"
          gets stdin someVar
          if {![string match -nocase "" $someVar ]} {
            set initials $someVar
          }        
          puts "Insered destination:"
          puts "- 0 for PublicDoc"
          puts "- 1 for Production"
          puts "- 2 for Development"
          puts "- 3 for Preliminary"
          puts "- 4 for Customer Release"

          while {1} {
            set someVar "NA"
            gets stdin someVar
            if {[string match -nocase "0" $someVar ]} {
              set dest "PublicDoc"
              break
            } elseif {[string match -nocase "1" $someVar ]} {
              set dest "Production"
              set someVar "NA"
              while {1} {
                puts "Insered destination:"
                puts "- 0 for Manual Test"
                puts "- 1 for Halfautomatic Test"
                puts "- 2 for Automatic Test System"
                puts "- 3 for Others"
                gets stdin someVar
                if {[string match -nocase "0" $someVar ]} {
                  set typ "MT"
                  break
                } elseif {[string match -nocase "1" $someVar ]} {
                  set typ "HT"
                  break
                } elseif {[string match -nocase "2" $someVar ]} {
                  set typ "ATS"
                  break
                } elseif {[string match -nocase "3" $someVar ]} {
                  set typ "NA"
                  break
                }
              }
              set someVar "NA"
              while {1} {
                puts "Insered Board Type(Test Reason):"
                puts "- 0 for Module Test Export"
                puts "- 1 for Carrier Test Export"
                puts "- 2 for Motherboard Test Export"
                puts "- 3 for FMC-Card Test Export"
                puts "- 4 for PCIe-Card Test Export"
                puts "- 5 for Others"
                gets stdin someVar
                if {[string match -nocase "0" $someVar ]} {
                  set btyp "Module"
                  break
                } elseif {[string match -nocase "1" $someVar ]} {
                  set btyp "Carrier"
                  break
                } elseif {[string match -nocase "2" $someVar ]} {
                  set btyp "Motherboard"
                  break
                } elseif {[string match -nocase "3" $someVar ]} {
                  set btyp "FMC-Card"
                  break
                } elseif {[string match -nocase "4" $someVar ]} {
                  set btyp "PCIe-Card"
                  break
                } elseif {[string match -nocase "5" $someVar ]} {
                  set btyp "NA"
                  break
                }
              }
              set someVar "NA"
              while {1} {
                puts "Include init.sh extention:"
                puts "- 0 with extentions"
                puts "- 1 without extentions"
                gets stdin someVar
                if {[string match -nocase "0" $someVar ]} {
                  set pext "yes"
                  break
                } elseif {[string match -nocase "1" $someVar ]} {
                  set pext "NA"
                  break
                }
              }
              break
            } elseif {[string match -nocase "2" $someVar ]} {
              set dest "Development"
              break
            } elseif {[string match -nocase "3" $someVar ]} {
              set dest "Preliminary"
              break
            } elseif {[string match -nocase "4" $someVar ]} {
              set someVar "NA"
              set dest "CustomerRelease"
              puts "Please Enter Project Release Number(any input possible):"
              gets stdin someVar
              if { [string length  $someVar ] == 0 } {
                set rev "NA"
              } else {
                set rev $someVar
              }
              break
            }
          }


          puts "--------------------------"
          puts "Start ZIP process"
          puts "-------------"
          if {[catch {TE::EXT::zip_project $zipname $excludelist $initials $dest $typ $btyp $pext $rev} result]} {TE::UTILS::te_msg UTIL-162 ERROR " Script (TE::EXT::zip_project) failed: $result."; return -code error}
        } else {

          if {[catch {TE::EXT::zip_project $zipname $excludelist} result]} {TE::UTILS::te_msg UTIL-98 ERROR " Script (TE::EXT::zip_project) failed: $result."; return -code error}
        }
      }
      TE::UTILS::te_msg UTIL-99 STATUS "Backup Project finished."
    }
  }
  #--------------------------------
  #--util_package_length:  
  proc util_package_length {{args ""}} {
    set run_help false
    #settings
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-help"		          { set run_help true}
          default    {TE::UTILS::te_msg TE_UTIL-100 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    
    if {$run_help} {
      set te_txt "TE Script export package length: \n\
      Description:\n\
      \  Export device package trace length to ${TE::DOC_PATH}.\n\
      Syntax:\n\
      \  TE::util_package_length \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-help\]                   Print help.\n\
      Categories:\n\
      \  TE::VIV \n\
      "
      TE::UTILS::te_msg TE_UTIL-101 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_UTIL-102 STATUS "Start Packages trace length export:"
      if {[catch {TE::VIV::export_trace_length} result]} {TE::UTILS::te_msg TE_HW-83 ERROR "Script (TE::VIV::export_trace_length) failed: $result."; return -code error}
      
      TE::UTILS::te_msg UTIL-103 STATUS "Packages trace length export finished."
    }
  }
  #--------------------------------
  #--util_editor:  
  proc util_editor {{args ""}} {
    set run_help false
    set file ""
    #settings
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-file"       { incr option; set file [lindex $args $option]}
        "-help"       { set run_help true}
          default    {TE::UTILS::te_msg TE_UTIL-163 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    
    if {$run_help} {
      set te_txt "TE Script which opens external editor. \n\
      Description:\n\
      \  Open specified file on defined text editor: ${TE::TE_EDITOR}.\n\
      Syntax:\n\
      \  TE::util_editor \[-file <arg>\] \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-file <arg>\]  Specify the file which should be opend.\n\
      \  \[-help\]                   Print help.\n\
      Categories:\n\
      \  TE::EXT \n\
      "
      TE::UTILS::te_msg TE_UTIL-164 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_UTIL-165 STATUS "Start open Editor:"
      if {[catch {TE::EXT::editor $file} result]} {TE::UTILS::te_msg TE_UTIL-166 ERROR "Script (TE::EXT::editor) failed: $result."; return -code error}
      
      TE::UTILS::te_msg UTIL-167 STATUS "Open Text editor finished."
    }
  }
  #--------------------------------
  #--util_editor:  
  proc util_terminal {{args ""}} {
    set run_help false
    set file ""
    #settings
    set args_cnt [llength $args]
    for {set option 0} {$option < $args_cnt} {incr option} {
        switch [lindex $args $option] { 
        "-help"       { set run_help true}
          default    {TE::UTILS::te_msg TE_UTIL-168 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
        }
    }
    
    if {$run_help} {
      set te_txt "TE Script which opens external terminal. \n\
      Description:\n\
      \  Open terminal:.\n\
      Syntax:\n\
      \  TE::util_terminal \[-help\]\n\
      Returns:\n\
      \  No return value.\n\
      Usage:\n\
      \  Name          Description\n\
      \  -------------------------\n\
      \  \[-help\]                   Print help.\n\
      Categories:\n\
      \  TE::EXT \n\
      "
      TE::UTILS::te_msg TE_UTIL-169 STATUS $te_txt
    } else {
      TE::UTILS::te_msg TE_UTIL-170 STATUS "Start open terminal:"
      if {[catch {TE::EXT::terminal} result]} {TE::UTILS::te_msg TE_UTIL-171 ERROR "Script (TE::EXT::terminal) failed: $result."; return -code error}
      
      TE::UTILS::te_msg UTIL-172 STATUS "Open Terminal finished."
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
      # set run_help false
      # set check_sdsoc false

      # set args_cnt [llength $args]
      # for {set option 0} {$option < $args_cnt} {incr option} {
          # switch [lindex $args $option] { 
          # "-check_only"		   { set check_sdsoc true}
          # "-help"		          { set run_help true}
            # default    {TE::UTILS::te_msg TE_UTIL-90 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
          # }
      # }
      
      # if {$run_help} {
        # set te_txt "TE Script SDSoC Project: \n\
        # Description:\n\
        # \  Generate SDSoC project structure in $TE::SDSOC_PATH.\n\
        # \  7-ZIP-Program is required (see design_basic_settings.cmd).\n\
        # \  Attention: This Project will be modified! To restore, close this Project after SDSOC generation an run create project batch file.\n\
        # Syntax:\n\
        # \  TE::ADV::beta_util_sdsoc_project \[-check_only\] \[-help\]\n\
        # Returns:\n\
        # \  No return value.\n\
        # Usage:\n\
        # \  Name          Description\n\
        # \  -------------------------\n\
        # \  \[-check_only\]        Check this project for SDSOC support (no modification are done).\n\
        # \  \[-help\]              Print help.\n\
        # Categories:\n\
        # \  TE::SDSOC, TE::EXT\n\
        # "
        # TE::UTILS::te_msg TE_HW-65 STATUS $te_txt
      # } else {
        # TE::UTILS::te_msg TE_HW-66 STATUS "Start SDSoC Project:"
        # if {$check_sdsoc} {
          # if {[catch {TE::SDSOC::check_and_modify_vivado_project true} result]} {TE::UTILS::te_msg TE_HW-67 ERROR "Script (TE::SDSOC::check_and_modify_vivado_project) failed: $result."; return -code error}
        # } else {
          # if {[catch {TE::SDSOC::create_sdsoc_structure} result]} {TE::UTILS::te_msg TE_HW-69 ERROR "Script (TE::SDSOC::create_sdsoc_structure) failed: $result."; return -code error}
          # if {[catch {TE::SDSOC::check_and_modify_vivado_project false} result]} {TE::UTILS::te_msg TE_HW-70 ERROR "Script (TE::SDSOC::check_and_modify_vivado_project) failed: $result."; return -code error}
           # #todo rebuild project files
          # if {[catch {TE::SDSOC::export_vivado_sdsoc_project} result]} {TE::UTILS::te_msg TE_HW-71 ERROR "Script (TE::SDSOC::export_vivado_sdsoc_project) failed: $result."; return -code error}
          # if {[catch {TE::SDSOC::create_sdsoc_pfm} result]} {TE::UTILS::te_msg TE_HW-72 ERROR "Script (TE::SDSOC::create_sdsoc_pfm) failed: $result."; return -code error}
        # }
        # TE::UTILS::te_msg TE_HW-73 STATUS "SDSoC Project finished."
      # }
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
            default               {TE::UTILS::te_msg TE_UTIL-91 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
          }
      }
      if {$run_help} {
        set te_txt "TE Script Remove Board part: \n\
        Description:\n\
        \  Remove board part from project.\n\
        \  Attention:\n\
        \  Function not supported for all Block-Design IPs.\n\
        \  Check design after automatically modifications are done!\n\
        \  To restore project after permanent modification do:\n\
        \  Delete ${TE::BD_PATH}/*.tcl.\n\
        \  Rename ${TE::BD_PATH}/*.tcl_backup into ${TE::BD_PATH}/*.tcl.\n\
        \  Delete ${TE::BOARDDEF_PATH}/*_board_files_mod.csv.\n\
        Syntax:\n\
        \  TE::ADV::beta_hw_remove_board_part \[-permanent\] \[-help\]\n\
        Returns:\n\
        \  No return value.\n\
        Usage:\n\
        \  Name          Description\n\
        \  -------------------------\n\
        \  \[-permanent\]  Board Part is removed permanently for this vivado project.TCL-File is generated and alternative board_part.cvs is used on design creation.\n\
        \  \[-help\]       Print help.\n\
        Categories:\n\
        \  TE::VIV, TE::UTILS\n\
        "
        TE::UTILS::te_msg TE_HW-74 STATUS $te_txt
      } else {
        TE::UTILS::te_msg TE_HW-75 STATUS "Start Remove Board Part:"
        if {[catch {TE::VIV::design_exclude_boarddef $temp_only} result]} {TE::UTILS::te_msg TE_HW-76 ERROR "Script (TE::VIV::design_exclude_boarddef) failed: $result."; return -code error}
        TE::UTILS::te_msg TE_HW-77 STATUS "Remove Board Part finished."
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
            default               {TE::UTILS::te_msg TE_UTIL-92 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
          }
      }
      if {$run_help} {
        set te_txt "TE Script Remove Board part: \n\
        Description:\n\
        \  Export RTL-IP Cores (*.xci), which are not included in a Block-Design to ${TE::HDL_PATH}/xci/${TE::SHORTDIR}.\n\
        \  HDL and *.xci files, which include in the folder $TE::HDL_PATH are load automatically on project creation.\n\
        Syntax:\n\
        \  TE::ADV::beta_hw_export_rtl_ip \[-help\]\n\
        Returns:\n\
        \  No return value.\n\
        Usage:\n\
        \  Name          Description\n\
        \  -------------------------\n\
        \  \[-help\]       Print help.\n\
        Categories:\n\
        \  TE::VIV, TE::UTILS\n\
        "
        TE::UTILS::te_msg TE_HW-78 STATUS $te_txt
      } else {
        TE::UTILS::te_msg TE_HW-79 STATUS "Start Export RTL-IPs:"
        if {[catch {TE::VIV::export_xci} result]} {TE::UTILS::te_msg TE_HW-80 ERROR "Script (TE::VIV::export_xci) failed: $result."; return -code error}
        TE::UTILS::te_msg TE_HW-81 STATUS "Export RTL-IPs finished."
      }
    }
    #--------------------------------
    #--beta_hw_create_board_part
    proc beta_hw_create_board_part {{args ""}} {
      set run_help false
      set run_update_preset false
      set run_all_variants false
      set run_create_ps true
      set module_series ""
      set board_part_only false
      set sourcepath "../../../../boards/board_files/_tcl_scripts"
      
      
      set args_cnt [llength $args]
      for {set option 0} {$option < $args_cnt} {incr option} {
          switch [lindex $args $option] { 
          "-series"		            { incr option; set module_series [lindex $args $option]}
          "-all"		              {set run_all_variants true}
          "-preset"		            {set run_update_preset true}
          "-existing_ps"		      {set run_create_ps false}
          "-source_path"		        { incr option; set sourcepath [lindex $args $option]}
          "-help"		              {set run_help true}
            default               {TE::UTILS::te_msg TE_UTIL-110 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
          }
      }
      if {$run_help} {
        set te_txt "TE create Board Part Files (internal usage only, external scripts needed!): \n\
        Description:\n\
        \  Create BD PS settings and optional modify PS preset.xml with new PS settings.\n\
        Syntax:\n\
        \  TE::ADV::beta_hw_create_board_part \[-series  <arg>\] \[-all\] \[-preset\] \[-existing_ps\] \[-help\]\n\
        Returns:\n\
        \  No return value.\n\
        Usage:\n\
        \  Name          Description\n\
        \  -------------------------\n\
        \  \[-series  <arg>\]       Select Series (predefined (ex. TE0808) or TCL Name (*.tcl)).\n\
        \  \[-all\]                 Run all available variants.\n\
        \  \[-preset\]              Update also preset.xml with Zynq/ZynqMP PS settings.\n\
        \  \[-existing_ps\]         Use existing PS instead of  create new one.\n\
        \  \[-source_path  <arg>\]  select search path).\n\
        \  \[-help\]                Print help.\n\
        Categories:\n\
        \  TE::VIV, TE::UTILS\n\
        "
        TE::UTILS::te_msg TE_HW-85 STATUS $te_txt
      } else {
        TE::UTILS::te_msg TE_HW-86 STATUS "Start Board Part creation:"
        #select correct files
        
        if {  [string match "TE0808" $module_series ] || \
              [string match "TE0807" $module_series ] || \
              [string match "TE0803" $module_series ] 
        } {
          set module_series "_5p2x7p6_ZynqMP.tcl"
        } elseif  {[string match "TE0820" $module_series ] } {
          set module_series "_4x5_ZynqMP.tcl"
        } elseif  {[string match "TE0823" $module_series ] } {
          set module_series "_4x5_ZynqMP.tcl"
        } elseif  {[string match "TE0835" $module_series ] } {
          set module_series "_835_ZynqMPRF.tcl"
        } elseif  {[string match "TEC0850" $module_series ] } {
          set module_series "_cpcis_0850_ZynqMP.tcl"
        } elseif  {[string match "TE0720" $module_series ] } {
          set module_series "_4x5_Zynq.tcl"
        } elseif  {[string match "TE0715" $module_series ] } {
          set module_series "_4x5_Zynq.tcl"
        } elseif  {[string match "TE0724" $module_series ] } {
          set module_series "_4x6_Zynq.tcl"
        } elseif  {[string match "TE0728" $module_series ] } {
          set module_series "_6x6_Zynq.tcl"
        } elseif  {[string match "TE0729" $module_series ] } {
          set module_series "_5p2x7p6_Zynq_729.tcl"
        } elseif  {[string match "TE0745" $module_series ] } {
          set module_series "_5p2x7p6_Zynq_745.tcl"
        } elseif  {[string match "TEB0911" $module_series ] } {
          set module_series "_911_ZynqMP.tcl"
        } elseif  {[string match "TE0802" $module_series ] } {
          set module_series "_802_ZynqMP.tcl"
        } elseif  {[string match "TEB0912" $module_series ] } {
          set module_series "_912_ZynqMP.tcl"
        } elseif  {[string match "TE0782" $module_series ] } {
          set module_series "_8p5x8p5_Zynq.tcl"
        } elseif  {[string match "TE0783" $module_series ] } {
          set module_series "_8p5x8p5_Zynq.tcl"
        } elseif  {[string match "TE0722" $module_series ] } {
          set module_series "_dipforty_Zynq.tcl"
        } elseif  {[string match "TE0726" $module_series ] } {
          set module_series "_zynqberry_Zynq.tcl"
        } elseif  {[string match "TE0723" $module_series ] } {
          set module_series "_arduzynq_Zynq.tcl"
        } elseif  {[string match "TE0830_Z" $module_series ] } {
          set module_series "_830_Zynq.tcl"
        } elseif  {[string match "TE0830_ZU" $module_series ] } {
          set module_series "_830_ZynqMP.tcl"
        } elseif  {[string match "*.tcl" $module_series ] } {
          #use TCL direct
        } else {
          #
          TE::UTILS::te_msg TE_HW-87 ERROR "No series is selected."; return -code error;
        }
        if {$run_all_variants} {
          foreach sublist $TE::BDEF::BOARD_DEFINITION {
            set id [lindex $sublist 0]
            if {$id ne "ID" } {
              set teinfo [TE::UTILS::findFiles $TE::VPROJ_PATH *teinfo]
              if { [file exists $teinfo] } {
                [catch {file delete $teinfo} result]
              }
              set_property board_part [TE::BDEF::get_boardname $id 0]             [current_project]
              cd [get_property DIRECTORY [current_project]]; source -notrace "../scripts/reinitialise_all.tcl"

            }
            if {[catch {TE::VIV::create_ps_board_part $module_series $run_update_preset $run_create_ps $sourcepath } result]} {TE::UTILS::te_msg TE_HW-88 ERROR "Script (TE::VIV::beta_hw_create_board_part) failed: $result."; return -code error}
          }
        } else {
          if {[catch {TE::VIV::create_ps_board_part $module_series $run_update_preset $run_create_ps $sourcepath } result]} {TE::UTILS::te_msg TE_HW-89 ERROR "Script (TE::VIV::beta_hw_create_board_part) failed: $result."; return -code error}
        }
        TE::UTILS::te_msg TE_HW-90 STATUS "Board Part creation finished."
      }
    }
    #--------------------------------
    #--beta_hw_export_binary
    proc beta_hw_export_binary {{args ""}} {
      set run_help false
      set mode NA
      set app NA
      set allboards false
      set production PROD
      
      set uprodid NA
      set ushortdir NA
      set uddr NA
      set urev NA
      set uflashfpga NA
      set uflashzynq NA
      
      
      set args_cnt [llength $args]
      for {set option 0} {$option < $args_cnt} {incr option} {
          switch [lindex $args $option] { 
          "-mode"		              { incr option; set mode [lindex $args $option]}
          "-app"		              { incr option; set app [lindex $args $option]}
          "-all"		              {set allboards true}
          "-folder"		            { incr option; set production [lindex $args $option]}
          "-help"		              {set run_help true}
            default               {TE::UTILS::te_msg TE_UTIL-123 ERROR "Unrecognised option: [lindex $args $option]."; set run_help true;break }
          }
      }
      if {$run_help} {
        set te_txt "TE export programming files (internal usage only!): \n\
        Description:\n\
        \  Export files to external folder with some notes.\n\
        Syntax:\n\
        \  TE::ADV::beta_hw_export_binary \[-mode  <arg>\] \[-app  <arg>\] \[-folder   <arg>\] \[-all\] \[-help\]\n\
        Returns:\n\
        \  No return value.\n\
        Usage:\n\
        \  Name          Description\n\
        \  -------------------------\n\
        \  \[-mode  <arg>\]     Select Export type: 0 JTAG Boot, 1 Flash Boot, 2 SD Boot, 3 Flash Boot with SD content.\n\
        \  \[-app\]             app name, which should be exported.\n\
        \  \[-folder   <arg>\]  export to special folder.\n\
        \  \[-all\]             export for all variants with selection from development_settings.tcl.\n\
        \  \[-help\]            Print help.\n\
        Categories:\n\
        \  TE::VIV, TE::UTILS\n\
        "
        TE::UTILS::te_msg TE_UTIL-124 STATUS $te_txt
      } else {
        TE::UTILS::te_msg TE_UTIL-125 STATUS "Start export files:" 
        if {$allboards eq true} {
          foreach sublist $TE::BDEF::BOARD_DEFINITION {
            set id [lindex $sublist 0]
            if {$id ne "ID" } {
              if {[llength $TE::DESIGNRUNS] > 0 && [lsearch -exact $TE::DESIGNRUNS $id] == -1} {
                TE::UTILS::te_msg TE_UTIL-133 STATUS "Skip ID: $id"
              } else {
                set uprodid [lindex $sublist ${TE::BDEF::PRODID}]
                set ushortdir [lindex $sublist ${TE::BDEF::SHORTNAME}]
                set uddr [lindex $sublist ${TE::BDEF::DDR_SIZE}]
                set urev [lindex $sublist ${TE::BDEF::PCB_REV}]
                set uflashfpga [lindex $sublist ${TE::BDEF::FPGAFLASHTYP}]
                set uflashzynq [lindex $sublist ${TE::BDEF::ZYNQFLASHTYP}]
                
                set urev [split ${urev} "|"]
                foreach urevx $urev {
                  for {set i 0} {$i < [llength $TE::TE_INTERNAL_EXPORT]} {incr i} {
                    set mode [lindex $TE::TE_INTERNAL_EXPORT $i]
                    set app [lindex $TE::TE_INTERNAL_APP $i]
                    if {[catch {TE::UTILS::copy_prod_export $mode $app $production $uprodid $ushortdir $uddr $urevx $uflashfpga $uflashzynq} result]} {TE::UTILS::te_msg TE_UTIL-134 ERROR "Script (TE::UTILS:copy_prod_export) failed: $result."; return -code error}
                  }
                }
              }
            }
          }
        } else {
          set uprodid ${TE::PRODID}
          set ushortdir ${TE::SHORTDIR}
          set uddr ${TE::DDR_SIZE}
          set urev ${TE::PCB_REV}
          set uflashfpga ${TE::FPGAFLASHTYP}
          set uflashzynq ${TE::ZYNQFLASHTYP}
          #use only current version  
          set urev [lindex [split ${urev} "|"] 0]
          
          if {[catch {TE::UTILS::copy_prod_export $mode $app $production $uprodid $ushortdir $uddr $urev $uflashfpga $uflashzynq} result]} {TE::UTILS::te_msg TE_UTIL-126 ERROR "Script (TE::UTILS:copy_prod_export) failed: $result."; return -code error}
        }

        TE::UTILS::te_msg TE_UTIL-127 STATUS "export files finished."
      }
    }
  }
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished beta test functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
    
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  puts "INFO:(TE) Load User Command scripts finished"
}