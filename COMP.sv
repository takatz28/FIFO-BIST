/***************************************************************************
 *** Filename: COMP.sv				 Created by: Louis Tacata 05-01-2020 ***
 ***************************************************************************
 *** This module compares the FIFO and ROM outputs during read mode.	 ***
 ***************************************************************************/
`timescale 1ns / 1ps
module COMP #(SIZE=10) (
	input EN,
	input [SIZE-1:0] DATA_A, DATA_B,
	output reg PASS
	);
	
	reg PASS_TMP;
	
	always_comb begin
		PASS_TMP = EN && (DATA_A == DATA_B);
		// ensures only 0 and 1 outputs
		case(PASS_TMP)
			1: PASS <= 1;
			default: PASS <= 0;
		endcase
	end
endmodule