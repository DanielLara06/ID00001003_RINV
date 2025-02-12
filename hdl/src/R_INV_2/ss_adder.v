/******************************************************************
*Module name : ss_adder
*Filename    : ss_adder.v
*Type        : Verilog Module
*
*Description : Auxiliar Parametric Adder module to index real/imag data from R^-1 mem
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : N_SIZE  =   6       // Address bits       
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module ss_adder
#(
    parameter N_SIZE  =   6      // Address bits       
)

(
	input [N_SIZE-1:0] x_i, 
	input [N_SIZE-1:0] y_i,//1
	
	output  [N_SIZE-1:0] result_o 

);

assign result_o = x_i + y_i;

endmodule 