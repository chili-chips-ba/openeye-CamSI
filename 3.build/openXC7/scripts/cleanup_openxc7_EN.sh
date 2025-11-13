#!/bin/bash

# Script for complete cleanup of openXC7 local installation

echo "========================================"
echo "openXC7 Installation Cleanup"
echo "========================================"
echo ""

# Warning
echo "⚠️  WARNING: This script will delete:"
echo "   - /opt/openxc7 (installation)"
echo "   - /tmp/openxc7_build (build files)"
echo "   - Environment setup from ~/.bashrc"
echo ""
read -p "Do you want to continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Cleanup in progress..."
echo ""

# 1. Delete installation
echo "1. Deleting /opt/openxc7..."
if [ -d /opt/openxc7 ]; then
    sudo rm -rf /opt/openxc7
    echo "   ✓ /opt/openxc7 deleted"
else
    echo "   - /opt/openxc7 does not exist"
fi

# 2. Delete build directory
echo "2. Deleting /tmp/openxc7_build..."
if [ -d /tmp/openxc7_build ]; then
    rm -rf /tmp/openxc7_build
    echo "   ✓ /tmp/openxc7_build deleted"
else
    echo "   - /tmp/openxc7_build does not exist"
fi

# 3. Remove from ~/.bashrc
echo "3. Removing from ~/.bashrc..."
if grep -q "openxc7" ~/.bashrc; then
    sed -i.backup '/openxc7/d' ~/.bashrc
    echo "   ✓ Removed from ~/.bashrc (backup: ~/.bashrc.backup)"
else
    echo "   - No openxc7 references in ~/.bashrc"
fi

# 4. Remove from ~/.zshrc (if it exists)
if [ -f ~/.zshrc ]; then
    echo "4. Removing from ~/.zshrc..."
    if grep -q "openxc7" ~/.zshrc; then
        sed -i.backup '/openxc7/d' ~/.zshrc
        echo "   ✓ Removed from ~/.zshrc (backup: ~/.zshrc.backup)"
    else
        echo "   - No openxc7 references in ~/.zshrc"
    fi
fi

# 5. Verification
echo ""
echo "5. Verifying cleanup..."

# Check installation directory
if [ -d /opt/openxc7 ]; then
    echo "   ✗ /opt/openxc7 STILL EXISTS!"
else
    echo "   ✓ /opt/openxc7 does not exist"
fi

# Check build directory
if [ -d /tmp/openxc7_build ]; then
    echo "   ✗ /tmp/openxc7_build STILL EXISTS!"
else
    echo "   ✓ /tmp/openxc7_build does not exist"
fi

# Check environment variables (only if currently loaded)
if [ -n "$PRJXRAY_DB_DIR" ]; then
    echo "   ⚠ Environment variables are still loaded in this session"
    echo "     Close terminal and open a new one to clear them"
else
    echo "   ✓ Environment variables are not loaded"
fi

# 6. Check PATH
echo ""
echo "6. Checking tools..."
YOSYS_PATH=$(which yosys 2>/dev/null || echo "not found")
NEXTPNR_PATH=$(which nextpnr-xilinx 2>/dev/null || echo "not found")

if [[ "$YOSYS_PATH" == *"opt/openxc7"* ]]; then
    echo "   ⚠ yosys still points to /opt/openxc7"
    echo "     Close terminal and open a new one"
elif [[ "$YOSYS_PATH" == *"snap"* ]]; then
    echo "   ℹ yosys points to snap version: $YOSYS_PATH"
else
    echo "   ✓ yosys: $YOSYS_PATH"
fi

if [[ "$NEXTPNR_PATH" == *"opt/openxc7"* ]]; then
    echo "   ⚠ nextpnr-xilinx still points to /opt/openxc7"
    echo "     Close terminal and open a new one"
elif [[ "$NEXTPNR_PATH" == *"snap"* ]]; then
    echo "   ℹ nextpnr-xilinx points to snap version: $NEXTPNR_PATH"
else
    echo "   ✓ nextpnr-xilinx: $NEXTPNR_PATH"
fi

echo ""
echo "========================================"
echo "Cleanup complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Close this terminal"
echo "2. Open a new terminal"
echo "3. Run: ./install_openxc7_local.sh"
echo ""
