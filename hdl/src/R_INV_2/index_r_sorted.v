/******************************************************************
*Module name : index_r_sorted
*Filename    : index_r_sorted.v
*Type        : Verilog Module
*
*Description : Auxiliar Parametric Adder module to index real/imag data from R^-1 mem
*					
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none,
* 
*Parameters  : ADDR_WIDTH  =   11       // Address bits       
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module index_r_sorted
#(
    parameter ADDR_WIDTH  =   11       // Address bits       
)

(
	input [ADDR_WIDTH:0] x_i, 
	input [ADDR_WIDTH:0] y_i,//mux_2_index_r_sorted
	input [ADDR_WIDTH:0] N,
	input [1:0] select,
	
	output  [ADDR_WIDTH:0] result_o 

);

wire [ADDR_WIDTH:0] auxiliar_N;

wire  [ADDR_WIDTH:0] result_1; 
wire  [ADDR_WIDTH:0] result_ss;
wire  [ADDR_WIDTH:0] result_N;

//assign auxiliar_N = N-{{(ADDR_WIDTH){1'b0}},1'b1}; //47


//assign result_o = (y_i == {{(ADDR_WIDTH){1'b0}},1'b1})?(x_i + y_i): 
						//(y_i == auxiliar_N)?(x_i + y_i):(x_i - y_i);
						
assign result_o = (select == 2'b00)?(x_i + y_i):
						(select == 2'b01)?(x_i - y_i):
						(x_i + y_i);

endmodule 