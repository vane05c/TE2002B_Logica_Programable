`timescale 1ns/100ps

module bcd_tb #(parameter N=10, ITERACIONES=10) ();

	reg [N-1:0] BCD_in_sw;

	wire [6:0] disp_uni;
	wire [6:0] disp_dec;
	wire [6:0] disp_cen;
	wire [6:0] disp_mil;

	bcd DUT (
		.binary(BCD_in_sw),
		.disp_uni(disp_uni),
		.disp_dec(disp_dec),
		.disp_cen(disp_cen),
		.disp_mil(disp_mil)
	);

	task set_input();
		BCD_in_sw=$urandom_range(0,2**N-1);
		$display("Valor a probar = %d",BCD_in_sw);
		
		#10;
	endtask

	integer i;
	initial
	begin
		for (i=0;i<ITERACIONES;i=i+1)
		begin
			set_input();
		end
	end

endmodule