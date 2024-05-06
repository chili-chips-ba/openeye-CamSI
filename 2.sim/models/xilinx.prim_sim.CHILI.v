//==========================================================================
// Improved by Chili.CHIPS (2023/24)
//--------------------------------------------------------------------------
// Description: Shortened version of xilinx.prim_sim.v
//              Contains only used primitives and IPs
//  Copied from: 
//    D:<GOWIN-INSTALL>/IDE/simlib/gw2a/prim_sim.v
//==========================================================================

// verilator lint_off WIDTH

`timescale 1ps / 1ps
// PLL models needs 1ps resolution

//--------------------------
module OBUF (O, I);
input  I;
output O;
buf OB (O, I);   
endmodule: OBUF

//--------------------------
module IOBUF #(
   parameter DRIVE        = 12,
   parameter IBUF_LOW_PWR = "TRUE",
   parameter IOSTANDARD   = "DEFAULT",
   parameter SLEW         = "SLOW"
)(
   input     I,T,
   output    O,
   inout     IO
);
   buf OB (O, IO);
   bufif0 IB (IO,I,T);
endmodule: IOBUF


//--------------------------
// verilator lint_on WIDTH
