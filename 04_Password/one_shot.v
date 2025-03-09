module one_shot (
	input clk,signal,
	output reg oneshot_out
);

	reg delay;
	
	always @(posedge clk) begin
		delay<=signal;
		if (signal && signal^delay)
			oneshot_out<=1;
		else
			oneshot_out<=0;
	end

endmodule