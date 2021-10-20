/***************************************************************************
 *** Filename: SYNC.sv				 Created by: Louis Tacata 04-19-2020 ***
 ***************************************************************************
 *** Module description of a scalable synchronizer.						 ***
 ***************************************************************************/
`timescale 1ns/1ps
module SYNC #(SIZE = 1) (
	input CLK, RST,
	input [SIZE-1:0] DIN,
	output reg [SIZE-1:0] DOUT
	);

	reg [SIZE-1:0] TMP;

	always_ff @ (posedge CLK, negedge RST) begin
		if (!RST) begin
			TMP <= 0;
			DOUT <= 0;
		end
		else begin
			TMP <= DIN;
			DOUT <= TMP;
		end
	end
endmodule