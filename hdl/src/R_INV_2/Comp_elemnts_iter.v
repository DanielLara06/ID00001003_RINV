/******************************************************************
*Module name : Comp_elemnts_iter
*Filename    : Comp_elemnts_iter.v
*Type        : Verilog Module
*
*Description :  Parametric Comparator module.  
*					
*------------------------------------------------------------------
*	clocks    : none,
*	reset		 : none,
* 
*Parameters  : none; 
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Comp_elemnts_iter 
#(
    parameter N_SIZE  =   6     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] Comp_x_i,
	input [N_SIZE-1:0] Comp_y_i, //N-1
	
	output Comp_o

);

assign Comp_o = (Comp_x_i > (Comp_y_i - {{(N_SIZE-2){1'b0}},2'b10}))?1'b1:1'b0;


endmodule 