//���Z��
/* Portlist
Divider #(.bw_Dsor(),.bw_Dend(),.bw_i()) _
	(.Clock(Clock),  .Reset(Reset), .Start(), .Dsor(), .Dend(), .Quo(), .End() ,.Busy());
*/

module Divider
////////////////////////////////////////////////////
// Parameters
#(
	parameter bw_Dsor	= 4,
	parameter bw_Dend	= 7,
	parameter bw_i		= 3		//bw_Dend�����܂�r�b�g�� log2(bw_Dend)
)
////////////////////////////////////////////////////
// Ports
(
	input Clock,Reset,Start,
	input [bw_Dsor-1:0]		Dsor,	//����
	input [bw_Dend-1:0]		Dend,	//�폜��				

	output reg [bw_Dend-1:0]	Quo,	//��
	output reg					Busy,
	output reg					End		//End Pulse
);

	localparam bw_SReg = bw_Dsor + bw_Dend;
	////////////////////////////////////////////////////
	// Registers
	reg [bw_SReg-1:0]	SReg;	//�V�t�g���W�X�^
	reg [bw_Dsor-1:0]	rDsor;
	reg [bw_i-1:0]		i;		//�V�[�P���X����
	reg					rSeqEn;
	
	////////////////////////////////////////////////////
	// Net
	wire [bw_Dsor:0]	wPrem	= SReg[bw_SReg-1:bw_Dend-1];	//�����]
	
	wire [bw_Dsor:0]	SubRem	= wPrem - {1'b0,rDsor};			//���������v�Z
	wire [bw_Dsor-1:0]	MuxOut	= (SubRem[bw_Dsor]) ? SReg[bw_SReg-2:bw_Dend-1] : SubRem [bw_Dsor-1:0];
	wire 				PQuo	= ~SubRem[bw_Dsor];				//������ Part of Quo
	wire wSeqEn	= (i>1'b0);
	
	always@(posedge Clock or posedge Reset) begin
		if(Reset)begin
			{
				SReg,rDsor,i,Quo,End,Busy
			}	<= 1'b0;
		end else begin
		
			if(Start)begin
				rDsor					<= Dsor;
				SReg[bw_SReg-1:bw_Dend]	<= 1'b0;
				SReg[bw_Dend-1:0]		<= Dend;
				i		<= bw_Dend;
				Busy	<= 1'b1;
			end else if(wSeqEn) begin
				SReg	<= {MuxOut,SReg[bw_Dend-2:0],PQuo};
				i 		<= i - 1'b1;
			end else begin
				Quo		<= SReg[bw_Dend-1:0];
			end
			
			rSeqEn	<= wSeqEn;
			if( {rSeqEn,wSeqEn} == 2'b10) begin
				End		<= 1'b1;
				Busy	<= 1'b0;
			end else
				End <= 1'b0;
		end
	end

endmodule