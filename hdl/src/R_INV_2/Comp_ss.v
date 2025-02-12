/******************************************************************
*Module name : Comp_ss
*Filename    : Comp_ss.v
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

module Comp_ss 
#(
    parameter N_SIZE  =   6     // Size of the square R matrix bits     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] Comp_x_i,//SS
	input [N_SIZE-1:0] Comp_y_i, //S
	
	output Comp_o

);


assign Comp_o = (Comp_x_i == (Comp_y_i)) ? 1'b1 : 1'b0;// SS == S//(Comp_x_i > (Comp_y_i)) ? 2'b00 : //SS > S - {{(N_SIZE-1){1'b0}}, 1'b1} 
					 //(Comp_x_i == (Comp_y_i)) ? 2'b01:  2'b10;// SS == S
			
                

endmodule 