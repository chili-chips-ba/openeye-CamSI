//This controls the wait_for_sync and packet_done inputs to the byte/word aligners;
//receives aligned words and processes them
//It keeps track of whether or not we are currently in a video line or frame;
//and pulls the video payload out of long packets of the correct type

module csi_rx_packet_handler (
   input  logic              clock,         // state machine clock in
   input  logic              reset,         // asynchronous active high reset
   input  logic              debug,
   input  logic              enable,        // active high enable
   input  logic [15:0]       data,          // data in from word aligner
   input  logic              data_valid,    // data valid in from word aligner
   output logic              sync_wait,     // drives byte and word aligner wait_for_sync
   output logic              packet_done,   // drives word aligner packet_done
   output logic [31:0]       payload_out,   // payload out from long video packets
   output logic              payload_valid, // whether or not payload output is valid
                                            // (i.e. currently receiving a long packet)
   output logic              sync_seq,      // active high when find mipi sync sequence (b8b8)
   output logic              in_frame,      // whether or not currently in video frame
                                            // (i.e. got FS but not FE)
   output logic              in_line,       // whether or not receiving video line
   output logic              ecc_out        // ECC output
);

   logic        is_hdr;    
   logic [31:0] packet_data;
   logic [7:0]  packet_type;
   logic        long_packet, long_packet_last;
   logic [15:0] packet_len;
   logic [15:0] packet_len_q = 16'h0000;
   logic [2:0]  state = 3'b000;

   logic [15:0] bytes_read;
   logic        in_frame_d;
   logic        in_line_d;
   logic        valid_packet;
   logic        valid_packet_data; 
   
   logic [23:0] packet_for_ecc;
   logic [7:0]  expected_ecc;
   logic        valid_ecc;
   
   function logic is_allowed_type(logic [7:0] packet_type);
      logic result;
      case (packet_type)
         8'h00, 8'h01, 8'h02, 8'h03: // sync
            result = 1'b1;
         8'h10, 8'h11, 8'h12: // non image
            result = 1'b1;
         8'h28, 8'h29, 8'h2A, 8'h2B, 8'h2C, 8'h2D: // RAW
            result = 1'b1;
         // 8'h37: // DEBUG
         // result = 1'b1;
         default:
            result = 1'b0;
      endcase
      return result;
   endfunction
   
   always_ff @(posedge clock or posedge reset) begin
      if (reset == 1'b1) begin
         state    <= 3'b000;
         sync_seq <= 1'b0;
      end else if (enable == 1'b1) begin
         packet_data[31:16] <= data;
         packet_data[15:0]  <= packet_data[31:16];
         case (state)
            3'b000: // waiting to init
               state <= 3'b001;
            3'b001: begin // waiting for start
               bytes_read <= 16'h0000;
               if (data_valid == 1'b1) begin
                  state <= 3'b110;
               end
            end
            3'b110: begin // sync sequence "10111000"
               sync_seq <= 1'b1;
               state    <= 3'b101;
            end
            3'b101: begin
               sync_seq     <= 1'b0;
               packet_len_q <= packet_len;
               if (long_packet == 1'b1) begin
                  state <= 3'b111; // wait one cycle to complete header (packet header 32 bits)
               end else begin
                  state <= 3'b011;
               end
            end
            3'b111: // rx long packet
               state <= 3'b010; // header completed go to read long packet
            3'b010: begin// rx long packet
               if ((bytes_read < (packet_len_q - 16'd2)) && (bytes_read < 16'd8192)) begin
                  bytes_read <= bytes_read + 16'd2;
               end
               else begin
                  state <= 3'b011;
               end
            end   
            3'b011: // packet done, assert packet_done
               state <= 3'b100;
            3'b100: // wait one cycle and reset
               state <= 3'b001;
            default:
               state <= 3'b000;
         endcase;
      end
   end
   
   csi_rx_hdr_ecc ecc_inst (
      .data(packet_for_ecc),
      .ecc(expected_ecc)
   );

   always_comb begin
      packet_type = {2'b00, packet_data[5:0]};
      valid_packet = (packet_data[31:24] == expected_ecc) && 
                     is_allowed_type(packet_type) && 
                     (packet_data[7:6] == 2'b00) ? 1'b1 : 1'b0;

      valid_ecc = (packet_data[31:24] == expected_ecc) ? 1'b1 : 1'b0;

      is_hdr = (data_valid == 1'b1 && state == 3'b101) ? 1'b1 : 1'b0;

      long_packet = (packet_type > 8'h0F) && valid_packet ? 1'b1 : 1'b0;

      packet_for_ecc = packet_data[23:0];
      packet_len = packet_data[23:8];
   end
   
   always_ff @(posedge clock or posedge reset) begin
      if (reset == 1'b1) begin
         in_frame_d <= 1'b0;
         in_line_d  <= 1'b0;
      end else if (enable == 1'b1) begin
         // FS (Frame Start)
         if (is_hdr == 1'b1 && packet_type == 8'h00 && valid_packet == 1'b1) begin
            in_frame_d <= 1'b1;
         end
         // FE (Frame End)
         else if (is_hdr == 1'b1 && packet_type == 8'h01 && valid_packet == 1'b1) begin
            in_frame_d <= 1'b0;
         end

         // Video line detection
         if (is_hdr == 1'b1 && packet_type[7:4] == 4'h2 && valid_packet == 1'b1) begin
            in_line_d <= 1'b1;
         end
         else if (state != 3'b110 && state != 3'b101 && state != 3'b111 && state != 3'b010) begin
            in_line_d <= 1'b0;
         end
      end
   end
   
   always_comb begin
      in_frame = in_frame_d;
      in_line = in_line_d;
      ecc_out = valid_ecc;

      sync_wait = (state == 3'b001) ? 1'b1 : 1'b0;
      packet_done = (state == 3'b011) ? 1'b1 : 1'b0;

      if (debug == 1'b1) begin
         payload_out[31:16] = {4'b1000, 1'b0, state, 1'b0, in_line_d, in_frame_d, is_hdr, 1'b0, valid_ecc, valid_packet, data_valid};
      end else begin
         payload_out[31:16] = 16'h0000;
      end

      if (debug == 1'b0 && state == 3'b010) begin
         payload_out[15:0] = {packet_data[7:0], packet_data[15:8]};
      end else if (debug == 1'b1 && state == 3'b010) begin
         payload_out[15:0] = {packet_data[7:0], packet_data[15:8]};
      end else if (debug == 1'b1 && state != 3'b010) begin
         payload_out[15:0] = packet_data[15:0];
      end else begin
         payload_out[15:0] = 16'h0000;
      end

      payload_valid = (debug == 1'b0 && state == 3'b010) || debug ? 1'b1 : 1'b0;
   end

endmodule