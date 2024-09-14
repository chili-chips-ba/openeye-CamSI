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
# -- $Date: 2016/02/02 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2017/06/13  | $Author: Hartfiel, John
# -- - new release version
# ------------------------------------------
# -- $Date: 2017/06/28  | $Author: Hartfiel, John
# -- -  new board part csv version
# ------------------------------------------
# -- $Date: 2017/07/10  | $Author: Hartfiel, John
# -- -  new script version
# ------------------------------------------
# -- $Date:  2017/09/07  | $Author: Hartfiel, John
# -- - add new document history style
# -- -  new script version
# -- -  add tmp path variable
# -- -  change sdsoc path variable
# ------------------------------------------
# -- $Date: 2017/09/13  | $Author: Hartfiel, John
# -- - new release version
# ------------------------------------------
# -- $Date: 2017/09/21  | $Author: Hartfiel, John
# -- - new script version
# ------------------------------------------
# -- $Date: 2017/10/04  | $Author: Hartfiel, John
# -- - new script version
# ------------------------------------------
# -- $Date: 2017/10/13  | $Author: Hartfiel, John
# -- - new script version
# ------------------------------------------
# -- $Date: 2017/10/19  | $Author: Hartfiel, John
# -- - new script version
# ------------------------------------------
# -- $Date: 2017/12/08  | $Author: Hartfiel, John
# -- - new script version
# ------------------------------------------
# -- $Date: 2017/12/12  | $Author: Hartfiel, John
# -- - new script version
# ------------------------------------------
# -- $Date: 2018/01/02  | $Author: Hartfiel, John
# -- - new release version
# ------------------------------------------
# -- $Date: 2018/01/04  | $Author: Hartfiel, John
# -- - script_vivado.tcl modification
# ------------------------------------------
# -- $Date: 2018/01/08  | $Author: Hartfiel, John
# -- - script_vivado.tcl and scripts_usrcommands.tcl modification
# -- - new script version
# ------------------------------------------
# -- $Date: 2018/01/11  | $Author: Hartfiel, John
# -- - script_vivado.tcl modification
# -- - new script version
# ------------------------------------------
# -- $Date: 2018/01/15  | $Author: Hartfiel, John
# -- - script_vivado.tcl modification
# -- - script_usrcommands.tcl modification
# -- - check_bdtyp bugfix 
# -- - new script version
# ------------------------------------------
# -- $Date: 2018/01/18  | $Author: Hartfiel, John
# -- - bugfix reinitiakise_all.tcl modification
# -- - new script version
# ------------------------------------------
# -- $Date: 2018/01/05  | $Author: Hartfiel, John
# -- - new script version with 2017.4 SDSoC
# ------------------------------------------
# -- $Date: 2018/02/13  | $Author: Hartfiel, John
# -- - new script version, changed script_te_utils.tcl
# ------------------------------------------
# -- $Date: 2018/05/09  | $Author: Hartfiel, John
# -- - new script version, changed, new variable script_te_utils.tcl, script_external.tcl
# ------------------------------------------
# -- $Date: 2018/05/17  | $Author: Hartfiel, John
# -- - new script version, changed, script_sdsoc.tcl, script_external.tcl
# ------------------------------------------
# -- $Date: 2018/05/22  | $Author: Hartfiel, John
# -- - new script version, changed script_external.tcl, script_vivado.tcl, scripts_te_utils.tcl
# ------------------------------------------
# -- $Date: 2018/05/23  | $Author: Hartfiel, John
# -- - use internal parameter from development_settings.tcl instead of cmd
# -- - small changes scripts_te_utils.tcl
# ------------------------------------------
# -- $Date: 2018/06/21  | $Author: Hartfiel, John
# -- - new script version, changed script_te_utils.tcl, script_sdsoc.tcl, script_external.tcl
# ------------------------------------------
# -- $Date: 2018/06/25  | $Author: Hartfiel, John
# -- - new release version
# ------------------------------------------
# -- $Date: 2018/07/05  | $Author: Hartfiel, John
# -- - new script version
# -- - new applist csv 2.1
# -- - changed script_hsi.tcl, script_external.tcl, script_te_utils.tcl
# ------------------------------------------
# -- $Date: 2018/07/05  | $Author: Hartfiel, John
# -- - new script version
# -- - changed script_vivado.tcl, script_te_utils.tcl
# ------------------------------------------
# -- $Date: 2018/08/23  | $Author: Hartfiel, John
# -- - new script version
# -- - changed script_vivado.tcl,
# ------------------------------------------
# -- $Date: 2018/08/23  | $Author: Hartfiel, John
# -- - new script version
# -- - modified init_app_list, init_boardlist (allow comma on header now)
# -- - changed script_te_util.tcl
# ------------------------------------------
# -- $Date: 2018/12/18  | $Author: Hartfiel, John
# -- - new script version
# -- - changed script_vivado.tcl
# ------------------------------------------
# -- $Date: 2019/02/14  | $Author: Hartfiel, John
# -- - new release version
# -- - new script version
# -- - add new board part metadate
# -- - changed init_board, init_part_only, all BDEF, SW_APPLIST
# -- - new BDEF parameter and design filter
# -- - changed ....tcl
# ------------------------------------------
# -- $Date: 2019/03/11  | $Author: Hartfiel, John
# -- - new script version
# -- - minor bugfix script_design.tcl
# ------------------------------------------
# -- $Date: 2019/03/11  | $Author: Hartfiel, John
# -- - new script version
# -- - minor bugfix script_design.tcl script_usrcommands.tcl
# -- - add possibility to generate FSBL_APP with other FSBL Project 
# ------------------------------------------
# -- $Date: 2019/04/03  | $Author: Hartfiel, John
# -- - new parameter
# ------------------------------------------
# -- $Date: 2019/06/21  | $Author: Hartfiel, John
# -- - new script version
# -- -  bugfix script_vivado.tcl
# ------------------------------------------
# -- $Date: 2019/09/13  | $Author: Hartfiel, John
# -- - new script version
# -- -  some new outputs in script_designs.tcl
# ------------------------------------------
# -- $Date: 2019/11/11  | $Author: Hartfiel, John
# -- - new script version
# -- -  bugfix in script_external.tcl
# ------------------------------------------
# -- $Date: 2019/11/25  | $Author: Hartfiel, John
# -- - new script version
# -- - new release version  19.2 
# -- - init_app_list, SW_APPLIST  definitions
# -- - init_boardlist, small changes tab remove shifted
# -- - new variable VERSION_CONTROL
# ------------------------------------------
# -- $Date: 2019/12/16  | $Author: Hartfiel, John
# -- - SW_APPLIST for mb
# ------------------------------------------
# -- $Date:  2019/12/18  | $Author: Hartfiel, John
# -- - new  filename variable   PB_FILENAME
# -- - new script version
# ------------------------------------------
# -- $Date:  2019/12/18  | $Author: Hartfiel, John
# -- - new script version
# -- - modify script_te_utils.tcl and script_designs.tcl
# ------------------------------------------
# -- $Date:  2020/01/09  | $Author: Hartfiel, John
# -- - new script version
# -- - modify script_te_utils.tcl and script_vivado.tcl script_vitis.tcl , add new variable
# ------------------------------------------
# -- $Date:  2020/01/24  | $Author: Hartfiel, John
# -- -  new script version
# -- - add xilinx install dir, modified print_version
# ------------------------------------------
# -- $Date:  2020/01/31  | $Author: Hartfiel, John
# -- - new script version
# -- - modify script_te_utils, script_designs
# ------------------------------------------
# -- $Date:  2020/02/14  | $Author: Hartfiel, John
# -- -  new script version
# -- - modify script_te_utils, script_designs
# ------------------------------------------
# -- $Date:  2020/02/25  | $Author: Hartfiel, John
# -- - new script version
# -- - modify script_te_utils, script_designs, script_vivado, script_external, script_usrcommands
# ------------------------------------------
# -- $Date:  2020/03/02  | $Author: Hartfiel, John
# -- - new script version
# -- - modify script_te_utils, script_main
# ------------------------------------------
# -- $Date:  2020/03/30  | $Author: Hartfiel, John
# -- - new script version
# -- - modify script_te_utils, script_evironment
# ------------------------------------------
# -- $Date:  2020/04/07  | $Author: Hartfiel, John
# -- - new script version
# -- - modify script_te_external, script_evironment, script_design, script_te_utils, script_designs
# -- - add missing msg numbers
# ------------------------------------------
# -- $Date:  2020/05/05  | $Author: Hartfiel, John
# -- - new script version
# -- - modify script_te_external, script_evironment, script_external
# ------------------------------------------
# -- $Date:  2020/05/05  | $Author: Hartfiel, John
# -- - new script version
# -- - modify , script_vivado.tcl
# ------------------------------------------
# -- $Date:  2020/06/29  | $Author: Hartfiel, John
# -- - new script version
# -- - modify , script_vivado.tcl script_usrcommands.tcl
# ------------------------------------------
# -- $Date:  2020/06/30  | $Author: Hartfiel, John
# -- - add new csv variable for production search
# -- - modify script_te_utils.tcl
# ------------------------------------------
# -- $Date:  2020/07/10  | $Author: Hartfiel, John
# -- - new script version
# -- - add new  variables XRT_PATH XRT_USED
# -- - modify script_te_utils.tcl, script_vivado.tcl, script_vitis.tcl
# ------------------------------------------
# -- $Date:  2020/09/12  | $Author: Hartfiel, John
# -- - new script version
# -- - modify script_te_utils.tcl
# ------------------------------------------
# -- $Date: 2020/11/25  | $Author: Hartfiel, John
# -- - new script version
# -- - new release version  20.2 
# -- - modified script_external.tcl
# ------------------------------------------
# -- $Date: 2021/01/05  | $Author: Hartfiel, John
# -- - renamed sdef platform into domain, new SW_IP_CSV version, add new parameter to csv list
# ------------------------------------------
# -- $Date: 2021/02/04  | $Author: Hartfiel, John
# -- - modified script_external.tcl
# -- - new script version
# ------------------------------------------
# -- $Date: 2021/02/13  | $Author: Hartfiel, John
# -- - modified script_external.tcl, script_te_utils.tcl
# -- - new script version
# -- - RUNNING_JOBS/TIMEOUT can be set global now (print_environment_settings)
# ------------------------------------------
# -- $Date: 2021/02/13  | $Author: Hartfiel, John
# -- - modified script_external.tcl, script_te_utils.tcl
# -- - new script version
# -- - modify init_app_list
# ------------------------------------------
# -- $Date: 2021/03/09  | $Author: Hartfiel, John
# -- - modified script_envirmonet.tcl, script_te_utils.tcl
# -- - new script version
# ------------------------------------------
# -- $Date: 2021/04/20  | $Author: Hartfiel, John
# -- - init_boardlist start always print_boardlist to remove TDB entries
# -- - new script version
# ------------------------------------------
# -- $Date: 2021/07/13  | $Author: Hartfiel, John
# -- - modified script_te_utils.tcl
# -- - new script version
# ------------------------------------------
# -- $Date:  2021/07/26  | $Author: Hartfiel, John
# -- - add petalinux tcl (beta for wsl)
# -- - new script version
# -- - update script_vivado.tcl (HW server connection has changed by xilinx)
# ------------------------------------------
# -- $Date:  2021/09/09  | $Author: Hartfiel, John
# -- - new script version
# -- - update script_vivado.tcl 
# ------------------------------------------
# -- $Date:  2021/11/11  | $Author: Hartfiel, John
# -- - new script version
# -- - update script_external.tcl 
# ------------------------------------------
# -- $Date: 2021/11/17  | $Author: Hartfiel, John
# -- - new release version based on 2020.2.9
# ------------------------------------------
# -- $Date: 2021/11/26  | $Author: Hartfiel, John
# -- - modified script_designs.tcl
# ------------------------------------------
# -- $Date: 2021/11/30  | $Author: Hartfiel, John
# -- - modified script_te_utils.tcl, script_external.tcl, script_vitis.tcl (add uboot dtb and bootscr option to software csv(update version))
# -- - init_app_list read new uboot boot.scr options
# -- - add  TE::SDEF::UBOOT_DTB_LOAD TE::SDEF::BOOTSCR_LOAD
# ------------------------------------------
# -- $Date: 2021/12/01  | $Author: Hartfiel, John
# -- - modified script_vitis.tcl
# -- - new script version
# ------------------------------------------
# -- $Date: 2021/12/13  | $Author: Hartfiel, John
# -- - modified script_external.tcl , script_te_util.tcl,script_designs.tcl,script_usrcommands.tcl
# -- - new script version
# ------------------------------------------
# -- $Date: 2021/12/14  | $Author: Hartfiel, John
# -- -  script_te_util.tcl, script_petalinux.tcl, script_usrcommands
# -- - add ZIPINFO_CSV Version
# -- - new script version
# ------------------------------------------
# -- $Date: 2021/12/16  | $Author: Hartfiel, John
# -- -  script_te_util.tcl, script_evironment.tcl, script_external
# -- - add variables
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/01/06  | $Author: Hartfiel, John
# -- -  script_te_util.tcl, script_usrcommands.tcl, script_external
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/01/11  | $Author: Hartfiel, John
# -- -  script_te_util.tcl, script_petalinux
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/01/20  | $Author: Hartfiel, John
# -- -  script_te_util.tcl, script_petalinux.tcl, script_usrcommands.tcl, script_envirmonet.tcl
# -- - new script version
# -- - add new enviroment vaiables
# ------------------------------------------
# -- $Date: 2022/01/21  | $Author: Hartfiel, John
# -- -  script_usrcommands.tcl
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/01/27  | $Author: Hartfiel, John
# -- -  script_te_util.tcl, script_designs.tcl, script_envirmonet.tcl
# -- -  add set_board_definition_index which automatically search boarddefinition position on header
# -- -  add CONFIG_SW_EXTPLL parameter (optional) add get_config_sw_extpll 
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/02/16  | $Author: Hartfiel, John
# -- - add silent option to get_check_unique_name, find_id  and init_board 
# ------------------------------------------
# -- $Date: 2022/03/17  | $Author: Hartfiel, John
# -- - init_prod_tcl bugfix
# ------------------------------------------
# -- $Date: 2022/04/26  | $Author: Hartfiel, John
# -- - script_te_util.tcl,script_vivado
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/05/04  | $Author: Hartfiel, John
# -- - script_te_util.tcl,script_designs.tcl,script_usrcommands.tcl
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/05/06  | $Author: Hartfiel, John
# -- - script_te_util.tcl,script_designs.tcl
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/07/27  | $Author: Hartfiel, John
# -- - script_usrcommandsl.tcl,
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/09/17  | $Author: Hartfiel, John
# -- - add  TE::SDEF::UBOOT_DTB_OFFSET TE::SDEF::BOOTSCR_OFFSET
# -- - add  TE::SDEF::D_AN, TE::SDEF::B_AN, TE::SDEF::AN --> article name for future usage --> different software for assembly versions --> wild card, full names...
# -- - set default TE::SDEF::* to 0 --> not available, on the csv file (todo used to be a little bit more backward compatible -> check if field content is same as ID for not available)
# -- - modify script_external and script_te_utils
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/09/20 | $Author: Hartfiel, John
# --  modify script_external and script_te_utils
# --  TODO remove special UBOOT and dBOOTSCR entries on next releases...
# ------------------------------------------
# -- $Date: 2022/09/21 | $Author: Hartfiel, John
# --  modify script_vivado and script_te_utils
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/09/24 | $Author: Hartfiel, John
# --  modify script_vivado , script_te_utils,script_environment
# -- - new script version
# --  
# ------------------------------------------
# -- $Date: 2022/10/14 | $Author: Hartfiel, John
# --  modify sscript_te_utils,script_environment
# -- - new script version
# --  
# ------------------------------------------
# -- $Date: 2022/10/19 | $Author: Hartfiel, John
# --  modify script_te_utils,script_design
# -- - new script version
# ------------------------------------------
# -- $Date: 2022/10/26 | $Author: Kirberg, Markus
# --  modify script_usrcommand,script_design, script_petalinux
# -- - new script version
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# --------------------------------------------------------------------
namespace eval ::TE {

