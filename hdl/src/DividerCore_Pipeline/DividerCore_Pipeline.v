
/**************************************************

Description: Top level for DividerCore Pipeline
			
Reset: Asynchronos low active
			
Author: Kevin Dominic Ochoa Covarrubias
email: Dominic.OCHOA@cinvestav.mx

**************************************************/



module DividerCore_Pipeline #(
	parameter DATA_WIDTH = 16,
	parameter INTEGER_BITS = 5,
	parameter INTEGER_BITS_INTERNAL_FORMAT = 3,
	parameter NRP_DATA_WIDTH = 32

)(
	input 			clk,
	input 			rstn,
	
	input 			start_i,
	input  signed 	[DATA_WIDTH-1:0] data_dividend_i, //DIVIDEND -> X
	input  signed	[DATA_WIDTH-1:0] data_divisor_i,  //DIVISOR  -> Y

	output signed	[DATA_WIDTH-1:0] data_o,
	output			busy_o,
	output  			done_o
);
	
	
	localparam PointOfDivision = 32'b0001_1110_0000_0000_0000_0000_0000_0000;
	localparam EncoderBits = ceillog2(DATA_WIDTH - 1);
	
	
	/*---------------------------------------------*/
	/*                    Wires                    */
	/*---------------------------------------------*/
	
	//Stage 1 Wires
		wire								  sign_result_wire;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire;
		wire 			[2*DATA_WIDTH-1:0] data_divisor_quadratic_wire;
		
	//Stage 2 Wires
		wire 								  sign_result_wire_S1toS2;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S1toS2;
		wire signed [DATA_WIDTH-1:0] data_divisor_quadratic_wire_S1toS2;
		wire 			[EncoderBits-1:0] encoder_scaling_wire;
	
	//Stage 3 Wires
		wire 								  sign_result_wire_S2toS3;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S2toS3;
		wire 			[EncoderBits-1:0] encoder_scaling_wire_S2toS3;
		wire signed [DATA_WIDTH-1:0] data_divisor_quadratic_wire_S2toFinal;
		wire 			[NRP_DATA_WIDTH-1:0] output_from_barrel_shifter_wire;
		
	//Stage 4 Wires
		wire 								  sign_result_wire_S3toS4;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S3toS4;
		wire 			[EncoderBits-1:0] encoder_scaling_wire_S3toS4;
		wire 			[NRP_DATA_WIDTH-1:0] input_barrel_shifter_wire_S3toS4;
		wire 								  selector_of_point_of_division;
		
	//Stage 5 Wires
		wire 								  sign_result_wire_S4toS5;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S4toS5;
		wire 			[EncoderBits-1:0] encoder_scaling_wire_S4toS5;
		wire 			[NRP_DATA_WIDTH-1:0] input_barrel_shifter_wire_S4toS5;
	
	//Stage 6 Wires
		wire 								  sign_result_wire_S5toS6;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S5toS6;
		wire 			[EncoderBits-1:0] encoder_scaling_wire_S5toS6;
		wire 			[NRP_DATA_WIDTH-1:0] input_barrel_shifter_wire_S5toS6;
		wire 			[NRP_DATA_WIDTH-1:0] PolynomialApprox_wire;
	
	//Stage 7 Wires
		wire 								  sign_result_wire_S6toS7;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S6toS7;
		wire 			[EncoderBits-1:0] encoder_scaling_wire_S6toS7;
		wire 			[NRP_DATA_WIDTH-1:0] input_barrel_shifter_wire_S6toFinal;
		wire 			[NRP_DATA_WIDTH-1:0] PolynomialApprox_wire_S6toFinal;
	
	//Stage 8 Wires
		wire 								  sign_result_wire_S7toS8;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S7toS8;
		wire 			[EncoderBits-1:0] encoder_scaling_wire_S7toS8;
	
	//Stage 9 Wires
		wire 								  sign_result_wire_S8toS9;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S8toS9;
		wire 			[EncoderBits-1:0] encoder_scaling_wire_S8toS9;
	
	//Stage 10 Wires
		wire 								  sign_result_wire_S9toS10;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S9toS10;
		wire 			[EncoderBits-1:0] encoder_scaling_wire_S9toS10;
		wire 			[NRP_DATA_WIDTH-1:0] NewtonRaphson_wire;
	
	//Stage 11 Wires
		wire 								  sign_result_wire_S10toS11;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S10toS11;
		wire 			[EncoderBits-1:0] encoder_scaling_wire_S10toFinal;
		wire 			[NRP_DATA_WIDTH-1:0] NewtonRaphson_wire_S10toFinal;
		wire 								  rounding_bit_wire;
		wire 			[DATA_WIDTH-1:0] result_after_scaling;
		wire 			[DATA_WIDTH-1:0] reciprocal_squareRoot_wire;
	
	//Stage 12 Wires
		wire 								  sign_result_wire_S11toFinal;
		wire signed [DATA_WIDTH-1:0] data_dividend_abs_wire_S11toFinal;
		wire 			[DATA_WIDTH-1:0] reciprocal_squareRoot_wire_S11toFinal;
		wire 			[2*DATA_WIDTH-1:0] division_abs_result_wire;
	
	
	
	//Control Machine wires
		wire enah_S1_wire;
		wire enah_S2_wire;
		wire enah_S3_wire;
		wire enah_S4_wire;
		wire enah_S5_wire;
		wire enah_S6_wire;
		wire enah_S7_wire;
		wire enah_S8_wire;
		wire enah_S9_wire;
		wire enah_S10_wire;
		wire enah_S11_wire;	
	
	
	/*---------------------------------------------*/
	/*               Control Machine               */
	/*---------------------------------------------*/
	
	DividerCore_Pipeline_ControlMachine 
	
		ControlMachine (
		
			.clk(clk),
			.rstn(rstn),
			
			.startCM_i(start_i),
			
			.enah_S1_o(enah_S1_wire),
			.enah_S2_o(enah_S2_wire),
			.enah_S3_o(enah_S3_wire),
			.enah_S4_o(enah_S4_wire),
			.enah_S5_o(enah_S5_wire),
			.enah_S6_o(enah_S6_wire),
			.enah_S7_o(enah_S7_wire),
			.enah_S8_o(enah_S8_wire),
			.enah_S9_o(enah_S9_wire),
			.enah_S10_o(enah_S10_wire),
			.enah_S11_o(enah_S11_wire),
			
			.busy_o(busy_o),
			.done_o(done_o)
			
	);
	
	
	
	/*---------------------------------------------*/
	/*            Pipeline Architecture            */
	/*---------------------------------------------*/
	
	//Stage 1 -----------------------------------------------------------------------------------------
		
		assign sign_result_wire = data_dividend_i[DATA_WIDTH-1] ^ data_divisor_i[DATA_WIDTH-1]; //Determine and save the sign of the result
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S1 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S1_wire),
				.data_i(sign_result_wire),
				.data_o(sign_result_wire_S1toS2)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_SignConverter #(
			 .DATA_WIDTH(DATA_WIDTH))
			 
			 SignConverter_S1 (
				 .selector(data_dividend_i[DATA_WIDTH-1]),
				 .data_i(data_dividend_i),
				 .data_o(data_dividend_abs_wire)
		);

		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S1 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S1_wire),
				.data_i(data_dividend_abs_wire),
				.data_o(data_dividend_abs_wire_S1toS2)
		);
		
		//--------------------------------------------
		
		assign data_divisor_quadratic_wire = data_divisor_i * data_divisor_i;
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_divisor_quadratic_Register_S1 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S1_wire),
				.data_i(data_divisor_quadratic_wire[2*DATA_WIDTH - INTEGER_BITS - 1 : DATA_WIDTH - INTEGER_BITS]),
				.data_o(data_divisor_quadratic_wire_S1toS2)
		);
		
	//Stage 2 -----------------------------------------------------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S2 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S2_wire),
				.data_i(sign_result_wire_S1toS2),
				.data_o(sign_result_wire_S2toS3)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S2 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S2_wire),
				.data_i(data_dividend_abs_wire_S1toS2),
				.data_o(data_dividend_abs_wire_S2toS3)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Encoder #(
			.DATA_WIDTH(DATA_WIDTH))
			
			encoder_scaling (
				.data_i(data_divisor_quadratic_wire_S1toS2),
				.data_o(encoder_scaling_wire)
		);
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(EncoderBits))
			
			encoder_scaling_Register_S2 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S2_wire),
				.data_i(encoder_scaling_wire),
				.data_o(encoder_scaling_wire_S2toS3)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_divisor_quadratic_Register_S2 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S2_wire),
				.data_i(data_divisor_quadratic_wire_S1toS2),
				.data_o(data_divisor_quadratic_wire_S2toFinal)
		);
	
	//Stage 3 -----------------------------------------------------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S3 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S3_wire),
				.data_i(sign_result_wire_S2toS3),
				.data_o(sign_result_wire_S3toS4)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S3 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S3_wire),
				.data_i(data_dividend_abs_wire_S2toS3),
				.data_o(data_dividend_abs_wire_S3toS4)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(EncoderBits))
			
			encoder_scaling_Register_S3 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S3_wire),
				.data_i(encoder_scaling_wire_S2toS3),
				.data_o(encoder_scaling_wire_S3toS4)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_InputBarrelShifter #(
			.DATA_WIDTH(DATA_WIDTH))
			
			input_barrel_shifter (
				.control(encoder_scaling_wire_S2toS3),
				.data_i(data_divisor_quadratic_wire_S2toFinal),
				
				.data_o(output_from_barrel_shifter_wire)
		);
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(NRP_DATA_WIDTH))
			
			input_barrel_shifter_Register_S3 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S3_wire),
				.data_i(output_from_barrel_shifter_wire),
				.data_o(input_barrel_shifter_wire_S3toS4)
		);
		
	//Stage 4 -----------------------------------------------------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S4 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S4_wire),
				.data_i(sign_result_wire_S3toS4),
				.data_o(sign_result_wire_S4toS5)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S4 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S4_wire),
				.data_i(data_dividend_abs_wire_S3toS4),
				.data_o(data_dividend_abs_wire_S4toS5)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(EncoderBits))
			
			encoder_scaling_Register_S4 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S4_wire),
				.data_i(encoder_scaling_wire_S3toS4),
				.data_o(encoder_scaling_wire_S4toS5)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(NRP_DATA_WIDTH))
			
			input_barrel_shifter_Register_S4 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S4_wire),
				.data_i(input_barrel_shifter_wire_S3toS4),
				.data_o(input_barrel_shifter_wire_S4toS5)
		);
	
	//Stage 5 -----------------------------------------------------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S5 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S5_wire),
				.data_i(sign_result_wire_S4toS5),
				.data_o(sign_result_wire_S5toS6)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S5 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S5_wire),
				.data_i(data_dividend_abs_wire_S4toS5),
				.data_o(data_dividend_abs_wire_S5toS6)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(EncoderBits))
			
			encoder_scaling_Register_S5 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S5_wire),
				.data_i(encoder_scaling_wire_S4toS5),
				.data_o(encoder_scaling_wire_S5toS6)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(NRP_DATA_WIDTH))
			
			input_barrel_shifter_Register_S5 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S5_wire),
				.data_i(input_barrel_shifter_wire_S4toS5),
				.data_o(input_barrel_shifter_wire_S5toS6)
		);
		
	//Stage 6 -----------------------------------------------------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S6 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S6_wire),
				.data_i(sign_result_wire_S5toS6),
				.data_o(sign_result_wire_S6toS7)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S6 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S6_wire),
				.data_i(data_dividend_abs_wire_S5toS6),
				.data_o(data_dividend_abs_wire_S6toS7)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(EncoderBits))
			
			encoder_scaling_Register_S6 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S6_wire),
				.data_i(encoder_scaling_wire_S5toS6),
				.data_o(encoder_scaling_wire_S6toS7)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(NRP_DATA_WIDTH))
			
			input_barrel_shifter_Register_S6 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S6_wire),
				.data_i(input_barrel_shifter_wire_S5toS6),
				.data_o(input_barrel_shifter_wire_S6toFinal)
		);
		
		//--------------------------------------------
		
		assign selector_of_point_of_division = input_barrel_shifter_wire_S3toS4 <= PointOfDivision;
		
		DividerCore_Pipeline_PolynomialApprox #(
			.DATA_WIDTH(NRP_DATA_WIDTH),
			.INTEGER_BITS(INTEGER_BITS_INTERNAL_FORMAT))
			
			PolynomialApprox_Module (
				.clk(clk),
				.rstn(rstn),
				.enah_1_i(enah_S4_wire),
				.enah_2_i(enah_S5_wire),
				.X_i(input_barrel_shifter_wire_S3toS4), 
				.P1_P2_selector_i(selector_of_point_of_division),
				.data_o(PolynomialApprox_wire)
		);
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(NRP_DATA_WIDTH))
			
			PolynomialApprox_Register (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S6_wire),
				.data_i(PolynomialApprox_wire),
				.data_o(PolynomialApprox_wire_S6toFinal)
		);
	
	//Stage 7 -----------------------------------------------------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S7 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S7_wire),
				.data_i(sign_result_wire_S6toS7),
				.data_o(sign_result_wire_S7toS8)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S7 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S7_wire),
				.data_i(data_dividend_abs_wire_S6toS7),
				.data_o(data_dividend_abs_wire_S7toS8)
		);
		
		//--------------------------------------------
	
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(EncoderBits))
			
			encoder_scaling_Register_S7 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S7_wire),
				.data_i(encoder_scaling_wire_S6toS7),
				.data_o(encoder_scaling_wire_S7toS8)
		);
	
	//Stage 8 -----------------------------------------------------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S8 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S8_wire),
				.data_i(sign_result_wire_S7toS8),
				.data_o(sign_result_wire_S8toS9)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S8 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S8_wire),
				.data_i(data_dividend_abs_wire_S7toS8),
				.data_o(data_dividend_abs_wire_S8toS9)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(EncoderBits))
			
			encoder_scaling_Register_S8 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S8_wire),
				.data_i(encoder_scaling_wire_S7toS8),
				.data_o(encoder_scaling_wire_S8toS9)
		);
	
	//Stage 9 -----------------------------------------------------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S9 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S9_wire),
				.data_i(sign_result_wire_S8toS9),
				.data_o(sign_result_wire_S9toS10)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S9 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S9_wire),
				.data_i(data_dividend_abs_wire_S8toS9),
				.data_o(data_dividend_abs_wire_S9toS10)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(EncoderBits))
			
			encoder_scaling_Register_S9 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S9_wire),
				.data_i(encoder_scaling_wire_S8toS9),
				.data_o(encoder_scaling_wire_S9toS10)
		);
	
	//Stage 10 -----------------------------------------------------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S10 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S10_wire),
				.data_i(sign_result_wire_S9toS10),
				.data_o(sign_result_wire_S10toS11)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S10 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S10_wire),
				.data_i(data_dividend_abs_wire_S9toS10),
				.data_o(data_dividend_abs_wire_S10toS11)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(EncoderBits))
			
			encoder_scaling_Register_S10 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S10_wire),
				.data_i(encoder_scaling_wire_S9toS10),
				.data_o(encoder_scaling_wire_S10toFinal)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_NewtonRaphson #(
			.DATA_WIDTH(NRP_DATA_WIDTH),
			.INTEGER_BITS(INTEGER_BITS_INTERNAL_FORMAT))
			
			NewtonRaphson_Module (
				.clk(clk),
				.rstn(rstn),
				.enah_1_i(enah_S7_wire),
				.enah_2_i(enah_S8_wire),
				.enah_3_i(enah_S9_wire),
				.X_i(PolynomialApprox_wire_S6toFinal),
				.data_i(input_barrel_shifter_wire_S6toFinal),
				.data_o(NewtonRaphson_wire)
		);
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(NRP_DATA_WIDTH))
			
			NewtonRaphson_Register (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S10_wire),
				.data_i(NewtonRaphson_wire),
				.data_o(NewtonRaphson_wire_S10toFinal)
		);
	
	//Stage 11 -----------------------------------------------------------------------------------------
	
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(1))
			
			sign_Register_S11 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S11_wire),
				.data_i(sign_result_wire_S10toS11),
				.data_o(sign_result_wire_S11toFinal)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			data_dividend_abs_Register_S11 (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S11_wire),
				.data_i(data_dividend_abs_wire_S10toS11),
				.data_o(data_dividend_abs_wire_S11toFinal)
		);
		
		//--------------------------------------------
		
		DividerCore_Pipeline_OutputBarrelShifter #(
			.DATA_WIDTH(DATA_WIDTH),
			.NR_DATA_WIDTH(NRP_DATA_WIDTH))
			
			barrel_shifter_for_descaling (
				.control(encoder_scaling_wire_S10toFinal),
				.data_i(NewtonRaphson_wire_S10toFinal),
				.rounding_bit(rounding_bit_wire),
				.data_o(result_after_scaling)
		);

		assign reciprocal_squareRoot_wire = rounding_bit_wire? result_after_scaling + 1'b1 : result_after_scaling;
		
		DividerCore_Pipeline_Register #(
			.DATA_WIDTH(DATA_WIDTH))
			
			reciprocal_squareRoot_Register (
				.clk(clk),
				.rstn(rstn),
				.enah(enah_S11_wire),
				.data_i(reciprocal_squareRoot_wire),
				.data_o(reciprocal_squareRoot_wire_S11toFinal)
		);
	
	//Stage 12 -----------------------------------------------------------------------------------------
	
		assign division_abs_result_wire = data_dividend_abs_wire_S11toFinal * reciprocal_squareRoot_wire_S11toFinal;
	
		DividerCore_Pipeline_SignConverter #(
			 .DATA_WIDTH(DATA_WIDTH))
			 
			 SignConverter_S12 (
				 .selector(sign_result_wire_S11toFinal),
				 .data_i(division_abs_result_wire[2*DATA_WIDTH - INTEGER_BITS - 1 : DATA_WIDTH - INTEGER_BITS]),
				 .data_o(data_o)
		);
		
		
	
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
