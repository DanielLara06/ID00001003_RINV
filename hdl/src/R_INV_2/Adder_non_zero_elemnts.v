/******************************************************************
*Module name : Adder_non_zero_elemnts
*Filename    : Adder_non_zero_elemnts.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to non zero matrix elemnts.  
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : N_SIZE = 6; elmnts_dif_zero_bits  =   11; 
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Adder_non_zero_elemnts
#(
    parameter elmnts_dif_zero_bits    =   11,       // Address bits
	 parameter N_SIZE    =   6     // Size of the square R matrix bits
)

(
	input [elmnts_dif_zero_bits-1:0] x_i,
	input [N_SIZE-1:0] y_i, //6 bits
	
	output  [elmnts_dif_zero_bits-1:0] result_o

);

assign result_o = x_i + y_i;

endmodule 