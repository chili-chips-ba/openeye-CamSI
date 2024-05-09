// (C) 2001-2017 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


////////////////////////////////////////////////////////////////////
//
//   ALTERA_INT_OSC
//
//  Copyright (C) 1991-2013 Altera Corporation
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, Altera MegaCore Function License 
//  Agreement, or other applicable license agreement, including, 
//  without limitation, that your use is for the sole purpose of 
//  programming logic devices manufactured by Altera and sold by 
//  Altera or its authorized distributors.  Please refer to the 
//  applicable agreement for further details.
//
////////////////////////////////////////////////////////////////////

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

`timescale 1 ps / 1 ps

module  altera_int_osc
	( 
	clkout,
	oscena);

	parameter DEVICE_FAMILY   = "MAX 10";
	parameter DEVICE_ID       = "08";
	parameter CLOCK_FREQUENCY = "dummy";
	
	output   clkout;
	input   oscena;
	
	wire  wire_clkout;
	
	assign clkout = wire_clkout;
		
	// -------------------------------------------------------------------
	// Instantiate wysiwyg for chipidblock according to device family
	// -------------------------------------------------------------------	
	generate
		if (DEVICE_FAMILY == "MAX 10") begin
			fiftyfivenm_oscillator # (	//MAX 10
				.device_id(DEVICE_ID),
				.clock_frequency(CLOCK_FREQUENCY)
			) oscillator_dut ( 
				.clkout(wire_clkout),
				.clkout1(),
				.oscena(oscena));
			end
	endgenerate
	
endmodule //altera_int_osc
//VALID FILE
