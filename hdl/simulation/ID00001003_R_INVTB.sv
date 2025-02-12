/*
    1 tab == 4 spaces!
*/

`timescale 1ns/10ps
`define CYCLE  (20) //ns -> 50 MHz (Macro to define clock cycle duration, it must be created before including the simulation library)
`include "./aip_sim_lib.sv"//"./aip_sim_lib.sv"

`define DELAY

module ID00001003_R_INVTB ();
  localparam DATA_WIDTH = 32;
  localparam SIZE_MEM = 'd6;

  reg clk;
  reg rst_a;
  reg en_s;

  reg [DATA_WIDTH-1:0] tb_data;
  reg [DATA_WIDTH-1:0] dataSet [2**SIZE_MEM];

  logic [31:0] pkgTemp [];
  logic [31:0] dataTX [];
  logic [31:0] dataR [];  
  logic [31:0] dataRX [];
  logic [31:0] dataR_INV [];
  logic [7:0] byteTemp [];
  

  aip_if aipCon();  
  assign aipCon.aip_clk = clk;
  
  ID00001003_R_INV
  DUT_TB
  (
    .clk(clk),
    .rst_a(rst_a),
    .en_s(en_s),
    .data_in(aipCon.aip_dataIn),
    .data_out(aipCon.aip_dataOut),
    .write(aipCon.aip_write),
    .read(aipCon.aip_read),
    .start(aipCon.aip_start),
    .conf_dbus(aipCon.aip_config),
    .int_req(aipCon.aip_int)
  );

   initial begin
      clk <= 0;
      forever #(`CYCLE/2) clk = ~clk;
   end

  initial begin
    $timeformat(-9, 0, "ns", 16);

    //-----------------------------------------------------
    //Time-0 initialization
    //All inputs are assigned with nonblocking assignements to avoid time-0 race conditions 
    rst_a <= 0;
    aipCon.aip_dataIn <= 0;
    aipCon.aip_config <= 0;
    aipCon.aip_read   <= 0;
    aipCon.aip_write  <= 0;
    aipCon.aip_start  <= 0;
    en_s <= 0;
    //---------------------------------------------------

    // Wait for global reset to finish
    #10;
    rst_a = 1'b1;
    en_s = 1'b1;
    #10;

    #10; // GET ID
    pkgTemp = new [1];
    $display("%t | TEST - Read ID", $time);
    aipCon.getID(pkgTemp);
    $display("%t | TEST - ID %x", $time, pkgTemp[0]);

    $display("--------------------------------------------------");

    $display("%t | TEST - Enable INT 0", $time);
    aipCon.enableINT(0);

    //for (int i = 0; i < 8; i++) begin
    //  aipCon.enableINT(i);
    //end

    $display("--------------------------------------------------");

    //dataTX = new [64];
    // WRITE MEM IN
	 //H MEM 
	 dataR = new [4096];
	 $readmemb("R1.txt",dataR);
	 
//    for (int idx = 0; idx < 64; idx++) begin
//        dataTX[idx] = $urandom;
//    end

    #2
    $display("%t | TEST - Writem Mem R (0)", $time);
    aipCon.writeMem('d0, dataR, 4096, 0);

    $display("--------------------------------------------------");
	 
    `ifdef DELAY
    pkgTemp = new [1];
    pkgTemp[0] = 32'h00000030; // 1
    $display("%t | TEST - Write Conf Reg", $time);
    aipCon.writeConfReg('d4, pkgTemp, 1, 0);
    `endif // DELAY

    $display("--------------------------------------------------");

    $display("%t | TEST - Start", $time);
    aipCon.start();

    $display("--------------------------------------------------");

    `ifdef DELAY
    pkgTemp = new [1];
    $display("%t | TEST - Read Status", $time);
    aipCon.getStatus(pkgTemp);
    $display("%t | TEST - Status %x", $time, pkgTemp[0]);

    $display("--------------------------------------------------");

    byteTemp = new [1];
    $display("%t | TEST - Get Notifications", $time);
    aipCon.getNotification(byteTemp);
    $display("%t | TEST - Notifications %b", $time, byteTemp[0]);

    $display("--------------------------------------------------");

    byteTemp = new [1]; //Get Done (Polling)
    do begin
      $display("%t | TEST - Get INT", $time);
      aipCon.getINT(byteTemp);
      $display("%t | TEST - %b", $time, byteTemp[0]);
      #20000;
    end
    while (!(byteTemp[0] & 8'b00000001));
    `endif // DELAY
    
    $display("--------------------------------------------------");

    dataR_INV = new [4096];
    $display("%t | TEST - Read Mem R_INV", $time);
    aipCon.readMem('d2, dataR_INV, 4096, 0);
	 
    $display("--------------------------------------------------");

    $display("%t | TEST - Check data", $time);
    //$display("%t | TX\t\t | RX\t\t | Result", $time);
    $display("%t | R_INV | Result", $time);
	 //H_Norm
    for (int i = 0; i < 2304; i++) begin     //compare data with matlab results 
      $display("%d | %32b\t | \t ", i, dataR_INV[i]); //$time %8x
    end

    $writememb("R_INV_1.txt",dataR_INV);
    
    $display("--------------------------------------------------");

//    $display("%t | TEST - Clean INT 0", $time);
//    aipCon.clearINT(0); 
//
//    $display("%t | TEST - Start", $time);
//    aipCon.start();
//
//    $display("%t | TEST - Wait INT", $time);
//    aipCon.waitINT();
//    
//    byteTemp = new [1];
//    aipCon.getINT(byteTemp);
//    $display("%t | TEST - %b", $time, byteTemp[0]);

    $display("--------------------------------------------------");

    $display("%t | TEST - Disable INT 0", $time);
    aipCon.disableINT(0);

    $display("--------------------------------------------------");

    #500;
    $finish;
  end

`ifdef IVERILOG
  initial begin
    $dumpfile("ID00001003_R_INVTB.vcd");
    $dumpvars(0, ID00001003_R_INVTB);

    for (integer index = 0; index < 4096; index = index + 1) begin //64
      $dumpvars(1, ID00001003_R_INVTB.DUT.INTERFACE.AIP.MEMIN[0].genblk1.MEMIN.RAM_Structure[index]);

      $dumpvars(1, ID00001003_R_INVTB.DUT.INTERFACE.AIP.MEMOUT[0].MEMOUT.RAM_Structure[index]);
    end

    $dumpall;
  end
`endif

endmodule
