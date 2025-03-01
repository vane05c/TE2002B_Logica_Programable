`timescale 1ns/100ps

module count_bcd_tb #(parameter N=4, N_MAX=5000) ();

	reg clk,rst,switch_in,load;
	reg [3:0] data_in;
	wire [6:0] disp_out;
	
	count_bcd #(.N(N), .N_MAX(N_MAX)) DUT (
		.clk(clk),
		.rst(rst),
		.switch_in(switch_in),
		.load(load),
		.data_in(data_in),
		.disp_out(disp_out)
	);

	initial begin
		clk=0;
		switch_in=0;
		rst=1;
		data_in=4'b0010;
		load=0;
		#10;
		rst=0; //400-410

		#10;
		switch_in=1;
		#100;
		load=1;
		#20;
		load=0;
		#150;
		switch_in=0;
		#110;
		rst=1;
		#10;
		rst=0;
		#155;
		
	$stop;
	end
	
	always
	begin
		#5 clk=~clk;
	end
	
endmodule