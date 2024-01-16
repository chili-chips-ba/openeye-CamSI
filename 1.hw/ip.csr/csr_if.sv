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
//  - Provides the register layout
//==========================================================================

interface csr_if ();
   import csr_pkg::*;
   
   uart_tx_t        uart_tx;
   uart_tx_start_t  uart_tx_start;
   uart_rx_t        uart_rx;
   adc_config_t     adc_config;
   adc_start_t      adc_start;
   
  //---------------------------------------- 
  // master/CPU side
  //---------------------------------------- 
   modport MST (
     output uart_tx,
            uart_tx_start,
            adc_config,
            adc_start,

     input  uart_rx
   );

  //---------------------------------------- 
  // Slave/Peripheral side
  //---------------------------------------- 
   modport SLV (
     input  uart_tx,
            uart_tx_start,
            adc_config,
            adc_start,

     output uart_rx
   );

endinterface: csr_if

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/01/15 AZ: initial creation    

*/
