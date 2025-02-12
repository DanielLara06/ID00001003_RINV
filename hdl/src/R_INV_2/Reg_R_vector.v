/******************************************************************
*Module name : Reg_R_vector
*Filename    : Reg_R_vector.v
*Type        : Verilog Module
*
*Description : Parametric Register module to vector R matrix.  
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk",
*	reset		 : sync rstn,
* 
*Parameters  : DATA_WIDTH    =   32,     // Datawidth of data;
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module Reg_R_vector
#(
    parameter DATA_WIDTH = 32     // Size of the square R matrix bits
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
			reg_o <= {DATA_WIDTH{1'b0}};
		else if(Clr)
			reg_o <= {DATA_WIDTH{1'b0}};
		else if(En)
			reg_o <= reg_i;
end

endmodule
