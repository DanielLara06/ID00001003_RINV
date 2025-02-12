/******************************************************************
*Module name : R_INV
*Filename    : R_INV.v
*Type        : Verilog Module
*
*Description : Inverse R Matrix Top entity.  
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk"
*	reset		 : sync rstn,
* 
*Parameters  : DATA_WIDTH = 32; ADDR_WIDTH = 11; N_SIZE = 6; DATA_WIDTH_CMPLX = 16; elmnts_dif_zero_bits  =   11 
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/
module R_INV
#(
    parameter DATA_WIDTH    =   32,     // Datawidth of data
    parameter ADDR_WIDTH    =   11,       // Address bits
	 parameter N_SIZE    =   6,     // Size of the square R matrix bits
    parameter DATA_WIDTH_CMPLX    =   16,       // Datawidth of complex data (Real/Imag)
	 parameter QI = 5, //Integer Part
	 parameter QF = DATA_WIDTH_CMPLX - QI, //Fractional Part (11)
	 parameter elmnts_dif_zero_bits    =   11       // elements bits
)

(
	input clk,
	input rstn,
	input start,
	input  [N_SIZE-1:0] N_elemnts_i,//N-1 that-s N = 48 - 1 = 47
	input  [DATA_WIDTH-1:0] R_mem_data_i,
	
	output  [ADDR_WIDTH:0] R_mem_read_addr_o,
	output [DATA_WIDTH-1:0] r_inv_data_o, 
	output [ADDR_WIDTH:0] r_mem_write_addr_o,
	output WE, //De máquina de estados 
	output busy, //De FSM
	output done); //De FSM
	
//Registers and wires
wire [elmnts_dif_zero_bits-1:0] Adder_non_zero_2_reg;
wire [elmnts_dif_zero_bits-1:0] reg_2_non_zero;
wire [N_SIZE-1:0] subs_regre_count_2_reg;
wire [N_SIZE-1:0] reg_2_regre_count;
wire [N_SIZE-1:0] non_zero_iter_2_reg;
wire [N_SIZE-1:0] reg_2_non_zero_iter_fb;
wire [N_SIZE-1:0] subs_count_elemnts_2_reg;
wire [N_SIZE-1:0] reg_2_subs_count_elemnts_FB;
wire [N_SIZE-1:0] add_elemnts_2_reg;
wire [N_SIZE-1:0] reg_elemnts_iter_2_fb;
wire [DATA_WIDTH-1:0] R_2_Mem_R_Vector;
wire [elmnts_dif_zero_bits-1:0] Subs_cont2_2_reg;
wire [elmnts_dif_zero_bits-1:0] Reg_cont2_2_FB;
wire [elmnts_dif_zero_bits-1:0] add_count_2_reg;
wire [elmnts_dif_zero_bits-1:0] reg_add_2_FB;
wire [elmnts_dif_zero_bits-1:0] add_val_d_2_reg;
wire [elmnts_dif_zero_bits-1:0] reg_val_2_FB;
wire [elmnts_dif_zero_bits-1:0] mux_2_add_count;
wire [elmnts_dif_zero_bits-1:0] mux_2_mem_mux;
wire [elmnts_dif_zero_bits-1:0] Add_count_count_acumm;
wire [elmnts_dif_zero_bits-1:0] mux_2_read_addr;
wire [N_SIZE-1:0] x_2_reg;
wire [DATA_WIDTH-1:0] R_2_real_imag_reg;
wire [elmnts_dif_zero_bits-1:0] add_N_1_2_mux;
wire [elmnts_dif_zero_bits-1:0] mux_2_aux_count;
wire [DATA_WIDTH_CMPLX-1:0] Mem_diag_2_Div;
wire [DATA_WIDTH_CMPLX-1:0] mux_2_Div;
wire [DATA_WIDTH-1:0] mult_r1_2_sub;
wire [DATA_WIDTH-1:0] mult_r2_2_sub;
wire [DATA_WIDTH_CMPLX-1:0] aux_imag_2_oper;
wire [DATA_WIDTH_CMPLX-1:0] aux_real_2_oper;
wire [DATA_WIDTH_CMPLX-1:0] add_real_2_reg;
wire [DATA_WIDTH-1:0] mult_i1_2_add;
wire [DATA_WIDTH-1:0] mult_i2_2_add;
wire [DATA_WIDTH_CMPLX-1:0] add_imag_2_reg;
wire [DATA_WIDTH_CMPLX-1:0] reg_2_real_div;
wire [DATA_WIDTH_CMPLX-1:0] reg_2_imag_div;
wire [N_SIZE-1:0] i_2_reg;
wire [N_SIZE-1:0] reg_i_2_FB;
wire [N_SIZE-1:0] ii_2_reg;
wire [N_SIZE-1:0] reg_ii_2_FB;
wire [N_SIZE-1:0] iii_2_reg;
wire [N_SIZE-1:0] reg_iii_2_FB;
wire [DATA_WIDTH_CMPLX-1:0] acummT2_2_reg;
wire [DATA_WIDTH_CMPLX-1:0] reg_2_fbT2;
wire [DATA_WIDTH_CMPLX-1:0] div_real_2_oper;
wire [DATA_WIDTH_CMPLX-1:0] acummT3_2_reg;
wire [DATA_WIDTH_CMPLX-1:0] reg_2_fbT3;
wire [DATA_WIDTH_CMPLX-1:0] div_imag_2_oper;
wire [ADDR_WIDTH-1:0] count_acumm_2_reg;
wire [ADDR_WIDTH-1:0] reg_2_FB_count_acumm;
wire [ADDR_WIDTH-1:0] count_acumm2_2_reg;
wire [ADDR_WIDTH-1:0] reg_2_FB_count_acumm2;
wire [ADDR_WIDTH-1:0] C_2_reg;
wire [ADDR_WIDTH-1:0] reg_2_CFB;
wire [N_SIZE-1:0] count2_2_reg;
wire [N_SIZE-1:0] reg_2_FB_count2;
wire [N_SIZE-1:0] count_diag_2_reg;
wire [N_SIZE-1:0] reg_2_FB_count_diag;
wire [N_SIZE-1:0] mux_2_count_diag;
wire [N_SIZE-1:0] i_1_2_mux;
wire [N_SIZE-1:0] aux_count3_elemnts_1_2_mux;
wire [DATA_WIDTH-1:0] elemnts_data_2_add;
wire [N_SIZE-1:0] mux_aux_count2;
wire [N_SIZE-1:0] aux_count2_2_aux_count3;
wire [N_SIZE-1:0] reg_2_adder_3_1;
wire [ADDR_WIDTH-1:0] iii_C_2_subs_N;
wire [ADDR_WIDTH-1:0] subs_count_acumm;
wire [ADDR_WIDTH-1:0] reg_aux_count_2_mux;
wire [ADDR_WIDTH-1:0] aux_count2_count_acumm2_2_mux;
wire [ADDR_WIDTH:0] mux_2_r_inv_read_addr;
wire [DATA_WIDTH_CMPLX-1:0] mux_real_2_mem;
wire [DATA_WIDTH_CMPLX-1:0] mux_imag_2_mem;
wire [DATA_WIDTH-1:0] r_inv_data_i_wire;
wire [DATA_WIDTH_CMPLX-1:0] r_real_2_oper;
wire [DATA_WIDTH_CMPLX-1:0] r_imag_2_oper;
wire [elmnts_dif_zero_bits-1:0] mux_U84_2_mux_U26;
wire [N_SIZE-1:0] reg_2_x_FB;
wire non_zero_en_2_FSM;
wire non_zero_clr_2_FSM;
wire regresive_count_en_2_FSM;
wire regresive_count_clr_2_FSM;
wire non_zero_iter_en_2_FSM;
wire non_zero_iter_clr_2_FSM;
wire non_zero_iter_COMP_2_FSM;
wire count_elemnts_en_2_FSM;
wire count_elemnts_clr_2_FSM;
wire elemnts_iter_en_2_FSM;
wire elemnts_iter_clr_2_FSM;
wire elemnts_iter_COMP_2_FSM;
wire WE_elemnts_2_FSM;
wire cont2_en_2_FSM;
wire cont2_clr_2_FSM;
wire count_N_en_2_FSM;
wire count_N_clr_2_FSM;
wire val_d_en_2_FSM;
wire val_d_clr_2_FSM;
wire mux_U26_2_FSM;
wire mux_U27_2_FSM;
wire mux_U28_2_FSM;
wire x_d_en_2_FSM;
wire x_d_clr_2_FSM;
wire diag_WE_2_FSM;
wire aux_real_en_2_FSM;
wire aux_real_clr_2_FSM;
wire aux_imag_en_2_FSM;
wire aux_imag_clr_2_FSM;
wire mux_37_2_FSM;
wire aux_count_en_2_FSM;
wire aux_count_clr_2_FSM;
wire mux_U39_2_FSM;
wire start_DIV_real_2_FSM;
wire busy_DIV_real_2_FSM;
wire done_DIV_real_2_FSM;
wire start_DIV_imag_2_FSM;
wire busy_DIV_imag_2_FSM;
wire done_DIV_imag_2_FSM;
wire multi_add_real_en_2_FSM;
wire multi_add_real_clr_2_FSM;
wire multi_add_imag_en_2_FSM;
wire multi_add_imag_clr_2_FSM; 
wire i_en_2_FSM;
wire i_clr_2_FSM;
wire ii_en_2_FSM;
wire ii_clr_2_FSM;
wire iii_en_2_FSM;
wire iii_clr_2_FSM;
wire [2:0] i_COMP_2_FSM;
wire [1:0] ii_COMP_2_FSM;
wire iii_COMP_2_FSM;
wire temp2_en_2_FSM;
wire temp2_clr_2_FSM;
wire temp3_en_2_FSM;
wire temp3_clr_2_FSM;
wire count_acumm_en_2_FSM;
wire count_acumm_clr_2_FSM;
wire count_acumm2_en_2_FSM;
wire count_acumm2_clr_2_FSM;
wire C_en_2_FSM;
wire C_clr_2_FSM;
wire count2_en_2_FSM;
wire count2_clr_2_FSM;
wire mux_U70_2_FSM;
wire count_diag_en_2_FSM;
wire count_diag_clr_2_FSM;
wire [1:0] mux_U73_2_FSM;
wire aux_count2_en_2_FSM;
wire aux_count2_clr_2_FSM;
wire aux_count3_en_2_FSM;
wire aux_count3_clr_2_FSM;
wire [1:0] mux_U80_2_FSM;
wire R_INV_WE_2_FSM;
wire mux_U82_2_FSM;
wire [1:0] mux_U83_2_FSM;
wire mux_U84_2_FSM;
wire out_pointer_COMP_2_FSM;
wire [1:0] x_d_COMP_2_FSM;
wire [N_SIZE-1:0] dd_2_reg;
wire [N_SIZE-1:0] reg_dd_2_fb;
wire [N_SIZE-1:0] d_2_reg;
wire [N_SIZE-1:0] reg_d_2_FB;
wire [N_SIZE-1:0]  dd_1_2_add;
wire [ADDR_WIDTH:0] C2_2_reg;
wire [ADDR_WIDTH:0] reg_C2_2_FB;
wire [ADDR_WIDTH:0] dd_1_C2_2_mux;
wire [ADDR_WIDTH:0] mux_2_R_read_addr;
wire [1:0] COMP_dd_2_FSM;
wire COMP_d_2_FSM;
wire dd_En_2_FSM;
wire dd_Clr_2_FSM;
wire d_En_2_FSM;
wire d_Clr_2_FSM;
wire C2_En_2_FSM;
wire C2_Clr_2_FSM;
wire mux_U90_sel;
wire R_Vec2_WE_2_FSM;
wire count_N_clr2_2_FSM;
wire [ADDR_WIDTH:0] reg_2_OutFB;
wire [ADDR_WIDTH:0] Out_2_reg;
wire Out_En_2_FSM;
wire Out_Clr_2_FSM;
wire [DATA_WIDTH-1:0] r_inv_data_2_mux;
wire [ADDR_WIDTH:0] index_r_2_reg;
wire [ADDR_WIDTH:0] reg_2_index_rFB;
wire [ADDR_WIDTH:0] mux_2_index_r_sorted; //ADDR_WIDTH-1:0
wire [N_SIZE-1:0] reg_ss_2_FB;
wire [ADDR_WIDTH:0] index_r_sorted_2_reg;
wire [ADDR_WIDTH:0] reg_index_sorted_2_FB;
wire [ADDR_WIDTH:0] mux_2_write_addr_o;
wire [N_SIZE-1:0] ss_2_reg;
wire [N_SIZE-1:0] s_2_reg;
wire [N_SIZE-1:0] reg_2_sFB;
wire mux_U96_sel_2_FSM;
wire mux_U97_sel_2_FSM;
wire [1:0] mux_U98_sel_2_FSM;
wire Reg_index_r_en_2_FSM;
wire Reg_index_r_clr_2_FSM;
wire Reg_index_r_sorted_en_2_FSM;
wire Reg_index_r_sorted_clr_2_FSM;
wire ss_en_2_FSM;
wire ss_clr_2_FSM;
wire s_en_2_FSM;
wire s_clr_2_FSM;
wire COMP_s_2_FSM;
wire  COMP_ss_2_FSM;
wire COMP_Z_2_FSM;
wire reset_div_real;
wire reset_div_imag;
wire Start_signal_real;
wire Start_signal_imag;

wire rstn_div_real;
wire rstn_div_imag;

reg aux_signal;
reg start_div_real;

reg aux_signal2;
reg start_div_imag;

/*wire Start_r;
wire Start_imag;

reg delay;
reg delay2;
reg start_div_real;
reg start_div_imag;*/




