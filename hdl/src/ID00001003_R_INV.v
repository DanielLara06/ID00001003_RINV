 /******************************************************************
*Module name : ID00001002_Norm
*Filename    : ID00001002_Norm.v
*Type        : Verilog Module
*
*Description : Top Level Entity for testing the IP Module - Normalizer core.  
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk"
*	reset		 : sync rstn
* 
*Parameters  : none
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	09/01/2025
******************************************************************/
module ID00001003_R_INV(
	 clk,
    rst_a,
    en_s,
    data_in, //different data in information types
    data_out, //different data out information types
    write, //Used for protocol to write different information types
    read, //Used for protocol to read different information types
    start, //Used to start the IP-core
    conf_dbus, //Used for protocol to determine different actions types
    int_req //Interruption request
);

	 localparam DATA_WIDTH = 'd32; //define data length
    localparam MEM_ADDR_MAX_WIDTH = 'd11;//'d16
	 localparam MEM_ADDR_MAX_WIDTH_O = 'd11;//'d16
    localparam ADDR_WIDTH_MEMI = 'd6; //define Memory In depth
    localparam ADDR_WIDTH_MEMO = 'd6; //define Memory Out depth
    localparam SIZE_CR = 'd1; //define Configuration Register depth
    localparam STATUS_WIDTH = 'd8; //define status length
    localparam INT_WIDTH = 'd8; //define status length

    input wire clk;
    input wire rst_a;
    input wire en_s;
    input wire [DATA_WIDTH-1:0] data_in; //different data in information types
    output wire [DATA_WIDTH-1:0] data_out; //different data out information types
    input wire write; //Used for protocol to write different information types
    input wire read; //Used for protocol to read different information types
    input wire start; //Used to start the IP-core
    input wire [4:0] conf_dbus; //Used for protocol to determine different actions types
    output wire int_req; //Interruption request

    wire [DATA_WIDTH-1:0] data_MemIn0; //data readed for memory in 0
    wire [MEM_ADDR_MAX_WIDTH:0] rd_addr_MemIn0; //address read for memory in 0

    wire [DATA_WIDTH-1:0] data_ConfigReg; //data readed for configuration register

    wire [DATA_WIDTH-1:0] data_MemOut0; //data to write for memory out 0
    wire [MEM_ADDR_MAX_WIDTH_O:0] wr_addr_MemOut0; //address write for memory out 0
    wire wr_en_MemOut0; //enable write for memory out 0
	
    wire start_IPcore; //Used to start the IP-core

    wire [STATUS_WIDTH-1:0] status_IPcore; //data of IP-core to set the flags value
    wire [INT_WIDTH-1:0] int_IPcore;
	 
	
	 
	 ID00001003_aip
    INTERFACE
    (
        .clk (clk),
        .rst (rst_a),
        .en (en_s),
			
			 //--- AIP-Interface ---//
        .dataInAIP (data_in),
        .dataOutAIP (data_out),
        .configAIP (conf_dbus),
        .readAIP (read),
        .writeAIP (write),
        .startAIP (start),
        .intAIP (int_req),
		  
		   //--- IP-core ---//
		  .rdDataMemIn_0	(data_MemIn0), //R Data
		  .rdAddrMemIn_0	(rd_addr_MemIn0), //R ADDR 


		  .wrDataMemOut_0	(data_MemOut0), //R_INV Data
		  .wrAddrMemOut_0	(wr_addr_MemOut0), //R_INV Addr
		  
		  .wrEnMemOut_0	(wr_en_MemOut0),

		  .rdDataConfigReg	(data_ConfigReg),
		  
		  .statusIPcore_Busy	(status_IPcore[0]),
		  .intIPCore_Done	(int_IPcore[0]),
		  .startIPcore	(start_IPcore)
    );
	 
	 	 
	R_INV 
		#(
        .DATA_WIDTH ('d32),
        .ADDR_WIDTH ('d11),
        .N_SIZE ('d6),
		  .DATA_WIDTH_CMPLX ('d16),
		  .QI ('d5),
		  .QF ('d16 - 'd5),
		  .elmnts_dif_zero_bits ('d11)
    )

	  DUT (
			.clk		(clk),
			.rstn		(rst_a),
			.start		(start_IPcore),
			.N_elemnts_i	(data_ConfigReg[5:0]),	// Configuration Register
			.R_mem_data_i	(data_MemIn0),

			.R_mem_read_addr_o	(rd_addr_MemIn0),
			.r_inv_data_o	(data_MemOut0),
			.r_mem_write_addr_o	(wr_addr_MemOut0),
			.WE(wr_en_MemOut0),
			.busy	(status_IPcore[0]),
			.done	(int_IPcore[0])
			
			
					
);

//assign data_MemOut0[31:16] = {16{1'b0}};
endmodule