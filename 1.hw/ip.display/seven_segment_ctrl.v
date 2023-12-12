// 7-segment display controller on Basys  3 FPGA
module seven_segment_ctrl (
	input clk, 				// 100 Mhz clock source on Basys 3 FPGA
	input reset, 						// reset
	input [15:0] number,
	output reg [3:0] anodes, 			// anode signals of the 7-segment LED display
	output reg [7:0] cathodes			// cathode patterns of the 7-segment LED display
);

    reg [3:0] bcd;
    reg [19:0] counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [1:0] led_counter; 

    always @(posedge clk or posedge reset)
    begin 
        if(reset==1)
            counter <= 0;
        else
            counter <= counter + 1;
    end 
	
	
    assign led_counter = counter[19:18];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(led_counter)
        2'b00: begin
			// activate LED1 and Deactivate LED2, LED3, LED4
            anodes = 4'b0111;             
			// the first digit of the 16-bit number
            bcd = number/1000;            
			end
        2'b01: begin
			// activate LED2 and Deactivate LED1, LED3, LED4
            anodes = 4'b1011;             
			// the second digit of the 16-bit number
            bcd = (number % 1000)/100;            
			end
        2'b10: begin
			// activate LED3 and Deactivate LED2, LED1, LED4
            anodes = 4'b1101;
			// the third digit of the 16-bit number
            bcd = ((number % 1000)%100)/10;            
			end
        2'b11: begin
			// activate LED4 and Deactivate LED2, LED3, LED1
            anodes = 4'b1110;
            // the fourth digit of the 16-bit number    
			bcd = ((number % 1000)%100)%10;
			end
        endcase
    end
	///////////
	//   a   //
	// f   b //
	//   g   //
	// e   c //
	//   d	 //
	///////////
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
		cathodes[7] = 1'b1;
        case(bcd)                // abcdefg
        4'b0000: cathodes[6:0] = 7'b0000001; // "0" 
        4'b0001: cathodes[6:0] = 7'b1001111; // "1" 
        4'b0010: cathodes[6:0] = 7'b0010010; // "2" 
        4'b0011: cathodes[6:0] = 7'b0000110; // "3" 
        4'b0100: cathodes[6:0] = 7'b1001100; // "4" 
        4'b0101: cathodes[6:0] = 7'b0100100; // "5" 
        4'b0110: cathodes[6:0] = 7'b0100000; // "6" 
        4'b0111: cathodes[6:0] = 7'b0001111; // "7" 
        4'b1000: cathodes[6:0] = 7'b0000000; // "8" 
        4'b1001: cathodes[6:0] = 7'b0000100; // "9" 
        default: cathodes[6:0] = 7'b0000001; // "0" 
        endcase
	end

 endmodule