//Design instances
	
Adder_non_zero_elemnts #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits),       // elements bits //*
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits     
		) 
		
		U1 (

			.x_i	(reg_2_non_zero), //Feedback
			.y_i (reg_2_regre_count),//6 bits
			
			.result_o	(Adder_non_zero_2_reg)
);	


Reg_non_zero #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)       // elements bits //*
		)

		U2 (

			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(Adder_non_zero_2_reg),
			.En	(non_zero_en_2_FSM),//FSM
			.Clr	(non_zero_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_non_zero) //To Feedback
);	

Subs_regresive_count #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits //*
		)
		
		U3 (

			.x_i	(reg_2_regre_count), //Feedback
			.y_i ({{(N_SIZE-1){1'b0}},1'b1}),
			
			.result_o	(subs_regre_count_2_reg)
);	

Reg_regresive_count #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits //*
		)
		
		
		U4 (

			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(subs_regre_count_2_reg),
			.N	(N_elemnts_i),
			.En	(regresive_count_en_2_FSM),//FSM
			.Clr	(regresive_count_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_regre_count)
);


Adder_non_zero_iter #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits //*    
		)  
		
		U5 (

			.x_i	(reg_2_non_zero_iter_fb), //Feedback
			.y_i ({{(N_SIZE-1){1'b0}},1'b1}),
			
			.result_o	(non_zero_iter_2_reg)
);


Reg_non_zero_iter #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits //*
		) 
		
		
		U6 (

			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(non_zero_iter_2_reg),
			.En	(non_zero_iter_en_2_FSM),//FSM
			.Clr	(non_zero_iter_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_non_zero_iter_fb)
);


Comp_non_zero_iter #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits *
		)  //a3
		
		
		U7 (
			.Comp_x_i	(reg_2_non_zero_iter_fb),
			.Comp_y_i	(N_elemnts_i), //N-1
			
			.Comp_o	(non_zero_iter_COMP_2_FSM) //to FSM
			
);


Subs_count_elmnts #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits *
		) 
		
		
		U8 (
			.x_i	(reg_2_subs_count_elemnts_FB),//Feedback
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}),
			
			.result_o	(subs_count_elemnts_2_reg)
);


