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
//   Wrapper for any CPU to make it Plug-and-Play compatible with our SOC 
//   infrastructure. We hereby instantiate the CPU itself, along with its 
//   Instruction Memory (IMEM). See individual files for details...
//--------------------------------------------------------
// Address mapping is:
//  0x0000_0000 - 0xFFFF_FFFF - IMEM / Program space: ADDR_RESET = 0x0000_0000
//  0x0000_0000 - 0xFFFF_FFFF - BUS  / Data space, see 'soc_fabric.sv' for details
//
//  The recommended Data space layout is:
//  0x0000_0000 - 0x1FFF_FFFF - DMEM: ADDR_STACK=0x2000_0000
//  0x2000_0000 - 0x3FFF_FFFF - CSR
//  0x4000_0000 - 0xFFFF_FFFF - SDRAM:8MBytes, which needs 00_0000-7F_FFFF
//==========================================================================

module soc_cpu #(
   parameter [31:0]   ADDR_RESET = 32'h 0000_0000,
   parameter [31:0]   ADDR_STACK = 32'h 2000_0000
)(
   soc_if.MST         bus,

// access point for reloading CPU program memory
   input logic        imem_we,
   input logic [31:2] imem_waddr,
   input logic [31:0] imem_wdat
);

   logic        clk, resetn;

   logic        cpu_valid; //-\ 
   logic        cpu_instr; // | CPU  
   logic        cpu_ready; // | memory 
   logic [31:0] cpu_addr;  // | interface 
   logic [31:0] cpu_wdata; // | 
   logic [3:0]  cpu_wstrb; // | 
   logic [31:0] cpu_rdata; //-/ 

   logic        bus_sel,
                imem_sel, imem_vld, imem_rdy;
   logic [31:0] imem_rdat;

   always_comb begin: _decode
      clk       = bus.clk;
      resetn    = bus.arst_n;

   // IMEM: 0x0000_0000 - 0xFFFF_FFFF - Instruction Space
   // BUS : 0x0000_0000 - 0xFFFF_FFFF - Data Space
      bus_sel   = ~cpu_instr;
      imem_sel  =  cpu_instr;

      bus.vld   =  bus_sel & cpu_valid;
      imem_vld  = imem_sel & cpu_valid;
                 
      bus.we    =  cpu_wstrb;
      bus.addr  =  cpu_addr[31:2];
      bus.wdat  =  cpu_wdata;
    
      if (imem_sel == 1'b1) begin 
         cpu_ready = imem_rdy;
         cpu_rdata = imem_rdat;
      end
      else begin
         cpu_ready =  bus.rdy;
         cpu_rdata =  bus.rdat;
      end
   end: _decode

   
//--------------------------------------------------------
// PicoRV32 itself
//--------------------------------------------------------
    logic        trace_valid;
    logic [35:0] trace_data;

    picorv32 #(
       .PROGADDR_RESET       (ADDR_RESET),
       .PROGADDR_IRQ         (32'h 0000_0000),
       .STACKADDR            (ADDR_STACK),
       .BARREL_SHIFTER       (0),
       .COMPRESSED_ISA       (1),
       .ENABLE_MUL           (0),
       .ENABLE_FAST_MUL      (0),
       .ENABLE_DIV           (0),

       .ENABLE_IRQ           (0),
       .ENABLE_IRQ_QREGS     (0),
       .ENABLE_IRQ_TIMER     (0),
       .MASKED_IRQ           (32'h0000_0000),
       .LATCHED_IRQ          (32'hffff_ffff),

`ifdef SIMULATION             
       .ENABLE_TRACE         (1),
`else                         
       .ENABLE_TRACE         (0),
`endif                        
       .ENABLE_COUNTERS      (1),
       .ENABLE_COUNTERS64    (1),
       .ENABLE_REGS_16_31    (1),
       .ENABLE_REGS_DUALPORT (1),
       .LATCHED_MEM_RDATA    (0),
       .TWO_STAGE_SHIFT      (1),
       .TWO_CYCLE_COMPARE    (0),
       .TWO_CYCLE_ALU        (0),
       .CATCH_MISALIGN       (1),
       .CATCH_ILLINSN        (1),
       .ENABLE_PCPI          (0),
       .REGS_INIT_ZERO       (0)
    ) 
    u_cpu (
       .clk          (clk),    //i
       .resetn       (resetn), //i
                      
       .trap         (), //o
                      
       .mem_valid    (cpu_valid), //o 
       .mem_instr    (cpu_instr), //o 
       .mem_ready    (cpu_ready), //i 
                      
       .mem_addr     (cpu_addr),  //o[31:0] 
       .mem_wdata    (cpu_wdata), //o[31:0] 
       .mem_wstrb    (cpu_wstrb), //o[3:0] 
       .mem_rdata    (cpu_rdata), //i[31:0] 

      // NOT-USED: Look-Ahead Interface
       .mem_la_read  (), //o 
       .mem_la_write (), //o 
       .mem_la_addr  (), //o[31:0] 
       .mem_la_wdata (), //o[31:0] 
       .mem_la_wstrb (), //o[3:0] 

      // NOT-USED: Pico Co-Processor Interface (PCPI)
       .pcpi_valid   (),   //o
       .pcpi_insn    (),   //o[31:0]
       .pcpi_rs1     (),   //o[31:0]
       .pcpi_rs2     (),   //o[31:0]
       .pcpi_wr      ('0), //i
       .pcpi_rd      ('0), //i[31:0]
       .pcpi_wait    ('0), //i
       .pcpi_ready   ('0), //i

        // NOT-USED: IRQ Interface
       .irq          ('0), //i[31:0]
       .eoi          (),   //o[31:0]

        // NOT-USED: Trace Interface
       .trace_valid  (trace_valid), //o
       .trace_data   (trace_data)   //o[35:0]
    );


//----------------------------------------------------
// Instruction (aka Program) memory for the CPU
//----------------------------------------------------
    imem u_imem (
      .clk    (clk),
      .arst_n (resetn),

    // CPU Read-Only port
      .rvld   (imem_vld),
      .rrdy   (imem_rdy),
      .raddr  (cpu_addr [31:2]),
      .rdat   (imem_rdat),

    // Write port for reloading new CPU program
      .we     (imem_we),
      .waddr  (imem_waddr),
      .wdat   (imem_wdat)
    );

//---------------------------------------------------------
// Simulation debug
//---------------------------------------------------------
`ifdef SIMULATION
    int trace_file;

    always_ff @(posedge clk) begin
       if ({resetn, mem_valid, mem_ready} == 3'b111) begin
          if (mem_instr)
             $display("Inst rd: [0x%08X] = 0x%08X", mem_addr, mem_rdata);
          else
             $display("Data rd: [0x%08X] = 0x%08X", mem_addr, mem_rdata);
       end
    end

    // Trace
    initial begin

       trace_file = $fopen("testbench.trace", "w");
       repeat (10) @(posedge clk);

       while(1) begin
          @(posedge clk)
          if (resetn & trace_valid)
              $fwrite(trace_file, "%x\n", trace_data);
              $fflush(trace_file);
              //$display("Trace  : %09X", trace_data);
       end
    end
`endif // SIMULATION

endmodule: soc_cpu

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/01/15 AZ: initial creation    

*/
