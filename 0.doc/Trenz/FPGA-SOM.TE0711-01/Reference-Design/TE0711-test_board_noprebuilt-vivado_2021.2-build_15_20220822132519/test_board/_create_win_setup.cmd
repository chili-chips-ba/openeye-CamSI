@REM # --------------------------------------------------------------------
@REM # --   *****************************
@REM # --   *   Trenz Electronic GmbH   *
@REM # --   *   Beendorfer Str. 23      *
@REM # --   *   32609 Hüllhorst         *
@REM # --   *   Germany                 *
@REM # --   *****************************
@REM # --------------------------------------------------------------------
@REM # --$Autor: Hartfiel, John $
@REM # --$Email: j.hartfiel@trenz-electronic.de $
@REM # --$Create Date:2017/01/03 $
@REM # --$Modify Date: 2021/02/11 $
@REM # --$Version: 2.5 $
@REM #    -- add note
@REM # --$Version: 2.4 $
@REM #    -- update docu section
@REM #    -- select vivado version
@REM #    -- use board store
@REM # --$Version: 2.3 $
@REM #    -- version request
@REM #    -- program_flash rework
@REM # --$Version: 2.2 $
@REM #    -- add labtools support for prebuilts usage only
@REM # --$Version: 2.1 $
@REM #    -- bugfix for xilinx path selection
@REM # --$Version: 2.0 $
@REM #    -- 19.2 update+ change path detection
@REM # --$Version: 1.8 $
@REM #    -- check Xilinx version  bugfix
@REM #    -- add internal cmd
@REM # --$Version: 1.7 $
@REM #    -- check Xilinx version + basefolder
@REM # --$Version: 1.6 $
@REM # --------------------------------------------------------------------
@REM # --------------------------------------------------------------------
@REM set local environment
setlocal
@echo ------------------------Set design paths----------------------------
@REM get paths
@set batchfile_name=%~n0
@set batchfile_drive=%~d0
@set batchfile_path=%~dp0
@REM change drive
@%batchfile_drive%
@REM change path to batchfile folder
@cd %batchfile_path%
@echo -- Run Design with: %batchfile_name%
@echo -- Use Design Path: %batchfile_path%
@set cmd_folder=%batchfile_path%console\base_cmd\
@set CLOSE_SELBATCH=0
@set CHECK_DIR_DONE=0
@set CHANGEVIV=0
@set CHANGEBOARDSTORE=0
@REM ------------------------------------------------------------------------------
:NEXT_TE_BASE
@set new_base=0
@echo --------------------------------------------------------------------
@echo ------------------------_create_win_setup.cmd-----------------------
@echo -------------------------TE Reference Design------------------------
@echo --------------------------------------------------------------------
@echo -- (0)  Module selection guide, project creation...prebuilt export...   
@echo -- (1)  Create minimum setup of CMD-Files and exit Batch   
@echo -- (2)  Create maximum setup of CMD-Files and exit Batch    
@echo -- (3)  (internal only) Dev    
@echo -- (4)  (internal only) Prod    
@echo -- (c)  Go to CMD-File Generation (Manual setup)
@echo -- (d)  Go to Documentation (Web Documentation)
@echo -- (g)  Install Board Files from Xilinx Board Store (beta)
@echo -- (a)  Start  design with unsupported Vivado Version (beta)
@echo -- (x)  Exit Batch (nothing is done!)
@echo ----
@set /p new_base=" Select (ex.:'0' for module selection guide):"

@if "%new_base%"=="d" (@GOTO NEXT_TE_DOC)
@if "%new_base%"=="c" (@GOTO NEXT_TE_CMD)
@if "%new_base%"=="x" (@GOTO EOF)
@if "%new_base%"=="" (
@set new_cmd=config
@GOTO CONFIG_SETUP
)
@if "%new_base%"=="a" (
@set new_cmd=config
@set CHANGEVIV=1
@GOTO CONFIG_SETUP
)
@if "%new_base%"=="g" (
@set new_cmd=config
@set CHANGEBOARDSTORE=1
@GOTO CONFIG_SETUP
)
@if "%new_base%"=="0" (
@set new_cmd=config
@GOTO CONFIG_SETUP
)
@if "%new_base%"=="1" (
@set new_cmd=min
@GOTO MIN_SETUP
)
@if "%new_base%"=="2" (
@set new_cmd=max
@GOTO MAX_SETUP
)