Reg_count_elemnts #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits *
		)
		
		
		U9 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(subs_count_elemnts_2_reg),
			.N	(N_elemnts_i),
			.En	(count_elemnts_en_2_FSM),//FSM
			.Clr	(count_elemnts_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_subs_count_elemnts_FB)
);


Adder_elmnts_iter #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits *
		)
		
		U10 (
			.x_i	(reg_elemnts_iter_2_fb),//Feedback
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}),
			
			.result_o	(add_elemnts_2_reg)
);

Reg_elemnts_iter #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits *
		) 
		
		
		U11 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(add_elemnts_2_reg),
			.En	(elemnts_iter_en_2_FSM),//FSM
			.Clr	(elemnts_iter_clr_2_FSM),//FSM
			
			.reg_o	(reg_elemnts_iter_2_fb)
);


Comp_elemnts_iter #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits *
		)  //dan
		
		
		U12 (
			.Comp_x_i	(reg_elemnts_iter_2_fb),
			.Comp_y_i	(N_elemnts_i), //N - 1
			
			.Comp_o	(elemnts_iter_COMP_2_FSM) //to FSM
			
);


simple_dual_port_ram_single_clk #(
			  .DATA_WIDTH(DATA_WIDTH),       //memory slot bits *
			  .ADDR_WIDTH(N_SIZE)     // Size of the square R matrix bits     
		) //Elements memory 
		
		
		U13  (
			.Write_clock__i	(clk),
			.Write_enable_i	(WE_elemnts_2_FSM),//FSM
			.Write_addres_i	(reg_elemnts_iter_2_fb),
			.Read_address_i	(reg_i_2_FB),//i 
			.data_input___i	({26'b00000000000000000000000000,reg_2_subs_count_elemnts_FB}),
			
			.data_output__o	(elemnts_data_2_add)
);


/*Reg_R_vector #(
			  .DATA_WIDTH(DATA_WIDTH)      //memory slot bits    *
		) 
		

		U14 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(R_mem_data_i),
			.En	(R_Vector_en_2_FSM),//FSM
			.Clr	(R_Vector_clr_2_FSM),//FSM
			
			.reg_o	(R_2_Mem_R_Vector)
);


Comp_R #(
			  .DATA_WIDTH(DATA_WIDTH)     // Size of the square R matrix bits *
		) 
		
		
		U15 ( 
			.Comp_x_i	(R_mem_data_i), //R_2_Mem_R_Vector este lo tenia aantes, si funciona así quitar registro R
			.Comp_y_i	({DATA_WIDTH{1'b0}}), //0
			
			.Comp_o	(R_COMP_2_FSM) //to FSM
			
);*/


simple_dual_port_ram_single_clk #(
			  .DATA_WIDTH(DATA_WIDTH),       //memory slot bits
			  .ADDR_WIDTH(ADDR_WIDTH)     // Size of the square R matrix bits     
		) //R_Vector2 memory *
		
		
		U14 (
			.Write_clock__i	(clk),
			.Write_enable_i	(R_Vec2_WE_2_FSM),//FSM
			.Write_addres_i	(Reg_cont2_2_FB),
			.Read_address_i	(mux_2_read_addr),
			.data_input___i	(R_mem_data_i), //R_2_Mem_R_Vector
			
			.data_output__o	(R_2_real_imag_reg)
);



Subs_cont2 #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		)
		
		
		U15 (
			.x_i	(Reg_cont2_2_FB),//Feedback
			.y_i	({{(elmnts_dif_zero_bits-1){1'b0}},1'b1}),
			
			.result_o	(Subs_cont2_2_reg)
);


Reg_cont2 #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		) 
		
		U16 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(Subs_cont2_2_reg),
			.N	(reg_2_non_zero),//1176
			.En	(cont2_en_2_FSM),//FSM
			.Clr	(cont2_clr_2_FSM),//FSM
			
			.reg_o	(Reg_cont2_2_FB)
);


/*Adder_N_N #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		)
		
		
		U19 (
			.x_i	(N_N_2_FB),//Feedback
			.y_i	({{(elmnts_dif_zero_bits){1'b0}},1'b1}),
			
			.result_o	(Adder_N_N_2_reg)
);


Reg_N_N #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		) 
		
		U20 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(Adder_N_N_2_reg),
			.En	(N_N_en_2_FSM),//FSM
			.Clr	(N_N_clr_2_FSM),//FSM
			
			.reg_o	(N_N_2_FB)
);



Comp_N_N #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits
		)
		
		
		U21 (
			.Comp_x_i	(N_N_2_FB),
			.Comp_y_i	({{(elmnts_dif_zero_bits-N_SIZE){1'b0}},N_elemnts_i}), //N
			
			.Comp_o	(N_N_COMP_2_FSM) //to FSM
			
);*/


Adder_count_d #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		)
		

		U17 (
			.x_i	(reg_add_2_FB),//Feedback
			.y_i	(mux_2_add_count),
			
			.result_o	(add_count_2_reg)
		
		
);


Reg_count_N #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		)
	
	
		U18 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(add_count_2_reg),
			.N_dif_zero	(reg_2_non_zero), //1176 
			.En	(count_N_en_2_FSM),//FSM
			.Clr	(count_N_clr_2_FSM),//FSM
			.Clr2	(count_N_clr2_2_FSM),//FSM
			
			.reg_o	(reg_add_2_FB)
);


Adder_val_d #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		)
		

		U19 (
			.x_i	(reg_val_2_FB),//Feedback
			.y_i	(reg_add_2_FB),
			
			.result_o	(add_val_d_2_reg)
		
		
);


Reg_val_d #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		) 
		
		
		U20 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(add_val_d_2_reg),
			.En	(val_d_en_2_FSM),//FSM
			.Clr	(val_d_clr_2_FSM),//FSM
			
			.reg_o	(reg_val_2_FB)
);

	
mux #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits
		)  //Generic mux for count module, using to set the diagonal values of R matrix  *
		
		
		U21 (
			.select	(mux_U26_2_FSM),//FSM
			.i_one	(mux_U84_2_mux_U26),//mux 1 o -1
			.i_zero	({{(elmnts_dif_zero_bits-N_SIZE){1'b0}},N_elemnts_i} + {{(elmnts_dif_zero_bits-1){1'b0}},1'b1}), //48-1     - {{(elmnts_dif_zero_bits-1){1'b0}},1'b1}
			
			.mux_o	(mux_2_add_count)
);


mux #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		)  //Generic mux after val_d module
	
		
		U22 (
			.select	(mux_U27_2_FSM),//FSM
			.i_one	(reg_val_2_FB),
			.i_zero	(reg_add_2_FB),//count
			
			.mux_o	(mux_2_mem_mux)
);


mux #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits
		)  //Generic mux to choose val or count  + count_acumm *
	
		
		U23 (
			.select	(mux_U28_2_FSM),//FSM
			.i_one	(mux_2_mem_mux),//mux_2_mem_mux (viene de val)
			.i_zero	(Add_count_count_acumm),//adder count_count_acumm 
			
			.mux_o	(mux_2_read_addr)
);


Adder_count_count_acumm #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits
		) 
	
		
		U24 (
			.x_i	(reg_add_2_FB),//count
			.y_i	(reg_2_FB_count_acumm),//count_acumm
			
			.result_o	(Add_count_count_acumm)
		
);


Adder_x_d #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits *
		) 
	
		
		U25 (
			.x_i	(reg_2_x_FB), //Feedback
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}),
			
			.result_o	(x_2_reg)
		
);


Reg_x_d #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits *
		) 
	
		
		U26 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(x_2_reg),
			.En	(x_d_en_2_FSM),//FSM val_d_en_2_FSM   x_d_en_2_FSM
			.Clr	(x_d_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_x_FB)
		
);


Comp_x_d #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits *
		) 
	
		
		U27 (
			.Comp_x_i	(reg_2_x_FB),
			.Comp_y_i	(N_elemnts_i),//N
			
			.Comp_o	(x_d_COMP_2_FSM)//FSM 2 bits
		
);


