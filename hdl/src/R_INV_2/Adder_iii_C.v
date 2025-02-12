/******************************************************************
*Module name : Adder_iii_C
*Filename    : Adder_iii_C.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to sum iii + C
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : ADDR_WIDTH    =   11,       // Address bits             
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Adder_iii_C
#(
    parameter ADDR_WIDTH  =  11     // Size of the square R matrix bits      
)

(
	input [ADDR_WIDTH-1:0] x_i, //iii
	input [ADDR_WIDTH-1:0] y_i, //C
	
	output  [ADDR_WIDTH-1:0] result_o 

);

assign result_o = x_i + y_i;

endmodule 
