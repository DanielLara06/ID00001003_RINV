/******************************************************************
*Module name : Reg_multi_add_real
*Filename    : Reg_multi_add_real.v
*Type        : Verilog Module
*
*Description : Parametric Register module for real part multiplication.     
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk",
*	reset		 : sync rstn,
* 
*Parameters  : DATA_WIDTH_CMPLX  =   16, QI = 5, QF = (DATA_WIDTH_CMPLX - QI),
*
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Reg_multi_add_real
#(
    parameter DATA_WIDTH_CMPLX    =   16,       // Datawidth of complex data (Real/Imag)
	 parameter QI = 5, //Integer Part
	 parameter QF = (DATA_WIDTH_CMPLX - QI) //Fractional Part (11)
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
