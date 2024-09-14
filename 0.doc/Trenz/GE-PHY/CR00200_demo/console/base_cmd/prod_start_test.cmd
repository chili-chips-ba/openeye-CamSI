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
@REM # --$Modify Date: 2022/03/21 $
@REM # --$Version: 3.5 $
@REM # -- small style update
@REM # --$Version: 3.4 $
@REM # -- Exit in case temfolder can't be deleted after 5 tries
@REM # --$Version: 3.3 $
@REM # -- make copy on c temp folder and start from c drive
@REM # -- use other tcl function to be compatible with MT and HT test
@REM # --$Version: 3.2 $
@REM # -- use powershell console to change color
@REM # --$Version: 3.1 $
@REM # -- bugfix labtools
@REM # --$Version: 3.0 $
@REM # -- 19.2 update+ change path detection
@REM # --$Version: 1.0 $
@REM # --------------------------------------------------------------------
@REM # --------------------------------------------------------------------
@REM set local environment
setlocal
@echo ------------------------Set design paths----------------------------
@REM get paths
@set batchfile_name=%~n0
@set batchfile_drive=%~d0
@set batchfile_path=%~dp0
@set project_folder_name=%batchfile_path:~0,-1%
@for %%f in (%project_folder_name%) do @set project_folder_name=%%~nxf
REM @echo %project_folder_name%

@REM change drive
@%batchfile_drive%
@REM change path to batchfile folder
@cd %batchfile_path%
@echo -- Run Design with: %batchfile_name%
@echo -- Use Design Path: %batchfile_path%
@set cmd_folder=%batchfile_path%console\base_cmd\
@set CLOSE_SELBATCH=0
@set CHECK_DIR_DONE=0



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
@set VIVADO_VERSION=


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
@echo -----------------------------------------
@REM # check Xilinx path
@set ckeckvivfolder=0
:XILINX_PATH

@if %XIL_VIV_EXIST%==1 (
  @echo Use Xilinx installation from '%XILDIR%/Vivado/%VIVADO_VERSION%/'
  @GOTO START_CONFIG
)
@if %XIL_VLAB_EXIST%==1 (
  @echo Use Xilinx installation from '%XILDIR%/Vivado_Lab/%VIVADO_VERSION%/'
  @GOTO START_CONFIG
)

 echo '%XILDIR%/Vivado/%VIVADO_VERSION%/' did not exists.
 echo '%XILDIR%/Vivado_Lab/%VIVADO_VERSION%/' did not exists.

@if %CHECK_DIR_DONE%==1 (
 @GOTO CHANGE_VERSION
)
@GOTO SPECIFY_XILINX_DIR

:START_CONFIG
@if  "%DEF_VIVADO_VERSION%" NEQ "%VIVADO_VERSION%" (
@echo -----------------------------------------
@echo Achtung:
@echo  - Design wurde mit %DEF_VIVADO_VERSION% erstellt, ausgewählt wurde Vivado %VIVADO_VERSION%
@echo  - Design wurde nur mit Vivado %DEF_VIVADO_VERSION% getestet, eventuell sind Anpassungen bei anderen Versionen nötig!
@echo .
@set /p new_cmd="... Continue with %VIVADO_VERSION% ... press enter..."

)

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

@REM # -----------------
@REM # --- delete request if old project exits
@echo ----------------------check old project exists--------------------------
@set vivado_p_folder=%batchfile_path%vivado
@echo --------------------------------------------------------------------

@set cdrive_testfolder=C:\temp\testdesign
@set prod_cfg=%batchfile_path%..\prod_cfg_list.csv
@set prod_init=%batchfile_path%..\cfg_init
@set prod_prj=%batchfile_path%
@set prod_prj_new=%cdrive_testfolder%\%project_folder_name%\

@set tempfolder=0
@if %prod_prj% == %prod_prj_new% (
  @set tempfolder=1
  @goto DONOTCOPY
)

@set trydelete=0
:DELETETESTFOLDER
@if %trydelete% == 5 ( 
  @echo -----------------------------------------------------------------------------------------------------
  @echo -----------------------------------------------------------------------------------------------------
  @echo Der Ordner %cdrive_testfolder% konnte nicht geloescht werden!
  @echo Pruefen Sie das kein Programm offen ist welches auf diesen Ordner oder Dateien daraus zugreift. 
  @echo Sollte sich das Problem nicht loesen lassen, starten Sie den PC einmal neu und/oder melden Sie sich bitte bei den Entwicklern. 
  @echo -----------------------------------------------------------------------------------------------------
  @echo -----------------------------------------------------------------------------------------------------
  @goto ERROR
)
@if exist %cdrive_testfolder% (
  @echo ----Try to delete old version on C temp folder  -- %trydelete% -----
  @rmdir /S /Q  %cdrive_testfolder%
  @set /a trydelete +=1
  @goto DELETETESTFOLDER
)
@if not exist %cdrive_testfolder% ( @mkdir %cdrive_testfolder%  ) 
 


@if exist %prod_cfg% (
  @echo -------------------- Make design copy on C drive  ------------------
  @copy %prod_cfg% %cdrive_testfolder% 
  @xcopy %prod_init% %cdrive_testfolder%\cfg_init\ /s /e /q
  @xcopy %prod_prj% %prod_prj_new% /s /e /q
  REM copy %batchfile_path% %cdrive_testfolder%
  
  @REM # -----------------
  @echo -------------------------- Move to C drive  ------------------------
  C:
  cd %cdrive_testfolder%
  @set prod_prj=%prod_prj_new%
)
:DONOTCOPY

@if %tempfolder% == 0 (
  @goto START_VIVADO
)

@set start_viv=0
@echo Falls die temporaere Projekterzeugung laenger her ist wird empfohlen, das Projekt erneut von Z Laufwerk zu starten!
@set /p start_viv="Mit 1 und Enter fortfahren oder mit Enter beenden:"
@if not %start_viv% == 1 (
  @goto ERROR
)


:START_VIVADO
@echo ----------------------Change to log folder--------------------------
@REM vlog folder
@set vlog_folder=%prod_prj%v_log
@echo %vlog_folder%
@if not exist %vlog_folder% ( @mkdir %vlog_folder% )   
@cd %vlog_folder%
@echo --------------------------------------------------------------------
@echo -------------------------Start VIVADO scripts -----------------------
@if %LABTOOL_AVAILABLE%==1 (

  @echo -------------------------start lab tools -----------------------
  start /max powershell vivado_lab -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --run_te_procedure "TE::INIT::start_production_test" --boardpart %PARTNUMBER%
) else (
  start /max powershell vivado -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --run_te_procedure "TE::INIT::start_production_test" --boardpart %PARTNUMBER%
)
@REM start /max  vivado -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --run_board_selection
%batchfile_drive%
@cd %batchfile_path%

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
@set VIVADO_XSETTINGS=%XILDIR%/Vivado/%VIVADO_VERSION%/settings64.bat
@set VITIS_XSETTINGS=%XILDIR%/Vitis/%VIVADO_VERSION%/settings64.bat
@set LABTOOL_XSETTINGS=%XILDIR%/Vivado_Lab/%VIVADO_VERSION%/settings64.bat
@if exist %XILDIR%/Vivado/%VIVADO_VERSION%/ (
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
  @if exist %XILDIR%/Vitis/%VIVADO_VERSION%/ (
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
@if exist %XILDIR%/Vivado_Lab/%VIVADO_VERSION%/ (
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
@echo Only in exceptional cases change the version, recommende version is %DEF_VIVADO_VERSION%! 
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