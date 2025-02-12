
/**************************************************

Description: Sign Converter
						
Author: Kevin Dominic Ochoa Covarrubias
email: Dominic.OCHOA@cinvestav.mx

**************************************************/





module DividerCore_Pipeline_SignConverter #(
    parameter DATA_WIDTH = 16
)(
    input         selector,
	 input signed  [DATA_WIDTH-1:0] data_i,
	 
    output signed [DATA_WIDTH-1:0] data_o
);

    assign data_o = selector? ~data_i + 1'b1 : data_i;

endmodule 
