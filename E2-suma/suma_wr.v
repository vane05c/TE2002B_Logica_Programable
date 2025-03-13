module suma_wr (
	input MAX10_CLK1_50,
	input [1:0] KEY,
	input [9:0] SW,
	output [0:6] HEX0,HEX1,HEX2
);

	suma WR (
		.clk(MAX10_CLK1_50),
		.rst(KEY[0]),
		.enable(SW[9]),
		.targ(SW[4:0]),
		.d0(HEX0),
		.d1(HEX1),
		.d2(HEX2)
	);
	
endmodule