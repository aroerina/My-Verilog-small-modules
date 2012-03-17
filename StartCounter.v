// Start を入れると桁が溢れるまでカウントするカウンタ
/* Portlist
StartCounter #(.width())
	scounter(
	.Clock(Clock),
	.Reset(Reset),
	.CountEn(),
	.Start(),
	.Count(),
	.End(),
	.Busy()
	);
*/

module StartCounter
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter width = 4
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,CountEn,Start,
	output reg [width-1:0] Count,
	output reg End,Busy
);
	wire [width+1:0] wCount = {Busy,Count} + 1'b1;
	wire wCarry = wCount[width+1];
	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			Count	<= 1'b0;
			Busy	<= 1'b0;
			End		<= 1'b0;
		end else begin		
			if(Start)
				Busy			<= 1'b1;
			else if(Busy && CountEn)
				{Busy,Count}	<= wCount;
				
			End	<= wCarry;
		end
	end
endmodule 