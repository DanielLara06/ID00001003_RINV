/******************************************************************
*Module name : Add_imag
*Filename    : Add_imag.v
*Type        : Verilog Module
*
*Description : Parametric Adder module to sum the values from the imaginary branch multipliers.  
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
//Números deben ser ambos negativos, checar si son complemento a 2 o como representarlos (Suma de números negativos)
module Add_imag
#(
    parameter DATA_WIDTH_CMPLX    =   16,       // Datawidth of complex data (Real/Imag)
	 parameter QI = 5, //Integer Part
	 parameter QF = (DATA_WIDTH_CMPLX - QI) //Fractional Part (11)
)

(
	input [(2*QI):-(2*QF-1)] x_i,
	input [(2*QI):-(2*QF-1)] y_i,//1
	
	output  [QI:-(QF-1)] result_o

);

wire [(2*QI)+1:-(2*QF-1)] result; //33

assign result = -x_i - y_i; 
assign result_o = result[QI:-(QF-1)];


//assign result_o = x_i + y_i;

endmodule 