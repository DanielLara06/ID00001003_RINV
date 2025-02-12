/******************************************************************
*Module name : Adder_x_d
*Filename    : Adder_x_d.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to load diagonal R_real value.  
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : N_SIZE    =   6,     // Size of the square R matrix bits      
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Adder_x_d
#(
    parameter N_SIZE = 6       // elements bits
)

(
	input [N_SIZE-1:0] x_i,
	input [N_SIZE-1:0] y_i,//1
	
	output  [N_SIZE-1:0] result_o

);

assign result_o = x_i + y_i;

endmodule 