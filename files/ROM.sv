/***************************************************************************
 *** Filename: ROM.sv				 Created by: Louis Tacata 04-30-2020 ***
 ***************************************************************************
 *** This module contains a 10-deep, scalable data width ROM.			 ***
 ***************************************************************************/
`timescale 1ns / 1ps
module ROM #(SIZE=10) (
	input R_CLK, EN,
	input [3:0] ADDR,
	output reg [SIZE-1:0] DATA
	);

	reg [SIZE-1:0] MEM_ARRAY [0:SIZE-1];

	always_ff @ (posedge R_CLK)
		DATA <= (EN) ? MEM_ARRAY[ADDR]: DATA;
endmodule