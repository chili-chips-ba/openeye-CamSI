//MIPI CSI-2 Rx 2 lane link layer

//This combines the clock and data PHYs; byte aligners and word aligner to
//form the lower levels of the CSI Rx link layer

module csi_rx_2_lane_link #(
   parameter dphy_term_en = 1'b0,
   parameter d0_invert = 1'b0,
   parameter d1_invert = 1'b0,
   parameter d0_skew = 0,
   parameter d1_skew = 0,
   parameter generate_idelayctrl = 1'b1
)(
   input  logic [1:0]  dphy_clk,      // clock lane (1 is P, 0 is N)
   input  logic [1:0]  dphy_d0,       // data lanes (1 is P, 0 is N)
   input  logic [1:0]  dphy_d1,
   
   input  logic [4:0]  skew_d0,
   input  logic [4:0]  skew_d1,
           
   input  logic        ref_clock,     // reference clock for clock detection and IDELAYCTRLs (nominally ~200MHz)
                   
   input  logic        reset,         // active high synchronous reset in        
   input  logic        enable,        // active high enable out
   input  logic        load,
   input  logic        wait_for_sync, // sync wait signal from packet handler
   input  logic        packet_done,   // packet done signal from packet handler
   output logic        reset_out,     // reset output based on clock detection
   output logic        byte_clock,    // divided byte clock output
   output logic [15:0] word_data,     // aligned word data output
   output logic        word_valid,    // whether or not above data is synced and aligned
   output logic [7:0]  delay_d0_out,  // aligned word data output
   output logic [7:0]  delay_d1_out   // aligned word data output
);

   logic        bit_clock;    
   logic        byte_clock_int;
   logic        word_clock_int;
   logic        serdes_reset;

   logic [15:0] deser_data;    
   logic [15:0] byte_align_data;
   logic [1:0]  byte_valid;
   logic [15:0] word_align_data;
   
   logic [4:0]  cnt_value_out0;
   logic [4:0]  cnt_value_out1;

   logic        byte_packet_done;

   logic [4:0] delay_in = 5'd0;
   logic [4:0] delay_out;
   
   csi_rx_hs_clk_phy #(
      .term_en(dphy_term_en)
   ) clkphy_inst (   
      .dphy_clk(dphy_clk),
      .reset(reset),
      .bit_clock(bit_clock),        
      .byte_clock(byte_clock_int)
   );

   csi_rx_clock_det clkdet_inst (
      .ref_clock(ref_clock),
      .ext_clock(byte_clock_int),
      .enable(enable),
      .reset_in(reset),        
      .reset_out(serdes_reset)
   );
   
   csi_rx_hs_lane_phy #(
      .invert(d0_invert),
      .term_en(dphy_term_en),
      .delay(d0_skew)
   ) d0phy_inst (
      .bit_clock(bit_clock),        
      .byte_clock(byte_clock_int),        
      .enable(enable),
      .reset(serdes_reset),
      .load(load),        
      .delay_in(delay_in),
      .delay_out(delay_out), 
      .dphy_hs(dphy_d0),  
      .deser_out(deser_data[7:0])       
   );

   csi_rx_hs_lane_phy #(
      .invert(d1_invert),
      .term_en(dphy_term_en),
      .delay(d1_skew)
   ) d1phy_inst (
      .bit_clock(bit_clock),        
      .byte_clock(byte_clock_int),
      .enable(enable),
      .reset(serdes_reset),
      .dphy_hs(dphy_d1),   
      .load(load),    
      .delay_in(delay_in),
      .delay_out(delay_out),    
      .deser_out(deser_data[15:8])        
   );
   
   csi_rx_byte_align ba0_inst (
      .clock(byte_clock_int),
      .reset(serdes_reset),
      .enable(enable),
      .deser_in(deser_data[7:0]),
      .wait_for_sync(wait_for_sync),
      .packet_done(byte_packet_done),
      .valid_data(byte_valid[0]),
      .data_out(byte_align_data[7:0])
   );

   csi_rx_byte_align ba1_inst (
      .clock(byte_clock_int),
      .reset(serdes_reset),
      .enable(enable),
      .deser_in(deser_data[15:8]),
      .wait_for_sync(wait_for_sync),
      .packet_done(byte_packet_done),
      .valid_data(byte_valid[1]),
      .data_out(byte_align_data[15:8])
   );
   
   csi_rx_word_align wordalign_inst (
      .byte_clock(byte_clock_int),
      .reset(serdes_reset),
      .enable(enable),
      .packet_done(packet_done),
      .wait_for_sync(wait_for_sync),
      .packet_done_out(byte_packet_done),
      .word_in(byte_align_data),
      .valid_in(byte_valid),
      .word_out(word_align_data),
      .valid_out(word_valid)
   );

   assign byte_clock = byte_clock_int;
   assign word_data  = word_align_data;    
   assign reset_out  = serdes_reset;

   if (generate_idelayctrl == 1'b1) begin
      csi_rx_idelayctrl_gen idctrl_inst (
         .ref_clock(ref_clock),
         .reset(reset)
      );
   end

endmodule