@if "%new_base%"=="3" (
@set new_cmd=development
@GOTO DEVELOPMENT_SETUP
)

@if "%new_base%"=="4" (
@set new_cmd=production
@GOTO PRODUCTION_SETUP
)

@GOTO NEXT_TE_BASE
@echo --------------------------------------------------------------------
@REM ------------------------------------------------------------------------------
:NEXT_TE_DOC
@echo --------------------------------------------------------------------
@echo -------------------------TE Documentation---------------------------
@echo --------------------------------------------------------------------
@echo -- (b)  Go to Base Menue
@echo -- (x)  Exit Batch(nothing is done!)
@echo -- (0)  Trenz Electronic Wiki
@echo -- (1)  Trenz Electronic Wiki: Tutorial
@echo -- (2) Trenz Electronic Wiki: Vivado/SDK/SDSoC-Board Part Flow
@echo -- (3)  Trenz Electronic Wiki: Project Delivery Xilinx Designs
@echo -- (4)  Trenz Electronic Wiki: Article Number Information
@echo -- (5)  Trenz Electronic Wiki: Reference Design overview (all boards)
@echo -- (6)  Trenz Electronic Downloads
@echo ----
@set /p new_doc=" Select Document (ex.:'0' for Wiki ,'b' go to Base Menue):"
@if "%new_doc%"=="b" (@GOTO NEXT_TE_BASE)
@if "%new_doc%"=="x" (@GOTO EOF)
@if "%new_doc%"=="0" (@start https://wiki.trenz-electronic.de/display/PD/Trenz+Electronic+Documentation)
@if "%new_doc%"=="1" (@start https://wiki.trenz-electronic.de/display/PD/Tutorials)
@if "%new_doc%"=="2" (@start https://wiki.trenz-electronic.de/display/PD/Xilinx+Development+Toolss)
@if "%new_doc%"=="3" (@start https://wiki.trenz-electronic.de/display/PD/Project+Delivery+-+Xilinx+devices)
@if "%new_doc%"=="4" (@start https://wiki.trenz-electronic.de/display/PD/Article+Number+Information)
@if "%new_doc%"=="5" (@start https://wiki.trenz-electronic.de/display/PD/TE+Reference+Designs+Overview)
@if "%new_doc%"=="6" (@start https://shop.trenz-electronic.de/en/Download/?path=Trenz_Electronic)
@GOTO NEXT_TE_DOC
@echo --------------------------------------------------------------------
@REM ------------------------------------------------------------------------------
:NEXT_TE_CMD
@if not exist %cmd_folder% (@GOTO ERROR)   
@echo --------------------------------------------------------------------
@echo --------------------------Create CMD Files--------------------------
@echo --------------------------------------------------------------------
@echo -- Available CMD Files:
@echo -- (b)  Go to Base Menue
@echo -- (x)  Exit CMD Generation
@REM @echo -- ( )  design_basic_settings.cmd (generated always, if not exist)
@echo -- (min)Generate minimum CMD setup (recommended)
@echo -- (max)Generate maximum CMD setup
@echo -- (1)  design_clear_design_folders.cmd
@echo -- (2)  design_run_project_batchmode.cmd
@echo -- (3)  development_design_run_prebuilt_all_batchmode.cmd (not available)
@REM @echo -- (4)  development_design_run_prebuilt_all_sdsoc_batchmode.cmd (not available)
@echo -- (5)  development_xsct_console.cmd                      (not available)
@echo -- (6)  development_utilities_backup.cmd                  (not available)
@echo -- (7)  development_utilities_backup_noprebuilt.cmd       (not available)
@echo -- (8)  labtools_open_project_guimode.cmd
@echo -- (9)  program_flash.cmd
@REM @echo -- (10) program_flash_mcsfile.cmd
@echo -- (11) program_fpga_bitfile.cmd
@echo -- (12) sdk_create_prebuilt_project_guimode.cmd
@echo -- (13) vivado_create_project_batchmode.cmd
@echo -- (14) vivado_create_project_guimode.cmd
@echo -- (15) vivado_open_existing_project_guimode.cmd
@echo -- (16) prod_start_test.cmd                             (not available)
@echo ----
@set /p new_cmd=" Select CMD Files (ex.:'min' for minimum setup, 'x' for exit):"
@if "%new_cmd%"=="b" (@GOTO NEXT_TE_BASE)
@if "%new_cmd%"=="x" (@GOTO LAST_DESCR)

:MIN_SETUP
@if "%new_cmd%"=="min" ( 
  @if exist %cmd_folder%vivado_create_project_guimode.cmd ( @copy %cmd_folder%vivado_create_project_guimode.cmd %batchfile_path%vivado_create_project_guimode.cmd)
  @if exist %cmd_folder%vivado_open_existing_project_guimode.cmd ( @copy %cmd_folder%vivado_open_existing_project_guimode.cmd %batchfile_path%vivado_open_existing_project_guimode.cmd)
  @GOTO LAST_DESCR
)
:DEVELOPMENT_SETUP
@if "%new_cmd%"=="development" ( 
  @if exist %cmd_folder%vivado_create_project_guimode.cmd ( @copy %cmd_folder%vivado_create_project_guimode.cmd %batchfile_path%vivado_create_project_guimode.cmd)
  @if exist %cmd_folder%vivado_open_existing_project_guimode.cmd ( @copy %cmd_folder%vivado_open_existing_project_guimode.cmd %batchfile_path%vivado_open_existing_project_guimode.cmd)
  @if exist %cmd_folder%development_design_run_prebuilt_all_batchmode.cmd ( @copy %cmd_folder%development_design_run_prebuilt_all_batchmode.cmd %batchfile_path%development_design_run_prebuilt_all_batchmode.cmd)
@REM   @if exist %cmd_folder%development_design_run_prebuilt_all_sdsoc_batchmode.cmd ( @copy %cmd_folder%development_design_run_prebuilt_all_sdsoc_batchmode.cmd %batchfile_path%development_design_run_prebuilt_all_sdsoc_batchmode.cmd)
  @if exist %cmd_folder%development_utilities_backup.cmd ( @copy %cmd_folder%development_utilities_backup.cmd %batchfile_path%development_utilities_backup.cmd)
  @if exist %cmd_folder%development_utilities_backup_noprebuilt.cmd ( @copy %cmd_folder%development_utilities_backup_noprebuilt.cmd %batchfile_path%development_utilities_backup_noprebuilt.cmd)
  @if exist %cmd_folder%development_xsct_console.cmd ( @copy %cmd_folder%development_xsct_console.cmd %batchfile_path%development_xsct_console.cmd)
  @GOTO LAST_DESCR
)
:PRODUCTION_SETUP
@if "%new_cmd%"=="production" ( 
  @if exist %cmd_folder%design_clear_design_folders.cmd ( @copy %cmd_folder%design_clear_design_folders.cmd %batchfile_path%design_clear_design_folders.cmd)
  @if exist %cmd_folder%prod_start_test.cmd ( @copy %cmd_folder%prod_start_test.cmd %batchfile_path%prod_start_test.cmd)
  @GOTO LAST_DESCR
)

:MAX_SETUP
@if "%new_cmd%"=="max" ( 
  @if exist %cmd_folder%design_clear_design_folders.cmd ( @copy %cmd_folder%design_clear_design_folders.cmd %batchfile_path%design_clear_design_folders.cmd)
  @if exist %cmd_folder%design_run_project_batchmode.cmd ( @copy %cmd_folder%design_run_project_batchmode.cmd %batchfile_path%design_run_project_batchmode.cmd)
  @if exist %cmd_folder%development_design_run_prebuilt_all_batchmode.cmd ( @copy %cmd_folder%development_design_run_prebuilt_all_batchmode.cmd %batchfile_path%development_design_run_prebuilt_all_batchmode.cmd)
@REM   @if exist %cmd_folder%development_design_run_prebuilt_all_sdsoc_batchmode.cmd ( @copy %cmd_folder%development_design_run_prebuilt_all_sdsoc_batchmode.cmd %batchfile_path%development_design_run_prebuilt_all_sdsoc_batchmode.cmd)
  @if exist %cmd_folder%development_utilities_backup.cmd ( @copy %cmd_folder%development_utilities_backup.cmd %batchfile_path%development_utilities_backup.cmd)
  @if exist %cmd_folder%development_utilities_backup_noprebuilt.cmd ( @copy %cmd_folder%development_utilities_backup_noprebuilt.cmd %batchfile_path%development_utilities_backup_noprebuilt.cmd)
  @if exist %cmd_folder%development_xsct_console.cmd ( @copy %cmd_folder%development_xsct_console.cmd %batchfile_path%development_xsct_console.cmd)
  @if exist %cmd_folder%labtools_open_project_guimode.cmd ( @copy %cmd_folder%labtools_open_project_guimode.cmd %batchfile_path%labtools_open_project_guimode.cmd)
  @if exist %cmd_folder%program_flash.cmd ( @copy %cmd_folder%program_flash.cmd %batchfile_path%program_flash.cmd)
  @REM @if exist %cmd_folder%program_flash_mcsfile.cmd ( @copy %cmd_folder%program_flash_mcsfile.cmd %batchfile_path%program_flash_mcsfile.cmd)
  @if exist %cmd_folder%program_fpga_bitfile.cmd ( @copy %cmd_folder%program_fpga_bitfile.cmd %batchfile_path%program_fpga_bitfile.cmd)
  @if exist %cmd_folder%prod_start_test.cmd ( @copy %cmd_folder%prod_start_test.cmd %batchfile_path%prod_start_test.cmd)
  @if exist %cmd_folder%sdk_create_prebuilt_project_guimode.cmd ( @copy %cmd_folder%sdk_create_prebuilt_project_guimode.cmd %batchfile_path%sdk_create_prebuilt_project_guimode.cmd)
  @if exist %cmd_folder%vivado_create_project_batchmode.cmd ( @copy %cmd_folder%vivado_create_project_batchmode.cmd %batchfile_path%vivado_create_project_batchmode.cmd)
  @if exist %cmd_folder%vivado_create_project_guimode.cmd ( @copy %cmd_folder%vivado_create_project_guimode.cmd %batchfile_path%vivado_create_project_guimode.cmd)
  @if exist %cmd_folder%vivado_open_existing_project_guimode.cmd ( @copy %cmd_folder%vivado_open_existing_project_guimode.cmd %batchfile_path%vivado_open_existing_project_guimode.cmd)
  @GOTO LAST_DESCR
)
@if "%new_cmd%"=="1" ( 
  @if exist %cmd_folder%design_clear_design_folders.cmd ( @copy %cmd_folder%design_clear_design_folders.cmd %batchfile_path%design_clear_design_folders.cmd)
)
@if "%new_cmd%"=="2" ( 
  @if exist %cmd_folder%design_run_project_batchmode.cmd ( @copy %cmd_folder%design_run_project_batchmode.cmd %batchfile_path%design_run_project_batchmode.cmd)
)
@if "%new_cmd%"=="3" ( 
  @if exist %cmd_folder%development_design_run_prebuilt_all_batchmode.cmd ( @copy %cmd_folder%development_design_run_prebuilt_all_batchmode.cmd %batchfile_path%development_design_run_prebuilt_all_batchmode.cmd)
)
@REM @if "%new_cmd%"=="4" ( 
@REM   @if exist %cmd_folder%development_design_run_prebuilt_all_sdsoc_batchmode.cmd ( @copy %cmd_folder%development_design_run_prebuilt_all_sdsoc_batchmode.cmd %batchfile_path%development_design_run_prebuilt_all_sdsoc_batchmode.cmd)
@REM )
@if "%new_cmd%"=="5" ( 
  @if exist %cmd_folder%development_xsct_console.cmd ( @copy %cmd_folder%development_xsct_console.cmd %batchfile_path%development_xsct_console.cmd)
)
@if "%new_cmd%"=="6" ( 
  @if exist %cmd_folder%development_utilities_backup.cmd ( @copy %cmd_folder%development_utilities_backup.cmd %batchfile_path%development_utilities_backup.cmd)
)
@if "%new_cmd%"=="7" ( 
  @if exist %cmd_folder%development_utilities_backup_noprebuilt.cmd ( @copy %cmd_folder%development_utilities_backup_noprebuilt.cmd %batchfile_path%development_utilities_backup_noprebuilt.cmd)
)
@if "%new_cmd%"=="8" ( 
  @if exist %cmd_folder%labtools_open_project_guimode.cmd ( @copy %cmd_folder%labtools_open_project_guimode.cmd %batchfile_path%labtools_open_project_guimode.cmd)
)
@if "%new_cmd%"=="9" ( 
  @if exist %cmd_folder%program_flash.cmd ( @copy %cmd_folder%program_flash.cmd %batchfile_path%program_flash.cmd)
)
@REM @if "%new_cmd%"=="10" ( 
  @REM @if exist %cmd_folder%program_flash_mcsfile.cmd ( @copy %cmd_folder%program_flash_mcsfile.cmd %batchfile_path%program_flash_mcsfile.cmd)
@REM )
@if "%new_cmd%"=="11" ( 
  @if exist %cmd_folder%program_fpga_bitfile.cmd ( @copy %cmd_folder%program_fpga_bitfile.cmd %batchfile_path%program_fpga_bitfile.cmd)
)
@if "%new_cmd%"=="12" ( 
  @if exist %cmd_folder%sdk_create_prebuilt_project_guimode.cmd ( @copy %cmd_folder%sdk_create_prebuilt_project_guimode.cmd %batchfile_path%sdk_create_prebuilt_project_guimode.cmd)
)
@if "%new_cmd%"=="13" ( 
  @if exist %cmd_folder%vivado_create_project_batchmode.cmd ( @copy %cmd_folder%vivado_create_project_batchmode.cmd %batchfile_path%vivado_create_project_batchmode.cmd)
)
@if "%new_cmd%"=="14" ( 
  @if exist %cmd_folder%vivado_create_project_guimode.cmd ( @copy %cmd_folder%vivado_create_project_guimode.cmd %batchfile_path%vivado_create_project_guimode.cmd)
)
@if "%new_cmd%"=="15" ( 
  @if exist %cmd_folder%vivado_open_existing_project_guimode.cmd ( @copy %cmd_folder%vivado_open_existing_project_guimode.cmd %batchfile_path%vivado_open_existing_project_guimode.cmd)
)
@if "%new_cmd%"=="16" ( 
  @if exist %cmd_folder%prod_start_test.cmd ( @copy %cmd_folder%prod_start_test.cmd %batchfile_path%prod_start_test.cmd)
)

@GOTO NEXT_TE_CMD

:CONFIG_SETUP


@if not exist %batchfile_path%design_basic_settings.cmd ( @copy %cmd_folder%design_basic_settings.cmd %batchfile_path%design_basic_settings.cmd)
@if not exist %batchfile_path%_use_virtual_drive.cmd    ( @copy %cmd_folder%_use_virtual_drive.cmd %batchfile_path%_use_virtual_drive.cmd)
@REM # --------------------
@REM # load environment and check vivado version
@call  %cmd_folder%design_basic_settings.cmd
@REM # --------------------
@set DEF_VIVADO_VERSION=%VIVADO_VERSION%
@set VIVADO_XSETTINGS_ISDONE=
@set VITIS_XSETTINGS_ISDONE=
@set LABTOOL_XSETTINGS_ISDONE=
@set LABTOOL_AVAILABLE=
@set VIVADO_XSETTINGS=
@set VITIS_XSETTINGS=
@set LABTOOL_XSETTINGS=
@set XIL_VIV_EXIST=
@set XIL_VIT_EXIST=
@set XIL_VLAB_EXIST=


@call design_basic_settings.cmd
@if  "%DEF_VIVADO_VERSION%" NEQ "%VIVADO_VERSION%" (
@echo -----------------------------------------
@echo Attantion:
@echo  - Design was created for Vivado %DEF_VIVADO_VERSION%, selected is Vivado %VIVADO_VERSION%
@echo  - Design only tested with Vivado %DEF_VIVADO_VERSION%, modifications on design can be needed for other versions!
@echo .
@echo ... Continue with %VIVADO_VERSION% ...
)

@set CLOSE_SELBATCH=1
if  %CHANGEBOARDSTORE%==1 (
@set USE_XILINX_BOARD_STORE=1
)

if  %CHANGEVIV%==1 (
@GOTO CHANGE_VERSION
)

@REM @if not defined XILDIR (
@REM   @set XILDIR=c:/xilinx
@REM )
@echo -----------------------------------------
@REM TODO check new SDSOC functionality with VITIS
@REM @echo Which tools should be started:
@REM @echo Vivado %VIVADO_VERSION% or SDSoC %VIVADO_VERSION% ?
@REM @set /p new_cmd=" Press '0' for Vivado or '1' for SDSoC: "
@REM @if "%new_cmd%"=="1" (@set ENABLE_SDSOC=1)
@REM @if "%new_cmd%"=="0" (@set ENABLE_SDSOC=0) 
@REM @if not defined ENABLE_SDSOC (
@REM   @set ENABLE_SDSOC=0
@REM )
@REM @if %ENABLE_SDSOC%==0 (@echo "Vivado installation is used")
@REM @if %ENABLE_SDSOC%==1 (@echo "SDSoC installation is used")

@echo -----------------------------------------
@REM # check Xilinx path
:XILINX_PATH


@if %XIL_VIV_EXIST%==1 (
  @echo Use Xilinx installation from '%XILDIR%\Vivado\%VIVADO_VERSION%\'
  @GOTO START_CONFIG
)
@if %XIL_VLAB_EXIST%==1 (
@GOTO ASK_LAB
)
:CHECKVIVADOFAILED

echo '%XILDIR%/Vivado/%VIVADO_VERSION%/' did not exists.
@if %CHECK_DIR_DONE%==1 (
 @GOTO CHANGE_VERSION
)
@GOTO SPECIFY_XILINX_DIR

:ASK_LAB
@echo Should Vivado Lab Tools be started for prebuilt selection
@set /p new_lab=" (Vivado design generation is not possible in this case) (Y/n)?:"

@if "%new_lab%"=="n" (
  @echo Use Xilinx installation from '%XILDIR%\Vivado_Lab\%VIVADO_VERSION%\'
  @GOTO CHECKVIVADOFAILED
)

@if "%new_lab%"=="N"  (
  @echo Use Xilinx installation from '%XILDIR%\Vivado_Lab\%VIVADO_VERSION%\'
  @GOTO CHECKVIVADOFAILED
)
@GOTO START_LAB

:START_CONFIG
@if  "%DEF_VIVADO_VERSION%" NEQ "%VIVADO_VERSION%" (
@echo -----------------------------------------
@echo Attantion:
@echo  - Design was created for Vivado %DEF_VIVADO_VERSION%, selected is Vivado %VIVADO_VERSION%
@echo  - Design only tested with Vivado %DEF_VIVADO_VERSION%, modifications on design can be needed for other versions!
@echo .
@set /p new_cmd="... Continue with %VIVADO_VERSION% ... press enter..."

)
@if exist %cmd_folder%vivado_create_project_guimode.cmd ( @copy %cmd_folder%vivado_create_project_guimode.cmd %batchfile_path%vivado_create_project_guimode.cmd)
@if exist %cmd_folder%vivado_open_existing_project_guimode.cmd ( @copy %cmd_folder%vivado_open_existing_project_guimode.cmd %batchfile_path%vivado_open_existing_project_guimode.cmd)


@REM # --------------------
@if not defined VIVADO_AVAILABLE (
  @set VIVADO_AVAILABLE=0
)
@if not defined SDK_AVAILABLE (
  @set SDK_AVAILABLE=0
)
@if not defined LABTOOL_AVAILABLE (
  @set LABTOOL_AVAILABLE=0
)
@if not defined SDSOC_AVAILABLE (
  @set SDSOC_AVAILABLE=0
)

@REM # --------------------

@REM # -----------------
@REM # --- delete request if old project exits
@echo ----------------------check old project exists--------------------------
@set vivado_p_folder=%batchfile_path%vivado

@if exist %vivado_p_folder% ( @echo Old vivado project was found: Create project will delete older project!
  @goto  before_uinput
)  
@goto  after_uinput
:before_uinput
@set /p creatProject="Are you sure to continue? (y/N):"
@echo User Input: "%creatProject%"
@if not "%creatProject%"=="y" (GOTO EOF)
:after_uinput
@echo Start create project..."
@echo ----------------------Change to log folder--------------------------
@REM vlog folder
@set vlog_folder=%batchfile_path%v_log
@echo %vlog_folder%
@if not exist %vlog_folder% ( @mkdir %vlog_folder% )   
@cd %vlog_folder%
@echo --------------------------------------------------------------------
@echo -------------------------Start VIVADO scripts -----------------------
start /max  vivado -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --run_board_selection
@echo -------------------------scripts finished----------------------------
@echo --------------------------------------------------------------------
@echo --------------------Change to design folder-------------------------
@cd..
@echo ------------------------Design finished-----------------------------


@GOTO LAST_DESCR
:START_LAB
@if  "%DEF_VIVADO_VERSION%" NEQ "%VIVADO_VERSION%" (
@echo -----------------------------------------
@echo Attantion:
@echo  - Design was created for Vivado %DEF_VIVADO_VERSION%, selected is Vivado %VIVADO_VERSION%
@echo  - Design only tested with Vivado %DEF_VIVADO_VERSION%, modifications on design can be needed for other versions!
@echo .
@set /p new_cmd="... Continue with %VIVADO_VERSION% ... press enter..."

)
@echo ----------------------Change to log folder--------------------------
@REM vlog folder
@set vlog_folder=%batchfile_path%v_log
@echo %vlog_folder%
@if not exist %vlog_folder% ( @mkdir %vlog_folder% )   
@cd %vlog_folder%
@echo --------------------------------------------------------------------
@echo -------------------------Start Vivado Lab scripts -----------------------
start /max  vivado_lab -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --run_board_selection
@echo -------------------------scripts finished----------------------------
@echo --------------------------------------------------------------------
@echo --------------------Change to design folder-------------------------
@cd..
@echo ------------------------Design finished-----------------------------
@GOTO EOF

:SPECIFY_XILINX_DIR
@set new_cmd=c:/xilinx
@echo Important: Specify only base folder, ex. 'c:/xilinx'. Subfolder '/Vivado/%VIVADO_VERSION%/' will be add automatically
@set /p new_cmd=" Please specifiy you Xilinx base installation folder : "
@set XILDIR=%new_cmd%
@set CHECK_DIR_DONE=1
@set XIL_VIV_EXIST=0
:CHECK_XILINX_DIR
@set VIVADO_XSETTINGS=%XILDIR%\Vivado\%VIVADO_VERSION%\settings64.bat
@set VITIS_XSETTINGS=%XILDIR%\Vitis\%VIVADO_VERSION%\settings64.bat
@set LABTOOL_XSETTINGS=%XILDIR%\Vivado_Lab\%VIVADO_VERSION%\settings64.bat
@if exist %XILDIR%\Vivado\%VIVADO_VERSION%\ (
  @set XIL_VIV_EXIST=1
  @if not exist %VIVADO_XSETTINGS% (  @echo -- Error: %VIVADO_XSETTINGS% not found. Check if this file is available on your installation
     @GOTO ERROR
  ) else (
    @echo --Info: Configure Xilinx Vivado Settings --
    @echo --Excecute: %VIVADO_XSETTINGS% --
    @call %VIVADO_XSETTINGS%
    @set VIVADO_AVAILABLE=1
  )
  @set VIVADO_XSETTINGS_ISDONE=1
  
  @set XIL_VIT_EXIST=0
  @if exist %XILDIR%\Vitis\%VIVADO_VERSION%\ (
    @set XIL_VIT_EXIST=1
    @if not exist %VITIS_XSETTINGS% ( @echo -- Warning: %VITIS_XSETTINGS% not found. Vitis not available, start project with limited functionality --
    ) else (
      @echo --Info: Configure Xilinx VITIS Settings --
      @echo --Excecute: %VITIS_XSETTINGS% --
      @call %VITIS_XSETTINGS%
      @set VITIS_AVAILABLE=1
    )
    @set VITIS_XSETTINGS_ISDONE=1
  )
  
)
@set XIL_VLAB_EXIST=0
@if exist %XILDIR%\Vivado_Lab\%VIVADO_VERSION%\ (
  @set XIL_VLAB_EXIST=1
  @if not exist %LABTOOL_XSETTINGS% ( @echo -- Warning: %LABTOOL_XSETTINGS% not found. LabTools not available --
  ) else (
    @echo --Info: Configure Xilinx VITIS Settings --
    @echo --Excecute: %LABTOOL_XSETTINGS% --
    @call %LABTOOL_XSETTINGS%
    @set LABTOOL_AVAILABLE=1
  )
  @set LABTOOL_XSETTINGS_ISDONE=1
)

@GOTO XILINX_PATH

:CHANGE_VERSION
@set new_cmd=%DEF_VIVADO_VERSION%
@echo Functionality cannot be guaranteed with modified version, recommende version is %DEF_VIVADO_VERSION%! 
@set /p new_cmd="Enter new Vivado Version (ex. %DEF_VIVADO_VERSION%) or press Y in case  %VIVADO_VERSION% is correct)?"
@set tmp=%new_cmd%
@set CHECK_DIR_DONE=0
@if "%tmp%"=="" (

  @GOTO CHECK_XILINX_DIR
)
@if "%tmp%"=="y" (
  @GOTO CHECK_XILINX_DIR
)
@if "%tmp%"=="Y" (
  @GOTO CHECK_XILINX_DIR
)
@set VIVADO_VERSION=%tmp%
@echo New Vivado Version:%VIVADO_VERSION%
@GOTO CHECK_XILINX_DIR

@REM ------------------------------------------------------------------------------
:LAST_DESCR
@if not exist %batchfile_path%design_basic_settings.cmd ( @copy %cmd_folder%design_basic_settings.cmd %batchfile_path%design_basic_settings.cmd)
@if not exist %batchfile_path%_use_virtual_drive.cmd    ( @copy %cmd_folder%_use_virtual_drive.cmd %batchfile_path%_use_virtual_drive.cmd)
@echo ---------------------------Minimal Setup----------------------------
@echo --- 0. (optional) use "_use_viartual_drive.cm" , see Xilinx "AR# 52787"
@echo ---    Note:Use to reduce path length
@echo --- 1. Open "design_basic_settings.cmd" with text editor
@echo ---    Note: "Module selection guide" modifies this file automatically
@echo --- 1.1  Set Xilinx Installation path, default:  @set XILDIR=C:/Xilinx
@echo --- 1.2  Set the Board Part you bought, example: @set PARTNUMBER=2
@echo ---       For available names see: ./board_files/TExxxx_board_files.csv
@echo --- 1.3 Save "design_basic_settings.cmd"
@echo --- Create and open Vivado Project with batch files:
@echo --- 2. To create vivado project, execute: ./vivado_create_project_guimode.cmd
@echo --- Open existing Vivado Project with batch files:
@echo --- 3. To open existing vivado project, execute: ./vivado_open_existing_project_guimode.cmd
@echo --- Use Trenz Electronic Wiki for more information:
@echo ---   https://wiki.trenz-electronic.de/display/PD/Project+Delivery+-+Xilinx+devices
@echo ---   https://wiki.trenz-electronic.de/pages/viewpage.action?pageId=14746264
@echo --------------------------------------------------------------------
@GOTO EOF
@REM ------------------------------------------------------------------------------
:ERROR
@echo ---------------------------Error occurs-----------------------------
@echo --------------------------------------------------------------------
@PAUSE
@REM ------------------------------------------------------------------------------

:EOF
@echo ------------------------------Finished------------------------------
@echo --------------------------------------------------------------------
@if %CLOSE_SELBATCH%==1 (
  @GOTO END
)
@PAUSE
:END