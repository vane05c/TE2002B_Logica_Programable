module count_bcd #(parameter N=4, N_MAX=5000) (
	input clk,rst,switch_in,load,
	input [3:0] data_in,
	output [6:0] disp_out
);

	wire clkdivided,switchDeb;
	wire [N-1:0] count_top;

	clkdiv CLK_DIVIDER (
		.clk(clk),
		.rst(rst),
		.clk_div(clkdivided)
	);
	
	debouncer #(.N_MAX(N_MAX)) DEBOUNCE (
		.clk(clk),
		.rst_a_p(rst),
		.debouncer_in(switch_in),
		.debouncer_out(switchDeb)
	);
	
	bin_count_load COUNT_UD (
		.count(count_top),
		.data_in(data_in),
		.rst(rst),
		.up_down(switchDeb),
		.load(load),
		.clk(clkdivided)
	);
	
	disp DISPLAY (
		.disp_in(count_top),
		.disp_out(disp_out)
	);

endmodule