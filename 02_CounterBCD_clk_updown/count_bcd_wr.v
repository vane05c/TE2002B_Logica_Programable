module count_bcd_wr #(parameter N=4, N_MAX=5000) (
	input MAX10_CLK1_50,
	input [9:0] SW,
	output [0:6] HEX0
);

	count_bcd #(.N(N), .N_MAX(N_MAX)) (
		.clk(MAX10_CLK1_50),
		.rst(SW[1]),
		.switch_in(SW[0]),
		.load(SW[5]),
		.data_in(SW[9:6]),
		.disp_out(HEX0),
	);

endmodule