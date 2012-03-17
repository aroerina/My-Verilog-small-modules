//Pipeline Register
/* Portlist
PipeReg #(.b_width(),.depth()) preg
	(.Clock(Clock),.Reset(Reset),.ClockEn(),.In(),.Out());
*/

module PipeReg
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter b_width = 4,
	parameter depth = 4
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,ClockEn,
	input [b_width-1:0] In,
	output [b_width-1:0] Out
);
	////////////////////////////////////////////////////
	// Net
	wire [b_width-1:0] wQ [0:depth];
	assign wQ[0]	= In;
	assign Out		= wQ[depth];
	
	////////////////////////////////////////////////////
	// Instantiation(s)

	generate 
		genvar i;
		for (i=0;i<depth;i=i+1) begin :df
			DF #(.b_width(b_width)) 
			dflip(.Clock(Clock),.ClockEn(ClockEn),.Reset(Reset),.D(wQ[i]),.Q(wQ[i+1]));
		end
	endgenerate
endmodule 

// D-FlipFlop
`ifndef DF
`define DF
module DF #(
	parameter b_width = 4
)
(
	input Clock,ClockEn,Reset,
	input [b_width-1:0] D,
	output reg [b_width-1:0] Q
);
	always@(posedge Reset or posedge Clock) begin
		if(Reset)
			Q	<= 1'b0;
		else if(ClockEn)
			Q	<= D;
	end	
endmodule 
`endif