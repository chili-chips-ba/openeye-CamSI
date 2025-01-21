# SPDX-FileCopyrightText: 2024 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, FallingEdge
from cocotbext.i2c import I2cDevice
from cocotbext_csi import CSI

import fpga_pll

class i2c_slave_class:
   def __init__(self, dut):
      self.dut = dut

      # Initialize the I2C slave device
      self.i2c_slave = I2cDevice(
         addr=26, 
         sda=dut.u_i2c.i2c_sda_oe, 
         sda_o=dut.u_i2c.i2c_sda_di,
         scl=dut.u_i2c.i2c_scl_oe,
         scl_o=dut.u_i2c.i2c_scl_di
      )

@cocotb.test()
async def test_0(dut): #I2C Icarus
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
async def test_1(dut):
   # Current python model of PLL, will later be replaced with a standalone MMCM
   pllt = fpga_pll.fpga_pll(dut, 'top')
   pllh = fpga_pll.fpga_pll(dut, 'hdmi')
   pllc = fpga_pll.fpga_pll(dut, 'csi_rx')

   # Start external clock generation at 100 MHz
   cocotb.start_soon(Clock(dut.clk_ext, 10, units="ns").start())

   # Initialize reset signal
   dut.areset.value = 1
   await Timer(4999, units='ns')
   dut.areset.value = 0

   # Wait for Cam to start
   await RisingEdge(dut.cam_en)
   
   # Configuration parameters based on num_lane
   num_lane = 2  # Change this to 4 for the other configuration

   if num_lane == 4:
      diff_clock_period_ns = 1.388
      raw = 12
      dinvert = [0, 0, 0, 1]
      resolution_width = 1920
      resolution_height = 1080
   elif num_lane == 2:
      diff_clock_period_ns = 2.190
      raw = 8
      dinvert = [0, 1]
      resolution_width = 1280
      resolution_height = 720
   else:
      raise ValueError(f"Unsupported num_lane configuration: {num_lane}")

   # Start driving the differential clock signal
   cocotb.start_soon(drive_diff_clock(dut.cam_dphy_clk, period_ns=diff_clock_period_ns))

   await Timer(8 * diff_clock_period_ns, units='ns')

   # Initialize CSI object with the determined configuration
   csi = CSI(
      dut,
      dut.cam_dphy_dat,
      period_ns=diff_clock_period_ns / 2,
      fps_Hz=60,
      line_length=resolution_width,
      frame_length=resolution_height,
      frame_blank=130,
      num_lane=num_lane,
      dinvert=dinvert,
      raw=raw,
      uniform_data=False,
      start_value=0x01
   )

   # Run the CSI class to send frames
   await csi.run(1)  # Sending 1 frame as an example

   await Timer(100, units='us')
