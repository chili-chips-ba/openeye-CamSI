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
@REM # --$Create Date:2016/02/16 $
@REM # --$Modify Date: 2021/11/17 $
@REM # --$Version: 3.1 $
@REM # --    update 2021.2
@REM # --$Version: 3.0 $
@REM # --    update 2020.2
@REM # --$Version: 2.9 $
@REM # --    add possibility to us Xilinx board store instead of local board files
@REM # --$Version: 2.8 $
@REM # --    update 2019.2
@REM # --$Version: 2.7 $
@REM # --    update 2018.2
@REM # --$Version: 2.6 $
@REM # --    remove parameter for internal usage
@REM # --    add note
@REM # --$Version: 2.5 $
@REM # --    Parameter for internal usage
@REM # --$Version: 2.4 $
@REM # --    update 2017.4
@REM # --    CVS Example
@REM # --    Optional Xilinx environment for debugging
@REM # --$Version: 2.3 $
@REM # --------------------------------------------------------------------
@REM # Additional description on: https://wiki.trenz-electronic.de/display/PD/Project+Delivery
@REM # --------------------------------------------------------------------
@REM # Important Settings:
@REM # -------------------------
@REM --------------------
@REM Set Vivado Installation path:
@REM    -The scripts search for Xilinx software on this paths:
@REM    -VIVADO (recommend used for project creation and programming): %XILDIR%\Vivado\%VIVADO_VERSION%\
@REM    -SDK (recommend, used for software projects and programming): %XILDIR%\SDK\%VIVADO_VERSION%\
@REM    -LabTools (optional used for programming only): %XILDIR%\Vivado_Lab\%VIVADO_VERSION%\
@REM    -SDSoC (optional used for SDSoC): %XILDIR%\SDSxC\%VIVADO_VERSION%\
@REM -Important Note: Check if Xilinx default install path use upper or lower case
@set XILDIR=C:/Xilinx
@REM -Attention: These scripts support only the predefined Vivado Version. 
@set VIVADO_VERSION=2021.2
@REM --------------------
@REM Set Board part number of the project which should be created
@REM    -Available Numbers: (you can use ID,PRODID from \board_files\TExxxx_board_file.csv list) or special name "LAST_ID" to get the board with the highest ID in the *.csv list
@REM    -variable is used for project creation and programming
@REM    -Example TE0726 Module : 
@REM      -USE ID           |USE PRODID                
@REM      -@set PARTNUMBER=3|@set PARTNUMBER=<complete TE article name from the CSV list>
@set PARTNUMBER=LAST_ID
@REM --------------------
@REM For program*file.cmd only:
@REM    -Select Software App, which should be configured.
@REM    -Use the folder name of the <projectname>/prebuilt/boot_image/<partname>/* subfolder. The *bin,*.mcs or *.bit from this folder will be used.
@REM    -If you will configure the raw *.bit or *.mcs from the <projectname>/prebuilt/hardware/<partname>/ folder, use @set SWAPP=NA or @set SWAPP="".
@REM    -Example: SWAPP=hello_world    --> used the file from prebuilt/boot_image/<partname>/hello_world
@REM              SWAPP=NA             --> used the file from <projectname>/prebuilt/boot_image/<partname>/
@set SWAPP=NA
@REM --------------------
@REM For program*file.cmd only:
@REM    -If you want to program from the root-folder <projectname>, set @set PROGRAMM_ROOT_FOLDER_FILE=1, otherwise set @set PROGRAMM_ROOT_FOLDER_FILE=0
@REM    -Attention: it should be only one *.bit, *.msc or *.bin file in the root folder. 
@set PROGRAM_ROOT_FOLDER_FILE=0
@REM --------------------
@REM # --------------------------------------------------------------------
@REM # Optional Settings:
@REM # -------------------------
@REM --------------------
@REM Xilinx Board Store
@REM    -board store is not always up to date at the moment, on problems yous local version
@REM    -set to 1 to use Xilinx board store instead of local board files ( will update catalog and install selected board part filest)
@REM    -set to 0 to use local board part files (default)
@set USE_XILINX_BOARD_STORE=0
@REM --------------------
@REM Do not close shell after processing
@REM  -Example: @set DO_NOT_CLOSE_SHELL=1, Shell will not be closed
@REM            @set DO_NOT_CLOSE_SHELL=0, Shell will be closed automatically
@set DO_NOT_CLOSE_SHELL=0
@REM --------------------
@REM # Used only for zip functions (supported programs 7z.exe(7 zip) and zip.exe (Info ZIP) )
@REM    -Example: @set ZIP_PATH=C:/Program Files/7-Zip/7z.exe
@set ZIP_PATH=C:/Program Files/7-Zip/7z.exe
@REM --------------------
@REM Enable SDSOC Setting (not set in every *.cmd file) (obsolete will be deleted in the future)
@REM    -Attention: Vivado and SDK settings will be overwrite. Used Tools installed with SDSxC 
@set ENABLE_SDSOC=0
@REM --------------------
@REM Xilinx GIT Hub Links (optional, currently only used to generate Device Tree with SDK instead of PetaLinux, see project delivery documentation):
@REM https://github.com/Xilinx/device-tree-xlnx
@REM https://github.com/Xilinx/u-boot-xlnx
@REM https://github.com/Xilinx/linux-xlnx
@REM Set Xilinx GIT Clone Path:
@REM    -optional, if device tree generation with SDK is needed
@set XILINXGIT_DEVICETREE=B:/xilinx_git/device-tree-xlnx
@REM --------------------
@REM optional Xilinx Environment variables
@REM -- Zynq QSPI Uboot debug:
@REM set XIL_CSE_ZYNQ_DISPLAY_UBOOT_MESSAGES=1
@REM -- Zynq QSPI Uboot speed to 10MHz:
@REM set XIL_CSE_ZYNQ_UBOOT_QSPI_FREQ_HZ = 10000000
@REM ------------------------------------------------------------------------------------------------------
@REM Do not change all lines below!!!!
@echo -----------------------------------------
@REM # check Xilinx path
@set XIL_VIV_EXIST=0
@if exist %XILDIR%\Vivado\%VIVADO_VERSION%\ (
  @set XIL_VIV_EXIST=1
)
@set XIL_VIT_EXIST=0
@if exist %XILDIR%\Vitis\%VIVADO_VERSION%\ (
  @set XIL_VIT_EXIST=1
)
@set XIL_VLAB_EXIST=0
@if exist %XILDIR%\Vivado_Lab\%VIVADO_VERSION%\ (
  @set XIL_VLAB_EXIST=1
)
@echo --------------------------------------------------------------------
@echo ------------------Set Xilinx environment variables------------------
@set VIVADO_XSETTINGS=%XILDIR%\Vivado\%VIVADO_VERSION%\settings64.bat
@set VITIS_XSETTINGS=%XILDIR%\Vitis\%VIVADO_VERSION%\settings64.bat
@set LABTOOL_XSETTINGS=%XILDIR%\Vivado_Lab\%VIVADO_VERSION%\settings64.bat
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
@REM # --------------------

@if not defined VIVADO_XSETTINGS_ISDONE ( 
  @if exist %VIVADO_XSETTINGS% (
    @echo --Info: Configure Xilinx Vivado Settings --
    @echo --Excecute: %VIVADO_XSETTINGS% --
    @call %VIVADO_XSETTINGS%
    @set VIVADO_AVAILABLE=1
  )
  @set VIVADO_XSETTINGS_ISDONE=1
)
@if not defined VITIS_XSETTINGS_ISDONE (
  @if exist %VITIS_XSETTINGS% (
    @echo --Info: Configure Xilinx VITIS Settings --
    @echo --Excecute: %VITIS_XSETTINGS% --
    @call %VITIS_XSETTINGS%
    @set SDK_AVAILABLE=1
  )
  @set VITIS_XSETTINGS_ISDONE=1
)
@if not defined LABTOOL_XSETTINGS_ISDONE (
  @if exist %LABTOOL_XSETTINGS% ( 
    @echo --Info: Configure Xilinx Vivado LabTools Settings --
    @echo --Excecute: %LABTOOL_XSETTINGS% --
    @call %LABTOOL_XSETTINGS%
    @set LABTOOL_AVAILABLE=1
  )
  @set LABTOOL_XSETTINGS_ISDONE=1
)
