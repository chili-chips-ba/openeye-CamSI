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
//   Wrapper for UART Tx & Rx blocks that makes it Plug-and-Play compatible
//   with our SOC infrastructure. See individual files for details...
//==========================================================================

module uart #(
    parameter    DATA_BITS  = 8, // Number of DATA bits, can be 7/8
    parameter    PARITY_BIT = 2, // PARITY disabled is by default
    parameter    STOP_BITS  = 1  // Using only 1 STOP bit
)(
    input  logic arst_n,
    input  logic clk,
    input  logic tick_1us,

    input  logic uart_rx,
    output logic uart_tx,

    csr_if.SLV   csr
);

  //------------------------------------------------
    uart_rx #(
      .DATA_BITS  (DATA_BITS),
      .PARITY_BIT (PARITY_BIT),
      .STOP_BITS  (STOP_BITS)
    )
    u_rx (
      .rx         (uart_rx),           //i
      .i_clk      (clk),               //i
      .flush      (1'b0),              //i
      .data       (csr.uart_rx.data),  //i'[FRAME_BITS-1:0]
      .converted  (), //o
      .data_valid (csr.uart_rx.valid), //o
      .busy       ()//o
    );

    assign csr.uart_rx.rsvd = '0; // dummy
   
  //------------------------------------------------
    uart_tx #(
      .DATA_BITS  (DATA_BITS),
      .PARITY_BIT (PARITY_BIT),
      .STOP_BITS  (STOP_BITS),
      .RETENTION_DURATION (15) // Compensate for oversampling in RX
    )
    u_tx (
      .tx         (uart_tx), //o
      .tx_busy    (),        //o
      .clk        (clk),     //i
      .tx_enable  (csr.uart_tx_start.pulse), //i
      .data       (csr.uart_tx.data)         //i'[FRAME_BITS-1:0]
    );

endmodule: uart

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/01/15 AZ: initial creation    

*/
