//MIPI CSI-2 Rx 2 lane link layer

//Simple Clock Detector for CSI-2 Rx

//This is designed to hold the ISERDES in reset until at least 3 byte clock
//cycles have been detected; to ensure proper ISERDES behaviour
//It will reassert reset once the byte clock has not toggled compared to the reference clock
//for at least 200 reference clock cycles

module csi_rx_clock_det (
   input  logic ref_clock,       // reference clock in; must not be synchronised to ext_clock
   input  logic ext_clock,       // external byte clock input for detection
   input  logic enable,          // active high enable
   input  logic reset_in,        // active high asynchronous reset in
   output logic reset_out        // active high reset out to ISERDESs
);

   logic [3:0] count_value;
   logic clk_fail;
   logic ext_clk_lat;
   logic last_ext_clk;
   logic [7:0] clk_fail_count;
   
   always_ff @(posedge ext_clock or posedge reset_in or posedge clk_fail) begin
      if (reset_in == 1'b1 || clk_fail == 1'b1) begin
         count_value <= 4'd0;
      end else if (enable == 1'b1) begin
         if (count_value < 4'd3) begin
            count_value <= count_value + 4'd1;
         end
      end
   end
   
   // Reset in between frames, by detecting the loss of the high speed clock
   always_ff @(posedge ref_clock) begin
      ext_clk_lat  <= ext_clock;
      last_ext_clk <= ext_clk_lat;
      if (last_ext_clk != ext_clk_lat) begin
         clk_fail_count <= 8'd0;
      end else begin
         if (clk_fail_count < 8'd250) begin
            clk_fail_count <= clk_fail_count + 8'd1;
         end
      end
   end
   
   always_comb begin
      clk_fail  = (clk_fail_count >= 8'd200) ? 1'b1 : 1'b0;
      reset_out = (count_value >= 4'd2) ? 1'b0 : 1'b1;
   end

endmodule
