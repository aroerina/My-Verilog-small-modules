//直列入力並列出力シフトレジスタ
/* Portlist
	Siftreg #(.bw_OutData()) s
	(.Clock(Clock),.ClockEn(),.Reset(Reset),.InData(),.OutData());
*/

module ShiftReg
////////////////////////////////////////////////////
// Parameters
#(
parameter bw_OutData = 24
)
////////////////////////////////////////////////////
// Ports
(
input Clock,ClockEn,Reset,InData,
output reg [bw_OutData-1:0] OutData
);

	////////////////////////////////////////////////////
	// Registers


	////////////////////////////////////////////////////
	// Net
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			OutData <= 0;
		end else
		if(Clock && ClockEn)begin
			OutData[0] <= InData;
			OutData[bw_OutData-1:1] <= OutData[bw_OutData-2:0];
		end
	end

endmodule 