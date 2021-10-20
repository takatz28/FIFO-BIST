/***************************************************************************
 *** Filename: FIFO_BIST.sv			 Created by: Louis Tacata 05-03-2020 ***
 ***************************************************************************
 *** This is the top-level module for the FIFO module with integrated	 ***
 *** memory BIST.														 ***
 ***************************************************************************/
`timescale 1ns / 1ps
module FIFO_BIST #(
	DATA_WIDTH = 10,
	ADDR_WIDTH = 4,
	DEPTH = 10
	)
	(
	input W_CLK, R_CLK, W_RST, R_RST,
	input W_EN, R_EN,
	input BIST,
	input [DATA_WIDTH-1:0] W_DATA,
	output reg [DATA_WIDTH-1:0] R_DATA,
	output wire FULL, EMPTY,
	output wire PASS
	);

	wire [3:0] ADDR;
	wire [9:0] DIN, ROM_DATA, FIFO_DATA;
	wire BIST_W_EN, BIST_R_EN;
	reg [9:0] DIN_NEXT;
	reg W_EN_NEXT, R_EN_NEXT;

	// r/w counters instantiation
	COUNTERS CNT_GEN(.W_CLK(W_CLK), .R_CLK(R_CLK),
					 .W_RST(W_RST), .R_RST(R_RST),
					 .W_EN(W_EN_NEXT), .R_EN(R_EN_NEXT),
					 .DIN(DIN), .ADDR(ADDR));
					 
	// top-level FIFO instantiation
	FIFO #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		   .DEPTH(DEPTH))
	   MEM(.W_CLK(W_CLK), .R_CLK(R_CLK), .W_RST(W_RST),
		   .R_RST(R_RST), .W_EN(W_EN_NEXT), .R_EN(R_EN_NEXT),
		   .W_DATA(DIN_NEXT), .R_DATA(FIFO_DATA),
		   .FULL(FULL), .EMPTY(EMPTY));
		   
	// expected result ROM instantiation
	ROM #(.SIZE(DEPTH)) TEST_MEM(.R_CLK(R_CLK), .EN(BIST_R_EN),
								 .ADDR(ADDR), .DATA(ROM_DATA));

	// output comparator instantiation
	COMP #(.SIZE(DATA_WIDTH)) CMP(.EN(BIST_R_EN), .DATA_A(FIFO_DATA),
								  .DATA_B(ROM_DATA), .PASS(PASS));

	// BIST controller instantiation
	FSM BIST_CTRL(.CLK(W_CLK), .RST(W_RST), .BIST_EN(BIST),
				  .WRITE_CNT(DIN), .READ_CNT(ROM_DATA),
				  .W_EN(BIST_W_EN), .R_EN(BIST_R_EN));

	// MUX instantiations to toggle inputs depending on
	// operating mode
	always_comb begin
		DIN_NEXT = (BIST) ? DIN : W_DATA;
		R_DATA = (BIST) ? ROM_DATA : FIFO_DATA;
		W_EN_NEXT = (BIST) ? BIST_W_EN : W_EN;
		R_EN_NEXT = (BIST) ? BIST_R_EN : R_EN;
	end
endmodule