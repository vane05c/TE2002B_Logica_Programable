module disp (
	input [3:0] disp_in,
	output reg [6:0] disp_out
);

	always @(*)
	begin
		case(disp_in)
			0: disp_out=1;
			1: disp_out=7'b1001111;
			2: disp_out=7'b0010010;
			3: disp_out=7'b0000110;
			4: disp_out=7'b1001100;
			5: disp_out=7'b0100100;
			6: disp_out=7'b0100000;
			7: disp_out=7'b0001111;
			8: disp_out=0;
			9: disp_out=7'b0000100;
			10: disp_out=7'b0001000;
			11: disp_out=7'b1100000;
			12: disp_out=7'b0110001;
			13: disp_out=7'b1000010;
			14: disp_out=7'b0110000;
			15: disp_out=7'b0111000;
		endcase
	end

endmodule