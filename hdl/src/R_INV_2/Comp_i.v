/******************************************************************
*Module name : Comp_i
*Filename    : Comp_i.v
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

module Comp_i 
#(
    parameter N_SIZE  =   6     // Size of the square R matrix bits     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] Comp_x_i,//N
	input [N_SIZE-1:0] Comp_y_i, //i
	
	output [2:0] Comp_o

);


assign Comp_o = (Comp_y_i == ({{(N_SIZE-1){1'b0}}, 1'b0})) ? 3'b000 : //i = 0
                (Comp_y_i == {{(N_SIZE-1){1'b0}}, 1'b1}) ? 3'b001 : //i = 1
                (Comp_y_i > {{(N_SIZE-1){1'b0}}, 1'b1} && Comp_y_i < (Comp_x_i - {{(N_SIZE-1){1'b0}},1'b1})) ? 3'b010 : // > 1 && <= 47
                (Comp_y_i >= (Comp_x_i - {{(N_SIZE-2){1'b0}},2'b10})) ? 3'b100 : 3'b111;//i == N             > 47
                
					 // le quite un = (Comp_y_i > Comp_x_i) ? 3'b100 : //i > N
                //3'b111; // Valor por defecto si ninguna condición se cumple

endmodule 