  # -----------------------------------------------------------------------------------------------------------------------------------------
  # TE variable declaration
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # overwrite Setting:
  # create TCL file: <design_name>/settings/development_settings.tcl
  # overwrite example:
  # set TE::<property> <value>
  # set TE::GEN_HW_BIT false
  # -----------------------------------
  # Unsupported Settings:
  # ---------------------
  # Currently only one BD is allowed
  # Multi BD Design is official not supported (maybe not all functions run correctly):
  # For Multi BD Design do following:
  # 1. set variable BD_MULTI to true
  # 2. Make own Top-level File (Name: <design_name>_top) in the folder  "<design_name>/hdl/" with file name: "<design_name>_top.vhd" or "<design_name>_top.v" 
  variable BD_MULTI false
  #
  variable DESIGNRUNS [list]
  # -----------------------------------
  # Build Settings:
  # Attention: there are dependencies between this properties!
  # ---------------------
  variable GEN_HW_DELETEOLDFILES  true
  variable GEN_HW_BIT             true
  variable GEN_HW_MCS             true
  variable GEN_HW_RPT             true
  variable GEN_HW_HDF             true
  variable GEN_SW_HSI             true
  variable GEN_SW_BIF             true
  variable GEN_SW_BIN             true
  variable GEN_SW_BITMCS          true
  variable GEN_SW_USEPREBULTHDF   false
  variable GEN_SW_FORCEBOOTGEN    false
  # -----------------------------------
  # Custom Design Settings:
  # overwrite Setting:
  # create TCL file: <design_name>/settings/design_settings.tcl
  # ---------------------
  variable FILTER_DESIGN [list]
  variable DESIGN_UART_COM NA
  variable DESIGN_UART_SPEED NA
  # -----------------------------------
  # Serial Settings:
  variable SERIAL_PATH 
  variable COM_PATH 
  variable COM_IGNORE_LIST [list] 
  # -----------------------------------
  # Other envirment:
  variable TE_WSL_USAGE 
  variable TE_EDITOR 
  variable PLX_SSTATE_CACHE_DOWNLOAD 
  variable PLX_SSTATE_CACHE_AARCH64 
  variable PLX_SSTATE_CACHE_ARM 
  variable PLX_SSTATE_CACHE_MB_FULL 
  variable PLX_SSTATE_CACHE_MB_LITE 
  # -----------------------------------
  # Basic Settings:
  # Attention: do not change following variables manually!
  # ---------------------
  # project path
  variable BASEFOLDER 
  variable VPROJ_NAME 
  variable VPROJ_PATH 
  variable VLABPROJ_PATH 
  variable BOARDDEF_PATH 
  variable FIRMWARE_PATH 
  variable IP_PATH
  variable BD_PATH
  variable XDC_PATH
  variable HDL_PATH
  variable SET_PATH
  variable PETALINUX_PATH
  variable WORKSPACE_PATH
  variable WORKSPACE_HSI_PATH
  variable WORKSPACE_SDK_PATH
  variable LIB_PATH
  variable PREBUILT_PATH
  variable PREBUILT_HW_PATH 
  variable PREBUILT_SW_PATH 
  variable PREBUILT_BI_PATH 
  variable PREBUILT_OS_PATH 
  variable PREBUILT_EXPORT_PATH 
  variable SCRIPT_PATH 
  variable DOC_PATH 
  variable LOG_PATH 
  variable BACKUP_PATH 
  variable ZIP_PATH 
  variable SDSOC_PATH 
  variable XRT_USED
  variable XRT_PATH 
  variable ADD_SD_PATH 
  variable TMP_PATH 
  # -----------------------------------
  variable ZIP_IGNORE_LIST [list]
  # -----------------------------------
  variable BATCH_FILE_NAME
  variable XILINX_INSTALL_DIR
  variable VIVADO_AVAILABLE
  variable LABTOOL_AVAILABLE
  variable SDK_AVAILABLE
  variable PETALINUX_AVAILABLE
  variable SDSOC_AVAILABLE
  # -----------------------------------
  variable XILINXGIT_DEVICETREE
  variable XILINXGIT_UBOOT
  variable XILINXGIT_LINUX
  # -----------------------------------
  variable TE_INTERNAL_EXPORT
  variable TE_INTERNAL_APP
  # -----------------------------------
  # board_files
  variable ID "NA"
  variable PRODID  "NA"
  variable BOARDPART "NA"
  variable PARTNAME "NA"
  variable SHORTDIR "NA"
  variable ZYNQFLASHTYP "NA"
  variable FPGAFLASHTYP "NA"
  variable CFGMEM_IF "NA"
  variable CFGMEM_MEMSIZE_MB "NA"
  variable PCB_REV "NA"
  variable DDR_SIZE "NA"
  variable FLASH_SIZE "NA"
  variable EMMC_SIZE "NA"
  variable OTHERS "NA"
  variable NOTES "NA"
  #filename -> VPROJ_NAME_SHORTDIR
  variable PB_FILENAME "NA"
  # -----------------------------------
  #project run (use default name)
  #for renaming use prefix sim*, syn*, imp* and con*!
  variable TIMEOUT 120
  variable RUNNING_JOBS 4
  #todo: multiple runs and strategies and modified strategies 
  variable SIM_NAME sim_1
  variable SYNTH_NAME synth_1
  variable IMPL_NAME impl_1
  variable CONST_NAME constrs_1
  variable SOURCE_NAME sources_1
  # -----------------------------------
  # check csv file ids
  variable SCRIPTVER    "2021.2.20"
  variable BOARDDEF_CSV "1.4"
  variable SW_IP_CSV    "2.5"
  variable BDMOD_CSV    "1.1"
  variable ZIP_CSV      "1.0"
  variable ZIPINFO_CSV  "1.0"
  variable PROD_CFG_CSV "1.1"
  # -----------------------------------
  variable SW_APPLIST [list]
  #BOARD_DEFINITION currently in BDEF todo set to init in settings
  variable BD_MOD_COMMENT [list]
  variable BD_MOD_ADD [list]
  variable BD_MOD_PCOMMENT [list]
  variable BD_MOD_PADD [list]
  variable BD_TCLNAME "NA"
  variable PR_TOPLEVELNAME "NA"
  variable IS_ZSYS false
  variable IS_ZUSYS false
  variable IS_MSYS false
  variable IS_FSYS false
  variable VERSION_CONTROL true
  # -----------------------------------
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished TE variables declaration
  # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  namespace eval INIT {
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # initial functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
    #--------------------------------
    #--import_usr_tcl:     
    proc init_usr_tcl {} {
    # hidden function: official not supported
      set usr_script []
      if { ![catch {set usr_script [glob -join -dir ${TE::SET_PATH}/usr/ *.tcl]}] } {
          TE::UTILS::te_msg TE_INIT-58 INFO "Load additional user TCL-script:\n ${usr_script}"
          uplevel 1 [ list ::source ${usr_script}]
      }
    }  
    #--------------------------------
    #--print_version:  
    proc print_version {} {
      set viv_version "NA"
      if {[catch {set viv_version [lindex [split [::version] "\n"] 0]}]} { set viv_version "Unknown" }
      set TE::BATCH_FILE_NAME "NA"
      if {[catch {set TE::BATCH_FILE_NAME $::env(batchfile_name)}]} { set TE::BATCH_FILE_NAME "Unknown" }
      set TE::XILINX_INSTALL_DIR "NA"
      if {[catch {set TE::XILINX_INSTALL_DIR $::env(XILDIR)}]} { set TE::XILINX_INSTALL_DIR "Unknown" }
      
      TE::UTILS::te_msg TE_INIT-0 INFO "Script Info:\n \
        Xilinx Directory:                           $TE::XILINX_INSTALL_DIR\n \
        Vivado Version:                             $viv_version\n \
        TE Script Version:                          $TE::SCRIPTVER\n \
        Board Part (Definition Files) CSV Version:  $TE::BOARDDEF_CSV\n \
        Software IP CSV Version:                    $TE::SW_IP_CSV\n \
        Board Design Modify CSV Version:            $TE::BDMOD_CSV\n \
        ZIP ignore CSV Version:                     $TE::ZIP_CSV\n \
        ---\n \
        Start project with:                         $TE::BATCH_FILE_NAME\n \
        ------"
    }
    #--------------------------------
    #--print_environment_settings:  
    proc print_environment_settings {} {
      set TE::VIVADO_AVAILABLE 0
      set TE::LABTOOL_AVAILABLE 0
      set TE::SDK_AVAILABLE 0
      set TE::PETALINUX_AVAILABLE 0
      set TE::SDSOC_AVAILABLE 0
      set USE_XILINX_PETALINUX 0
      catch {set TE::VIVADO_AVAILABLE        $::env(VIVADO_AVAILABLE)}
      catch {set TE::LABTOOL_AVAILABLE       $::env(LABTOOL_AVAILABLE)}
      catch {set TE::SDK_AVAILABLE           $::env(SDK_AVAILABLE)}
      catch {set TE::PETALINUX_AVAILABLE     $::env(PETALINUX_AVAILABLE)}
      catch {set USE_XILINX_PETALINUX     $::env(USE_XILINX_PETALINUX)}
      if {$USE_XILINX_PETALINUX ==0 && $TE::PETALINUX_AVAILABLE==1} {
        TE::UTILS::te_msg TE_INIT-213 {CRITICAL WARNING} "Petalinux script features (beta usages) are disbled, enable it on design_basic_settings.sh, in case it should be used"
        set TE::PETALINUX_AVAILABLE 0
      }
			#change envirment
			catch {set TE::TIMEOUT 			          $::env(TE_TIMEOUT)}
			catch {set TE::RUNNING_JOBS 	          $::env(TE_RUNNING_JOBS)}
      TE::UTILS::te_msg TE_INIT-1 INFO "Script Environment:\n \
        TIMEOUT Setting:          $TE::TIMEOUT \n \
        RUNNING_JOBS Setting:     $TE::RUNNING_JOBS \n \
        Vivado Setting:           $TE::VIVADO_AVAILABLE \n \
        LabTools Setting:         $TE::LABTOOL_AVAILABLE \n \
        VITIS Setting:            $TE::SDK_AVAILABLE \n \
        Petalinux Setting:        $TE::PETALINUX_AVAILABLE \n \
        ------"

      if {$TE::SDK_AVAILABLE==1 && $TE::SDSOC_AVAILABLE==1} {
        TE::UTILS::te_msg TE_INIT-2 WARNING "SDK settings are overwritten by SDSOC settings."
      }
			
			
    }
    #--------------------------------
    #--init_pathvar:  
    proc init_pathvar {} {
      set tmppath [pwd]
      if {[file tail [pwd]]=="vivado"} {
        cd ..
      }
      set TE::BASEFOLDER [pwd]
      set TE::VPROJ_NAME [file tail [pwd]]
      set TE::VPROJ_PATH [pwd]/vivado
      set TE::VLABPROJ_PATH [pwd]/vivado_lab
      #--
      set TE::BOARDDEF_PATH [pwd]/board_files
      set TE::FIRMWARE_PATH [pwd]/firmware
      #--
      set TE::IP_PATH [pwd]/ip_lib
      set TE::BD_PATH [pwd]/block_design
      set TE::XDC_PATH [pwd]/constraints
      set TE::HDL_PATH [pwd]/hdl
      set TE::SET_PATH [pwd]/settings
      set TE::PETALINUX_PATH [pwd]/os/petalinux
      #--
      set TE::WORKSPACE_PATH [pwd]/workspace
      #todo delete HSI_PATH in some of the next releases, only sdk is valid
      set TE::WORKSPACE_HSI_PATH ${TE::WORKSPACE_PATH}/hsi
      set TE::WORKSPACE_SDK_PATH ${TE::WORKSPACE_PATH}/sdk
      #--
      set TE::LIB_PATH [pwd]/sw_lib
      set TE::SCRIPT_PATH [pwd]/scripts
      set TE::DOC_PATH [pwd]/doc
      #--
      set TE::PREBUILT_PATH [pwd]/prebuilt
      set TE::PREBUILT_BI_PATH ${TE::PREBUILT_PATH}/boot_images
      set TE::PREBUILT_HW_PATH ${TE::PREBUILT_PATH}/hardware
      set TE::PREBUILT_SW_PATH ${TE::PREBUILT_PATH}/software
      set TE::PREBUILT_OS_PATH ${TE::PREBUILT_PATH}/os
      
      # TE::PREBUILT_EXPORT_PATH -> osolete todo remove
      set TE::PREBUILT_EXPORT_PATH ${TE::BASEFOLDER}/../export
      
      #--
      set TE::LOG_PATH [pwd]/v_log
      set TE::BACKUP_PATH [pwd]/backup
      #--
      set TE::ZIP_PATH ""
      catch {set TE::ZIP_PATH $::env(ZIP_PATH)}
      #--
      # set TE::SDSOC_PATH obsolete todo remove
      set TE::SDSOC_PATH [pwd]/../SDSoC_PFM
      #--
      set TE::XRT_PATH [pwd]/xrt
      if {[file exists  $TE::XRT_PATH]} { 
        set TE::XRT_USED true
      } else {
        set TE::XRT_USED false
      }
      #--
      set TE::TMP_PATH [pwd]/tmp
      #--
      set TE::ADD_SD_PATH [pwd]/misc/sd
      #--
      set TE::XILINXGIT_DEVICETREE ""
      catch {set TE::XILINXGIT_DEVICETREE $::env(XILINXGIT_DEVICETREE)}
      set TE::XILINXGIT_UBOOT ""
      catch {set TE::XILINXGIT_UBOOT $::env(XILINXGIT_UBOOT)}
      set TE::XILINXGIT_LINUX ""
      catch {set TE::XILINXGIT_LINUX $::env(XILINXGIT_LINUX)}
      #--
      TE::UTILS::te_msg TE_INIT-3 INFO "Initial project names and paths:\n \
        TE::VPROJ_NAME:           $TE::VPROJ_NAME \n \
        TE::VPROJ_PATH:           $TE::VPROJ_PATH \n \
        TE::VLABPROJ_PATH:        $TE::VLABPROJ_PATH \n \
        TE::BOARDDEF_PATH:        $TE::BOARDDEF_PATH \n \
        TE::FIRMWARE_PATH:        $TE::FIRMWARE_PATH \n \
        TE::IP_PATH:              $TE::IP_PATH \n \
        TE::BD_PATH:              $TE::BD_PATH \n \
        TE::XDC_PATH:             $TE::XDC_PATH \n \
        TE::HDL_PATH:             $TE::HDL_PATH \n \
        TE::SET_PATH:             $TE::SET_PATH \n \
        TE::PETALINUX_PATH:       $TE::PETALINUX_PATH \n \
        TE::WORKSPACE_HSI_PATH:   $TE::WORKSPACE_HSI_PATH \n \
        TE::WORKSPACE_SDK_PATH:   $TE::WORKSPACE_SDK_PATH \n \
        TE::LIB_PATH:             $TE::LIB_PATH \n \
        TE::SCRIPT_PATH:          $TE::SCRIPT_PATH \n \
        TE::DOC_PATH:             $TE::DOC_PATH \n \
        TE::PREBUILT_BI_PATH:     $TE::PREBUILT_BI_PATH \n \
        TE::PREBUILT_HW_PATH:     $TE::PREBUILT_HW_PATH \n \
        TE::PREBUILT_SW_PATH:     $TE::PREBUILT_SW_PATH \n \
        TE::PREBUILT_OS_PATH:     $TE::PREBUILT_OS_PATH \n \
        TE::PREBUILT_EXPORT_PATH: $TE::PREBUILT_EXPORT_PATH \n \
        TE::LOG_PATH:             $TE::LOG_PATH \n \
        TE::BACKUP_PATH:          $TE::BACKUP_PATH \n \
        TE::ZIP_PATH:             $TE::ZIP_PATH \n \
        TE::XRT_PATH:             $TE::XRT_PATH \n \
        TE::XRT_USED:             $TE::XRT_USED \n \
        TE::SDSOC_PATH:           $TE::SDSOC_PATH \n \
        TE::ADD_SD_PATH:          $TE::ADD_SD_PATH \n \
        TE::TMP_PATH:             $TE::TMP_PATH \n \
        TE::XILINXGIT_DEVICETREE: $TE::XILINXGIT_DEVICETREE \n \
        TE::XILINXGIT_UBOOT:      $TE::XILINXGIT_UBOOT \n \
        TE::XILINXGIT_LINUX:      $TE::XILINXGIT_LINUX \n \
        ------"

      cd $tmppath
    } 
    #--------------------------------
    #--init_board:  
    proc init_board {ID POS {silent false}} {
      TE::BDEF::get_check_unique_name $ID $POS $silent

      set TE::ID            [TE::BDEF::get_id $ID $POS]
      set TE::PRODID        [TE::BDEF::get_prodid $ID $POS]
      set TE::BOARDPART     [TE::BDEF::get_boardname $ID $POS]
      set TE::PARTNAME      [TE::BDEF::get_partname $ID $POS]
      set TE::SHORTDIR      [TE::BDEF::get_shortname $ID $POS]
      set TE::ZYNQFLASHTYP  [TE::BDEF::get_zynqflashtyp $ID $POS]
      set TE::PB_FILENAME "${TE::VPROJ_NAME}_${TE::SHORTDIR}"
      set tmp [TE::BDEF::get_fpgaflashtyp $ID $POS]
      #todo extrakt CFGMEM_IF and CFGMEM_MEMSIZE_MB from FPGAFLASHTYP-name and from bitfile configuration
      set tmp [split $tmp "|"]
      if {[llength $tmp] eq 3} {
        set TE::FPGAFLASHTYP [lindex $tmp 0]
        set TE::CFGMEM_IF [lindex $tmp 1]
        set TE::CFGMEM_MEMSIZE_MB [lindex $tmp 2]
      } else {
        set TE::FPGAFLASHTYP $tmp
        set TE::CFGMEM_IF "NA"
        set TE::CFGMEM_MEMSIZE_MB "NA"
      }
      set TE::PCB_REV [TE::BDEF::get_pcb_rev $ID $POS]
      set TE::DDR_SIZE [TE::BDEF::get_ddr_size $ID $POS]
      set TE::FLASH_SIZE [TE::BDEF::get_flash_size $ID $POS]
      set TE::EMMC_SIZE [TE::BDEF::get_emmc_size $ID $POS]
      set TE::OTHERS [TE::BDEF::get_others $ID $POS]
      set TE::NOTES [TE::BDEF::get_notes $ID $POS]
      if {!$silent} {
      TE::UTILS::te_msg TE_INIT-4 INFO "Board Part definition:\n \
        TE::ID:             $TE::ID \n \
        TE::PRODID:         $TE::PRODID \n \
        TE::PARTNAME:       $TE::PARTNAME \n \
        TE::BOARDPART:      $TE::BOARDPART \n \
        TE::SHORTDIR:       $TE::SHORTDIR \n \
        TE::ZYNQFLASHTYP:   $TE::ZYNQFLASHTYP \n \
        TE::FPGAFLASHTYP:   $TE::FPGAFLASHTYP \n \
        TE::PCB_REV:        $TE::PCB_REV \n \
        TE::DDR_SIZE:       $TE::DDR_SIZE \n \
        TE::FLASH_SIZE:     $TE::FLASH_SIZE \n \
        TE::EMMC_SIZE:      $TE::EMMC_SIZE \n \
        TE::OTHERS:         $TE::OTHERS \n \
        TE::NOTES:          $TE::NOTES \n \
        ------"
      }
    } 
    #--------------------------------
    #--init_part_only:  init fpga part if found in csv (used if board part is not defined on open project)
    proc init_part_only {partname} {
      #--check if fpga part is unique
        #-2 not found
        #-1 some same
        #0 unique
        #1 all same
      set pcheck [TE::BDEF::get_check_unique_name $partname 2]
      if {$pcheck == 0 } {
        set TE::ID            [TE::BDEF::get_id $partname 2]
        set TE::PRODID        "NA"
        set TE::BOARDPART     "NA"
        set TE::PARTNAME      [TE::BDEF::get_partname $partname 2]
        set TE::SHORTDIR      [TE::BDEF::get_shortname $partname 2]
        set TE::ZYNQFLASHTYP  [TE::BDEF::get_zynqflashtyp $partname 2]
        set tmp [TE::BDEF::get_fpgaflashtyp $partname 2]
        #todo extrakt CFGMEM_IF and CFGMEM_MEMSIZE_MB from FPGAFLASHTYP-name and from bitfile configuration
        set tmp [split $tmp "|"]
        if {[llength $tmp] eq 3} {
          set TE::FPGAFLASHTYP [lindex $tmp 0]
          set TE::CFGMEM_IF [lindex $tmp 1]
          set TE::CFGMEM_MEMSIZE_MB [lindex $tmp 2]
        } else {
          set TE::FPGAFLASHTYP $tmp
          set TE::CFGMEM_IF "NA"
          set TE::CFGMEM_MEMSIZE_MB "NA"
        }
        set TE::PCB_REV [TE::BDEF::get_pcb_rev $ID $POS]
        set TE::DDR_SIZE [TE::BDEF::get_ddr_size $ID $POS]
        set TE::FLASH_SIZE [TE::BDEF::get_flash_size $ID $POS]
        set TE::EMMC_SIZE [TE::BDEF::get_emmc_size $ID $POS]
        set TE::OTHERS [TE::BDEF::get_others $ID $POS]
        set TE::NOTES [TE::BDEF::get_notes $ID $POS]

        TE::UTILS::te_msg TE_INIT-5 WARNING "Board Part definition initialization with unique part name:\n \
          TE::ID:             $TE::ID \n \
          TE::PRODID:         $TE::PRODID \n \
          TE::PARTNAME:       $TE::PARTNAME \n \
          TE::BOARDPART:      $TE::BOARDPART \n \
          TE::SHORTDIR:       $TE::SHORTDIR \n \
          TE::ZYNQFLASHTYP:   $TE::ZYNQFLASHTYP \n \
          TE::FPGAFLASHTYP:   $TE::FPGAFLASHTYP \n \
          TE::PCB_REV:        $TE::PCB_REV \n \
          TE::DDR_SIZE:       $TE::DDR_SIZE \n \
          TE::FLASH_SIZE:     $TE::FLASH_SIZE \n \
          TE::EMMC_SIZE:      $TE::EMMC_SIZE \n \
          TE::OTHERS:         $TE::OTHERS \n \
          TE::NOTES:          $TE::NOTES \n \
          ------"
      } elseif  {$pcheck == 1 } {
        #todo check if flash is the same on all definitions
        set TE::ID            "NA"
        set TE::PRODID        "NA"
        set TE::BOARDPART     "NA"
        set TE::PARTNAME      [TE::BDEF::get_partname $partname 2]
        #short name is fpga name
        set TE::SHORTDIR      [TE::BDEF::get_shortname $partname 2]
        set TE::ZYNQFLASHTYP  "NA"
        set TE::FPGAFLASHTYP  "NA"
        set TE::CFGMEM_IF     "NA"
        set TE::CFGMEM_MEMSIZE_MB "NA"
        set TE::PCB_REV     "NA"
        set TE::DDR_SIZE    "NA"
        set TE::FLASH_SIZE  "NA"
        set TE::EMMC_SIZE   "NA"
        set TE::OTHERS      "NA"
        set TE::NOTES       "Identifier on CSV was't unique ($pcheck)"
        
        TE::UTILS::te_msg TE_INIT-6 WARNING "Board Part definition initialization with same part name:\n \
          TE::ID:             $TE::ID \n \
          TE::PRODID:         $TE::PRODID \n \
          TE::PARTNAME:       $TE::PARTNAME \n \
          TE::BOARDPART:      $TE::BOARDPART \n \
          TE::SHORTDIR:       $TE::SHORTDIR \n \
          TE::ZYNQFLASHTYP:   $TE::ZYNQFLASHTYP \n \
          TE::FPGAFLASHTYP:   $TE::FPGAFLASHTYP \n \
          TE::PCB_REV:        $TE::PCB_REV \n \
          TE::DDR_SIZE:       $TE::DDR_SIZE \n \
          TE::FLASH_SIZE:     $TE::FLASH_SIZE \n \
          TE::EMMC_SIZE:      $TE::EMMC_SIZE \n \
          TE::OTHERS:         $TE::OTHERS \n \
          TE::NOTES:          $TE::NOTES \n \
        ------"
      } else {
        set TE::ID            "NA"
        set TE::PRODID        "NA"
        set TE::BOARDPART     "NA"
        set TE::PARTNAME      $partname
        set TE::SHORTDIR      $partname
        set TE::ZYNQFLASHTYP  "NA"
        set TE::FPGAFLASHTYP  "NA"
        set TE::CFGMEM_IF     "NA"
        set TE::CFGMEM_MEMSIZE_MB "NA"
        set TE::PCB_REV     "NA"
        set TE::DDR_SIZE    "NA"
        set TE::FLASH_SIZE  "NA"
        set TE::EMMC_SIZE   "NA"
        set TE::OTHERS      "NA"
        set TE::NOTES       "Identifier on CSV was't unique ($pcheck)"
        
        TE::UTILS::te_msg TE_INIT-7 {CRITICAL WARNING} "Board Part definition initialization with unknown part name:\n \
          TE::ID:             $TE::ID \n \
          TE::PRODID:         $TE::PRODID \n \
          TE::PARTNAME:       $TE::PARTNAME \n \
          TE::BOARDPART:      $TE::BOARDPART \n \
          TE::SHORTDIR:       $TE::SHORTDIR \n \
          TE::ZYNQFLASHTYP:   $TE::ZYNQFLASHTYP \n \
          TE::FPGAFLASHTYP:   $TE::FPGAFLASHTYP \n \
          TE::PCB_REV:        $TE::PCB_REV \n \
          TE::DDR_SIZE:       $TE::DDR_SIZE \n \
          TE::FLASH_SIZE:     $TE::FLASH_SIZE \n \
          TE::EMMC_SIZE:      $TE::EMMC_SIZE \n \
          TE::OTHERS:         $TE::OTHERS \n \
          TE::NOTES:          $TE::NOTES \n \
        ------"
      }

    }
    #--------------------------------
    #--check_bdtyp: check BD typ
    proc check_bdtyp {} {
      set bd_files []
      set TE::BD_TCLNAME "NA"
      set TE::PR_TOPLEVELNAME "NA"
      set TE::IS_ZSYS   false
      set TE::IS_ZUSYS  false
      set TE::IS_MSYS   false 
      set TE::IS_FSYS   false   
      #get bd_filelist
      set bd_files [TE::UTILS::search_bd_files]
      foreach bd $bd_files {
        set TE::BD_TCLNAME  [file tail [file rootname $bd]]
        set TE::PR_TOPLEVELNAME  "[string map {"_bd" ""} $TE::BD_TCLNAME]_wrapper"
        TE::UTILS::te_msg TE_INIT-8 INFO "Found BD-Design:\n \
          TE::BD_TCLNAME:       $TE::BD_TCLNAME \n \
          TE::PR_TOPLEVELNAME: $TE::PR_TOPLEVELNAME \n \
          ------"
        #check typ for other functions
        if {[string match *zsys* $TE::BD_TCLNAME ]} {set TE::IS_ZSYS true;          TE::UTILS::te_msg TE_INIT-9  STATUS "  TE::IS_ZSYS:         $TE::IS_ZSYS"
        } elseif {[string match *zusys* $TE::BD_TCLNAME ]} {set TE::IS_ZUSYS true;  TE::UTILS::te_msg TE_INIT-10 STATUS "  TE::IS_ZUSYS:        $TE::IS_ZUSYS"
        } elseif {[string match *msys* $TE::BD_TCLNAME ]}  {set TE::IS_MSYS true;   TE::UTILS::te_msg TE_INIT-11 STATUS "  TE::IS_MSYS:         $TE::IS_MSYS"
        } elseif {[string match *fsys* $TE::BD_TCLNAME ]}  {set TE::IS_FSYS true;   TE::UTILS::te_msg TE_INIT-12 STATUS "  TE::IS_FSYS:         $TE::IS_FSYS"
        } else {
          TE::UTILS::te_msg TE_INIT-13 WARNING "Not all TE-functions support unknown BD Filename. Use: \n \
            \"*zsys*.tcl\" for Systems with Zynq \n \
            \"*zusys*.tcl\" for Systems with UltraScale Zynq \n \
            \"*msys*.tcl\" for Systems with MicroBlaze \n \
            \"*fsys*.tcl\" for Systems with FPGA-Fabric design only \n \
            ------"
        }
      }
    }
    #--------------------------------
    #--init_boardlist: 
    proc init_boardlist {} {
      set board_files ""
      set TE::BDEF::BOARD_DEFINITION [list]
      if { [catch {set board_files [ glob $TE::BOARDDEF_PATH/*board_files_mod.csv ] }] } {
        if { [catch {set board_files [ glob $TE::BOARDDEF_PATH/*board_files.csv ] }] } {
          TE::UTILS::te_msg TE_INIT-14 WARNING "No board part definition list found (Path: ${TE::BOARDDEF_PATH})."
        }
      } else {
        TE::UTILS::te_msg TE_INIT-15 WARNING "Modified board part definition list found (File: ${board_files})."
      }
      if {$board_files ne ""} {
        TE::UTILS::te_msg TE_INIT-16 INFO "Read board part definition list (File ${board_files})."
        set fp [open "${board_files}" r]
        set file_data [read $fp]
        close $fp
        # set TE::BDEF::BOARD_DEFINITION [list]
        set data [split $file_data "\n"]
        foreach line $data {
          #  check file version ignore comments and empty lines
          if {[string match *#* $line] != 1 && [string match *CSV_VERSION* $line] } {
            # in case somebody has save csv with other programm add comma can be add
            set linetmp [lindex $[split $line ","] 0]
            #remove spaces
            set linetmp [string map {" " ""} $linetmp]
            #remove tabs
            set linetmp [string map {"\t" ""} $linetmp]
            #check version
            set tmp [split $linetmp "="]
            if {[string match [lindex $tmp 1] $TE::BOARDDEF_CSV] != 1} {
              TE::UTILS::te_msg TE_INIT-17 ERROR "Wrong board part definition CSV version (${TE::BOARDDEF_PATH}/board_files.csv) get [lindex $tmp 1] expected ${TE::BOARDDEF_CSV}."
              return -code error "Wrong board part definition CSV version (${TE::BOARDDEF_PATH}/board_files.csv) get [lindex $tmp 1] expected ${TE::BOARDDEF_CSV}."
            }
          } elseif {[string match *#* $line] != 1 && [string length $line] > 0} {
            #remove spaces
            # set line [string map {" " ""} $line]
            #remove tabs
            # set line [string map {"\t" ""} $line]
            #split and append
            set tmp [split $line ","]
            for {set index 0 } {$index < [llength $tmp]} {incr index} {
              set tempvalue [lindex $tmp $index]
              if {[string match *\"* $tempvalue] == 1} {
                set tempvalue2 [split $tempvalue "\""]
                if { [llength $tempvalue2] > 2 } {
                 set tempvalue [lindex $tempvalue2 1]
                 set tmp [lreplace $tmp $index $index $tempvalue]
                }
              } else {
                #remove spaces
                set tempvalue [string map {" " ""} $tempvalue]
                #remove tabs
                set tempvalue [string map {"\t" ""} $tempvalue]
                #replace
                set tmp [lreplace $tmp $index $index $tempvalue]
              }  
            }
            lappend TE::BDEF::BOARD_DEFINITION $tmp
          }
        }
        #
        #check_possitions
        TE::BDEF::set_board_definition_index
        #filter board parts
        if {[llength $TE::FILTER_DESIGN] > 0} {
          set filter "NONE"
          foreach element $TE::FILTER_DESIGN {
            set filter "*${element}*"
            set TE::BDEF::BOARD_DEFINITION [TE::UTILS::print_boardlist $TE::BDEF::BOARD_DEFINITION ${TE::BDEF::DESIGN} ${filter} false true]
          }
        } else {
            # check of TBD entries are included which must be removed
            set TE::BDEF::BOARD_DEFINITION [TE::UTILS::print_boardlist $TE::BDEF::BOARD_DEFINITION ${TE::BDEF::DESIGN} NA false true]
        }
      }
    }
    #--------------------------------
    #--init_app_list: 
    proc init_app_list {} {
      set version_check false
      set alist_header false
      set blist_header false
      set plist_header false
      
      set TE::SDEF::SW_DOMLIST [list]
      set TE::SDEF::SW_BSPLIST [list]
      set TE::SDEF::SW_APPLIST [list]
      if {[file exists  ${TE::LIB_PATH}/apps_list.csv]} { 
        TE::UTILS::te_msg TE_INIT-18 INFO "Read Software list (File: ${TE::LIB_PATH}/apps_list.csv)."
        set fp [open "${TE::LIB_PATH}/apps_list.csv" r]
        set file_data [read $fp]
        close $fp
        set data [split $file_data "\n"]
        # set fsbl_name ""
        foreach line $data {
          #  check file version ignore comments and empty lines
          if {[string match *#* $line] != 1 && [string match *CSV_VERSION* $line] } {
            # in case somebody has save csv with other programm add comma can be add
            set linetmp [lindex $[split $line ";"] 0]
            #remove spaces
            set linetmp [string map {" " ""} $linetmp]
            #remove tabs
            set linetmp [string map {"\t" ""} $linetmp]
            #check version
            set tmp [split $linetmp "="]
            if {[string match [lindex $tmp 1] $TE::SW_IP_CSV] != 1} {
              TE::UTILS::te_msg TE_INIT-19 ERROR "Wrong Software Definition CSV Version (${TE::LIB_PATH}/apps_list.csv) get [lindex $tmp 1] expected ${TE::SW_IP_CSV}."
              return -code error "Wrong Software Definition CSV Version (${TE::LIB_PATH}/apps_list.csv) get [lindex $tmp 1] expected $TE::SW_IP_CSV"
            } else {
              set version_check true
              TE::UTILS::te_msg TE_INIT-189 INFO "Software Definition CSV version passed"
            }
          } elseif {[string match *#* $line] != 1 && [string length $line] > 0} {
            if {$version_check eq false} {
              TE::UTILS::te_msg TE_INIT-190 ERROR "Software Definition CSV Version check was not done."
              return -code error "Software Definition CSV Version check was not done. (${TE::LIB_PATH}/apps_list.csv). CSV_VERSION=$TE::SW_IP_CSV missing"
            } else {
              set tmp [split $line ";"]
              for {set index 0 } {$index < [llength $tmp]} {incr index} {
                set tempvalue [lindex $tmp $index]
                if {[string match *\"* $tempvalue] == 1} {
                  set tempvalue2 [split $tempvalue "\""]
                  if { [llength $tempvalue2] > 2 } {
                   set tempvalue [lindex $tempvalue2 1]
                   set tmp [lreplace $tmp $index $index $tempvalue]
                  }
                } else {
                  #remove spaces
                  set tempvalue [string map {" " ""} $tempvalue]
                  #remove tabs
                  set tempvalue [string map {"\t" ""} $tempvalue]
                  #replace
                  set tmp [lreplace $tmp $index $index $tempvalue]
                }  
              }
              set table [lindex $tmp 0]
              set tmp [lreplace $tmp 0 0] 
              set element_length [llength $tmp]
              if {$table eq "domain"} {
                #header
                if {[string match "id" [lindex $tmp 0]] } {
                  TE::UTILS::te_msg TE_INIT-191 INFO "Software Definition CSV Version analyze domain table header"
                  
                  set element NA
                  for {set i 0} {$i < $element_length} {incr i} {
                    set element [lindex $tmp $i]
                    switch $element {
                      "id" {
                        set TE::SDEF::D_ID $i
                      }
                      "an" {
                        set TE::SDEF::D_AN $i
                      }
                      "name" {
                        set TE::SDEF::D_NAME $i
                      }
                      "proc" {
                        set TE::SDEF::D_PROC $i
                      }
                      "os" {
                        set TE::SDEF::D_OS $i
                      }
                      default {
                           TE::UTILS::te_msg TE_INIT-192 {CRITICAL WARNING} "Software Definition CSV unknown element: $element for $table."
                      }
                    }
                  }
                  
                  # append
                  lappend TE::SDEF::SW_DOMLIST $tmp
                  set plist_header true
                  
                } else {
                  lappend TE::SDEF::SW_DOMLIST $tmp
                }
              } elseif {$table eq "bsp"} {
                #header
                if {[string match "id" [lindex $tmp 0]] } {
                  TE::UTILS::te_msg TE_INIT-193 INFO "Software Definition CSV Version analyze bsp table header"
                  set element NA
                  for {set i 0} {$i < $element_length} {incr i} {
                    set element [lindex $tmp $i]
                    switch $element {
                      "id" {
                        set TE::SDEF::B_ID $i
                      }
                      "an" {
                        set TE::SDEF::B_AN $i
                      }
                      "name" {
                        set TE::SDEF::B_NAME $i
                      }
                      "uart" {
                        set TE::SDEF::B_UART $i
                      }
                      "libs" {
                        set TE::SDEF::B_LIBS $i
                      }
                      "os" {
                        set TE::SDEF::B_OS $i
                      }
                      "config" {
                        set TE::SDEF::B_CONFIG $i
                      }
                      default {
                           TE::UTILS::te_msg TE_INIT-194 {CRITICAL WARNING} "Software Definition CSV unknown element: $element for $table."
                      }
                    }
                  }
                  
                  # append
                  lappend TE::SDEF::SW_BSPLIST $tmp
                  set blist_header true
                  
                } else {
                  lappend TE::SDEF::SW_BSPLIST $tmp
                }
              } elseif {$table eq "appmp"} {
                #header
                if {[string match "id" [lindex $tmp 0]] } {
                  TE::UTILS::te_msg TE_INIT-195 INFO "Software Definition CSV Version analyze app table header"
                  set element NA
                  for {set i 0} {$i < $element_length} {incr i} {
                    set element [lindex $tmp $i]
                    switch $element {
                      "id" {
                        set TE::SDEF::ID $i
                      }
                      "an" {
                        set TE::SDEF::AN $i
                      }
                      "name" {
                        set TE::SDEF::APPNAME $i
                      }
                      "template_name" {
                        set TE::SDEF::TEMPLATE_NAME $i
                      }
                      "steps" {
                        set TE::SDEF::STEPS $i
                      }
                      "os" {
                        set TE::SDEF::OSNAME $i
                      }
                      "build" {
                        set TE::SDEF::BUILD $i
                      }
                      "csymb" {
                        set TE::SDEF::CSYMB $i
                      }
                      "destination_cpu" {
                        set TE::SDEF::DESTINATION_CPU $i
                      }
                      "uboot_dtb_load" {
                        set TE::SDEF::UBOOT_DTB_LOAD $i
                      }
                      "uboot_dtb_offset" {
                        set TE::SDEF::UBOOT_DTB_OFFSET $i
                      }
                      "bootscr_load" {
                        set TE::SDEF::BOOTSCR_LOAD $i
                      }
                      "bootscr_offset" {
                        set TE::SDEF::BOOTSCR_OFFSET $i
                      }
                      "data01_file" {
                        set TE::SDEF::MB_DATA01_FILE $i
                      }
                      "data01_load" {
                        set TE::SDEF::MB_DATA01_LOAD $i
                      }
                      "data01_offset" {
                        set TE::SDEF::MB_DATA01_OFFSET $i
                      }
                      default {
                        if {[string match -nocase "data*" $element ]} {
                          #suppress data02...they depends
                        } else {
                          TE::UTILS::te_msg TE_INIT-196 {CRITICAL WARNING} "Software Definition CSV unknown element: $element for $table."
                        }
                      }
                    }
                  }
                  
                  # append
                  lappend TE::SDEF::SW_APPLIST $tmp
                  set alist_header true
                  
                } else {
                  lappend TE::SDEF::SW_APPLIST $tmp
                }
              } elseif {$table eq "appzynq"} {
                #header
                if {[string match "id" [lindex $tmp 0]] } {
                  TE::UTILS::te_msg TE_INIT-197 INFO "Software Definition CSV Version analyze app table header"
                  set element NA
                  for {set i 0} {$i < $element_length} {incr i} {
                    set element [lindex $tmp $i]
                    switch $element {
                      "id" {
                        set TE::SDEF::ID $i
                      }
                      "an" {
                        set TE::SDEF::AN $i
                      }
                      "name" {
                        set TE::SDEF::APPNAME $i
                      }
                      "template_name" {
                        set TE::SDEF::TEMPLATE_NAME $i
                      }
                      "steps" {
                        set TE::SDEF::STEPS $i
                      }
                      "os" {
                        set TE::SDEF::OSNAME $i
                      }
                      "build" {
                        set TE::SDEF::BUILD $i
                      }
                      "csymb" {
                        set TE::SDEF::CSYMB $i
                      }
                      "destination_cpu" {
                        set TE::SDEF::DESTINATION_CPU $i
                      }
                      "uboot_dtb_load" {
                        set TE::SDEF::UBOOT_DTB_LOAD $i
                      }
                      "uboot_dtb_offset" {
                        set TE::SDEF::UBOOT_DTB_OFFSET $i
                      }
                      "bootscr_load" {
                        set TE::SDEF::BOOTSCR_LOAD $i
                      }
                      "bootscr_offset" {
                        set TE::SDEF::BOOTSCR_OFFSET $i
                      }
                      "data01_file" {
                        set TE::SDEF::ZYNQ_DATA01_FILE $i
                      }
                      "data01_load" {
                        set TE::SDEF::ZYNQ_DATA01_LOAD $i
                      }
                      "data01_offset" {
                        set TE::SDEF::ZYNQ_DATA01_OFFSET $i
                      }
                      default {
                        if {[string match -nocase "data*" $element ]} {
                          #suppress data02...they depends
                        } else {
                          TE::UTILS::te_msg TE_INIT-198 {CRITICAL WARNING} "Software Definition CSV unknown element: $element for $table."
												}
                      }
                    }
                  }
                  
                  # append
                  lappend TE::SDEF::SW_APPLIST $tmp
                  set alist_header true
                  
                } else {
                  lappend TE::SDEF::SW_APPLIST $tmp
                }
              } elseif {$table eq "appzynqMP"} {
                #header
                if {[string match "id" [lindex $tmp 0]] } {
                  TE::UTILS::te_msg TE_INIT-199 INFO "Software Definition CSV Version analyze app table header"
                  set element NA
                  for {set i 0} {$i < $element_length} {incr i} {
                    set element [lindex $tmp $i]
                    # puts "TestJH|$i|$element |$TE::SDEF::APPNAME"
                    switch $element {
                      "id" {
                        set TE::SDEF::ID $i
                      }
                      "an" {
                        set TE::SDEF::AN $i
                      }
                      "name" {
                        set TE::SDEF::APPNAME $i
                      }
                      "template_name" {
                        set TE::SDEF::TEMPLATE_NAME $i
                      }
                      "steps" {
                        set TE::SDEF::STEPS $i
                      }
                      "os" {
                        set TE::SDEF::OSNAME $i
                      }
                      "build" {
                        set TE::SDEF::BUILD $i
                      }
                      "csymb" {
                        set TE::SDEF::CSYMB $i
                      }
                      "fsbl_config" {
                        set TE::SDEF::ZYNQMP_FSBL_CONFIG $i
                      }
                      "destination_cpu" {
                        set TE::SDEF::DESTINATION_CPU $i
                      }
                      "uboot_dtb_load" {
                        set TE::SDEF::UBOOT_DTB_LOAD $i
                      }
                      "uboot_dtb_offset" {
                        set TE::SDEF::UBOOT_DTB_OFFSET $i
                      }
                      "bootscr_load" {
                        set TE::SDEF::BOOTSCR_LOAD $i
                      }
                      "bootscr_offset" {
                        set TE::SDEF::BOOTSCR_OFFSET $i
                      }
                      "exception_level" {
                        set TE::SDEF::ZYNQMP_EXCEPTION_LEVEL $i
                      }
                      "atf" {
                        set TE::SDEF::ZYNQMP_ATF $i
                      }
                      "pmu" {
                        set TE::SDEF::ZYNQMP_PMU $i
                      }
                      "data01_file" {
                        set TE::SDEF::ZYNQMP_DATA01_FILE $i
                      }
                      "data01_load" {
                        set TE::SDEF::ZYNQMP_DATA01_LOAD $i
                      }
                      "data01_offset" {
                        set TE::SDEF::ZYNQMP_DATA01_OFFSET $i
                      }
                      default {
                        if {[string match -nocase "data*" $element ]} {
                          #suppress data02...they depends
                        } else {
                          TE::UTILS::te_msg TE_INIT-200 {CRITICAL WARNING} "Software Definition CSV unknown element: $element for $table."
												}
                      }
                    }
                  }
                  
                  # append
                  lappend TE::SDEF::SW_APPLIST $tmp
                  set alist_header true
                  
                } else {
                  lappend TE::SDEF::SW_APPLIST $tmp
                }
              } else {
                TE::UTILS::te_msg TE_INIT-201 {CRITICAL WARNING} "Software Definition CSV unknown definition: $table $tmp."
              }
            }
          }
        }
        #------------------------------------------
        # if {![file exists ${TE::XILINXGIT_DEVICETREE}]} {
          # set tmp_index -1
          # foreach sw_applist_line ${TE::SDEF::SW_APPLIST} {
            # incr tmp_index
            # #currently remove Device Tree from list (currently only additonal files)
            # if {[lindex $sw_applist_line $TE::SDEF::STEPS] eq "DTS" } {
              # TE::UTILS::te_msg TE_INIT-20 {CRITICAL WARNING} "Xilinx Devicetree git clone path not found (Path: ${TE::XILINXGIT_DEVICETREE}). Device-Tree generation will be removed from apps_list.csv"
              # set TE::SDEF::SW_APPLIST [lreplace $TE::SDEF::SW_APPLIST $tmp_index $tmp_index]
            # }
          # }
        # }
        #------------------------------------------
      } else {
        TE::UTILS::te_msg TE_INIT-21 INFO "No software apps_list used."
      }
    }
    #--------------------------------
    #--init_zip_ignore_list: 
    proc init_zip_ignore_list {} {
      set TE::ZIP_IGNORE_LIST [list]
      if {[file exists  ${TE::SET_PATH}/zip_ignore_list.csv]} { 
        TE::UTILS::te_msg TE_INIT-22 INFO "Read ZIP ignore list (File: ${TE::LIB_PATH}/apps_list.csv)."
        set fp [open "${TE::SET_PATH}/zip_ignore_list.csv" r]
        set file_data [read $fp]
        close $fp
        set data [split $file_data "\n"]
        foreach line $data {
          #  check file version ignore comments and empty lines
          if {[string match *#* $line] != 1 && [string match *CSV_VERSION* $line] } {
            #remove spaces
            set line [string map {" " ""} $line]
            #remove tabs
            set line [string map {"\t" ""} $line]
            #check version
            set tmp [split $line "="]
            if {[string match [lindex $tmp 1] $TE::ZIP_CSV] != 1} {
              TE::UTILS::te_msg TE_INIT-23 ERROR " Wrong Zip ignore definition CSV Version (${TE::SET_PATH}/zip_ignore_list.csv) get [lindex $tmp 1] expected ${TE::ZIP_CSV}."
              return -code error "Wrong Zip ignore definition CSV Version (${TE::SET_PATH}/zip_ignore_list.csv) get [lindex $tmp 1] expected ${TE::ZIP_CSV}."
            }
          } elseif {[string match *#* $line] != 1 && [string length $line] > 0} {
            #remove spaces
            set line [string map {" " ""} $line]
            #remove tabs
            set line [string map {"\t" ""} $line]
            #splitt and append
            set tmp [split $line ","]
            lappend TE::ZIP_IGNORE_LIST $tmp
          }
        }
      } else {
        TE::UTILS::te_msg TE_INIT-24 INFO "No Zip ignore list used."
      }
    }
    #--------------------------------
    #--init_mod_list: 
    proc init_mod_list {} {
      set TE::BD_MOD_COMMENT [list]
      set TE::BD_MOD_ADD [list]
      set TE::BD_MOD_PCOMMENT [list]
      set TE::BD_MOD_PADD [list]
      if {[file exists  ${TE::BD_PATH}/mod_bd.csv]} { 
        TE::UTILS::te_msg TE_INIT-25 INFO "Read BD modify list (File: ${TE::BD_PATH}/mod_bd.csv)."
        set fp [open "${TE::BD_PATH}/mod_bd.csv" r]
        set file_data [read $fp]
        close $fp
        set data [split $file_data "\n"]
        foreach line $data {
          #ignore comments and empty lines
          if {[string match *#* $line] != 1 && [string length $line] > 0} {
            #  check file version
            if {[string match *CSV_VERSION* $line] } {
              #remove spaces
              set line [string map {" " ""} $line]
              #remove tabs
              set line [string map {"\t" ""} $line]
              #check version
              set tmp [split $line "="]
              if {[string match [lindex $tmp 1] $TE::BDMOD_CSV] != 1} {
                TE::UTILS::te_msg TE_INIT-26 ERROR "  Wrong BD Modify CSV Version (${TE::BD_PATH}/mod_bd.csv) get [lindex $tmp 1] expected ${TE::BDMOD_CSV}."
                return -code error " Wrong BD Modify CSV Version (${TE::BD_PATH}/mod_bd.csv) get [lindex $tmp 1] expected $TE::BDMOD_CSV"
              }
            } else {
              #split line
              set temp [split $line ","]
              if {[llength $temp] <3} {
                TE::UTILS::te_msg TE_INIT-27 WARNING "Not enough elements on line ($line). Line ignored."
              } else {
                #get line id +remove spaces and tabs
                set line_id [string map {"\t" ""} [string map {" " ""} [lindex $temp 0]]]
                #sort
                if {$line_id eq "id"} {
                  #table header
                  #remove spaces
                  set line [string map {" " ""} $line]
                  #remove tabs
                  set line [string map {"\t" ""} $line]
                  set temp [split $line ","]
                  lappend TE::BD_MOD_COMMENT $temp
                  lappend TE::BD_MOD_ADD $temp
                  lappend TE::BD_MOD_PCOMMENT $temp
                  lappend TE::BD_MOD_PADD $temp
                } elseif {$line_id==0} {
                  # ID 0: remove(comment) line 
                  lappend TE::BD_MOD_COMMENT $temp
                } elseif {$line_id==1} {
                  # ID 1: add line 
                  if {[llength $temp] >3} {
                  # replaced removed comma from modify txt
                    set newinsert_list [list]
                    lappend newinsert_list [lindex $temp 0]
                    lappend newinsert_list [lindex $temp 1]
                    set addstring [lindex $temp 2]
                    for {set i 3} {$i < [llength $temp]} {incr i} {
                      set addstring "${addstring},[lindex $temp $i]"
                    }
                    lappend newinsert_list $addstring
                    set temp $newinsert_list
                  }
                  lappend TE::BD_MOD_ADD $temp
                } elseif {$line_id==2} {
                  # ID 2: remove(comment) property 
                  lappend TE::BD_MOD_PCOMMENT $temp
                } elseif {$line_id==3} {
                  # ID 3: add property
                  lappend TE::BD_MOD_PADD $temp
                } else {
                  #unsupported lines ignored
                  TE::UTILS::te_msg TE_INIT-28 WARNING "Unsupported id ($line_id). Line ignored."
                }
              }
            }
          }
        }
      }
    }
    
    #--------------------------------
    #--get_prod_tcl:
    proc init_prod_tcl {} {
      set version_check false
      set series_tcl NA
      set prodid_tcl NA
      set tmp_series NA
      #--read only file location, content will be set with extentions
      if { [file exists  ${TE::BASEFOLDER}/../prod_cfg_list.csv] } {
        TE::UTILS::te_msg TE_INIT-240 INFO "Read Prod list (File: ${TE::BASEFOLDER}/../prod_cfg_list.csv)."
        # set tmp_series [lindex [split ${TE::PRODID} "-"] 0]
        set tmp_series [lindex [split [TE::BDEF::get_prodid [TE::BDEF::get_id "LAST_ID" ${TE::BDEF::ID}] ${TE::BDEF::ID}] "-"] 0]
        set fp [open "${TE::BASEFOLDER}/../prod_cfg_list.csv" r]
        set file_data [read $fp]
        close $fp
        set data [split $file_data "\n"]
        foreach line $data {
          #  check file version ignore comments and empty lines
          if {[string match *#* $line] != 1 && [string match *CSV_VERSION* $line] } {
            # in case somebody has save csv with other programm add comma can be add
            set linetmp [lindex $[split $line ";"] 0]
            #remove spaces
            set linetmp [string map {" " ""} $linetmp]
            #remove tabs
            set linetmp [string map {"\t" ""} $linetmp]
            #check version
            set tmp [split $linetmp "="]
            if {[string match [lindex $tmp 1] $TE::PROD_CFG_CSV] != 1} {
              TE::UTILS::te_msg TE_INIT-237 ERROR "Wrong Prod Definition CSV Version (${TE::BASEFOLDER}/../prod_cfg_list.csv get [lindex $tmp 1] expected ${TE::PROD_CFG_CSV}."
              return -code error "Wrong Prod Definition CSV Version (${TE::BASEFOLDER}/../prod_cfg_list.csv get [lindex $tmp 1] expected $TE::PROD_CFG_CSV"
            } else {
              set version_check true
              TE::UTILS::te_msg TE_INIT-238 INFO "Software Definition CSV version passed"
            }
          } elseif {[string match *#* $line] != 1 && [string length $line] > 0 } {
            #add only entries for this design
            if {$version_check eq false} {
              TE::UTILS::te_msg TE_INIT-239 ERROR "Prod Definition CSV Version check was not done."
              return -code error "Prod CFG Definition CSV Version check was not done. (${TE::BASEFOLDER}/../prod_cfg_list.csv. CSV_VERSION=$TE::PROD_CFG_CSV missing"
            } else {
              set tmp [split $line ","]
              for {set index 0 } {$index < [llength $tmp]} {incr index} {
                set tempvalue [lindex $tmp $index]
                if {[string match *\"* $tempvalue] == 1} {
                  set tempvalue2 [split $tempvalue "\""]
                  if { [llength $tempvalue2] > 2 } {
                   set tempvalue [lindex $tempvalue2 1]
                   set tmp [lreplace $tmp $index $index $tempvalue]
                  }
                } else {
                  #remove spaces
                  set tempvalue [string map {" " ""} $tempvalue]
                  #remove tabs
                  set tempvalue [string map {"\t" ""} $tempvalue]
                  #replace
                  set tmp [lreplace $tmp $index $index $tempvalue]
                }  
              }
              #use only entries for this project and header
              if {[string match "${TE::VPROJ_NAME}" [lindex $tmp $TE::PROD::DESIGN_NAME]] || [string match "DESIGN_NAME" [lindex $tmp 0]]} {

                lappend TE::PROD::PROD_CFG $tmp
                if {( [string match "2" [lindex $tmp $TE::PROD::TYPE]] ||  [string match "3" [lindex $tmp $TE::PROD::TYPE]]) && ![string match "def" [lindex $tmp $TE::PROD::SEARCH_PATH]]} {
                  if {[string match "${tmp_series}*" [lindex $tmp $TE::PROD::PRODID]] || [string match "${tmp_series}*" [lindex $tmp $TE::PROD::TD_PRODID]]} {
                    set series_tcl [lindex $tmp $TE::PROD::SEARCH_PATH]
                  }
                  if {[string match "${TE::PRODID}" [lindex $tmp $TE::PROD::PRODID]] || [string match "${TE::PRODID}" [lindex $tmp $TE::PROD::TD_PRODID]]} {
                    set prodid_tcl [lindex $tmp $TE::PROD::SEARCH_PATH]
                    #Attention --> curently init only at beginning of main TCL initialisation and only series will be used
                  }
                }
              }
            }
          }
        }
        if {![string match "NA" $prodid_tcl]} {
          TE::UTILS::te_msg TE_INIT-241 INFO "Prod Definition CSV Individual TCL is used ${TE::BASEFOLDER}/$prodid_tcl."
          set TE::PROD::PROD_TCL_FILE $prodid_tcl
        } else {
          TE::UTILS::te_msg TE_INIT-242 INFO "Prod Definition CSV Series TCL is used ${TE::BASEFOLDER}/$series_tcl."
          set TE::PROD::PROD_TCL_FILE $series_tcl
        }
      }
    }
    
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # finished initial functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  }

  namespace eval PROD {
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # internal usage only
  # -----------------------------------------------------------------------------------------------------------------------------------------
    variable PROD_CFG [list] 
    variable PROD_TCL_FILE "NA"
    set DESIGN_NAME 0
    set TYPE 1
    set PRODID 2
    set SEARCH_PATH 3
    set TD_PRODID 4
    set TD_SERIAL 5

  }
  namespace eval SDEF {
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # board part definition functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
    variable SW_DOMLIST [list] 
    variable SW_BSPLIST [list] 
    variable SW_APPLIST [list] 
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # Note oder will be defined by CSV files. --> currently not checked if all set!
    # SDEF --> D_AN,B_AN,AN --> article name for future usage --> different software for assembly versions --> wild card, full names...
    
    #domain list
    set D_ID 0
    set D_AN 0
    set D_NAME 0
    set D_PROC 0
    set D_OS   0
    #bsp list
    set B_ID 0
    set B_AN 0
    set B_NAME 0
    set B_UART 0
    set B_LIBS 0
    set B_OS 0
    set B_CONFIG 0
    #app list
    set ID                            0
    set AN                            0
    set APPNAME                       0
    set TEMPLATE_NAME                 0
    set STEPS                         0
    set OSNAME                        0
    set BUILD                         0
    set CSYMB                         0
    set DESTINATION_CPU               0
    set UBOOT_DTB_LOAD                0
    set BOOTSCR_LOAD                  0
    set UBOOT_DTB_OFFSET              0
    set BOOTSCR_OFFSET                0
    
    set ZYNQMP_FSBL_CONFIG            0
    set ZYNQMP_EXCEPTION_LEVEL        0
    set ZYNQMP_ATF                    0
    set ZYNQMP_PMU                    0
    set ZYNQMP_DATA01_FILE            0
    set ZYNQMP_DATA01_LOAD            0
    set ZYNQMP_DATA01_OFFSET          0
    #...ZYNQMP only 01 possible at the moment
    set MB_DATA01_FILE     0
    set MB_DATA01_LOAD     0
    set MB_DATA01_OFFSET   0
    #...MB multiple files possible 02 (10...12), 03(13..15)
    set ZYNQ_DATA01_FILE      0
    set ZYNQ_DATA01_LOAD      0
    set ZYNQ_DATA01_OFFSET    0
    #...ZYNQ only 01 possible at the moment
    # #domain list
    # set D_ID 0
    # set D_AN 1
    # set D_NAME 2
    # set D_PROC 3
    # set D_OS   4
    # #bsp list
    # set B_ID 0
    # set B_AN 1
    # set B_NAME 2
    # set B_UART 3
    # set B_LIBS 4
    # set B_OS 5
    # set B_CONFIG 6
    # #app list
    # set ID                            0
    # set AN                            1
    # set APPNAME                       2
    # set TEMPLATE_NAME                 3
    # set STEPS                         4
    # set OSNAME                        6
    # set BUILD                         7
    # set CSYMB                         9
    # set DESTINATION_CPU               10
    # set UBOOT_DTB_LOAD                11
    # set BOOTSCR_LOAD                  12
    # set UBOOT_DTB_OFFSET              13
    # set BOOTSCR_OFFSET                14
    
    # set ZYNQMP_FSBL_CONFIG            8
    # set ZYNQMP_EXCEPTION_LEVEL        12
    # set ZYNQMP_ATF                    13
    # set ZYNQMP_PMU                    14
    # set ZYNQMP_DATA01_FILE            15
    # set ZYNQMP_DATA01_LOAD            16
    # set ZYNQMP_DATA01_OFFSET          17
    # #...ZYNQMP only 01 possible at the moment
    # set MB_DATA01_FILE     12
    # set MB_DATA01_LOAD     13
    # set MB_DATA01_OFFSET   14
    # #...MB multiple files possible 02 (10...12), 03(13..15)
    # set ZYNQ_DATA01_FILE      12
    # set ZYNQ_DATA01_LOAD      13
    # set ZYNQ_DATA01_OFFSET    14
    # #...ZYNQ only 01 possible at the moment
  }
  
  namespace eval BDEF {
  # -----------------------------------------------------------------------------------------------------------------------------------------
  # board part definition functions
  # -----------------------------------------------------------------------------------------------------------------------------------------
    variable BOARD_DEFINITION [list] 
    #{"ID" "PRODID" "PARTNAME" "BOARDNAME" "SHORTDIR"} 
    # position (will be checked if available)      
    set ID NA
    set PRODID NA
    set PARTNAME NA
    set BOARDNAME NA
    set SHORTNAME NA
    set ZYNQFLASHTYP NA
    set FPGAFLASHTYP NA
    set PCB_REV NA
    set DDR_SIZE NA
    set FLASH_SIZE NA
    set EMMC_SIZE NA
    set OTHERS NA
    set NOTES NA
    set DESIGN NA
    # configs will be set only if available otherwhise it's NA will be ignored
    set CONFIG_SW_EXTPLL NA
    #--------------------------------
    #--set_board_definition_index:
    proc set_board_definition_index {} {
      variable BOARD_DEFINITION
      if {[llength $BOARD_DEFINITION] > 0} {
        set header [lindex $BOARD_DEFINITION 0]
        #search in id 
        set new_index 0
        
        foreach element $header {
          if {[string match "ID" $element]} {
            set TE::BDEF::ID $new_index
          }
          if {[string match "PRODID" $element]} {
            set TE::BDEF::PRODID $new_index
          }
          if {[string match "PARTNAME" $element]} {
            set TE::BDEF::PARTNAME $new_index
          }
          if {[string match "BOARDNAME" $element]} {
            set TE::BDEF::BOARDNAME $new_index
          }
          if {[string match "SHORTNAME" $element]} {
            set TE::BDEF::SHORTNAME $new_index
          }
          if {[string match "ZYNQFLASHTYP" $element]} {
            set TE::BDEF::ZYNQFLASHTYP $new_index
          }
          if {[string match "FPGAFLASHTYP" $element]} {
            set TE::BDEF::FPGAFLASHTYP $new_index
          }
          if {[string match "PCB_REV" $element]} {
            set TE::BDEF::PCB_REV $new_index
          }
          if {[string match "DDR_SIZE" $element]} {
            set TE::BDEF::DDR_SIZE $new_index
          }
          if {[string match "FLASH_SIZE" $element]} {
            set TE::BDEF::FLASH_SIZE $new_index
          }
          if {[string match "EMMC_SIZE" $element]} {
            set TE::BDEF::EMMC_SIZE $new_index
          }
          if {[string match "OTHERS" $element]} {
            set TE::BDEF::OTHERS $new_index
          }
          if {[string match "NOTES" $element]} {
            set TE::BDEF::NOTES $new_index
          }
          if {[string match "DESIGN" $element]} {
            set TE::BDEF::DESIGN $new_index
          }
          if {[string match "CONFIG_SW_EXTPLL" $element]} {
            set TE::BDEF::CONFIG_SW_EXTPLL $new_index
          }
          set new_index [expr $new_index+1]
        }
        
      }
      if {[string match "NA" $TE::BDEF::ID]} {
        TE::UTILS::te_msg TE_INIT-219 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::PRODID]} {
        TE::UTILS::te_msg TE_INIT-220 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::PARTNAME]} {
        TE::UTILS::te_msg TE_INIT-221 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::BOARDNAME]} {
        TE::UTILS::te_msg TE_INIT-222 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::SHORTNAME]} {
        TE::UTILS::te_msg TE_INIT-223 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::ZYNQFLASHTYP]} {
        TE::UTILS::te_msg TE_INIT-224 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::FPGAFLASHTYP]} {
        TE::UTILS::te_msg TE_INIT-225 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::PCB_REV]} {
        TE::UTILS::te_msg TE_INIT-226 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::DDR_SIZE]} {
        TE::UTILS::te_msg TE_INIT-227 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::FLASH_SIZE]} {
        TE::UTILS::te_msg TE_INIT-228 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::EMMC_SIZE]} {
        TE::UTILS::te_msg TE_INIT-229 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::OTHERS]} {
        TE::UTILS::te_msg TE_INIT-230 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::NOTES]} {
        TE::UTILS::te_msg TE_INIT-231 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }
      if {[string match "NA" $TE::BDEF::DESIGN]} {
        TE::UTILS::te_msg TE_INIT-232 ERROR "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
        return -code error "Corrupted Board definition csv (${TE::BOARDDEF_PATH}/board_files.csv)."
      }


    } 
    set CONFIG_SW_EXTPLL NA
    #extract board definition list from board definition file "board_files.csv"
    #--------------------------------
    #--find_shortdir: 
    proc find_shortdir {NAME} {
      variable BOARD_DEFINITION
      #search in id
      set value [get_shortname $NAME  ${TE::BDEF::ID}]
      if {$value ne "NA"} {TE::UTILS::te_msg TE_INIT-29 STATUS "Found Shortname: $value";return $value}
      #search in productid
      set value [get_shortname $NAME  ${TE::BDEF::PRODID}]
      if {$value ne "NA"} {TE::UTILS::te_msg TE_INIT-30 STATUS "Found Shortname: $value";return $value}
      #search in boardname
      set value [get_shortname $NAME ${TE::BDEF::BOARDNAME}]
      if {$value ne "NA"} {TE::UTILS::te_msg TE_INIT-31 STATUS "Found Shortname: $value";return $value}
      #search in shortname
      set value [get_shortname $NAME ${TE::BDEF::SHORTNAME}]
      if {$value ne "NA"} {TE::UTILS::te_msg TE_INIT-32 STATUS "Found Shortname: $value";return $value}
      #search in part name (only if unique)
      if {[get_check_unique_name $NAME $NAME ${TE::BDEF::PARTNAME}]==0} {
        set value [get_shortname $NAME ${TE::BDEF::PARTNAME}]
        if {$value ne "NA"} {TE::UTILS::te_msg TE_INIT-33 STATUS "Found Shortname: $value";return $value}
      }
      #default
      TE::UTILS::te_msg TE_INIT-34 STATUS "No Shortname found for ${NAME}, use default "
      return "default"
    }   
    #--------------------------------
    #--find_id:     
    proc find_id {NAME {silent false}} {
      variable BOARD_DEFINITION
      #search in id
      set value [get_id $NAME ${TE::BDEF::ID}]
      if {$value ne "NA"} {if {!$silent} {TE::UTILS::te_msg TE_INIT-35 STATUS "Found ID: $value"};return $value}
      #search in productid
      set value [get_id $NAME ${TE::BDEF::PRODID}]
      if {$value ne "NA"} {if {!$silent} {TE::UTILS::te_msg TE_INIT-36 STATUS "Found ID: $value"};return $value}
      #search in boardname
      set value [get_id $NAME ${TE::BDEF::BOARDNAME}]
      if {$value ne "NA"} {if {!$silent} {TE::UTILS::te_msg TE_INIT-37 STATUS "Found ID: $value"};return $value}
      #search in shortname
      set value [get_id $NAME ${TE::BDEF::SHORTNAME}]
      if {$value ne "NA"} {if {!$silent} {TE::UTILS::te_msg TE_INIT-38 STATUS "Found ID: $value"};return $value}
      #search in part name (only if unique)
      if {[get_check_unique_name $NAME ${TE::BDEF::PARTNAME} $silent]==0} {
        set value [get_id $NAME ${TE::BDEF::PARTNAME}]
        if {$value ne "NA"} {if {!$silent} {TE::UTILS::te_msg TE_INIT-39 STATUS "Found ID: $value"};return $value}
      }
      #default
      TE::UTILS::te_msg TE_INIT-40 STATUS "No ID found for ${NAME}, use NA "
      return "NA"
    }
    #--------------------------------
    #--find_partname:         
    proc find_partname {NAME} {
      variable BOARD_DEFINITION
      #search in id
      set value [get_partname $NAME ${TE::BDEF::ID}]
      if {$value ne "NA"} {TE::UTILS::te_msg TE_INIT-41 STATUS "Found part name: $value";return $value}
      #search in productid
      set value [get_partname $NAME ${TE::BDEF::PRODID}]
      if {$value ne "NA"} {TE::UTILS::te_msg TE_INIT-42 STATUS "Found part name: $value";return $value}
      #search in boardname
      set value [get_partname $NAME ${TE::BDEF::BOARDNAME}]
      if {$value ne "NA"} {TE::UTILS::te_msg TE_INIT-43 STATUS "Found part name: $value";return $value}
      #search in shortname
      set value [get_partname $NAME ${TE::BDEF::SHORTNAME}]
      if {$value ne "NA"} {TE::UTILS::te_msg TE_INIT-44 STATUS "Found part name: $value";return $value}
      #search in part name (only if unique)
      if {[get_check_unique_name $NAME ${TE::BDEF::PARTNAME}]==0} {
        set value [get_partname $NAME ${TE::BDEF::PARTNAME}]
        if {$value ne "NA"} {TE::UTILS::te_msg TE_INIT-45 STATUS "Found part name: $value";return $value}
      }
      #default
      TE::UTILS::te_msg TE_INIT-46 STATUS "No part name found for ${NAME}, use NA "
      return "NA"
    }  
    #--------------------------------
    #--get_check_unique_name: POS: Table position ID....
    proc get_check_unique_name {NAME POS {silent false}} {
      variable BOARD_DEFINITION
      set part_count 0
      set max_count [expr [llength $BOARD_DEFINITION] -1]
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          set part_count [expr $part_count+1]
        }
      }
      #-2 not found
      #-1 some same
      #0 unique
      #1 all same
      if {$part_count==0} {
        TE::UTILS::te_msg TE_INIT-47 STATUS "Board part csv name check: $NAME not found on position $POS."
        return -2
      } elseif {$part_count==$max_count} {
        TE::UTILS::te_msg TE_INIT-48 STATUS "Board part csv name check:  All names ($NAME) are equal on position  $POS."
        return 1
      } elseif {$part_count==1} {
        if {!$silent} {
          TE::UTILS::te_msg TE_INIT-49 STATUS "Board part csv name check:  $NAME is unique on position $POS."
        }
        return 0
      } else {
        TE::UTILS::te_msg TE_INIT-50 STATUS "Board part csv name check:  Only some names ($NAME) are equal on position $POS."
        return -1
      }
    }      
    #--------------------------------
    #--get_id: Name--> search name, POS: Table position ID....
    proc get_id {NAME POS} {
      variable BOARD_DEFINITION
      set last_id 0
      foreach sublist $BOARD_DEFINITION {
        if {$last_id < [lindex $sublist ${TE::BDEF::ID}] && [lindex $sublist ${TE::BDEF::ID}] ne "ID"} {
          set last_id [lindex $sublist ${TE::BDEF::ID}]
        }
        # if { [string equal $NAME [lindex $sublist $POS]] } {
          # return [lindex $sublist 0]
        # }
        if { [string match -nocase $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::ID}]
        }
      }
      if {$NAME eq "LAST_ID"} {
        #return the the highest id from the list
        return $last_id
      }
      #default
      TE::UTILS::te_msg TE_INIT-51 STATUS "ID not found for $NAME $POS, return default: NA"
      return "NA"
    }     
    #--------------------------------
    #--get_prodid: POS: Table position  ID....
    proc get_prodid {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::PRODID}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-52 STATUS "Product ID not found for $NAME $POS, return default: NA"
      return "NA"
    }    
    #--------------------------------
    #--get_partname: POS: Table position  ID....
    proc get_partname {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::PARTNAME}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-53 STATUS "Part Name not found for $NAME $POS, return default: NA"
      return "NA"
    }   
    #--------------------------------
    #--get_boardname: POS: Table position  ID....
    proc get_boardname {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::BOARDNAME}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-54 STATUS "Board Name not found for $NAME $POS, return default: NA"
      return "NA"
    }  
    #--------------------------------
    #--get_shortname: POS: Table position  ID....  
    proc get_shortname {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::SHORTNAME}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-55 STATUS "Short Name not found for $NAME $POS, return default: NA"
      return "NA"
    } 
    #--------------------------------
    #--get_zynqflashtyp: POS:  ID....
    proc get_zynqflashtyp {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::ZYNQFLASHTYP}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-56 STATUS "Zynq Flash typ not found for $NAME $POS, return default: NA"
      return "NA"
    }
    #--------------------------------
    #--get_fpgaflashtyp: POS: Table position ID....
    proc get_fpgaflashtyp {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::FPGAFLASHTYP}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-57 STATUS "FPGA Flash typ not found for $NAME $POS, return default: NA"
      return "NA"
    }
    #--------------------------------
    #--get_pcb_rev: POS: Table position ID....
    proc get_pcb_rev {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::PCB_REV}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-173 STATUS "Module PCB Revision not found for $NAME $POS, return default: NA"
      return "NA"
    }
    #--------------------------------
    #--get_ddr_size: POS: Table position ID....
    proc get_ddr_size {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::DDR_SIZE}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-174 STATUS "Module DDR size not found for $NAME $POS, return default: NA"
      return "NA"
    }
    #--------------------------------
    #--get_flash_size: POS: Table position ID....
    proc get_flash_size {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::FLASH_SIZE}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-175 STATUS "Module flash size not found for $NAME $POS, return default: NA"
      return "NA"
    }
    #--------------------------------
    #--get_emmc_size: POS: ID....
    proc get_emmc_size {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::EMMC_SIZE}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-176 STATUS "Module eMMC size not found for $NAME $POS, return default: NA"
      return "NA"
    }
    #--------------------------------
    #--get_others: POS: Table position ID....
    proc get_others {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::OTHERS}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-177 STATUS "Module other changes not found for $NAME $POS, return default: NA"
      return "NA"
    }
    #--------------------------------
    #--get_notes: POS: Table position ID....
    proc get_notes {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::NOTES}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-178 STATUS "Module notes not found for $NAME $POS, return default: NA"
      return "NA"
    }
    #--------------------------------
    #--get_design: POS: Table position ID....
    proc get_design {NAME POS} {
      variable BOARD_DEFINITION
      foreach sublist $BOARD_DEFINITION {
        if { [string equal $NAME [lindex $sublist $POS]] } {
          return [lindex $sublist ${TE::BDEF::DESIGN}]
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-178 STATUS "Module design not found for $NAME $POS, return default: NA"
      return "NA"
    }
    #--------------------------------
    #--get_sw_extpll: POS: Table position ID....
    #-- this is option parameter will be used only if available
    proc get_config_sw_extpll {NAME POS} {
      variable BOARD_DEFINITION
      if {![string match "NA" $TE::BDEF::CONFIG_SW_EXTPLL]} {
        foreach sublist $BOARD_DEFINITION {
          if { [string equal $NAME [lindex $sublist $POS]] } {
            return [lindex $sublist ${TE::BDEF::CONFIG_SW_EXTPLL}]
          }
        }
      }
      #default
      TE::UTILS::te_msg TE_INIT-178 STATUS "Module CONFIG_SW_EXTPLL not found for $NAME $POS, return default: NA"
      return "NA"
    }
    # -----------------------------------------------------------------------------------------------------------------------------------------
    # finished initial functions
    # -----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  # -----------------------------------------------------------------------------------------------------------------------------------------
  }
  puts "INFO:(TE) Load Settings Script finished"
}