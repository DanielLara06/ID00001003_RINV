
/*****************************************************************

Description: Parametizable Encoder
			
Parameters:	DATA_WIDTH -> Width of the register (bits)

*****************************************************************/






module DividerCore_Pipeline_Encoder #(
	parameter DATA_WIDTH = 16,
	parameter ENCODER_BITS = ceillog2(DATA_WIDTH-1)
)(
	input  [DATA_WIDTH-1 : 0]   data_i,

	output [ENCODER_BITS-1 : 0] data_o
);
	
	assign data_o =  (data_i[15] | data_i[14])? 4'b1000 : // 2^4
                    (data_i[13] | data_i[12])? 4'b0100 : // 2^2
                    (data_i[11] | data_i[10])? 4'b0000 : // Center of fixed-point word
                    (data_i[9]  | data_i[8])?  4'b1110 : // 2^-2
                    (data_i[7]  | data_i[6])?  4'b1100 : // 2^-4
                    (data_i[5]  | data_i[4])?  4'b1010 : // 2^-6
                    (data_i[3]  | data_i[2])?  4'b1111 : // 2^-8
															  4'b0000;  // Default case
	
	/*----------------------------------------------------------------------------------------*/
	//log function*/
	
	function integer ceillog2;
		input integer data;
		integer i,result;
		
		begin
			for(i = 0; 2**i <= data; i = i + 1)
				result = i + 1;
				
			ceillog2 = result;
		end
		
	endfunction
		 
	/*----------------------------------------------------------------------------------------*/

endmodule





/*****************************************************************

Este módulo selecciona el rango adecuado al realizar una operación 
de raíz cuadrada recíproca con escalado. 

Implementa un codificador que toma una entrada de ancho especificado 
por DATA_WIDTH y produce una salida de ancho determinado por la 
función ceillog2. 

La entrada se clasifica en diferentes rangos de bits utilizando 
una instrucción casex, y según el rango en el que se encuentre, 
se asigna un valor codificado específico a la salida. Estos valores 
codificados representan exponentes en una base de dos, con un 
enfoque particular en las potencias de dos y los puntos fijos 
en el rango de valores. 

El resultado codificado se almacena en un registro y se asigna 
a la salida del codificador.

*****************************************************************/