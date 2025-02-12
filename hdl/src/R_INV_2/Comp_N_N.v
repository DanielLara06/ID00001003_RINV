/******************************************************************
*Module name : Comp_N_N
*Filename    : Comp_N_N.v
*Type        : Verilog Module
*
*Description :  Parametric Comparator module.  
*					
*------------------------------------------------------------------
*	clocks    : none,
*	reset		 : none,
* 
*Parameters  : elmnts_dif_zero_bits    =   11     // Size of the square R matrix bits
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Comp_N_N 
#(
    parameter elmnts_dif_zero_bits    =   11     // Size of the square R matrix bits
)

(
	input [elmnts_dif_zero_bits:0] Comp_x_i,//reg_N_N  12 bits
	input [elmnts_dif_zero_bits-1:0] Comp_y_i, //N-1 47+1
	
	output Comp_o

);

wire [elmnts_dif_zero_bits:0] partial_result;
assign partial_result = ((Comp_y_i)*(Comp_y_i)); //- {{(elmnts_dif_zero_bits-1){1'b0}},1'b1}

assign Comp_o = (Comp_x_i > partial_result - {{(elmnts_dif_zero_bits){1'b0}},1'b1})?1'b1:1'b0; //48*48 = 2303 - 1 = 2302 -// {{(elmnts_dif_zero_bits-1){1'b0},1'b1}}


endmodule 