# openXC7 Build Environment Setup

Installation guide for openXC7 FPGA toolchain with local build from source.

---

## Overview

This guide provides a snap-free installation method for the openXC7 toolchain, building Yosys, nextpnr-xilinx, and prjxray from source. The approach eliminates hardcoded paths and snap dependencies, providing a portable solution across Linux distributions.

**Toolchain Components:**
- **Yosys** (v0.38) - RTL synthesis with Xilinx primitives
- **nextpnr-xilinx** (v0.8.2) - Place and route for Series 7 FPGAs
- **prjxray** - Bitstream generation tools (fasm2frames, xc7frames2bit)
- **prjxray-db** - Device databases for Artix7, Kintex7, Spartan7, Zynq7

**Installation:** `/opt/openxc7`  
**Disk Space:** ~10GB (source + build artifacts + installation)

⚠️ **Important Notes** 

- Do **NOT** run install script as root
- **ALWAYS** source environment before building: `source /opt/openxc7/setup_env.sh`

---

## Quick Installation
**Scripts Location:** All installation scripts are located in `3.build/openXC7/scripts/` directory.
```bash
cd 3.build/openXC7/scripts/

# Install toolchain
chmod +x install_openxc7_local_EN.sh
./install_openxc7_local_EN.sh
# Select: 1 (all components)

# Configure environment
source /opt/openxc7/setup_env.sh

# Verify installation
./test_openxc7_installation_EN.sh

# Fix any missing files (recommended)
./post_install_fix_EN.sh
```

For persistent environment setup:
```bash
echo 'source /opt/openxc7/setup_env.sh' >> ~/.bashrc
```

---

## System Requirements

**Supported Platforms**
- Ubuntu 20.04 LTS or newer  
- Fedora 38 or newer  
- Arch Linux (rolling)  
- Debian 11 or newer  
- RHEL/CentOS 8 or newer  

> **Disclaimer:** While multiple Linux distributions are listed as supported, this project has been **tested only on Ubuntu**, specifically on **Ubuntu 22.04.5 LTS**.

**Privileges:** sudo access required for installation to `/opt/openxc7`

---

## Installation Process

### Automated Installation

The installer performs the following steps:

1. **Dependency Resolution**
   - Auto-detects distribution (Ubuntu/Fedora/Arch)
   - Installs required build tools and libraries

2. **Source Download**
   - Clones repositories from GitHub
   - Initializes git submodules recursively

3. **Component Build**
   - Yosys: Synthesis tool compilation
   - prjxray: Bitstream utilities
   - nextpnr-xilinx: Place and route engine

4. **Post-Build Setup**
   - Copies Python scripts and chip metadata
   - Creates symbolic links for database access
   - Generates environment configuration script

### Manual Component Installation

Install individual components:

```bash
./install_openxc7_local_EN.sh
# Options:
# 2) Dependencies only
# 3) Yosys only
# 4) prjxray only  
# 5) nextpnr-xilinx only
```

### Post-Installation Fix

If installation completes but files are missing, run the post-install fix script which copies all necessary files from the build directory:

```bash
./post_install_fix_EN.sh
```

This addresses edge cases where `make install` doesn't copy:
- Python scripts (`bbaexport.py`, etc.)
- Constraint files (`constids.inc`)
- Chip metadata (`nextpnr-xilinx-meta`)

---

## Project Configuration
### Build Workflow

```bash
source /opt/openxc7/setup_env.sh
cd /your/project # in this case: openeye-CamSI/3.build/openXC7
# cd openeye-CamSI/3.build/openXC7

# Full build
make all

```

### Chipdb Generation

The chip database is generated once per FPGA part on first build:

```makefile
make chipdb/xc7a100tcsg324-2.bin
```

**Process:**
1. `bbaexport.py` extracts device data from prjxray-db
2. `bbasm` compiles into binary database format
3. nextpnr-xilinx uses this for place and route

**Note:** Regenerate chipdb after updating nextpnr-xilinx:
```bash
rm -rf chipdb && make chipdb/your-part.bin
```

---

## FPGA Programming

### Linux - openFPGALoader

Installation:
```bash
sudo apt-get install libftdi1-2 libftdi1-dev libhidapi-hidraw0 \
    libhidapi-dev libudev-dev zlib1g-dev cmake pkg-config make g++

git clone https://github.com/trabucayre/openFPGALoader
cd openFPGALoader && mkdir build && cd build
cmake ../ && cmake --build .
sudo make install
```

Programming:
```bash
openFPGALoader -b arty your_design.bit
# or via Makefile
make program
```

### Windows - Digilent Adept

Download: [Digilent Adept](https://digilent.com/shop/software/digilent-adept/)

---

## Troubleshooting

### Missing bbaexport.py

**Symptom:**
```
python3: can't open file '.../bbaexport.py': No such file or directory
```

**Solution:**
```bash
./post_install_fix_EN.sh
source /opt/openxc7/setup_env.sh
```

### Chipdb Incompatibility

**Symptom:**
```
nextpnr assertion failure: internal IDs inconsistent with chip database
```

**Solution:**
```bash
rm -rf chipdb
make chipdb/xc7a100tcsg324-2.bin
```

### Missing Metadata

**Symptom:**
```
FileNotFoundError: '.../nextpnr-xilinx-meta/artix7/wire_intents.json'
```

**Solution:**
```bash
./post_install_fix_EN.sh
```

### Build Performance

Utilize all CPU cores:
```bash
export MAKEFLAGS="-j$(nproc)"
make all
```

---

## Verification

Test suite validates:
- Tool availability and versions
- Environment configuration
- File structure integrity
- Python module imports
- Basic synthesis functionality

```bash
./test_openxc7_installation_EN.sh
```

Expected result: All tests pass with no failures.

---

## Uninstallation

```bash
./cleanup_openxc7_EN.sh
```

Removes:
- `/opt/openxc7` installation
- `/tmp/openxc7_build` build artifacts
- Shell configuration entries

---

## Supported Devices

**Artix-7:** xc7a{12t,15t,25t,35t,50t,75t,100t,200t}  
**Kintex-7:** xc7k{70t,160t,325t,410t,420t,480t}  
**Spartan-7:** xc7s{6,15,25,50,75,100}  
**Zynq-7:** xc7z{007s,010,012s,014s,015,020,030,035,045,100}

---

## Additional Resources

- [openXC7 GitHub Organization](https://github.com/openXC7)
- [Yosys Documentation](https://yosyshq.readthedocs.io/)
- [nextpnr Documentation](https://github.com/YosysHQ/nextpnr)
- [prjxray Project](https://github.com/f4pga/prjxray)

**Project Issues:** [openeye-CamSI openXC7 Issues](https://github.com/chili-chips-ba/openeye-CamSI/issues?q=is%3Aissue%20label%3AopenXC7)

---

## License

Installation scripts: Free to use  
Toolchain components: ISC License (Yosys, nextpnr, prjxray)

---

**Maintained by:** [Chili Chips](https://github.com/chili-chips-ba)  
**Version:** 2.0  
**Last Updated:** November 2025
