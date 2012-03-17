//任意数の分周器
/* Portlist
	VariClockDivider #(.bw_count()) CD
	(.Clock(Clock),.ClockEn(),.Reset(Reset),.ResetVal(),.OutClock(Clock));
*/

module VariClockDivider
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_count = 5
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,
	input [bw_count-1:0] ResetVal,	//カウンタをリセットする値
	output reg OutClock
);

	////////////////////////////////////////////////////
	// Registers
	reg [bw_count-1:0]	Count,rResetVal;

	////////////////////////////////////////////////////
	// Net
	
	always@(posedge Clock or posedge Reset) begin
		if( Reset )begin
			Count		<= 0;
			OutClock	<= 0;
			rResetVal	<= 0;
		end else
		if(Clock)begin
			rResetVal	<= ResetVal;
			if( Count >= rResetVal ) begin
				Count		<= 1;
				OutClock	<= ~OutClock;
			end else begin
				Count		<= Count + 1;
			end
		end
	end

endmodule