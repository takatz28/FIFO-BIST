/***************************************************************************
 *** Filename: R_PTR_GEN.sv			 Created by: Louis Tacata 04-27-2020 ***
 ***************************************************************************
 *** Module description of the pointer and empty flag generator for the	 ***
 *** FIFO's read side.													 ***
 *** -- Revision 1: Used Johnson counter for 10-deep pointers			 ***
 *** -- Revision 0: Used a modified Gray code for pointers				 ***
 ***************************************************************************/
`timescale 1ns/1ps
module R_PTR_GEN #(SIZE = 4) (
	input CLK, RST, INC,
	input [SIZE:0] W_PTR,
	output reg [SIZE-1:0] R_ADDR,
	output reg [SIZE:0] R_PTR,
	output reg R_EMPTY
	);
	
	reg [SIZE-1:0] ADDR_NXT;
	reg [SIZE:0] PTR_NXT;
	reg R_EMP_NXT;
	
	// counters logic
	always_ff @ (posedge CLK, negedge RST) begin
		if (!RST) begin
			R_ADDR <= 0;
			R_PTR <= 0;
			R_EMPTY <= 1;
		end
		else begin
			R_EMPTY <= R_EMP_NXT;
			R_PTR <= PTR_NXT;
			R_ADDR <= ADDR_NXT;
		end
	end
	
	// next-state logic
	always_comb begin
		ADDR_NXT = (R_ADDR == 9) ? 0 : (INC) ? R_ADDR + INC : R_ADDR;
		// pointer encoding using Johnson counter
		PTR_NXT = (INC) ? {R_PTR[SIZE-1:0], !R_PTR[SIZE]} : R_PTR;
		// empty flag is generated when the next read pointer is
		// equal to the synchronized write pointer
		R_EMP_NXT = (INC) ? (PTR_NXT == W_PTR) : R_EMPTY; 
	end
endmodule