#
# Authored by: Robert Metchev / Chips & Scripts (rmetchev@ieee.org)
#
# CERN Open Hardware Licence Version 2 - Permissive
#
# Copyright (C) 2024 Robert Metchev
#

SIM_TIME ?= 100000  # Run simulation for 100000 ns

XILINX = /tools/Xilinx/Vivado/2023.2
XILINX_UNISIMS = $(XILINX)/data/verilog/src/unisims

HW_SRC	:= ../../../1.hw

# Design sources
VERILOG_SOURCES += \
        tb.sv \
        dumper.sv \
        ${HW_SRC}/lib/fpgatech/XILINX/fpga_pll_hdmi.sv \
        ${HW_SRC}/lib/fpgatech/XILINX/fpga_pll_top.sv 

# Xilinx primitives
VERILOG_SOURCES += \
        $(XILINX)/data/verilog/src/glbl.v \
        $(XILINX_UNISIMS)/BUFG.v \
        $(XILINX_UNISIMS)/OBUFDS.v \

# Xilinx primitives modelled for verilator
VERILOG_SOURCES += \
        $(XILINX_UNISIMS)/MMCME2_BASE.v \
        $(XILINX_UNISIMS)/MMCME2_ADV.v \
        $(XILINX_UNISIMS)/OSERDESE2.v \
        $(XILINX)/data/secureip/oserdese2/oserdese2_002.vp

# Xilinx libraries for CSI
VERILOG_SOURCES += \
        $(XILINX_UNISIMS)/BUFR.v \
        $(XILINX_UNISIMS)/BUFMR.v \
        $(XILINX_UNISIMS)/IBUFDS.v \
        $(XILINX_UNISIMS)/IDELAYE2.v \
        $(XILINX_UNISIMS)/IDELAYCTRL.v \
        $(XILINX_UNISIMS)/IOBUF.v \
        $(XILINX_UNISIMS)/ISERDESE2.v \
        $(XILINX)/data/secureip/iserdese2/iserdese2_002.vp

VERILOG_INCLUDE_DIRS += .

ifeq ($(WAVES),1)
DUMP := ""
endif


all:
	xvlog --sv $(VERILOG_SOURCES) $(VERILOG_INCLUDE_DIRS:%=--include %)  --define DUMP
	xelab -s my_snapshot glbl dumper tb --timescale 1ns/1ps
	xsim my_snapshot --R --xsimdir . --testplusarg "dump"

g gtkwave:
	gtkwave dump.vcd  # -a 1.gtkw -o

clean: 
	rm -rf dump.vcd dump.wdb my_snapshot.wdb .Xil
	rm -rf xvlog.* xelab.* xsim*.*
