Project Description
==========================================================================
Important notes:
 1.Please do not use space character on path name.
 2.(Win OS)Please use short path name on Windows OS. This OS allows only 256 characters in normal path. 
 3.(Linux OS) Use bash as shell (change for example with: sudo dpkg-reconfigure dash)
 4.(Linux OS) Add access rights to bash files (change for example with: chmod 777 <filename>)
==========================================================================
Optional  to reduce Path length on Windows OS:
Run "_use_virtual_drive.cmd" to create a virtual drive for the design folder (<drive>:\<design folder>).
==========================================================================
1. Create Command Files and open documentation links:
  On Windows OS: run "_create_win_setup.cmd" and follow setup instructions 
  On Linux OS: run "_create_linux_setup.sh"  and follow setup instructions 
  Note: Created CMD Files works only on project root directory. (It doesn't work to execute files on "<design root directory>/console/<type>/")
==============================
1.1 Important: "Module selection guide" modifies design_basic_settings file (Step 2 or 3) automatically on project creation
==============================
Attention:
  =====
  Run design_clear_design_folders.cmd/sh clear all generated files and folders (vivado, workspace(vitis & sdk), vlog,...)!
==============================
Basic documentations:
  =====
  VIVADO/Vitis/Petalinuy
  https://wiki.trenz-electronic.de/display/PD/Xilinx+Development+Tools
  ==
  Project Delivery:
  https://wiki.trenz-electronic.de/display/PD/Project+Delivery+-+Xilinx+devices
  ==
  Trenz Electronic product description
  https://wiki.trenz-electronic.de/display/PD/Products
  ==
  Additional Information are available on the wiki page of the design
  https://wiki.trenz-electronic.de/display/PD/<Series Name>+Reference+Designs
====================================================================================================================================================
==========================================================================
====================================================================================================================================================
====================================================================================================================================================
2. (optional) Create Vivado Project on Windows OS use instructions from option 1 of:
  =====
  https://wiki.trenz-electronic.de/display/PD/Vivado+Projects+-+TE+Reference+Design
  =====
  1.Modify start setting:
  =====
  Edit "design_basic_settings.cmd" with text editor:
    Set your vivado installation path for edit: 
      @set XILDIR=C:\Xilinx
      @set VIVADO_VERSION=2021.2
      In this example the it search in 
        C:\Xilinx\Vivado\2021.2 for VIVADO
        C:\Xilinx\Vitis\2021.2 for SDK (optional for some functionality, HSI/SDK)
        C:\Xilinx\Vivado_Lab\2021.2 for VIVADO Labtools (optional for programming only)
    Set the correct part number for your pcb variant (see board_files/TExxx_board_files.csv), edit:
      @set PARTNUMBER=<number from the csv list>
    ==
    For SDSoC Design only (SDSxC installation is used):
      Set variables:
        @set ENABLE_SDSOC=1
        @set ZIP_PATH=C:/Program Files/7-Zip/7z.exe
  =====
  2.Run "vivado_create_project_guimode.cmd"
==============================
2.(optional) Create Vivado Project on Linux use instructions from option 1 of:
  =====
  https://wiki.trenz-electronic.de/display/PD/Vivado+Projects+-+TE+Reference+Design
  =====
  1.Modify start setting:
  =====
  Edit "design_basic_settings.sh" with text editor:
    Set your vivado installation path for edit: 
      @set XILDIR=/opt/Xilinx
      @set VIVADO_VERSION=2021.2
      In this example the it search in 
        /opt/Vivado/2021.2 for VIVADO
        /opt/Vitis/2021.2 for SDK (optional for some functionality, HSI/SDK)
        /opt/Vivado_Lab/2021.2 for VIVADO Labtools (optional for programming only)
    Set the correct part number for your pcb variant (see board_files/TE0xxx_board_files.csv), edit:
      @set PARTNUMBER=<number from the csv list>
  =====
  2.Run "vivado_create_project_guimode.sh"

=====
NOTES
=====