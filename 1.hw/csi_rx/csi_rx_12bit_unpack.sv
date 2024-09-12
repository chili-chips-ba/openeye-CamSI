module csi_rx_12bit_unpack 
   import top_pkg::*;
(
   input  logic        clock,      // byte clock in
   input  logic        reset,      // active-1 synchronous reset
   input  logic        enable,     // active-1 enable

   input  logic [31:0] data_in,    // packet payload in from packet handler
   input  logic        din_valid,  // payload in valid from packet handler

   output lane_raw_data_t data_out,   // unpacked data out
   output logic        dout_valid  // data out valid (see above)
);

   logic [47:0] dout_int;
   logic [47:0] dout_unpacked;

   logic [31:0] bytes_int;
   logic [1:0]  byte_count_int;

   logic dout_valid_int;
   logic dout_valid_up;

   // Unpack CSI packed 10-bit to 4 sequential 10-bit pixels
   function logic [47:0] mipi12_unpack(input logic [47:0] packed_data);
      logic [47:0] result;
      result[11:0]  = {packed_data[7:0],   packed_data[19:16]};
      result[23:12] = {packed_data[15:8],  packed_data[23:20]};
      result[35:24] = {packed_data[31:24], packed_data[43:40]};
      result[47:36] = {packed_data[39:32], packed_data[47:44]};
      return result;
   endfunction

   always_ff @(posedge clock or posedge reset) begin
      if (reset == 1'b1) begin
         dout_int       <= '0;
         byte_count_int <= '0;
         dout_valid_int <= 1'b0;
      end else if (enable == 1'b1) begin
         if (din_valid == 1'b1) begin
               case (byte_count_int)
                  0: begin
                     dout_int       <= '0;
                     byte_count_int <= 3'd2;
                     dout_valid_int <= 1'b0;
                     bytes_int      <= data_in;
                  end
                  1: begin
                     dout_int       <= {data_in[31:0], bytes_int[15:0]};
                     byte_count_int <= 3'd0;
                     dout_valid_int <= 1'b1;
                     bytes_int      <= '0;
                  end
                  2: begin
                     dout_int       <= {data_in[15:0], bytes_int[31:0]};
                     byte_count_int <= 3'd1;
                     dout_valid_int <= 1'b1;
                     bytes_int      <= {16'd0, data_in[31:16]};
                  end
               endcase
         end else begin
               byte_count_int <= '0;
               dout_valid_int <= 1'b0;
         end
         dout_unpacked <= mipi12_unpack(dout_int);  // Use 12-bit unpacking function
         dout_valid_up <= dout_valid_int;
         data_out      <= dout_unpacked;
         dout_valid    <= dout_valid_up;
      end
   end
endmodule
