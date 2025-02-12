/******************************************************************
*Module name : Adder_dd
*Filename    : Adder_dd.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to index real/imag data from R mem
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : N_SIZE  =   6       // Address bits   
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Adder_dd
#(
    parameter N_SIZE  =   6       // Address bits       
)

(
	input [N_SIZE-1:0] x_i, 
	input [N_SIZE-1:0] y_i,//1
	
	output  [N_SIZE-1:0] result_o 

);

assign result_o = x_i + y_i;

endmodule 