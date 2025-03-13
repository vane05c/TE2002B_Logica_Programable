module counter (
	input clk,rst,enable,
	output reg [9:0] ms,
	output reg [6:0] s
);
	
	//reg [16:0] count; //'
	
	always @(posedge clk or negedge rst)
		begin
		if (!rst)
			begin
			s<=0;
			ms<=0;
			end
		else if (enable)
			begin
			if (s>98)
				begin
				s<=0;
				ms<=0;
				end
			if (ms>999)
				begin
				ms<=0;
				s<=s+1;
				end
			else 
				ms<=ms+1;
			end
		end

	/*always @(posedge clk)
		begin
		if (enable)
			begin
			if (count==50_000) //50,000=1ms/20ns (T de 50MHz)
				ms<=ms+1;
			if (ms==999)
				s<=s+1;
			end
		end*/
		
endmodule