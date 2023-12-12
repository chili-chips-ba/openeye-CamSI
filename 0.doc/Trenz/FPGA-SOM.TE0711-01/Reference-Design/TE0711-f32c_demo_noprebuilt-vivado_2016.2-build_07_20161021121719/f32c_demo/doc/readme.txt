Project Description
==========================================================================
==============================
Create Vivado Project on Windows OS use instructions from option 1 of:
=====
https://wiki.trenz-electronic.de/display/PD/Vivado+Projects
=====
  1.Modify start setting:
  =====
  Edit "design_basic_settings.cmd" with text editor:
    Set your vivado installation path for edit: 
      @set XILDIR=C:\Xilinx
      @set VIVADO_VERSION=2016.2
      In this example the it search in 
        C:\Xilinx\Vivado\2016.2 for VIVADO
        C:\Xilinx\SDK\2016.2 for SDK (optional for some functionality)
        C:\Xilinx\Vivado_Lab\2016.2 for VIVADO Labtools (optional for some functionality)
    Set the correct part number for your pcb variant (see board_files/TE0710_board_files.csv), edit:
      @set PARTNUMBER=1
  =====
  2.Run "vivado_create_project_guimode.cmd"
==============================
Create Vivado Project on Linux OS use instructions from option 2 of:
=====
https://wiki.trenz-electronic.de/display/PD/Vivado+Projects
==============================
Attention:
=====
Run design_clear_design_folders.cmd clear all generated files and folders (vivado, workspace(hsi & sdk), vlog,...)!
==============================
Basic documentations:
=====
  Project Delivery:
  https://wiki.trenz-electronic.de/display/PD/Project+Delivery 
  ==
  VIVADO/SDK/SDSoC
  https://wiki.trenz-electronic.de/pages/viewpage.action?pageId=14746264
  ==
  Trenz Electronic SoMs
  https://wiki.trenz-electronic.de/display/PD/All+Trenz+Electronic+SoMs
==============================
=====
NOTES
=====