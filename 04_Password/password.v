module password (
	input clk,rst,
	input [9:0] comb_in_so,
	output [9:0] states,
	output [6:0] d0,d1,d2,d3,d4
	);
	
	wire [9:0] comb_in;
	wire correct,error;
	wire clkdivided;
	
	clkdiv #(.FREQ(10)) CLKDIVIDER (
		.clk(clk),
		.rst(rst),
		.clk_div(clkdivided)
	);
	
	genvar i;
	generate
		for (i=0;i<10;i=i+1)
			begin: oneShotInst
			one_shot U (
				.clk(clkdivided),
				.signal(comb_in_so[i]),
				.oneshot_out(comb_in[i])
			);
			end
	endgenerate
	
	pwFSM PW (
		.clk(clkdivided),
		.rst(rst),
		.comb_in(comb_in),
		.correct(correct),
		.error(error),
		.states(states),
		.d0(d0),
		.d1(d1),
		.d2(d2),
		.d3(d3),
		.d4(d4)
	 );
	 
endmodule