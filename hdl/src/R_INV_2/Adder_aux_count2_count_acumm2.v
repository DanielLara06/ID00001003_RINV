/******************************************************************
*Module name : Adder_aux_count2_count_acumm2
*Filename    : Adder_aux_count2_count_acumm2.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to sum aux_count2_count_acumm2
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

module Adder_aux_count2_count_acumm2
#(
    parameter ADDR_WIDTH  =  11     // Size of the square R matrix bits      
)

(
	input [ADDR_WIDTH-1:0] x_i, //aux_count2
	input [ADDR_WIDTH-1:0] y_i, //count_acumm2
	
	output  [ADDR_WIDTH-1:0] result_o 

);

assign result_o = x_i + y_i;

endmodule 
