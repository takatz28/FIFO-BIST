/***************************************************************************
 *** Filename: MEMORY.sv			 Created by: Louis Tacata 04-23-2020 ***
 ***************************************************************************
 *** Module description of a scalable register file memory.				 ***
 ***************************************************************************/
`timescale 1ns/1ps
module MEMORY #(
	DATA_WIDTH = 8,
	ADDR_WIDTH = 4,
	DEPTH = 10
	)
	(
	input W_CLK, R_CLK,
	input W_EN, R_EN,
	input [DATA_WIDTH-1:0] W_DATA,
	input [ADDR_WIDTH-1:0] W_ADDR, R_ADDR,
	output reg [DATA_WIDTH-1:0] R_DATA
	);

	reg [DATA_WIDTH-1:0] MEM_ARRAY [0:DEPTH-1];
	// write process

	always_ff @ (posedge W_CLK)
		begin
		if(W_EN)
			MEM_ARRAY[W_ADDR] <= W_DATA;
		else
			MEM_ARRAY[W_ADDR] <= MEM_ARRAY[W_ADDR];
	end
	// read process
	always_ff @ (posedge R_CLK) begin
		if(R_EN)
			R_DATA <= MEM_ARRAY[R_ADDR];
		else
			R_DATA <= R_DATA;
	end
endmodule