/******************************************************************
*Module name : FSM
*Filename    : FSM.v
*Type        : Verilog Module
*
*Description : Finite State Machine to control R_INV DataPath
*------------------------------------------------------------------
*	clocks    : posedge clock "clk"
*	reset		 : sync rstn
* 
*Parameters  : none
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/

module FSM(
   input  clk,
   input  rstn,
   input  start_i,
	input non_zero_iter_COMP_i,//non_zero_elemnts process flag
	input elemnts_iter_COMP_i,//elements count process flag 
	input [1:0] x_d_COMP_i,//x iteration limit to set diagonal R matrix values in memory process flag
	input busy_div_real, //busy divider real branch 
	input done_div_real, //done divider real branch 
	input busy_div_imag, //busy divider imag branch 
	input done_div_imag, //done divider imag branch 
	input [2:0] i_COMP_i, //i iteration process flag 
	input [1:0]ii_COMP_i, //ii iteration process flag 
	input iii_COMP_i, //iii iteration process flag
	
	input out_pointer_COMP_i, //out pointer comparator
	
	input [1:0] Comp_dd_i, //"Fast"iterator to get R without zeros
	input Comp_d_i, //"Slow"iterator to get R without zeros
	input Comp_s_i, //S comparator
	input Comp_ss_i,//SS comparator
	input Comp_z_i,//Z comparator
	
	
	/*Module's Output**/
	
	output reg busy,
	output reg done,	
	
	/*Outputs directed to muxes and Registers*/
	
	//Reg_non_zero *
	output reg Reg_non_zero_clr,
	output reg Reg_non_zero_en,

	//Reg_regresive_count *
	output reg Reg_regresive_count_clr,
	output reg Reg_regresive_count_en,
	
	//Reg_non_zero_iter *
	output reg Reg_non_zero_iter_en,
	output reg Reg_non_zero_iter_clr,

	//Reg_count_elemnts *
	output reg Reg_count_elemnts_en,
	output reg Reg_count_elemnts_clr,
	
	//Reg_elemnts_iter *
	output reg Reg_elemnts_iter_en,
	output reg Reg_elemnts_iter_clr,

	//Reg_R_vector *
	//output reg Reg_R_vector_clr,
	//output reg Reg_R_vector_en,

	//Reg_cont2 *
	output reg Reg_cont2_en,
   output reg Reg_cont2_clr,
	
	//Reg_N_N *
	//output reg Reg_N_N_en,
   ///output reg Reg_N_N_clr,
	
	//Reg_count_N *
	output reg Reg_count_N_en,
   output reg Reg_count_N_clr,
	output reg Reg_count_N_clr2, //(1176)
	
	//Reg_val_d *
	output reg Reg_val_d_en,
   output reg Reg_val_d_clr,
	
	//mux_U26_sel - Generic mux for count module, using to set the diagonal values of R matrix (selector) *
	output reg mux_U26_sel,
	
	//mux_U27_sel - Generic mux after val_d module (selector) *
	output reg mux_U27_sel,
	
	//mux_U28_sel - Generic mux to choose val or count  + count_acumm (selector) *
	output reg mux_U28_sel,
		
	//Reg_x_d *
	output reg Reg_x_d_en,
   output reg Reg_x_d_clr,
	
	//Reg_aux_real *
	output reg Reg_aux_real_en,
   output reg Reg_aux_real_clr,
	
	//Reg_aux_imag *
	output reg Reg_aux_imag_en,
   output reg Reg_aux_imag_clr,
	
	//Reg_aux_count *
	output reg Reg_aux_count_en,
   output reg Reg_aux_count_clr,
	
	//mux_U37_sel - Generic mux between N+1 to aux_count_reg
	output reg mux_U37_sel,

	//mux_U39_sel - Multiplexor located before real Div to select values or 1 to set diagonal values of R^-1 *
	output reg mux_U39_sel,
	
	//DividerCore_real - Divider Core Initialization for real branch *
	output reg start_div_real_o,
	output reg reset_div_real_o,
	
	//DividerCore_imag - Divider Core Initialization for imaginary branch *
	output reg start_div_imag_o,
	output reg reset_div_imag_o,
	
	//Reg_multi_add_real - Register to store or load the multi/add real branch *
	output reg Reg_multi_add_real_en,
   output reg Reg_multi_add_real_clr,
	
	//Reg_multi_add_imag - Register to store or load the multi/add imag branch *
	output reg Reg_multi_add_imag_en,
   output reg Reg_multi_add_imag_clr,

	//Reg_i *
	output reg Reg_i_en,
   output reg Reg_i_clr,
	
	//Reg_ii *
	output reg Reg_ii_en,
   output reg Reg_ii_clr,
	
	//Reg_iii *
	output reg Reg_iii_en,
   output reg Reg_iii_clr,
	
	//Reg_temp2 *
	output reg Reg_temp2_en,
   output reg Reg_temp2_clr,
	
	//Reg_temp3 *
	output reg Reg_temp3_en,
   output reg Reg_temp3_clr,
	
	//Reg_count_acumm *
	output reg Reg_count_acumm_en,
   output reg Reg_count_acumm_clr,
	
	//Reg_count_acumm2 *
	output reg Reg_count_acumm2_en,
   output reg Reg_count_acumm2_clr,
	
	//Reg_C *
	output reg Reg_C_en,
   output reg Reg_C_clr,
	
	//Reg_count2 *
	output reg Reg_count2_en,
   output reg Reg_count2_clr,
	
	//mux_U70 *
	output reg mux_U70_sel,

	//Reg_count_diag  *
	output reg Reg_count_diag_en,
   output reg Reg_count_diag_clr,
	
	//mux_3_1_U73 *
	output reg  [1:0] mux_3_1_U73_sel,

	//Reg_aux_count2 *
	output reg Reg_aux_count2_en,
   output reg Reg_aux_count2_clr,
	
	//Reg_aux_count3 *
	output reg Reg_aux_count3_en,
   output reg Reg_aux_count3_clr,
	
	
	//Reg_dd
	output reg Reg_dd_en,
   output reg Reg_dd_clr,
	
	//Reg_d
	output reg Reg_d_en,
   output reg Reg_d_clr,
	
	//Reg_C2
	output reg Reg_C2_en,
   output reg Reg_C2_clr,
	
	//Reg_Out
	output reg Reg_Out_en,
	output reg Reg_Out_clr,
	
	//mux_U90
	output reg mux_U90_sel,
	
	//mux_3_1_U80 *
	output reg  [1:0] mux_3_1_U80_sel,
	
	//mux_U82 *
	output reg mux_U82_sel,
	
	//mux_3_1_U83 *
	output reg  [1:0] mux_3_1_U83_sel,
	
	//mux_U84 *
	output reg mux_U84_sel,
	
	//mux_U96 
	output reg mux_U96_sel,
	
	//mux_U97
	output reg mux_U97_sel,
	
	//mux_U98
	output reg [1:0] mux_U98_sel,
	
	//Reg_index_r 
	output reg Reg_index_r_en,
	output reg Reg_index_r_clr,
	
	//Reg_index_r_sorted
	output reg Reg_index_r_sorted_en,
	output reg Reg_index_r_sorted_clr,
	
	//Reg_ss
	output reg Reg_ss_en,
	output reg Reg_ss_clr,
	
	//Reg_s
	output reg Reg_s_en,
	output reg Reg_s_clr,
	
	
	//WE elemnts mem *
	output reg WE_elemnts,
	
	//WE R mem *
	output reg WE_R2,
	
	//WE diagonal mem *
	output reg WE_diagonal,
	
	//WE R^-1 mem *
	output reg WE_r,
	
	//WE
	output reg WE
);

 localparam [5:0] S1=6'b000001, S2=6'b00010, S3=6'b000011, S4=6'b000100, S5=6'b000101, S6=6'b000110, 
 S7=6'b000111, S8=6'b001000, S9=6'b001001, S10=6'b001010, S11=6'b001011, S12=6'b001100, S13=6'b001101,	
 S14=6'b001110,S15=6'b001111,S16=6'b10000, S17=6'b010001, S18=6'b010010, S19=6'b010011, S20=6'b010100,
 S21=6'b010101,S22=6'b010110,S23=6'b010111, S24=6'b011000, S25=6'b011001, S26=6'b011010, S27=6'b011011,
 S28=6'b011100,S29=6'b011101,S30=6'b011110,S31=6'b011111,S32=6'b100000,S33=6'b100001,S34=6'b100010, 
 S35=6'b100011,S36=6'b100100, S37 = 6'b100101, S38 = 6'b100110, S39 = 6'b100111, S40 = 6'b101000, S41 = 6'b101001,
 S42 = 6'b101010, S43 = 6'b101011,S44 = 6'b101100, S45 = 6'b101101, S46 = 6'b101110, S47 = 6'b101111, S48 = 6'b110000,
 S49 = 6'b110001, S50 = 6'b110010, S51 = 6'b110011, S52 = 6'b110100, S53 = 6'b110101, S54 = 6'b110110, S55 = 6'b110111, 
 S56 = 6'b111000, S57 = 6'b111001, S58 = 6'b111010, S59 = 6'b111011, S60 = 6'b111100, S61 = 6'b111101, 
 S62 = 6'b111110;

 reg [5:0] state;
 reg [5:0] next;

 //(1) State register
 always@(posedge clk or negedge rstn)
     if(!rstn) 
			state <= S1;                                            
     else      
			state <= next;

			
 //(2) Combinational next state logic
 always@* begin
     //next = XX;
     case(state)
         S2: if(start_i) //busy/done initialize 
					next = S3;
             else      //@ loopback
					next = S2;
			S3:   
				 next = S4;  
			
         S4: if(non_zero_iter_COMP_i == 1'b1 && elemnts_iter_COMP_i == 1'b1) 
					next = S5;
             else      
					next = S4;            
			
			S5: 
				next = S6;
				
			
			
			S6: if(Comp_dd_i == 2'b00) begin //dd == 1
					next = S9;
				end
				else if((Comp_dd_i == 2'b10)) begin	
							next = S7; //Aqui se selecciona salida R_read_address 
				end
				else begin
							next = S9;
				end
				
				
			/*S6: if(Comp_dd_i == 2'b00) //dd == 1
					next = S9;
				 else begin 
					if((Comp_dd_i == 2'b10))
						next = S7; //Aqui se selecciona salida R_read_address 
					else 
						next = S9;
				  end
				 //else 
					//next = S2;*/
									
		   S7: 
				next = S8;
				
			S8:
				next = S11;
				
			S9: 
				next = S10;
				
			S10:
				next = S11;
				
			
		   S11: 
				next = S12;
				
			
			S12: 
				next = S13;
			
			
			S13: if(Comp_dd_i == 2'b01) //dd > d
					next = S14;
				  else 
					next = S6;
					
		//Se agrega un estado mas, todos se recorren 1	
		
			S14: 
				next = S15;
				
			S15:
				next = S16;
				
			S16: if(Comp_d_i) begin
						if(x_d_COMP_i == 2'b01) //X>0
							next = S17;
						else
							next = S19;
					end 
				  else 
					next = S5;
		
			S17: 
				next = S18;
				
			
			S18:
				next = S19;
				
			S19: if(x_d_COMP_i == 2'b00) //x == 0 *****
					  next = S20;
				  else  begin 
				  
					  next = S21;
				  
//					 if(x_d_COMP_i == 2'b10) begin //x > N-1
//						
//							if(i_COMP_i == 3'b010) //i > 2
//								next = S21;
//							else begin
//								if(i_COMP_i == 3'b011) //i == N
//									next = S22;
//								else
//									next = S23;
//							end
//						
//					  end	
//					  
//					 else
//						next = S16;
						
				 end  
					
			S20: 
				next = S21;
			
			S21: if(x_d_COMP_i == 2'b10) //x > N-1
					 next = S22; 
				  else 
					 next = S16;
			
			//fuera de los 2 ciclos
			S22: 
				next = S23;
			
			//dentro de siguiente ciclo
			
			
			S23: if(i_COMP_i == 3'b010) //i > 2
						next = S24;
					else begin
						if(i_COMP_i == 3'b011) //i == N   3'b011
								next = S25;
						else
								next = S26;
					end	
			
			
			S24: if(i_COMP_i == 3'b011) //i == N 3'b011
						next = S25;
					else 
						next = S26;
						
			
			S25: 
				next = S26;
				
			
			S26: 
				next = S27;
				
			S27: if(ii_COMP_i == 2'b00) begin //ii == 1
							next = S28;
							end
					else if(ii_COMP_i == 2'b01) begin//ii == 2 
							next = S30;//17
							end
					else if(i_COMP_i == 3'b000) begin //i == 1
							next = S34;//20
							end
					else if(i_COMP_i == 3'b001) begin //i == 2
							next = S35;//21
							end
					else begin
							next = S37;//23
					end	
							
			
	
			/*S27: if(ii_COMP_i == 2'b00) //ii == 1
							next = S28;
						 else begin
							if(ii_COMP_i == 2'b01) //ii == 2
								next = S30;//17	 	
							else begin 
								if(i_COMP_i == 3'b000) //i == 1
									next = S34;//20
								else begin 
									if(i_COMP_i == 3'b001) //i == 2
										next = S35;//21
									else 
										next = S37;//23
								end	
							end	
						 end*/
						 
			S28: if(done_div_real) 
						next = S29;
					else 
						next = S28;
						
			
			S29: 
				next = S46;
				
			S30: 
				next = S31;
				
			S31:
				next = S32;
				
			S32: if(done_div_real == 1'b1 && done_div_imag == 1'b1) //done_div_real == 1'b1 && done_div_imag == 1'b1
						next = S33;
				  else 
						next = S32;
			
			S33: 
				next = S46;
				
			
			S34: 
				next = S38;
				
			
			S35:
				next = S36;
				
			S36:
				next = S38;
				
				
			S37: 
				next = S38;
				
				
			S38: 
				next = S39;
				
			S39:
			   next = S40;
				
				
			S40: if(done_div_real == 1'b1 && done_div_imag == 1'b1) //26 ** && done_div_imag == 1'b1
						next = S41; //27
				  else 
						next = S40; //26
				
				
		   S41: 
				next = S42;
				
			S42:
				next = S43;
				
			S43:
				next = S44;
				
			S44: if(iii_COMP_i == 1'b1)// iii > ii-1 30 **
						next = S45; //31
					else
						next = S38; //24	
						
			S45:
				next = S46;
				
			S46:
				next = S47;
				
			S47: if(ii_COMP_i == 2'b11 || i_COMP_i == 3'b100) // ii > N-count2 
						next = S48; 
				  else
						next = S27;	
			S48: 
				next = S49;
				
			S49: if(i_COMP_i == 3'b100) //i > N  
					next = S50; 
				  else 
					next = S23;// o S20 inicio de algoritmo
			
			S50:
				next = S51;
				
			
			S51: if(Comp_z_i == 1'b1)
					next = S52;
				  else 
				   next = S50;
					
			S52: 
				next = S53;
				
				
			S53:
				next = S54;
				
			S54: if(Comp_ss_i == 1'b1)
					 next = S55;
				   else 
					 next = S56;
					 
			S55: 
				next = S56;
				
			
			S56: if(Comp_ss_i == 1'b1)
					 next = S57;
					else 
					  next = S53;
			
				 
			S57:
				next = S58;
				
			S58: if(Comp_s_i == 1'b1)
					 next = S59;
					else 
					 next = S53;
				
			
			S59: 
				next = S2;
			
			
			
			
			
			
			/*S50:
				next = S51;
				
				
			S51:
				next = S52;
				
				
			S52: if(out_pointer_COMP_i == 1'b1) //37
					next = S53;
				else 
					next = S52;
				
			S53: 
				next = S2;*/
						
		
			
			default:  next = S2;
     endcase
 end
 

 //(3) Registered output logic (Moore outputs)
 always@(posedge clk or negedge rstn) begin
     if(!rstn) begin //S1
			busy <= 1'b0;
			done <= 1'b0;
			Reg_non_zero_clr <= 1'b1;
			Reg_non_zero_en <= 1'b0;
			Reg_regresive_count_clr <= 1'b1;
	      Reg_regresive_count_en <= 1'b0;
			Reg_non_zero_iter_en <= 1'b0;
			Reg_non_zero_iter_clr <= 1'b1;
			Reg_count_elemnts_en <= 1'b0;
			Reg_count_elemnts_clr <= 1'b1;
			Reg_elemnts_iter_en <= 1'b0;
			Reg_elemnts_iter_clr <= 1'b1;
			Reg_cont2_clr <= 1'b1;
			Reg_cont2_en <= 1'b0;
			Reg_count_N_clr <= 1'b1;
			Reg_count_N_en <= 1'b0;
			Reg_val_d_clr <= 1'b1; 
			Reg_val_d_en <= 1'b0;			
			mux_U26_sel <= 1'b0;
			mux_U27_sel <= 1'b0;
			mux_U28_sel <= 1'b0;			
			Reg_x_d_clr <= 1'b1; 
			Reg_x_d_en <= 1'b0;
			Reg_aux_real_clr <= 1'b1;
			Reg_aux_real_en <= 1'b0;
			Reg_aux_imag_clr <= 1'b1;
			Reg_aux_imag_en <= 1'b0;
		   Reg_aux_count_clr <= 1'b1;
			Reg_aux_count_en <= 1'b0;
			mux_U37_sel	<= 1'b0;		
			mux_U39_sel <= 1'b0;			
			start_div_real_o <= 1'b0;
			start_div_imag_o <= 1'b0;
			Reg_multi_add_real_clr <= 1'b1;
			Reg_multi_add_real_en <= 1'b0;
			Reg_multi_add_imag_clr <= 1'b1;
			Reg_multi_add_imag_en <= 1'b0;
			Reg_i_clr <= 1'b1;
			Reg_i_en <= 1'b0;
			Reg_ii_clr <= 1'b1;
			Reg_ii_en <= 1'b0;
			Reg_iii_clr <= 1'b1;
			Reg_iii_en <= 1'b0;
			Reg_temp2_clr <= 1'b1; 
			Reg_temp2_en <= 1'b0;
			Reg_temp3_clr <= 1'b1; 
			Reg_temp3_en <= 1'b0;
			Reg_count_acumm_clr <= 1'b1;
			Reg_count_acumm_en <= 1'b0;
         Reg_count_acumm2_clr <= 1'b1;
			Reg_count_acumm2_en <= 1'b0;
         Reg_C_clr <= 1'b1;
			Reg_C_en <= 1'b0;
			Reg_count2_clr <= 1'b1;
			Reg_count2_en <= 1'b0;
			mux_U70_sel <= 1'b0;
			Reg_count_diag_clr <= 1'b1;
         Reg_count_diag_en <= 1'b0;
			mux_3_1_U73_sel <= 1'b0;  
			Reg_aux_count2_clr <= 1'b1;
			Reg_aux_count2_en <= 1'b0;
         Reg_aux_count3_clr <= 1'b1;
			Reg_aux_count3_en <= 1'b0;	
			Reg_Out_en <= 1'b0;
			Reg_Out_clr <= 1'b1;
			mux_3_1_U80_sel <= 2'b00;
         mux_U82_sel <= 1'b0;
			mux_3_1_U83_sel <= 2'b00;  
			mux_U84_sel	<= 1'b0;
			mux_U90_sel	<= 1'b0;
			
			mux_U96_sel <= 1'b1;
			mux_U97_sel <= 1'b0;
			mux_U98_sel <= 2'b00;
			
			
			WE_elemnts <= 1'b0;
			WE_R2 <= 1'b0;
         WE_diagonal <= 1'b0;
			WE_r <= 1'b0;
			WE <= 1'b0;
			
			Reg_dd_clr <= 1'b1;
			Reg_dd_en <= 1'b0;
			Reg_d_clr <= 1'b1;
			Reg_d_en <= 1'b0; 
			Reg_C2_clr <= 1'b1;
			Reg_C2_en <= 1'b0;
			Reg_index_r_en <= 1'b0;
			Reg_index_r_clr <= 1'b1; //Reg_index_r_clr <= 1'b0;
			Reg_index_r_sorted_en <= 1'b0;
			Reg_index_r_sorted_clr <= 1'b1;
			Reg_ss_en <= 1'b0;
			Reg_ss_clr <= 1'b1;
			Reg_s_en <= 1'b0;
			Reg_s_clr <= 1'b1;
     end
     else begin
			//one hot - First default values!
			//enable y selectores de muxes
			busy <= 1'b1;
			done <= 1'b0; //For Interrup process
			Reg_non_zero_en <= 1'b0;
	      Reg_regresive_count_en <= 1'b0;
			Reg_non_zero_iter_en <= 1'b0;
			Reg_count_elemnts_en <= 1'b0;
			Reg_elemnts_iter_en <= 1'b0;
			Reg_cont2_en <= 1'b0;
			//Reg_N_N_en <= 1'b0;
			Reg_count_N_en <= 1'b0;
			Reg_val_d_en <= 1'b0;
			Reg_x_d_en <= 1'b0;	
			Reg_aux_real_en <= 1'b0;			
			Reg_aux_imag_en <= 1'b0;	
			Reg_aux_count_en <= 1'b0;
			start_div_real_o <= 1'b0;
			start_div_imag_o <= 1'b0;
			Reg_multi_add_real_en <= 1'b0;
			Reg_multi_add_imag_en <= 1'b0;
			Reg_i_en <= 1'b0;	
			Reg_ii_en <= 1'b0;
			Reg_iii_en <= 1'b0;
			Reg_temp2_en <= 1'b0;
			Reg_temp3_en <= 1'b0;
			Reg_count_acumm_en <= 1'b0;
			Reg_count_acumm2_en <= 1'b0;
			Reg_C_en <= 1'b0;
			Reg_count2_en <= 1'b0;
         Reg_count_diag_en <= 1'b0;
			Reg_aux_count2_en <= 1'b0;	
			Reg_aux_count3_en <= 1'b0;		
         WE_elemnts <= 1'b0;
			WE_R2 <= 1'b0;
         WE_diagonal <= 1'b0;
			WE_r <= 1'b0;
			WE <= 1'b0;
			Reg_dd_en <= 1'b0;
			Reg_d_en <= 1'b0;
			Reg_C2_en <= 1'b0;
			Reg_Out_en <= 1'b0;
			//Reg_Out_en <= 1'b0;
			Reg_index_r_en <= 1'b0;
			Reg_index_r_sorted_en <= 1'b0;
			Reg_ss_en <= 1'b0;
			Reg_s_en <= 1'b0;
			
			mux_U26_sel <= 1'b1;
			//mux_U27_sel <= 1'b0;
			//mux_U28_sel <= 1'b0;
			mux_U37_sel	<= 1'b0;	
			mux_U39_sel <= 1'b0;
			mux_U70_sel <= 1'b0;
			mux_3_1_U73_sel <= 2'b00;
			mux_3_1_U73_sel <= 2'b00;
			
			//mux_3_1_U80_sel <= 2'b00;
         
			mux_U82_sel <= 1'b0;
			mux_3_1_U83_sel <= 2'b00;
			//mux_U84_sel	<= 1'b0;
			//mux_U90_sel	<= 1'b0;
			
			//mux_U96_sel <= 1'b1;//***
			//mux_U97_sel <= 1'b0;
			mux_U98_sel <= 2'b00;

			//Clrs 
			Reg_non_zero_clr <= 1'b0;
			Reg_regresive_count_clr <= 1'b0;
			Reg_non_zero_iter_clr <= 1'b0;
			Reg_count_elemnts_clr <= 1'b0;
			Reg_elemnts_iter_clr <= 1'b0;
			Reg_cont2_clr <= 1'b0;
			Reg_count_N_clr <= 1'b0;
			Reg_count_N_clr2 <= 1'b0;
			Reg_val_d_clr <= 1'b0;
			Reg_x_d_clr <= 1'b0; 
			Reg_aux_real_clr <= 1'b0;
			Reg_aux_imag_clr <= 1'b0;	
		   Reg_aux_count_clr <= 1'b0;
			Reg_multi_add_real_clr <= 1'b0;	
			Reg_multi_add_imag_clr <= 1'b0;
			Reg_i_clr <= 1'b0;
			Reg_ii_clr <= 1'b0;	
			Reg_iii_clr <= 1'b0;
			Reg_temp2_clr <= 1'b0; 
			Reg_temp3_clr <= 1'b0; 	
			Reg_count_acumm_clr <= 1'b0;
         Reg_count_acumm2_clr <= 1'b0;
         Reg_C_clr <= 1'b0;
			Reg_count2_clr <= 1'b0;
			Reg_count_diag_clr <= 1'b0;
         Reg_aux_count2_clr <= 1'b0;
         Reg_aux_count3_clr <= 1'b0;
			Reg_dd_clr <= 1'b0;
			Reg_d_clr <= 1'b0;
			Reg_C2_clr <= 1'b0;
			Reg_Out_clr <= 1'b0;
			Reg_index_r_clr <= 1'b0;
			Reg_index_r_sorted_clr <= 1'b0;
			Reg_ss_clr <= 1'b0;
			Reg_s_clr <= 1'b0;
			
			reset_div_real_o <= 1'b1;
			reset_div_imag_o <= 1'b1;
			
			
             case(next)	
						S2: begin
								busy <= 1'b0;
								done <= 1'b0;
							  end
						S3: begin
								Reg_count_elemnts_clr <= 1'b1;
								Reg_regresive_count_clr <= 1'b1;
								reset_div_real_o <= 1'b0;
								reset_div_imag_o <= 1'b0;
								
								
								mux_3_1_U80_sel <= 2'b00;
								mux_U96_sel <= 1'b1;//***
								mux_U97_sel <= 1'b0;
								
								
								
								
							 /*Reg_index_r_en <= 1'b0;
							 Reg_index_r_clr <= 1'b1; //Reg_index_r_clr <= 1'b0;
							 Reg_index_r_sorted_en <= 1'b0;
							 Reg_index_r_sorted_clr <= 1'b1;
							 Reg_ss_en <= 1'b0;
							 Reg_ss_clr <= 1'b1;
							 Reg_s_en <= 1'b0;
							 Reg_s_clr <= 1'b1;*/
							 end
						
//						S3: begin 
//								//Reg_non_zero_en <= 1'b1;
//								//Reg_count_elemnts_en <= 1'b1;
//								//Reg_elemnts_iter_en <= 1'b1;
//								
//							
//							
//							 end
						
						S4: begin 
								WE_elemnts <= 1'b1;
								Reg_count_elemnts_en <= 1'b1;
								Reg_non_zero_en <= 1'b1;
								Reg_regresive_count_en <= 1'b1;
								Reg_non_zero_iter_en <= 1'b1;
								Reg_elemnts_iter_en <= 1'b1;
								Reg_cont2_clr <= 1'b1;
								
							 end
						 
						 //Dummy and Empty States
						 
						 //S5: begin
							//	Reg_cont2_clr <= 1'b1; 
							//end  
						 //S6: begin
								//WE_R2 <= 1'b1;
							  //end
						 
						 S7: begin 
						      mux_U90_sel	<= 1'b0;
								//WE_R2 <= 1'b1;
							  end
						 
						 //S8: begin
								//Reg_cont2_en <= 1'b1; lo cambie al 11
								//WE_R2 <= 1'b1;
							  //end
						 
						 S9: begin 
						      mux_U90_sel	<= 1'b1;
								//WE_R2 <= 1'b1;
							  end
						
					    //S10: begin
								 //Reg_cont2_en <= 1'b1; lo cambie al 11
								 //WE_R2 <= 1'b1;
								//end
						 
						 S11: begin 
								 Reg_dd_en <= 1'b1;
								 Reg_cont2_en <= 1'b1;
								end
						 S12: begin 
								 //Reg_dd_clr <= 1'b1;
								 //WE_R2 <= 1'b1;
								end
								
						S13: begin
								 WE_R2 <= 1'b1;
								end	
								
						 
						 S14: begin
								 Reg_C2_en <= 1'b1;
								 Reg_dd_clr <= 1'b1;  
								end
								
						 S15: begin
								 Reg_d_en <= 1'b1;
								end
						 
						 S16: begin 
								 mux_U84_sel <= 1'b0;
								 mux_U27_sel <= 1'b1;
								 mux_U28_sel <= 1'b1;
								end
						 
						 
						 S17: begin //16
								Reg_count_N_en <= 1'b1;
								mux_U84_sel	<= 1'b0;
								mux_U27_sel <= 1'b1;
								mux_U28_sel <= 1'b1;
							  end
							  
						 S18: begin //17
								 mux_U27_sel <= 1'b1;
								 mux_U28_sel <= 1'b1;
								 mux_U84_sel	<= 1'b0;
								 Reg_val_d_en <= 1'b1;
							  end
				
						 S19: begin //18
								 mux_U27_sel <= 1'b1;
								 mux_U28_sel <= 1'b1;
								 mux_U84_sel	<= 1'b0;
								 //Reg_x_d_en <= 1'b1;
								 //WE_diagonal <= 1'b1;
								 
								end
						 
						 S20: begin //19	
								 mux_U27_sel <= 1'b1;
								 mux_U28_sel <= 1'b1;
								 mux_U84_sel	<= 1'b0;
								 Reg_count_N_en <= 1'b1;
								 mux_U26_sel <= 1'b0;
								 Reg_cont2_clr <= 1'b1;
								end		
						
						S21: begin //20
								 Reg_x_d_en <= 1'b1;
								 WE_diagonal <= 1'b1;
							   end
						 
						S22: begin 
								Reg_count_N_clr <= 1'b1;
								end
						
//						S23: begin 
//								Reg_count_N_clr <= 1'b1;
//								end
						 
						 
					S24: begin //20
							Reg_aux_count_en <= 1'b1;
							mux_U37_sel	<= 1'b0;
						  end
						 	
					 S25: begin //21
							 Reg_count_N_clr2 <= 1'b1;
							end
					
					 S26:  begin //22
							  Reg_aux_real_en <= 1'b1;			
							  Reg_aux_imag_en <= 1'b1;
							  mux_U84_sel	<= 1'b1;
							  mux_U26_sel <= 1'b1;
							  mux_U27_sel <= 1'b0;
							  mux_U28_sel <= 1'b1;
							  //Reg_count_N_clr <= 1'b1;
							 end		 
						
				 
					//S27:
				 
				 
					S28: begin //23
							start_div_real_o <= 1'b1;
							start_div_imag_o <= 1'b1;
							mux_U39_sel <= 1'b1;
							mux_U82_sel <= 1'b1;
							mux_3_1_U83_sel <= 2'b00;
							WE_r <= 1'b1;
							end
					  
					 //S29: begin //24
						//		WE_r <= 1'b1;
						//	 end
					  
				    S30: begin 
							  Reg_aux_real_en <= 1'b1;			
							  Reg_aux_imag_en <= 1'b1;
							end
				 
					 S31: begin //26
							 Reg_multi_add_real_en <= 1'b1;
							 Reg_multi_add_imag_en <= 1'b1;
							end 
			  
					 S32:  begin //27
							  start_div_real_o <= 1'b1;
							  start_div_imag_o <= 1'b1;
							  mux_U82_sel <= 1'b1;
							  mux_3_1_U83_sel <= 2'b01;
							  WE_r <= 1'b1;
							 end							
						
//					S33: begin //28
//							WE_r <= 1'b1;
//						  end
						
					S34: begin //29
							 Reg_aux_count2_en <= 1'b1;
							 mux_3_1_U73_sel <= 2'b01;
							end
						
					S35: begin //30
							 Reg_aux_count2_en <= 1'b1;
							 mux_3_1_U73_sel <= 2'b00;
							end
						
					S36: begin //31
							Reg_aux_count3_en <= 1'b1;	
							end
						
					S37: begin //32
							 Reg_aux_count2_en <= 1'b1;
							 mux_3_1_U73_sel <= 2'b10;
							end

				
					S38: begin //33
							mux_3_1_U80_sel <= 2'b10;
							mux_U28_sel <= 1'b0;
							Reg_aux_real_en <= 1'b1;			
							Reg_aux_imag_en <= 1'b1;
						  end

					S39: begin //34
							 Reg_multi_add_real_en <= 1'b1;
							 Reg_multi_add_imag_en <= 1'b1;
							end
						
					S40: begin //35
							start_div_real_o <= 1'b1;
							start_div_imag_o <= 1'b1;
						   end
						
					S41: begin //36
							Reg_temp2_en <= 1'b1;
							Reg_temp3_en <= 1'b1;
							mux_U82_sel <= 1'b0;
							mux_3_1_U83_sel <= 2'b10;
						  end
						
					S42: begin //37
							WE_r <= 1'b1;
							mux_U82_sel <= 1'b0;
							mux_3_1_U83_sel <= 2'b10;
							Reg_count_acumm_en <= 1'b1;				
						  end
				
					S43: begin //38
							//Reg_count_acumm_en <= 1'b1;
							Reg_iii_en <= 1'b1;
						  end
						
					S44: begin //39
							Reg_count_acumm2_en <= 1'b1;
						  end
						
					S45: begin //40
							Reg_temp2_clr <= 1'b1; 
							Reg_temp3_clr <= 1'b1; 	
							Reg_count_acumm_clr <= 1'b1;
							Reg_count_acumm2_clr <= 1'b1;
							Reg_iii_clr <= 1'b1;
						  end
						
					S46: begin //41
							mux_U37_sel	<= 1'b1;	
							Reg_aux_count_en <= 1'b1;
							Reg_ii_en <= 1'b1;
						  end
						
						
					S47: begin //42
							 mux_U84_sel	<= 1'b1;
							 mux_U26_sel <= 1'b1;
							 mux_U70_sel <= 1'b1;
							 Reg_count_diag_en <= 1'b1;
							 Reg_count_N_en <= 1'b1;
							end
						
						
					S48: begin //43
							 Reg_aux_count3_en <= 1'b1;
							 Reg_count_diag_clr <= 1'b1;
							 //Reg_ii_en <= 1'b1;
							
							 
							end
						
					S49: begin //44
							 mux_U70_sel <= 1'b0;
							 Reg_count_diag_en <= 1'b1;
							 Reg_count2_en <= 1'b1;
							 Reg_C_en <= 1'b1;
							 Reg_i_en <= 1'b1;
							 Reg_ii_clr <= 1'b1;	
							 
							 
							end
				
					
					S50: begin 
							  WE <= 1'b1; 
							  mux_U96_sel <= 1'b0;
							  mux_U97_sel <= 1'b0;
							end
					
					S51: begin 
							 Reg_Out_en <= 1'b1;
						  end
					
					S52: begin //dummy before sort
								Reg_index_r_clr <= 1'b1;
							end
					
					S53:begin 
						  //WE <= 1'b1; 
						  mux_U96_sel <= 1'b1;
						  mux_3_1_U80_sel <= 2'b01;
						  mux_U97_sel <= 1'b1;
						 end
					
					
					S54: begin 
								WE <= 1'b1;
								mux_U97_sel <= 1'b1;
								Reg_index_r_en <= 1'b1;
								Reg_index_r_sorted_en <= 1'b1;
								mux_U98_sel <= 2'b00;						  
							end
					
					S55: begin 
								Reg_index_r_sorted_en <= 1'b1;
								mux_U98_sel <= 2'b01;
							end
					
					S56: begin 
								Reg_ss_en <= 1'b1;
							end
					
					S57: begin 
								mux_U98_sel <= 2'b10;
								Reg_index_r_sorted_en <= 1'b1;
								Reg_ss_clr <= 1'b1;
							end
					
					
					S58: begin 
								Reg_s_en <= 1'b1;
							end
						
					S59: begin //47
							 busy <= 1'b0;
							 done <= 1'b1;
							 
							 Reg_non_zero_clr <= 1'b1;
							 Reg_non_zero_en <= 1'b0;
							 Reg_regresive_count_clr <= 1'b1;
							 Reg_regresive_count_en <= 1'b0;
							 Reg_non_zero_iter_en <= 1'b0;
							 Reg_non_zero_iter_clr <= 1'b1;
							 Reg_count_elemnts_en <= 1'b0;
							 Reg_count_elemnts_clr <= 1'b1;
							 Reg_elemnts_iter_en <= 1'b0;
							 Reg_elemnts_iter_clr <= 1'b1;
							 Reg_cont2_clr <= 1'b1;
							 Reg_cont2_en <= 1'b0;
							 Reg_count_N_clr <= 1'b1;
							 Reg_count_N_en <= 1'b0;
							 Reg_val_d_clr <= 1'b1; 
							 Reg_val_d_en <= 1'b0;			
							 mux_U26_sel <= 1'b0;
							 mux_U27_sel <= 1'b0;
							 mux_U28_sel <= 1'b0;			
							 Reg_x_d_clr <= 1'b1; 
							 Reg_x_d_en <= 1'b0;
							 Reg_aux_real_clr <= 1'b1;
							 Reg_aux_real_en <= 1'b0;
							 Reg_aux_imag_clr <= 1'b1;
							 Reg_aux_imag_en <= 1'b0;
							 Reg_aux_count_clr <= 1'b1;
							 Reg_aux_count_en <= 1'b0;
							 mux_U37_sel	<= 1'b0;		
							 mux_U39_sel <= 1'b0;			
							 start_div_real_o <= 1'b0;
							 start_div_imag_o <= 1'b0;
							 Reg_multi_add_real_clr <= 1'b1;
							 Reg_multi_add_real_en <= 1'b0;
							 Reg_multi_add_imag_clr <= 1'b1;
							 Reg_multi_add_imag_en <= 1'b0;
							 Reg_i_clr <= 1'b1;
							 Reg_i_en <= 1'b0;
							 Reg_ii_clr <= 1'b1;
							 Reg_ii_en <= 1'b0;
							 Reg_iii_clr <= 1'b1;
							 Reg_iii_en <= 1'b0;
							 Reg_temp2_clr <= 1'b1; 
							 Reg_temp2_en <= 1'b0;
							 Reg_temp3_clr <= 1'b1; 
							 Reg_temp3_en <= 1'b0;
							 Reg_count_acumm_clr <= 1'b1;
							 Reg_count_acumm_en <= 1'b0;
							 Reg_count_acumm2_clr <= 1'b1;
							 Reg_count_acumm2_en <= 1'b0;
							 Reg_C_clr <= 1'b1;
							 Reg_C_en <= 1'b0;
							 Reg_count2_clr <= 1'b1;
							 Reg_count2_en <= 1'b0;
							 mux_U70_sel <= 1'b0;
							 Reg_count_diag_clr <= 1'b1;
							 Reg_count_diag_en <= 1'b0;
							 mux_3_1_U73_sel <= 1'b0;  
							 Reg_aux_count2_clr <= 1'b1;
							 Reg_aux_count2_en <= 1'b0;
							 Reg_aux_count3_clr <= 1'b1;
							 Reg_aux_count3_en <= 1'b0;	
							 Reg_Out_en <= 1'b0;
							 Reg_Out_clr <= 1'b1;
							 mux_3_1_U80_sel <= 2'b00;
							 mux_U82_sel <= 1'b0;
							 mux_3_1_U83_sel <= 2'b00;  
							 mux_U84_sel	<= 1'b0;
							 mux_U90_sel	<= 1'b0;
								
							 mux_U96_sel <= 1'b1;
							 mux_U97_sel <= 1'b0;
							 mux_U98_sel <= 2'b00;
								
								
							 WE_elemnts <= 1'b0;
							 WE_R2 <= 1'b0;
							 WE_diagonal <= 1'b0;
							 WE_r <= 1'b0;
							 WE <= 1'b0;
								
							 Reg_dd_clr <= 1'b1;
							 Reg_dd_en <= 1'b0;
							 Reg_d_clr <= 1'b1;
							 Reg_d_en <= 1'b0; 
							 Reg_C2_clr <= 1'b1;
							 Reg_C2_en <= 1'b0;
							 Reg_index_r_en <= 1'b0;
							 Reg_index_r_clr <= 1'b1; //Reg_index_r_clr <= 1'b0;
							 Reg_index_r_sorted_en <= 1'b0;
							 Reg_index_r_sorted_clr <= 1'b1;
							 Reg_ss_en <= 1'b0;
							 Reg_ss_clr <= 1'b1;
							 Reg_s_en <= 1'b0;
							 Reg_s_clr <= 1'b1;

							reset_div_real_o <= 1'b1;
						   reset_div_imag_o <= 1'b1;
							 
							 
							 
							 
							end
				
             endcase
     end

 end

endmodule
