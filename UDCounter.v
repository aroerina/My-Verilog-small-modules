////////////////////////////////////////////////////
// Up-Down Counter
// 出力レジスタ
/*	Port list
UDCounter #(.width()) 
	udcounter (.Clock(Clock),.Reset(Reset),.ClockEn(),.SClear(),.DownEn(),.Count());
*/

module UDCounter
#(
	////////////////////////////////////////////////////
	// ParameteCount
	parameter width = 4,			//input bit width
	parameter val_preset = 1'b0		//Preset Value
)
(	
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,CountEn,SClear,	// 同期クリア
	input DownEn,		//decrement enable
	output reg [width-1:0]	Count
);

	////////////////////////////////////////////////////
	// Net
	wire [width-2:0]	C;
	wire [width-1:0]	wS;
	assign C[0] 	= Count[0];
	assign wS[0]	= ~Count[0];									//S[LSB] =
	assign wS[width-1] = (C[width-2] ^ DownEn) ^ Count [width-1];	//S[MSB] =
	generate 
		genvar i;
		for ( i=1 ; i < (width-1) ; i=i+1) begin :incdec
			FA fa(.A(Count[i]),.B(DownEn),.Ci(C[i-1]),.S(wS[i]),.Co(C[i]));
		end
	endgenerate
	
	always@(posedge Clock ,posedge Reset) begin
		if(Reset) begin
			Count	<= val_preset;
		end else begin 
			if(SClear)
				Count	<= val_preset;
			else if(CountEn)
				Count	<= wS;
		end
	end
endmodule
`ifndef FA
`define FA
/////////////////////////////////////////////////////////////////////////
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