///////////////////////////////////
//ドット無し７セグLEDドライバ
//

//0 = 点灯　1 = 消灯
`define _9	7'b0010000
`define _8	7'b0000000
`define _7	7'b1011000
`define _6	7'b0000010
`define _5	7'b0010010
`define _4	7'b0011001
`define _3	7'b0110000
`define _2	7'b0100100
`define _1	7'b1111001
`define _0	7'b1000000
`define _A	7'b0001000
`define _B	7'b0000011
`define _C	7'b0100111
`define _D	7'b0100001
`define _E	7'b0000110
`define _F	7'b0001110

//Port list
//SegmentDecoder sd(.Value(),.dg1(),.dg2(),.dg3(),.dg4())

module SegmentDecoder
(
	input [15:0] Value,
	output [6:0] dg1,dg2,dg3,dg4
);

	assign dg1 =	num(Value [3:0]	);
	assign dg2 = 	num(Value [7:4]	);
	assign dg3 = 	num(Value [11:8]);
	assign dg4 = 	num(Value [15:12]);
	
	
	function [6:0] num(input [3:0] cnt);
		begin
			case(cnt)
				0:num = `_0;
				1:num = `_1;
				2:num = `_2;
				3:num = `_3;
				4:num = `_4;
				5:num = `_5;
				6:num = `_6;
				7:num = `_7;
				8:num = `_8;
				9:num = `_9;
				10:num = `_A;
				11:num = `_B;
				12:num = `_C;
				13:num = `_D;
				14:num = `_E;
				15:num = `_F;
			endcase
		end
	endfunction
	

endmodule