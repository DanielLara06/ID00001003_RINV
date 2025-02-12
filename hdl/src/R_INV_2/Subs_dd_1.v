/******************************************************************
*Module name : Subs_dd_1
*Filename    : Subs_dd_1.v
*Type        : Verilog Module
*
*Description : Parametric Adder/Subs module for dd-1
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : N_SIZE    =   6,       // Address bits             
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Subs_dd_1
#(
    parameter N_SIZE  =  6     // Size of the square R matrix bits      
)

(
	input [N_SIZE-1:0] x_i, //dd
	input [N_SIZE-1:0] y_i, //1
	
	output  [N_SIZE-1:0] result_o 

);

assign result_o = x_i - y_i;

endmodule 