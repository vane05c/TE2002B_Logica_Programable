`timescale 1ns/1ps

module pwm_tb;
    reg pb_inc, pb_dec, clk, rst;
    wire pwm_out;

    pwm DUT (
        .pb_inc(pb_inc),
        .pb_dec(pb_dec),
        .clk(clk),
        .rst(rst),
        .pwm_out(pwm_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        pb_inc = 0;
        pb_dec = 0;
        
        #20 rst = 0;
        
        #50 pb_inc = 1; #10 pb_inc = 0;
        #100 pb_inc = 1; #10 pb_inc = 0;
        
        #100 pb_dec = 1; #10 pb_dec = 0;
        #100 pb_dec = 1; #10 pb_dec = 0;

        #500;
        
        $stop;
    end

endmodule