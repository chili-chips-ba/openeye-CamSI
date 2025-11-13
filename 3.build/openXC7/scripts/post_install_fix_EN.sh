#!/bin/bash

# Post-install fix script for openXC7
# Copies missing files from build directory to installation

set -e

BUILD_DIR="/tmp/openxc7_build/nextpnr-xilinx"
INSTALL_DIR="/opt/openxc7"

echo "========================================"
echo "openXC7 Post-Install Fix"
echo "========================================"
echo ""

if [ ! -d "$BUILD_DIR" ]; then
    echo "ERROR: Build directory not found: $BUILD_DIR"
    echo "Cannot perform post-install fix."
    exit 1
fi

if [ ! -d "$INSTALL_DIR" ]; then
    echo "ERROR: Installation directory not found: $INSTALL_DIR"
    echo "Please run install_openxc7_local.sh first."
    exit 1
fi

echo "Copying missing files from build to installation..."
echo ""

# Create directories
sudo mkdir -p "$INSTALL_DIR/share/nextpnr-xilinx/python"
sudo mkdir -p "$INSTALL_DIR/share/nextpnr-xilinx/external"

# 1. Python files
echo "1. Copying Python files..."
if [ -d "$BUILD_DIR/xilinx/python" ]; then
    sudo cp "$BUILD_DIR/xilinx/python/"*.py "$INSTALL_DIR/share/nextpnr-xilinx/python/" 2>/dev/null && \
    echo "   ✓ Python files copied ($(ls $BUILD_DIR/xilinx/python/*.py | wc -l) files)" || \
    echo "   ✗ Failed to copy Python files"
else
    echo "   ✗ Source directory not found: $BUILD_DIR/xilinx/python"
fi

# 2. constids.inc (to BOTH locations)
echo "2. Copying constids.inc..."
if [ -f "$BUILD_DIR/xilinx/constids.inc" ]; then
    # To python directory
    sudo cp "$BUILD_DIR/xilinx/constids.inc" "$INSTALL_DIR/share/nextpnr-xilinx/python/" 2>/dev/null
    # To parent directory
    sudo cp "$BUILD_DIR/xilinx/constids.inc" "$INSTALL_DIR/share/nextpnr-xilinx/" 2>/dev/null
    echo "   ✓ constids.inc copied to both locations"
else
    echo "   ✗ Source file not found: $BUILD_DIR/xilinx/constids.inc"
fi

# 3. nextpnr-xilinx-meta
echo "3. Copying nextpnr-xilinx-meta..."
if [ -d "$BUILD_DIR/xilinx/external/nextpnr-xilinx-meta" ]; then
    sudo cp -r "$BUILD_DIR/xilinx/external/nextpnr-xilinx-meta" \
               "$INSTALL_DIR/share/nextpnr-xilinx/external/" 2>/dev/null && \
    echo "   ✓ nextpnr-xilinx-meta copied" || \
    echo "   ✗ Failed to copy nextpnr-xilinx-meta"
else
    echo "   ✗ Source directory not found: $BUILD_DIR/xilinx/external/nextpnr-xilinx-meta"
fi

# 4. prjxray-db symbolic link
echo "4. Creating prjxray-db symbolic link..."
if [ -d "$INSTALL_DIR/share/prjxray-db" ]; then
    sudo ln -sf "$INSTALL_DIR/share/prjxray-db" \
                "$INSTALL_DIR/share/nextpnr-xilinx/external/prjxray-db" 2>/dev/null && \
    echo "   ✓ Symbolic link created" || \
    echo "   ⚠ Symbolic link already exists or failed to create"
else
    echo "   ✗ prjxray-db not found in $INSTALL_DIR/share/"
fi

echo ""
echo "========================================"
echo "Verification"
echo "========================================"

# Verify files
echo "Checking copied files..."
echo ""

echo "Python files:"
if [ -f "$INSTALL_DIR/share/nextpnr-xilinx/python/bbaexport.py" ]; then
    FILE_COUNT=$(ls "$INSTALL_DIR/share/nextpnr-xilinx/python/"*.py 2>/dev/null | wc -l)
    echo "  ✓ Found $FILE_COUNT Python files"
else
    echo "  ✗ bbaexport.py NOT FOUND"
fi

echo "constids.inc:"
if [ -f "$INSTALL_DIR/share/nextpnr-xilinx/python/constids.inc" ]; then
    echo "  ✓ Found in python/"
else
    echo "  ✗ NOT FOUND in python/"
fi

if [ -f "$INSTALL_DIR/share/nextpnr-xilinx/constids.inc" ]; then
    echo "  ✓ Found in parent directory"
else
    echo "  ✗ NOT FOUND in parent directory"
fi

echo "nextpnr-xilinx-meta:"
if [ -d "$INSTALL_DIR/share/nextpnr-xilinx/external/nextpnr-xilinx-meta" ]; then
    echo "  ✓ Found"
else
    echo "  ✗ NOT FOUND"
fi

echo "prjxray-db link:"
if [ -L "$INSTALL_DIR/share/nextpnr-xilinx/external/prjxray-db" ]; then
    TARGET=$(readlink -f "$INSTALL_DIR/share/nextpnr-xilinx/external/prjxray-db")
    echo "  ✓ Symbolic link exists → $TARGET"
else
    echo "  ✗ Symbolic link NOT FOUND"
fi

echo ""
echo "========================================"
echo "Post-Install Fix Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Load environment: source /opt/openxc7/setup_env.sh"
echo "2. Test: ./test_openxc7_installation.sh"
echo "3. Build your project: make all"
echo ""
