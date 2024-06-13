import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, FallingEdge
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

async def send_byte_on_lane(signal, lane, byte, period_ns):
   """
   Coroutine to send a specific byte on a given differential lane.
   """
   for bit in range(8):
      bit_value = (byte >> bit) & 0x1
      # Positive bit is at (lane*2 + 1), negative bit is at (lane*2)
      signal[lane*2 + 1].value = bit_value  # Positive bit
      signal[lane*2].value = ~bit_value & 0x1  # Negative bit (inverse)
      await Timer(period_ns, units='ns')

async def send_data_pattern(signal, lane, data_pattern, period_ns, duration_ns):
   """
   Coroutine to send a specific data pattern on a given lane for a specified duration.
   """
   start_time = cocotb.utils.get_sim_time(units='ns')
   while cocotb.utils.get_sim_time(units='ns') - start_time < duration_ns:
      await send_byte_on_lane(signal, lane, data_pattern, period_ns)

async def send_sequence(signal, num_lanes, period_ns, sequence):
   """
   Coroutine to send a sequence of data patterns for specified durations on multiple lanes.
   Each element in the sequence is a tuple (data_pattern, duration_ns).
   """
   for data_pattern, duration_ns in sequence:
      for lane in range(num_lanes):
         cocotb.start_soon(send_data_pattern(signal, lane, data_pattern[lane], period_ns, duration_ns))
      await Timer(duration_ns, units='ns')

@cocotb.test()
async def test_1(dut):
   # Current python model of PLL, will later be replaced with a standalone MMCM
   pllt = fpga_pll.fpga_pll(dut, 'top')
   pllh = fpga_pll.fpga_pll(dut, 'hdmi')

   # Start external clock generation at 100 MHz
   cocotb.start_soon(Clock(dut.clk_ext, 10, units="ns").start())

   # Initialize reset signal
   dut.areset.value = 1
   await Timer(5000, units='ns')
   dut.areset.value = 0

   # Wait for Cam to start
   await RisingEdge(dut.cam_en)
   
   # Start driving the differential clock signal
   diff_clock_period_ns = 5
   cocotb.start_soon(drive_diff_clock(dut.cam_dphy_clk, period_ns=diff_clock_period_ns))

   await Timer(diff_clock_period_ns, units='ns')

   # Define the sequence of data patterns and durations
   sequence = [
      ([0b00000000, 0b11111111], 40), # Some random data at the start
      ([0b10111000, 0b01000111], 20), # Sync bytes b8b8
      ([0b00010010, 0b11101101], 20)  # Start of long packet
   ]

   # Start driving the differential lane signals with the sequence of patterns
   cocotb.start_soon(send_sequence(dut.cam_dphy_dat, num_lanes=2, period_ns=2.5, sequence=sequence))

   # Wait for some time to allow further processing
   await Timer(100, units='us')