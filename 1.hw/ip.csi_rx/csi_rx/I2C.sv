module I2C(
   input  logic        clk_ext,
   input  logic        strobe,
   input  logic        reset,
   input  logic        enable,
   input  logic        read_write,
   input  logic [6:0]  slave_address,
   input  logic [15:0] register_address,
   input  logic [7:0]  data_in,
	
   input  logic        scl_do,
   input  logic        sda_do,
   
   output logic        scl_di,
   output logic        scl_oe,
   output logic        sda_di,
   output logic        sda_oe,
   output logic        register_done
);

   typedef enum logic [3:0] {
      IDLE               = 4'd0,
      START              = 4'd1,
      WRITE_SLAVE_ADDR   = 4'd2,
	  CHECK_ACK          = 4'd3,
	  WRITE_REG_ADDR_MSB = 4'd4,
	  WRITE_REG_ADDR     = 4'd5,
	  WRITE_REG_DATA     = 4'd6,
	  STOP               = 4'd7,
      RESTART            = 4'd8
   } state_type;
   
   state_type state;
   state_type post_state;
   
   logic [1:0] process_counter;
   logic [7:0] slave_address_plus_rw;
   logic [3:0] bit_counter;
   logic       post_serial_data;
   logic       acknowledge_bit;
   
   assign scl_oe = (state == IDLE || process_counter == 2'd1 || process_counter == 2'd2) ? 1'b1 : 1'b0;
   assign sda_oe = (state == IDLE || state == CHECK_ACK) ? 1'b1 : 1'b0;
   
   always_ff @(posedge clk_ext or posedge reset) begin
      if (reset == 1'b1) begin
	     register_done         <= 1'b0;
         state                 <= IDLE;
         post_state            <= IDLE;
         process_counter       <= '0;
		 slave_address_plus_rw <= '0;
		 bit_counter           <= '0;
		 post_serial_data      <= 1'b0;
		 acknowledge_bit       <= 1'b0;
      end else begin
         unique case (state)
		    IDLE: begin
               process_counter       <= '0;
			   bit_counter           <= '0;
			   acknowledge_bit       <= 1'b0;
			   slave_address_plus_rw <= {slave_address, read_write};
               scl_di                <= 1'b1;
               sda_di                <= 1'b1;

               if (enable == 1'b1) begin
			      register_done <= 1'b0;
                  state         <= START;
                  post_state    <= WRITE_SLAVE_ADDR;
               end
            end
			START: begin
               if (strobe == 1'b1) begin
                  unique case (process_counter)
                     2'd0: begin
                        process_counter <= 2'd1;
                     end
                     2'd1: begin
                        sda_di          <= 1'b0;
                        process_counter <= 2'd2;
                     end
                     2'd2: begin
                        bit_counter     <= 4'd8;
                        process_counter <= 2'd3;
                     end
                     2'd3: begin
                        scl_di          <= 1'b0;
                        process_counter <= 2'd0;
                        state           <= post_state;
                        sda_di          <= slave_address_plus_rw[3'd7];
                     end
                  endcase
               end
            end
			WRITE_SLAVE_ADDR: begin
			   if (strobe == 1'b1) begin
                  unique case (process_counter)
                     2'd0: begin
                        scl_di          <= 1'b1;
                        process_counter <= 2'd1;
                     end
                     2'd1: begin
                        //check for clock stretching
                        if (scl_do == 1'b1) begin
                           process_counter <= 2'd2;
                        end
                     end
                     2'd2: begin
                        scl_di          <= 1'b0;
                        bit_counter     <= bit_counter - 4'd1;
                        process_counter <= 2'd3;
                     end
                     2'd3: begin
                        if (bit_counter == 4'd0) begin
						   post_serial_data <= register_address[4'd15];
						   
                           state            <= CHECK_ACK;
                           post_state       <= WRITE_REG_ADDR_MSB;
                           bit_counter      <= 4'd8;
                        end
                        else begin
                           sda_di <= slave_address_plus_rw[bit_counter - 4'd1];
                        end
                        process_counter <= 2'd0;
                     end
                  endcase
               end
			end
			CHECK_ACK: begin
			   if (strobe == 1'b1) begin
                  unique case (process_counter)
                     2'd0: begin
                        scl_di          <= 1'b1;
                        process_counter <= 2'd1;
                     end
                     2'd1: begin
                        //check for clock stretching
                        if (scl_do == 1'b1) begin
                           process_counter <= 2'd2;
                        end
                     end
                     2'd2: begin
                        scl_di <= 1'b0;

                        if (sda_do == 1'b0) begin
                           acknowledge_bit <= 1'b1;
                        end
                        process_counter <= 2'd3;
                     end
                     2'd3: begin
                        if (acknowledge_bit == 1'b1) begin
                           acknowledge_bit <= 1'b0;
                           sda_di          <= post_serial_data;
                           state           <= post_state;
                        end
                        else begin
                           state <= RESTART;
                        end
                        process_counter <= 2'd0;
                     end
                  endcase
               end
			end
			WRITE_REG_ADDR_MSB: begin
			   if (strobe == 1'b1) begin
                  unique case (process_counter)
                     2'd0: begin
                        scl_di          <= 1'b1;
                        process_counter <= 2'd1;
                     end
                     2'd1: begin
                        //check for clock stretching
                        if (scl_do == 1'b1) begin
                           process_counter <= 2'd2;
                        end
                     end
                     2'd2: begin
                        scl_di          <= 1'b0;
                        bit_counter     <= bit_counter - 4'd1;
                        process_counter <= 2'd3;
                     end
                     2'd3: begin
                        if (bit_counter == 4'd0) begin
						   post_serial_data <= register_address[4'd7];
						   //sda_di           <= 1'b0; //mislim da je ovo viška, nepotrebno
                           state            <= CHECK_ACK;
                           post_state       <= WRITE_REG_ADDR;
                           bit_counter      <= 4'd8;
                        end
                        else begin
                           sda_di <= register_address[bit_counter + 4'd7];
                        end
                        process_counter <= 2'd0;
                     end
                  endcase
               end
			end
			WRITE_REG_ADDR: begin
			   if (strobe == 1'b1) begin
                  unique case (process_counter)
                     2'd0: begin
                        scl_di          <= 1'b1;
                        process_counter <= 2'd1;
                     end
                     2'd1: begin
                        //check for clock stretching
                        if (scl_do == 1'b1) begin
                           process_counter <= 2'd2;
                        end
                     end
                     2'd2: begin
                        scl_di          <= 1'b0;
                        bit_counter     <= bit_counter - 4'd1;
                        process_counter <= 2'd3;
                     end
                     2'd3: begin
                        if (bit_counter == 4'd0) begin
						   if (read_write == 1'b0) begin
						      post_serial_data <= data_in[4'd7];
                              post_state       <= WRITE_REG_DATA;
						   end
						   else begin
						      //post_state <= RESTART; //u slu�?aju �?itanja podataka
						      post_serial_data <= 1'b1;
						   end

                           state       <= CHECK_ACK;
                           bit_counter <= 4'd8;
                        end
                        else begin
                           sda_di <= register_address[bit_counter - 4'd1];
                        end
                        process_counter <= 2'd0;
                     end
                  endcase
               end
			end
			WRITE_REG_DATA: begin
			   if (strobe == 1'b1) begin
                  unique case (process_counter)
                     2'd0: begin
                        scl_di          <= 1'b1;
                        process_counter <= 2'd1;
                     end
                     2'd1: begin
                        //check for clock stretching
                        if (scl_do == 1'b1) begin
                           process_counter <= 2'd2;
                        end
                     end
                     2'd2: begin
                        scl_di          <= 1'b0;
                        bit_counter     <= bit_counter - 4'd1;
                        process_counter <= 2'd3;
                     end
                     2'd3: begin
                        if (bit_counter == 4'd0) begin
						   post_serial_data <= 1'b0;
                           state            <= CHECK_ACK;
                           post_state       <= STOP;
                           bit_counter      <= 4'd8;
                           //register_done    <= 1'b1;
                        end
                        else begin
                           sda_di <= data_in[bit_counter - 4'd1];
                        end
                        process_counter <= 2'd0;
                     end
                  endcase
               end
			end
			STOP: begin
			   if (strobe == 1'b1) begin
                  unique case (process_counter)
                     2'd0: begin
                        scl_di          <= 1'b1;
                        process_counter <= 2'd1;
                     end
                     2'd1: begin
                        //check for clock stretching
                        if (scl_do == 1'b1) begin
                           process_counter <= 2'd2;
                        end
                     end
                     2'd2: begin
                        sda_di          <= 1'b1;
                        process_counter <= 2'd3;
                        register_done   <= 1'b1;
                     end
                     2'd3: begin
                        state <= IDLE;
                     end
                  endcase
               end
			end
            RESTART: begin
               if (strobe == 1'b1) begin
                  unique case (process_counter)
                     2'd0: begin
                        scl_di          <= 1'b1;
                        process_counter <= 2'd1;
                     end
                     2'd1: begin
                        //check for clock stretching
                        if (scl_do == 1'b1) begin
                           process_counter <= 2'd2;
                        end
                     end
                     2'd2: begin
                        sda_di          <= 1'b1;
                        process_counter <= 2'd3;
                     end
                     2'd3: begin
                        state <= IDLE;
                     end
                  endcase
               end
            end
		 endcase
      end
   end
   
   
endmodule