//===========================================================================
// accel.v
//
// Template module to get the DE10-Lite's accelerator working very quickly.
//
//
//===========================================================================

module accel (
   //////////// CLOCK //////////
   input 		          		ADC_CLK_10,
   input 		          		MAX10_CLK1_50,
   input 		          		MAX10_CLK2_50,

   //////////// SEG7 //////////
   output		     [7:0]		HEX0,
   output		     [7:0]		HEX1,
   output		     [7:0]		HEX2,
   output		     [7:0]		HEX3,
   output		     [7:0]		HEX4,
   output		     [7:0]		HEX5,

   //////////// KEY //////////
   input 		     [1:0]		KEY,

   //////////// LED //////////
   output		     [9:0]		LEDR,

   //////////// SW //////////
   input 		     [9:0]		SW,
	
	/////////// GPIO /////////
   output 		     [35:0]		GPIO,
	
	////////// VGA ///////////
	output [3:0] VGA_R,
	output [3:0] VGA_G,
	output [3:0] VGA_B,
	output VGA_HS,
	output VGA_VS,

   //////////// Accelerometer ports //////////
   output		          		GSENSOR_CS_N,
   input 		     [2:1]		GSENSOR_INT,
   output		          		GSENSOR_SCLK,
   inout 		          		GSENSOR_SDI,
   inout 		          		GSENSOR_SDO
   );

//===== Declarations
   localparam SPI_CLK_FREQ  = 200;  // SPI Clock (Hz)
   localparam UPDATE_FREQ   = 1;    // Sampling frequency (Hz)

   // clks and reset
   wire reset_n;
   wire clk, spi_clk, spi_clk_out;

   // output data
   wire data_update;
	wire signed [15:0] data_x, data_y, data_z;
	

//===== Phase-locked Loop (PLL) instantiation. Code was copied from a module
//      produced by Quartus' IP Catalog tool.
	PLL ip_inst (
		.inclk0 ( MAX10_CLK1_50 ),
		.c0 ( clk ),                 // 25 MHz, phase   0 degrees
		.c1 ( spi_clk ),             //  2 MHz, phase   0 degrees
		.c2 ( spi_clk_out )          //  2 MHz, phase 270 degrees
		);

//===== Instantiation of the spi_control module which provides the logic to 
//      interface to the accelerometer.
	spi_control #(     // parameters
			.SPI_CLK_FREQ   (SPI_CLK_FREQ),
			.UPDATE_FREQ    (UPDATE_FREQ))
		spi_ctrl (      // port connections
			.reset_n    (reset_n),
			.clk        (clk),
			.spi_clk    (spi_clk),
			.spi_clk_out(spi_clk_out),
			.data_update(data_update),
			.data_x     (data_x),
			.data_y     (data_y),
			.data_z		(data_z),
			.SPI_SDI    (GSENSOR_SDI),
			.SPI_SDO    (GSENSOR_SDO),
			.SPI_CSN    (GSENSOR_CS_N),
			.SPI_CLK    (GSENSOR_SCLK),
			.interrupt  (GSENSOR_INT)
		);

