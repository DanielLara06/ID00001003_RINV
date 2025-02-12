/******************************************************************
*Module name : Subs_count_elmnts
*Filename    : Subs_count_elmnts.v
*Type        : Verilog Module
*
*Description : Parametric Substraction module to count elemnts.  
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

module Subs_count_elmnts
#(
    parameter N_SIZE  =   6     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] x_i,
	input [N_SIZE-1:0] y_i,
	
	output  [N_SIZE-1:0] result_o

);

assign result_o = x_i - y_i;

endmodule 

