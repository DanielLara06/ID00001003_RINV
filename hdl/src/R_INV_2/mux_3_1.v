/******************************************************************
*Module name : mux_3_1
*Filename    : mux_3_1.v
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
module mux_3_1
#(
    parameter elmnts_dif_zero_bits    =   11       // Address bits
)


(
	input [1:0] select,
	input [elmnts_dif_zero_bits-1:0] i_x, //N+1
	input [elmnts_dif_zero_bits-1:0] i_y,//1
	input [elmnts_dif_zero_bits-1:0] i_z, //aux_count3 + elements +1
	
	output [elmnts_dif_zero_bits-1:0] mux_o
	
);

/*always@(*)
begin 
	if(select == 2'b00)
		mux_o <= i_x;
	else if (select == 2'b01)
		mux_o <= i_y;
	else if(select == 2'b10)
		mux_o <= i_z;
end*/ 

assign mux_o = (select == 2'b00) ? i_x :
               (select == 2'b01) ? i_y :
               (select == 2'b10) ? i_z :
               i_x; // Valor por defecto si ninguna condición se cumple
	
endmodule 