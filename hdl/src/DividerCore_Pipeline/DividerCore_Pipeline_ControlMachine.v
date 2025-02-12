
/*****************************************************************

Description: FSM for DividerCore Pipeline

Signals:		Reset  -> Active low

*****************************************************************/






module DividerCore_Pipeline_ControlMachine(
	input clk,
	input rstn,
	
	input startCM_i,
	
	output reg enah_S1_o,
	output reg enah_S2_o,
	output reg enah_S3_o,
	output reg enah_S4_o,
	output reg enah_S5_o,
	output reg enah_S6_o,
	output reg enah_S7_o,
	output reg enah_S8_o,
	output reg enah_S9_o,
	output reg enah_S10_o,
	output reg enah_S11_o,
	
	output busy_o,
	output reg done_o
);
	

	reg enah_S11_aux;
	reg [3:0] busy_counter;
	
	
	always @(negedge clk or negedge rstn) begin
		
		if(!rstn) begin
			
			enah_S1_o  <= 1'b0;
			enah_S2_o  <= 1'b0;
			enah_S3_o  <= 1'b0;
			enah_S4_o  <= 1'b0;
			enah_S5_o  <= 1'b0;
			enah_S6_o  <= 1'b0;
			enah_S7_o  <= 1'b0;
			enah_S8_o  <= 1'b0;
			enah_S9_o  <= 1'b0;
			enah_S10_o <= 1'b0;
			enah_S11_o <= 1'b0;

		end
			
		else begin
		
			enah_S1_o  <= startCM_i;
			enah_S2_o  <= enah_S1_o;
			enah_S3_o  <= enah_S2_o;
			enah_S4_o  <= enah_S3_o;
			enah_S5_o  <= enah_S4_o;
			enah_S6_o  <= enah_S5_o;
			enah_S7_o  <= enah_S6_o;
			enah_S8_o  <= enah_S7_o;
			enah_S9_o  <= enah_S8_o;
			enah_S10_o <= enah_S9_o;
			enah_S11_o <= enah_S10_o;
			
		end
		
	end
	
	
	
	always @(posedge clk or negedge rstn) begin
		
		if(!rstn) begin
			
			enah_S11_aux <= 1'b0;
			done_o <= 1'b0;

		end
			
		else begin
			
			enah_S11_aux <= enah_S10_o;
			done_o <= enah_S11_o;
			
		end
		
	end
	
	
	
	always @(posedge clk or negedge rstn) begin
		 
		 if(!rstn) begin
		 
			  busy_counter <= 0;
			  
		 end 
		 
		 else if(enah_S1_o) begin
		 
			  busy_counter <= busy_counter + 1;
			  
		 end 
		 
		 else if(enah_S11_aux) begin
		 
			  busy_counter <= busy_counter - 1;
			  
		 end
	end

	assign busy_o = (busy_counter > 0);
	
	

endmodule
