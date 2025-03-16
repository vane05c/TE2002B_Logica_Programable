module debouncer2 (
    input pb1,
	 input clk,
    input rst, // Reset
    output pb_out
);

    wire Q0, Q1, Q2, Q2_bar,slow_clk;
	 
	 clkdiv #(.FREQ(20)) u1(
		.clk(clk),
		.rst(rst),
		.clk_div(slow_clk)
		);

    // Flip-flops
    d_ff d0 (slow_clk, pb1, Q0);
    d_ff d1 (slow_clk, Q0, Q1);
    d_ff d2 (slow_clk, Q1, Q2);
    
    assign Q2_bar = ~Q2;
    assign pb_out = Q1 & Q2_bar;

endmodule