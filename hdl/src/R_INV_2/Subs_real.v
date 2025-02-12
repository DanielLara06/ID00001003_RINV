/******************************************************************
*Module name : Subs_real
*Filename    : Subs_real.v
*Type        : Verilog Module
*
*Description : Parametric Substraction module after real multi 
*					
*------------------------------------------------------------------1176
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : DATA_WIDTH_CMPLX  =   16, QI = 5, QF = (DATA_WIDTH_CMPLX - QI),
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Subs_real 
#(
    parameter DATA_WIDTH_CMPLX    =   16,       // Datawidth of complex data (Real/Imag)
	 parameter QI = 5, //Integer Part
	 parameter QF = (DATA_WIDTH_CMPLX - QI) //Fractional Part (11)
)

(
	input [(2*QI):-(2*QF-1)] x_i, //32
	input [(2*QI):-(2*QF-1)] y_i, //32
	
	output  [QI:-(QF-1)] result_o //16

);

wire [(2*QI)+1:-(2*QF-1)] result; //33

assign result = x_i - y_i; 
assign result_o = result[QI:-(QF-1)];

endmodule 