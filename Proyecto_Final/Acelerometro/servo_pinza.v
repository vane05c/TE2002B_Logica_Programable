module servo_pinza (
	input clk, 
	input rst,      
	input btn_pinza,      
	output reg pwm_out  
);

	parameter frecuencia_base = 50_000_000;
	parameter frecuencia_final = 50;
	parameter cuentas_por_periodo = frecuencia_base/frecuencia_final;
	reg [31:0] DC;
	reg [31:0] ctr;

	always @(posedge clk or negedge rst)
		begin
		if (!rst)
			DC <= 32'd25_000;
		else
			begin
			if (!btn_pinza)
				DC <= 32'd100_000;
			else if (btn_pinza)
				DC <= 32'd25_000;
			end
		end

	always @(posedge clk)
		begin
		if (ctr < cuentas_por_periodo - 1)
			ctr <= ctr + 32'd1;
		else
			ctr <= 0;
			pwm_out <= (ctr < DC) ? 1'b1 : 1'b0;
		end
 
endmodule