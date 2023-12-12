
module vga_map_ram (
    input clk,	
	input wen, 
	input [11:0] waddr,
	input [3:0] wdata,	
    input ren,	
	input [11:0] raddr,		    	
    output reg [3:0] rdata
);
	//parameter MEM_INIT_FILE = "vid_ram.mem";
	(* ram_style = "block" *) reg [3:0] map_ram [0:1199];   // memory for 40 x 30 position mega character with value between 0-15 for character id
	
	//initial
	//if (MEM_INIT_FILE != "")
	//	$readmemh(MEM_INIT_FILE, map_ram);
		
    always @(posedge clk) 
	begin
		if (ren)
			rdata <= map_ram[raddr];
	end		
			
    always @(posedge clk) 
	begin			
		if (wen)
			map_ram[waddr] <= wdata;
    end
	
endmodule
