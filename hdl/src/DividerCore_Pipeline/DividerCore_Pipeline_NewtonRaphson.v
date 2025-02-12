/*****************************************************************

Description: Newton-Rapson method Module

Signals:		Enable -> Active high
			
Parameters:	DATA_WIDTH -> Width of the register (bits)

*****************************************************************/





module DividerCore_Pipeline_NewtonRaphson #(
	parameter DATA_WIDTH = 32,
	parameter INTEGER_BITS = 3,
	parameter FRACTIONAL_BITS = DATA_WIDTH - INTEGER_BITS,
		
	parameter CONSTANT = 32'h60000000 	//Constant used in the Newton-Raphson method
)(
	input 			clk,
	input 			rstn,
	input 			enah_1_i,
	input 			enah_2_i,
	input 			enah_3_i,
	input signed 	[DATA_WIDTH-1:0] X_i, 
	input 			[DATA_WIDTH-1:0] data_i,
	
	output 			[DATA_WIDTH-1:0] data_o
);
	
	reg signed	[DATA_WIDTH-1:0] data_1;
	reg signed	[DATA_WIDTH-1 : 0] X_divided_by_2_1;
	reg signed	[DATA_WIDTH-1 : 0] X_divided_by_2_2;
	
	
	reg signed	[DATA_WIDTH-1 : 0] quadratic_X;
	reg signed	[2*DATA_WIDTH-1 : 0] data_X_quadratic_term_full_product;
	reg signed	[2*DATA_WIDTH-1 : 0] result_from_sub_by_X;

	
	wire 			[2*DATA_WIDTH-1 : 0] quadratic_X_full;
	wire signed	[DATA_WIDTH-1 : 0] X_divided_by_2;
	
	wire signed [DATA_WIDTH-1 : 0] data_by_quadratic_term;
	

	// 1 ----------------------------------------------------------------------------------------------------------------------
	
	assign quadratic_X_full = X_i * X_i; //X^2
	assign X_divided_by_2 = {1'b0, X_i[DATA_WIDTH-1 : 1]}; //Shift to divide X by 2
	
	always @(posedge clk or negedge rstn) begin
		
		if(!rstn) begin
			quadratic_X  <= {DATA_WIDTH{1'b0}};
			
			data_1 <= {DATA_WIDTH{1'b0}};
			X_divided_by_2_1 <= {DATA_WIDTH{1'b0}};
		end
			
		else if(enah_1_i) begin
			quadratic_X  <= quadratic_X_full[2*DATA_WIDTH - INTEGER_BITS - 1 : FRACTIONAL_BITS]; //The previous result is truncated
			
			data_1 <= data_i;
			X_divided_by_2_1 <= X_divided_by_2;
		end
			
		else begin
			quadratic_X  <= quadratic_X;
			
			data_1 <= data_1;
			X_divided_by_2_1 <= X_divided_by_2_1;
		end
		
	end
		
	
	// 2 ----------------------------------------------------------------------------------------------------------------------
	
	always @(posedge clk or negedge rstn) begin
		
		if(!rstn) begin
			data_X_quadratic_term_full_product <= {2*DATA_WIDTH{1'b0}};
			
			X_divided_by_2_2 <= {DATA_WIDTH{1'b0}};
		end
			
		else if(enah_2_i) begin
			data_X_quadratic_term_full_product <= quadratic_X * data_1;
			
			X_divided_by_2_2 <= X_divided_by_2_1;
		end
			
		else begin
			data_X_quadratic_term_full_product <= data_X_quadratic_term_full_product;
			
			X_divided_by_2_2 <= X_divided_by_2_2;
		end
		
	end
	
	
	// 3 ----------------------------------------------------------------------------------------------------------------------

	assign data_by_quadratic_term = CONSTANT - data_X_quadratic_term_full_product[2*DATA_WIDTH - INTEGER_BITS - 1 : FRACTIONAL_BITS];

	always @(posedge clk or negedge rstn) begin
		
		if(!rstn) begin
			result_from_sub_by_X <= {DATA_WIDTH{1'b0}};
		end
			
		else if(enah_3_i) begin
			result_from_sub_by_X <= data_by_quadratic_term * X_divided_by_2_2; 	//Multiply the result from the subtractor by X divided by 2
		end
			
		else begin
			result_from_sub_by_X <= result_from_sub_by_X;
		end
		
	end
	
	
	
	assign data_o = result_from_sub_by_X[2*DATA_WIDTH - INTEGER_BITS - 1 : FRACTIONAL_BITS];

endmodule
