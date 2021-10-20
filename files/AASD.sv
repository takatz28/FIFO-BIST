/***************************************************************************
 *** Filename: AASD.sv				 Created by: Louis Tacata 04-23-2020 ***
 ***************************************************************************
 *** Module description of the active-low reset synchronizer.			 ***
 ***************************************************************************/
`timescale 1 ns / 1 ns
module AASD(
	input CLK, RST_IN,
	output reg RST_OUT
	);

	reg R_TMP;

	always_ff @ (posedge CLK, negedge RST_IN) begin
		if (!RST_IN) begin
			R_TMP <= 0;
			RST_OUT <= 0;
		end
		else begin
			R_TMP <= 1;
			RST_OUT <= R_TMP;
		end
	end
endmodule