# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Holzweg 19A             *
# --   *   32257 Bünde             *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# -- $Author: Hartfiel, John $
# -- $Email: j.hartfiel@trenz-electronic.de $
# --------------------------------------------------------------------
# -- File Revision 1.0
# --------------------------------------------------------------------
# -- Change History :
# ------------------------------------------
# -- $Date: 2019/02/14 | $Author: Hartfiel, John
# -- - initial release
# ------------------------------------------
# -- $Date: 2019/04/03 | $Author: Hartfiel, John
# -- - add uard parameter
# ------------------------------------------
# -- $Date: 0000/00/00  | $Author:
# -- - 
# --------------------------------------------------------------------
# ------------------------------------------------
# copy file into <design_name>/settings/
# file will be sourced automatically when found 
# ------------------------------------------------
# TE::FILTER_DESIGN: add only article numbers which contains the the string as part design column
set TE::FILTER_DESIGN {CRUVI}
#set TE::FILTER_DESIGN [list]
# must be checked with device manager or tcl function
set TE::DESIGN_UART_COM NA
# mostly used for zynq, zynqMP: 115200, mostly used  for FPGA: 9600
set TE::DESIGN_UART_SPEED 115200