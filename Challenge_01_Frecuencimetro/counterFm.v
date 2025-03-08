module counterFm (
	input clk,rst,enable,
	output reg [22:0] countOut
);

	reg [22:0] counter = 0;

	always @(posedge clk or negedge rst)
		begin
			if (!rst)
				begin
				counter <= 0;
				countOut <= 0;
				end
			else
				begin
				if (!enable && counter!=0)
					begin
					countOut <= 2*counter;
					counter <= 0;
					end
				else if (enable)
					counter <= counter+1;
				end
		end
		
endmodule