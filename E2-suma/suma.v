module suma (
	input clk,rst,enable,
	input [4:0] targ,
	//output [9:0] states,
	output [6:0] d0,d1,d2//,d3,d4
	);
	
	//wire [4:0] targ;
	wire [7:0] sum;
	//wire clkdivided;
	
	/*clkdiv #(.FREQ(1)) CLKDIVIDER (
		.clk(clk),
		.rst(rst),
		.clk_div(clkdivided)
	);*/
	
	/*genvar i;
	generate
		for (i=0;i<5;i=i+1)
			begin: oneShotInst
			one_shot U (
				.clk(clkdivided),
				.signal(comb_so[i]),
				.oneshot_out(comb[i])
			);
			end
	endgenerate*/
	//assign targ=comb_so;
	
	sumFSM FSM (
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.targ(targ),
		.sum(sum),
	 );
	 
	bcd BCD (
		.binary(sum),
		.disp_uni(d0),
		.disp_dec(d1),
		.disp_cen(d2)
	);
	 
endmodule