This is a brief description of our cocoTB sim setup, with instructions on how to run it, set it up in different configuration, and view the waveforms. Additionally, links to relevant resources, tools and issues are included.

---

## Sim Overview

### Verilog Sources
- The Makefile reads the source file list from `${HW_SRC}/top.filelist` to locate and compile all required Verilog source files.

### Testbench
- Python testbench file: `test_top.py`
  - Includes clocks, resets, transactors, BFMs (Bus Functional Models), and checkers.

### Key Makefile Variables

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

---

## BFMs (Bus Functional Models)

### I2C BFM
- Repository: [cocotbext-i2c](https://github.com/alexforencich/cocotbext-i2c)
- Important Notes:
  - Not available via PyPI.
  - Must be installed directly from the GitHub repository:
    ```bash
    pip install https://github.com/alexforencich/cocotbext-i2c/archive/master.zip
    ```
### Related Issues
- Discussions about I2C simulation can be found in the following GitHub issues:
  - [Issue #12](https://github.com/chili-chips-ba/openeye-CamSI/issues/12)
  - [Issue #14](https://github.com/chili-chips-ba/openeye-CamSI/issues/14)

---
## Testcases

### `test_0 - I2C`

- **Purpose**: Basic initialization and functionality test of the I2C interface.
  
- **Description**:
  - Validates I2C operations using the Icarus simulator.
  - Ensures compatibility of the I2C slave device address with `top_pkg.sv`.
  - Uses basic reset and clock signals to initialize components and verify I2C transactions.

- **Waves**:
  - A pre-saved setup file `i2c.gtkw` is available to load signals of interest for the I2C simulation.
  ![image](https://github.com/user-attachments/assets/0be99641-83e6-4fe7-81b0-b95b1fe30103)

---

### `test_1 - CSI`

- **Purpose**: Simulates a Camera Serial Interface (CSI) with configurable parameters using the Verilator simulator.

- **Description**:
  - Implements a CSI model defined in [`cocotbext_csi.py`](https://github.com/chili-chips-ba/openeye-CamSI/blob/main/2.sim/cocotb/top/cocotbext_csi.py).
  - Dynamically generates a differential clock signal and feeds it into the simulation.
  - Frames are sent using the CSI class to replicate camera data streams, testing system behavior with realistic inputs.
  - Supports the following Key Parameters:
     - `num_lane`: Number of data lanes (e.g., 2 or 4).
     - `raw`: Bit depth of pixel data (e.g., 8, 12).
     - `line_length` and `frame_length`: Define the resolution of the simulated frames (e.g., 1280x720 or 1920x1080).
     - `fps_Hz`: Frames per second (e.g., 60 Hz).
  - Further details and discussions about this test can be found in [Issue #19](https://github.com/chili-chips-ba/openeye-CamSI/issues/19).
    
- **Waves**:
  - For displaying signals with GTKWave, several pre-saved setup files (`.gtkw`) are available.
  - Files start with `csi-2`, such as `csi-2-raw2rgb-fifo-hdmi.gtkw` and others, which are tailored for different aspects of the CSI simulation.
![image](https://github.com/user-attachments/assets/6c9a0550-f813-497e-a549-d8e029ce2905)
![image](https://github.com/user-attachments/assets/c0711eeb-5564-469e-994e-f13cfba606f8)

### Performance
Simulation runtime and performance will vary based on the simulator and configurations used. The provided results include first 5 lines of a single frame, as the execution is slow. Simulation of a complete frame would take close to 2 hours.

---

## Future Improvements
- Adding more test cases for comprehensive validation.
- Expanding waveform analysis to include automated signal checks.

---

For any issues or further inquiries, please consult the source code documentation or reach out to the development team.

