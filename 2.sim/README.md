# Simulation README

This document provides detailed instructions for running the simulation, including testbench setup, supported configurations, and waveform generation. Additionally, links to relevant resources and tools are included.

---

## Simulation Overview

### Verilog Sources
- The Makefile reads the source file list from `${HW_SRC}/top.filelist` to locate and compile all required Verilog source files.

### Testbench
- Python testbench file: `test_top.py`
  - Includes clocks, resets, transactors, BFMs (Bus Functional Models), and checkers.

---

## Makefile Variables

### Key Variables
- **WAVES**:
  - `1` to enable waveform generation.
  - `0` to disable waveform generation (default: off).
- **SIM**:
  - Selects the simulator: `verilator` (default) or `icarus`.
- **RUN_SIM_US**:
  - Defines the simulation runtime in microseconds (default: `15000`).
- **TESTCASE**:
  - Specifies the test case to run: `test_0` or `test_1` (more tests may be added in the future).

---

## Running the Simulation

Simulations must be run from the directory `openeye/2.sim/cocotb/top`. Navigate to this folder and execute the `make` command with the desired options.

### With Verilator
To run the simulation using Verilator:
```bash
make [SIM=verilator] [WAVES=1|0] [RUN_SIM_US=<time>] [TESTCASE=test_0|test_1]
```
- **Waveform Output**: `dump.fst`

### With Icarus
To run the simulation using Icarus:
```bash
make SIM=icarus [WAVES=1|0] [RUN_SIM_US=<time>] [TESTCASE=test_0|test_1]
```
- **Waveform Output**: `sim_build/top.fst`

### With Verilator
To run the simulation using Verilator:
```bash
make [SIM=verilator] [WAVES=1|0] [RUN_SIM_US=<time>] [TESTCASE=test_0|test_1]
```
- **Waveform Output**: `dump.fst`

### With Icarus
To run the simulation using Icarus:
```bash
make SIM=icarus [WAVES=1|0] [RUN_SIM_US=<time>] [TESTCASE=test_0|test_1]
```
- **Waveform Output**: `sim_build/top.fst`

---

## BFMs (Bus Functional Models)

### Related Issues
- Discussions about I2C simulation can be found in the following GitHub issues:
  - [Issue #12](https://github.com/chili-chips-ba/openeye-CamSI/issues/12)
  - [Issue #14](https://github.com/chili-chips-ba/openeye-CamSI/issues/14)

### I2C BFM
- Repository: [cocotbext-i2c](https://github.com/alexforencich/cocotbext-i2c)
- Important Notes:
  - Not available via PyPI.
  - Must be installed directly from the GitHub repository:
    ```bash
    pip install https://github.com/alexforencich/cocotbext-i2c/archive/master.zip
    ```

---

## Results and Examples

### Testcase Results

#### **Testcase `test_0`**:
- **Purpose**: Basic initialization and functionality test of the I2C interface.
- **Description**:
  - Validates I2C operations using the Icarus simulator.
  - Ensures compatibility of the I2C slave device address with `top_pkg.sv`.
  - Uses basic reset and clock signals to initialize components and verify I2C transactions.

#### **Testcase `test_1`**:
- **Purpose**: Simulates a camera interface with configurable parameters using the Verilator simulator.
- **Description**:
  - Implements a CSI (Camera Serial Interface) model defined in [`cocotbext_csi.py`](https://github.com/chili-chips-ba/openeye-CamSI/blob/main/2.sim/cocotb/top/cocotbext_csi.py).
  - Further details and discussions about this test can be found in [Issue #19](https://github.com/chili-chips-ba/openeye-CamSI/issues/19).
  - Supports multiple lane configurations (`num_lane`), RAW data bit depths (`raw`), and resolutions (`line_length`, `frame_length`).
  - Dynamically generates a differential clock signal and feeds it into the simulation.
  - Frames are sent using the CSI class to replicate camera data streams, testing system behavior with realistic inputs.
- **Purpose**: Simulates a camera interface with configurable parameters using the Verilator simulator.
- **Description**:
  - Implements a CSI (Camera Serial Interface) model defined in [`cocotbext_csi.py`](https://github.com/chili-chips-ba/openeye-CamSI/blob/main/2.sim/cocotb/top/cocotbext_csi.py).
  - Supports multiple lane configurations (`num_lane`), RAW data bit depths (`raw`), and resolutions (`line_length`, `frame_length`).
  - Dynamically generates a differential clock signal and feeds it into the simulation.
  - Frames are sent using the CSI class to replicate camera data streams, testing system behavior with realistic inputs.
- **Key Parameters**:
  - `num_lane`: Number of data lanes (e.g., 2 or 4).
  - `raw`: Bit depth of pixel data (e.g., 8, 12).
  - `line_length` and `frame_length`: Define the resolution of the simulated frames (e.g., 1280x720 or 1920x1080).
  - `fps_Hz`: Frames per second (e.g., 60 Hz).

---

### Simulation Artifacts
- **GTKWave Setup**:
  - For reading signals with GTKWave, several pre-saved setup files (`.gtkw`) are available for signals of interest.
  - Files start with `csi-2`, such as `csi-2-raw2rgb-fifo-hdmi.gtkw` and others, which are tailored for different aspects of the CSI simulation.
- Waveform files:
  - Verilator: `dump.fst`
  - Screenshots: Insert example waveform screenshots here.
- **GTKWave Setup**:
  - For reading signals with GTKWave, a pre-saved setup file (`i2c.gtkw`) is available to load signals of interest for the I2C simulation.
- Waveform files:
  - Verilator: `dump.fst`
  - Icarus: `sim_build/top.fst`
- Screenshots: Insert example waveform screenshots here.

### Performance
Simulation runtime and performance may vary based on the simulator and configurations used.

---

## Future Improvements
- Adding more test cases for comprehensive validation.
- Integration of additional BFMs for protocols beyond I2C.
- Expanding waveform analysis to include automated signal checks.

---

For any issues or further inquiries, please consult the source code documentation or contact the development team.

