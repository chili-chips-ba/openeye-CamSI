#!/bin/bash

# Script to update Yosys to version 0.60 in openXC7 installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="/opt/openxc7"
BUILD_DIR="/tmp/yosys_update"
NUM_JOBS=$(nproc)

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Yosys Update to 0.60${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then
   echo -e "${RED}ERROR: Do not run this script as root!${NC}"
   echo "The script will use sudo when needed."
   exit 1
fi

# Check if openXC7 is installed
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${RED}ERROR: $INSTALL_DIR does not exist!${NC}"
    echo "Please install openXC7 first."
    exit 1
fi

# Create build directory
echo -e "${YELLOW}Creating build directory...${NC}"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Clone or update Yosys
echo -e "${YELLOW}Fetching Yosys repository...${NC}"
if [ -d "yosys" ]; then
    echo "Yosys directory exists, cleaning and updating..."
    cd yosys
    # Clean any previous build
    make clean 2>/dev/null || true
    git fetch --all --tags
    git reset --hard
else
    git clone https://github.com/YosysHQ/yosys.git
    cd yosys
fi

# Checkout version 0.60
echo -e "${YELLOW}Checking out Yosys v0.60...${NC}"
git checkout v0.60

# CRITICAL: Initialize submodules
echo -e "${YELLOW}Initializing submodules (abc, cxxopts, etc.)...${NC}"
git submodule update --init --recursive

# Clean any previous build
echo -e "${YELLOW}Cleaning previous build...${NC}"
make clean || true

# Build and install
echo -e "${YELLOW}Building Yosys (using $NUM_JOBS jobs)...${NC}"
make config-clang
make -j$NUM_JOBS

echo -e "${YELLOW}Installing Yosys to $INSTALL_DIR...${NC}"
sudo make install PREFIX="$INSTALL_DIR"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Yosys updated successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Verify installation:${NC}"
echo "  source $INSTALL_DIR/setup_env.sh"
echo "  yosys --version"
echo ""

# Cleanup
cd /tmp
read -p "Delete build directory $BUILD_DIR? (y/n): " cleanup
if [ "$cleanup" = "y" ]; then
    rm -rf "$BUILD_DIR"
    echo -e "${GREEN}Build directory deleted.${NC}"
fi
