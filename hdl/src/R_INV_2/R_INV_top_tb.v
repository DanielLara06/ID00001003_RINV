/******************************************************************
*Module name : R_INV_top_tb
*Filename    : R_INV_top_tb.v
*Type        : Verilog Module
*
*Description : Testbench module to test R^-1 core.  
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk"
*	reset		 : sync rstn
* 
*Parameters  : DATA_WIDTH = 32; ADDR_WIDTH = 11; N_SIZE = 6; DATA_WIDTH_CMPLX = 16; elmnts_dif_zero_bits  =   11 
*
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	22/08/2024
******************************************************************/
`timescale 1ns/100ps 

module R_INV_top_tb
#(
    parameter DATA_WIDTH    =   32,     // Datawidth of data
    parameter ADDR_WIDTH    =   11,       // Address bits
	 parameter N_SIZE    =   6,     // Size of the square R matrix bits
    parameter DATA_WIDTH_CMPLX    =   16,       // Datawidth of complex data (Real/Imag)
	 parameter QI = 5, //Integer Part
	 parameter QF = DATA_WIDTH_CMPLX - QI, //Fractional Part (11)
	 parameter elmnts_dif_zero_bits    =   11,       // elements bits
	 parameter R_N_N = 11
)
();

//integer f,x, data, status; //fichero
//integer i, k, j, y, z, ii, fd;
integer ii,fd;

reg clk;
reg rstn;
reg start_tb;
reg [N_SIZE-1:0] N_elemnts_i_tb;
wire [DATA_WIDTH-1:0] R_mem_data_i_tb;

wire  [ADDR_WIDTH:0] R_mem_read_addr_o_tb;//
wire [DATA_WIDTH-1:0] r_inv_data_o_tb;
wire [ADDR_WIDTH:0] r_mem_write_addr_o_tb;
wire WE_tb;
wire busy_tb;
wire done_tb;


//mem i
reg WE_mem_i_i;
reg [ADDR_WIDTH-1:0] mem_i_Write_addres_i; 
reg [DATA_WIDTH-1:0] mem_i_data_input_i;

//mem o 
reg [ADDR_WIDTH:0] mem_o_Read_address_i;
wire [DATA_WIDTH-1:0] mem_o_data_out_o;

//testbench and design instances
R_INV #(
			 .DATA_WIDTH(DATA_WIDTH),    // Datawidth of data
			 .ADDR_WIDTH(ADDR_WIDTH),       // Address bits
			 .N_SIZE(N_SIZE),     // Size of the square R matrix bits
			 .DATA_WIDTH_CMPLX(DATA_WIDTH_CMPLX),       // Datawidth of complex data (Real/Imag)
			 .QI(QI), //Integer Part
			 .QF(QF), //Fractional Part (11)
			 .elmnts_dif_zero_bits(elmnts_dif_zero_bits)      // elements bits
			)
			
		DUT(
			.clk		(clk),
			.rstn		(rstn),
			.start		(start_tb),
			.N_elemnts_i	(N_elemnts_i_tb),
			.R_mem_data_i	(R_mem_data_i_tb),
			
			.R_mem_read_addr_o	(R_mem_read_addr_o_tb),
			.r_inv_data_o	(r_inv_data_o_tb),
			.r_mem_write_addr_o	(r_mem_write_addr_o_tb),
			.WE	(WE_tb),
			.busy	(busy_tb),
			.done	(done_tb)
					
);

simple_dual_port_ram_single_clk_i #(
			  .DATA_WIDTH(DATA_WIDTH),       //memory slot bits *
			  .ADDR_WIDTH(R_N_N)     // Size of the square R matrix bits     
		) //R
		
		
		mem_i (
			.Write_clock__i	(clk),
			.Write_enable_i	(WE_mem_i_i),
			.Write_addres_i	(mem_i_Write_addres_i),
			.Read_address_i	(R_mem_read_addr_o_tb), 
			.data_input___i	(mem_i_data_input_i),
			
			.data_output__o	(R_mem_data_i_tb)
);

simple_dual_port_ram_single_clk_o #(
			  .DATA_WIDTH(DATA_WIDTH),       //memory slot bits *
			  .ADDR_WIDTH(ADDR_WIDTH)     // Size of the square R matrix bits     
		) //R^-1
		
		
		mem_o (
			.Write_clock__i	(clk),
			.Write_enable_i	(WE_tb),
			.Write_addres_i	(r_mem_write_addr_o_tb),
			.Read_address_i	(mem_o_Read_address_i), 
			.data_input___i	(r_inv_data_o_tb),
			
			.data_output__o	(mem_o_data_out_o)
);


initial 
	begin 
		
		//Inicialization process
		clk = 1'b0;
		rstn = 1'b1;
		start_tb = 1'b0;
		N_elemnts_i_tb = 6'b110000;


		
		#10
		rstn = 1'b0;
		#10 // o poner 20
		rstn = 1'b1;
		



		#10 
		start_tb = 1'b1;
		#40 
		start_tb = 1'b0;
	



end


always @(posedge clk) begin
    if(done_tb) begin
        fd = $fopen("R_INV_o.txt","w");
        for(ii=0; ii < 2304; ii = ii+1) begin
            $fdisplay(fd, "%b", mem_o.RAM_Structure[ii]);
        end
        $fclose(fd);
    end
end


	  
   
always #10 clk <= ~clk;

endmodule 