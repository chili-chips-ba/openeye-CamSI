//MIPI CSI-2 Rx 2 lane link layer

//This receives raw, unaligned bytes (which could contain part of two actual bytes)
//from the SERDES and aligns them by looking for the D-PHY sync pattern

//When wait_for_sync is high the entity will wait until it sees the valid header at some alignment,
//at which point the found alignment is locked until packet_done is asserted

//valid_data is asserted as soon as the sync pattern is found, so the next byte
//contains the CSI packet header

//In reality to avoid false triggers we must look for a valid sync pattern on all 4 lanes,
//if this does not occur the word aligner (a seperate entity) will assert packet_done immediately

module csi_rx_byte_align (
   input  logic        clock,         // byte clock in
   input  logic        reset,         // synchronous active high reset
   input  logic        enable,        // active high enable
   input  logic [7:0]  deser_in,      // raw data from ISERDES
   input  logic        wait_for_sync, // when high will look for a sync pattern if sync not already found
   input  logic        packet_done,   // assert to reset synchronisation status
   output logic        valid_data,    // goes high as soon as sync pattern is found (so data out on next cycle contains header)
   output logic [7:0]  data_out       // aligned data out, typically delayed by 2 cycles
);

   logic [7:0]  curr_byte;
   logic [7:0]  last_byte;
   logic [7:0]  shifted_byte;
   //logic [15:0] test_byte;
   
   logic        found_hdr;
   logic        valid_data_int;
   logic [2:0]  hdr_offs;
   logic [2:0]  data_offs;
         
   //logic [31:0] r_CNT_WORD;
   
   always_ff @(posedge clock) begin
      if (reset == 1'b1) begin
         valid_data_int <= 1'b0;
      end else if (enable == 1'b1) begin
         last_byte <= curr_byte;
         curr_byte <= deser_in;
         data_out  <= shifted_byte;
         if (packet_done == 1'b1) begin
            valid_data_int <= found_hdr;
         end else if ({wait_for_sync, found_hdr, valid_data_int} == 3'b110) begin
            valid_data_int <= 1'b1;
            data_offs      <= hdr_offs;
         end
      end
   end

   assign valid_data = valid_data_int;
   
   function logic is_zero (
      input logic [15:0] value,
      input int          msb
   );
      is_zero = 1'b1;
      for (int i = 0; i < msb; i++) begin
         if (value[i] == 1'b1) is_zero = 1'b0;
      end
   endfunction: is_zero
   
   logic [15:0] curr_word;
   logic [7:0]  sync = 8'b10111000;   
   
   always_comb begin
      logic was_found = 1'b0;
      int offset      = 0;
      found_hdr       = 1'b0;
      hdr_offs        = 3'b0;

      /*for (int i = 0; i <= 7; i++) begin
         if (({curr_byte[i:0], last_byte[7:i+1]} == 8'b10111000) && ({last_byte[i:0]} == '0)) begin
            was_found = 1'b1;
            offset = i;
         end
      end*/
      
      curr_word[15:0] = {curr_byte, last_byte};

      for (int i = 8; i < 16; i++) begin
         was_found = (curr_word[i -:8] == sync) & is_zero(curr_word, i-8);
         if (was_found == 1'b1) offset = i;
      end
      
      
      if (was_found == 1'b1) begin
         found_hdr = 1'b1;
         hdr_offs = offset[2:0];
      end
   end
   
   always_comb begin
      case (data_offs)
         3'd7: shifted_byte = curr_byte;
         3'd6: shifted_byte = {curr_byte[6:0], last_byte[7]};
         3'd5: shifted_byte = {curr_byte[5:0], last_byte[7:6]};
         3'd4: shifted_byte = {curr_byte[4:0], last_byte[7:5]};
         3'd3: shifted_byte = {curr_byte[3:0], last_byte[7:4]};
         3'd2: shifted_byte = {curr_byte[2:0], last_byte[7:3]};
         3'd1: shifted_byte = {curr_byte[1:0], last_byte[7:2]};
         3'd0: shifted_byte = {curr_byte[0], last_byte[7:1]};
         default: shifted_byte = 8'bx;
      endcase
   end
   
endmodule
