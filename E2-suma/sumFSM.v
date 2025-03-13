module sumFSM (
	input clk,rst,enable,
	//input [9:0] targ,
	input [4:0] targ,
	//output reg [9:0] states,
	//output reg [6:0] d0,d1,
	output reg [7:0] sum
 );
 
	
	// Estados: idle, un num correcto, dos, tres, cuatro (done) y error
	localparam IDLE=0,COUNT=1,DONE=2;
	
	reg [1:0] current_state;
	reg [1:0] next_state;
	
	reg [4:0] count=0;
	reg done=0;
		
	// Actualiza current_state
	always @(posedge clk or negedge rst) begin
		if (!rst)
			begin
			//count<=0;
			current_state<=IDLE;
			end
		else
			current_state<=next_state;
	end
	
	// Actualiza estados
	always @(current_state,targ) begin 
		case(current_state)
			IDLE:
				begin
				/*done=0;
				count=0;
				sum=0;*/
				if (!enable)
				begin
				/*count=0;
				sum=0;*/
					next_state<=IDLE;
				end
				else
					next_state<=COUNT;
				end
			COUNT:
				if (!enable)
					next_state<=COUNT;
				else
					next_state<=DONE;
			DONE: 
				if (enable)
					next_state<=DONE;
				else
					next_state<=IDLE;
		endcase
	end
	
	// Actualiza salidas
	always @(current_state) begin
		case(current_state)
			COUNT:
				if (enable && count<=targ)
					begin
					sum=sum+count;
					count=count+1;
					end
				else
				begin
					done=1;
					count=0;
					sum=0;
					end
			default:
				begin
				if (!done) begin
				count=0;
				sum=0;end
				end
			/*
			if (enable && count<=targ)
					begin
					sum=sum+count;
					count=count+1;
					end
				else if (count==targ)
					done=1;
				else
				begin
					done=0;
					end
			*/
		endcase
	end

endmodule