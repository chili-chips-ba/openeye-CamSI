`timescale 1ns / 1ps

module vga_wrapper (
    input clk,	
	input reset,        // system reset	

	output reg vga_iomem_ready,
	input iomem_valid,
	input iomem_ready,
	input [3:0]  iomem_wstrb,
	input [31:0] iomem_addr,
	input [31:0] iomem_wdata,	
	
    input video_on,
    input [9:0] x, y,
    output reg [11:0] rgb,
	
	output[4:0]   o_debug_pins
);
    
    // signal declarations
	wire charset_on, charset_on1, charset_on2;	
	reg char_mem_write, map_mem_write;
	wire [11:0] write_address;    
	wire [11:0] read_address, map_read_address;
	wire [11:0] rgb_rdata;
	wire [3:0] map_rdata;		
	
	always @(posedge clk) 
	begin
		if (reset) begin			
			char_mem_write <= 0;	
			map_mem_write <= 0;
		end else begin
			vga_iomem_ready <= 0;
			char_mem_write <= 0;
			map_mem_write <= 0;
			if (iomem_valid && !iomem_ready) begin
				vga_iomem_ready <= 1;				
				if(iomem_addr[23:20]==4'h1) begin
					if(iomem_wstrb[0]) begin
						char_mem_write <= 1;						
					end				
				end else if(iomem_addr[23:20]==4'h2) begin
					if(iomem_wstrb[0]) begin
						map_mem_write <= 1;
					end
				end
			end
		end
	end
	
	assign write_address = (iomem_addr[15:0]/4);
	assign read_address = {map_rdata, y[3:0], x[3:0]};
	assign map_read_address = ( y >> 4 ) * 6'd40 + ( x >> 4 );

	vga_map_ram map(
		.clk(clk),
		.wen(map_mem_write),			
		.waddr(write_address),		
		.wdata(iomem_wdata[3:0]),
		.ren(video_on), 
		.raddr(map_read_address), 
		.rdata(map_rdata)
	);
	
	vga_ram ram(
		.clk(clk),
		.wen(char_mem_write),			
		.waddr(write_address),		
		.wdata(iomem_wdata[11:0]),
		.ren(video_on), 
		.raddr(read_address), 
		.rdata(rgb_rdata)
	);
	

    // rgb multiplexing circuit
    always @(*)
	begin
        if(~video_on)
            rgb = 12'h000;      // blank
        else	
			rgb = rgb_rdata;				
	end
	
	assign o_debug_pins = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0};	
	
endmodule
