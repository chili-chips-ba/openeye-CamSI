// SPDX-FileCopyrightText: 2024 Chili.CHIPS*ba
//
// SPDX-License-Identifier: BSD-3-Clause

//======================================================================== 
// openeye-CamSI * NLnet-sponsored open-source core for Camera I/F with ISP
//------------------------------------------------------------------------
//                   Copyright (C) 2024 Chili.CHIPS*ba
// 
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// 1. Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright 
// notice, this list of conditions and the following disclaimer in the 
// documentation and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its 
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//              https://opensource.org/license/bsd-3-clause
//------------------------------------------------------------------------
// Description: RGB-to-UDP Top level
//========================================================================

module rgb2udp_top
   import top_pkg::*;
   import hdmi_pkg::*;   
(
   input  logic      clk,
   input  logic      rst,
   input  logic      enable,
   
   input  logic      in_frame,
   input  logic      in_line, 
   input  logic      rgb_valid,
   input  pix_t      data_in,
   input  logic      data_in_en,      
   
   input  logic      tx_ready,
   output bus16_t    tx_length,
   output bus8_t     tx_data,
   output logic      tx_valid,   
   output logic      tx_last,
   output logic      tx_reset,
   
   output bus8_t     debug
);

   parameter [3:0]   T_STATES_IDLE = 0,
                     T_STATES_INIT = 1,
                     T_STATES_SYNC_FRM1 = 2,
                     T_STATES_SYNC_FRM2 = 3,
                     T_STATES_SYNC_ROW1 = 4,
                     T_STATES_SYNC_ROW2 = 5,
                     T_STATES_ROW_HI = 6,
                     T_STATES_ROW_LO = 7,                     
                     T_STATES_IMAGE_DATA = 9,
                     T_STATES_END = 15;

   parameter [15:0]  C_COL_START = 0;
   parameter [15:0]  C_COL_STOP = 640;
   parameter [15:0]  C_ROW_START = 0;
   parameter [15:0]  C_ROW_STOP = 480;   
   parameter [15:0]  C_PACKET_LENGTH = C_COL_STOP; // 2 byte I_ROW_CNT + 2 byte I_COL_CNT
   
   bus8_t         I_FRAME_CNT;
   bus16_t        I_ROW_CNT;
   bus16_t        I_COL_CNT;
       
   bus4_t         I_CURRENT_STATE;
   bus4_t         I_NEXT_STATE;
   bus8_t         I_TX_FIFO_WRDAT_WORD;
   logic          I_TX_FIFO_WREN_WORD;   
   logic          in_line_dl1, in_line_dl2, in_line_dl3, in_line_dl4;
   logic          in_frame_dl1;
   logic          data_in_en_dl1;
   
   always_ff @(posedge clk)
   begin
      if (rst) begin
         I_CURRENT_STATE <= T_STATES_IDLE;
      end else begin
         case (I_CURRENT_STATE)
            T_STATES_IDLE :
               if (tx_ready && enable && in_frame)
                  I_CURRENT_STATE <= T_STATES_INIT;
               else
                  I_CURRENT_STATE <= T_STATES_IDLE;

            T_STATES_INIT :
               I_CURRENT_STATE <= T_STATES_SYNC_FRM1;
                   
            T_STATES_SYNC_FRM1 :
               I_CURRENT_STATE <= T_STATES_SYNC_FRM2;
                                               
            T_STATES_SYNC_FRM2 :
               I_CURRENT_STATE <= T_STATES_ROW_HI;

            T_STATES_SYNC_ROW1 :
               I_CURRENT_STATE <= T_STATES_SYNC_ROW2;
               
            T_STATES_SYNC_ROW2 :
               I_CURRENT_STATE <= T_STATES_ROW_HI;
                              
            T_STATES_ROW_HI :
               I_CURRENT_STATE <= T_STATES_ROW_LO;
                        
            T_STATES_ROW_LO :
               I_CURRENT_STATE <= T_STATES_IMAGE_DATA;
                                                                                                                                                                               
            T_STATES_IMAGE_DATA :
               if((enable == 1'b1) & (in_frame == 1'b1)) begin
                  if((in_line_dl1 == 1'b0) && (in_line == 1'b1))
