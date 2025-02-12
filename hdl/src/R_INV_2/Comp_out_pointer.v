/******************************************************************
*Module name : Comp_out_pointer
*Filename    : Comp_out_pointer.v
*Type        : Verilog Module
*
*Description :  Parametric Comparator module.  
*					
*------------------------------------------------------------------
*	clocks    : none,
*	reset		 : none,
* 
*Parameters  : ADDR_WIDTH; 
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Comp_out_pointer 
#(
    parameter ADDR_WIDTH  =   11     // Size of the square R matrix bits
)

(
	input [ADDR_WIDTH-1:0] Comp_x_i,//C
	input [ADDR_WIDTH-1:0] Comp_y_i, //elements_dif_zero
	
	output Comp_o

);

assign Comp_o = (Comp_x_i == (Comp_y_i - {{(ADDR_WIDTH-1){1'b0}},1'b1}))?1'b1:1'b0; //- {{(ADDR_WIDTH-1){1'b0}},1'b1}


endmodule 