simple_dual_port_ram_single_clk #(
			  .DATA_WIDTH(DATA_WIDTH/2),       //memory slot bits
			  .ADDR_WIDTH(N_SIZE)     // Size of the square R matrix bits *
		)  //Diagonal memory *
		
		
		U28 (
			.Write_clock__i	(clk),
			.Write_enable_i	(diag_WE_2_FSM),//FSM
			.Write_addres_i	(reg_2_x_FB),
			.Read_address_i	(reg_2_FB_count_diag),
			.data_input___i	(R_2_real_imag_reg[(2*DATA_WIDTH_CMPLX)-1:DATA_WIDTH_CMPLX]), //Real data took it from the diagonal
			
			.data_output__o	(Mem_diag_2_Div)
		
);


Reg_aux_real #(
			  .DATA_WIDTH(DATA_WIDTH/2)       //memory slot bits *
		) 
		
		U29 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(R_2_real_imag_reg[31:16]),
			.En	(aux_real_en_2_FSM),//FSM
			.Clr	(aux_real_clr_2_FSM),//FSM

			.reg_o	(aux_real_2_oper)
);


Reg_aux_imag #(
			  .DATA_WIDTH(DATA_WIDTH/2)       //memory slot bits *
		) 
		
		
		U30 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(R_2_real_imag_reg[15:0]),
			.En	(aux_imag_en_2_FSM),//FSM
			.Clr	(aux_imag_clr_2_FSM),//FSM

			.reg_o	(aux_imag_2_oper)
);



Adder_N_1 #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)       //memory slot bits *
		) 
		
		
		U31 (
			.x_i	({{(elmnts_dif_zero_bits-N_SIZE){1'b0}},N_elemnts_i}),
			.y_i	({{(elmnts_dif_zero_bits-1){1'b0}},1'b1}),
			
			.result_o	(add_N_1_2_mux)
);


mux #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		)  //Generic mux between N+1 to aux_count_reg
	
		
		U32 (
			.select	(mux_37_2_FSM),//FSM
			.i_one	(reg_add_2_FB),//Count
			.i_zero	(add_N_1_2_mux),//n+1 11 bits
			
			.mux_o	(mux_2_aux_count)
);


Reg_aux_count #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		) 
	

		U33 (
			.clk	(clk), 
			.rstn (rstn),
			.reg_i	(mux_2_aux_count),
			.En	(aux_count_en_2_FSM),//FSM
			.Clr	(aux_count_clr_2_FSM),//FSM

			.reg_o	(reg_aux_count_2_mux)
);


mux #(
			  .elmnts_dif_zero_bits(DATA_WIDTH_CMPLX)     // Size of the square R matrix bits *
		) 
	
		
		U34 (
			.select	(mux_U39_2_FSM),//FSM
			.i_one	(16'h0800), //number 1 fixed point representation 
			.i_zero	(reg_2_real_div),//Real branch input
			
			.mux_o	(mux_2_Div)
);


DividerCore_Pipeline #(
			  .DATA_WIDTH(DATA_WIDTH_CMPLX), //Divider Wordlength *
			  .INTEGER_BITS(QI),     // Integer part Size
			  .INTEGER_BITS_INTERNAL_FORMAT(3),
			  .NRP_DATA_WIDTH(32)
		)  //Real branch divider
	
		
		U35 (
			.clk	(clk),
			.rstn	(rstn),//Cambiar por el reset de la FSM rstn rstn_div_real
			.start_i	(start_div_real), //FSM - Must send one shot bit to enable division start_DIV_real_2_FSM  
			.data_dividend_i	(mux_2_Div),
			.data_divisor_i	(Mem_diag_2_Div), //Diagonal
			
			.data_o	(div_real_2_oper),
			.busy_o	(busy_DIV_real_2_FSM),//Internal busy to FSM, works like a flag 
			.done_o	(done_DIV_real_2_FSM)	//Internal Done to FSM, works like a flag 
);

DividerCore_Pipeline #(
			  .DATA_WIDTH(DATA_WIDTH_CMPLX), //Divider Wordlength *
			  .INTEGER_BITS(QI),     // Integer part Size
			  .INTEGER_BITS_INTERNAL_FORMAT(3),
			  .NRP_DATA_WIDTH(32)
		)  //Imaginary branch divider
	
		
		U36 (
			.clk	(clk),
			.rstn	(rstn), //reset_div_imag rstn_div_imag
			.start_i	(start_div_imag), //FSM - Must send one shot bit to enable division  start_DIV_imag_2_FSM
			.data_dividend_i	(reg_2_imag_div), //Imaginary branch input
			.data_divisor_i	(Mem_diag_2_Div), //Diagonal
			
			.data_o	(div_imag_2_oper),
			.busy_o	(busy_DIV_imag_2_FSM),//Internal busy to FSM, works like a flag 
			.done_o	(done_DIV_imag_2_FSM)	//Internal Done to FSM, works like a flag 
);



Mult_real1 #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX), //Divider Wordlength *
			  .QI(QI),     // Integer part Size
			  .QF(QF)	//Fractional part Size
		) 
		
		U37 (
			.x_i	(aux_imag_2_oper),//Aux imag
			.y_i	(r_imag_2_oper), //r_i
			
			.result_o	(mult_r1_2_sub)
);

Mult_real2 #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX), //Divider Wordlength * 
			  .QI(QI),     // Integer part Size
			  .QF(QF)	//Fractional part Size
		) 

		U38 (
			.x_i	(aux_real_2_oper), //Aux_real
			.y_i	(r_real_2_oper), //r_r C2
			
			.result_o	(mult_r2_2_sub)
);

Subs_real #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX), //Divider Wordlength *
			  .QI(QI),     // Integer part Size
			  .QF(QF)	//Fractional part Size
		)
	
		
		U39 (
			.x_i	(mult_r1_2_sub),
			.y_i	(mult_r2_2_sub),
			
			.result_o	(add_real_2_reg)
);


Reg_multi_add_real #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX), //Divider Wordlength *
			  .QI(QI),     // Integer part Size
			  .QF(QF)	//Fractional part Size
		)
	
	
		U40 (
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(add_real_2_reg),
			.En	(multi_add_real_en_2_FSM), //FSM
			.Clr	(multi_add_real_clr_2_FSM), //FSM
			
			.reg_o	(reg_2_real_div)
		
);


Mult_imag1 #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX), //Divider Wordlength *
			  .QI(QI),     // Integer part Size
			  .QF(QF)	//Fractional part Size
		) 
	
		
	   U41 (
			.x_i	(aux_real_2_oper),//Aux_real
			.y_i	(r_imag_2_oper), //r_i
			
			.result_o	(mult_i1_2_add)
);	


Mult_imag2 #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX), //Divider Wordlength *
			  .QI(QI),     // Integer part Size
			  .QF(QF)	//Fractional part Size
		)
	
		
	   U42 (
			.x_i	(aux_imag_2_oper), //Aux_imag
			.y_i	(r_real_2_oper), //r_r
			
			.result_o	(mult_i2_2_add)
);	


Add_imag #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX), //Divider Wordlength *
			  .QI(QI),     // Integer part Size
			  .QF(QF)	//Fractional part Size
		) 
	
		
		U43 (
			.x_i	(mult_i1_2_add),
			.y_i	(mult_i2_2_add),
			
			.result_o	(add_imag_2_reg)
);
		

Reg_multi_add_imag #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX), //Divider Wordlength *
			  .QI(QI),     // Integer part Size
			  .QF(QF)	//Fractional part Size
		) 
	
	
		U44 (
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(add_imag_2_reg),
			.En	(multi_add_imag_en_2_FSM),//FSM
			.Clr	(multi_add_imag_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_imag_div)
		
);
		

Adder_i #(
			  .N_SIZE(N_SIZE)     //*
		)
	
		U45 (
			.x_i	(reg_i_2_FB),
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}), //1 DATA_WIDTH_CMPLX
			
			.result_o	(i_2_reg)
);
		

