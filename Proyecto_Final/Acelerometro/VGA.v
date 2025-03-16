module VGA(
    input clk,
    input [7:0] ax, 
    input [7:0] ay, 
    input [7:0] az, 
    output [2:0] pixel,
    output hsync_out,
    output vsync_out
);
    
    wire clk_25;
    wire inDisplayArea;
    wire [9:0] CounterX, CounterY;
    
    clkdiv #(.FREQ(25_175_000)) CLKDIV (
        .clk(clk),
        .rst(0),
        .clk_div(clk_25)
    );

    hvsync_generator hvsync (
        .clk(clk_25),
        .vga_h_sync(hsync_out),
        .vga_v_sync(vsync_out),
        .CounterX(CounterX),
        .CounterY(CounterY),
        .inDisplayArea(inDisplayArea)
    );
	 
	AccelText accel_text_inst (
		.clk(clk_25),
		.inDisplayArea(inDisplayArea),
		.CounterX(CounterX),
		.CounterY(CounterY),
		.ax(ax),
		.ay(ay),
		.az(az),
		.pixel(pixel)
	);

endmodule