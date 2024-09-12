# SPDX-FileCopyrightText: 2024 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, FallingEdge
from cocotbext.i2c import I2cDevice
from cocotbext_csi import CSI

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
async def test_0(dut): #I2C Icarus
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
   await FallingEdge(dut.u_i2c.i2c_enable)
   
   # Wait for some time to allow further processing
   await Timer(100, units='us')

async def drive_diff_clock(signal, period_ns):
   """
   Coroutine to drive a differential clock.
   """
   while True:
      signal.value = 0b10
      await Timer(period_ns / 2, units='ns')
      signal.value = 0b01
      await Timer(period_ns / 2, units='ns')

@cocotb.test() #CSI Verilator
async def test_2(dut):
   # Current python model of PLL, will later be replaced with a standalone MMCM
   pllt = fpga_pll.fpga_pll(dut, 'top')
   pllh = fpga_pll.fpga_pll(dut, 'hdmi')

   # Start external clock generation at 100 MHz
   cocotb.start_soon(Clock(dut.clk_ext, 10, units="ns").start())

   # Initialize reset signal
   dut.areset.value = 1
   await Timer(4999, units='ns')
   dut.areset.value = 0

   # Wait for Cam to start
   await RisingEdge(dut.cam_en)
   
   # Start driving the differential clock signal
   diff_clock_period_ns = 2.192
   cocotb.start_soon(drive_diff_clock(dut.cam_dphy_clk, period_ns=diff_clock_period_ns))

   await Timer(8*diff_clock_period_ns, units='ns')

   num_lane = 4
   dinvert = [0, 1] if num_lane == 2 else [0, 1, 0, 1]
    
   csi = CSI(dut, dut.cam_dphy_dat, period_ns=1.096, fps_Hz=60, line_length=1280, frame_length=720, frame_blank=130, num_lane=num_lane, dinvert=dinvert, raw=12, uniform_data=True, start_value=0x01)
    
   # Run the CSI class to send frames
   await csi.run(1)  # Sending 3 frames as an example
   
   await Timer(100, units='us')
