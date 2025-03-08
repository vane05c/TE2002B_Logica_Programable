module frecuencimetro (
	input clk,rst,signal,
	output [6:0] disp0,disp1,disp2,disp3,disp4,disp5
);

	wire [22:0] countOut;
	reg [16:0] freq;
	
	counterFm COUNT (
		.clk(clk),
		.rst(rst),
		.enable(signal),
		.countOut(countOut)
	);
	
	always @(posedge clk)
		begin
		if (countOut!=0)
			freq <= 50_000_000/countOut;
		else
			freq <= 0; // la frecuencia no ha sido calculads porque la cuenta no ha llegado a la mitad del pulso de signal (input).
		end
	
	bcdFm BCD (
		.num(freq),
		.disp_uni(disp0),
		.disp_dec(disp1),
		.disp_cen(disp2),
		.disp_mil(disp3),
		.disp_decmil(disp4),
		.disp_cenmil(disp5)
	);
	
endmodule