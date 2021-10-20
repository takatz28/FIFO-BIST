/***************************************************************************
 *** Filename: W_PTR_GEN.sv			 Created by: Louis Tacata 04-27-2020 ***
 ***************************************************************************
 *** Module description of the pointer and full flag generator for the	 ***
 *** FIFO's write side.													 ***
 *** -- Revision 1: Used Johnson counter for 10-deep pointers			 ***
 *** -- Revision 0: Used a modified Gray code for pointers 				 ***
 ***************************************************************************/
`timescale 1ns/1ps
module W_PTR_GEN #(SIZE = 4) (
	input CLK, RST, INC,
	input [SIZE:0] R_PTR,
	output reg [SIZE-1:0] W_ADDR,
	output reg [SIZE:0] W_PTR,
	output reg W_FULL
	);

	reg [SIZE-1:0] ADDR_NXT;
	reg [SIZE:0] PTR_NXT;
	reg W_FULL_NXT;

	// counters logic
	always_ff @ (posedge CLK, negedge RST) begin
		if (!RST) begin
			W_ADDR <= 0;
			W_PTR <= 0;
			W_FULL <= 0;
		end
		else begin
			W_FULL <= W_FULL_NXT;
			W_ADDR <= ADDR_NXT;
			W_PTR <= PTR_NXT;
		end
	end
	
	// next state logic
	always_comb begin
		ADDR_NXT = (W_ADDR == 9) ? 0 : INC ? W_ADDR + INC : W_ADDR;
		// pointer encoding using Johnson counter
		PTR_NXT = INC ? {W_PTR[SIZE-1:0], !W_PTR[SIZE]} : W_PTR;
		// full flag is generated when the synchronized read pointer
		// is equal to the write pointer
		W_FULL_NXT = (INC) ? (W_PTR == {!R_PTR[SIZE], R_PTR[SIZE-1:0]}) :
		W_FULL;
	end
endmodule