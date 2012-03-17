//�폜���������t��(�Q�̕␔)���Z��
/* Portlist
	SDivider #(.bw_Dsor(),.bw_Dend(),.bw_i()) _
	(.Clock(Clock),  .Reset(Reset), .Start(), .Dsor(), .Dend(), .Quo(), .Busy());
*/

module SDivider
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter bw_Dsor = 4,	//�����Ȃ�
	parameter bw_Dend = 8,	//��������
	parameter bw_i	= 4		//���[�v�񐔂��i�[����reg i�̃r�b�g��
							//���[�v�񐔁�bw_Dend-1
)
(
	////////////////////////////////////////////////////
	// Ports
	input Clock,Reset,Start,
	input [bw_Dsor-1:0]	Dsor,			//����
	input [bw_Dend-1:0]	Dend,			//�폜��

	output reg [bw_Dend-1:0]	Quo,	//��
	output reg Busy
);

	localparam bw_SReg = bw_Dsor + bw_Dend - 1;
	////////////////////////////////////////////////////
	// Registers
	reg [bw_SReg-1:0]	SReg;	//�V�t�g���W�X�^
	reg [bw_Dsor-1:0]	rDsor;
	reg [bw_Dend-1:0]	rDend;
	reg [bw_i-1:0]		i;		//�V�[�P���X����
	reg Loop2;					//�V�[�P���X����
	reg rC2sMuxSel;				//2�̕␔�����MUX���䃌�W�X�^
	
	////////////////////////////////////////////////////
	// Net
	wire [bw_Dsor:0]	wPrem	= SReg[bw_SReg-1:bw_Dend-2];	//�����]
	wire [bw_Dsor:0]	SubRem	= wPrem - {1'b0,rDsor};			//���������v�Z
	wire [bw_Dsor-1:0] MuxOut =
	(SubRem[bw_Dsor]) ? SReg[bw_SReg-2:bw_Dend-2] : SubRem [bw_Dsor-1:0];

	wire PQuo	= ~SubRem[bw_Dsor];								//������ Part of Quo
	wire [bw_Dend-1:0]	wComp2in,wComp2out;						//�Q�̕␔����́A�o�͐�
	
	////////////////////////////////////////////////////
	// Assign
	//Loop2�̎��́@rDend ����ȊO��SReg
	assign wComp2in	= (rC2sMuxSel) ?  {1'b0,SReg[bw_Dend-2:0]} : rDend ;	//�Q�̕␔�����MUX
	wire LoopEn		= (i>0);												//���[�v�����
	
	////////////////////////////////////////////////////
	// Instantiations
	Comp2s #(.width(bw_Dend)) c2(.IN(wComp2in),.OUT(wComp2out));			//�Q�̕␔��

	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin	//Reset
			SReg		<= 1'b0;
			rDsor		<= 1'b0;
			i			<= 1'b0;
			Quo			<= 1'b0;
			rDend		<= 1'b0;
			Busy		<= 1'b0;
			Loop2		<= 1'b0;
			rC2sMuxSel	<= 1'b0;
		end else
		if(Clock)begin	//Clock
			if( Start ) begin			//�P�N���b�N�ڂł�邱��
				SReg[bw_SReg-1:bw_Dend-2]	<= 0 ;
				rDsor	<= Dsor;
				rDend	<= Dend;
				Busy	<= 1'b1;
				i		<= bw_Dend-1;	//���[�v�񐔃Z�b�g
				Loop2	<= 1'b1;
				rC2sMuxSel <= 1'b0;
			end else if( Loop2)  begin	//2�N���b�N�ڂɂ�邱��
				if(rDend[bw_Dend-1]) begin
					SReg[bw_Dend-2:0]	<= {1'b0,wComp2out};	//Dend < 0
				end else begin
					SReg[bw_Dend-2:0]	<= rDend[bw_Dend-2:0];	//Dend > 0
				end
				Loop2	<= 1'b0;
				rC2sMuxSel	<= 1'b1;
			end else if( LoopEn ) begin							//���[�v
				SReg	<= {MuxOut,SReg[bw_Dend-3:0],PQuo};		//�r�b�g�V�t�g
				i 		<= i - 1;
			end else begin	//���Z�I���� �����ϊ�
				Busy	<= 1'b0;
				if(rDend[bw_Dend-1])
					Quo		<= wComp2out;
				else
					Quo		<= {1'b0,SReg[bw_Dend-2:0]};
			end
		end
	end

endmodule 

`ifndef COMP2S
`define COMP2S
/////////////////////////////////////////////////////
//�Q�̕␔��

module Comp2s
#(
	////////////////////////////////////////////////////
	// Parameters
	parameter width = 4 //input bit width
)
(	
	////////////////////////////////////////////////////
	// Ports 
	input [width-1:0]	IN,
	output [width-1:0]	OUT
);

	////////////////////////////////////////////////////
	// Net
	wire [width-2:0]		C;		//Carry
	
	//MSB��LSB�̏���
	assign OUT[0]	= IN[0];	//LSB
	assign C[0]		= ~IN[0];
	assign OUT[width-1]	= (~IN[width-1]) ^ C[width-2];	//MSB
	
	generate 
		genvar i;
		for (i=1;i<(width-1);i=i+1) begin :generate_Comp2s
			HA a(.A(~IN[i]),.B(C[i-1]),.S(OUT[i]),.Co(C[i]));
		end
	endgenerate
endmodule
`endif

`ifndef HALF_ADDER
`define HALF_ADDER
/////////////////////////////////////////////////////
//Half Adder
/* Portlist
	HA _(.A(),.B(),.S(),.Co());
*/
module HA
(
input A,B,
output S,Co
);
	assign S	= A^B;
	assign Co	= A&B;
endmodule 
`endif