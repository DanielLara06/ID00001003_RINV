/******************************************************************
*Module name : Reg_index_r
*Filename    : Reg_index_r.v
*Type        : Verilog Module
*
*Description : Parametric Register module from adder C.   
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk",
*	reset		 : sync rstn,
* 
*Parameters  : ADDR_WIDTH    =   11,       // Address bits
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Reg_index_r
#(
   parameter ADDR_WIDTH  =   11       // Address bits
)
(
	input clk,
	input rstn,
	input [ADDR_WIDTH:0] reg_i,
	input [ADDR_WIDTH:0] elements_dif_zero_i,
	input En,
	input Clr,
	
	output reg [ADDR_WIDTH:0] reg_o

);

always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			reg_o <= {(ADDR_WIDTH){1'b0}};
		else if(Clr)
			reg_o <= elements_dif_zero_i - {{(ADDR_WIDTH-1){1'b0}}, 1'b1}; //1175
		else if(En)
			reg_o <= reg_i;
end

endmodule
