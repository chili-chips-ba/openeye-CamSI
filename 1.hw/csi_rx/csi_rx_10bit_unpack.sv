module csi_rx_10bit_unpack 
   import top_pkg::*;
(
   input  logic        clock,      // byte clock in
   input  logic        reset,      // active-1 synchronous reset
   input  logic        enable,     // active-1 enable

   input  logic [31:0] data_in,    // packet payload in from packet handler
   input  logic        din_valid,  // payload in valid from packet handler

   output logic [39:0] data_out,   // unpacked data out
   output logic        dout_valid  // data out valid (see above)
);

   logic [39:0] dout_int;
   logic [39:0] dout_unpacked;

   logic [31:0] bytes_int;
   logic [2:0]  byte_count_int;

   logic dout_valid_int;
   logic dout_valid_up;

   // Unpack CSI packed 10-bit to 4 sequential 10-bit pixels
   function logic [39:0] mipi10_unpack(input logic [39:0] packed_data);
      logic [39:0] result;
      result[9:0]   = {packed_data[7:0],   packed_data[33:32]};
      result[19:10] = {packed_data[15:8],  packed_data[35:34]};
      result[29:20] = {packed_data[23:16], packed_data[37:36]};
      result[39:30] = {packed_data[31:24], packed_data[39:38]};
      return result;
   endfunction

   always_ff @(posedge clock or posedge reset) begin
      if (reset == 1'b1) begin
         dout_int       <= '0;
         byte_count_int <= '0;
         dout_valid_int <= 1'b0;
      end else if (enable == 1'b1) begin
         if (din_valid == 1'b1) begin
               // Behaviour is based on the number of bytes in the buffer
               case (byte_count_int)
                  0: begin
                     dout_int       <= '0;
                     byte_count_int <= 3'd4;
                     dout_valid_int <= 1'b0;
                     bytes_int      <= data_in;
                  end
                  1: begin
                     dout_int       <= {data_in, bytes_int[7:0]};
                     byte_count_int <= 3'd0;
                     dout_valid_int <= 1'b1;
                     bytes_int      <= '0;   
                  end
                  2: begin
                     dout_int       <= {data_in[23:0], bytes_int[15:0]};
                     byte_count_int <= 3'd1;
                     dout_valid_int <= 1'b1;
                     bytes_int      <= {24'd0, data_in[31:24]};
                     
                  end
                  3: begin
                     dout_int       <= {data_in[15:0], bytes_int[23:0]};
                     byte_count_int <= 3'd2;
                     dout_valid_int <= 1'b1;
                     bytes_int      <= {16'd0, data_in[31:16]};
                  end
                  4: begin
                     dout_int       <= {data_in[7:0], bytes_int[31:0]};
                     byte_count_int <= 3'd3;
                     dout_valid_int <= 1'd1;
                     bytes_int      <= {8'd0, data_in[31:8]};  
                  end
               endcase
         end else begin
               byte_count_int <= '0;
               dout_valid_int <= 1'b0;
         end
         dout_unpacked <= mipi10_unpack(dout_int);
         dout_valid_up <= dout_valid_int;
         data_out      <= dout_unpacked;
         dout_valid    <= dout_valid_up;
      end
   end
endmodule
