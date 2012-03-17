
////////////////////////////////////////////////////
// Increment or Decrement
/*
Inc_Dec #(.width()) id(.DecEn(),.A(),.S());
*/

module Inc_Dec
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter width = 4	//input bit width
)
(	
	////////////////////////////////////////////////////
	// Ports 
	input DecEn,		//decrement enable
	input [width-1:0]	A,
	output [width-1:0]	S
);

	////////////////////////////////////////////////////
	// Net
	wire [width-2:0] C;
	assign C[0] = A[0];
	assign S[0]	= ~A[0];									//S[LSB] =
	assign S[width-1] = (C[width-2] ^ DecEn) ^ A [width-1];	//S[MSB] =
	generate 
		genvar i;
		for ( i=1 ; i < (width-1) ; i=i+1) begin :incdec
			FA fa(.A(A[i]),.B(DecEn),.Ci(C[i-1]),.S(S[i]),.Co(C[i]));
		end
	endgenerate
endmodule

/////////////////////////////////////////////////////////////////////////
//Full Adder
/* Portlist
	FA _(.A(),.B(),.Ci(),.S(),.Co());
*/
`ifndef FA
`define FA
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