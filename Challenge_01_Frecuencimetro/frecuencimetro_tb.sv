`timescale 1ns/1ps

module frecuencimetro_tb();

	reg clk=0;
	reg rst=1;
	reg signal=0;
	wire [6:0] disp0,disp1,disp2,disp3,disp4,disp5;
	
	frecuencimetro DUT (
		.clk(clk),
		.rst(rst),
		.signal(signal),
		.disp0(disp0),
		.disp1(disp1),
		.disp2(disp2),
		.disp3(disp3),
		.disp4(disp4),
		.disp5(disp5)
	);
	
	always #10 clk=~clk; // 10 ns = T/2 del clk de 50 MHz
	
	integer i;
	initial
		begin
		rst=0;
		#1 rst=1;
		
		for (i=0;i<4;i=i+1)
			begin
			signal=~signal;
			#5_000;        // 5_000 ns = 100 kHz (T/2, T=1/f=1/100_000)
			//#50_000_000; // 50_000_000 ns = 10 Hz (T/2, T=1/f=1/10)
			end
		
		$stop;
		end
	
endmodule