module pwFSM (
	input clk,rst,
	input [9:0] comb_in,
	output reg correct,error,
	output reg [9:0] states,
	output reg [6:0] d0,d1,d2,d3,d4
 );
 
	// Password: 9876
	
	// Estados: idle, un num correcto, dos, tres, cuatro (done) y error
	localparam IDLE=0,N1=1,N2=2,N3=3,N4=4,ERROR=5;
	
	reg [2:0] current_state;
	reg [2:0] next_state=IDLE;
		
	// Actualiza current_state
	always @(posedge clk or negedge rst) begin
		if (!rst)
			current_state<=IDLE; 
		else
			current_state<=next_state;
	end
	
	// Actualiza estados
	always @(current_state,comb_in) begin 
		case(current_state)
			IDLE:
				begin
				if (comb_in==0)
					next_state<=IDLE;
				else if (comb_in[9])
					next_state<=N1;
				else
					next_state<=ERROR;
				end
			N1:
				begin
				if (comb_in==0)
					next_state<=N1;
				else if (comb_in[8])
					next_state<=N2;
				else
					next_state<=ERROR;
				end
			N2:
				begin
				if (comb_in==0)
					next_state<=N2;
				else if (comb_in[7])
					next_state<=N3;
				else
					next_state<=ERROR;
				end
			N3:
				begin
				if (comb_in==0)
					next_state<=N3;
				else if (comb_in[6])
					next_state<=N4;
				else
					next_state<=ERROR;
				end
			N4: 
				if (comb_in==0)
					next_state<=N4;
				else
					next_state<=IDLE;
			ERROR: 
				if (comb_in==0)
					next_state<=ERROR;
				else
					next_state<=IDLE;
		endcase
	end
	
	// Actualiza salidas
	always @(current_state) begin
		case(current_state)
			IDLE: 
				begin 
				correct=0; 
				error=0; 
				states=10'b0000000001; 
				d0=7'b1111111;
				d1=7'b1111111;
				d2=7'b1111111;
				d3=7'b1111111;
				d4=7'b1111111;
				end
			N1:
				begin
				correct=0; 
				error=0; 
				states=10'b0000000011; 
				d0=7'b1111111;
				d1=7'b1111111;
				d2=7'b1111111;
				d3=7'b0111111;
				d4=7'b1111111;
				end
			N2: 
				begin 
				correct=0; 
				error=0; 
				states=10'b00_0000_0111; 
				d0=7'b1111111;
				d1=7'b1111111;
				d2=7'b0111111;
				d3=7'b0111111;
				d4=7'b1111111;
				end
			N3: 
				begin 
				correct=0; 
				error=0; 
				states=10'b00_0000_1111;
				d0=7'b1111111;
				d1=7'b0111111;
				d2=7'b0111111;
				d3=7'b0111111;
				d4=7'b1111111;
				end
			N4: 
				begin 
				correct=1; 
				error=0; 
				states=10'b00_0001_1111; 
				d4=7'b1111_111;
				d3=7'b0100_001;
				d2=7'b1000_000;
				d1=7'b1001_000;
				d0=7'b0000_110;
				end
			ERROR: 
				begin 
				correct=0; 
				error=1; 
				states=10'b10_0000_0000; 
				d4=7'b0000_110;
				d3=7'b0101_111;
				d2=7'b0101_111;
				d1=7'b0100_011;
				d0=7'b0101_111;
				end
		endcase
	end

endmodule