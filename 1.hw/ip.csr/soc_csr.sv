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
//   This is the CSR register block. While it does not need to so, for 
//   simplicity, we try to keep only one GPIO block for the entire SOC.
//
//   See 'csr_if.sv for the register map...
//==========================================================================

module soc_csr 
   import soc_pkg::*;
   import csr_pkg::*;
(
   soc_if.SLV  bus,
   csr_if.MST  csr
);
   
//-----------------------------------------
// Address decoder
//-----------------------------------------
   sel_t sel;
   
   always_comb begin 
      sel = '0;
      
      unique case (bus.addr[CSR_ADDR_MSB:2])
         ADDR_UART_TX       : sel.uart_tx       = HI;
         ADDR_UART_TX_START : sel.uart_tx_start = HI;
         ADDR_UART_RX       : sel.uart_rx       = HI;
         ADDR_ADC_CONFIG    : sel.adc_config    = HI;
         ADDR_ADC_START     : sel.adc_start     = HI;

         default: begin end 
      endcase  
   end

//-----------------------------------------
// WRITE registers
//-----------------------------------------
   logic  write;
   assign write = &{bus.vld, bus.we};

   always_ff @(negedge bus.arst_n or posedge bus.clk) begin: reg_wr
      if (bus.arst_n == LO) begin
         csr.uart_tx.data       <= INIT_UART_TX.data;
         csr.adc_config.time_us <= INIT_ADC_CONFIG.time_us;
      end 
     // only full 32-bit writes are supported
      else if (write == HI) begin
         unique case (HI) 
            sel.uart_tx   : csr.uart_tx.data       <= bus.wdat[7:0];
            sel.adc_config: csr.adc_config.time_us <= bus.wdat[14:0];
    
            default: begin end 
         endcase // unique case (HI)
      end
   end // block: reg_wr

//-----------------------------------------
// WO_PULSE registers
//-----------------------------------------
   always_ff @(posedge bus.clk) begin: reg_wo_pulse
      csr.uart_tx_start.pulse <= sel.uart_tx_start & write & bus.wdat[0];
      csr.adc_start.pulse     <= sel.adc_start     & write & bus.wdat[0];
   end

//-----------------------------------------
// READ Mux
//-----------------------------------------
   always_comb begin: rd_mux
      bus.rdat = '0;

      unique case (HI) 
         sel.uart_tx   : bus.rdat[7:0]  = csr.uart_tx.data;
         sel.uart_rx   : begin
                         bus.rdat[7:0]  = csr.uart_rx.data;
                         bus.rdat[31]   = csr.uart_rx.valid;
                         end
         sel.adc_config: bus.rdat[14:0] = csr.adc_config.time_us;

         default: begin end 
      endcase // unique case (HI)
   end // block: rd_mux

//-----------------------------------------
// Handshake
//-----------------------------------------
  //assign bus.rdy = bus.vld; // all transactions are completed in one cycle
  assign bus.rdy = HI;
   
endmodule: soc_csr

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/01/15 AZ: initial creation    

*/
