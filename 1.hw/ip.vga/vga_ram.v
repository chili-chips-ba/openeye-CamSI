
module vga_ram (
    input clk,	
	input wen, 
	input [11:0] waddr,
	input [11:0] wdata,	
    input ren,	
	input [11:0] raddr,		    	
    output reg [11:0] rdata
);
	//parameter MEM_INIT_FILE = "vid_ram.mem";
	(* ram_style = "distributed" *) reg [11:0] ram [0:4095];   //  memory for 16 character with dimension 16x16 pixels @ 12bpp
	
	//initial
	//if (MEM_INIT_FILE != "")
	//	$readmemh(MEM_INIT_FILE, ram);
		
    always @(posedge clk) 
	begin
		if (ren)
			rdata <= ram[raddr];
	end		
			
    always @(posedge clk) 
	begin			
		if (wen)
			ram[waddr] <= wdata;
    end
	
endmodule
