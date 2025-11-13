# Makefile for openXC7 - Local Installation Version
# This version uses local installation instead of snap

PREFIX ?= /opt/openxc7

# Check if environment is setup
ifndef PRJXRAY_DB_DIR
$(error Please run: source $(PREFIX)/setup_env.sh)
endif

# Paths to databases and tools
DB_DIR = $(PREFIX)/share/prjxray-db
CHIPDB = ../chipdb

# FPGA Part specification
PART = xc7a100tcsg324-2

# Project directories
CURR_DIR := $(CURDIR)
SW_DIR := $(CURR_DIR)/2.sw

# Source directories
SRC_DIR0 = 1.hw
SRC_DIR1 = 1.hw/csi_rx
SRC_DIR2 = 1.hw/isp
SRC_DIR3a = 1.hw/lib/fpgatech/XILINX
SRC_DIR3b = 1.hw/lib/ip/axis_data_fifo.OPENSRC
SRC_DIR3c = 1.hw/lib/ip/axis_data_fifo.XILINX
SRC_DIR3d = 1.hw/lib/ip/hdmi
SRC_DIR3e = 1.hw/lib/ip/i2c_master
SRC_DIR4 = 1.hw/misc

# =============================================================================
# SOURCE FILES
# =============================================================================

SRC_FILES0 := $(wildcard $(CURR_DIR)/$(SRC_DIR0)/*.v)

SRC_FILES1_COMMON := $(filter-out \
    $(CURR_DIR)/$(SRC_DIR1)/csi_rx_top.v \
    $(CURR_DIR)/$(SRC_DIR1)/csi_rx_top_1.v \
    $(CURR_DIR)/$(SRC_DIR1)/csi_rx_top_2.v, \
    $(wildcard $(CURR_DIR)/$(SRC_DIR1)/*.v))

SRC_FILES2 := $(wildcard $(CURR_DIR)/$(SRC_DIR2)/*.v)
SRC_FILES3a := $(wildcard $(CURR_DIR)/$(SRC_DIR3a)/*.v)
SRC_FILES3b := $(wildcard $(CURR_DIR)/$(SRC_DIR3b)/*.v)
SRC_FILES3c := $(wildcard $(CURR_DIR)/$(SRC_DIR3c)/*.v)
SRC_FILES3d := $(wildcard $(CURR_DIR)/$(SRC_DIR3d)/*.v)
SRC_FILES3e := $(wildcard $(CURR_DIR)/$(SRC_DIR3e)/*.v)
SRC_FILES4 := $(wildcard $(CURR_DIR)/$(SRC_DIR4)/*.v)

# Constraint and top files
XDC_FILE := $(CURR_DIR)/$(SRC_DIR0)/top.Artix100.CRUVI_CC.xdc
TOP_FILE := $(CURR_DIR)/$(SRC_DIR0)/top.v

# CSI_RX top files
CSI_RX_TOP_1 := $(CURR_DIR)/$(SRC_DIR1)/csi_rx_top_1.v
CSI_RX_TOP_2 := $(CURR_DIR)/$(SRC_DIR1)/csi_rx_top_2.v

# =============================================================================
# TARGETS
# =============================================================================

.PHONY: all
all: error1 error2

.PHONY: error1
error1: error1.bit

.PHONY: error2
error2: error2.bit

.PHONY: program
program: top.bit
	openFPGALoader --board basys3 --bitstream $<

.PHONY: check-env
check-env:
	@echo "Checking environment..."
	@echo "PREFIX: $(PREFIX)"
	@echo "DB_DIR: $(DB_DIR)"
	@echo "PRJXRAY_DB_DIR: $(PRJXRAY_DB_DIR)"
	@which yosys > /dev/null || (echo "ERROR: yosys not found!" && exit 1)
	@which nextpnr-xilinx > /dev/null || (echo "ERROR: nextpnr-xilinx not found!" && exit 1)
	@which fasm2frames > /dev/null || (echo "ERROR: fasm2frames not found!" && exit 1)
	@which xc7frames2bit > /dev/null || (echo "ERROR: xc7frames2bit not found!" && exit 1)
	@echo "All OK!"

# =============================================================================
# BUILD PROCESS - ERROR1 (with csi_rx_top_1.v)
# =============================================================================

error1.json: $(TOP_FILE) $(SRC_FILES1_COMMON) $(CSI_RX_TOP_1) $(SRC_FILES2) \
             $(SRC_FILES3a) $(SRC_FILES3b) $(SRC_FILES3d) $(SRC_FILES3e) $(SRC_FILES4)
	@echo "Synthesis: error1 configuration..."
	yosys -p "synth_xilinx -flatten -abc9 -arch xc7 -top top; write_json error1.json" \
		$(TOP_FILE) $(SRC_FILES1_COMMON) $(CSI_RX_TOP_1) $(SRC_FILES2) \
		$(SRC_FILES3a) $(SRC_FILES3b) $(SRC_FILES3d) $(SRC_FILES3e) $(SRC_FILES4)

error1.fasm: error1.json ${CHIPDB}/${PART}.bin
	@echo "Place and Route: error1..."
	nextpnr-xilinx --chipdb ${CHIPDB}/${PART}.bin \
		--xdc $(XDC_FILE) \
		--json error1.json \
		--fasm $@ \
		--verbose --debug

error1.frames: error1.fasm
	@echo "Converting FASM to frames: error1..."
	fasm2frames --part ${PART} --db-root ${DB_DIR}/artix7 $< > $@

error1.bit: error1.frames
	@echo "Creating bitstream: error1..."
	xc7frames2bit --part_file ${DB_DIR}/artix7/${PART}/part.yaml \
		--part_name ${PART} \
		--frm_file $< \
		--output_file $@
	@echo "Bitstream created: error1.bit"

# =============================================================================
# BUILD PROCESS - ERROR2 (with csi_rx_top_2.v)
# =============================================================================

error2.json: $(TOP_FILE) $(SRC_FILES1_COMMON) $(CSI_RX_TOP_2) $(SRC_FILES2) \
             $(SRC_FILES3a) $(SRC_FILES3b) $(SRC_FILES3d) $(SRC_FILES3e) $(SRC_FILES4)
	@echo "Synthesis: error2 configuration..."
	yosys -p "synth_xilinx -flatten -abc9 -arch xc7 -top top; write_json error2.json" \
		$(TOP_FILE) $(SRC_FILES1_COMMON) $(CSI_RX_TOP_2) $(SRC_FILES2) \
		$(SRC_FILES3a) $(SRC_FILES3b) $(SRC_FILES3d) $(SRC_FILES3e) $(SRC_FILES4)

error2.fasm: error2.json ${CHIPDB}/${PART}.bin
	@echo "Place and Route: error2..."
	nextpnr-xilinx --chipdb ${CHIPDB}/${PART}.bin \
		--xdc $(XDC_FILE) \
		--json error2.json \
		--fasm $@ \
		--verbose --debug

error2.frames: error2.fasm
	@echo "Converting FASM to frames: error2..."
	fasm2frames --part ${PART} --db-root ${DB_DIR}/artix7 $< > $@

error2.bit: error2.frames
	@echo "Creating bitstream: error2..."
	xc7frames2bit --part_file ${DB_DIR}/artix7/${PART}/part.yaml \
		--part_name ${PART} \
		--frm_file $< \
		--output_file $@
	@echo "Bitstream created: error2.bit"

# =============================================================================
# CHIPDB GENERATION
# =============================================================================

${CHIPDB}/${PART}.bin:
	@echo "Generating chipdb for ${PART}..."
	@mkdir -p ${CHIPDB}
	python3 $(PREFIX)/share/nextpnr-xilinx/python/bbaexport.py \
		--device ${PART} \
		--bba ${PART}.bba
	bbasm -l ${PART}.bba ${CHIPDB}/${PART}.bin
	rm -f ${PART}.bba
	@echo "Chipdb generated: ${CHIPDB}/${PART}.bin"

# =============================================================================
# UTILITY TARGETS
# =============================================================================

.PHONY: clean
clean:
	@echo "Cleaning generated files..."
	@rm -f *.bit *.frames *.fasm *.json *.bba
	@echo "Cleanup complete!"

.PHONY: clean-all
clean-all: clean
	@echo "Deleting chipdb..."
	@rm -rf ${CHIPDB}
	@echo "All deleted!"

.PHONY: info
info:
	@echo "========================================="
	@echo "openXC7 Project Information"
	@echo "========================================="
	@echo "Install Prefix:  $(PREFIX)"
	@echo "Database Dir:    $(DB_DIR)"
	@echo "FPGA Part:       $(PART)"
	@echo "Chipdb Dir:      $(CHIPDB)"
	@echo "XDC File:        $(XDC_FILE)"
	@echo "Top File:        $(TOP_FILE)"
	@echo ""
	@echo "Available targets:"
	@echo "  all        - Build both error1 and error2"
	@echo "  error1     - Build error1.bit"
	@echo "  error2     - Build error2.bit"
	@echo "  check-env  - Check if environment is set up correctly"
	@echo "  clean      - Remove generated files"
	@echo "  clean-all  - Remove all generated files including chipdb"
	@echo "  info       - Show this information"
	@echo "========================================="

.PHONY: help
help: info

# =============================================================================
# DEPENDENCIES
# =============================================================================

# Ensure chipdb exists before synthesis
error1.json error2.json: | ${CHIPDB}/${PART}.bin
