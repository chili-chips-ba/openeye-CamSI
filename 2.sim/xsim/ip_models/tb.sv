`timescale 1ns / 1ps

module tb;

logic clk_100;
logic reset_ext;

initial begin
    clk_100 <= 0;
    forever #(5) clk_100 <= ~clk_100;
end        
initial begin
    reset_ext = 1;
    #(150) reset_ext = 0;
end        


// PLL
fpga_pll_hdmi fpga_pll_hdmi (
    .clk_ext(clk_100),     // 100MHz

    .srst_n(), // LOCK = 5707.5 ns
     // 11613 ps -> (100 / 3) * 38.750 / 15 = 86.11 MHz
     .clk_pix(),     // 5x pixel clock: 371.25MHz (or 666.66MHz)
     // 2323 ps -> (100 / 3) * 38.750 / 3 = 430.5556 MHz
    .clk_pix5()     // pixel clock: 74.25MHz (or 133.32MHz)
);


fpga_pll_top fpga_pll_top (
    .areset(reset_ext),  // active-1 async reset
    .clk_in(clk_100),  // 100MHz
   
    .srst(), // LOCK = 9258.75 ns
    // 4386ps -> (100 / 5) * 49.875 / 4.375 = 228 MHz
    .clk_out0(),
    // 5012ps  -> (100 / 5) * 49.875 / 5 = 199.5 MHz
    .clk_out1() // ~200MHz
);

// ISERDES
logic clk_12p5;
logic dphy_hs;


initial begin
    clk_12p5 <= 0;
    forever begin
        repeat(4) @(posedge clk_100);
        #(0.0001) clk_12p5 <= ~clk_12p5;
    end
end        

initial begin
    dphy_hs = 0;
    repeat (42) @(clk_100);
    for (int i=0; i<100; i++) repeat (5) Send(i*3);
    
    @(clk_100);
    dphy_hs <= 0;
    repeat (200) @(clk_100);
    $finish;
end        



csi_rx_phy_dat #(.INVERT(0), .DELAY(3)) csi_rx_phy_dat (
   .bit_clock(clk_100),     // DDR bit clocks, buffered from D-PHY clock
   .byte_clock(clk_12p5),   // byte clock = input clock /4

   .reset(reset_ext),       // async reset, sync'd internally to byte clock
   .enable(1),              // active-1 enable for SERDES

   .dphy_hs({dphy_hs, ~dphy_hs}),                // lane input: [1]=P; [0]=N
   .deser_out()             // deserialised byte output
);

logic P, N;
logic [7:0] S, S1, S2, Z;
always @(posedge clk_100) P <= csi_rx_phy_dat.in_delayed;
always @(negedge clk_100) N <= csi_rx_phy_dat.in_delayed;
always @(posedge clk_100) S <= {N, P, S[7:2]};
always @(posedge clk_100) S1 <= S;
always @(posedge clk_100) S2 <= S1;
always @(posedge clk_12p5) Z <= S2;
always @(posedge clk_12p5) $display(S, S1, S2, Z);

task Send(input [7:0] s);
    for (int i=0; i<8; i++) @(clk_100) dphy_hs <= s[i];
endtask

endmodule
