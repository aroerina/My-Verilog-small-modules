//n:1 MUX

module MUX
#(
parameter bw_in = 8,	//input bit width
parameter bw_sel = 1,	//selecter bit width
parameter num_inport = 2	//Number of input port
)
(
input [bw_sel-1:0] sel,
input [bw_in-1:0] in [0:num_inport-1],
output [bw_in:0] muxout
);
	generate 
		genvar g;
		for (g=0;g<num_inport;g=g+1) begin :loop
			assign muxout = (sel==g)? in[g] :  32'bz;
		end
	endgenerate
endmodule
