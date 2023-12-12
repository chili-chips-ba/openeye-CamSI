@REM # --------------------------------------------------------------------
@REM # --   *****************************
@REM # --   *   Trenz Electronic GmbH   *
@REM # --   *   Holzweg 19A             *
@REM # --   *   32257 Bünde             *
@REM # --   *   Germany                 *
@REM # --   *****************************
@REM # --------------------------------------------------------------------
@REM # --$Autor: Hartfiel, John $
@REM # --$Email: j.hartfiel@trenz-electronic.de $
@REM # --$Create Date:2016/02/16 $
@REM # --$Modify Date: 2016/09/27 $
@REM # --$Version: 2.3 $
@REM # --------------------------------------------------------------------
@REM # Additional description on: https://wiki.trenz-electronic.de/display/PD/Project+Delivery
@REM # --------------------------------------------------------------------
@REM # Important Settings:
@REM # -------------------------
@REM --------------------
@REM Set Vivado Installation path:
@REM    -Attention: This scripts support only the predefined Vivado Version. Others Versions are not tested.
@REM    -Xilinx Software will be searched in:
@REM    -VIVADO (optional for project creation and programming): %XILDIR%\Vivado\%VIVADO_VERSION%\
@REM    -SDK (optional for software projects and programming): %XILDIR%\SDK\%VIVADO_VERSION%\
@REM    -LabTools (optional for programming only): %XILDIR%\Vivado_Lab\%VIVADO_VERSION%\
@set XILDIR=C:/Xilinx
@set VIVADO_VERSION=2016.2
@REM --------------------
@REM Set Board part number of the project which should be created
@REM    -Available Numbers: (you can use ID,PRODID,BOARDNAME or SHORTNAME from TExxxx_board_file.csv list) or special name "LAST_ID" to get the board with the highest ID in the *.csv list
@REM    -Used for project creation and programming
@REM    -Example TE0726 Module : 
@REM      -USE ID           |USE PRODID                 |Use Boardname                                  |Use Shortname
@REM      -@set PARTNUMBER=1|@set PARTNUMBER=te0726-3m  |@set PARTNUMBER=trenz.biz:te0726_m:part0:3.1  |@set PARTNUMBER=te0726_m
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
@REM Do not close shell after processing
@REM  -Example: @set DO_NOT_CLOSE_SHELL=1, Shell will not be closed
@REM            @set DO_NOT_CLOSE_SHELL=0, Shell will be closed automatically
@set DO_NOT_CLOSE_SHELL=0
@REM --------------------
@REM # Used only for zip functions (supported programs 7z.exe(7 zip) and zip.exe (Info ZIP) )
@REM    -Example: @set ZIP_PATH=C:/Program Files/7-Zip/7z.exe
@set ZIP_PATH=B:/SVN/cores/zip/zip.exe
@REM --------------------
@REM Enable SDSOC Setting (not set in every *.cmd file)
@set ENABLE_SDSOC=0
@REM --------------------
@REM Xilinx GIT Hub Links:
@REM https://github.com/Xilinx/device-tree-xlnx
@REM https://github.com/Xilinx/u-boot-xlnx
@REM https://github.com/Xilinx/linux-xlnx
@REM Set Xilinx GIT Clone Path:
@set XILINXGIT_DEVICETREE=B:/xilinx_git/device-tree-xlnx
@REM --------------------