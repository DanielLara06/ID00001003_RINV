/******************************************************************
*Module name : Adder_val_d
*Filename    : Adder_val_d.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to load diagonal R_real value.  
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : parameter elmnts_dif_zero_bits    =   11       // elements bits
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Adder_val_d
#(
    parameter elmnts_dif_zero_bits    =   11       // elements bits
)

(
	input [elmnts_dif_zero_bits-1:0] x_i,
	input [elmnts_dif_zero_bits-1:0] y_i,//1
	
	output  [elmnts_dif_zero_bits-1:0] result_o

);

assign result_o = x_i + y_i;

endmodule 