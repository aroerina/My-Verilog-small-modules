//LED“_–Å

module LED_Flicker
#(parameter bw_cntr = 24)	//Counter Bit Width
(
input Clock,Reset,
output LED_OUT
);
	
	reg [bw_cntr-1:0] rCNTR;
	assign LED_OUT = rCNTR[bw_cntr-1];
	always@(posedge Clock or posedge Reset )begin
		if(Reset) begin
			rCNTR	<= 0;
		end	else begin
			rCNTR	<= rCNTR + 1;
		end
	end
endmodule 