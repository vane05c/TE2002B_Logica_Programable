module debouncerCclkdiv (
	input pb1,clk,rst,
	output pbout
);

	wire Q0,Q1,Q2,Q2_bar,slow_clk;

	// reducir el reloj
	clkdiv #(.FREQ(20)) u1 (
		.clk(clk),
		.rst(rst),
		.clk_div(slow_clk)
	);
	
	// flip flops
	d_ff d0 (
		.slow_clk(slow_clk),
		.D(pb1),
		.Q(Q0)
	);
	
	d_ff d1 (
		.slow_clk(slow_clk),
		.D(Q0),
		.Q(Q1)
	);
	
	d_ff d2 (
		.slow_clk(slow_clk),
		.D(Q1),
		.Q(Q2)
	);
	
	assign Q2_bar=~Q2;
	assign pbout=Q1&Q2_bar;

endmodule