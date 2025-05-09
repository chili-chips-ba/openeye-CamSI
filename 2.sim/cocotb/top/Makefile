# SPDX-FileCopyrightText: 2024 Robert Metchev
#
# SPDX-License-Identifier: CERN-OHL-P-2.0

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

# Control testcase
TESTCASE ?= test_0
export TESTCASE := $(TESTCASE)

TOPLEVEL_LANG ?= verilog

XILINX_ORIG = ../../models/no-change

HW_SRC	:= $(realpath ../../../1.hw)

# Read verilog sources from 1.hw/top.filelist
TOP_FILELIST = $(shell perl -ne 's/\$$\{HW_SRC\}\///g ; print unless /^\s*\#/' ${HW_SRC}/top.filelist)
VERILOG_SOURCES += $(TOP_FILELIST:%=$(HW_SRC)/%)

# Xilinx primitives      
VERILOG_SOURCES += \
        $(XILINX_ORIG)/glbl.v \
        $(XILINX_ORIG)/BUFG.v \
	$(XILINX_ORIG)/OBUFDS.v \
	$(XILINX_ORIG)/BUFMR.v \
	$(XILINX_ORIG)/IBUFDS.v \
	$(XILINX_ORIG)/IDELAYCTRL.v \
	$(XILINX_ORIG)/IOBUF.v 

VERILOG_SOURCES += \
        ../../models/BUFR.v \
        ../../models/IDELAYE2.v

VERILOG_INCLUDE_DIRS += 

COMMON_DEFINES += \
        SIM_ONLY \
        HACKED_UNISIM \
        OSERDES_SIM_MODEL \
        ISERDES_SIM_MODEL

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

# Control sim runtime
RUN_SIM_US ?= 200
export RUN_SIM_US := $(RUN_SIM_US)

# Convert Xs for now
export COCOTB_RESOLVE_X := ZEROS    

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = top

# MODULE is the basename of the Python test file
MODULE = test_top
export PYTHONPATH := $(realpath .)

# include cocotb's make rules to take care of the simulator setup
sim: $(VERILOG_SOURCES)
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
	rm -rf dump.vcd dump.vcd.fst dump.vcd.fst.hier dump.fst.hier
	rm -rf transcript modelsim.ini vsim.wlf vsim_stacktrace.vstf vish_stacktrace.vstf
