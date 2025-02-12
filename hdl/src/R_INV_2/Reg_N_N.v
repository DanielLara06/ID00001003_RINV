/******************************************************************
*Module name : Reg_N_N
*Filename    : Reg_N_N.v
*Type        : Verilog Module
*
*Description : Parametric Register module to vector cont2 index to R_Vector2 memory.  
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk",
*	reset		 : sync rstn,
* 
*Parameters  : elmnts_dif_zero_bits    =   11;
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Reg_N_N
#(
    parameter elmnts_dif_zero_bits    =   11     // Size of the square R matrix bits
)

(
	input clk,
	input rstn,
	input [elmnts_dif_zero_bits:0] reg_i,
	input En,
	input Clr,
	
	output reg [elmnts_dif_zero_bits:0] reg_o

);

always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			reg_o <= {(elmnts_dif_zero_bits+1){1'b0}};
		else if(Clr)
			reg_o <= {(elmnts_dif_zero_bits+1){1'b0}};
		else if(En)
			reg_o <= reg_i;
end

endmodule
