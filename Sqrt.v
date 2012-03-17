// ���������Z��
//���ʂ��o�͂����܂�bw_in/2�N���b�N�K�v
/* Portlist
Sqrt s(.Clock(Clock),.Reset(Reset),.Start(),.Sin(),.Sout(),.Busy(),.End());
*/

module Sqrt #(
	parameter bw_in = 10,	// input bit width
	parameter bw_step = 4	// bw_in/2 �����܂�r�b�g��
) 
(
	input Clock,Reset,Start,
	input [bw_in-1:0] Sin,      // ����
	output reg [bw_in/2-1:0] Sout,     // ���Z���ʏo��
	output reg Busy,
	output reg End
);

	reg [bw_in-1:0]	rSin;
	reg [bw_in/2-1:0]	mod;
	reg [bw_step-1:0]	step;

	wire [1:0] add	= rSin >> ((bw_in-2) - step * 2'd2);	// �~�낵�Ă��鐔�ian �ɑ����j
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
				if({mod, add} >= {Sout, 2'b01}) begin   // ���ɂP�𗧂Ă��邩�H
					Sout<= {Sout, 1'b1};                // �n�j�Ȃ�A���ɂP�𗧂ĂāA
					mod <= {mod, add} - {Sout, 2'b01};  // ���̗]����v�Z
				end
				else begin                  // ���ɂP�������Ȃ��ꍇ
					Sout<= {Sout, 1'b0};    // ���ɂ͂O���Z�b�g���āA
					mod <= {mod, add};      // ���̗]����v�Z
				end
				step	<= step + 1;	// ���̃X�e�b�v��
				Busy	<= wBusy;
			end
			
			if({Busy,wBusy} == 2'b10)
					End <= 1'b1;
				else
					End <= 1'b0;
		end
	end
endmodule
