module password_wr (
	input MAX10_CLK1_50,
	input [1:0] KEY,
	input [9:0] SW,
	output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,
	output [9:0] LEDR
);

	password PW_WR(
		.clk(MAX10_CLK1_50),
		.rst(KEY[0]),
		.comb_in_so(SW),
		.d0(HEX0),
		.d1(HEX1),
		.d2(HEX2),
		.d3(HEX3),
		.d4(HEX4),
		.states(LEDR)
	);
	
endmodule