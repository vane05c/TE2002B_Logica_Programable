module suma (
	input clk,rst,enable,
	input [3:0] targ,
	output [6:0] d0,d1,d2
	);
	
	wire [7:0] sum;
	
	sumFSM FSM (
		.clk(clk),
		.rst(~rst),
		.enable(enable),
		.targ(targ),
		.sum(sum)
	 );
	 
	bcd BCD (
		.binary(sum),
		.disp_uni(d0),
		.disp_dec(d1),
		.disp_cen(d2)
	);
	 
endmodule