module frecuencimetro_wr (
	input MAX10_CLK1_50,
	input [1:0] KEY,
	input [35:0] GPIO,
	output [0:6] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5
);

	frecuencimetro wr (
		.clk(MAX10_CLK1_50),
		.rst(KEY[0]),
		.signal(GPIO[27]),
		.disp0(HEX0),
		.disp1(HEX1),
		.disp2(HEX2),
		.disp3(HEX3),
		.disp4(HEX4),
		.disp5(HEX5)
	);

endmodule