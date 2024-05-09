#! /bin/sh

# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Beendorfer Str. 23      *
# --   *   32609 Hüllhorst   		   *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# --$Autor: Hartfiel, John $
# --$Email: j.hartfiel@trenz-electronic.de $
# --$Create Date:2017/01/24 $
# --$Modify Date: 2021/12/14 $
# --$Version: 2.0$
# --     add USE_XILINX_PETALINUX parameter
# --$Version: 1.9$
# --     update 2021.2
# --$Version: 1.8 $
# --     changed default linux directory(see Xilinx 20.2 installer)
# --$Version: 1.7 $
# --     update 2020.2
# --$Version: 1.6 $
# --    add possibility to us Xilinx board store instead of local board files
# --$Version: 1.5 $
# --    update 2019.2
# --$Version: 1.4 $
# --    update 2018.3
# --$Version: 1.3 $ 
# --    update 2018.2
# --$Version: 1.2 $
# --    update 2017.4
# --    CVS Example
# --    Optional Xilinx environment for debugging
# --    lower cases for Xilinx default path
# --$Version: 1.1 $ 
# --   export variables to be visible by Xilinx tools
# --------------------------------------------------------------------
# Additional description on: https://wiki.trenz-electronic.de/display/PD/Project+Delivery
# --------------------------------------------------------------------
# Important Settings:
# -------------------------
# --------------------
# Set Vivado Installation path:
#    -Attention: This scripts support only the predefined Vivado Version. Others Versions are not tested.
#    -Xilinx Software will be searched in:
#    -VIVADO (optional for project creation and programming): $XILDIR/Vivado/$VIVADO_VERSION/
#    -SDK (optional for software projects and programming): $XILDIR/SDK/$VIVADO_VERSION/
#    -LabTools (optional for programming only): $XILDIR/Vivado_Lab/$VIVADO_VERSION/
#    -SDSoC (optional used for SDSoC): $XILDIR/SDx/$VIVADO_VERSION/
#
# -Important Note: Check if Xilinx default install path use upper or lower case
export XILDIR=/tools/Xilinx
# -Attention: These scripts support only the predefined Vivado Version. 
export VIVADO_VERSION=2021.2
# --------------------
# Set Board part number of the project which should be created
#    -Available Numbers: (you can use ID,PRODID from TExxxx_board_file.csv list) or special name "LAST_ID" to get the board with the highest ID in the *.csv list
#    -Used for project creation and programming
#    -Example TE0726 Module : 
#      -USE ID           |USE PRODID                 
#      -@set PARTNUMBER=1|@set PARTNUMBER=<complete TE article name from the CSV list> 
export PARTNUMBER=LAST_ID
# --------------------
# For program*file.cmd only:
#    -Select Software App, which should be configured.
#    -Use the folder name of the <projectname>/prebuilt/boot_image/<partname>/* subfolder. The *bin,*.mcs or *.bit from this folder will be used.
#    -If you will configure the raw *.bit or *.mcs from the <projectname>/prebuilt/hardware/<partname>/ folder, use @set SWAPP=NA or @set SWAPP="".
#    -Example: SWAPP=hello_world    --> used the file from prebuilt/boot_image/<partname>/hello_world
#              SWAPP=NA             --> used the file from <projectname>/prebuilt/boot_image/<partname>/
export SWAPP=NA
# --------------------
# For program*file.cmd only:
#    -If you want to program from the root-folder <projectname>, set @set PROGRAMM_ROOT_FOLDER_FILE=1, otherwise set @set PROGRAMM_ROOT_FOLDER_FILE=0
#    -Attention: it should be only one *.bit, *.msc or *.bin file in the root folder. 
export PROGRAM_ROOT_FOLDER_FILE=0
# --------------------
# # --------------------------------------------------------------------
# # Optional Settings:
# # -------------------------
# --------------------
# Xilinx Board Store
#    -board store is not always up to date at the moment, on problems yous local version
#    -set to 1 to use Xilinx board store instead of local board files ( will update catalog and install selected board part files)
#    -set to 0 to use local board part files (default)
export USE_XILINX_BOARD_STORE=0
# --------------------
# Xilinx Petalinux
#    -Enable petalinux controll over vivado GUI (beta version)
export USE_XILINX_PETALINUX=0
#    -petalinux alternative path in case it's not installed with xilinx unified installer
export ALTERNATIVE_PETALINUX_XSETTINGS=~/petalinux/2021.2/settings.sh
# --------------------
# Do not close shell after processing
#  -Example: @set DO_NOT_CLOSE_SHELL=1, Shell will not be closed
#            @set DO_NOT_CLOSE_SHELL=0, Shell will be closed automatically
export DO_NOT_CLOSE_SHELL=0
# --------------------
# # Used only for zip functions (supported programs 7z.exe(7 zip) and zip.exe (Info ZIP) )
#    -Example: @set ZIP_PATH=/usr/bin/zip
#    -install zip with sudo apt-get install zip
export ZIP_PATH=`which zip`
# --------------------
# Enable SDSOC Setting (not set in every *.cmd file)  (obsolete will be deleted in the future)
export ENABLE_SDSOC=0
# --------------------
# Xilinx GIT Hub Links:
# https://github.com/Xilinx/device-tree-xlnx
# https://github.com/Xilinx/u-boot-xlnx
# https://github.com/Xilinx/linux-xlnx
# Set Xilinx GIT Clone Path:
export XILINXGIT_DEVICETREE=/home/xilinx_git/device-tree-xlnx
# --------------------
# optional Xilinx Environment variables
# -- QSPI Uboot debug:
# export XIL_CSE_ZYNQ_DISPLAY_UBOOT_MESSAGES=1
# --------------------
