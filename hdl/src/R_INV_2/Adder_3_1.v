/******************************************************************
*Module name : Adder_3_1
*Filename    : Adder_3_1.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to sum aux_count3 + elements + 1
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : N_SIZE =  6     // Size of the square R matrix bits             
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Adder_3_1
#(
    parameter N_SIZE =  6     // Size of the square R matrix bits      
)

(
	input [N_SIZE-1:0] x_i, //aux_count3
	input [N_SIZE-1:0] y_i, //elements
	input [N_SIZE-1:0] z_i, //1
	
	output  [N_SIZE-1:0] result_o 

);

assign result_o = x_i + y_i + z_i;

endmodule 
