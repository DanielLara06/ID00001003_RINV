
/*****************************************************************

Description: Parametizable register

Signals:		Reset  -> Active low
				Enable -> Active high
			
Parameters:	DATA_WIDTH -> Width of the register (bits)

*****************************************************************/



module DividerCore_Pipeline_Register #(
	parameter DATA_WIDTH = 16
)(
	input 	clk,
	input 	rstn,
	input 	enah,
	input 	[DATA_WIDTH-1:0] data_i,

	output 	[DATA_WIDTH-1:0] data_o
);

	reg [DATA_WIDTH-1 : 0] data_reg;


	always@(posedge clk or negedge rstn) begin
	
		if(!rstn) 
			data_reg <= {DATA_WIDTH{1'b0}};
			
		else if(enah)
			data_reg <= data_i;
			
		else 
			data_reg = data_reg;
				
	end


	assign data_o = data_reg;

endmodule
