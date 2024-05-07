#=============================================================
# Copyright (C) 2024 Chili.CHIPS*ba
#=============================================================
SHELL   := /bin/bash

HW_SRC	:= $(CURDIR)/../1.hw
TB_NAME := tb

export HW_SRC TB_NAME


#------------------------
.PHONY: all
all: clean sim wave

#------------------------
clean:
	rm -rf output

#-------------------------------------------------------------
#___Global macros___
#   +define+SIM_ONLY \    to speed-up things for sim
#   +define+MIPI_4_LANE \
#
#___Xilinx macros___
#   +define+XIL_TIMING \
#   +define+HACKED_UNISIM \
#
#-------------------------------------------------------------
compile: 
	verilator \
		--cc \
		--timing \
		--trace-fst \
		--trace-structs \
		--timescale-override 1ps/1ps \
		--exe versimSV.cpp \
		--Mdir ./output \
		\
		+define+SIM_ONLY \
		+define+HACKED_UNISIM \
		\
		-f ${HW_SRC}/top.filelist \
		\
		models/xilinx.unisim.CHILI.v \
		${TB_NAME}.sv \
		--top-module ${TB_NAME}

#		-O1 \
#		-O3 \
#		-Wno-fatal \
#		--debug \
#		--trace-threads 1 \
#
#		--x-assign fast \
#		--x-initial fast \
#		--noassert \
#		--no-timing \
#		--trace-depth 10 \
#		--trace-max-array 1024 \    Maximum array depth for tracing
#		--trace-max-width 32 \      Maximum bit width for tracing
#
#		--assert \  read //synopsys full_case or //synopsys parallel_case
#		     //ambit synthesis, //cadence or //pragma directives
#		     Also asserts any "unique" or "priority" SV keywords on
#		     case statements, as well as "unique" on if statements.
#		     However, "priority if" is currently ignored.


#------------------------
sim: compile
	cd output; \
	make -f V${TB_NAME}.mk  V${TB_NAME}; \
	./V${TB_NAME} | tee sim.log

#------------------------
wave: xml2stems
	cd output; \
	gtkwave --saveonexit \
		--slider-zoom \
		--stems   ../tb.stems \
		--logfile sim.log \
		-rc       ../.gtkwaverc \
		--dump    wave.fst &

#		--wish \
#		--save ../wave.gtkw 

#------------------------
wave-alt: 
	cd output; \
	surfer.exe -s ../wave.surfer.ron wave.fst &

#------------------------
xml2stems: 
	verilator \
		--timing \
		-xml-only \
		-xml-output tb.xml \
		--timescale 1ps/1ps \
		-f ${HW_SRC}/top.filelist \
		${TB_NAME}.sv \
                \
		+define+SIM_ONLY \
		+define+HACKED_UNISIM \
                \
		models/xilinx.unisim.CHILI.v \
		--top-module ${TB_NAME}
	xml2stems tb.xml tb.stems


#------------------------
rtlbrowse: xml2stems
	rtlbrowse tb.stems   

#=============================================================
# End-of-File
#=============================================================
