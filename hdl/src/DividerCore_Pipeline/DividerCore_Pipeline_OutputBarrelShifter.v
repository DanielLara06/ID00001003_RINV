
/*****************************************************************

Description: Parametizable Output Barrel Shifter
			
Parameters:	DATA_WIDTH -> Width of the register (bits)

*****************************************************************/






module DividerCore_Pipeline_OutputBarrelShifter #(
	parameter DATA_WIDTH = 16,
	parameter NR_DATA_WIDTH = 32,
	parameter BARREL_SHIFTER_BITS = ceillog2(DATA_WIDTH-1)
)(
	input [BARREL_SHIFTER_BITS-1 : 0] 	control,
	input [NR_DATA_WIDTH-1 : 0] 			data_i,

	output rounding_bit,
	output [DATA_WIDTH-1:0] data_o
);


	wire [NR_DATA_WIDTH+1:0] barrel_shifter_wire;
	wire [NR_DATA_WIDTH+1:0] barrel_shifter_output;
	
	
	assign barrel_shifter_wire = {{2{1'b0}},data_i};


	assign barrel_shifter_output = 	(control == 4'b1000) ? {{2{1'b0}}, barrel_shifter_wire[NR_DATA_WIDTH+1 : 2]} : // 2^2
												(control == 4'b0100) ? {{1{1'b0}}, barrel_shifter_wire[NR_DATA_WIDTH+1 : 1]} : // 2^1
												(control == 4'b0000) ? barrel_shifter_wire :                                   // 2^0
												(control == 4'b1110) ? {barrel_shifter_wire[NR_DATA_WIDTH : 0], {1{1'b0}}} :   // 2^-1
												(control == 4'b1100) ? {barrel_shifter_wire[NR_DATA_WIDTH-1 : 0], {2{1'b0}}} : // 2^-2
												(control == 4'b1010) ? {barrel_shifter_wire[NR_DATA_WIDTH-2 : 0], {3{1'b0}}} : // 2^-3
												(control == 4'b1111) ? {barrel_shifter_wire[NR_DATA_WIDTH-3 : 0], {4{1'b0}}} : // 2^-4
												barrel_shifter_wire; // Default case


	assign rounding_bit 	= barrel_shifter_output[NR_DATA_WIDTH-15];
	assign data_o 			= barrel_shifter_output[NR_DATA_WIDTH+1 : NR_DATA_WIDTH-14];

	

	/*----------------------------------------------------------------------------------------*/
	//log function*/
	
	function integer ceillog2;
		input integer data;
		integer i,result;
		
		begin
			for(i=0; 2**i <= data; i=i+1)
				result = i + 1;
				
			ceillog2 = result;
		end
		
	endfunction
		 
	/*----------------------------------------------------------------------------------------*/
	
endmodule
