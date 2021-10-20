/***************************************************************************
 *** Filename: FSM.sv				 Created by: Louis Tacata 05-02-2020 ***
 ***************************************************************************
 *** This module provides the read and write enable signals during		 ***
 *** the BIST mode.														 ***
 ***************************************************************************/
`timescale 1ns / 1ps
module FSM(
	input CLK, RST,
	input BIST_EN,
	input [9:0] WRITE_CNT, READ_CNT,
	output reg W_EN, R_EN
	);

	reg [1:0] CURR_STATE, NEXT_STATE;
	// state aliases
	localparam IDLE = 2'b00,
			   WRITE = 2'b01,
			   READ = 2'b10;
			   
	// current state logic
	always_ff @ (posedge CLK, negedge RST) begin
		if (!RST) 
			CURR_STATE <= IDLE;
		else 
			CURR_STATE <= NEXT_STATE;
	end

		// next-state logic
	always_comb begin
		case (CURR_STATE)
			IDLE: begin
				NEXT_STATE <= (BIST_EN) ? WRITE : IDLE;
			end
			WRITE: begin
				if (BIST_EN) begin
					if (WRITE_CNT == 10'h200)
						NEXT_STATE <= READ;
					else
						NEXT_STATE <= WRITE;
					end
				else
					NEXT_STATE <= IDLE;
			end
			READ: begin
				if (BIST_EN) begin
					if (READ_CNT == 10'h200 &&
						WRITE_CNT != 10'h001)
						NEXT_STATE <= IDLE;
					else
						NEXT_STATE <= READ;
					end
				else
					NEXT_STATE <= IDLE;
				end
			default:
				NEXT_STATE <= IDLE;
		endcase
	end
	
	// Moore outputs
	always_comb begin
		case (CURR_STATE)
			IDLE: begin
				W_EN <= 0;
				R_EN <= 0;
			end
			WRITE: begin
				W_EN <= 1;
				R_EN <= 0;
			end
			READ: begin
				W_EN <= 0;
				R_EN <= 1;
			end
			default: begin
				W_EN <= 0;
				R_EN <= 0;
			end
		endcase
	end
endmodule