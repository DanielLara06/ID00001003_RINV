/******************************************************************
*Module name : Subs_regresive_count
*Filename    : Subs_regresive_count.v
*Type        : Verilog Module
*
*Description : Parametric substraction module.  
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : DATA_WIDTH = 32; ADDR_WIDTH = 11; N_SIZE = 6; DATA_WIDTH_CMPLX = 16; 
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Subs_regresive_count
#(
	 parameter N_SIZE    =   6     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] x_i,
	input [N_SIZE-1:0] y_i,
	
	output  [N_SIZE-1:0] result_o

);

assign result_o = x_i - y_i;

endmodule 