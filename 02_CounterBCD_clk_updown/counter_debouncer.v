module counter_debouncer #(parameter N_MAX=5000) (
	input clk, rst_a_p, // reset asincrono (ni depende de la clk signal), flanco positivo (se resetea cuando le doy un 1)
	output reg [ceillog2(N_MAX)-1:0] counter_out,
	output reg counter_match
);

	always @(posedge clk or posedge rst_a_p) // depende de los flancos de subida del clk
	begin
		if(rst_a_p) begin
			counter_out<=0;
			counter_match<=0;
		end
		else begin
			if(counter_out>=N_MAX-1) begin // checar que el contador no pase de 5000 (-1 porque el 0 tmb cuenta)
				counter_out<=0;
				counter_match<=1;
			end
			else begin
				counter_out<=counter_out+1;
				counter_match<=0;
			end
		end
	end

	//log function
	function integer ceillog2;
		input integer data;
		integer i,result;
		begin
			for(i=0;2**i<data;i=i+1)
				result=i+1;
			ceillog2=result;
		end
	endfunction
	//

endmodule