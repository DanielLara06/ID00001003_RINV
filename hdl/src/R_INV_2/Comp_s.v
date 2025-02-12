/******************************************************************
*Module name : Comp_s
*Filename    : Comp_s.v
*Type        : Verilog Module
*
*Description :  Parametric Comparator module to limit for cycle. 
*					
*------------------------------------------------------------------
*	clocks    : none,
*	reset		 : none,
* 
*Parameters  : N_SIZE    =   6,     // Size of the square R matrix bits
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Comp_s 
#(
    parameter N_SIZE  =   6     // Size of the square R matrix bits     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] Comp_x_i,//S
	input [N_SIZE-1:0] Comp_y_i, //N
	
	output Comp_o

);


assign Comp_o = (Comp_x_i == (Comp_y_i - {{(N_SIZE-1){1'b0}}, 1'b1})) ? 1'b1:1'b0; //S > 47 
                

endmodule 