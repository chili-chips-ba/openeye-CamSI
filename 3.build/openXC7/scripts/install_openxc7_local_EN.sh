#!/bin/bash

# Script for local installation of openXC7 toolchain without snap
# Installs all required tools in /opt/openxc7

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="/opt/openxc7"
BUILD_DIR="/tmp/openxc7_build"
NUM_JOBS=$(nproc)

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}openXC7 Toolchain Local Installer${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Install directory: $INSTALL_DIR"
echo "Build directory: $BUILD_DIR"
echo "Using $NUM_JOBS parallel jobs"
echo ""

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then 
   echo -e "${RED}ERROR: Do not run this script as root!${NC}"
   echo "The script will use sudo when needed."
   exit 1
fi

# Create directories
echo -e "${YELLOW}Creating directories...${NC}"
sudo mkdir -p "$INSTALL_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}Installing dependencies...${NC}"
    
    # Detect distribution
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        echo -e "${RED}Cannot detect distribution!${NC}"
        exit 1
    fi
    
    case $OS in
        ubuntu|debian)
            sudo apt-get update
            sudo apt-get install -y \
                build-essential clang bison flex \
                libreadline-dev gawk tcl-dev libffi-dev git \
                graphviz xdot pkg-config python3 python3-dev python3-pip \
                libboost-system-dev libboost-python-dev libboost-filesystem-dev \
                libboost-thread-dev libboost-program-options-dev libboost-iostreams-dev \
                zlib1g-dev libeigen3-dev cmake wget curl \
                libtbb-dev libgtest-dev
            ;;
        fedora|rhel|centos)
            sudo dnf install -y \
                make clang bison flex readline-devel gawk tcl-devel libffi-devel git \
                graphviz pkgconf python3 python3-devel \
                boost-devel boost-python3-devel zlib-devel eigen3-devel cmake wget curl \
                tbb-devel gtest-devel
            ;;
        arch|manjaro)
            sudo pacman -S --needed --noconfirm \
                base-devel clang bison flex readline gawk tcl libffi git \
                graphviz pkgconf python python-pip \
                boost boost-libs zlib eigen cmake wget curl \
                tbb gtest
            ;;
        *)
            echo -e "${RED}Unsupported distribution: $OS${NC}"
            echo "Please install dependencies manually."
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}Dependencies installed!${NC}"
}

# Function to install Yosys
install_yosys() {
    echo -e "${YELLOW}Installing Yosys...${NC}"
    
    if [ -d "yosys" ]; then
        echo "Yosys directory exists, updating..."
        cd yosys
        git pull
    else
        git clone https://github.com/YosysHQ/yosys.git
        cd yosys
    fi
    
    # Checkout stable version
    git checkout yosys-0.38
    
    make config-clang
    make -j$NUM_JOBS
    sudo make install PREFIX="$INSTALL_DIR"
    
    cd "$BUILD_DIR"
    echo -e "${GREEN}Yosys installed!${NC}"
}

# Function to install prjxray and prjxray-db
install_prjxray() {
    echo -e "${YELLOW}Installing prjxray and prjxray-db...${NC}"
    
    # prjxray
    if [ -d "prjxray" ]; then
        echo "prjxray directory exists, updating..."
        cd prjxray
        git pull
    else
        git clone --recursive https://github.com/f4pga/prjxray.git
        cd prjxray
    fi
    
    git submodule update --init --recursive
    
    mkdir -p build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" ..
    make -j$NUM_JOBS
    sudo make install
    
    cd "$BUILD_DIR"
    
    # prjxray-db
    if [ -d "prjxray-db" ]; then
        echo "prjxray-db directory exists, updating..."
        cd prjxray-db
        git pull
    else
        git clone https://github.com/openXC7/prjxray-db.git
        cd prjxray-db
    fi
    
    sudo mkdir -p "$INSTALL_DIR/share/prjxray-db"
    sudo cp -r * "$INSTALL_DIR/share/prjxray-db/"
    
    cd "$BUILD_DIR"
    echo -e "${GREEN}prjxray and prjxray-db installed!${NC}"
}

