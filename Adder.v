`ifndef ADDER
`define ADDER
////////////////////////////////////////////////////
//Adder

module Adder
////////////////////////////////////////////////////
// Parameters
#(
	parameter width = 4
)
////////////////////////////////////////////////////
// Ports
(
	input [width-1:0]	A,B,
	output [width:0]	S
);

	////////////////////////////////////////////////////
	// Net
	wire [width:0] C;
	assign C[0]		= 1'b0;
	assign S[width]	= C[width];
	
	generate 
		genvar i;
		for (i=0;i<width;i=i+1) begin :loop
			FA a(.A(A[i]),.B(B[i]),.Ci(C[i]),.S(S[i]),.Co(C[i+1]));
		end
	endgenerate
endmodule
`endif

`ifndef FULL_ADDER
`define FULL_ADDER
////////////////////////////////////////////////////
//Full Adder
/* Portlist
	FA _(.A(),.B(),.Ci(),.S(),.Co());
*/
module FA
////////////////////////////////////////////////////
// Ports
(
input A,B,Ci,
output S,Co
);
	wire exAB	= A^B;
	assign S	= exAB^Ci;
	assign Co	= (A&B)|(exAB&Ci);

endmodule
`endif