//===== Main block
//      To make the module do something visible, the 16-bit data_x is 
//      displayed on four of the HEX displays in hexadecimal format.

	assign reset_n = KEY[1];


	//actualizar cada 2_500_000 cuentas
	reg signed [15:0] x_reg, y_reg, z_reg;

	reg [23:0] update_counter;
   wire update_en;
	
	   always @(posedge clk or negedge reset_n) begin
			if (!reset_n)
				update_counter <= 0;
			else if (update_counter == 2_500_000 - 1)
				update_counter <= 0;
			else
				update_counter <= update_counter + 1;
		end

   assign update_en = (update_counter == 2_500_000 - 1);

   always @(posedge clk or negedge reset_n)
		begin
      if (!reset_n)
			begin
         x_reg <= 0;
         y_reg <= 0;
         z_reg <= 0;
			end
      else if (update_en)
			begin
         x_reg <= data_x;
         y_reg <= data_y;
         z_reg <= data_z;
			end
		end
	
	wire [3:0] unidades_x = x_reg %10;
	wire [3:0] decenas_x = (x_reg/10)%10;
	wire [3:0] centenas_x = x_reg /100;

	wire [3:0] unidades_y = y_reg%10;
	wire [3:0] decenas_y = (y_reg/10)%10;
	wire [3:0] centenas_y = y_reg/100;


	// 7-segment displays HEX0-3 show data_x in hexadecimal
	seg7 s0 (
		.in      (unidades_x),
		.display (HEX0) );

	seg7 s1 (
		.in      (decenas_x),
		.display (HEX1) );

	seg7 s2 (
		.in      (centenas_x),
		.display (HEX2) );

	seg7 s3 (
		.in      (unidades_y),
		.display (HEX3) );
		
	seg7 s4 ( .in(decenas_y), .display(HEX4) );

	seg7 s5 ( .in(centenas_y), .display(HEX5) );

	assign LEDR = z_reg[9:0];
	

	//ROM
	wire [15:0] rom_x;
	wire [15:0] rom_y;
	wire [15:0] rom_z;
	
	reg [3:0] address_reg;
	reg [31:0] counter; 
   reg enable_counter;
	
	localparam COUNT_1SEC = 50_000_000;
	
	always @(posedge MAX10_CLK1_50 or negedge reset_n)
		begin
		if (!reset_n)
			begin
			counter <= 32'd0;
			enable_counter <= 1'b0;
			end
		else
			begin
			if (SW[0])
				begin
				enable_counter <= 1'b1;
				if (enable_counter)
					begin 
					if (counter < COUNT_1SEC - 1)
						begin
						counter <= counter + 1;
						end
					else
						begin
						counter <= 32'd0;
						address_reg <= (address_reg < 8) ? address_reg + 1 : 3'd0;
						end
					end
				end
			else
				begin
				enable_counter <= 1'b0;
				counter <= 32'd0;
				end
			end
		end

	ROM #(.DATA_WIDTH(16),.ADDRESS_WIDTH(3)) rom_instancia(
		.ce(1'b1), 
		.read_en(SW[0]), 
		.address(address_reg),
		.data_x(rom_x),
		.data_y(rom_y),
		.data_z(rom_z)
	); 


	//VGA
   wire [2:0] pixel;
   wire hsync_out;
   wire vsync_out;
	
	wire [7:0] send_x;
	wire [7:0] send_y;
	wire [7:0] send_z;
	
	assign send_x = { x_reg[15], x_reg[10:4] };
	assign send_y = { y_reg[15], y_reg[10:4] };
	assign send_z = { z_reg[15], z_reg[10:4] };

   VGA vgainst (
      .clk(MAX10_CLK1_50),
		.ax(send_x), 
      .ay(send_y),
      .az(send_z),
      .pixel(pixel),
      .hsync_out(hsync_out),
      .vsync_out(vsync_out)
   );
	
	assign VGA_R = {4{pixel[2]}};
   assign VGA_G = {4{pixel[1]}};
   assign VGA_B = {4{pixel[0]}};

   assign VGA_HS = hsync_out;
   assign VGA_VS = vsync_out;
	
	
	//servos
	brazo2 brazoinst_x (
        .clk(MAX10_CLK1_50), 
        .rst(KEY[1]), 
		  .read_en(SW[0]),
        .data_ace(x_reg[15:8]), 
		  .data_rom(rom_x),
        .pwm_out(GPIO[1]) 
    );
	 
	 brazo2 brazoinst_y (
        .clk(MAX10_CLK1_50), 
        .rst(KEY[1]),
		  .read_en(SW[0]), 
        .data_ace(y_reg[15:8]),  
		  .data_rom(rom_y),
        .pwm_out(GPIO[0]) 
    );
	 
	 brazo2 brazoinst_z (
        .clk(MAX10_CLK1_50), 
        .rst(KEY[1]),
		  .read_en(SW[0]), 
        .data_ace(z_reg[15:8]),
		  .data_rom(rom_z),
        .pwm_out(GPIO[2]) 
    );
	 
	 servo_pinza br_wr (
        .clk(MAX10_CLK1_50), 
        .rst(KEY[1]),
        .btn_pinza(~KEY[0]),
        .pwm_out(GPIO[3])
    );

endmodule