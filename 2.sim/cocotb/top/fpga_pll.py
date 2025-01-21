# SPDX-FileCopyrightText: 2024 Chili.CHIPS*ba
#
# SPDX-License-Identifier: BSD-3-Clause

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge, Timer, with_timeout

class fpga_pll():
    def __init__(self, dut, pll):
        

        if pll == 'top':
            divclk_divide = 5           # Master division value (1-106)
            clkfbout_mult_f = 49.875    # Multiply value for all CLKOUT (2.000-64.000)
            clkout0_divide_f = 4.375
            clkout2_divide = 5
            self.start_up_time = 3595   # ns
            self.lock_time = 9258.75    # ns
            p = dut.u_clkrst_gen.u_pll_top
            self.clk0 = p.uclk_out0
            self.clk2 = p.uclk_out1
            self.lock = p.pll_lock

            ref_clk = 100 # MHz
            clk0_freq = ref_clk * clkfbout_mult_f / (divclk_divide * clkout0_divide_f)
            clk2_freq = ref_clk * clkfbout_mult_f / (divclk_divide * clkout2_divide)
            self.clk0_period = 2*round(1e3/clk0_freq/2, 3)      # ns # ValueError: Unable to accurately represent 4.385964912280702(ns) with the simulator precision of 1e-12
            self.clk2_period = 2*round(1e3/clk2_freq/2, 3)      # ns

            cocotb.start_soon(self.pll_clks())
            cocotb.start_soon(self.pll_lock())

        if pll == 'hdmi':
            divclk_divide = 3           # Master division value (1-106)
            clkfbout_mult_f = 38.750    # Multiply value for all CLKOUT (2.000-64.000)
            clkout0_divide_f = 3.0
            clkout2_divide = 15
            self.start_up_time = 4635   # ns
            self.lock_time = 5707.5     # ns
            p = dut.u_hdmi_top.u_hdmi_backend.u_fpga_pll_hdmi
            self.clk0 = p.uclk_pix5
            self.clk2 = p.uclk_pix
            self.lock = p.pll_lock
        
            ref_clk = 100 # MHz
            clk0_freq = ref_clk * clkfbout_mult_f / (divclk_divide * clkout0_divide_f)
            clk2_freq = ref_clk * clkfbout_mult_f / (divclk_divide * clkout2_divide)
            self.clk0_period = 2*round(1e3/clk0_freq/2, 3)      # ns # ValueError: Unable to accurately represent 4.385964912280702(ns) with the simulator precision of 1e-12
            self.clk2_period = 2*round(1e3/clk2_freq/2, 3)      # ns

            cocotb.start_soon(self.pll_clks())
            cocotb.start_soon(self.pll_lock())

        if pll == 'csi_rx':
            divclk_divide = 1           # Master division value (1-106)
            clkfbout_mult_f = 2         # Multiply value for all CLKOUT (2.000-64.000)
            clkout0_divide_f = 2
            clkout2_divide = 8
            self.start_up_time = 3595   # ns
            self.lock_time = 9258.75    # ns
            p = dut.u_csi_rx_top.u_phy_clk
            self.clk0 = p.uclk_out
            self.clk2 = p.uclk_out_div4
            self.lock = p.pll_lock

            ref_clk = 720 # MHz
            clk0_freq = ref_clk * clkfbout_mult_f / (divclk_divide * clkout0_divide_f)
            clk2_freq = ref_clk * clkfbout_mult_f / (divclk_divide * clkout2_divide)
            self.clk0_period = 2*round(1e3/clk0_freq/2, 3)      # ns # ValueError: Unable to accurately represent 4.385964912280702(ns) with the simulator precision of 1e-12
            self.clk2_period = 2*round(1e3/clk2_freq/2, 3)      # ns

            cocotb.start_soon(self.pll_clks())
            cocotb.start_soon(self.pll_lock())

    async def pll_lock(self):
        self.lock.value = 0
        await Timer(self.lock_time, units='ns')
        self.lock.value = 1

    async def pll_clks(self):
        await Timer(self.start_up_time, units='ns')
        cocotb.start_soon(Clock(self.clk0, self.clk0_period, units="ns").start())
        cocotb.start_soon(Clock(self.clk2, self.clk2_period, units="ns").start())
