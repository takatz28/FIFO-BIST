/***************************************************************************
 *** Filename: FIFO.sv				 Created by: Louis Tacata 04-27-2020 ***
 ***************************************************************************
 *** Top-level module for the FIFO buffer.								 ***
 ***************************************************************************/
`timescale 1ns/1ps
module FIFO #(
	DATA_WIDTH = 8,
	ADDR_WIDTH = 4,
	DEPTH = 10
	)
	(
	input W_CLK, R_CLK, W_RST, R_RST,
	input W_EN, R_EN,
	input [DATA_WIDTH-1:0] W_DATA,
	output [DATA_WIDTH-1:0] R_DATA,
	output wire FULL, EMPTY
	);
	
	wire W_RST_SYNC, R_RST_SYNC;
	wire [ADDR_WIDTH-1:0] W_ADDR, R_ADDR;
	wire [ADDR_WIDTH:0] W_PTR, R_PTR;
	wire [ADDR_WIDTH:0] W_PTR_SYNC, R_PTR_SYNC;
	
	// reset synchronizer instantiations
	AASD WRST(.CLK(W_CLK), .RST_IN(W_RST), .RST_OUT(W_RST_SYNC));
	AASD RRST(.CLK(R_CLK), .RST_IN(R_RST), .RST_OUT(R_RST_SYNC));
	
	// synchronizer instantiations
	SYNC #(.SIZE(ADDR_WIDTH+1)) W_SYNC(.CLK(W_CLK), .RST(W_RST_SYNC),
		   .DIN(R_PTR), .DOUT(W_PTR_SYNC));
	SYNC #(.SIZE(ADDR_WIDTH+1)) R_SYNC(.CLK(R_CLK), .RST(R_RST_SYNC),
		   .DIN(W_PTR), .DOUT(R_PTR_SYNC));
	
	// write pointer/full flag generator instantiation
	W_PTR_GEN #(.SIZE(ADDR_WIDTH)) WGEN(.CLK(W_CLK), .RST(W_RST_SYNC),
				.R_PTR(R_PTR_SYNC), .W_ADDR(W_ADDR), .INC(W_EN),
				.W_PTR(W_PTR), .W_FULL(FULL));
	
	// read pointer/empty flag generator instantiation
	R_PTR_GEN #(.SIZE(ADDR_WIDTH)) RGEN(.CLK(R_CLK), .RST(R_RST_SYNC),
				.W_PTR(W_PTR_SYNC), .R_ADDR(R_ADDR), .INC(R_EN),
				.R_PTR(R_PTR), .R_EMPTY(EMPTY));
	
	// RAM register file instantiation
	MEMORY #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .DEPTH(DEPTH))
		FIFO_MEM(.W_CLK(W_CLK), .R_CLK(R_CLK),
				 .W_EN(W_EN), .R_EN(R_EN),
				 .W_DATA(W_DATA), .W_ADDR(W_ADDR),
				 .R_ADDR(R_ADDR), .R_DATA(R_DATA));
endmodule