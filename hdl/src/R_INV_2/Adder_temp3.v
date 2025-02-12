/******************************************************************
*Module name : Adder_temp3
*Filename    : Adder_temp3.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to acummulate imaginary branch
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : DATA_WIDTH_CMPLX    =   16, QI = 5, QF = (DATA_WIDTH_CMPLX - QI)
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Adder_temp3
#(
    parameter DATA_WIDTH_CMPLX    =   16,       // Datawidth of complex data (Real/Imag)
	 parameter QI = 5, //Integer Part
	 parameter QF = (DATA_WIDTH_CMPLX - QI) //Fractional Part (11)
)

(
	input [QI:-(QF-1)] x_i, //Se podría cambiar a 32.20
	input [QI:-(QF-1)] y_i,//Entrada 16.11
	
	output  [QI:-(QF-1)] result_o //16.11 probando realizaciones a 16 bits, se puede cambiar a 32.20 si se llega a cambiar el tamaño 

);

assign result_o = x_i + y_i;

endmodule 
