module d_ff (
    input slow_clk,
    input D,
    output reg Q
);

    always @(posedge slow_clk) begin
        Q <= D;
    end

endmodule