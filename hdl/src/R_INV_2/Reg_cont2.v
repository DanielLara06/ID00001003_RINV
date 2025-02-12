/******************************************************************
*Module name : Reg_cont2
*Filename    : Reg_cont2.v
*Type        : Verilog Module
*
*Description : Parametric Register module to vector cont2 index to R_Vector2 memory.  
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk",
*	reset		 : sync rstn,
* 
*Parameters  : elmnts_dif_zero_bits    =   11; N_SIZE = 6 
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Reg_cont2
#(
    parameter elmnts_dif_zero_bits    =   11, // Size of the square R matrix bits
	 parameter	N_SIZE = 6 
)

(
	input clk,
	input rstn,
	input [elmnts_dif_zero_bits-1:0] reg_i,
   input [elmnts_dif_zero_bits-1:0] N,
	input En,
	input Clr,
	
	output reg [elmnts_dif_zero_bits-1:0] reg_o

);

always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			reg_o <= {elmnts_dif_zero_bits{1'b0}};
		else if(Clr)
			reg_o <= (N + {{(elmnts_dif_zero_bits-1){1'b0}},1'b1});//- {{(elmnts_dif_zero_bits-1){1'b0}},1'b1}
		else if(En)
			reg_o <= reg_i;
end

endmodule
