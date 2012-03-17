// 平方根演算器
//結果が出力されるまでbw_in/2クロック必要
/* Portlist
Sqrt s(.Clock(Clock),.Reset(Reset),.Start(),.Sin(),.Sout(),.Busy(),.End());
*/

module Sqrt #(
	parameter bw_in = 10,	// input bit width
	parameter bw_step = 4	// bw_in/2 が収まるビット幅
) 
(
	input Clock,Reset,Start,
	input [bw_in-1:0] Sin,      // 入力
	output reg [bw_in/2-1:0] Sout,     // 演算結果出力
	output reg Busy,
	output reg End
);

	reg [bw_in-1:0]	rSin;
	reg [bw_in/2-1:0]	mod;
	reg [bw_step-1:0]	step;

	wire [1:0] add	= rSin >> ((bw_in-2) - step * 2'd2);	// 降ろしてくる数（an に相当）
	wire wBusy		= (step < (bw_in/2-1));

	always @(posedge Clock or posedge Reset) begin
		if(Reset)begin	//Reset
			Sout	<= 1'b0;
			mod		<= 1'b0;
			step	<= 1'b0;
			rSin	<= 1'b0;
			Busy	<= 1'b0;
		end else begin	//Clock
			if(Start)begin
				Sout	<= 1'b0;
				mod		<= 1'b0;
				step	<= 1'b0;	
				rSin	<= Sin;
				Busy	<= 1'b1;
			end else
			if(Busy) begin
				if({mod, add} >= {Sout, 2'b01}) begin   // 解に１を立てられるか？
					Sout<= {Sout, 1'b1};                // ＯＫなら、解に１を立てて、
					mod <= {mod, add} - {Sout, 2'b01};  // 次の余りを計算
				end
				else begin                  // 解に１が立たない場合
					Sout<= {Sout, 1'b0};    // 解には０をセットして、
					mod <= {mod, add};      // 次の余りを計算
				end
				step	<= step + 1;	// 次のステップへ
				Busy	<= wBusy;
			end
			
			if({Busy,wBusy} == 2'b10)
					End <= 1'b1;
				else
					End <= 1'b0;
		end
	end
endmodule
