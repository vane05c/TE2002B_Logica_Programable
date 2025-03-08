module bcdFm (
	input [16:0] num,
	output [6:0] disp_uni,disp_dec,disp_cen,disp_mil,disp_decmil,disp_cenmil
);
	
	reg [3:0] uni;
	reg [3:0] dec;
	reg [3:0] cen;
	reg [3:0] mil;
	reg [3:0] decmil;
	reg [3:0] cenmil;

	always @(*)
	begin
		uni=num%10;
		dec=(num%100)/10;
		cen=(num%1_000)/100;
		mil=(num%10_000)/1_000;
		decmil=(num%100_000)/10_000;
		cenmil=num/100_000;
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
	
	disp DISP_DM (
		.disp_in(decmil),
		.disp_out(disp_decmil)
	);
	
	disp DISP_CM (
		.disp_in(cenmil),
		.disp_out(disp_cenmil)
	);
	
endmodule