#======================================================================== 
# openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
#------------------------------------------------------------------------
#                   Copyright (C) 2024 Chili.CHIPS*ba
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions 
# are met:
#
# 1. Redistributions of source code must retain the above copyright 
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright 
# notice, this list of conditions and the following disclaimer in the 
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its 
# contributors may be used to endorse or promote products derived
# from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#              https://opensource.org/license/bsd-3-clause
#------------------------------------------------------------------------
# Build script for openXC7
#========================================================================

NEXTPNR_XILINX_DIR ?= /nextpnr-xilinx/xilinx
NEXTPNR_XILINX_PYTHON_DIR ?= ${NEXTPNR_XILINX_DIR}/python

PREFIX ?= /openxc7
PYPY3 ?= pypy3

PRJXRAY_DB_DIR ?= ${NEXTPNR_XILINX_DIR}/xilinx/external/prjxray-db

DB_DIR=/nextpnr-xilinx/xilinx/external/prjxray-db
CHIPDB=./chipdb

#PART = xc7a35tcpg236-1
PART = xc7a100tcsg324-2

CURR_DIR := $(CURDIR)

SRC_HW = 1.hw

XDC_FILE := $(CURR_DIR)/$(SRC_DIR0)/top.xdc
TOP_FILE := $(CURR_DIR)/$(SRC_DIR0)/top.sv

.PHONY: all
all: top.bit

.PHONY: program


.PHONY: clean

clean:
	@rm -f *.bit
	@rm -f *.frames
	@rm -f *.fasm
	@rm -f *.json


#----------------------------------------
# The chip database only needs to be generated once,
#  which is why we don't clean it with 'make clean'
#----------------------------------------
${CHIPDB}/${PART}.bin:
	python3 /nextpnr-xilinx/xilinx/python/bbaexport.py --device ${PART} --bba ${PART}.bba
	bbasm -l ${PART}.bba ${CHIPDB}/${PART}.bin
	rm -f ${PART}.bba


#----------------------------------------
# Synthesis
#----------------------------------------
top.json: $(TOP_FILE) $(SRC_FILES1b) $(SRC_FILES1a) $(SRC_FILES2) $(SRC_FILES3) $(SRC_FILES4) $(SRC_FILES5)
	yosys -q -p \
	"synth_xilinx -flatten -abc9 -arch xc7 -top top; write_json top.json" \
	$(TOP_FILE) 


#----------------------------------------
# PNR
#----------------------------------------

top.fasm: top.json ${CHIPDB}/${PART}.bin
	nextpnr-xilinx \
	--chipdb ${CHIPDB}/${PART}.bin \
	--xdc $(XDC_FILE) \
	--json top.json \
	--fasm $@ \
	--quiet --debug


top.frames: top.fasm
	fasm2frames --part ${PART} \
	--db-root ${DB_DIR}/artix7 $< > $@ #FIXME: fasm2frames should be on PATH


top.bit: top.frames
	xc7frames2bit --part_file /nextpnr-xilinx/xilinx/external/prjxray-db/artix7/${PART}/part.yaml \
	--part_name ${PART} \
	--frm_file $< --output_file $@


#----------------------------------------
# Bit loader
#----------------------------------------
program: top.bit
	openFPGALoader --board basys3 --bitstream $<


# End-of-File
