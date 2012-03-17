//
//		•‰’l‚Ì•\Œ»•û–@‚ð•ÏŠ·
//	
/* Portlist
OneBitSigned #(.width()) obs (
		.Clock(Clock),
		.Reset(Reset),
		.In(),
		.Out()
	);
*/

module OneBitSigned
#(
	parameter width = 4
)
(
	input Clock,Reset,
	input [width-1:0] In,
	output reg [width-1:0] Out
);

	always@(posedge Reset or posedge Clock) begin
		if(Reset)begin
			Out		<= 1'b0;
		end else begin
			Out[width-1] 	<= In[width-1];
			
			if(In[width-1] == 1'b1)
				Out[width-2:0]		<= (~In[width-2:0])+1'b1;
			else
				Out[width-2:0]		<= In[width-2:0];
		end
	end

endmodule 