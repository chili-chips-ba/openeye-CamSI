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
// Description: <brief explanation of what this module does, with links
//               to other projects that were used for reference>
//========================================================================

module top 
   import soc_pkg::*;
(
   input  logic        clk_27,    // 27MHz clock oscillator on TangNano20K
                        
 //input  logic [2:0]  clk_fpll,  // clock from onboard FractionalPLL (5351)
                        
   input  logic [2:1]  key,       // active-HI, S1:UserFunction S2:Reset
   output logic [5:0]  led_n,     // active-LO onboard LEDs
                        
   input  logic        uart_rx,   // -\ UART towards BL616
   output logic        uart_tx,   // -/ 

 //Embedded SDRAM
   output logic        O_sdram_clk,
   output logic        O_sdram_cke,
   output logic        O_sdram_cs_n,
                                 
   output logic        O_sdram_ras_n,
   output logic        O_sdram_cas_n,
   output logic        O_sdram_wen_n,
                                
   output logic [1:0]  O_sdram_ba,  
   output logic [10:0] O_sdram_addr,
   output logic [3:0]  O_sdram_dqm,

   inout  wire  [31:0] IO_sdram_dq

 //ADC
);

//=================================
// Clock and reset generation
//=================================
   logic       arst_n;
   logic       clk_54;
                
   logic       tick_1us;
   logic       tick_cca15us;
   logic [2:1] key_clean;
   
   fpga_pll u_pll (
      .clk_27    (clk_27),       //i
      .force_rst (key_clean[2]), //i            

      .srst_n    (arst_n),       //o
      .clk_54    (clk_54),       //o
      .clk_108   ()              //o
   );

   debounce u_debounce[2:1] (
      .clk       (clk_54),       //i
      .tick_15us (tick_cca15us), //i
      .inp       (key),          //i
      .out       (key_clean)     //o
   );

   assign led_n[5:1] =  5'b10101;
   assign led_n[0]   = ~key_clean[1];
   

//=================================
// CPU Subsystem
//=================================
   soc_if bus_cpu   (.arst_n(arst_n), .clk(clk_54));
   soc_if bus_dmem  (.arst_n(arst_n), .clk(clk_54));
   soc_if bus_csr   (.arst_n(arst_n), .clk(clk_54));
   soc_if bus_sdram (.arst_n(arst_n), .clk(clk_54));

   csr_if csr ();

   logic        imem_we;
   logic [31:2] imem_waddr;
   logic [31:0] imem_wdat;

//---------------------------------
   soc_cpu #(
     .ADDR_RESET (32'h 0000_0000),
     .ADDR_STACK (32'h 2000_0000)
   ) 
   u_cpu (
     .bus        (bus_cpu),    //MST

     .imem_we    (imem_we),    //-\ access point for 
     .imem_waddr (imem_waddr), // | reloading CPU 
     .imem_wdat  (imem_wdat)   //-/ program memory 
   ); 

//---------------------------------
  soc_fabric u_fabric (
     .cpu   (bus_cpu),  //SLV

     .dmem  (bus_dmem), //MST
     .csr   (bus_csr),  //MST
     .sdram (bus_sdram) //MST
  );

//---------------------------------
  soc_ram #(
     .NUM_WORDS(1024) // 4KByte CPU DataRAM
  )
  u_dmem (
     .bus (bus_dmem) //SLV
  );

//---------------------------------
  soc_csr u_csr (
     .bus (bus_csr), //SLV
     .csr (csr)      //MST
  );
                   
//---------------------------------
  sdram_if pad();
   
  soc_sdram u_sdram (
     .pad          (pad),         //MST
     .IO_sdram_dq  (IO_sdram_dq),

     .bus          (bus_sdram),   //SLV

     .tick_1us     (tick_1us),    //o
     .tick_cca15us (tick_cca15us) //o
  );

   assign O_sdram_clk   = pad.O_sdram_clk;
   assign O_sdram_cke   = pad.O_sdram_cke; 
   assign O_sdram_cs_n  = pad.O_sdram_cs_n;
                             
   assign O_sdram_ras_n = pad.O_sdram_ras_n;
   assign O_sdram_cas_n = pad.O_sdram_cas_n;
   assign O_sdram_wen_n = pad.O_sdram_wen_n;
                             
   assign O_sdram_ba    = pad.O_sdram_ba;
   assign O_sdram_addr  = pad.O_sdram_addr;
   assign O_sdram_dqm   = pad.O_sdram_dqm;

//---------------------------------
  uart #(
    .DATA_BITS  (8), // Number of DATA bits, can be 7/8
    .PARITY_BIT (2), // PARITY disabled is by default
    .STOP_BITS  (1)  // Using only 1 STOP bit
  )
  u_uart (
    .arst_n   (arst_n),   //i 
    .clk      (clk_54),   //i 
    .tick_1us (tick_1us), //i 

    .uart_rx  (uart_rx),  //i 
    .uart_tx  (uart_tx),  //o

    .csr      (csr)       //SLV 
  );

//---------------------------------
// TODO: Code for loading IMEM via UART
   assign imem_we    = '0;
   assign imem_waddr = '0;
   assign imem_wdat  = '0;

//=================================
// Misc
//=================================

endmodule: top

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/01/15 AZ: initial creation    

*/
