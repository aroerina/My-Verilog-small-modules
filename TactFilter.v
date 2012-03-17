//タクト用チャタリングフィルタ
/* Portlist
TactFilter tf(.Clock(Clock),.Reset(Reset),.Tact(),.Out());
*/

module TactFilter
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Tact,
	output reg Out
);

	////////////////////////////////////////////////////
	// Registers
	reg		[7:0] SReg;

	////////////////////////////////////////////////////
	// Net
	wire	FPos	= &SReg;	//SReg == 11111111
	wire	FNeg	= &(~SReg);	//SReg == 00000000	
	
	function FUNC
	(input FPos ,input FNeg, input FBefore);
	begin
		if((!FPos)&&(!FNeg))
			FUNC	= FBefore;
		else if (FPos) 
			FUNC	= 1'b1;
		else
			FUNC	= 1'b0;
	end endfunction
	
	always@(posedge Clock) begin
		if(Reset)begin
			Out		<= 0;
			SReg	<= 0;
		end else begin
			SReg	<= {SReg[6:0],Tact};
			Out		<= FUNC(FPos,FNeg,Out);
		end
	end

endmodule