Reg_i #(
			  .N_SIZE(N_SIZE)     //*
		)
	 
	
		U46 (
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(i_2_reg),
			.En	(i_en_2_FSM),//FSM
			.Clr	(i_clr_2_FSM),//FSM
			
			.reg_o	(reg_i_2_FB)
		
);
		
Adder_ii #(
			  .N_SIZE(N_SIZE)     //*
		) 
	

		U47 (
			.x_i	(reg_ii_2_FB),
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}),
			
			.result_o	(ii_2_reg)
);
			
		
Reg_ii #(
			  .N_SIZE(N_SIZE)     //*
		) 	
	
		U48 (
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(ii_2_reg),
			.En	(ii_en_2_FSM),//FSM
			.Clr	(ii_clr_2_FSM),//FSM
			
			.reg_o	(reg_ii_2_FB)
		
);		
		
Adder_iii #(
			  .N_SIZE(N_SIZE)     //*
		)
	

		U49 (
			.x_i	(reg_iii_2_FB),
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}), //DATA_WIDTH_CMPLX
			
			.result_o	(iii_2_reg)
);
			
		
Reg_iii #(
			  .N_SIZE(N_SIZE)     //*
		) 	
	
		U50(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(iii_2_reg),
			.En	(iii_en_2_FSM),//FSM
			.Clr	(iii_clr_2_FSM),//FSM
			
			.reg_o	(reg_iii_2_FB)
		
);		
		
		
Comp_i #(
			  .N_SIZE(N_SIZE)     //*
		) 
	
		
		U51(
			.Comp_x_i	(N_elemnts_i), //N
			.Comp_y_i	(reg_i_2_FB), //i
			
			.Comp_o	(i_COMP_2_FSM) //FSM
		
);	
		
		
Comp_ii #(
			  .N_SIZE(N_SIZE)     //*
		)
		
		U52 (
			.Comp_x_i	(N_elemnts_i ), //N - {{(N_SIZE-1){1'b0}}, 1'b1} 48
			.Comp_y_i	(reg_2_FB_count2), //count2
			.Comp_z_i	(reg_ii_2_FB), //ii
			
			.Comp_o	(ii_COMP_2_FSM) //FSM
		
);	
		

Comp_iii  #(
			  .N_SIZE(N_SIZE)     //*
		)
	
		
		U53(
			.Comp_x_i	(reg_ii_2_FB), //ii
			.Comp_y_i	(reg_iii_2_FB), //iii
			
			.Comp_o	(iii_COMP_2_FSM) //FSM
		
);	



Adder_temp2 #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX),//*
			  .QI(QI),
			  .QF(QF)
		)
	

		U54 (
			.x_i	(reg_2_fbT2),//Feedback
			.y_i	(div_real_2_oper), //Div_real
			
			.result_o	(acummT2_2_reg)
);


Reg_temp2 #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX)//*
		) 
		
		U55 (
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(acummT2_2_reg),
			.En	(temp2_en_2_FSM),//FSM
			.Clr	(temp2_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_fbT2)
);


Adder_temp3 #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX),//*
			  .QI(QI),
			  .QF(QF)
		) 
	
		U56(
			.x_i	(reg_2_fbT3),//Feedback
			.y_i	(div_imag_2_oper), //Div_imag
			
			.result_o	(acummT3_2_reg)
);


Reg_temp3 #(
			  .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX)//*
		) 
		
		U57(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(acummT3_2_reg),
			.En	(temp3_en_2_FSM),//FSM
			.Clr	(temp3_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_fbT3)
);


Adder_count_acumm #(
			  .ADDR_WIDTH(ADDR_WIDTH) //*
		) 

		U58 (
			.x_i	(reg_2_FB_count_acumm),//Feedback
			.y_i	(subs_count_acumm), //N+(iii+C)
			
			.result_o	(count_acumm_2_reg)
);


Reg_count_acumm #(
			  .ADDR_WIDTH(ADDR_WIDTH) //*
		) 
	
		
		U59(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(count_acumm_2_reg),
			.En	(count_acumm_en_2_FSM),//FSM
			.Clr	(count_acumm_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_FB_count_acumm)
);


Adder_count_acumm2 #(
			  .ADDR_WIDTH(ADDR_WIDTH) //*
		) 

		U60(
			.x_i	(reg_2_FB_count_acumm2),//Feedback
			.y_i	({{(ADDR_WIDTH-1){1'b0}},1'b1}), //1 en 11 bits
			
			.result_o	(count_acumm2_2_reg)
);


Reg_count_acumm2 #(
			  .ADDR_WIDTH(ADDR_WIDTH) //*
		)
	
		
		U61 (
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(count_acumm2_2_reg),
			.En	(count_acumm2_en_2_FSM),//FSM
			.Clr	(count_acumm2_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_FB_count_acumm2)
);


Adder_C #(
			  .ADDR_WIDTH(ADDR_WIDTH) //*
		)

		U62(
			.x_i	(reg_2_CFB),//Feedback
			.y_i	({{(ADDR_WIDTH-1){1'b0}},1'b1}), //1
			
			.result_o	(C_2_reg)
);


Reg_C  #(
			  .ADDR_WIDTH(ADDR_WIDTH) //*
		) 
	
		U63(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(C_2_reg),
			.En	(C_en_2_FSM),//FSM
			.Clr	(C_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_CFB)
);


Adder_count2 	#(
			  .N_SIZE(N_SIZE) //*
		) 

		U64(
			.x_i	(reg_2_FB_count2),//Feedback
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}), //1 
			
			.result_o	(count2_2_reg)
);


Reg_count2 #(
			  .N_SIZE(N_SIZE) //*
		) 
		
		U65(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(count2_2_reg),
			.En	(count2_en_2_FSM),//FSM
			.Clr	(count2_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_FB_count2)
);

Adder_i_1 #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits *
		) 
		
		U66(
			.x_i	(reg_i_2_FB),//i
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}),//1
			
			.result_o	(i_1_2_mux)
);


mux #(
			  .elmnts_dif_zero_bits(N_SIZE)     // Size of the square R matrix bits *
		) 
	
		
		U67(
			.select	(mux_U70_2_FSM),//FSM
			.i_one	({{(N_SIZE-1){1'b0}},1'b1}), //1
			.i_zero	(i_1_2_mux),//i + 1 input
			
			.mux_o	(mux_2_count_diag)
);


Adder_count_diag #(
			  .N_SIZE(N_SIZE) //*
		) 

		U68(
			.x_i	(reg_2_FB_count_diag),//Feedback
			.y_i	(mux_2_count_diag), //mux
			
			.result_o	(count_diag_2_reg)
);

Reg_count_diag #(
			  .N_SIZE(N_SIZE) //*
		)
		
		U69(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(count_diag_2_reg),
			.En	(count_diag_en_2_FSM),//FSM
			.Clr	(count_diag_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_FB_count_diag)
);


