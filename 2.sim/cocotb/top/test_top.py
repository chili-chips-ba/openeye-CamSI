import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotbext.i2c import I2cDevice

import os
import fpga_pll

class i2c_slave_class:
   def __init__(self, dut):
      self.dut = dut

      # Initialize the I2C slave device
      self.i2c_slave = I2cDevice(
         addr=16, 
         sda=dut.u_i2c.i2c_sda_di, 
         sda_o=dut.u_i2c.i2c_sda_do,
         scl=dut.u_i2c.i2c_scl_di, 
         scl_o=dut.u_i2c.i2c_scl_do
      )

@cocotb.test()
async def test_0(dut):
   # Get simulation runtime from environment variable, default to 15 microseconds
   run_sim_us = float(os.environ.get('RUN_SIM_US', 15))
   run_sim_cycles_100MHz = int(run_sim_us * 1000 / 10)

   # Initialize PLL instances for top and HDMI clocks
   pllt = fpga_pll.fpga_pll(dut, 'top')
   pllh = fpga_pll.fpga_pll(dut, 'hdmi')

   # Start external clock generation at 100 MHz
   cocotb.start_soon(Clock(dut.clk_ext, 10, units="ns").start())

   # Create instance of i2c_slave_class with the DUT
   i2c_slave_tb = i2c_slave_class(dut)

   # Initialize reset signal
   dut.areset.value = 1
   await Timer(5000, units='ns')
   dut.areset.value = 0

   # Wait for the internal reset to be released
   await RisingEdge(dut.u_i2c.areset_n)
   
   # Start the I2C slave coroutine
   cocotb.start_soon(i2c_slave_tb.i2c_slave._run())

   # Wait for I2C register count done signal
   await RisingEdge(dut.u_i2c.i2c_reg_cnt_done)
   
   # Wait for some time to allow further processing
   await Timer(100, units='us')