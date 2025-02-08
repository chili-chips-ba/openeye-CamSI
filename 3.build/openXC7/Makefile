PREFIX ?= /snap/openxc7/current
DB_DIR=${PREFIX}/opt/nextpnr-xilinx/external/prjxray-db
CHIPDB=../chipdb

#PART = xc7a100tcsg324-1
PART = xc7a100tcsg324-2

CURR_DIR := $(CURDIR)
SW_DIR := $(CURR_DIR)/2.sw

SRC_DIR0 = 1.hw
SRC_DIR1 = 1.hw/csi_rx
SRC_DIR2 = 1.hw/isp
SRC_DIR3a = 1.hw/lib/fpgatech/XILINX
SRC_DIR3b = 1.hw/lib/ip/axis_data_fifo.OPENSRC
SRC_DIR3c = 1.hw/lib/ip/axis_data_fifo.XILINX
SRC_DIR3d = 1.hw/lib/ip/hdmi
SRC_DIR3e = 1.hw/lib/ip/i2c_master
SRC_DIR4 = 1.hw/misc

SRC_FILES0 := $(wildcard $(CURR_DIR)/$(SRC_DIR0)/*.v)
SRC_FILES1_COMMON := $(filter-out $(CURR_DIR)/$(SRC_DIR1)/csi_rx_top_1.v $(CURR_DIR)/$(SRC_DIR1)/csi_rx_top_2.v, $(wildcard $(CURR_DIR)/$(SRC_DIR1)/*.v))
SRC_FILES2 := $(wildcard $(CURR_DIR)/$(SRC_DIR2)/*.v)
SRC_FILES3a := $(wildcard $(CURR_DIR)/$(SRC_DIR3a)/*.v)
SRC_FILES3b := $(wildcard $(CURR_DIR)/$(SRC_DIR3b)/*.v)
SRC_FILES3c := $(wildcard $(CURR_DIR)/$(SRC_DIR3c)/*.v)
SRC_FILES3d := $(wildcard $(CURR_DIR)/$(SRC_DIR3d)/*.v)
SRC_FILES3e := $(wildcard $(CURR_DIR)/$(SRC_DIR3e)/*.v)
SRC_FILES4 := $(wildcard $(CURR_DIR)/$(SRC_DIR4)/*.v)

XDC_FILE := $(CURR_DIR)/$(SRC_DIR0)/top.Artix100.CRUVI_CC.xdc
TOP_FILE := $(CURR_DIR)/$(SRC_DIR0)/top.v

# CSI_RX top files
CSI_RX_TOP_1 := $(CURR_DIR)/$(SRC_DIR1)/csi_rx_top_1.v
CSI_RX_TOP_2 := $(CURR_DIR)/$(SRC_DIR1)/csi_rx_top_2.v

.PHONY: all
all: error1 error2

.PHONY: error1
error1: error1.bit

.PHONY: error2
error2: error2.bit

.PHONY: program
program: top.bit
	openFPGALoader --board basys3 --bitstream $<

# Build process for error1
error1.json: $(TOP_FILE) $(SRC_FILES1_COMMON) $(CSI_RX_TOP_1) $(SRC_FILES2) $(SRC_FILES3a) $(SRC_FILES3b) $(SRC_FILES3d) $(SRC_FILES3e) $(SRC_FILES4)
	yosys -p "synth_xilinx -flatten -abc9 -arch xc7 -top top; write_json error1.json" $(TOP_FILE) $(SRC_FILES1_COMMON) $(CSI_RX_TOP_1) $(SRC_FILES2) $(SRC_FILES3a) $(SRC_FILES3b) $(SRC_FILES3d) $(SRC_FILES3e) $(SRC_FILES4)

error1.fasm: error1.json ${CHIPDB}/${PART}.bin
	nextpnr-xilinx --chipdb ${CHIPDB}/${PART}.bin --xdc $(XDC_FILE) --json error1.json --fasm $@ --verbose --debug

error1.frames: error1.fasm
	fasm2frames --part ${PART} --db-root ${DB_DIR}/artix7 $< > $@

error1.bit: error1.frames
	xc7frames2bit --part_file ${DB_DIR}/artix7/${PART}/part.yaml --part_name ${PART} --frm_file $< --output_file $@

# Build process for error2
error2.json: $(TOP_FILE) $(SRC_FILES1_COMMON) $(CSI_RX_TOP_2) $(SRC_FILES2) $(SRC_FILES3a) $(SRC_FILES3b) $(SRC_FILES3d) $(SRC_FILES3e) $(SRC_FILES4)
	yosys -p "synth_xilinx -flatten -abc9 -arch xc7 -top top; write_json error2.json" $(TOP_FILE) $(SRC_FILES1_COMMON) $(CSI_RX_TOP_2) $(SRC_FILES2) $(SRC_FILES3a) $(SRC_FILES3b) $(SRC_FILES3d) $(SRC_FILES3e) $(SRC_FILES4)

error2.fasm: error2.json ${CHIPDB}/${PART}.bin
	nextpnr-xilinx --chipdb ${CHIPDB}/${PART}.bin --xdc $(XDC_FILE) --json error2.json --fasm $@ --verbose --debug

error2.frames: error2.fasm
	fasm2frames --part ${PART} --db-root ${DB_DIR}/artix7 $< > $@

error2.bit: error2.frames
	xc7frames2bit --part_file ${DB_DIR}/artix7/${PART}/part.yaml --part_name ${PART} --frm_file $< --output_file $@

${CHIPDB}/${PART}.bin:
	python3 ${PREFIX}/opt/nextpnr-xilinx/python/bbaexport.py --device ${PART} --bba ${PART}.bba
	bbasm -l ${PART}.bba ${CHIPDB}/${PART}.bin
	rm -f ${PART}.bba

.PHONY: clean
clean:
	@rm -f *.bit *.frames *.fasm *.json
