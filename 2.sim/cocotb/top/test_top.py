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
    Coroutine to drive a differential signal.
    """
    while True:
        # Drive one part of the differential pair high, the other low
        signal.value = 0b01
        await Timer(period_ns / 2, units='ns')
        # Drive one part of the differential pair low, the other high
        signal.value = 0b10
        await Timer(period_ns / 2, units='ns')

async def send_byte_on_lane(signal, lane, byte, period_ns):
    """
    Coroutine to send a specific byte on a given differential lane.
    """
    while True:
        for bit in range(8):
            bit_value = (byte >> bit) & 0x1
            # Positive bit is at (lane*2 + 1), negative bit is at (lane*2)
            signal[lane*2 + 1].value = bit_value  # Positive bit
            signal[lane*2].value = ~bit_value & 0x1  # Negative bit (inverse)
            await Timer(period_ns, units='ns')

async def drive_diff_counter(signal, period_ns, num_lanes, data_bytes):
    """
    Coroutine to drive a differential signal as a counter with specified bytes for each lane.
    """
    # Start parallel coroutines for each lane
    for lane in range(num_lanes):
        cocotb.start_soon(send_byte_on_lane(signal, lane, data_bytes[lane], period_ns))

@cocotb.test()
async def test_1(dut):
    # Get simulation runtime from environment variable, default to 15 microseconds
    run_sim_us = float(os.environ.get('RUN_SIM_US', 15))
    run_sim_cycles_100MHz = int(run_sim_us * 1000 / 10)

    # Initialize PLL instances for top and HDMI clocks
    pllt = fpga_pll.fpga_pll(dut, 'top')
    pllh = fpga_pll.fpga_pll(dut, 'hdmi')

    # Start external clock generation at 100 MHz
    cocotb.start_soon(Clock(dut.clk_ext, 10, units="ns").start())

    # Wait for Cam to start
    await RisingEdge(dut.cam_en)
    
    # Start driving the differential clock signal
    cocotb.start_soon(drive_diff_clock(dut.cam_dphy_clk, period_ns=5))

    # Specify the data bytes for each lane
    data_bytes = [0b10111000, 0b01000111]  # Example bytes for 2 lanes

    await Timer(45, units='ns')

    # Start driving the differential lane signals with specified bytes in parallel
    cocotb.start_soon(drive_diff_counter(dut.cam_dphy_dat, period_ns=2.5, num_lanes=2, data_bytes=data_bytes))

    # Wait for some time to allow further processing
    await Timer(100, units='us')