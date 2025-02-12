/******************************************************************
*Module name : Reg_aux_real
*Filename    : Reg_aux_real.v
*Type        : Verilog Module
*
*Description : Parametric Register module to load R_real data (Real).   
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk",
*	reset		 : sync rstn,
* 
*Parameters  : DATA_WIDTH    =   32,     // Datawidth of data
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Reg_aux_real
#(
    parameter DATA_WIDTH    =   32     // Datawidth of data
)

(
	input clk,
	input rstn,
	input [DATA_WIDTH-1:0] reg_i,
	input En,
	input Clr,
	
	output reg [DATA_WIDTH-1:0] reg_o

);

always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			reg_o <= {(DATA_WIDTH){1'b0}};
		else if(Clr)
			reg_o <= {(DATA_WIDTH){1'b0}};
		else if(En)
			reg_o <= reg_i;
end

endmodule
