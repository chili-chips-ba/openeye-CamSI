- Verilog sources: Makefile reads source file list ${HW_SRC}/top.filelist
- Testbench (clocks, resets, transactors, BFM, checkers, etc): test_top.py

- Makefile variables:
-- WAVES=1|0 controls if simulation generates a waverform or not (default = off)
-- SIM=verilator|icarus controls which simulator is used (default = Verilator)

- Run simulation with Verilator: make [SIM=verilator] [WAVES=1|0]
-- Waveform: dump.fst

- Run simulation with Icarus: make SIM=icarus [WAVES=1|0]
-- Waveform: sim_build/top.fst
