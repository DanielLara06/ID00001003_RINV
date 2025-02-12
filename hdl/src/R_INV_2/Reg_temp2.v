/******************************************************************
*Module name : Reg_temp2
*Filename    : Reg_temp2.v
*Type        : Verilog Module
*
*Description : Parametric Register module from adder temp2.   
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk",
*	reset		 : sync rstn,
* 
*Parameters  : DATA_WIDTH_CMPLX    =   16
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Reg_temp2
#(
    parameter DATA_WIDTH_CMPLX    =   16       // Datawidth of complex data (Real/Imag)
)
(
	input clk,
	input rstn,
	input [DATA_WIDTH_CMPLX-1:0] reg_i,
	input En,
	input Clr,
	
	output reg [DATA_WIDTH_CMPLX-1:0] reg_o

);

always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			reg_o <= {(DATA_WIDTH_CMPLX){1'b0}};
		else if(Clr)
			reg_o <= {(DATA_WIDTH_CMPLX){1'b0}};
		else if(En)
			reg_o <= reg_i;
end

endmodule
