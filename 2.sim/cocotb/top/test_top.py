import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge, Timer, with_timeout
import cocotbext.i2c

import os

import fpga_pll


@cocotb.test()
async def test_0(dut):
    run_sim_us = float(os.environ.get('RUN_SIM_US', 15000))
    run_sim_cycles_100MHz = int(run_sim_us*1000/10)

    # initialize PLL
    pllt = fpga_pll.fpga_pll(dut, 'top')
    pllh = fpga_pll.fpga_pll(dut, 'hdmi')

    # Ext clock generation
    cocotb.start_soon(Clock(dut.clk_ext, 10, units="ns").start())  # 100 MHz clock

    # Initialize signals
    dut.areset.value = 1
    await Timer(3000, units='ns')
    dut.areset.value = 0

    #await ClockCycles(dut.clk_ext, run_sim_cycles_100MHz)
    await Timer(run_sim_us, units='us')
