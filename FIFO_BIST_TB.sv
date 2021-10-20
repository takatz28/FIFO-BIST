/***************************************************************************
 *** Filename: FIFO_BIST_TB.sv		 Created by: Louis Tacata 05-05-2020 ***
 ***************************************************************************
 *** This module provides the test stimuli for the top-level module		 ***
 *** which tests both normal and BIST modes of the FIFO.				 ***
 ***************************************************************************/
`timescale 1ns / 1ps
`define BIST_EN
module FIFO_BIST_TB();
	parameter DATA_WIDTH = 10,
			  ADDR_WIDTH = 4,
			  DEPTH = 10;
	reg W_CLK, R_CLK, W_RST, R_RST;
	reg W_EN, R_EN;
	reg BIST;
	reg [DATA_WIDTH-1:0] W_DATA;
	wire [DATA_WIDTH-1:0] R_DATA;
	wire FULL, EMPTY, PASS;

	FIFO_BIST #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
			    .DEPTH(DEPTH))
		UUT(.W_CLK(W_CLK), .R_CLK(R_CLK), .W_RST(W_RST),
			.R_RST(R_RST), .W_EN(W_EN), .R_EN(R_EN),
			.BIST(BIST), .W_DATA(W_DATA), .R_DATA(R_DATA),
			.FULL(FULL), .EMPTY(EMPTY), .PASS(PASS));
	
	// write clock generator
	initial W_CLK = 0;
	always #(1.25) W_CLK = !W_CLK;
	
	// read clock generator
	initial R_CLK = 0;
	always #(12.5) R_CLK = !R_CLK;
	
	// loading ROM with walking ones pattern
	initial $readmemh("MEMORY.txt", UUT.TEST_MEM.MEM_ARRAY);
	
	// If BIST_EN is defined, the FIFO is in test mode
	`ifdef BIST_EN
		initial begin
			W_RST = 0; R_RST = 0; W_EN = 0; R_EN = 0;
			BIST = 0;
			#10 W_RST = 1; R_RST = 1;
			#20 BIST = 1;
			#275 R_EN = 0; BIST = 0;
			#25 $finish;
		end
	`else
	// This simulates the normal functions of a FIFO
		integer i = 0;
		task burstWrite;
			#(92.5)
			W_EN = 1; W_DATA = 0;
			for(i = 1; i < 10; i=i+1)
			begin
				#(2.5) W_DATA = i;
			end
			#(2.5) W_EN = 0;
		endtask
		initial begin
			W_RST = 0; R_RST = 0; W_CLK = 0;
			R_EN = 0; W_EN = 0; BIST = 0;
			#5 W_RST = 1; R_RST = 1;
			burstWrite();
			#(27.5) R_EN = 1;
			#250 R_EN = 0;
			#20 $finish;
		end
	`endif
endmodule