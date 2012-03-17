////////////////////////////////////////////////////
//加減算器 Carryを別ポートに分ける 出力レジスタ
//SubEn = 0: A+B
//SubEn = 1: A-B

/* Portlist
	AddSub #(.width()) as(.SubEn(),.A(),.B(),.S(),.Carry());
*/

module AddSubC
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter width = 4 //input bit width
)
(	
	////////////////////////////////////////////////////
	// Ports 
	input SubEn,	//Subustractor Enable
	input [width-1:0]	A,B,
	output reg [width-1:0]	S,
	output reg Carry
);

	////////////////////////////////////////////////////
	// Net
	wire [width-1:0]	wFAB;	//Full Adder B input wire
	wire [width:0]		C;		//Carry
	wire [width-1:0]	wS;
	assign C[0]		= SubEn;
	
	generate 
		genvar i;
		for (i=0;i<width;i=i+1) begin :loop
			assign wFAB[i]	= (SubEn) ? ~B[i] : B[i] ;
			FA a(.A(A[i]),.B(wFAB[i]),.Ci(C[i]),.S(wS[i]),.Co(C[i+1]));
		end
	endgenerate
	

	always@(posedge Clock or posedge Reset)begin
		if(Reset)begin
			Carry	<= 1'b0;
			S		<= 0;
		end else begin
			Carry	<= C[width];
			S		<= wS;
		end
	end
endmodule

`ifndef FA
`define FA
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