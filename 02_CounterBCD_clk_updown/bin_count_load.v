module bin_count_load (
	output reg [3:0] count,
	input [3:0] data_in,
	input rst,up_down,load,clk
);

	always @(posedge clk or posedge rst) begin
		if (rst)
			count<=4'b0000;
		else if (load)
			count<=data_in;
		else if (up_down)
			count<=count+1;
		else
			count<=count-1;
	end

endmodule