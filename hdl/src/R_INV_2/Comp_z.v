/******************************************************************
*Module name : Comp_z
*Filename    : Comp_z.v
*Type        : Verilog Module
*
*Description :  Parametric Comparator module to limit for cycle. 
*					
*------------------------------------------------------------------
*	clocks    : none,
*	reset		 : none,
* 
*Parameters  : ADDR_WIDTH    =   11, N_SIZE    =   6  // Size of the square R matrix bits
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Comp_z 
#(
    parameter ADDR_WIDTH    =   11,     // Size of the square R matrix bits     // Size of the square R matrix bits
	 parameter N_SIZE    =   6
)

(
	input [ADDR_WIDTH:0] Comp_x_i,//Out
	input [N_SIZE-1:0] Comp_y_i, //N
	
	output Comp_o

);

wire [(2*N_SIZE-1):0] N_N;

assign N_N = Comp_y_i*Comp_y_i;


assign Comp_o = (Comp_x_i > (N_N - {{(N_SIZE-2){1'b0}}, 2'b10})) ? 1'b1:1'b0; //Z > (N*N-1) (Z > 2303) 
                

endmodule 