//======================================================================== 
// openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
//------------------------------------------------------------------------
//                   Copyright (C) 2024 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//------------------------------------------------------------------------
// Designers  : Armin Zunic, Isam Vrce
// Description: 
//   Standardized template, then customized to each particular SOC design. 
//   This is the central module that all other SOC blocks, be they Masters 
//   or Slaves connect to. It is responsible for routing, address decoding 
//   and muxing of data returned by the Slaves
//--------------------------------------------------------------------------
// Address Decoding is as follows:
//  0x0000_0000 - 0x1FFF_FFFF - DMEM: CPU ADDR_STACK=0x2000_0000
//  0x2000_0000 - 0x3FFF_FFFF - CSR
//  0x4000_0000 - 0xFFFF_FFFF - SDRAM:8MBytes, which needs 00_0000-7F_FFFF
//==========================================================================

module soc_fabric (
// From Master(s):
   soc_if.SLV  cpu,  // interface for the controlling CPU. This SOC has only one CPU

// To Peripheral(s):                   
   soc_if.MST  dmem,  // interface to Data Memory of the CPU
   soc_if.MST  csr,   // interface to CSR register block (aka GPIO)
   soc_if.MST  sdram  // interface to SDRAM block
);

//-----------------------------------------------------------
// propagate/replicate common controls from Master to all Peripherals
//-----------------------------------------------------------
   assign dmem.addr  = cpu.addr;
   assign dmem.we    = cpu.we;
   assign dmem.wdat  = cpu.wdat;
                      
   assign csr.addr   = cpu.addr;
   assign csr.we     = cpu.we;
   assign csr.wdat   = cpu.wdat;

   assign sdram.addr = cpu.addr;
   assign sdram.we   = cpu.we;
   assign sdram.wdat = cpu.wdat;

//-----------------------------------------------------------
// assign peripheral Point-to-Point controls per Memory Map
//-----------------------------------------------------------
   // peripheral selects
   logic dmem_sel, csr_sel, sdram_sel;
    
   always_comb begin: _slv_p2p
   // address decode: All selects must be mutually exclusive!
      dmem_sel  = (cpu.addr[31:29] == 3'd0);
      csr_sel   = (cpu.addr[31:29] == 3'd1);
      sdram_sel = (cpu.addr[31:30] != 2'd0);
      
   // peripheral access is when it's SELected and CPU VLD
      dmem.vld  = dmem_sel  & cpu.vld;
      csr.vld   = csr_sel   & cpu.vld;
      sdram.vld = sdram_sel & cpu.vld;

   // return to CPU data from the selected peripheral
      unique case (1'b1) 
         dmem_sel: begin
            cpu.rdy  = dmem.rdy;
            cpu.rdat = dmem.rdat;
         end     

         csr_sel: begin
            cpu.rdy  = csr.rdy;
            cpu.rdat = csr.rdat;
         end     

         default: begin // sdram_sel
            cpu.rdy  = sdram.rdy;
            cpu.rdat = sdram.rdat;
         end     
       endcase
   end // block: _slv_p2p
   
endmodule: soc_fabric

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/01/15 AZ: initial creation    

*/
