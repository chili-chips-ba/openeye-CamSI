//==========================================================================
// Improved by Chili.CHIPS (2024)
//--------------------------------------------------------------------------
// Description: Shortened version of Xilinx library primitives. Contains 
//              only primitives and IPs that are used in the design
//
//  Adapted from: 
//    <XILINX-INSTALL>/data/verilog/src/unisims/*.v
//    <XILINX-INSTALL>/data/verilog/src/unisim_comp.v
//==========================================================================

// verilator lint_off WIDTH

//`timescale 1ps / 1ps
//   While PLL models would need 1ps resolution, we don't use Verilog 
//   models for them. Instead, cocoTB generates the necessary clocks 
//   directly, which then results in a much faster simulation

//--------------------------
/*
module glbl ();
    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
        GSR_int = 1'b1;
        PRLD_int = 1'b1;
        #(ROC_WIDTH)
        GSR_int = 1'b0;
        PRLD_int = 1'b0;
    end

    initial begin
        GTS_int = 1'b1;
        #(TOC_WIDTH)
        GTS_int = 1'b0;
    end

    initial begin 
        GRESTORE_int = 1'b0;
        #(GRES_START);
        GRESTORE_int = 1'b1;
        #(GRES_WIDTH);
        GRESTORE_int = 1'b0;
    end
endmodule: glbl
*/

//--------------------------
module OBUF #(
   parameter         CAPACITANCE = "DONT_CARE",
   parameter integer DRIVE       = 12,
   parameter         IOSTANDARD  = "DEFAULT",
   parameter         SLEW        = "SLOW"
)(
   input  I,
   output O
);
   assign O = I;   
endmodule: OBUF


//--------------------------
module IOBUF #(
   parameter integer DRIVE        = 12,
   parameter         IBUF_LOW_PWR = "TRUE",
   parameter         IOSTANDARD   = "DEFAULT",
   parameter         SLEW         = "SLOW"
)(
   input   I,T,
   output  O,
   inout   IO
);
   assign O  = IO;
   assign IO = (T == 1'b1) ? 1'bz : I;
endmodule: IOBUF


//--------------------------
module IBUFDS #(
   parameter CAPACITANCE      = "DONT_CARE",
   parameter DIFF_TERM        = "FALSE",
   parameter DQS_BIAS         = "FALSE",
   parameter IBUF_DELAY_VALUE = "0",
   parameter IBUF_LOW_PWR     = "TRUE",
   parameter IFD_DELAY_VALUE  = "AUTO",
   parameter IOSTANDARD       = "DEFAULT"
)(
   output  O,
   input   I, IB
);
   assign O = I & ~IB;
endmodule: IBUFDS


//--------------------------
module OBUFDS #(
   parameter CAPACITANCE = "DONT_CARE",
   parameter IOSTANDARD  = "DEFAULT",
   parameter SLEW        = "SLOW"
)(
   output O, OB,
   input  I
);
   assign O  = I;
   assign OB = ~O;
endmodule: OBUFDS


//--------------------------
module BUFG (
   output O,
   input  I
);
   assign O = I;
endmodule: BUFG


//--------------------------
module BUFMR (
   output O,
   input  I
);
endmodule: BUFMR


//--------------------------
module BUFR #(
   parameter BUFR_DIVIDE = "BYPASS",
   parameter SIM_DEVICE  = "7SERIES"
)(
   output O,
   input  CE,
   input  CLR,
   input  I
);
`ifdef XIL_TIMING
    parameter LOC = "UNPLACED";
`endif
    integer count, period_toggle, half_period_toggle;    
    reg  first_rise, half_period_done;
    reg  notifier;
    reg  o_out_divide = 0;
    wire o_out;
    reg  ce_enable1, ce_enable2, ce_enable3, ce_enable4;

    //HACKED tri0 GSR = glbl.GSR;
    bit GSR;
    initial begin
       GSR = 1'b1;
       #1
       GSR = 1'b0;
    end

    wire i_in, ce_in, clr_in, gsr_in, ce_en, i_ce;
    
    buf buf_i (i_in, I);
    buf buf_ce (ce_in, CE);
    buf buf_clr (clr_in, CLR);
    buf buf_gsr (gsr_in, GSR);    
    buf buf_o (O, o_out);

    initial begin
    case (BUFR_DIVIDE)
      "BYPASS" : period_toggle = 0;
      "1" : begin 
        period_toggle = 1;
        half_period_toggle = 1;
            end
      "2" : begin 
        period_toggle = 2;
        half_period_toggle = 2;
            end
      "3" : begin 
        period_toggle = 4;
        half_period_toggle = 2;
            end
      "4" : begin
        period_toggle = 4;
        half_period_toggle = 4;
      end
      "5" : begin 
        period_toggle = 6;
        half_period_toggle = 4;
      end
      "6" : begin 
        period_toggle = 6;
        half_period_toggle = 6;
      end
      "7" : begin 
        period_toggle = 8;
        half_period_toggle = 6;
      end
      "8" : begin 
        period_toggle = 8;
        half_period_toggle = 8;
            end
      default : begin 
              $display("Attribute Syntax Error : The attribute BUFR_DIVIDE on BUFR instance %m is set to %s.  Legal values for this attribute are BYPASS, 1, 2, 3, 4, 5, 6, 7 or 8.", BUFR_DIVIDE);
                    #1 $finish;
      end
     endcase // case(BUFR_DIVIDE)

     case (SIM_DEVICE)
        "VIRTEX4" : ;
        "VIRTEX5" : ;
        "VIRTEX6" : ;
        "7SERIES" : ;
        default : begin 
           $display("Attribute Syntax Error : The attribute SIM_DEVICE on BUFR instance %m is set to %s.  Legal values for this attribute are VIRTEX4 or VIRTEX5 or VIRTEX6 or 7SERIES.", SIM_DEVICE);
                 #1 $finish;
        end
     endcase 
  end // initial begin
    
