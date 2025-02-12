/******************************************************************
*Module name : Comp_dd
*Filename    : Comp_dd.v
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

module Comp_dd 
#(
    parameter N_SIZE  =   6     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] Comp_x_i,//dd o dd-1
	input [N_SIZE-1:0] Comp_y_i, //d o d-1
	
	output [1:0] Comp_o

);

assign Comp_o = (Comp_x_i == 6'b000000) ? 2'b00: //dd == 0 
               //(Comp_x_i != 6'b000000) ? 2'b10 : //dd > 0   && Comp_x_i < Comp_y_i
					(Comp_x_i > Comp_y_i) ? 2'b01 : //dd > d
					2'b10; // Valor por defecto si ninguna condición se cumple


endmodule 
