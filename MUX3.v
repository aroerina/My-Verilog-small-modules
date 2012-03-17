//3:1 MUX
/* Portlist
MUX3 #(.bw_in()) _
(.Select(),.IN0(),.IN1(),.IN2(),.OUT());
*/

module MUX3
#(parameter bw_in = 4) //input bit width
(
input [1:0] Select,
input [bw_in-1:0] Select,
output [bw_in-1:0] OUT
);
	function [bw_in-1:0] mux (
	input [1:0] Select,
	input [bw_in-1:0] IN0,IN1,IN2);
		case(Select)
			0: mux = IN0;
			1: mux = IN1;
			2: mux = IN2;
			default:
				mux = 'bz;
		endcase
	endfunction
	
	assign OUT = mux(Select,IN0,IN1,IN2);
endmodule
