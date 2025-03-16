module ROM #(parameter DATA_WIDTH = 16, ADDRESS_WIDTH = 4)(
	input ce, read_en, 
	input [ADDRESS_WIDTH - 1:0] address,
	output [DATA_WIDTH - 1:0] data_x,
	output [DATA_WIDTH - 1:0] data_y,
	output [DATA_WIDTH - 1:0] data_z
);

reg [DATA_WIDTH - 1:0] mem_x [0:2**(ADDRESS_WIDTH)-1];
reg [DATA_WIDTH - 1:0] mem_y [0:2**(ADDRESS_WIDTH)-1];
reg [DATA_WIDTH - 1:0] mem_z [0:2**(ADDRESS_WIDTH)-1];

initial begin
	$readmemh("ROM_x_hex.hex",mem_x);
	$readmemh("ROM_y_hex.hex",mem_y);
	$readmemh("ROM_z_hex.hex",mem_z);
end

assign data_x = (ce && read_en) ? mem_x[address]:3'h00;
assign data_y = (ce && read_en) ? mem_y[address]:3'h00;
assign data_z = (ce && read_en) ? mem_z[address]:3'h00;

endmodule