//                     I_CURRENT_STATE <= T_STATES_SYNC_ROW1;
//                  else
                     I_CURRENT_STATE <= T_STATES_IMAGE_DATA;
               end else
                  I_CURRENT_STATE <= T_STATES_END;
                 
            T_STATES_END :
               I_CURRENT_STATE <= T_STATES_IDLE;
                     
         endcase
      end
   end
    
   always_ff @(posedge clk)
   begin
      if (rst) begin
         I_FRAME_CNT <= 8'h0;
         in_frame_dl1 <= 1'b0;
      end else begin
         in_frame_dl1 <= in_frame;
         if(in_frame_dl1 == 1'b1 && in_frame == 1'b0) begin
            if(I_FRAME_CNT < 8'd15) begin
               I_FRAME_CNT <= I_FRAME_CNT + 8'd1;
            end else begin
               I_FRAME_CNT <= 8'd0;
            end    
         end            
      end
   end   
   
   //------------------------------------------------------------------------------
   // column counter
   //------------------------------------------------------------------------------     
   always_ff @(posedge clk)
   begin: COL_CNT_EVAL
      if (rst == 1'b1) begin
         I_COL_CNT <= {16{1'b0}};
         data_in_en_dl1 <= 1'b0;
      end else begin
         if (enable == 1'b1) begin                
            if (I_CURRENT_STATE == T_STATES_IMAGE_DATA) begin
//               data_in_en_dl1 <= data_in_en;
               if(in_line == 1'b0 || in_frame == 1'b0)
                  I_COL_CNT <= {16{1'b0}}; 
//               else if ((data_in_en_dl1 == 1'b1) && (data_in_en == 1'b0)) begin
               else if (data_in_en == 1'b1) begin
                  I_COL_CNT <= I_COL_CNT + 16'd1;    
               end
            end
         end else
            I_COL_CNT <= {16{1'b0}};
      end
   end
         
   //------------------------------------------------------------------------------
   // row counter
   //------------------------------------------------------------------------------       
   always_ff @(posedge clk)
   begin
      if (rst == 1'b1) begin
         I_ROW_CNT <= {16{1'b0}};
         in_line_dl1 <= 1'b0;
      end else begin        
         if (enable == 1'b1) begin               
            if (in_frame == 1'b1) begin
               in_line_dl1 <= in_line;
               in_line_dl2 <= in_line_dl1;
               if (I_CURRENT_STATE == T_STATES_IMAGE_DATA) begin                     
                  if (in_line_dl1 == 1'b1 && in_line == 1'b0) begin
                     I_ROW_CNT <= I_ROW_CNT + 1'b1;
                  end
               end
            end else
               I_ROW_CNT <= {16{1'b0}};
         end else
            I_ROW_CNT <= {16{1'b0}};                
      end
   end
    
   always_ff @(posedge clk)
   begin
      if (rst) begin
         I_TX_FIFO_WREN_WORD <= 1'b0;
      end else begin 
         case (I_CURRENT_STATE)
            T_STATES_IDLE :
               I_TX_FIFO_WREN_WORD <= 1'b0;
               
            T_STATES_INIT :
               I_TX_FIFO_WREN_WORD <= 1'b0;    
               
            T_STATES_SYNC_FRM1, T_STATES_SYNC_FRM2 :
               if(I_ROW_CNT >= C_ROW_START)
                  I_TX_FIFO_WREN_WORD <= 1'b1;
               else 
                  I_TX_FIFO_WREN_WORD <= 1'b0;

            T_STATES_SYNC_ROW1, T_STATES_SYNC_ROW2 :
               if(I_ROW_CNT >= C_ROW_START)
                  I_TX_FIFO_WREN_WORD <= 1'b1;
               else 
                  I_TX_FIFO_WREN_WORD <= 1'b0;  
                  
            T_STATES_ROW_HI, T_STATES_ROW_LO :
               if(I_ROW_CNT >= C_ROW_START)
                  I_TX_FIFO_WREN_WORD <= 1'b1;
               else 
                  I_TX_FIFO_WREN_WORD <= 1'b0;               
                                                                                                          
            T_STATES_IMAGE_DATA : begin            
                  if(data_in_en == 1'b1 && in_line == 1'b1) begin
                     if((I_ROW_CNT >= C_ROW_START) && (I_ROW_CNT < C_ROW_STOP)) begin
                        if(((I_FRAME_CNT%4 == 0) && (I_ROW_CNT%4 == 0))
                        || ((I_FRAME_CNT%4 == 1) && (I_ROW_CNT%4 == 1))
                        || ((I_FRAME_CNT%4 == 2) && (I_ROW_CNT%4 == 2))
                        || ((I_FRAME_CNT%4 == 3) && (I_ROW_CNT%4 == 3))) begin                        
                           if((C_COL_START <= I_COL_CNT) && (I_COL_CNT < C_COL_STOP)) begin
                              I_TX_FIFO_WREN_WORD <= 1'b1;
                           end else
                              I_TX_FIFO_WREN_WORD <= 1'b0;
                        end else
                           I_TX_FIFO_WREN_WORD <= 1'b0;
                     end else
                        I_TX_FIFO_WREN_WORD <= 1'b0;                        
                  end else
                     I_TX_FIFO_WREN_WORD <= 1'b0;
               end         
                                                                 
            T_STATES_END : 
               I_TX_FIFO_WREN_WORD <= 1'b0;                 
         endcase
      end
   end
       
   always_ff @(posedge clk)
   begin
      if (rst)
         I_TX_FIFO_WRDAT_WORD <= {8{1'b0}};
      else begin
         case (I_CURRENT_STATE)
            T_STATES_IDLE :
               I_TX_FIFO_WRDAT_WORD <= {8{1'b0}};
            T_STATES_INIT :
               I_TX_FIFO_WRDAT_WORD <= 8'h00;
            T_STATES_SYNC_FRM1 :
               I_TX_FIFO_WRDAT_WORD <= 8'hCA;
            T_STATES_SYNC_FRM2 :
               I_TX_FIFO_WRDAT_WORD <= 8'hFE;
            T_STATES_SYNC_ROW1 :
               I_TX_FIFO_WRDAT_WORD <= 8'hCA;
            T_STATES_SYNC_ROW2 :
               I_TX_FIFO_WRDAT_WORD <= 8'hBA;                
            T_STATES_ROW_HI :
               I_TX_FIFO_WRDAT_WORD <= I_ROW_CNT[15:8];
            T_STATES_ROW_LO :
               I_TX_FIFO_WRDAT_WORD <= I_ROW_CNT[7:0];
  
            T_STATES_IMAGE_DATA :                                                         
//               I_TX_FIFO_WRDAT_WORD <= {data_in[23:21], data_in[15:13], data_in[7:6]};  
               I_TX_FIFO_WRDAT_WORD <= I_COL_CNT[7:0];
//               I_TX_FIFO_WRDAT_WORD <= (I_COL_CNT == 0 ?  8'h88 : (I_COL_CNT == 639 ?  8'h44 : 8'h55));
                     
            T_STATES_END :
               I_TX_FIFO_WRDAT_WORD <= 8'hEE;                                
         endcase
      end
   end

   
   assign tx_length = C_PACKET_LENGTH; 
   assign tx_reset = (I_CURRENT_STATE == T_STATES_INIT);
   assign tx_data =  I_TX_FIFO_WRDAT_WORD;
   assign tx_valid =  I_TX_FIFO_WREN_WORD;   
   
   assign tx_last = (I_COL_CNT == C_COL_STOP)
                     && ((I_FRAME_CNT%4 == 0)&&(I_ROW_CNT%4 == 0)
                     ||  (I_FRAME_CNT%4 == 1)&&(I_ROW_CNT%4 == 1)
                     ||  (I_FRAME_CNT%4 == 2)&&(I_ROW_CNT%4 == 2)
                     ||  (I_FRAME_CNT%4 == 3)&&(I_ROW_CNT%4 == 3));

   assign debug = { 1'b0, 1'b0, 1'b0, 1'b0,  1'b0, tx_last, tx_valid};
//   assign debug = { 1'b0, 1'b0, 1'b0, 1'b0,  (I_CURRENT_STATE == T_STATES_IMAGE_DATA), (I_CURRENT_STATE == T_STATES_ROW_HI) | (I_CURRENT_STATE == T_STATES_SYNC_FRM1), (I_CURRENT_STATE == T_STATES_INIT) | (I_CURRENT_STATE == T_STATES_END), (I_CURRENT_STATE == T_STATES_IDLE)};
   
endmodule: rgb2udp_top

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/12/10 Anel H: Initial creation 
*/
