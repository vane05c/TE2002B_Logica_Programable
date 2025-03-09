`timescale 1ns/1ps

module password_tb();

	reg clk=1;
	reg rst=1;
	reg [9:0] comb_in_so=0;
	wire [6:0] d0,d1,d2,d3,d4;
	wire [9:0] states;

	password DUT (
		.clk(clk),
		.rst(rst),
		.comb_in_so(comb_in_so),
		.d0(d0),
		.d1(d1),
		.d2(d2),
		.d3(d3),
		.d4(d4),
		.states(states)
	);
	
	always #5 clk=~clk;
	
	initial
	begin
		rst=0;
		#10;
		rst=1;
		
		#30;
		comb_in_so=10'b1000000000;
		#30;
		comb_in_so=10'b1100000000;
		#30;
		comb_in_so=10'b1110000000;
		#30;
		comb_in_so=10'b1111000000;
		#40;
		
		rst=0;
		#10;
		rst=1;
		comb_in_so=0;
		
		#30;
		comb_in_so=10'b1000000000;
		#30;
		comb_in_so=10'b0000010000;
		#40;
		
		$stop;
	end
	
endmodule