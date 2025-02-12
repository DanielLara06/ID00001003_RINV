/******************************************************************
*Module name : index_r
*Filename    : index_r.v
*Type        : Verilog Module
*
*Description : Auxiliar Parametric Adder module to index real/imag data from R^-1 mem
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : ADDR_WIDTH  =   11       // Address bits       
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module index_r
#(
    parameter ADDR_WIDTH  =   11       // Address bits       
)

(
	input [ADDR_WIDTH:0] x_i, 
	input [ADDR_WIDTH:0] y_i,//1
	
	output  [ADDR_WIDTH:0] result_o 

);

assign result_o = x_i - y_i;

endmodule 