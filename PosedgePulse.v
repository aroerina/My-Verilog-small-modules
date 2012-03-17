//入力信号の上昇端でクロック一位相分のパルスを出力
// Unit of delay : 2
/* Portlist
PosedgePulse ppulse(
		.Clock(Clock),	// i
		.Reset(Reset),	// i
		.InPulse(),		// i
		.OutPulse()		// o
	);
*/

module PosedgePulse
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,InPulse,
	output reg OutPulse
);

	////////////////////////////////////////////////////
	// Registers
	reg rInPulse;
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			OutPulse	<= 1'b0;
			rInPulse	<= 1'b0;
		end else begin
			rInPulse	<= InPulse;
			OutPulse	<= {rInPulse,InPulse} == 2'b01;
		end
	end

endmodule 