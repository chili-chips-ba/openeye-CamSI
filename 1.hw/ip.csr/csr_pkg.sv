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
// Description: This is the DNA of register set. Formalized and structured
//              for ease of automation and scripted generation
//==========================================================================

package csr_pkg;
 //import soc_pkg::clog2;
   
//-----------------------------------------------------------
   localparam ADDR_UART_TX = 'h0;

   typedef struct packed {       // WR_RD
    //logic [31:8]  rsvd;        // [31:8]
      logic [7:0]   data;        // [7:0]   Data to send out
   } uart_tx_t;
   
   localparam uart_tx_t INIT_UART_TX = 'h0;

//-----------------------------------------------------------
   localparam ADDR_UART_TX_START = 'h1;
     
   typedef struct packed {       // WO_PULSE
    //logic [31:1]  rsvd;        // [31:1]
      logic [0:0]   pulse;       // [0:0]   1 to start UART transmission
   } uart_tx_start_t;                   
                                  
//-----------------------------------------------------------
   localparam ADDR_UART_RX = 'h2;

   typedef struct packed {       // RD_ONLY 
      logic [31:31] valid;       // [31]    '1' when 'data' is valid
      logic [30:8]  rsvd;        // [31:8]
      logic [7:0]   data;        // [7:0]   Received data
   } uart_rx_t;

//-----------------------------------------------------------
   localparam ADDR_ADC_CONFIG = 'h3;

   typedef struct packed {       // WR_RD
    //logic [31:15] rsvd;        // [31:15]
      logic [14:0]  time_us;     // [14:0]  Duration of ADC conversion
   } adc_config_t;               //         in us. Max is 32_768 usec
                                  
   localparam adc_config_t INIT_ADC_CONFIG = '0;

//-----------------------------------------------------------
   localparam ADDR_ADC_START = 'h4;

   typedef struct packed {       // WO_PULSE
    //logic [31:1]  rsvd;        // [31:1]
      logic [0:0]   pulse;       // [0:0]   1 to start ADC conversion
   } adc_start_t;

//-----------------------------------------------------------
// Housekeeping
//-----------------------------------------------------------
   localparam CSR_ADDR_MAX = ADDR_ADC_START;
   
   localparam CSR_ADDR_MSB = $clog2(CSR_ADDR_MAX + 1) + 1;
   // number of bits needed to hold the highest CSR address
   // plus 1, because addressing is in the full 32-bit words
                        
   typedef struct packed {
      logic uart_tx;
      logic uart_tx_start;
      logic uart_rx;
      logic adc_config;
      logic adc_start;
   } sel_t;

endpackage: csr_pkg

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/01/15 AZ: initial creation    

*/
