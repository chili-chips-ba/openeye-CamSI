`timescale 10ns / 1ns

/*
 * Custom TX design, to match the RX module
 * Author: Shubhayu Das
 * Date: 27th November, 2021
 * Version: 1.2
 * Last update: 28th Nov, 2021: Changed order of bytes to big-endian
 *
 ********************
 * Inputs:
 * clk: UART clk, which MUST match the clock on the RX module
 * tx_enable: start transmitting data ASAP
 * data: the actual data to be transmitted
 ******************** 
 * Parameters:
 * FRAME_BITS: Number of data bits per transaction
 * PARITY_BITS: 0/1 indicate odd or even parity, 2 disables parity
 * STOP_BITS: Number of stop bits to send
 * RETENTION_DURATION: Compensate for oversampling UART clock
 *
 ********************
 * Outputs:
 * tx: The TX data line
 * tx_busy: signal to indicate TX line is busy, don't start anything else
 *
 ********************
 * Features of this module:
 *
 * This module automatically compensates for the faster UART clock being used
 * for oversampling in the RX module. This is controlled by the 
 * RETENTION_DURATION" parameter.
 *
 * The input data is sampled as soon as "tx_enable" is set(on the next clock posedge)
 * The input data is stored locally, the source register's value can change
 * freely, without corrupting the TX activity.
 *
 * The data being sent is automatically flipped. So data[7:0] is sent as data[0:7]
*/


module uart_tx #(
    parameter FRAME_BITS = 8,   // Number of data bits, can be 7/8
    PARITY_BIT = 2,             // Parity disabled by default
    STOP_BITS = 1,              // Using only 1 stop bit
    RETENTION_DURATION = 15     // Compensate for oversampling in RX
)(
    input clk,
    input tx_enable,
    input [FRAME_BITS-1:0] data,
    output reg tx,
    output reg tx_busy
);

function integer clog2;
    input integer value;
          integer temp;
    begin
        temp = value - 1;
        for (clog2 = 0; temp > 0; clog2 = clog2 + 1) begin
            temp = temp >> 1;
        end
    end
endfunction

// Knowing how bits need to be sent
localparam N_TX_BITS = (PARITY_BIT < 2) ? 
                        (1+FRAME_BITS+1+STOP_BITS) : (1+FRAME_BITS+STOP_BITS);
localparam INDEX_SIZE = clog2(N_TX_BITS);

// FSM states
localparam IDLE = 0;        // Wait for tx_enable to be set
localparam CAPTURE = 1;     // Copy data into local_data, with parity, stop bits
localparam TRANSMITTING = 2;// Data being put on TX line

reg [2:0] state;
reg data_framed;            // Indicates data has been copied to local_data

reg [INDEX_SIZE:0] bit_index;

reg [0:N_TX_BITS-1] local_data; // local data register

// Keeps TX high for requisite number of cycles
reg [clog2(RETENTION_DURATION):0] retention_counter;


initial begin
    tx = 1;
    tx_busy = 0;
    
    state = IDLE;
    bit_index = 0;
    data_framed = 0;
    local_data = 0;
    
    // This is NOT a mistake
    // This compensates for the immediate addition that happens
    // in "TRANSMITTING" state
    retention_counter = RETENTION_DURATION;
end

// Handle the state changes
always @(posedge clk) begin
    case(state)
        IDLE:
            state <= (tx_enable) ? CAPTURE : IDLE;
        
        CAPTURE:
            state <= (data_framed) ? TRANSMITTING : CAPTURE;
            
        TRANSMITTING:
            state <= (bit_index == N_TX_BITS) ? IDLE : TRANSMITTING;
    endcase 
end

always @(posedge clk) begin
    case(state)
        IDLE: begin
                tx <= 1;
                tx_busy <= 0;
                bit_index <= 0;
                local_data <= 0;
                data_framed <= 0;
                retention_counter <= RETENTION_DURATION;
            end
            
        CAPTURE: begin
            tx_busy <= 1;
            
            // The data needs to be reversed
            if(PARITY_BIT < 2) begin
                local_data <= {
                    1'b0,       // Start bit
                    data[0],    // Reversed data
                    data[1],
                    data[2],
                    data[3],
                    data[4],
                    data[5],
                    data[6],
                    data[7],
                    ^data,      // Parity
                    {(STOP_BITS){1'b1}} // Stop bit(s)
                };
                data_framed <= 1;
            end
            else begin
                // Same as above, but without parity
                local_data <= {
                    1'b0,
                    data[0],
                    data[1],
                    data[2],
                    data[3],
                    data[4],
                    data[5],
                    data[6],
                    data[7],
                    {(STOP_BITS){1'b1}}
                };
                data_framed <= 1;
            end
        end
        
        TRANSMITTING: begin
            if(retention_counter == 0) begin
                tx <= local_data[bit_index];
                bit_index <= bit_index + 1;
                
                if(bit_index == N_TX_BITS)
                    tx_busy <= 0;
                
            end
            
            if(retention_counter < RETENTION_DURATION)
                retention_counter <= retention_counter + 1;
            else
                retention_counter <= 0;
        end
    endcase
end

endmodule
