module cronometro (
	input clk,rst,enable,
	output [6:0] d0,d1,d2,d3,d4,d5
);

	wire [9:0] ms;
	wire [6:0] s,cen;
	wire clkdivided;
	
	assign d3='b11111110;
	
	clkdiv #(.FREQ(1_000)) CLKDIV (
		.clk(clk),
		.rst(rst),
		.clk_div(clkdivided)
	);

	counter COUNT (
		.clk(clkdivided),
		.rst(rst),
		.enable(enable),
		.ms(ms),
		.s(s)
	);
	
	bcd MS (
		.binary(ms),
		.disp_uni(d0),
		.disp_dec(d1),
		.disp_cen(d2),
		//.disp_mil(d3)
	);
	
	bcd S (
		.binary(s),
		.disp_uni(d4),
		.disp_dec(d5),
		.disp_cen(cen),
		//.disp_mil(d3)
	);
	
	/*always @(posedge clk)
	begin
		d3=
		
	end*/

endmodule