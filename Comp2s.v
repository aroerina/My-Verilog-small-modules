q;//ÇQÇÃï‚êîäÌ
/* Portlist
	Comp2s #(.width()) _(.IN(),.OUT());
*/
`ifndef COMP2S
`define COMP2S

module Comp2s
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter width = 4 //input bit width
)
(	
	////////////////////////////////////////////////////
	// Ports 
	input [width-1:0]	IN,
	output [width-1:0]	OUT
);

	////////////////////////////////////////////////////
	// Net
	wire [width-2:0]		C;		//Carry
	
	//MSBÇ∆LSBÇÃèàóù
	assign OUT[0]	= IN[0];	//LSB
	assign C[0]		= ~IN[0];
	assign OUT[width-1]	= (~IN[width-1]) ^ C[width-2];	//MSB
	
	generate 
		genvar i;
		for (i=1;i<(width-1);i=i+1) begin :generate_Comp2s
			HA a(.A(~IN[i]),.B(C[i-1]),.S(OUT[i]),.Co(C[i]));
		end
	endgenerate
endmodule
`endif

`ifndef HA
`define HA
/////////////////////////////////////////////////////
//Half Adder
/* Portlist
	HA _(.A(),.B(),.S(),.Co());
*/
module HA
(
input A,B,
output S,Co
);
	assign S	= A^B;
	assign Co	= A&B;
endmodule 
`endif