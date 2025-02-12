/******************************************************************
*Module name : mux2
*Filename    : mux2.v
*Type        : Verilog Module
*
*Description : 3x1 generic multiplexer 
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none
* 
*Parameters  : none
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/
module mux2
#(
    parameter DATA_WIDTH    =   32,     // Datawidth of data
    parameter elmnts_dif_zero_bits    =   11,       // Address bits
	 parameter N_SIZE    =   6,     // Size of the square R matrix bits
    parameter DATA_WIDTH_CMPLX    =   16       // Datawidth of complex data (Real/Imag)
)


(
	input [1:0] select,
	input [5:0] i_one,
	input [5:0] i_two,
	input [5:0] i_zero,
	
	output [5:0] mux_o
	
);

assign mux_o = (select == 2'b00) ? i_zero :
             (select == 2'b01) ? i_one :
             (select == 2'b10) ? i_two : i_zero; //Default Value 

	
endmodule 