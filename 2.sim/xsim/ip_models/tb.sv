`timescale 1ns / 1ps

module tb;

logic clk_100;
logic reset_ext;

initial begin
    clk_100 = 0;
    forever #(5) clk_100 = ~clk_100;
end        
initial begin
    reset_ext = 1;
    #(150) reset_ext = 0;
end        
initial begin
    #(100000) $finish;
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


endmodule
