/******************************************************************
*Module name : Comp_iii
*Filename    : Comp_iii.v
*Type        : Verilog Module
*
*Description :  Parametric 1 bit Comparator module.  
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

module Comp_iii 
#(
    parameter N_SIZE  =   6     // Size of the square R matrix bits     // Size of the square R matrix bits
)

(
	input [N_SIZE-1:0] Comp_x_i,//ii
	input [N_SIZE-1:0] Comp_y_i, //iii
	
	output reg Comp_o

);

always@(*) 
begin
		if(Comp_y_i > Comp_x_i) //>ii-1 tener cuidado con esta conddición
			Comp_o = 1'b1;
		else 
			Comp_o = 1'b0;
end

endmodule 