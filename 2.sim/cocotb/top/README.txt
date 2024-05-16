- Verilog sources: Makefile reads source file list ${HW_SRC}/top.filelist

- Testbench (clocks, resets, transactors, BFM, checkers, etc): test_top.py

- Makefile variables:
-- WAVES=1|0 controls if simulation generates a waverform or not (default = off)
-- SIM=verilator|icarus controls which simulator is used (default = Verilator)
-- RUN_SIM_US=<time> Sim runtime in us (default = 15000)

- Run simulation with Verilator: make [SIM=verilator] [WAVES=1|0] [RUN_SIM_US=<time>]
-- Waveform: dump.fst

- Run simulation with Icarus: make SIM=icarus [WAVES=1|0] [RUN_SIM_US=<time>]
-- Waveform: sim_build/top.fst

- BFMs
-- I2C 
--- https://github.com/alexforencich/cocotbext-i2c/blob/master/README.md
--- Not available in PyPI, must install from git!
--- pip install https://github.com/alexforencich/cocotbext-i2c/archive/master.zip
