module bcd #(parameter N=10) (
	input [N-1:0] binary,
	output [6:0] disp_uni,disp_dec,disp_cen,disp_mil
);
	
	reg [3:0] uni;
	reg [3:0] dec;
	reg [3:0] cen;
	reg [3:0] mil;

	always @(*)
	begin
		uni=binary%10;
		dec=(binary%100)/10;
		cen=(binary%1000)/100;
		mil=binary/1000;
	end
	
	disp DISP_U (
		.disp_in(uni),
		.disp_out(disp_uni)
	);
	
	disp DISP_D (
		.disp_in(dec),
		.disp_out(disp_dec)
	);
	
	disp DISP_C (
		.disp_in(cen),
		.disp_out(disp_cen)
	);
	
	disp DISP_M (
		.disp_in(mil),
		.disp_out(disp_mil)
	);
	
endmodule