//4:1 MUX
/* Portlist
MUX4 #(.bw_in()) _
(
.Clock(Clock),.Reset(Reset)
.Select(),.IN0(),.IN1(),.IN2(),.IN3(),.OUT());
*/
//Output Register
module MUX4
#(parameter bw_in = 4) //input bit width
(
input Clock,Reset,
input [1:0] Select,
input [bw_in-1:0] IN0,IN1,IN2,IN3,
output reg [bw_in-1:0] OUT
);
	
	always@(posedge Clock or posedge Reset)
		if(Reset)
			OUT	<= 1'b0;
		else
			case(Select)
				0: OUT <= IN0;
				1: OUT <= IN1;
				2: OUT <= IN2;
				3: OUT <= IN3;
			endcase
		
endmodule
