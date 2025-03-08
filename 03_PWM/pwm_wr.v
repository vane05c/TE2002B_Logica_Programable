module pwm_wr (
	input [1:0] KEY,
	input MAX10_CLK1_50,
	input [9:0] SW,
	output [35:0] GPIO
);

	pwm PWM (
		.pb_inc(KEY[0]),
		.pb_dec(KEY[1]),
		.clk(MAX10_CLK1_50),
		.rst(SW[0]),
		.pwm_out(GPIO[8])
	);

endmodule