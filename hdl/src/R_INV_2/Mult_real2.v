/******************************************************************
*Module name : Mult_real2
*Filename    : Mult_real2.v
*Type        : Verilog Module
*
*Description : Parametric Multiplier for real branch.  
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : DATA_WIDTH_CMPLX  =   16, QI = 5, QF = (DATA_WIDTH_CMPLX - QI),
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Mult_real2
#(
    parameter DATA_WIDTH_CMPLX    =   16,       // Datawidth of complex data (Real/Imag)
	 parameter QI = 5, //Integer Part
	 parameter QF = (DATA_WIDTH_CMPLX - QI) //Fractional Part (11)
)

(
	input [QI:-(QF-1)] x_i,
	input [QI:-(QF-1)] y_i,
	
	output  [(2*QI):-(2*QF-1)] result_o

);

wire [QI:-(QF-1)] x_t; //C2 representation or without it 
wire [QI:-(QF-1)] y_t; //C2 representation or without it

assign x_t = (x_i[QI] == 1'b1)?(~(x_i-16'b0000000000000001)):x_i;
assign y_t = (y_i[QI] == 1'b1)?(~(y_i-16'b0000000000000001)):y_i;

assign result_o = ~(x_t*y_t) + 32'b00000000000000000000000000000001;



endmodule