`ifdef HACKED_UNISIM
// verilator lint_off LATCH
  always @(gsr_in or clr_in) begin
     if (gsr_in == 1'b1 || clr_in == 1'b1) begin
        o_out_divide     = 1'b0;
        count            = 0;
        first_rise       = 1'b1;
        half_period_done = 1'b0;
     end

     if (gsr_in == 1'b1) begin
        ce_enable1 = 1'b0;
        ce_enable2 = 1'b0;
        ce_enable3 = 1'b0;
        ce_enable4 = 1'b0;
     end      
  end  
// verilator lint_on LATCH

`else
  always @(gsr_in or clr_in)
  if (gsr_in == 1'b1 || clr_in == 1'b1) begin
      assign o_out_divide = 1'b0;
      assign count = 0;
      assign first_rise = 1'b1;
      assign half_period_done = 1'b0;

      if (gsr_in == 1'b1) begin
        assign ce_enable1 = 1'b0;
        assign ce_enable2 = 1'b0;
        assign ce_enable3 = 1'b0;
        assign ce_enable4 = 1'b0;
      end      
  end  
  else if (gsr_in == 1'b0 || clr_in == 1'b0) begin
      deassign o_out_divide;      
      deassign count;
      deassign first_rise;
      deassign half_period_done;

      if (gsr_in == 1'b0) begin
        deassign ce_enable1;
        deassign ce_enable2;
        deassign ce_enable3;
        deassign ce_enable4;
      end    
  end
`endif    

    always @(negedge i_in) 
    begin
       //HACKED ce_enable1 <= ce_in;
       //HACKED ce_enable2 <= ce_enable1;
       //HACKED ce_enable3 <= ce_enable2;
       //HACKED ce_enable4 <= ce_enable3;
       ce_enable4 = ce_enable3;
       ce_enable3 = ce_enable2;
       ce_enable2 = ce_enable1;
       ce_enable1 = ce_in;
    end

    assign ce_en = ((SIM_DEVICE == "VIRTEX5") || (SIM_DEVICE == "VIRTEX6") || (SIM_DEVICE == "7SERIES")) ? ce_in :  ce_enable4;

    assign i_ce = i_in & ce_en;

  generate
    case (SIM_DEVICE)
      "VIRTEX4" : begin
      always @(i_in or ce_en)
        if (ce_en == 1'b1) begin
      if (i_in == 1'b1 && first_rise == 1'b1) begin
    o_out_divide = 1'b1;
    first_rise = 1'b0;
      end
      else if (count == half_period_toggle && half_period_done == 1'b0) begin
    o_out_divide = ~o_out_divide;
    half_period_done = 1'b1;
          count = 0;  
      end
      else if (count == period_toggle && half_period_done == 1'b1) begin
    o_out_divide = ~o_out_divide;
    half_period_done = 1'b0;
          count = 0;
      end

            if (first_rise == 1'b0)
    count = count + 1;
  end // if (ce_in == 1'b1)
        else begin
           count = 0;
           first_rise = 1;
        end
      end
      "VIRTEX5","VIRTEX6","7SERIES" : begin
       always @(i_ce)
       begin 
           if (i_ce == 1'b1 && first_rise == 1'b1) begin
       o_out_divide = 1'b1;
       first_rise = 1'b0;
     end
     else if (count == half_period_toggle && half_period_done == 1'b0) begin
              o_out_divide = ~o_out_divide;
        half_period_done = 1'b1;
       count = 0;  
     end
     else if (count == period_toggle && half_period_done == 1'b1) begin
       o_out_divide = ~o_out_divide;
       half_period_done = 1'b0;
       count = 0;
           end

          if (first_rise == 1'b0) begin
      count = count + 1;
    end // if (ce_in == 1'b1)
        end   
       end
    endcase
  endgenerate
    
  assign o_out = (period_toggle == 0) ? i_in : o_out_divide;

//*** Timing Checks Start here
   always @(notifier) begin
      //HACKED o_out_divide <= 1'bx;
      o_out_divide = 1'bx;
   end

`ifdef XIL_TIMING
  specify
    (CLR => O) = (0:0:0, 0:0:0);
    (I => O) = (0:0:0, 0:0:0);
    $period (negedge I, 0:0:0, notifier);
    $period (posedge I, 0:0:0, notifier);
    $setuphold (posedge I, posedge CE, 0:0:0, 0:0:0, notifier);
    $setuphold (posedge I, negedge CE, 0:0:0, 0:0:0, notifier);
    $setuphold (negedge I, posedge CE, 0:0:0, 0:0:0, notifier);
    $setuphold (negedge I, negedge CE, 0:0:0, 0:0:0, notifier);
    $width (posedge CLR, 0:0:0, 0, notifier);
    $width (posedge I, 0:0:0, 0, notifier);
    $width (negedge I, 0:0:0, 0, notifier);
    specparam PATHPULSE$ = 0;
  endspecify
`endif
endmodule: BUFR


//--------------------------
module IDELAYE2 #(
   parameter         CINVCTRL_SEL          = "FALSE",
   parameter         DELAY_SRC             = "IDATAIN",
   parameter         HIGH_PERFORMANCE_MODE = "FALSE",
   parameter         IDELAY_TYPE           = "FIXED",
   parameter integer IDELAY_VALUE          = 0,
   parameter [0:0]   IS_C_INVERTED         = 1'b0,
   parameter [0:0]   IS_DATAIN_INVERTED    = 1'b0,
   parameter [0:0]   IS_IDATAIN_INVERTED   = 1'b0,
   parameter         PIPE_SEL              = "FALSE",
   parameter real    REFCLK_FREQUENCY      = 200.0,
   parameter         SIGNAL_PATTERN        = "DATA",
   parameter integer SIM_DELAY_D           = 0
)(
   output       DATAOUT,
   output [4:0] CNTVALUEOUT,
   input        C,
   input        CE,
   input        CINVCTRL,
   input        DATAIN,
   input        IDATAIN,
   input        INC,
   input        LD,
   input        LDPIPEEN,
   input        REGRST,
   input [4:0]  CNTVALUEIN
);

`ifdef XIL_TIMING
    parameter  LOC = "UNPLACED";
    localparam DELAY_D = (IDELAY_TYPE == "VARIABLE") ? SIM_DELAY_D : 0;
`else
    integer DELAY_D=0;
`endif

    //HACKED tri0 GSR = glbl.GSR;
    bit GSR;
    initial begin
        GSR = 1'b1;
        #1
        GSR = 1'b0;
    end

    real  CALC_TAPDELAY ; 
    real  INIT_DELAY;

//------------------- constants ------------------------------------
    localparam MAX_DELAY_COUNT = 31; 
    localparam MIN_DELAY_COUNT = 0; 

    localparam MAX_REFCLK_FREQUENCYL = 210.0;
    localparam MIN_REFCLK_FREQUENCYL = 190.0;

    localparam MAX_REFCLK_FREQUENCYH = 410.0;
    localparam MIN_REFCLK_FREQUENCYH = 290.0;


//------------------- variable declaration -------------------------

    integer idelay_count;
    integer CNTVALUEIN_INTEGER;
    reg [4:0] cntvalueout_pre;

    reg notifier;

    reg data_mux = 0;
    reg tap_out   = 0;
    reg DATAOUT_reg   = 0;

    wire delay_chain_0,  delay_chain_1,  delay_chain_2,  delay_chain_3,
         delay_chain_4,  delay_chain_5,  delay_chain_6,  delay_chain_7,
         delay_chain_8,  delay_chain_9,  delay_chain_10, delay_chain_11,
         delay_chain_12, delay_chain_13, delay_chain_14, delay_chain_15,
         delay_chain_16, delay_chain_17, delay_chain_18, delay_chain_19,
         delay_chain_20, delay_chain_21, delay_chain_22, delay_chain_23,
         delay_chain_24, delay_chain_25, delay_chain_26, delay_chain_27,
         delay_chain_28, delay_chain_29, delay_chain_30, delay_chain_31;

    reg  c_in;
    wire ce_in,delay_CE,delay_C;
    wire clkin_in;
    wire [4:0] cntvaluein_in,delay_CNTVALUEIN;
    wire datain_in,delay_DATAIN;
    wire gsr_in;
    wire idatain_in,delay_IDATAIN;
    wire inc_in,delay_INC;
    wire odatain_in;
    wire ld_in,delay_LD;
    wire t_in;
    wire cinvctrl_in,delay_CINVCTRL;
    wire ldpipeen_in,delay_LDPIPEEN;
    wire regrst_in,delay_REGRST;

    wire c_in_pre;

   reg [4:0] qcntvalueout_reg = 5'b0;
   reg [4:0] qcntvalueout_mux = 5'b0;


//----------------------------------------------------------------------
//-------------------------------  Output ------------------------------
//----------------------------------------------------------------------
// CR 587496
//    assign #INIT_DELAY DATAOUT = tap_out;
    always @(tap_out)
       DATAOUT_reg <= #INIT_DELAY tap_out;

    assign DATAOUT = DATAOUT_reg;

    assign CNTVALUEOUT = cntvalueout_pre;

`ifndef XIL_TIMING
//----------------------------------------------------------------------
//-------------------------------  Input -------------------------------
//----------------------------------------------------------------------
    assign delay_C = C;
    assign delay_CE = CE;
    assign delay_CNTVALUEIN = CNTVALUEIN;
    assign delay_INC = INC;
    assign delay_LD = LD;
    assign delay_LDPIPEEN = LDPIPEEN;
    assign delay_REGRST = REGRST;
`endif // ifndef XIL_TIMING
    assign delay_CINVCTRL = CINVCTRL;
    assign delay_DATAIN =  DATAIN;
    assign delay_IDATAIN =  IDATAIN;
    assign gsr_in = GSR;

    assign c_in_pre = delay_C ^ IS_C_INVERTED;
    assign ce_in = delay_CE;
    assign cntvaluein_in = delay_CNTVALUEIN;
    assign inc_in = delay_INC;
    assign ld_in = delay_LD;
    assign ldpipeen_in = delay_LDPIPEEN;
    assign regrst_in = delay_REGRST;
   assign cinvctrl_in = delay_CINVCTRL;
    assign datain_in = IS_DATAIN_INVERTED ^ delay_DATAIN;
    assign idatain_in = IS_IDATAIN_INVERTED ^ delay_IDATAIN;

`ifdef HACKED_UNISIM
//*** GLOBAL hidden GSR pin
    always @(gsr_in) begin
        if (gsr_in == 1'b1) begin
//   For simprims, the fixed/Default Delay values are taken from the sdf.
           // if (IDELAY_TYPE == "FIXED")
           //     assign idelay_count = 0;
           // else
           //     assign idelay_count = IDELAY_VALUE;
                case (IDELAY_TYPE)
                        "VAR_LOAD", "VAR_LOAD_PIPE": idelay_count = 0;
                        "FIXED", "VARIABLE" : idelay_count = IDELAY_VALUE;
                endcase
        end
    end
`else
//*** GLOBAL hidden GSR pin
    always @(gsr_in) begin
        if (gsr_in == 1'b1) begin
//   For simprims, the fixed/Default Delay values are taken from the sdf.
           // if (IDELAY_TYPE == "FIXED")
           //     assign idelay_count = 0;
           // else
           //     assign idelay_count = IDELAY_VALUE;
                case (IDELAY_TYPE)
                        "VAR_LOAD", "VAR_LOAD_PIPE": assign idelay_count = 0;
                        "FIXED", "VARIABLE" : assign idelay_count = IDELAY_VALUE;
                endcase
        end
        else if (gsr_in == 1'b0) begin
            deassign idelay_count;
        end
    end
`endif

//------------------------------------------------------------
//---------------------   Initialization  --------------------
//------------------------------------------------------------
    initial begin

        //-------- CINVCTRL_SEL check

        case (CINVCTRL_SEL)
            "TRUE", "FALSE" : ;
            default : begin
               $display("Attribute Syntax Error : The attribute CINVCTRL_SEL on IDELAYE2 instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.",  CINVCTRL_SEL);
               #1 $finish;
            end
        endcase

        //-------- DELAY_SRC check
        if (DELAY_SRC != "DATAIN" && DELAY_SRC != "IDATAIN") begin
            $display("Attribute Syntax Error : The attribute DELAY_SRC on IDELAYE2 instance %m is set to %s.  Legal values for this attribute are DATAIN or IDATAIN", DELAY_SRC);
            #1 $finish;
        end

        //-------- HIGH_PERFORMANCE_MODE check
        case (HIGH_PERFORMANCE_MODE)
            "TRUE", "FALSE" : ;
            default : begin
               $display("Attribute Syntax Error : The attribute HIGH_PERFORMANCE_MODE on IDELAYE2 instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.",  HIGH_PERFORMANCE_MODE);
               #1 $finish;
            end
        endcase


        //-------- IDELAY_TYPE check

        if (IDELAY_TYPE != "FIXED" && IDELAY_TYPE != "VARIABLE" && IDELAY_TYPE != "VAR_LOAD" && IDELAY_TYPE != "VAR_LOAD_PIPE") begin

            $display("Attribute Syntax Error : The attribute IDELAY_TYPE on IDELAYE2 instance %m is set to %s.  Legal values for this attribute are FIXED, VARIABLE, VAR_LOAD or VAR_LOAD_PIPE", IDELAY_TYPE);
            #1 $finish;

        end


        //-------- IDELAY_VALUE check

        if (IDELAY_VALUE < MIN_DELAY_COUNT || IDELAY_VALUE > MAX_DELAY_COUNT) begin
            $display("Attribute Syntax Error : The attribute IDELAY_VALUE on IDELAYE2 instance %m is set to %d.  Legal values for this attribute are 0, 1, 2, 3, .... or 31", IDELAY_VALUE);
            #1 $finish;

        end

        //-------- PIPE_SEL check

        case (PIPE_SEL)
            "TRUE", "FALSE" : ;
            default : begin
               $display("Attribute Syntax Error : The attribute PIPE_SEL on IDELAYE2 instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.",  PIPE_SEL);
               #1 $finish;
            end
        endcase


        //-------- REFCLK_FREQUENCY check

        if ((REFCLK_FREQUENCY >= 190.0 && REFCLK_FREQUENCY <= 210.0) || 
            (REFCLK_FREQUENCY >= 290.0 && REFCLK_FREQUENCY <= 310.0) || 
            (REFCLK_FREQUENCY >=390.0 && REFCLK_FREQUENCY <= 410.0)) 
              /*    */;
        else begin
            $display("Attribute Syntax Error : The attribute REFCLK_FREQUENCY on IDELAYE2 instance %m is set to %f.  Legal values for this attribute are either between 190.0 and 210.0, or between 290.0 and 310.0 or between 390.0 and 410.0", REFCLK_FREQUENCY);
            #1 $finish;
        end

        //-------- SIGNAL_PATTERN check

        case (SIGNAL_PATTERN)
            "CLOCK", "DATA" : ;
            default : begin
               $display("Attribute Syntax Error : The attribute SIGNAL_PATTERN on IDELAYE2 instance %m is set to %s.  Legal values for this attribute are DATA or CLOCK.",  SIGNAL_PATTERN);
               #1 $finish;
            end
        endcase


        //-------- CALC_TAPDELAY check

        INIT_DELAY = 600;

    end // initial begin

    // CALC_TAPDELAY value
    initial begin
        if ((REFCLK_FREQUENCY <= 410.0) && (REFCLK_FREQUENCY >= 390.0))
                begin
                        CALC_TAPDELAY = 39;
                end
        else if ((REFCLK_FREQUENCY <= 310.0) && (REFCLK_FREQUENCY >= 290.0))
                begin
                        CALC_TAPDELAY = 52;
                end
        else
                begin
                        CALC_TAPDELAY = 78;
                end
    end

//----------------------------------------------------------------------
//------------------------ Dynamic clock inversion ---------------------
//----------------------------------------------------------------------

//    always @(c_in_pre or cinvctrl_in) begin
//        case (CINVCTRL_SEL)
//                "TRUE" : c_in = (cinvctrl_in ? ~c_in_pre : c_in_pre);
//                "FALSE" : c_in = c_in_pre;
//        endcase
//    end

   generate
      case (CINVCTRL_SEL)
         "TRUE"  : always @(c_in_pre or cinvctrl_in) c_in = (cinvctrl_in ? ~c_in_pre : c_in_pre);
         "FALSE" : always @(c_in_pre) c_in = c_in_pre;
      endcase
   endgenerate

//----------------------------------------------------------------------
//------------------------      CNTVALUEOUT        ---------------------
//----------------------------------------------------------------------
    always @(idelay_count) begin
//  Fixed CNTVALUEOUT for when in FIXED mode because of simprim. 
       if(IDELAY_TYPE != "FIXED")
           assign cntvalueout_pre = idelay_count;
       else
           assign cntvalueout_pre = IDELAY_VALUE;
    end

//----------------------------------------------------------------------
//--------------------------  CNTVALUEIN LOAD --------------------------
//----------------------------------------------------------------------
    always @(posedge c_in) begin
       if (regrst_in == 1'b1) 
              qcntvalueout_reg = 5'b0;
       else if (regrst_in == 1'b0 && ldpipeen_in == 1'b1) begin
              qcntvalueout_reg =  CNTVALUEIN_INTEGER;
       end 
    end  // always @(posedge c_in)

   generate
      case (PIPE_SEL)
         "TRUE"  : always @(qcntvalueout_reg) qcntvalueout_mux   <= qcntvalueout_reg;
         "FALSE" : always @(CNTVALUEIN_INTEGER) qcntvalueout_mux   <= CNTVALUEIN_INTEGER;
      endcase
    endgenerate

//----------------------------------------------------------------------
//--------------------------  IDELAY_COUNT  ----------------------------
//----------------------------------------------------------------------
    always @(posedge c_in) begin

        if (IDELAY_TYPE == "VARIABLE" | IDELAY_TYPE == "VAR_LOAD" | IDELAY_TYPE == "VAR_LOAD_PIPE") begin
            if (ld_in == 1'b1) begin
                case (IDELAY_TYPE)
                        "VARIABLE" : idelay_count = IDELAY_VALUE;
                        "VAR_LOAD", "VAR_LOAD_PIPE" : idelay_count = qcntvalueout_mux;
                endcase
            end
            else if (ld_in == 1'b0 && ce_in == 1'b1) begin
                if (inc_in == 1'b1) begin
                    case (IDELAY_TYPE)
                        "VARIABLE", "VAR_LOAD", "VAR_LOAD_PIPE" : begin
                                        if (idelay_count < MAX_DELAY_COUNT)
                                          idelay_count = idelay_count + 1;
                                        else if (idelay_count == MAX_DELAY_COUNT)
                                          idelay_count = MIN_DELAY_COUNT;
                                     end
                    endcase
                end
                else if (inc_in == 1'b0) begin
                    case (IDELAY_TYPE)
                        "VARIABLE", "VAR_LOAD", "VAR_LOAD_PIPE" : begin
                                        if (idelay_count >  MIN_DELAY_COUNT)
                                          idelay_count = idelay_count - 1;
                                        else if (idelay_count == MIN_DELAY_COUNT)
                                          idelay_count = MAX_DELAY_COUNT;
                                     end
                    endcase
                end
            end
        end //
    end // always @ (posedge c_in)
  
    always @(cntvaluein_in or gsr_in) begin
       case (cntvaluein_in)
          5'b00000 : assign CNTVALUEIN_INTEGER = 0;
          5'b00001 : assign CNTVALUEIN_INTEGER = 1;
          5'b00010 : assign CNTVALUEIN_INTEGER = 2;
          5'b00011 : assign CNTVALUEIN_INTEGER = 3;
          5'b00100 : assign CNTVALUEIN_INTEGER = 4;
          5'b00101 : assign CNTVALUEIN_INTEGER = 5;
          5'b00110 : assign CNTVALUEIN_INTEGER = 6;
          5'b00111 : assign CNTVALUEIN_INTEGER = 7;
          5'b01000 : assign CNTVALUEIN_INTEGER = 8;
          5'b01001 : assign CNTVALUEIN_INTEGER = 9;
          5'b01010 : assign CNTVALUEIN_INTEGER = 10;
          5'b01011 : assign CNTVALUEIN_INTEGER = 11;
          5'b01100 : assign CNTVALUEIN_INTEGER = 12;
          5'b01101 : assign CNTVALUEIN_INTEGER = 13;
          5'b01110 : assign CNTVALUEIN_INTEGER = 14;
          5'b01111 : assign CNTVALUEIN_INTEGER = 15;
          5'b10000 : assign CNTVALUEIN_INTEGER = 16;
          5'b10001 : assign CNTVALUEIN_INTEGER = 17;
          5'b10010 : assign CNTVALUEIN_INTEGER = 18;
          5'b10011 : assign CNTVALUEIN_INTEGER = 19;
          5'b10100 : assign CNTVALUEIN_INTEGER = 20;
          5'b10101 : assign CNTVALUEIN_INTEGER = 21;
          5'b10110 : assign CNTVALUEIN_INTEGER = 22;
          5'b10111 : assign CNTVALUEIN_INTEGER = 23;
          5'b11000 : assign CNTVALUEIN_INTEGER = 24;
          5'b11001 : assign CNTVALUEIN_INTEGER = 25;
          5'b11010 : assign CNTVALUEIN_INTEGER = 26;
          5'b11011 : assign CNTVALUEIN_INTEGER = 27;
          5'b11100 : assign CNTVALUEIN_INTEGER = 28;
          5'b11101 : assign CNTVALUEIN_INTEGER = 29;
          5'b11110 : assign CNTVALUEIN_INTEGER = 30;
          5'b11111 : assign CNTVALUEIN_INTEGER = 31;
       endcase
    end

 
//*********************************************************
//*** SELECT IDATA signal
//*********************************************************
    always @(datain_in or idatain_in) begin
       case (DELAY_SRC)

         "IDATAIN" : begin
                      data_mux <= idatain_in;
                     end
         "DATAIN" : begin
                      data_mux <= datain_in;
                    end
         default : begin
                       $display("Attribute Syntax Error : The attribute DELAY_SRC on X_IODELAYE2 instance %m is set to %s.  Legal values for this attribute are DATAIN or IDATAIN", DELAY_SRC);
                       $finish;
                   end

       endcase // case(DELAY_SRC)

    end // always @(datain_in or idatain_in)

//*********************************************************
//*** DELAY IDATA signal
//*********************************************************
    assign #(DELAY_D)     delay_chain_0  = data_mux;
    assign #CALC_TAPDELAY delay_chain_1  = delay_chain_0;
    assign #CALC_TAPDELAY delay_chain_2  = delay_chain_1;
    assign #CALC_TAPDELAY delay_chain_3  = delay_chain_2;
    assign #CALC_TAPDELAY delay_chain_4  = delay_chain_3;
    assign #CALC_TAPDELAY delay_chain_5  = delay_chain_4;
    assign #CALC_TAPDELAY delay_chain_6  = delay_chain_5;
    assign #CALC_TAPDELAY delay_chain_7  = delay_chain_6;
    assign #CALC_TAPDELAY delay_chain_8  = delay_chain_7;
    assign #CALC_TAPDELAY delay_chain_9  = delay_chain_8;
    assign #CALC_TAPDELAY delay_chain_10 = delay_chain_9;
    assign #CALC_TAPDELAY delay_chain_11 = delay_chain_10;
    assign #CALC_TAPDELAY delay_chain_12 = delay_chain_11;
    assign #CALC_TAPDELAY delay_chain_13 = delay_chain_12;
    assign #CALC_TAPDELAY delay_chain_14 = delay_chain_13;
    assign #CALC_TAPDELAY delay_chain_15 = delay_chain_14;
    assign #CALC_TAPDELAY delay_chain_16 = delay_chain_15;
    assign #CALC_TAPDELAY delay_chain_17 = delay_chain_16;
    assign #CALC_TAPDELAY delay_chain_18 = delay_chain_17;
    assign #CALC_TAPDELAY delay_chain_19 = delay_chain_18;
    assign #CALC_TAPDELAY delay_chain_20 = delay_chain_19;
    assign #CALC_TAPDELAY delay_chain_21 = delay_chain_20;
    assign #CALC_TAPDELAY delay_chain_22 = delay_chain_21;
    assign #CALC_TAPDELAY delay_chain_23 = delay_chain_22;
    assign #CALC_TAPDELAY delay_chain_24 = delay_chain_23;
    assign #CALC_TAPDELAY delay_chain_25 = delay_chain_24;
    assign #CALC_TAPDELAY delay_chain_26 = delay_chain_25;
    assign #CALC_TAPDELAY delay_chain_27 = delay_chain_26;
    assign #CALC_TAPDELAY delay_chain_28 = delay_chain_27;
    assign #CALC_TAPDELAY delay_chain_29 = delay_chain_28;
    assign #CALC_TAPDELAY delay_chain_30 = delay_chain_29;
    assign #CALC_TAPDELAY delay_chain_31 = delay_chain_30;

//*********************************************************
//*** assign delay
//*********************************************************
    always @(idelay_count) begin
        case (idelay_count)
            0:  assign tap_out = delay_chain_0;
            1:  assign tap_out = delay_chain_1;
            2:  assign tap_out = delay_chain_2;
            3:  assign tap_out = delay_chain_3;
            4:  assign tap_out = delay_chain_4;
            5:  assign tap_out = delay_chain_5;
            6:  assign tap_out = delay_chain_6;
            7:  assign tap_out = delay_chain_7;
            8:  assign tap_out = delay_chain_8;
            9:  assign tap_out = delay_chain_9;
            10: assign tap_out = delay_chain_10;
            11: assign tap_out = delay_chain_11;
            12: assign tap_out = delay_chain_12;
            13: assign tap_out = delay_chain_13;
            14: assign tap_out = delay_chain_14;
            15: assign tap_out = delay_chain_15;
            16: assign tap_out = delay_chain_16;
            17: assign tap_out = delay_chain_17;
            18: assign tap_out = delay_chain_18;
            19: assign tap_out = delay_chain_19;
            20: assign tap_out = delay_chain_20;
            21: assign tap_out = delay_chain_21;
            22: assign tap_out = delay_chain_22;
            23: assign tap_out = delay_chain_23;
            24: assign tap_out = delay_chain_24;
            25: assign tap_out = delay_chain_25;
            26: assign tap_out = delay_chain_26;
            27: assign tap_out = delay_chain_27;
            28: assign tap_out = delay_chain_28;
            29: assign tap_out = delay_chain_29;
            30: assign tap_out = delay_chain_30;
            31: assign tap_out = delay_chain_31;
            default:
                assign tap_out = delay_chain_0;
        endcase
    end // always @ (idelay_count)

`ifdef XIL_TIMING
   wire c_en_n;
   wire c_en_p;
   assign c_en_n = IS_C_INVERTED;
   assign c_en_p = ~IS_C_INVERTED;

   wire d_en;
   wire id_en;
   assign d_en = (idelay_count == 0) && (DELAY_SRC == "DATAIN");
   assign id_en = (idelay_count == 0) && (DELAY_SRC == "IDATAIN");
  
//*** Timing Checks Start here
    always @(notifier) begin
        tap_out <= 1'bx;
    end
`endif // ifdef XIL_TIMING

`ifdef XIL_TIMING
    specify
        ( C *> CNTVALUEOUT) = (0:0:0, 0:0:0);
        ( C => DATAOUT) = (0:0:0, 0:0:0);
        ( CINVCTRL *> CNTVALUEOUT) = (0:0:0, 0:0:0);
        ( CINVCTRL => DATAOUT) = (0:0:0, 0:0:0);
        if (d_en) ( DATAIN => DATAOUT) = (0:0:0, 0:0:0);
        if (id_en) ( IDATAIN => DATAOUT) = (0:0:0, 0:0:0);

        $period (negedge C, 0:0:0, notifier);
        $period (posedge C, 0:0:0, notifier);
 
        $setuphold (posedge C, posedge CE,  0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_CE);
        $setuphold (posedge C, negedge CE,  0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_CE);
        $setuphold (posedge C, posedge INC, 0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_INC);
        $setuphold (posedge C, negedge INC, 0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_INC);
        $setuphold (posedge C, posedge LD, 0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_LD);
        $setuphold (posedge C, negedge LD, 0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_LD);
        $setuphold (posedge C, posedge CNTVALUEIN, 0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_CNTVALUEIN);
        $setuphold (posedge C, negedge CNTVALUEIN, 0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_CNTVALUEIN);
        $setuphold (posedge C, posedge LDPIPEEN, 0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_LDPIPEEN);
        $setuphold (posedge C, negedge LDPIPEEN, 0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_LDPIPEEN);
        $setuphold (posedge C, posedge REGRST,  0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_REGRST);
        $setuphold (posedge C, negedge REGRST,  0:0:0, 0:0:0, notifier, c_en_p, c_en_p, delay_C, delay_REGRST);

        $setuphold (negedge C, posedge CE,  0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_CE);
        $setuphold (negedge C, negedge CE,  0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_CE);
        $setuphold (negedge C, posedge INC, 0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_INC);
        $setuphold (negedge C, negedge INC, 0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_INC);
        $setuphold (negedge C, posedge LD, 0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_LD);
        $setuphold (negedge C, negedge LD, 0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_LD);
        $setuphold (negedge C, posedge CNTVALUEIN, 0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_CNTVALUEIN);
        $setuphold (negedge C, negedge CNTVALUEIN, 0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_CNTVALUEIN);
        $setuphold (negedge C, posedge LDPIPEEN, 0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_LDPIPEEN);
        $setuphold (negedge C, negedge LDPIPEEN, 0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_LDPIPEEN);
        $setuphold (negedge C, posedge REGRST,  0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_REGRST);
        $setuphold (negedge C, negedge REGRST,  0:0:0, 0:0:0, notifier, c_en_n, c_en_n, delay_C, delay_REGRST);

        specparam PATHPULSE$ = 0;
    endspecify
`endif // ifdef XIL_TIMING
endmodule: IDELAYE2


//========================================
// Dummies, just to get the sim compile through
//========================================

//--------------------------dummy shell
module IDELAYCTRL #(
   parameter SIM_DEVICE = "7SERIES"
)(
   output RDY,
   input  REFCLK,
   input  RST
);
endmodule: IDELAYCTRL


//--------------------------dummy shell
module MMCME2_BASE #(
   parameter         BANDWIDTH          = "OPTIMIZED",
   parameter real    CLKFBOUT_MULT_F    = 5.000,
   parameter real    CLKFBOUT_PHASE     = 0.000,
   parameter real    CLKIN1_PERIOD      = 0.000,
   parameter real    CLKOUT0_DIVIDE_F   = 1.000,
   parameter real    CLKOUT0_DUTY_CYCLE = 0.500,
   parameter real    CLKOUT0_PHASE      = 0.000,
   parameter integer CLKOUT1_DIVIDE     = 1,
   parameter real    CLKOUT1_DUTY_CYCLE = 0.500,
   parameter real    CLKOUT1_PHASE      = 0.000,
   parameter integer CLKOUT2_DIVIDE     = 1,
   parameter real    CLKOUT2_DUTY_CYCLE = 0.500,
   parameter real    CLKOUT2_PHASE      = 0.000,
   parameter integer CLKOUT3_DIVIDE     = 1,
   parameter real    CLKOUT3_DUTY_CYCLE = 0.500,
   parameter real    CLKOUT3_PHASE      = 0.000,
   parameter         CLKOUT4_CASCADE    = "FALSE",
   parameter integer CLKOUT4_DIVIDE     = 1,
   parameter real    CLKOUT4_DUTY_CYCLE = 0.500,
   parameter real    CLKOUT4_PHASE      = 0.000,
   parameter integer CLKOUT5_DIVIDE     = 1,
   parameter real    CLKOUT5_DUTY_CYCLE = 0.500,
   parameter real    CLKOUT5_PHASE      = 0.000,
   parameter integer CLKOUT6_DIVIDE     = 1,
   parameter real    CLKOUT6_DUTY_CYCLE = 0.500,
   parameter real    CLKOUT6_PHASE      = 0.000,
   parameter integer DIVCLK_DIVIDE      = 1,
   parameter real    REF_JITTER1        = 0.010,
   parameter         STARTUP_WAIT       = "FALSE"
)(
   output CLKFBOUT,
   output CLKFBOUTB,
   output CLKOUT0,
   output CLKOUT0B,
   output CLKOUT1,
   output CLKOUT1B,
   output CLKOUT2,
   output CLKOUT2B,
   output CLKOUT3,
   output CLKOUT3B,
   output CLKOUT4,
   output CLKOUT5,
   output CLKOUT6,
   output LOCKED,
   input  CLKFBIN,
   input  CLKIN1,
   input  PWRDWN,
   input  RST
);
endmodule: MMCME2_BASE


//--------------------------dummy shell
module OSERDESE2 #(
   parameter         DATA_RATE_OQ       = "DDR",
   parameter         DATA_RATE_TQ       = "DDR",
   parameter integer DATA_WIDTH         = 4,
   parameter [0:0]   INIT_OQ            = 1'b0,
   parameter [0:0]   INIT_TQ            = 1'b0,
   parameter [0:0]   IS_CLKDIV_INVERTED = 1'b0,
   parameter [0:0]   IS_CLK_INVERTED    = 1'b0,
   parameter [0:0]   IS_D1_INVERTED     = 1'b0,
   parameter [0:0]   IS_D2_INVERTED     = 1'b0,
   parameter [0:0]   IS_D3_INVERTED     = 1'b0,
   parameter [0:0]   IS_D4_INVERTED     = 1'b0,
   parameter [0:0]   IS_D5_INVERTED     = 1'b0,
   parameter [0:0]   IS_D6_INVERTED     = 1'b0,
   parameter [0:0]   IS_D7_INVERTED     = 1'b0,
   parameter [0:0]   IS_D8_INVERTED     = 1'b0,
   parameter [0:0]   IS_T1_INVERTED     = 1'b0,
   parameter [0:0]   IS_T2_INVERTED     = 1'b0,
   parameter [0:0]   IS_T3_INVERTED     = 1'b0,
   parameter [0:0]   IS_T4_INVERTED     = 1'b0,
   parameter         SERDES_MODE        = "MASTER",
   parameter [0:0]   SRVAL_OQ           = 1'b0,
   parameter [0:0]   SRVAL_TQ           = 1'b0,
   parameter         TBYTE_CTL          = "FALSE",
   parameter         TBYTE_SRC          = "FALSE",
   parameter integer TRISTATE_WIDTH     = 4
)(
   output OFB,
   output OQ,
   output SHIFTOUT1,
   output SHIFTOUT2,
   output TBYTEOUT,
   output TFB,
   output TQ,

   input  CLK,
   input  CLKDIV,
   input  D1,
   input  D2,
   input  D3,
   input  D4,
   input  D5,
   input  D6,
   input  D7,
   input  D8,
   input  OCE,
   input  RST,
   input  SHIFTIN1,
   input  SHIFTIN2,
   input  T1,
   input  T2,
   input  T3,
   input  T4,
   input  TBYTEIN,
   input  TCE
);
endmodule: OSERDESE2

//--------------------------dummy shell
module ISERDESE2 #(
   parameter         DATA_RATE           = "DDR",
   parameter integer DATA_WIDTH          = 4,
   parameter         DYN_CLKDIV_INV_EN   = "FALSE",
   parameter         DYN_CLK_INV_EN      = "FALSE",
   parameter [0:0]   INIT_Q1             = 1'b0,
   parameter [0:0]   INIT_Q2             = 1'b0,
   parameter [0:0]   INIT_Q3             = 1'b0,
   parameter [0:0]   INIT_Q4             = 1'b0,
   parameter         INTERFACE_TYPE      = "MEMORY",
   parameter         IOBDELAY            = "NONE",
   parameter [0:0]   IS_CLKB_INVERTED    = 1'b0,
   parameter [0:0]   IS_CLKDIVP_INVERTED = 1'b0,
   parameter [0:0]   IS_CLKDIV_INVERTED  = 1'b0,
   parameter [0:0]   IS_CLK_INVERTED     = 1'b0,
   parameter [0:0]   IS_D_INVERTED       = 1'b0,
   parameter [0:0]   IS_OCLKB_INVERTED   = 1'b0,
   parameter [0:0]   IS_OCLK_INVERTED    = 1'b0,
   parameter integer NUM_CE              = 2,
   parameter         OFB_USED            = "FALSE",
   parameter         SERDES_MODE         = "MASTER",
   parameter [0:0]   SRVAL_Q1            = 1'b0,
   parameter [0:0]   SRVAL_Q2            = 1'b0,
   parameter [0:0]   SRVAL_Q3            = 1'b0,
   parameter [0:0]   SRVAL_Q4            = 1'b0
)(
   output O,
   output Q1,
   output Q2,
   output Q3,
   output Q4,
   output Q5,
   output Q6,
   output Q7,
   output Q8,
   output SHIFTOUT1,
   output SHIFTOUT2,

   input  BITSLIP,
   input  CE1,
   input  CE2,
   input  CLK,
   input  CLKB,
   input  CLKDIV,
   input  CLKDIVP,
   input  D,
   input  DDLY,
   input  DYNCLKDIVSEL,
   input  DYNCLKSEL,
   input  OCLK,
   input  OCLKB,
   input  OFB,
   input  RST,
   input  SHIFTIN1,
   input  SHIFTIN2
);
endmodule: ISERDESE2

//--------------------------
// verilator lint_on WIDTH

//==========================================================================
// End-of-File
//==========================================================================
