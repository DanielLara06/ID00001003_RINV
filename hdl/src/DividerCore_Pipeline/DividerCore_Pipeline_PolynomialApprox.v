
/*****************************************************************

Description: Polynomial Approximation Module

Signals:		Enable -> Active high
			
Parameters:	DATA_WIDTH -> Width of the register (bits)

*****************************************************************/




module DividerCore_Pipeline_PolynomialApprox #(
	parameter DATA_WIDTH = 32,
	parameter INTEGER_BITS = 3,
	parameter FRACTIONAL_BITS = DATA_WIDTH - INTEGER_BITS,
	
	//Polynomial coefficients
	parameter A2P1 = 32'h1B940AC2,
	parameter A1P1 = 32'hBCE80F05,
	parameter A0P1 = 32'h47BB76E0,
	
	parameter A2P2 = 32'h05401366,
	parameter A1P2 = 32'hE70BD6B8,
	parameter A0P2 = 32'h33B39D35
)(
	input 			clk,
	input 			rstn,
	input 			enah_1_i,
	input 			enah_2_i,
	input signed 	[DATA_WIDTH-1:0] X_i, 
	input 			P1_P2_selector_i, //Control to select the set of polynomial coefficients
	
	output 			[DATA_WIDTH-1:0] data_o
);
	
	reg 			P1_P2_selector_1;
	reg 			P1_P2_selector_2;
	reg 			enah_1;
	reg 			enah_2;
	reg signed 	[DATA_WIDTH-1:0] X_1;

	
	reg signed	[DATA_WIDTH-1:0] 	quadratic_X;
	reg signed	[2*DATA_WIDTH-1:0] data_X_quadratic_term_full_product;
	reg signed 	[2*DATA_WIDTH-1:0] a1px_by_X_full_product;
	
	
	wire signed	[2*DATA_WIDTH-1:0] quadratic_X_full;
	wire signed [DATA_WIDTH-1:0] data_by_quadratic_term;
	wire signed [DATA_WIDTH-1:0] a2px_mux, a1px_mux, a0px_mux;
	wire signed [DATA_WIDTH-1:0] a1px_by_x;


	// 1 ----------------------------------------------------------------------------------------------------------------------
	
	assign quadratic_X_full = X_i * X_i; //X^2
	
	always @(posedge clk or negedge rstn) begin
		
		if(!rstn) begin
			quadratic_X <= {DATA_WIDTH{1'b0}};
			
			X_1 <= {DATA_WIDTH{1'b0}};
			P1_P2_selector_1 <= 1'b0;
		end
			
		else if(enah_1_i) begin
			quadratic_X  <= quadratic_X_full[2*DATA_WIDTH - INTEGER_BITS - 1 : FRACTIONAL_BITS]; //The previous result is truncated
			
			X_1 <= X_i;
			P1_P2_selector_1 <= P1_P2_selector_i;
		end
			
		else begin
			quadratic_X  <= quadratic_X;
			
			X_1 <= X_1;
			P1_P2_selector_1 <= P1_P2_selector_1;
		end
		
	end
	
	
	// 2 ----------------------------------------------------------------------------------------------------------------------
	
	assign a2px_mux = P1_P2_selector_1? A2P1 : A2P2; //The set of polynomial coefficients is selected based on P1_P2_selector
	assign a1px_mux = P1_P2_selector_1? A1P1 : A1P2;
	
	always @(posedge clk or negedge rstn) begin
		
		if(!rstn) begin
			data_X_quadratic_term_full_product 	<= {2*DATA_WIDTH{1'b0}};
			a1px_by_X_full_product 					<= {2*DATA_WIDTH{1'b0}};
			
			P1_P2_selector_2 <= 1'b0;
		end
			
		else if(enah_2_i) begin
			data_X_quadratic_term_full_product 	<= quadratic_X * a2px_mux; //Multiply the quadratic term by a2px_mux
			a1px_by_X_full_product 					<= X_1 * a1px_mux; 			//Multiply X by a1px_mux
			
			P1_P2_selector_2 <= P1_P2_selector_1;
		end
			
		else begin
			data_X_quadratic_term_full_product 	<= data_X_quadratic_term_full_product;
			a1px_by_X_full_product 					<= a1px_by_X_full_product;
			
			P1_P2_selector_2 <= P1_P2_selector_2;
		end
		
	end
	
	
	// 3 ----------------------------------------------------------------------------------------------------------------------
	
	assign data_by_quadratic_term = data_X_quadratic_term_full_product[2*DATA_WIDTH - INTEGER_BITS - 1 : FRACTIONAL_BITS];
	assign a1px_by_x = a1px_by_X_full_product[2*DATA_WIDTH - INTEGER_BITS - 1 : FRACTIONAL_BITS];
	assign a0px_mux = P1_P2_selector_2? A0P1 : A0P2;
	
	assign data_o = data_by_quadratic_term + a1px_by_x + a0px_mux;

endmodule
