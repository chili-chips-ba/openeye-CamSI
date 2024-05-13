#
# Authored by: Robert Metchev / Chips & Scripts (rmetchev@ieee.org)
#
# CERN Open Hardware Licence Version 2 - Permissive
#
# Copyright (C) 2024 Robert Metchev
#

SHELL=/bin/bash
# defaults
SIM ?= verilator
#SIM ?= icarus
export SIM := $(SIM)

TOPLEVEL_LANG ?= verilog

XILINX = /tools/Xilinx/Vivado/2023.2
XILINX_UNISIMS = $(XILINX)/data/verilog/src/unisims

HW_SRC	:= ../../../1.hw

VERILOG_SOURCES += \
        $(HW_SRC)/top_pkg.sv

#---Library of target-specific components
VERILOG_SOURCES += \
        ${HW_SRC}/lib/fpgatech/XILINX/fpga_olvds.sv \
        ${HW_SRC}/lib/fpgatech/XILINX/fpga_oser10.sv \
        ${HW_SRC}/lib/fpgatech/XILINX/fpga_pll_hdmi.sv \
        ${HW_SRC}/lib/fpgatech/XILINX/fpga_pll_top.sv 

#---Library of IP components
VERILOG_SOURCES += \
        ${HW_SRC}/lib/ip/axis_data_fifo.OPENSRC/DP_BRAM.sv \
        ${HW_SRC}/lib/ip/axis_data_fifo.OPENSRC/afifo.sv \
        ${HW_SRC}/lib/ip/axis_data_fifo.OPENSRC/axis_data_fifo.sv \

VERILOG_SOURCES += \
        $(HW_SRC)/lib/ip/hdmi/hdmi_pkg.sv \
        ${HW_SRC}/lib/ip/hdmi/hdmi_tdms_enc.sv \
        ${HW_SRC}/lib/ip/hdmi/hdmi_backend.sv \
        ${HW_SRC}/lib/ip/hdmi/hdmi_top.sv

VERILOG_SOURCES += \
        ${HW_SRC}/lib/ip/i2c_master/i2c_ctrl.sv \
        ${HW_SRC}/lib/ip/i2c_master/i2c_top.sv

#---CSI-Rx
VERILOG_SOURCES += \
        ${HW_SRC}/csi_rx/csi_rx_phy_clk.sv \
        ${HW_SRC}/csi_rx/csi_rx_phy_dat.sv \
        ${HW_SRC}/csi_rx/csi_rx_clk_det.sv \
        ${HW_SRC}/csi_rx/csi_rx_align_byte.sv \
        ${HW_SRC}/csi_rx/csi_rx_align_word.sv \
        ${HW_SRC}/csi_rx/csi_rx_packer_handler.sv \
        ${HW_SRC}/csi_rx/csi_rx_hdr_ecc.sv \
        ${HW_SRC}/csi_rx/csi_rx.sv \
        ${HW_SRC}/csi_rx/csi_rx_top.sv

#---ISP
VERILOG_SOURCES += \
        ${HW_SRC}/isp/raw2rgb.sv

#---Misc
VERILOG_SOURCES += \
        ${HW_SRC}/misc/rgb2hdmi.sv \
        ${HW_SRC}/misc/clkrst_gen.sv

#---TOP
VERILOG_SOURCES += \
        $(HW_SRC)/top.sv 

# Xilinx primitives      
VERILOG_SOURCES += \
        $(XILINX)/data/verilog/src/glbl.v \
        $(XILINX_UNISIMS)/BUFG.v \
        $(XILINX_UNISIMS)/OBUFDS.v \
        $(XILINX_UNISIMS)/BUFMR.v \
        $(XILINX_UNISIMS)/IBUFDS.v \
        $(XILINX_UNISIMS)/IDELAYCTRL.v \
        $(XILINX_UNISIMS)/IOBUF.v 

VERILOG_SOURCES += \
        ../../models/BUFR.v \
        ../../models/IDELAYE2.v \
        ../../models/ISERDESE2.v

VERILOG_INCLUDE_DIRS +=  $(HW_SRC)

COMMON_DEFINES += \
        HACKED_UNISIM \
        OSERDES_SIM_MODEL

PLUSARGS += \
        +i2c_init_mem_file="${HW_SRC}/lib/ip/i2c_master/i2c_init.mem"

ifeq ($(SIM),$(filter $(SIM),verilator VERILATOR))
        EXTRA_ARGS += $(COMMON_DEFINES:%=+define+%)
        EXTRA_ARGS += --no-timing
        ifeq ($(WAVES),1)
                EXTRA_ARGS += --trace --trace-structs --trace-fst
        endif
        WNO = fatal WIDTHTRUNC WIDTHEXPAND ASCRANGE EOFNEWLINE PINCONNECTEMPTY DECLFILENAME GENUNNAMED VARHIDDEN UNUSEDPARAM
        WNO += STMTDLY ASSIGNDLY
        EXTRA_ARGS += -Wall $(WNO:%=-Wno-%)
endif
ifeq ($(SIM),$(filter $(SIM),icarus ICARUS))
        COMPILE_ARGS += $(COMMON_DEFINES:%=-D%)
        COMPILE_ARGS += -DICARUS
        COMPILE_ARGS += -Wall
        COMPILE_ARGS += -g2005-sv
endif


# Convert Xs for now
export COCOTB_RESOLVE_X := ZEROS    

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = top

# MODULE is the basename of the Python test file
MODULE = test_top
export PYTHONPATH := $(realpath .)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

g gtkwave:
ifeq ($(SIM),$(filter $(SIM),icarus ICARUS))
	gtkwave sim_build/$(TOPLEVEL).fst
endif
ifeq ($(SIM),$(filter $(SIM),verilator VERILATOR))
	gtkwave dump.fst -o # -a 1.gtkw
endif

clean::
	rm -rf __pycache__ results.xml
	rm -rf dump.vcd dump.vcd.fst dump.vcd.fst.hier 
	rm -rf transcript modelsim.ini vsim.wlf vsim_stacktrace.vstf vish_stacktrace.vstf
