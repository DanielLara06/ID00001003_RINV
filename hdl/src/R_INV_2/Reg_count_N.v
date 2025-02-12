/******************************************************************
*Module name : Reg_count_N
*Filename    : Reg_count_N.v
*Type        : Verilog Module
*
*Description : Parametric Register module to to load diagonal R_real value.   
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk",
*	reset		 : sync rstn,
* 
*Parameters  : elmnts_dif_zero_bits    =   11, N_SIZE    =   6,
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Reg_count_N
#(
    parameter elmnts_dif_zero_bits    =   11,       // elements bits
	 parameter N_SIZE    =   6     // Size of the square R matrix bits
)

(
	input clk,
	input rstn,
	input [elmnts_dif_zero_bits-1:0] reg_i,
	input [elmnts_dif_zero_bits-1:0] N_dif_zero,
	input En,
	input Clr,
	input Clr2, //(1176)
	
	output reg [elmnts_dif_zero_bits-1:0] reg_o

);

always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			reg_o <= {(elmnts_dif_zero_bits-N_SIZE){1'b1}};// se inicializa en 1 o 0 desde reset
		else if(Clr)
			reg_o <= {{(elmnts_dif_zero_bits-N_SIZE){1'b0}},1'b0}; //Al inicial el algoritmo se le otorga el valor de 1176 = numel(R_vec) en la condición indicada.
		else if(Clr2)
			reg_o <= N_dif_zero - {{(elmnts_dif_zero_bits-1){1'b0}}, 1'b1};
		else if(En)
			reg_o <= reg_i;
end

endmodule
