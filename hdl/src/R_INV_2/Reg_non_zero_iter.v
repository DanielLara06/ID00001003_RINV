/******************************************************************
*Module name : Reg_non_zero_iter
*Filename    : Reg_non_zero_iter.v
*Type        : Verilog Module
*
*Description : Parametric register module for non zero elements.  
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk",
*	reset		 : sync rstn,
* 
*Parameters  : N_SIZE  =   6; 
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/
module Reg_non_zero_iter
#(
    parameter N_SIZE  =   6     // Size of the square R matrix bits
)

(
	input clk,
	input rstn,
	input [N_SIZE-1:0] reg_i,
	input En,
	input Clr,
	
	output reg [N_SIZE-1:0] reg_o

);

always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			reg_o <= {N_SIZE{1'b0}};
		else if(Clr)
			reg_o <= {N_SIZE{1'b0}};
		else if(En)
			reg_o <= reg_i;
end

endmodule 