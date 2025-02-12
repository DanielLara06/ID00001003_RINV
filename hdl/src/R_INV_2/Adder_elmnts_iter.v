/******************************************************************
*Module name : Adder_elmnts_iter
*Filename    : Adder_elmnts_iter.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to iter count elemnts.  
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : N_SIZE = 6;
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/


module Adder_elmnts_iter
#(
	 parameter N_SIZE    =   6     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] x_i,
	input [N_SIZE-1:0] y_i,
	
	output  [N_SIZE-1:0] result_o

);

assign result_o = x_i + y_i;

endmodule 

