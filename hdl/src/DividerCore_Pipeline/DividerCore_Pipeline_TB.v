
/**************************************************

Description: Test bench for DividerCore_Pipeline
			
Author: Kevin Dominic Ochoa Covarrubias
email: Dominic.OCHOA@cinvestav.mx
Date: 20/Aug/2024

**************************************************/




`timescale 1ns/1ns

module DividerCore_Pipeline_TB #(
		parameter DATA_WIDTH = 16,
		parameter INTEGER_BITS = 5
	)();
	
	reg clk;
	reg rstn;
	reg start;
	reg signed [DATA_WIDTH-1:0] dividend;
	reg signed [DATA_WIDTH-1:0] divisor;
	
	wire signed [DATA_WIDTH-1:0] result;
	wire busy;
	wire done;
	
	
	
	DividerCore_Pipeline /*#(
		.DATA_WIDTH(DATA_WIDTH),
		.INTEGER_BITS(INTEGER_BITS))*/
		
		DUT (
			.clk(clk),
			.rstn(rstn),
			.start_i(start),
			.data_dividend_i(dividend),
			.data_divisor_i(divisor),

			.data_o(result), 
			.busy_o(busy),
			.done_o(done)
	);
	
	
	//Clock source
	always begin 
		clk = 1; #50; 
		clk = 0; #50; 
	end
	
	
	
	initial begin
		
		//-----------------------
		
		rstn 		= 1'b1;
		#100;
		
		rstn      = 1'b0;   
		start   = 1'b0;
		dividend = 16'h0000;
		divisor =  16'h0000;
		#100;
		
		rstn 		= 1'b1;
		#100;
		
		//-----------------------
		
		start	= 1'b1;
		
		dividend = 16'hFE66; //-0.2 = -0.25
		divisor =  16'h0666; //0.8
		#100;
		
		start	= 1'b0;
		
		#1000;
		
		
		start	= 1'b1;
		
		dividend = 16'h019A; //0.2 = 0.4
		divisor =  16'h0400; //0.5
		#100;

		start	= 1'b0;
		
		#500;
		
		start	= 1'b1;
		
		dividend = 16'h04CD; //0.6 = -0.75
		divisor =  16'hF99A; //-0.8
		#100;

		start	= 1'b0;
		
		#1000;
		
		
		start	= 1'b1;
		
		dividend = 16'hFCCD; //-0.4 = 0.8
		divisor =  16'hFC00; //-0.5
		#100;

		start	= 1'b0;
		
		#2500;

		$stop;
		
	end
	
endmodule
