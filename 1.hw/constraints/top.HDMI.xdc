#------------------------------------------------------------------------ 
# openeye-CSI * NLnet-sponsored open-source core for Camera I/F with ISP
#------------------------------------------------------------------------
#                   Copyright (C) 2024 Chili.CHIPS*ba
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions 
# are met:
#
# 1. Redistributions of source code must retain the above copyright 
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright 
# notice, this list of conditions and the following disclaimer in the 
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its 
# contributors may be used to endorse or promote products derived
# from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#              https://opensource.org/license/bsd-3-clause
#------------------------------------------------------------------------
# Designers  : Armin Zunic, Isam Vrce
# Description: HDMI constraint with Xilinx Artix-7
#------------------------------------------------------------------------

# clk
set_property -dict { PACKAGE_PIN P17  IOSTANDARD LVCMOS33 } [get_ports { clk_ext }];
    create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk_ext }];

# HDMI
set_property -dict { PACKAGE_PIN C4  IOSTANDARD LVDS_25 } [get_ports { hdmi_clk_p }];
set_property -dict { PACKAGE_PIN B4  IOSTANDARD LVDS_25 } [get_ports { hdmi_clk_n }];

set_property -dict { PACKAGE_PIN H1  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_p[0] }];
set_property -dict { PACKAGE_PIN G1  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_n[0] }];

set_property -dict { PACKAGE_PIN D8  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_p[1] }];
set_property -dict { PACKAGE_PIN C7  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_n[1] }];

set_property -dict { PACKAGE_PIN F4  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_p[2] }];
set_property -dict { PACKAGE_PIN F3  IOSTANDARD LVDS_25 } [get_ports { hdmi_dat_n[2] }];

#
#------------------------------------------------------------------------------
# Version History:
#------------------------------------------------------------------------------
# 2024/1/4 Isam Vrce: Initial creation
# 2024/1/17 Armin Zunic: Testing
#