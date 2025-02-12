/******************************************************************
*Module name : Comp_ii
*Filename    : Comp_ii.v
*Type        : Verilog Module
*
*Description :  Parametric 3 bits Comparator module.  
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

module Comp_ii 
#(
    parameter N_SIZE  =   6     // Size of the square R matrix bits     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] Comp_x_i,//N
	input [N_SIZE-1:0] Comp_y_i, //count2
	input [N_SIZE-1:0] Comp_z_i, //ii
	
	output [1:0] Comp_o

);

wire [N_SIZE-1:0] N_count2;

assign N_count2 = ((Comp_x_i) - Comp_y_i); //((47-1)-count2) 46

assign Comp_o = (Comp_z_i == ({{(N_SIZE-1){1'b0}}, 1'b0})) ? 2'b00 : //ii == 0 (1)
                (Comp_z_i == {{(N_SIZE-1){1'b0}}, 1'b1}) ? 2'b01 : //ii == 1 (2)
					 ((Comp_z_i >= {{(N_SIZE-1){1'b0}}, 1'b1} && Comp_z_i < (N_count2)) ) ? 2'b10 : 2'b11;	//	Comp_z_i > {{(N_SIZE-1){1'b0}}, 1'b1} && Comp_z_i < (N_count2)														
                //2'b01; // Valor por defecto si ninguna condición se cumple

endmodule 