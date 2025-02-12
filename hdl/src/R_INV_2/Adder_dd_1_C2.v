/******************************************************************
*Module name : Adder_dd_1_C2
*Filename    : Adder_dd_1_C2.v
*Type        : Verilog Module
*
*Description : Parametric Adder/Subs module for dd-1
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  :  ADDR_WIDTH  =   11,       // Address bits             
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Adder_dd_1_C2
#(
    parameter ADDR_WIDTH = 11     // Size of the square R matrix bits      
)

(
	input [ADDR_WIDTH:0] x_i, //dd
	input [ADDR_WIDTH:0] y_i, //1
	
	output  [ADDR_WIDTH:0] result_o 

);

assign result_o = x_i + y_i;

endmodule 