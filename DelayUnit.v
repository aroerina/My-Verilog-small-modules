//////////////////////////////////////////////////////
//”Ä—p’x‰„‘fŽq
/* Portlist
 DelayUnit #(.w_data(),.delay()) 
 d(.Clock(Clock),.Reset(Reset),.i_DATA(),.o_DATA());
 
*/
module DelayUnit #(
   	parameter w_data  =  1, // Data bit width
   	parameter delay =  1	// Total delay value
)
(
   input Clock,Reset,
   input [w_data-1:0]   i_DATA,
   output [w_data-1:0] o_DATA
  );
 
	//////////////////////////////////////////////////////
	// Register 
  	reg    [w_data-1:0]   delay_buff[delay-1:0];
 
	//////////////////////////////////////////////////////
	// Wire   
    assign o_DATA = delay_buff[delay-1];
	
   integer i;
	always@( posedge Clock or posedge Reset) begin
		if(Reset) begin
			for(i=1;i<= (delay-1);i=i+1) begin
				delay_buff[i] <= 0;
			end
		end else begin
         delay_buff[0] <= i_DATA;
			for(i=1;i<= (delay-1);i=i+1) begin
				delay_buff[i] <= delay_buff[i-1];
			end
      end
   end
endmodule
