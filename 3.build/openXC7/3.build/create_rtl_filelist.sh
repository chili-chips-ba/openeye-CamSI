#!/bin/bash

# Initialize the RTL_FILES array
RTL_FILES=()

# Function to print usage instructions
usage() {
    echo "Usage: $0 [-v | -sv | -sv2v]"
    echo "  -v     : Generate rtl.filelist with .v extensions"
    echo "  -sv    : Generate rtl.filelist with .sv extensions (default)"
    echo "  -sv2v  : Generate rtl.filelist with .sv extensions for sv2v"
    exit 1
}

echo "----------------------------------"
echo "Running create_rtl_filelist script"

# Determine the file extension based on the provided parameter
# If no parameter is provided, default to -sv

case "$1" in
    -v)
        EXT=".v"
        echo "Using extension: .v"
        ;;
    -sv | "")
        EXT=".sv"
        echo "Using extension: .sv"
        ;;
    -sv2v)
        EXT=".sv"
        echo "Using extension: .sv for sv2v"
        ;;
    *)
        usage
        ;;
esac

# Add the anomaly file which is always .v because there is no need to convert it to Verilog from SystemVerilog
RTL_FILES+=("modules/misc/src/afifo.v")

# Toolchain Directories and Executable Commands
BLD_DIR=$(pwd)
HW_SRC="$BLD_DIR/../1.hw"
SW_SRC="$BLD_DIR/../2.sw"

# Ensure the HW_SRC directory exists
if [ ! -d "$HW_SRC" ]; then
    echo "Directory $HW_SRC does not exist. Creating it..."
    mkdir -p "$HW_SRC"
fi

# Define the list of RTL files with the correct extensions
rtl_files=(
    "systemverilog/top_pkg"
	 "systemverilog/lib/ip/hdmi/hdmi_pkg"
    "systemverilog/lib/fpgatech/XILINX/fpga_olvds"
    "systemverilog/lib/fpgatech/XILINX/fpga_oser10"
	 "systemverilog/lib/fpgatech/XILINX/fpga_pll_hdmi"
	 "systemverilog/lib/fpgatech/XILINX/fpga_pll_top"
	 "systemverilog/lib/ip/axis_data_fifo.OPENSRC/DP_BRAM"
	 "systemverilog/lib/ip/axis_data_fifo.OPENSRC/afifo_ctrl"
	 "systemverilog/lib/ip/axis_data_fifo.OPENSRC/axis_data_fifo"
	 "systemverilog/lib/ip/hdmi/hdmi_tdms_enc"
	 "systemverilog/lib/ip/hdmi/hdmi_backend"
	 "systemverilog/lib/ip/hdmi/hdmi_top"
	 "systemverilog/lib/ip/i2c_master/i2c_ctrl"
	 "systemverilog/lib/ip/i2c_master/i2c_top"
	 "systemverilog/csi_rx/csi_rx_phy_clk"
	 "systemverilog/csi_rx/csi_rx_phy_dat"
	 "systemverilog/csi_rx/csi_rx_clk_det"
	 "systemverilog/csi_rx/csi_rx_align_byte"
	 "systemverilog/csi_rx/csi_rx_align_word"
	 "systemverilog/csi_rx/csi_rx_packer_handler"
	 "systemverilog/csi_rx/csi_rx_hdr_ecc"
	 "systemverilog/csi_rx/csi_rx_10bit_unpack"
	 "systemverilog/csi_rx/csi_rx_12bit_unpack"
	 "systemverilog/csi_rx/csi_rx_top"
	 "systemverilog/isp/raw2rgb.8"
	 "systemverilog/isp/raw2rgb.10"
	 "systemverilog/isp/raw2rgb.12"
	 "systemverilog/isp/raw2rgb.14"
	 "systemverilog/isp/isp_top"
	 "systemverilog/misc/rgb2hdmi"
	 "systemverilog/misc/clkrst_gen"
	 "systemverilog/top"
)

# Add each file with the appropriate extension to the RTL_FILES array
for file in "${rtl_files[@]}"; do
    RTL_FILES+=("${file}${EXT}")
done

# Path to the rtl.filelist in 1.hw directory
RTL_FILELIST="$HW_SRC/rtl.filelist"

# Create or overwrite the rtl.filelist file
echo "Creating rtl.filelist with RTL files in $HW_SRC..."
> "$RTL_FILELIST"  # This truncates the file if it exists or creates a new one

# Add each file to rtl.filelist with the full path
for file in "${RTL_FILES[@]}"; do
    echo "$HW_SRC/$file" >> "$RTL_FILELIST"
done

echo "rtl.filelist created successfully in $HW_SRC using extension $EXT."
echo "Finished create_rtl_filelist script"
echo "-----------------------------------"

