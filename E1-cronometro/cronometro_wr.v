module cronometro_wr (
	input MAX10_CLK1_50,
	input [1:0] KEY,
	input [9:0] SW,
	output [0:6] HEX3,
	output [0:6] HEX0,HEX1,HEX2,HEX4,HEX5
);

	cronometro WR (
		.clk(MAX10_CLK1_50),
		.rst(KEY[0]),
		.enable(SW[0]),
		.d0(HEX0),
		.d1(HEX1),
		.d2(HEX2),
		.d3(HEX3),
		.d4(HEX4),
		.d5(HEX5)
	);

endmodule