mux_3_1 #(
			  .elmnts_dif_zero_bits(N_SIZE) //Checar, tenía N_SIZE * tenía elmnts_dif_zero_bits
		) 
		
		U70 (
			.select	(mux_U73_2_FSM), //FSM
			.i_x	(add_N_1_2_mux[5:0]), //N+1 11bits add_N_1_2_mux
			.i_y	({{(N_SIZE-1){1'b0}},1'b1}), //1 {{(N_SIZE-1){1'b0}},1'b0}
			.i_z	(aux_count3_elemnts_1_2_mux), //aux_count3 + elements + 1 *****
			
			.mux_o	(mux_aux_count2)
		
);


Adder_3_1 #(
			  .N_SIZE(N_SIZE) //*
		) 
		
		U71(
			.x_i	(reg_2_adder_3_1),//aux_count3
			.y_i	(elemnts_data_2_add[N_SIZE-1:0]),//elements
			.z_i	({{(N_SIZE-1){1'b0}},1'b1}),//1
			
			.result_o	(aux_count3_elemnts_1_2_mux)
);


Reg_aux_count2  #(
			  .N_SIZE(N_SIZE) //*
		)
		
		U72(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(mux_aux_count2),
			.En	(aux_count2_en_2_FSM),//FSM
			.Clr	(aux_count2_clr_2_FSM),//FSM
			
			.reg_o	(aux_count2_2_aux_count3)
);


Reg_aux_count3 #(
			  .N_SIZE(N_SIZE) //*
		) 
		
		U73(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(aux_count2_2_aux_count3),
			.En	(aux_count3_en_2_FSM),//FSM
			.Clr	(aux_count3_clr_2_FSM),//FSM
			
			.reg_o	(reg_2_adder_3_1)
);


Adder_iii_C #(
			  .ADDR_WIDTH(ADDR_WIDTH)
		)  //*
		
		U74(
			.x_i	({{(ADDR_WIDTH-N_SIZE){1'b0}},reg_iii_2_FB}),//iii
			.y_i	(reg_2_CFB),//C

			
			.result_o	(iii_C_2_subs_N)
);


Subs_N_iii_C #(
			  .ADDR_WIDTH(ADDR_WIDTH)
		)  //*
		
		U75 (
			.x_i	({{(ADDR_WIDTH-N_SIZE){1'b0}},N_elemnts_i}),//N a 11 bits - {{(ADDR_WIDTH-1){1'b0}},1'b1}
			.y_i	(iii_C_2_subs_N),//(iii+C)

			
			.result_o	(subs_count_acumm)
);


Adder_aux_count2_count_acumm2 #(
			  .ADDR_WIDTH(ADDR_WIDTH) //*
		) 
		
		U76 (
			.x_i	({{(ADDR_WIDTH-N_SIZE){1'b0}},aux_count2_2_aux_count3}),//aux_count2
			.y_i	(reg_2_FB_count_acumm2),//count_acumm2

			.result_o	(aux_count2_count_acumm2_2_mux)//mux_3_1
);


mux_3_1 #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits+1) //Checar, tenía N_SIZE * 11 bits elmnts_dif_zero_bits
		) 
		
		U77 (
			.select	(mux_U80_2_FSM), //FSM
			.i_x	({{(1){1'b0}},reg_aux_count_2_mux}), //aux_count 11
			.i_y	(reg_2_index_rFB), //read_addr_o Out reg_2_OutFB reg_2_index_rFB    {{(ADDR_WIDTH-N_SIZE){1'b0}},aux_count2_2_aux_count3}  12
			.i_z	({{(1){1'b0}},aux_count2_count_acumm2_2_mux}), //aux_count2_count_acumm2 11
			
			.mux_o	(mux_2_r_inv_read_addr)
		
);


simple_dual_port_ram_single_clk #(
			  .DATA_WIDTH(DATA_WIDTH),       //memory slot bits *
			  .ADDR_WIDTH(ADDR_WIDTH)     // Size of the square R matrix bits     *
		)  //R^-1 data matrix 
		
		U78 (
			.Write_clock__i	(clk),
			.Write_enable_i	(R_INV_WE_2_FSM),//FSM
			.Write_addres_i	(reg_add_2_FB),//Count_d o count_N, se debe resetear a 1
			.Read_address_i	(mux_2_r_inv_read_addr[10:0]),
			.data_input___i	(r_inv_data_i_wire),
			
			.data_output__o	(r_inv_data_2_mux)
);


mux #(
			  .elmnts_dif_zero_bits(DATA_WIDTH_CMPLX)     // Size of the square R matrix bits *
		) //Mux parte real (16 bits)
		
		U79 (
			.select	(mux_U82_2_FSM),//FSM
			.i_one	(div_real_2_oper), //div1 o div_real
			.i_zero	(reg_2_fbT2),//temp2
			
			.mux_o	(mux_real_2_mem)// concatenar con imaginario 
);


mux_3_1 #(
			  .elmnts_dif_zero_bits(DATA_WIDTH_CMPLX) //Checar, tenía N_SIZE *
		)  //Mux parte imaginaria (16 bits)
		
		U80(
			.select	(mux_U83_2_FSM), //FSM
			.i_x	({(DATA_WIDTH_CMPLX){1'b0}}), //0
			.i_y	(div_imag_2_oper), //Div2 o DivImag
			.i_z	(reg_2_fbT3), //temp3
			
			.mux_o	(mux_imag_2_mem)//Concatenar
		
);

mux #(
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits)     // Size of the square R matrix bits *
		) //mux selecting between 1 or -1
		
		U81(
			.select	(mux_U84_2_FSM),//FSM
			.i_one	({{(elmnts_dif_zero_bits-1){1'b0}},1'b1}), //1
			.i_zero	({(elmnts_dif_zero_bits){1'b1}}),//-1 en complemento a 2
			
			.mux_o	(mux_U84_2_mux_U26)//  
);


Comp_out_pointer #(
			  .ADDR_WIDTH(ADDR_WIDTH)     // Size of the square R matrix bits
		)  //out counter(pointer) *

		U82(
			.Comp_x_i(reg_2_CFB),//C
			.Comp_y_i(reg_2_non_zero),//Elements_diff_zero
			
			.Comp_o(out_pointer_COMP_2_FSM)//FSM
);

 
Adder_dd #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits
		)

		U83 (
			.x_i	(reg_dd_2_fb),//feedback
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}),//1

			.result_o	(dd_2_reg)//
);

Reg_dd #(
			  .N_SIZE(N_SIZE)     // Size of the square R matrix bits
		)
		
		U84(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(dd_2_reg),
			.En	(dd_En_2_FSM),//FSM
			.Clr	(dd_Clr_2_FSM),//FSM
			
			.reg_o	(reg_dd_2_fb)
);


Comp_dd #(
			  .N_SIZE(N_SIZE)     
		)
	
		U85(
			.Comp_x_i	(reg_dd_2_fb), //dd
			.Comp_y_i	(reg_d_2_FB), //d o d-1
			
			.Comp_o	(COMP_dd_2_FSM) //FSM
		
);


Adder_d #(
			  .N_SIZE(N_SIZE)     
		)

		U86 (
			.x_i	(reg_d_2_FB),//feedback
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}),//1

			.result_o	(d_2_reg)//
);


Reg_d #(
			  .N_SIZE(N_SIZE)     
		)
		
		U87(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(d_2_reg),
			.En	(d_En_2_FSM),//FSM
			.Clr	(d_Clr_2_FSM),//FSM
			
			.reg_o	(reg_d_2_FB)
);	


Comp_d #(
			  .N_SIZE(N_SIZE)     
		)
	
		U88(
			.Comp_x_i	(reg_d_2_FB), //d
			.Comp_y_i	(N_elemnts_i), //N
			
			.Comp_o	(COMP_d_2_FSM) //FSM
		
);


Subs_dd_1 #(
			  .N_SIZE(N_SIZE)     
		)
		
		U89(
			.x_i	(reg_dd_2_fb), //dd
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}), //1
			
			.result_o	(dd_1_2_add) 
		
);


Adder_dd_1_C2 #(
			  .ADDR_WIDTH(ADDR_WIDTH)     
		)

		U90 (
			.x_i	({{((ADDR_WIDTH-N_SIZE)+1){1'b0}},dd_1_2_add}),//dd-1
			.y_i	(reg_C2_2_FB),//C2

			.result_o	(dd_1_C2_2_mux)//C2 + (dd-1) to mux
);

Adder_C2 #(
			  .ADDR_WIDTH(ADDR_WIDTH)     // Size of the square R matrix bits
		) 
		
		U91 (
			.x_i	(reg_C2_2_FB),//Feedback
			.y_i	({{((ADDR_WIDTH-N_SIZE)+1){1'b0}},N_elemnts_i}),//N

			.result_o	(C2_2_reg) 
			
);

Reg_C2 #(
			  .ADDR_WIDTH(ADDR_WIDTH)     // Size of the square R matrix bits
		)
		
		U92(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(C2_2_reg),
			.En	(C2_En_2_FSM),//FSM
			.Clr	(C2_Clr_2_FSM),//FSM
			
			.reg_o	(reg_C2_2_FB) //to mux
);	


mux #(
			  .elmnts_dif_zero_bits(ADDR_WIDTH+1)     // Size of the square R matrix bits *
		) 
		
		U93 (
			.select	(mux_U90_sel),//FSM
			.i_one	(reg_C2_2_FB), //C2
			.i_zero	(dd_1_C2_2_mux),//C2+(dd-1)
			
			.mux_o	(mux_2_R_read_addr)// concatenar con imaginario 
);

Adder_Out #(
			  .ADDR_WIDTH(ADDR_WIDTH)
			  //.N_SIZE	(N_SIZE) //*
		)

		U94(
			.x_i	(reg_2_OutFB),//Feedback
			.y_i	({{(ADDR_WIDTH){1'b0}},1'b1}), //1
			
			.result_o	(Out_2_reg)
);


Reg_Out  #(
			  .ADDR_WIDTH(ADDR_WIDTH) //*
		) 
	
		U95(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(Out_2_reg),
			.En	(Out_En_2_FSM),//FSM
			.Clr	(Out_Clr_2_FSM),//FSM
			
			.reg_o	(reg_2_OutFB)
);

mux #( 
			  .elmnts_dif_zero_bits(DATA_WIDTH) // mux 2 data o 
		)

		U96(
			.select	(mux_U96_sel_2_FSM),//FSM
			.i_one	(r_inv_data_2_mux), //data_o
			.i_zero	({(DATA_WIDTH){1'b0}}),//0
			
			.mux_o	(r_inv_data_o)
);


mux #( 
			  .elmnts_dif_zero_bits(elmnts_dif_zero_bits+1) // mux 2 write addr o 
		)

		U97(
			.select	(mux_U97_sel_2_FSM),//FSM
			.i_one	(reg_index_sorted_2_FB), //index_sorted
			.i_zero	(reg_2_OutFB),//out (zeros)
			
			.mux_o	(mux_2_write_addr_o)
);


mux_3_1 #(
			  .elmnts_dif_zero_bits(ADDR_WIDTH+1) 
		)  //Mux selector para -1/-ss/N
		
		U98(
			.select	(mux_U98_sel_2_FSM), //FSM
			.i_x	({{(ADDR_WIDTH){1'b0}},1'b1}), //1 {{(ADDR_WIDTH-1){1'b0}},1'b1} 11
			.i_y	(({{((ADDR_WIDTH-N_SIZE)+1){1'b0}},reg_ss_2_FB})), //ss  11
			.i_z	({{(((ADDR_WIDTH)-N_SIZE)+1){1'b0}},N_elemnts_i} - {{(ADDR_WIDTH){1'b0}},1'b1}), //N {{(ADDR_WIDTH-1){1'b0}},1'b1} 47
			
			.mux_o	(mux_2_index_r_sorted)
		
);


index_r #(
			  .ADDR_WIDTH(ADDR_WIDTH) 
		) 
		
		U99(
			.x_i	(reg_2_index_rFB),//feedback
			.y_i	({{(ADDR_WIDTH){1'b0}},1'b1}), //1
			
			.result_o	(index_r_2_reg)
);


Reg_index_r #(
			  .ADDR_WIDTH(ADDR_WIDTH) 
		) 

		U100(
			.clk	(clk),
			.rstn(rstn),
			.reg_i	(index_r_2_reg),
			.elements_dif_zero_i	({{(1){1'b0}},reg_2_non_zero}), //{{(ADDR_WIDTH-N_SIZE){1'b0}},reg_2_non_zero}
			.En	(Reg_index_r_en_2_FSM),//FSM
			.Clr	(Reg_index_r_clr_2_FSM),//FSM
			
			.reg_o (reg_2_index_rFB)
);
		

index_r_sorted #(
			  .ADDR_WIDTH(ADDR_WIDTH) 
		) 
		
		U101(
			.x_i	(reg_index_sorted_2_FB),//feedback
			.y_i	(mux_2_index_r_sorted), //mux2adder {{(1){1'b0}},mux_2_index_r_sorted}
			.N	({{((N_SIZE)){1'b0}},N_elemnts_i}),//N_elemnts_i
			.select	(mux_U98_sel_2_FSM),
			
			.result_o	(index_r_sorted_2_reg)
);
		
	
Reg_index_r_sorted #(
			  .ADDR_WIDTH(ADDR_WIDTH) 
		) 

		U102(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(index_r_sorted_2_reg),
			.En	(Reg_index_r_sorted_en_2_FSM),//fsm
			.Clr	(Reg_index_r_sorted_clr_2_FSM),//fsm
			
			.reg_o (reg_index_sorted_2_FB)
);		
		
		
ss_adder #(
			  .N_SIZE(N_SIZE) 
		) 
		
		U103(
			.x_i	(reg_ss_2_FB),//feedback 
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}), //1
			
			.result_o	(ss_2_reg)
);		
		
Reg_ss #(
			  .N_SIZE(N_SIZE) 
		) 

		U104(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(ss_2_reg),
			.En	(ss_en_2_FSM),//FSM
			.Clr	(ss_clr_2_FSM),//FSM
			
			.reg_o (reg_ss_2_FB)
);		

	
Comp_ss #(
			  .N_SIZE(N_SIZE) 
		) 
		
		U105(
			.Comp_x_i	(reg_ss_2_FB),//SS
			.Comp_y_i	(reg_2_sFB),//S
			
			.Comp_o	(COMP_ss_2_FSM) //fsm
		
);

	
s_adder #(
			  .N_SIZE(N_SIZE) 
		) 
		
		U106(
			.x_i	(reg_2_sFB),//feedback
			.y_i	({{(N_SIZE-1){1'b0}},1'b1}), //1
			
			.result_o	(s_2_reg)
);	


Reg_s #(
			  .N_SIZE(N_SIZE) 
		) 

		U107(
			.clk	(clk),
			.rstn	(rstn),
			.reg_i	(s_2_reg),
			.En	(s_en_2_FSM),
			.Clr	(s_clr_2_FSM),
			
			.reg_o (reg_2_sFB)
);	
	
Comp_s #(
			  .N_SIZE(N_SIZE) 
		) 
		
		U108(
			.Comp_x_i	(reg_2_sFB),//S
			.Comp_y_i	(N_elemnts_i),//N
			
			.Comp_o	(COMP_s_2_FSM)//fsm
		
);


Comp_z #(
			  .ADDR_WIDTH(ADDR_WIDTH),
			  .N_SIZE(N_SIZE) 
		) 
		
		U109(
			.Comp_x_i	(reg_2_OutFB),//Out
			.Comp_y_i	(N_elemnts_i),//N
			
			.Comp_o	(COMP_Z_2_FSM)//fsm
		
);



FSM U110 
	(
		.clk	(clk),
		.rstn	(rstn),
		.start_i	(start),
		.non_zero_iter_COMP_i	(non_zero_iter_COMP_2_FSM),
		.elemnts_iter_COMP_i	(elemnts_iter_COMP_2_FSM),
		.x_d_COMP_i	(x_d_COMP_2_FSM),
		.busy_div_real	(busy_DIV_real_2_FSM),
		.done_div_real	(done_DIV_real_2_FSM),
		.busy_div_imag	(busy_DIV_imag_2_FSM),
		.done_div_imag	(done_DIV_imag_2_FSM),
		.i_COMP_i	(i_COMP_2_FSM),
		.ii_COMP_i	(ii_COMP_2_FSM),
		.iii_COMP_i	(iii_COMP_2_FSM),
		.out_pointer_COMP_i	(out_pointer_COMP_2_FSM),
		.Comp_dd_i	(COMP_dd_2_FSM),
		.Comp_d_i	(COMP_d_2_FSM),
		.Comp_s_i	(COMP_s_2_FSM),
		.Comp_ss_i	(COMP_ss_2_FSM),
		.Comp_z_i	(COMP_Z_2_FSM),
		
		.busy	(busy),
		.done	(done),
		.Reg_non_zero_clr	(non_zero_clr_2_FSM),
		.Reg_non_zero_en	(non_zero_en_2_FSM),
		.Reg_regresive_count_clr	(regresive_count_clr_2_FSM),
		.Reg_regresive_count_en	(regresive_count_en_2_FSM),
		.Reg_non_zero_iter_en	(non_zero_iter_en_2_FSM),
		.Reg_non_zero_iter_clr	(non_zero_iter_clr_2_FSM),
		.Reg_count_elemnts_en	(count_elemnts_en_2_FSM),
		.Reg_count_elemnts_clr	(count_elemnts_clr_2_FSM),
		.Reg_elemnts_iter_en	(elemnts_iter_en_2_FSM),
		.Reg_elemnts_iter_clr	(elemnts_iter_clr_2_FSM),
		.Reg_cont2_en	(cont2_en_2_FSM),
		.Reg_cont2_clr	(cont2_clr_2_FSM),
		.Reg_count_N_en	(count_N_en_2_FSM),
		.Reg_count_N_clr	(count_N_clr_2_FSM),
		.Reg_count_N_clr2	(count_N_clr2_2_FSM),
		.Reg_val_d_en	(val_d_en_2_FSM),
		.Reg_val_d_clr	(val_d_clr_2_FSM),
		.mux_U26_sel	(mux_U26_2_FSM),
		.mux_U27_sel	(mux_U27_2_FSM),
		.mux_U28_sel	(mux_U28_2_FSM),
		.Reg_x_d_en	(x_d_en_2_FSM),
		.Reg_x_d_clr	(x_d_clr_2_FSM),
		.Reg_aux_real_en	(aux_real_en_2_FSM),
		.Reg_aux_real_clr	(aux_real_clr_2_FSM),
		.Reg_aux_imag_en	(aux_imag_en_2_FSM),
		.Reg_aux_imag_clr	(aux_imag_clr_2_FSM),
		.Reg_aux_count_en	(aux_count_en_2_FSM),
		.Reg_aux_count_clr	(aux_count_clr_2_FSM),
		.mux_U37_sel	(mux_37_2_FSM),
		.mux_U39_sel	(mux_U39_2_FSM),
		.start_div_real_o	(start_DIV_real_2_FSM),
		.reset_div_real_o	(rstn_div_real),
		.start_div_imag_o	(start_DIV_imag_2_FSM),
		.reset_div_imag_o	(rstn_div_imag),
		.Reg_multi_add_real_en	(multi_add_real_en_2_FSM),
		.Reg_multi_add_real_clr	(multi_add_real_clr_2_FSM),
		.Reg_multi_add_imag_en	(multi_add_imag_en_2_FSM),
		.Reg_multi_add_imag_clr	(multi_add_imag_clr_2_FSM),
		.Reg_i_en	(i_en_2_FSM),
		.Reg_i_clr	(i_clr_2_FSM),
		.Reg_ii_en	(ii_en_2_FSM),
		.Reg_ii_clr	(ii_clr_2_FSM),
		.Reg_iii_en	(iii_en_2_FSM),
		.Reg_iii_clr	(iii_clr_2_FSM),
		.Reg_temp2_en	(temp2_en_2_FSM),
		.Reg_temp2_clr(temp2_clr_2_FSM),
		.Reg_temp3_en	(temp3_en_2_FSM),
		.Reg_temp3_clr	(temp3_clr_2_FSM),
		.Reg_count_acumm_en	(count_acumm_en_2_FSM),
		.Reg_count_acumm_clr	(count_acumm_clr_2_FSM),
		.Reg_count_acumm2_en	(count_acumm2_en_2_FSM),
		.Reg_count_acumm2_clr	(count_acumm2_clr_2_FSM),
		.Reg_C_en	(C_en_2_FSM),
		.Reg_C_clr	(C_clr_2_FSM),
		.Reg_count2_en	(count2_en_2_FSM),
		.Reg_count2_clr	(count2_clr_2_FSM),
		.mux_U70_sel	(mux_U70_2_FSM),
		.Reg_count_diag_en	(count_diag_en_2_FSM),
		.Reg_count_diag_clr	(count_diag_clr_2_FSM),
		.mux_3_1_U73_sel	(mux_U73_2_FSM),
		.Reg_aux_count2_en	(aux_count2_en_2_FSM),
		.Reg_aux_count2_clr	(aux_count2_clr_2_FSM),
		.Reg_aux_count3_en	(aux_count3_en_2_FSM),
		.Reg_aux_count3_clr	(aux_count3_clr_2_FSM),
		.mux_3_1_U80_sel	(mux_U80_2_FSM),
		.mux_U82_sel	(mux_U82_2_FSM),
		.mux_3_1_U83_sel	(mux_U83_2_FSM),
		.mux_U84_sel	(mux_U84_2_FSM),
		.WE_elemnts	(WE_elemnts_2_FSM),
		.WE_R2	(R_Vec2_WE_2_FSM),
		.WE_diagonal	(diag_WE_2_FSM),
		.WE_r	(R_INV_WE_2_FSM),
		.WE	(WE),
		.Reg_dd_en	(dd_En_2_FSM),
		.Reg_dd_clr	(dd_Clr_2_FSM),
		.Reg_d_en	(d_En_2_FSM),
		.Reg_d_clr	(d_Clr_2_FSM),
		.Reg_C2_en	(C2_En_2_FSM),
		.Reg_C2_clr	(C2_Clr_2_FSM),
		.mux_U90_sel	(mux_U90_sel),
		.Reg_Out_en	(Out_En_2_FSM),
		.Reg_Out_clr	(Out_Clr_2_FSM),
		.mux_U96_sel	(mux_U96_sel_2_FSM),
		.mux_U97_sel	(mux_U97_sel_2_FSM),
		.mux_U98_sel	(mux_U98_sel_2_FSM),
		.Reg_index_r_en	(Reg_index_r_en_2_FSM),
		.Reg_index_r_clr	(Reg_index_r_clr_2_FSM),
		.Reg_index_r_sorted_en	(Reg_index_r_sorted_en_2_FSM),
		.Reg_index_r_sorted_clr	(Reg_index_r_sorted_clr_2_FSM),
		.Reg_ss_en	(ss_en_2_FSM),
		.Reg_ss_clr	(ss_clr_2_FSM),
		.Reg_s_en	(s_en_2_FSM),
		.Reg_s_clr	(s_clr_2_FSM)
		
);	


//Direct Assignments 
assign r_inv_data_i_wire = {mux_real_2_mem,mux_imag_2_mem};//Real/Imag
assign r_real_2_oper = r_inv_data_o[(2*DATA_WIDTH_CMPLX)-1:DATA_WIDTH_CMPLX];//[31:16] Real
assign r_imag_2_oper = r_inv_data_o[DATA_WIDTH_CMPLX-1:0];//[15:0] Imag
assign R_mem_read_addr_o = mux_2_R_read_addr;
assign r_mem_write_addr_o = mux_2_write_addr_o;



//assign Start_signal_real = (start_div_real != start_DIV_real_2_FSM)? 1'b1:1'b0;
//assign Start_signal_imag = (start_div_imag != start_DIV_imag_2_FSM)? 1'b1:1'b0;

//assign Start_r = Start_signal_real & delay;
//assign Start_imag = Start_signal_imag & delay2;

//other logic one shot
//real

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
		  start_div_real <= 1'b0;
        aux_signal <= 1'b0;
    end 
	 else begin
		if (start_DIV_real_2_FSM && !aux_signal) begin
			start_div_real <= 1'b1;
		end 
		else begin
			start_div_real <= 1'b0;
		end
		aux_signal <= start_DIV_real_2_FSM;
	 end
end

//Imag
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
		  start_div_imag <= 1'b0;
        aux_signal2 <= 1'b0;
    end 
	 else begin
		if (start_DIV_imag_2_FSM && !aux_signal2) begin
			start_div_imag <= 1'b1;
		end 
		else begin
			start_div_imag <= 1'b0;
		end
		aux_signal2 <= start_DIV_imag_2_FSM;
	 end
end

	
endmodule
