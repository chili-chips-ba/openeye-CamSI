#!/bin/bash

# Test script for openXC7 local installation
# Checks if all tools are installed and functional

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

INSTALL_DIR="/opt/openxc7"
PASSED=0
FAILED=0

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}openXC7 Installation Test${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function for testing commands
test_command() {
    local cmd=$1
    local desc=$2
    
    echo -ne "Testing $desc... "
    
    if command -v $cmd &> /dev/null; then
        echo -e "${GREEN}PASS${NC}"
        ((PASSED++))
        
        # Show version if available
        if [[ "$cmd" == "yosys" || "$cmd" == "nextpnr-xilinx" ]]; then
            local version=$($cmd --version 2>&1 | head -n1)
            echo -e "  ${BLUE}→${NC} $version"
        fi
    else
        echo -e "${RED}FAIL${NC}"
        echo -e "  ${RED}→${NC} Command not found: $cmd"
        ((FAILED++))
    fi
}

# Function for testing files
test_file() {
    local file=$1
    local desc=$2
    
    echo -ne "Testing $desc... "
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}PASS${NC}"
        ((PASSED++))
    elif [ -d "$file" ]; then
        echo -e "${GREEN}PASS${NC} (directory)"
        ((PASSED++))
    else
        echo -e "${RED}FAIL${NC}"
        echo -e "  ${RED}→${NC} Not found: $file"
        ((FAILED++))
    fi
}

# Function for testing environment variables
test_env_var() {
    local var=$1
    local desc=$2
    
    echo -ne "Testing $desc... "
    
    if [ ! -z "${!var}" ]; then
        echo -e "${GREEN}PASS${NC}"
        echo -e "  ${BLUE}→${NC} ${!var}"
        ((PASSED++))
    else
        echo -e "${YELLOW}WARN${NC}"
        echo -e "  ${YELLOW}→${NC} Variable not set: $var"
        echo -e "  ${YELLOW}→${NC} Did you run: source $INSTALL_DIR/setup_env.sh ?"
        ((FAILED++))
    fi
}

echo -e "${YELLOW}=== Environment Variables ===${NC}"
test_env_var "PRJXRAY_DB_DIR" "PRJXRAY_DB_DIR"
test_env_var "NEXTPNR_XILINX_PYTHON_DIR" "NEXTPNR_XILINX_PYTHON_DIR"
test_env_var "PYTHONPATH" "PYTHONPATH"
echo ""

echo -e "${YELLOW}=== Core Tools ===${NC}"
test_command "yosys" "Yosys (synthesis)"
test_command "nextpnr-xilinx" "nextpnr-xilinx (place & route)"
test_command "fasm2frames" "fasm2frames"
test_command "xc7frames2bit" "xc7frames2bit"
test_command "bbasm" "bbasm (chipdb assembler)"
test_command "bit2fasm" "bit2fasm"
echo ""

echo -e "${YELLOW}=== Python Tools ===${NC}"
test_command "python3" "Python3"
echo ""

echo -e "${YELLOW}=== Installation Structure ===${NC}"
test_file "$INSTALL_DIR" "Installation directory"
test_file "$INSTALL_DIR/bin" "Binary directory"
test_file "$INSTALL_DIR/share" "Share directory"
test_file "$INSTALL_DIR/share/prjxray-db" "prjxray-db"
test_file "$INSTALL_DIR/share/prjxray-db/artix7" "Artix7 database"
test_file "$INSTALL_DIR/share/nextpnr-xilinx" "nextpnr-xilinx data"
test_file "$INSTALL_DIR/share/nextpnr-xilinx/python/bbaexport.py" "bbaexport.py script"
test_file "$INSTALL_DIR/setup_env.sh" "Environment setup script"
echo ""

echo -e "${YELLOW}=== Advanced Tests ===${NC}"

# Test Yosys functionality
echo -ne "Testing Yosys synthesis... "
if command -v yosys &> /dev/null; then
    TMPDIR=$(mktemp -d)
    cat > "$TMPDIR/test.v" <<'EOF'
module test(input clk, input rst, output reg out);
always @(posedge clk or posedge rst)
    if (rst) out <= 0;
    else out <= ~out;
endmodule
EOF
    
    if yosys -q -p "read_verilog $TMPDIR/test.v; synth_xilinx -top test" > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        ((PASSED++))
    else
        echo -e "${RED}FAIL${NC}"
        echo -e "  ${RED}→${NC} Yosys synthesis failed"
        ((FAILED++))
    fi
    rm -rf "$TMPDIR"
else
    echo -e "${YELLOW}SKIP${NC} (yosys not found)"
fi

# Test Python bbaexport script
echo -ne "Testing bbaexport.py import... "
if [ -f "$INSTALL_DIR/share/nextpnr-xilinx/python/bbaexport.py" ]; then
    if python3 -c "import sys; sys.path.insert(0, '$INSTALL_DIR/share/nextpnr-xilinx/python'); import bbaexport" 2>/dev/null; then
        echo -e "${GREEN}PASS${NC}"
        ((PASSED++))
    else
        echo -e "${RED}FAIL${NC}"
        echo -e "  ${RED}→${NC} Cannot import bbaexport module"
        ((FAILED++))
    fi
else
    echo -e "${YELLOW}SKIP${NC} (bbaexport.py not found)"
fi

# Test prjxray-db structure
echo -ne "Testing prjxray-db structure... "
if [ -d "$INSTALL_DIR/share/prjxray-db/artix7" ]; then
    # Check if part files exist
    PART_COUNT=$(find "$INSTALL_DIR/share/prjxray-db/artix7" -name "part.yaml" | wc -l)
    if [ $PART_COUNT -gt 0 ]; then
        echo -e "${GREEN}PASS${NC} ($PART_COUNT parts found)"
        ((PASSED++))
    else
        echo -e "${RED}FAIL${NC}"
        echo -e "  ${RED}→${NC} No part.yaml files found"
        ((FAILED++))
    fi
else
    echo -e "${RED}FAIL${NC}"
    echo -e "  ${RED}→${NC} Artix7 database not found"
    ((FAILED++))
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Test Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo -e "${GREEN}Your openXC7 installation is working correctly.${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Go to your project directory"
    echo "2. Copy Makefile.openxc7 to your project"
    echo "3. Run: make all"
    exit 0
else
    echo -e "${RED}✗ Some tests failed!${NC}"
    echo ""
    echo -e "${YELLOW}Troubleshooting:${NC}"
    
    if [ -z "$PRJXRAY_DB_DIR" ]; then
        echo "• Environment not loaded. Run:"
        echo "  source $INSTALL_DIR/setup_env.sh"
    fi
    
    if ! command -v yosys &> /dev/null; then
        echo "• Core tools missing. Run:"
        echo "  ./install_openxc7_local.sh"
        echo "  Choose option 1 (Install all)"
    fi
    
    if [ ! -d "$INSTALL_DIR" ]; then
        echo "• Installation directory not found. Run:"
        echo "  ./install_openxc7_local.sh"
    fi
    
    exit 1
fi
