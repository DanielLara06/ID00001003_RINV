/******************************************************************
*Module name : mux
*Filename    : mux.v
*Type        : Verilog Module
*
*Description : 2x1 generic multiplexer 
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
module mux
#(
    parameter elmnts_dif_zero_bits    =   11       // Address bits
)


(
	input select,
	input [elmnts_dif_zero_bits-1:0] i_one,
	input [elmnts_dif_zero_bits-1:0] i_zero,
	
	output [elmnts_dif_zero_bits-1:0] mux_o
	
);

assign mux_o = (select)?i_one:i_zero;
	
endmodule 
