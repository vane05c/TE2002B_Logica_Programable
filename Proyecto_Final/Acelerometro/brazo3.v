module brazo3 (
    input clk,
    input rst,
    input btn_pinza,
    output reg pwm_out
);

	wire slow_clk;
    wire [9:0] debouncer_pb;

    parameter frecuencia_base = 50_000_000;
    parameter frecuencia_final = 50;
    parameter cuentas_por_periodo = frecuencia_base / frecuencia_final;
    reg [31:0] DC [3:0];
    reg [31:0] ctr;

    clkdiv #(.FREQ(20)) u1(
        .clk(clk),
        .rst(rst),
        .clk_div(slow_clk)
    );

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : debouncer_gen
            debouncer2 d(
                .pb1(~sw[i]),
                .rst(rst),
                .pb_out(debouncer_pb[i]),
                .clk(clk)
            );
        end
    endgenerate

    always @(posedge slow_clk or posedge rst) begin
        if (rst) begin
            DC[0] <= 32'd25_000;
            DC[1] <= 32'd25_000;
            DC[2] <= 32'd25_000;
            DC[3] <= 32'd25_000;
        end else begin
		  
            if (debouncer_pb[0] && DC[0] < 32'd150_000) 
                DC[0] <= DC[0] + 32'd5000;
            else if (debouncer_pb[1] && DC[0] > 32'd5000)
                DC[0] <= DC[0] - 32'd5000;

            if (debouncer_pb[2] && DC[1] < 32'd150_000) 
                DC[1] <= DC[1] + 32'd5000;
            else if (debouncer_pb[3] && DC[1] > 32'd5000)
                DC[1] <= DC[1] - 32'd5000;

            if (debouncer_pb[4] && DC[2] < 32'd150_000) 
                DC[2] <= DC[2] + 32'd5000;
            else if (debouncer_pb[5] && DC[2] > 32'd5000)
                DC[2] <= DC[2] - 32'd5000;

            if (~btn_pinza)
                DC[3] <= 32'd100_000;
            else if (btn_pinza)
                DC[3] <= 32'd25_000;
        end
    end

    always @(posedge clk) begin
        if (ctr < cuentas_por_periodo - 1)
            ctr <= ctr + 32'd1;
        else begin
            ctr <= 0;

        pwm_out <= (ctr < DC[3]) ? 1'b1 : 1'b0;
		  end
    end
	
endmodule