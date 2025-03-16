module brazo2 (
    input clk,
    input rst,
	 input read_en,
    input signed [15:0] data_rom,
	 input signed [15:0] data_ace,
    output reg pwm_out
);

	reg signed [15:0] data;

	always @(*)
		begin
		if (read_en)
			data <= data_rom;
		else
			data <= data_ace;
		end

	parameter CLK_FREQ = 50_000_000;
	parameter PWM_FREQ = 50; 
	parameter PWM_PERIOD = CLK_FREQ / PWM_FREQ;

	parameter PULSE_MIN = 32'd25_000;
	parameter PULSE_MID = 32'd75_000;
	parameter PULSE_MAX = 32'd150_000;

	parameter ACCEL_MAX = 16'd130;
	parameter ACCEL_MIN = -16'd130;

	parameter SPEED_DIVIDER=32'd500;

	reg [31:0] DC = PULSE_MID;
	reg [31:0] target_DC=PULSE_MID;
	reg [31:0] ctr;
	reg [15:0] data_abs;
	reg [31:0] x;
	reg [31:0] speed_ctr=0;


	always @(*)
		begin
		if (data[15])
			data_abs <= (~data) + 1;
		else
			data_abs <= data;
		end

	always @(*)
		begin
		if (data_abs > ACCEL_MAX)
			x <= PULSE_MAX;
		else
			x <= ((PULSE_MAX - PULSE_MIN) * data_abs) / ACCEL_MAX + PULSE_MIN;
		end

	always @(posedge clk or negedge rst)
		begin
		if (!rst)
			begin
			DC <= PULSE_MID;
			target_DC<=PULSE_MID;
			end
		else
			begin
			if (x >= PULSE_MIN && x <= PULSE_MAX)
				target_DC <= x;
			else
				target_DC <= PULSE_MID;
			if (speed_ctr >= SPEED_DIVIDER)
				begin
				speed_ctr <= 0;
				if (DC < target_DC)
					DC <= DC + 1;
				else if (DC > target_DC)
					DC <= DC - 1;
				end
			else
				begin
				speed_ctr <= speed_ctr + 1;
				end
			end
		end


	always @(posedge clk)
		begin
		if (ctr < PWM_PERIOD - 1)
			ctr <= ctr + 1;
		else
			ctr <= 0;
			pwm_out <= (ctr < DC) ? 1:0;
		end

endmodule