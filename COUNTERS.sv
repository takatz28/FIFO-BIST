/***************************************************************************
 *** Filename: COUNTERS.sv			 Created by: Louis Tacata 04-30-2020 ***
 ***************************************************************************
 *** This module generates two counts: walking ones (write mode)		 ***
 *** and decade count for memory addressing (read mode).				 ***
 ***************************************************************************/
`timescale 1ns / 1ps
module COUNTERS(
	input W_CLK, R_CLK,
	input W_RST, R_RST,
	input W_EN, R_EN,
	output reg [9:0] DIN,
	output reg [3:0] ADDR
	);

	wire W_RST_SYNC, R_RST_SYNC;

	// reset synchronizers
	AASD WRST(W_CLK, W_RST, W_RST_SYNC);
	AASD RRST(R_CLK, R_RST, R_RST_SYNC);

	// ring counter generator
	always_ff @ (posedge W_CLK, negedge W_RST_SYNC) begin
		if (!W_RST_SYNC) 
			DIN <= 1;
		else 
			DIN <= (W_EN) ? {DIN[8:0], DIN[9]} : DIN;
	end

	// memory address generator
	always_ff @ (posedge R_CLK, negedge R_RST_SYNC) begin
		if (!R_RST_SYNC) 
			ADDR <= 0;
		else 
			ADDR <= (R_EN) ? ((ADDR == 9) ? 0 : ADDR + 1) : ADDR;
	end
endmodule