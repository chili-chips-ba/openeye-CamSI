`timescale 1ns / 1ps

//localparam true =  1'b1;
//localparam false = 1'b0;

module csi_rx_top #(
   parameter dphy_term_en = "TRUE",
   parameter d0_invert = 1'b0,
   parameter d1_invert = 1'b1,
   parameter d0_skew = 0,
   parameter d1_skew = 0,

   parameter int video_hlength = 4041,    // Total visible and blanking pixels per line
   parameter int video_vlength = 2992,    // Total visible and blanking lines per frame

   parameter bit video_hsync_pol = 1'b1,  // HSYNC polarity: 1 for positive sync, 0 for negative sync
   parameter int video_hsync_len = 48,    // Horizontal sync length in pixels
   parameter int video_hbp_len = 122,     // Horizontal back porch length (excluding sync)
   parameter int video_h_visible = 3840,  // Number of visible pixels per line

   parameter bit video_vsync_pol = 1'b1,  // VSYNC polarity: 1 for positive sync, 0 for negative sync
   parameter int video_vsync_len = 3,     // Vertical sync length in lines
   parameter int video_vbp_len = 23,      // Vertical back porch length (excluding sync)
   parameter int video_v_visible = 2160,  // Number of visible lines per frame

   parameter int pixels_per_clock = 2     // Number of pixels per clock to output; 1, 2, or 4
)(
   inout  wire pad_sda,
   inout  wire pad_scl,
   
   input  logic [1:0]  dphy_clk,          // clock lane (1 is P, 0 is N)
   input  logic [1:0]  dphy_d0,           // data lanes (1 is P, 0 is N)
   input  logic [1:0]  dphy_d1,
   
   input  logic        clk_ext,      // reference clock for clock detection and IDELAYCTRLs (nominally ~200MHz)
   input  logic        reset,             // active high synchronous reset in   

   output logic cam_en,

   output logic led1,
   output logic led2,
   output logic led3,
   
   output logic temp1 
   
   //output logic [31:0] packet_payload,
   //output logic packet_payload_valid,
   
   //output logic video_hsync,
   //output logic video_vsync,
   //output logic video_den,
   //output logic video_line_start, // like hsync but asserted for only one clock cycle and only for visible lines
   //output logic video_odd_line, // LSB of y-coordinate for a downstream debayering block
   //output logic [(8 * pixels_per_clock) - 1 : 0] video_data, // LSW is the leftmost pixel
   //output logic [(8 * pixels_per_clock) - 1 : 0] video_prev_line_data // data from the last line at this point, for use in a debayering block

   );
   
   logic clk_temp;
   logic ref_clock_in;
   fpga_pll temp(.clk_in(clk_ext), .clk_out0(clk_temp), .clk_out1(ref_clock_in)); //clk_temp = 228MHz, ref_clock_in = 200MHz
       
   logic        strobe_400kHz;
   logic [6:0]  counter;
   
   logic        clk_10MHz;
   logic [2:0]  counter_10MHz;
   
   always_ff @(posedge reset or posedge clk_ext) begin
      if (reset == 1'b1) begin
         counter_10MHz       <= '0;
         clk_10MHz           <= 1'b0;
      end else begin
         counter_10MHz <= counter_10MHz + 3'd1; 
         if (counter_10MHz >= 3'd5) begin
            counter_10MHz <= '0;
            clk_10MHz     <= ~clk_10MHz;
         end
      end
   end

   always_ff @(posedge reset or posedge clk_ext) begin
      if (reset == 1'b1) begin
         counter       <= '0;
         strobe_400kHz <= 1'b0;
      end else begin
         counter <= counter + 7'd1; 
         if (counter >= 7'd124) begin
            counter       <= '0;
            strobe_400kHz <= 1'b1;
         end else begin
            strobe_400kHz <= 1'b0;
         end
      end
   end
   
   logic        enable_i2c;
   logic        read_write;
   logic [6:0]  slave_address;
   logic [15:0] register_address;
   logic [7:0]  data_in;
   
   logic        scl_do;
   logic        sda_do;
   
   logic        scl_di;
   logic        scl_oe;
   logic        sda_di;
   logic        sda_oe;
   
   logic        register_done;
   
   I2C i2c (
      .clk_ext(clk_ext),
      .strobe(strobe_400kHz),
      .reset(reset),
      .enable(enable_i2c),
      .read_write(read_write),
      .slave_address(slave_address),
      .register_address(register_address),
      .data_in(data_in),

      .scl_do(scl_do),
      .sda_do(sda_do),
      
      .scl_di(scl_di),
      .scl_oe(scl_oe),
      .sda_di(sda_di),
      .sda_oe(sda_oe),

      .register_done(register_done)
   );
   
   logic        enable_csi;
   
   logic [6:0]  reg_counter;
   logic        reg_counter_done;
   logic [23:0] data_init [0:54];
   
   initial $readmemh("I2C_init.mem", data_init);

   always_ff @(posedge reset or posedge clk_ext) begin
      if(reset == 1'b1) begin
//         enable_i2c       <= 1'b0;
         read_write       <= 1'b0;
         slave_address    <= '0;
         register_address <= '0;
         data_in          <= '0;
         reg_counter      <= '0;
         reg_counter_done <= 1'b0;
 
         //scl_do           <= 1'b1;
         //sda_do           <= 1'b0;
      end 
      else begin
         if (reg_counter_done == 1'b0 & strobe_400kHz == 1'b1) begin
//            enable_i2c       <= 1'b1;
            slave_address    <= 7'd16;   
            register_address <= data_init[reg_counter][23:8];
            data_in          <= data_init[reg_counter][7:0];

            if (register_done == 1'd1) begin
               if (reg_counter < 7'd54) begin
                  reg_counter <= reg_counter + 6'd1;
               end
               else begin
                  reg_counter_done <= 1'b1;
//                  enable_i2c       <= 1'b0;
               end
            end
         end    
      end
   end

   IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF_sda (
      .O(sda_do),     // Buffer output
      .IO(pad_sda),   // Buffer inout port (connect directly to top-level port)
      .I(sda_di),     // Buffer input
      .T(sda_oe)      // 3-state enable input, high=input, low=output
   );
   
   IOBUF #(
      .DRIVE(12), // Specify the output drive strength
      .IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE"
      .IOSTANDARD("DEFAULT"), // Specify the I/O standard
      .SLEW("SLOW") // Specify the output slew rate
   ) IOBUF_scl (
      .O(scl_do),     // Buffer output
      .IO(pad_scl),   // Buffer inout port (connect directly to top-level port)
      .I(scl_di),     // Buffer input
      .T(scl_oe)      // 3-state enable input, high=input, low=output
   );
   
   logic wait_for_sync;
   logic packet_done;
   logic link_reset_out;                       // reset output based on clock detection
   logic csi_byte_clock;                       // divided word clock output   
   logic [15:0] word_data;
   logic word_valid;
   logic load;
   
   csi_rx_2_lane_link #(
      .dphy_term_en(dphy_term_en),
      .d0_invert(d0_invert),
      .d1_invert(d1_invert),
      .d0_skew(d0_skew),
      .d1_skew(d1_skew)
   ) link (
      .dphy_clk     (dphy_clk),
      .dphy_d0      (dphy_d0),
      .dphy_d1      (dphy_d1),
      .ref_clock    (ref_clock_in),
      .reset        (reset),
      .enable       (1'b1),
      .load         (load),
      .wait_for_sync(wait_for_sync),
      .packet_done  (packet_done),
      .reset_out    (link_reset_out),
      .byte_clock   (csi_byte_clock),
      .word_data    (word_data),
      .word_valid   (word_valid)
   );
   
   logic [31:0] packet_payload;
   logic packet_payload_valid;
   logic sync_seq;
   logic csi_in_frame;
   logic csi_in_line;
   logic ecc_out;
   
   csi_rx_packet_handler depacket (
      .clock(csi_byte_clock),
      .reset(link_reset_out),
      .enable(1'b1),
      .data(word_data),
      .data_valid(word_valid),
      .sync_wait(wait_for_sync),
      .packet_done(packet_done),
      .payload_out(packet_payload),
      .payload_valid(packet_payload_valid),
      .sync_seq(sync_seq),
      .in_frame(csi_in_frame),
      .in_line(csi_in_line),
      .ecc_out(ecc_out)
   );
/*   
   logic video_hsync;
   logic video_vsync;
   logic video_den;
   logic video_line_start;
   logic video_odd_line;
   logic [(8 * pixels_per_clock) - 1 : 0] video_data;
   logic [(8 * pixels_per_clock) - 1 : 0] video_prev_line_data;
   
   csi_rx_video_output #(
      .video_hlength(video_hlength),
      .video_vlength(video_vlength),
      .video_hsync_pol(video_hsync_pol),
      .video_hsync_len(video_hsync_len),
      .video_hbp_len(video_hbp_len),
      .video_h_visible(video_h_visible),
      .video_vsync_pol(video_vsync_pol),
      .video_vsync_len(video_vsync_len),
      .video_vbp_len(video_vbp_len),
      .video_v_visible(video_v_visible),
      .pixels_per_clock(pixels_per_clock)
   ) vout (
      .output_clock(pixel_clock_in),
      .csi_byte_clock(csi_byte_clock),
      .enable(enable),
      .reset(reset),
      .pixel_data_in(unpack_data),
     .pixel_data_valid(unpack_data_valid),
      .csi_in_frame(csi_in_frame),
      .csi_in_line(csi_in_line),
      .csi_vsync(csi_vsync),
      // .video_valid(video_valid),
      .video_hsync(video_hsync),
      .video_vsync(video_vsync),
      .video_den(video_den),
      .video_line_start(video_line_start),
      .video_odd_line(video_odd_line),
      .video_data(video_data),
      .video_prev_line_data(video_prev_line_data)
   );*/
   
   
    assign cam_en = enable_csi;
    // Constants (parameters) to create the frequencies needed:
    // Input clock is 100.0 MHz, system clock.
    // Formula is: (100000 KHz / 1 Hz) * 50% duty cycle    
    // So for 1/2 Hz: (100000000 / 1) * 0.5 = 50000000, Input clock is generated 100MHz        
    parameter c_CNT_CLK_HZ = 50000000;        
    // These signals will be the counters:        
    reg [31:0] r_CNT_CLK_HZ = 0;       
    // These signals will toggle at the frequencies needed:          
    reg r_CLK_1HZ       = 1'b0;   
    reg [3:0] r_delay   = 0;   
    always @(posedge clk_ext)  
    begin     
        if(reset == 1'b1) begin
            enable_csi <= 1'b0;
            r_CNT_CLK_HZ <= 0;
            r_delay <= 0; 
        end else if (r_CNT_CLK_HZ == c_CNT_CLK_HZ-1) begin// -1, since counter starts at 0                
            r_CLK_1HZ <= !r_CLK_1HZ;
            r_CNT_CLK_HZ <= 0;            
            if(r_delay < 8 ) begin
                r_delay = r_delay + 1;
                if(r_delay >= 2) begin // Omogućiti CMOS napajanje nakon dvije sekunde po power_up-u, dok se smiri napajanje, ovo su reda milisekunde ali mi bilo lakše iskoristiti ovaj timer za testiranje
                    enable_csi <= 1'b1;
                end
                if(r_delay >= 4) begin // Nakon 4 sekunde palimo I2C inicijalizaciju
                    enable_i2c <= 1'b1;
                end                
            end
        end else
            r_CNT_CLK_HZ <= r_CNT_CLK_HZ + 1;            
    end                                   
    //------------------------------------------------------------------------------ 
      
    
   /*assign temp1 = clk_temp;
   assign temp2 = wait_for_sync;     */
   
   assign led1 = clk_temp;
   assign temp1 = csi_byte_clock;
   assign led2 = wait_for_sync; 
   assign led3 = link_reset_out; //Low LED light
endmodule
