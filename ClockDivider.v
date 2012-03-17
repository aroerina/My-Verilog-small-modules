//ƒNƒƒbƒN•ªüŠí
/* Portlist
	ClockDivider #(.bw_Count) cd
	(.InClock(Clock),.Reset(Reset),.OutClock(Clock));
*/

module ClockDivider
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_Count = 8
)
(
	////////////////////////////////////////////////////
	// Ports
	input InClock,Reset,
	output OutClock
);

	////////////////////////////////////////////////////
	// Registers
	reg [bw_Count-1:0] Count;
	
	////////////////////////////////////////////////////
	// Assign
	assign	OutClock	= Count[bw_Count-1]; 
	
	always@(posedge InClock or posedge Reset) begin
		if(Reset) begin
			Count	<= 0;
		end else
		if(InClock)begin
			Count	<= Count + 1;
		end
	end

endmodule 