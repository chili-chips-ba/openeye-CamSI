////////////////////////////////////////////////////////////////////////////////
//
// Filename:    afifo_ctrl.v
//
// Project:     Controller for Async FIFO, based on Cliff Cummings' example
//
// Purpose:     This file defines the behaviour of an asynchronous FIFO.
//              It was originally copied from a paper by Clifford E. Cummings
//              of Sunburst Design, Inc.  Since then, many of the variable names
//              have been changed and the logic has been rearranged.  However, 
//              the fundamental logic remains the same.
//
//              http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
//
// Creator:     Dan Gisselquist, Ph.D.
//              Gisselquist Technology, LLC
//
// License:     GPL, v3, as defined and found on www.gnu.org,
//              http://www.gnu.org/licenses/gpl.html
////////////////////////////////////////////////////////////////////////////////
//
//  Adopted by: Robert Metchev / Chips & Scripts (rmetchev@ieee.org)
//  for Brilliant Labs Ltd.
//  for TISG Project
////////////////////////////////////////////////////////////////////////////////

module afifo_ctrl #(
   parameter  DW = 8,
              AW = 8
)(

// Write side 
   input   logic i_wclk,
                 i_wrst_n,
                 i_wr,
   output  logic o_wr, o_wfull,
   output  logic [AW-1:0] o_waddr,

// Read side 
   input   logic i_rclk,
                 i_rrst_n,
                 i_rd,
   output  logic o_rd, o_rempty,
   output  logic [AW-1:0] o_raddr
);
    
   typedef logic [AW:0] ptr_t;
   
   ptr_t  wgray, wbin, wq2_rgray, wq1_rgray,
          rgray, rbin, rq2_wgray, rq1_wgray,
          wgray_next,  wbin_next,
          rgray_next,  rbin_next;


   /////////////////////////////////////////////
   // Write logic
   /////////////////////////////////////////////

   // Cross the read Gray pointer into the write clock domain
   always_ff @(posedge i_wclk) begin
      if (i_wrst_n == 1'b0) begin
          { wq2_rgray, wq1_rgray } <= '0;
      end
      else begin
          { wq2_rgray, wq1_rgray } <= { wq1_rgray, rgray };
      end 
   end

   // Calculate the next write address and the next graycode pointer
   assign wbin_next  = ptr_t'(wbin + {{AW{1'b0}}, o_wr});
   assign wgray_next = (wbin_next >> 1) ^ wbin_next;
   assign o_waddr    = wbin[AW-1:0];

   always_ff @(posedge i_wclk) begin
      if (i_wrst_n == 1'b0) begin
         { wbin, wgray } <= '0;
      end 
      else begin
         { wbin, wgray } <= { wbin_next, wgray_next };
      end
   end

   assign o_wfull = (wgray == 
                     {~wq2_rgray[AW:AW-1], wq2_rgray[AW-2:0]});

   assign o_wr = i_wr & ~o_wfull;

   
   ////////////////////////////////////////////////////////////////////////
   // Read logic
   ////////////////////////////////////////////////////////////////////////

   // Cross the write Gray pointer into the read clock domain
   always_ff @(posedge i_rclk) begin 
      if (i_rrst_n == 1'b0) begin
          { rq2_wgray, rq1_wgray } <= '0;
      end 
      else begin
          { rq2_wgray, rq1_wgray } <= { rq1_wgray, wgray };
      end
   end


   // Calculate the next read address,
   // and the next Gray code version associated with it
   assign rbin_next  = ptr_t'(rbin + {{AW{1'b0}}, o_rd});
   assign rgray_next = (rbin_next >> 1) ^ rbin_next;

   always_ff @(posedge i_rclk) begin 
      if (i_rrst_n == 1'b0) begin
         { rbin, rgray } <= '0;
      end
      else begin
         { rbin, rgray } <= { rbin_next, rgray_next };
      end
   end

   assign o_raddr  = rbin[AW-1:0];
   assign o_rempty = (rgray == rq2_wgray);
   assign o_rd     = i_rd & ~o_rempty;
   
endmodule: afifo_ctrl
