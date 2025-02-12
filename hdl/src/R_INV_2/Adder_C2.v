/******************************************************************
*Module name : Adder_C2
*Filename    : Adder_C2.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to index real/imag data from R mem
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

module Adder_C2
#(
    parameter ADDR_WIDTH  =   11       // Address bits       
)

(
	input [ADDR_WIDTH:0] x_i, 
	input [ADDR_WIDTH:0] y_i,//
	
	output  [ADDR_WIDTH:0] result_o 

);

assign result_o = x_i + y_i;

endmodule 