/******************************************************************
*Module name : Adder_N_N
*Filename    : Adder_N_N.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to iter till N*N of the R matrizx elements.  
*					
*------------------------------------------------------------------1176
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : elmnts_dif_zero_bits    =   11;
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Adder_N_N
#(
    parameter elmnts_dif_zero_bits    =   11       // elements bits
)

(
	input [elmnts_dif_zero_bits:0] x_i,
	input [elmnts_dif_zero_bits:0] y_i,//1
	
	output  [elmnts_dif_zero_bits:0] result_o

);

assign result_o = x_i + y_i;

endmodule 