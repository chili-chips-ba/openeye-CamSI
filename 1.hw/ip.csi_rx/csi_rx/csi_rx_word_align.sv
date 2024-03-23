//This receives aligned bytes and status signals from the 4 byte aligners
//and compensates for up to 2 clock cycles of skew between channels. It also
//controls the packet_done input to the byte aligner, resetting byte aligners'
//sync status if all 4 byte aligners fail to find the sync pattern

//Similar to the byte aligner, this locks the alignment once a valid alignment
//has been found until packet_done is asserted

module csi_rx_word_align (
    input  logic        byte_clock,      // byte clock in
    input  logic        reset,           // active high synchronous reset
    input  logic        enable,          // active high enable
    input  logic        packet_done,     // packet done input from packet handler entity
    input  logic        wait_for_sync,   // whether or not to be looking for an alignment
    output logic        packet_done_out, // packet done output to byte aligners
    input  logic [15:0] word_in,         // unaligned word from the 4 byte aligners
    input  logic [1:0]  valid_in,        // valid_out from the byte aligners (MSB is index 3, LSB index 0)
    output logic [15:0] word_out,        // aligned word out to packet handler
    output logic        valid_out        // goes high once alignment is valid, such that the first word with it high is the CSI packet header
);

   logic [15:0] word_dly_0;
   logic [15:0] word_dly_1;
   logic [15:0] word_dly_2;

   logic [1:0] valid_dly_0;
   logic [1:0] valid_dly_1;
   logic [1:0] valid_dly_2;

   typedef logic [1:0] taps_t [4];

   taps_t taps;
   taps_t next_taps;

   logic valid = 1'b0;
   logic next_valid;
   logic invalid_start = 1'b0;
   logic [15:0] aligned_word;
   
   
   // Process handling the word_clock
   always_ff @(posedge byte_clock) begin
      if (reset == 1'b1) begin
         valid <= 0;
         taps = '{2'b00, 2'b00, 2'b00, 2'b00}; // Reset taps
      end else if (enable == 1'b1) begin
         word_dly_0  <= word_in;
         valid_dly_0 <= valid_in;
         word_dly_1  <= word_dly_0;
         valid_dly_1 <= valid_dly_0;
         word_dly_2  <= word_dly_1;
         valid_dly_2 <= valid_dly_1;
         valid_out   <= valid;
         word_out    <= aligned_word;
         if ({next_valid, valid, wait_for_sync} == 3'b101) begin
            valid <= 1'b1;
            taps  <= next_taps;
         end else if (packet_done == 1'b1) begin
            valid <= 1'b0;
         end
      end
   end

   // Process handling valid delay logic and tap calculation
   always_comb begin
      logic next_valid_int;
      logic is_triggered = 1'b0;

      next_valid_int = &valid_dly_0;
      is_triggered   = 1'b0;
      for (int i = 0; i <= 1; i++) begin
         if ({valid_dly_0[i], valid_dly_1[i], valid_dly_2[i]} == 3'b111) begin
            is_triggered = 1'b1;
         end
      end
      invalid_start <= (!next_valid_int) && is_triggered;
      next_valid    <= next_valid_int;
      for (int i = 0; i <= 1; i++) begin
         if (valid_dly_2[i]) begin
            next_taps[i] = 2'b10;
         end else if (valid_dly_1[i]) begin
            next_taps[i] = 2'b01;
         end else begin
            next_taps[i] = 2'b00;
         end
      end
   end

   // Process handling word alignment
   always_comb begin
      for (int i = 0; i <= 1; i++) begin
         case (taps[i])
            2'b10: aligned_word[(8*i)+7 -: 8] = word_dly_2[(8*i)+7 -: 8];
            2'b01: aligned_word[(8*i)+7 -: 8] = word_dly_1[(8*i)+7 -: 8];
            default: aligned_word[(8*i)+7 -: 8] = word_dly_0[(8*i)+7 -: 8];
         endcase
      end
   end

   // Update packet_done_out
   assign packet_done_out = packet_done || invalid_start;
   
endmodule
