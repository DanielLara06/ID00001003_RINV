/******************************************************************
*Module name : Adder_count2
*Filename    : Adder_count2.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to iter columns process
*					helps the process to do effective iterations bet-
*					ween the data per column and the size of the matrix
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : N_SIZE =  6,     // Size of the square R matrix bits             
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Adder_count2
#(
    parameter N_SIZE =  6     // Size of the square R matrix bits      
)

(
	input [N_SIZE-1:0] x_i, 
	input [N_SIZE-1:0] y_i,//1
	
	output  [N_SIZE-1:0] result_o 

);

assign result_o = x_i + y_i;

endmodule 