# Function to install nextpnr-xilinx
install_nextpnr() {
    echo -e "${YELLOW}Installing nextpnr-xilinx...${NC}"
    
    if [ -d "nextpnr-xilinx" ]; then
        echo "nextpnr-xilinx directory exists, updating..."
        cd nextpnr-xilinx
        git pull
    else
        git clone --recursive https://github.com/openXC7/nextpnr-xilinx.git
        cd nextpnr-xilinx
    fi
    
    # CRITICAL: Initialize submodules first
    echo "Initializing submodules..."
    git submodule update --init --recursive
    
    mkdir -p build
    cd build
    
    cmake -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
          -DARCH=xilinx \
          -DBUILD_GUI=OFF \
          -DBUILD_PYTHON=ON \
          ..
    
    make -j$NUM_JOBS
    sudo make install
    
    # Go back to nextpnr-xilinx root directory
    cd ..
    
    # CRITICAL: Copy Python files and metadata (make install sometimes skips them)
    echo "Copying Python files, constids.inc and metadata..."
    sudo mkdir -p "$INSTALL_DIR/share/nextpnr-xilinx/python"
    sudo mkdir -p "$INSTALL_DIR/share/nextpnr-xilinx/external"
    
    # Copy Python scripts from xilinx/python/
    if [ -d "xilinx/python" ]; then
        sudo cp xilinx/python/*.py "$INSTALL_DIR/share/nextpnr-xilinx/python/" 2>/dev/null && \
        echo "  ✓ Python files copied" || \
        echo "  ⚠ Could not copy Python files"
    else
        echo "  ✗ xilinx/python/ directory not found!"
    fi
    
    # Copy constids.inc from xilinx/ to BOTH locations
    if [ -f "xilinx/constids.inc" ]; then
        # To python directory
        sudo cp xilinx/constids.inc "$INSTALL_DIR/share/nextpnr-xilinx/python/" 2>/dev/null
        # To parent directory (where bbaexport.py looks for it)
        sudo cp xilinx/constids.inc "$INSTALL_DIR/share/nextpnr-xilinx/" 2>/dev/null
        echo "  ✓ constids.inc copied to both locations"
    else
        echo "  ✗ xilinx/constids.inc not found!"
    fi
    
    # Copy nextpnr-xilinx-meta from xilinx/external/
    if [ -d "xilinx/external/nextpnr-xilinx-meta" ]; then
        sudo cp -r xilinx/external/nextpnr-xilinx-meta "$INSTALL_DIR/share/nextpnr-xilinx/external/" 2>/dev/null && \
        echo "  ✓ nextpnr-xilinx-meta copied" || \
        echo "  ⚠ Could not copy nextpnr-xilinx-meta"
    else
        echo "  ✗ xilinx/external/nextpnr-xilinx-meta not found!"
        echo "  ℹ This might be because submodules were not initialized"
    fi
    
    # Create symbolic link for prjxray-db
    if [ -d "$INSTALL_DIR/share/prjxray-db" ]; then
        sudo ln -sf "$INSTALL_DIR/share/prjxray-db" \
                    "$INSTALL_DIR/share/nextpnr-xilinx/external/prjxray-db" 2>/dev/null && \
        echo "  ✓ prjxray-db symbolic link created" || \
        echo "  ⚠ Could not create prjxray-db symbolic link"
    else
        echo "  ⚠ prjxray-db not found - install prjxray first!"
    fi
    
    cd "$BUILD_DIR"
    echo -e "${GREEN}nextpnr-xilinx installed!${NC}"
}

# Create environment setup script
create_env_script() {
    echo -e "${YELLOW}Creating environment setup script...${NC}"
    
    sudo tee "$INSTALL_DIR/setup_env.sh" > /dev/null <<'EOF'
#!/bin/bash
# openXC7 Environment Setup Script

OPENXC7_DIR="/opt/openxc7"

# Add bin directory to PATH
export PATH="$OPENXC7_DIR/bin:$PATH"

# Python path for nextpnr
if [ -d "$OPENXC7_DIR/lib/python3"* ]; then
    export PYTHONPATH="$OPENXC7_DIR/lib/$(ls $OPENXC7_DIR/lib | grep python3 | head -n1)/site-packages:$PYTHONPATH"
fi

# NextPNR Python dir
export NEXTPNR_XILINX_PYTHON_DIR="$OPENXC7_DIR/share/nextpnr-xilinx/python"

# prjxray database
export PRJXRAY_DB_DIR="$OPENXC7_DIR/share/prjxray-db"

echo "openXC7 environment configured!"
echo "  OPENXC7_DIR: $OPENXC7_DIR"
echo "  PATH: $PATH"
echo "  PRJXRAY_DB_DIR: $PRJXRAY_DB_DIR"
EOF
    
    sudo chmod +x "$INSTALL_DIR/setup_env.sh"
    
    echo -e "${GREEN}Environment setup script created: $INSTALL_DIR/setup_env.sh${NC}"
    echo ""
    echo -e "${YELLOW}To use the toolchain, run:${NC}"
    echo -e "${GREEN}  source $INSTALL_DIR/setup_env.sh${NC}"
}

# Main function
main() {
    echo -e "${YELLOW}Starting installation...${NC}"
    echo ""
    
    # Ask user what to install
    echo "What would you like to install?"
    echo "1) All components (recommended)"
    echo "2) Dependencies only"
    echo "3) Yosys only"
    echo "4) prjxray only"
    echo "5) nextpnr-xilinx only"
    read -p "Select option (1-5): " choice
    
    case $choice in
        1)
            install_dependencies
            install_yosys
            install_prjxray
            install_nextpnr
            create_env_script
            ;;
        2)
            install_dependencies
            ;;
        3)
            install_yosys
            ;;
        4)
            install_prjxray
            ;;
        5)
            install_nextpnr
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Installation complete!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Load environment: ${GREEN}source $INSTALL_DIR/setup_env.sh${NC}"
    echo "2. Check installation: ${GREEN}yosys --version${NC}"
    echo "3. Check installation: ${GREEN}nextpnr-xilinx --version${NC}"
    echo ""
    echo -e "${YELLOW}For use in your project:${NC}"
    echo "  - Change PREFIX in Makefile to: ${GREEN}$INSTALL_DIR${NC}"
    echo "  - DB_DIR will be: ${GREEN}$INSTALL_DIR/share/prjxray-db${NC}"
    echo ""
    
    # Optional cleanup
    read -p "Would you like to delete the build directory? (y/n): " cleanup_choice
    if [ "$cleanup_choice" = "y" ]; then
        rm -rf "$BUILD_DIR"
        echo -e "${GREEN}Build directory deleted.${NC}"
    fi
}

# Run main function
main
