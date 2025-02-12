/******************************************************************
*Module name : Comp_R
*Filename    : Comp_R.v
*Type        : Verilog Module
*
*Description :  Parametric Comparator module.  
*					
*------------------------------------------------------------------
*	clocks    : none,
*	reset		 : none,
* 
*Parameters  : DATA_WIDTH = 32; 
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Comp_R 
#(
    parameter DATA_WIDTH = 32     // Size of the square R matrix bits
)

(
	input [DATA_WIDTH-1:0] Comp_x_i,
	input [DATA_WIDTH-1:0] Comp_y_i, //0
	
	output Comp_o

);

assign Comp_o = (Comp_x_i != (Comp_y_i))?1'b1:1'b0;


endmodule 