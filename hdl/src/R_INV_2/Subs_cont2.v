/******************************************************************
*Module name : Subs_cont2
*Filename    : Subs_cont2.v
*Type        : Verilog Module
*
*Description : Parametric Substraction module to count2 to index R_Vector2 memory .  
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

module Subs_cont2
#(
    parameter elmnts_dif_zero_bits    =   11       // elements bits
)

(
	input [elmnts_dif_zero_bits-1:0] x_i,
	input [elmnts_dif_zero_bits-1:0] y_i,//1
	
	output  [elmnts_dif_zero_bits-1:0] result_o

);

assign result_o = x_i - y_i;

endmodule 