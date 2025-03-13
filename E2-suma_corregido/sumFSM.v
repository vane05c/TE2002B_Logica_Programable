	module sumFSM (
		input clk, rst, enable,
		input [3:0] targ,
		output reg [7:0] sum
	);
	
	localparam IDLE = 0, COUNT = 1, DONE = 2;
	reg [1:0] current_state, next_state;
	reg [6:0] count;

	always @(posedge clk or posedge rst)
		begin
		if (rst)
			begin
			current_state <= IDLE;
			sum <= 0;
			count <= 0;
			end
		else
			begin
			if (!enable)
				begin  	
				current_state <= IDLE;
				sum <= 0;
				count <= 0;
				end
			else
				begin
				current_state <= next_state;
				if (current_state == COUNT)
					begin
					sum <= sum + count;
					count <= count + 1;
					end
				end
			end
		end

	always @(*)
		begin
		
			case(current_state)
				IDLE:
					begin
					if (enable)
						next_state<=COUNT;
					else
						next_state<=IDLE;
					end
					
				COUNT:
					begin
					if (count >= targ)
						next_state<=DONE;
					else
						next_state<=COUNT;
					end
					
				DONE:
					begin
					if (enable)
						next_state<=DONE;
					else
						next_state<=IDLE;
					end
					
				default: next_state = IDLE;
				
			endcase
		end

	endmodule
