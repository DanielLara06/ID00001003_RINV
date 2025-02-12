/******************************************************************
*Module name : Comp_x_d
*Filename    : Comp_x_d.v
*Type        : Verilog Module
*
*Description :  Parametric 2 bits Comparator module.  
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

module Comp_x_d 
#(
    parameter N_SIZE    =   6     // Size of the square R matrix bits     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] Comp_x_i,//x
	input [N_SIZE-1:0] Comp_y_i, //N-1 11
	
	output [1:0] Comp_o

);

assign Comp_o = (Comp_x_i == ({{(N_SIZE-1){1'b0}},1'b0})) ? 2'b00: //x == 0
                (Comp_x_i > ({{(N_SIZE-1){1'b0}},1'b0}) && Comp_x_i <= (Comp_y_i)) ? 2'b01: //x > 0 -6'b000001
                (Comp_x_i >= (Comp_y_i+6'b000001)) ? 2'b10: //x > N-1   - {{(N_SIZE-1){1'b0}},1'b1}) -6'b000001    Comp_y_i-
                2'b00; // Valor por defecto si ninguna condición se cumple
				
endmodule 