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
SRC_FILES1 := $(wildcard $(CURR_DIR)/$(SRC_DIR1)/*.v)
SRC_FILES2 := $(wildcard $(CURR_DIR)/$(SRC_DIR2)/*.v)
SRC_FILES3a := $(wildcard $(CURR_DIR)/$(SRC_DIR3a)/*.v)
SRC_FILES3b := $(wildcard $(CURR_DIR)/$(SRC_DIR3b)/*.v)
SRC_FILES3c := $(wildcard $(CURR_DIR)/$(SRC_DIR3c)/*.v)
SRC_FILES3d := $(wildcard $(CURR_DIR)/$(SRC_DIR3d)/*.v)
SRC_FILES3e := $(wildcard $(CURR_DIR)/$(SRC_DIR3e)/*.v)
SRC_FILES4 := $(wildcard $(CURR_DIR)/$(SRC_DIR4)/*.v)

XDC_FILE := $(CURR_DIR)/$(SRC_DIR0)/top.Artix100.CRUVI_CC.xdc
TOP_FILE := $(CURR_DIR)/$(SRC_DIR0)/top.v

.PHONY: all
all: top.bit

.PHONY: program
program: top.bit
	openFPGALoader --board basys3 --bitstream $<
	
top.json: $(TOP_FILE) $(SRC_FILES1) $(SRC_FILES2) $(SRC_FILES3a) $(SRC_FILES3b) $(SRC_FILES3d) $(SRC_FILES3e) $(SRC_FILES4)
	yosys -p "synth_xilinx -flatten -abc9 -arch xc7 -top top; write_json top.json" $(TOP_FILE) $(SRC_FILES1) $(SRC_FILES2) $(SRC_FILES3a) $(SRC_FILES3b) $(SRC_FILES3d) $(SRC_FILES3e) $(SRC_FILES4)

# The chip database only needs to be generated once
# that is why we don't clean it with make clean
${CHIPDB}/${PART}.bin:
	python3 ${PREFIX}/opt/nextpnr-xilinx/python/bbaexport.py --device ${PART} --bba ${PART}.bba
	bbasm -l ${PART}.bba ${CHIPDB}/${PART}.bin
	rm -f ${PART}.bba
	
	
top.fasm: top.json ${CHIPDB}/${PART}.bin
	nextpnr-xilinx --chipdb ${CHIPDB}/${PART}.bin --xdc $(XDC_FILE) --json top.json --fasm $@ --verbose --debug
	
top.frames: top.fasm
	fasm2frames --part ${PART} --db-root ${DB_DIR}/artix7 $< > $@ #FIXME: fasm2frames should be on PATH

top.bit: top.frames
	xc7frames2bit --part_file ${DB_DIR}/artix7/${PART}/part.yaml --part_name ${PART} --frm_file $< --output_file $@
	
	#Install gcc package: apt install gcc-riscv64-unknown-elf
CROSS=riscv64-unknown-elf-
CFLAGS=

.PHONY: clean
clean:
	@rm -f *.bit
	@rm -f *.frames
	@rm -f *.fasm
	@rm -f *.json
