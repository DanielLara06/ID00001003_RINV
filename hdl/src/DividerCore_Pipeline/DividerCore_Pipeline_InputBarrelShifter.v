
/*****************************************************************

Description: Parametizable Barrel Shifter
			
Parameters:	DATA_WIDTH -> Width of the register (bits)

*****************************************************************/






module DividerCore_Pipeline_InputBarrelShifter #(
	parameter DATA_WIDTH = 16,
	parameter BARREL_SHIFTER_BITS = ceillog2(DATA_WIDTH-1)
)(
	input [BARREL_SHIFTER_BITS-1:0] 	control,
	input [DATA_WIDTH-1:0] 				data_i,

	output [2*DATA_WIDTH-1:0] 			data_o
);
	
	
	wire [2*DATA_WIDTH-1 : 0] barrel_shifter_input_wire;
	wire [2*DATA_WIDTH-1 : 0] barrel_shifter_output;
	
	
	assign barrel_shifter_input_wire = {data_i, {16{1'b0}}};
	
	
	assign barrel_shifter_output = 	(control == 4'b1000) ? {{4{1'b0}}, barrel_shifter_input_wire[2*DATA_WIDTH-1 : 4]} : // 2^4
												(control == 4'b0100) ? {{2{1'b0}}, barrel_shifter_input_wire[2*DATA_WIDTH-1 : 2]} : // 2^2
												(control == 4'b0000) ? barrel_shifter_input_wire :                                  // 2^0
												(control == 4'b1110) ? {barrel_shifter_input_wire[2*DATA_WIDTH-3 : 0], {2{1'b0}}} : // 2^-2
												(control == 4'b1100) ? {barrel_shifter_input_wire[2*DATA_WIDTH-5 : 0], {4{1'b0}}} : // 2^-4
												(control == 4'b1010) ? {barrel_shifter_input_wire[2*DATA_WIDTH-7 : 0], {6{1'b0}}} : // 2^-6
												(control == 4'b1111) ? {barrel_shifter_input_wire[2*DATA_WIDTH-9 : 0], {8{1'b0}}} : // 2^-8
												barrel_shifter_input_wire; 																			// Default case
	
	
	assign data_o = {barrel_shifter_output[2*DATA_WIDTH-3 : 0], {2{1'b0}}};

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





/*****************************************************************

El módulo realiza operaciones de desplazamiento en los datos de 
entrada de ancho DATA_WIDTH basado en un control de entrada de 
ancho BARREL_SHIFTER_BITS, que se calcula mediante la función 
ceillog2. 

Recibe un dato de entrada, lo expande agregando ceros en los bits 
más bajos, y lo desplaza hacia la izquierda o derecha según el 
valor del control. Cada valor del control corresponde a una potencia 
de dos, determinando el número de posiciones por las cuales se 
desplazan los bits de entrada. 

El resultado del desplazamiento se guarda en un registro y se 
asigna a la salida. La salida final se ajusta nuevamente agregando 
ceros en los bits más bajos, asegurando el tamaño adecuado para 
operaciones posteriores.

*****************************************************************/
