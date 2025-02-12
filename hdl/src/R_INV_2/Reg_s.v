/******************************************************************
*Module name : Reg_s
*Filename    : Reg_s.v
*Type        : Verilog Module
*
*Description : Parametric Register module from adder C.   
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk",
*	reset		 : sync rstn,
* 
*Parameters  : N_SIZE  =   6,       // Address bits
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Reg_s
#(
   parameter N_SIZE  =   6       // Address bits
)
(
	input clk,
	input rstn,
	input [N_SIZE-1:0] reg_i,
	input En,
	input Clr,
	
	output reg [N_SIZE-1:0] reg_o

);

always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			reg_o <= {(N_SIZE){1'b0}};
		else if(Clr)
			reg_o <= {(N_SIZE){1'b0}};
		else if(En)
			reg_o <= reg_i;
end

endmodule
