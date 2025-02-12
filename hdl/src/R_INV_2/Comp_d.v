/******************************************************************
*Module name : Comp_d
*Filename    : Comp_d.v
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

module Comp_d 
#(
    parameter N_SIZE  =   6     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] Comp_x_i,//d d-1
	input [N_SIZE-1:0] Comp_y_i, //N
	
	output Comp_o

);

assign Comp_o = (Comp_x_i > Comp_y_i - {{((N_SIZE-1)){1'b0}},1'b1}) ? 1'b1:1'b0;//- {{((N_SIZE-1)){1'b0}},1'b1}


endmodule 