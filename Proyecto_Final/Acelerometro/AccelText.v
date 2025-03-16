module AccelText(
    input clk,
    input inDisplayArea,
    input [9:0] CounterX,
    input [9:0] CounterY,
    input [7:0] ax,
    input [7:0] ay,
    input [7:0] az,
    output reg [2:0] pixel 
);

    localparam START_X = 100;  // inicio del bloque en x
    localparam START_Y = 100;  // inicio del bloque en y
    localparam CHAR_WIDTH = 16;
    localparam CHAR_HEIGHT = 16;
    localparam CHAR_SPACE = 4;    // espacio horizontal entre caracteres
    localparam LINE_GAP = 4;    // espacio vertical entre lineas
    localparam LINE0_Y = START_Y;
    localparam LINE1_Y = START_Y + CHAR_HEIGHT + LINE_GAP;
    localparam LINE2_Y = START_Y + 2*(CHAR_HEIGHT + LINE_GAP);
    localparam TOTAL_CHARS = 6;
    localparam CHAR_AREA = CHAR_WIDTH + CHAR_SPACE;

    reg [3:0] xCen, xDec, xUni;
    reg [3:0] yCen, yDec, yUni;
    reg [3:0] zCen, zDec, zUni;
    reg [7:0] ax_abs, ay_abs, az_abs;
	 reg sign_x, sign_y, sign_z;
	
	 // separar signo de valor
    always @(*) begin

		  if (ax[7]) begin
            sign_x = 1;
            ax_abs = (~ax) + 1;
        end else begin
            sign_x = 0;
            ax_abs = ax;
        end
      
        if (ay[7]) begin
            sign_y = 1;
            ay_abs = (~ay) + 1;
        end else begin
            sign_y = 0;
            ay_abs = ay;
        end
       
        if (az[7]) begin
            sign_z = 1;
            az_abs = (~az) + 1;
        end else begin
            sign_z = 0;
            az_abs = az;
        end

        xUni = ax_abs%10;
        xDec = (ax_abs%100)/10;
        xCen = (ax_abs%1_000)/100;
        yUni = ay_abs%10;
        yDec = (ay_abs%100)/10;
        yCen = (ay_abs%1_000)/100;
        zUni = az_abs%10;
        zDec = (az_abs%100)/10;
        zCen = (az_abs%1_000)/100;
    end

    // patrones para caracteres de 16x16
    function [15:0] pattern_x;
        input [3:0] row;
        begin
            case(row)
                0: pattern_x = 16'b0000000000000000;
                1: pattern_x = 16'b0000000000000000;
                2: pattern_x = 16'b1100000000000011;
                3: pattern_x = 16'b0110000000000110;
                4: pattern_x = 16'b0011000000001100;
                5: pattern_x = 16'b0001100000011000;
                6: pattern_x = 16'b0000110000110000;
                7: pattern_x = 16'b0000011001100000;
                8: pattern_x = 16'b0000001111000000;
                9: pattern_x = 16'b0000001111000000;
                10: pattern_x = 16'b0000011001100000;
                11: pattern_x = 16'b0000110000110000;
                12: pattern_x = 16'b0001100000011000;
                13: pattern_x = 16'b0011000000001100;
                14: pattern_x = 16'b0110000000000110;
                15: pattern_x = 16'b1100000000000011;
                default: pattern_x = 16'b0;
            endcase
        end
    endfunction

    function [15:0] pattern_y;
        input [3:0] row;
        begin
            case(row)
                0: pattern_y = 16'b0000000000000000;
                1: pattern_y = 16'b0000000000000000;
                2: pattern_y = 16'b1100000000000011;
                3: pattern_y = 16'b0110000000000110;
                4: pattern_y = 16'b0011000000001100;
                5: pattern_y = 16'b0001100000011000;
                6: pattern_y = 16'b0000110000110000;
                7: pattern_y = 16'b0000011001100000;
                8: pattern_y = 16'b0000001111000000;
                9: pattern_y = 16'b0000000110000000;
                10: pattern_y = 16'b0000000110000000;
                11: pattern_y = 16'b0000000110000000;
                12: pattern_y = 16'b0000000110000000;
                13: pattern_y = 16'b0000000110000000;
                14: pattern_y = 16'b0000000110000000;
                15: pattern_y = 16'b0000000110000000;
                default: pattern_y = 16'b0;
            endcase
        end
    endfunction

    function [15:0] pattern_z;
        input [3:0] row;
        begin
            case(row)
                0: pattern_z = 16'b0000000000000000;
                1: pattern_z = 16'b0000000000000000;
                2: pattern_z = 16'b1111111111111111;
                3: pattern_z = 16'b0000000000001111;
                4: pattern_z = 16'b0000000000011110;
                5: pattern_z = 16'b0000000000111000;
                6: pattern_z = 16'b0000000001110000;
                7: pattern_z = 16'b0000000011100000;
                8: pattern_z = 16'b0000000111000000;
                9: pattern_z = 16'b0000001110000000;
                10: pattern_z = 16'b0000011100000000;
                11: pattern_z = 16'b0000111000000000;
                12: pattern_z = 16'b0001110000000000;
                13: pattern_z = 16'b0011100000000000;
                14: pattern_z = 16'b0111000000000000;
                15: pattern_z = 16'b1111111111111111;
                default: pattern_z = 16'b0;
            endcase
        end
    endfunction

    function [15:0] pattern_equal;
        input [3:0] row;
        begin
            case(row)
                0: pattern_equal = 16'b0000000000000000;
                1: pattern_equal = 16'b0000000000000000;
                2: pattern_equal = 16'b0000000000000000;
                3: pattern_equal = 16'b0000000000000000;
                4: pattern_equal = 16'b1111111111111111;
                5: pattern_equal = 16'b1111111111111111;
                6: pattern_equal = 16'b0000000000000000;
                7: pattern_equal = 16'b0000000000000000;
                8: pattern_equal = 16'b1111111111111111;
                9: pattern_equal = 16'b1111111111111111;
                10: pattern_equal = 16'b0000000000000000;
                11: pattern_equal = 16'b0000000000000000;
                12: pattern_equal = 16'b0000000000000000;
                13: pattern_equal = 16'b0000000000000000;
                14: pattern_equal = 16'b0000000000000000;
                15: pattern_equal = 16'b0000000000000000;
                default: pattern_equal = 16'b0;
            endcase
        end
    endfunction
	 
	 // patrones para digitos (de 0 a 9)
    function [15:0] pattern_digit;
        input [3:0] digit;
        input [3:0] row;
        begin
            case(digit)
                4'd0: case(row)
                      0:  pattern_digit = 16'b0000111111110000;
							 1:  pattern_digit = 16'b0011000000001100;
							 2:  pattern_digit = 16'b0100000000000010;
							 3:  pattern_digit = 16'b1000000000000001;
							 4:  pattern_digit = 16'b1000000000000001;
							 5:  pattern_digit = 16'b1000000000000001;
							 6:  pattern_digit = 16'b1000000000000001;
							 7:  pattern_digit = 16'b1000000000000001;
							 8:  pattern_digit = 16'b1000000000000001;
							 9:  pattern_digit = 16'b1000000000000001;
							 10: pattern_digit = 16'b1000000000000001;
							 11: pattern_digit = 16'b0100000000000010;
							 12: pattern_digit = 16'b0011000000001100;
							 13: pattern_digit = 16'b0000111111110000;
							 14: pattern_digit = 16'b0000000000000000;
							 15: pattern_digit = 16'b0000000000000000;
                      endcase
                4'd1: case(row)
                      0:  pattern_digit = 16'b0000000110000000;
							 1:  pattern_digit = 16'b0000011110000000;
							 2:  pattern_digit = 16'b0001110110000000;
							 3:  pattern_digit = 16'b0111000110000000;
							 4:  pattern_digit = 16'b0000000110000000;
							 5:  pattern_digit = 16'b0000000110000000;
							 6:  pattern_digit = 16'b0000000110000000;
							 7:  pattern_digit = 16'b0000000110000000;
							 8:  pattern_digit = 16'b0000000110000000;
							 9:  pattern_digit = 16'b0000000110000000;
							 10: pattern_digit = 16'b0000000110000000;
							 11: pattern_digit = 16'b0000000110000000;
							 12: pattern_digit = 16'b0111111111111110;
							 13: pattern_digit = 16'b0000000000000000;
							 14: pattern_digit = 16'b0000000000000000;
							 15: pattern_digit = 16'b0000000000000000;
                      endcase
                4'd2: case(row)
                      0:  pattern_digit = 16'b0000111111110000;
							 1:  pattern_digit = 16'b0011000000001100;
							 2:  pattern_digit = 16'b0100000000000010;
							 3:  pattern_digit = 16'b0000000000000010;
							 4:  pattern_digit = 16'b0000000000000100;
							 5:  pattern_digit = 16'b0000000000011000;
							 6:  pattern_digit = 16'b0000000001100000;
							 7:  pattern_digit = 16'b0000000110000000;
							 8:  pattern_digit = 16'b0000011000000000;
							 9:  pattern_digit = 16'b000011000000000;
							 10: pattern_digit = 16'b0001100000000000;
							 11: pattern_digit = 16'b0011100000000000;
							 12: pattern_digit = 16'b0011111111111110;
							 13: pattern_digit = 16'b0000000000000000;
							 14: pattern_digit = 16'b0000000000000000;
							 15: pattern_digit = 16'b0000000000000000;
                      endcase
                4'd3: case(row)
                      0:  pattern_digit = 16'b0000111111110000;
							 1:  pattern_digit = 16'b0011000000001100;
							 2:  pattern_digit = 16'b0100000000000010;
							 3:  pattern_digit = 16'b0000000000000010;
							 4:  pattern_digit = 16'b0000000000000100;
							 5:  pattern_digit = 16'b0000000111111000;
							 6:  pattern_digit = 16'b0000000000000100;
							 7:  pattern_digit = 16'b0000000000000010;
							 8:  pattern_digit = 16'b0000000000000010;
							 9:  pattern_digit = 16'b0100000000000010;
							 10: pattern_digit = 16'b0011000000000100;
							 11: pattern_digit = 16'b0001000000001000;
							 12: pattern_digit = 16'b0000111111110000;
							 13: pattern_digit = 16'b0000000000000000;
							 14: pattern_digit = 16'b0000000000000000;
							 15: pattern_digit = 16'b0000000000000000;
                      endcase
					  4'd4: case(row)
							 0:  pattern_digit = 16'b0000000001100000;
							 1:  pattern_digit = 16'b0000000011100000;
							 2:  pattern_digit = 16'b0000000111100000;
							 3:  pattern_digit = 16'b0000001101100000;
							 4:  pattern_digit = 16'b0000011001100000;
							 5:  pattern_digit = 16'b0000110001100000;
							 6:  pattern_digit = 16'b0001100001100000;
							 7:  pattern_digit = 16'b0011000001100000;
							 8:  pattern_digit = 16'b0111111111111110;
							 9:  pattern_digit = 16'b0000000001100000;
							 10: pattern_digit = 16'b0000000001100000;
							 11: pattern_digit = 16'b0000000001100000;
							 12: pattern_digit = 16'b0000000001100000;
							 13: pattern_digit = 16'b0000000000000000;
							 14: pattern_digit = 16'b0000000000000000;
							 15: pattern_digit = 16'b0000000000000000;
						    endcase
					  4'd5: case(row)
							 0:  pattern_digit = 16'b0111111111111100;
							 1:  pattern_digit = 16'b0110000000000000;
							 2:  pattern_digit = 16'b0110000000000000;
							 3:  pattern_digit = 16'b0110000000000000;
							 4:  pattern_digit = 16'b0110111111100000;
							 5:  pattern_digit = 16'b0111000000110000;
							 6:  pattern_digit = 16'b0000000000011000;
							 7:  pattern_digit = 16'b0000000000001100;
							 8:  pattern_digit = 16'b0000000000001100;
							 9:  pattern_digit = 16'b0110000000001100;
							 10: pattern_digit = 16'b0011000000011000;
							 11: pattern_digit = 16'b0001110001110000;
							 12: pattern_digit = 16'b0000011111000000;
							 13: pattern_digit = 16'b0000000000000000;
							 14: pattern_digit = 16'b0000000000000000;
							 15: pattern_digit = 16'b0000000000000000;
						    endcase
					  4'd6: case(row)
							 0:  pattern_digit = 16'b0000011111110000;
							 1:  pattern_digit = 16'b0001100000001100;
							 2:  pattern_digit = 16'b0011000000000000;
							 3:  pattern_digit = 16'b0110000000000000;
							 4:  pattern_digit = 16'b0110000000000000;
							 5:  pattern_digit = 16'b1100111111100000;
							 6:  pattern_digit = 16'b1101000000110000;
							 7:  pattern_digit = 16'b1100000000011000;
							 8:  pattern_digit = 16'b1100000000001100;
							 9:  pattern_digit = 16'b1100000000001100;
							 10: pattern_digit = 16'b0110000000001100;
							 11: pattern_digit = 16'b0011110001111000;
							 12: pattern_digit = 16'b0000011111000000;
							 13: pattern_digit = 16'b0000000000000000;
							 14: pattern_digit = 16'b0000000000000000;
							 15: pattern_digit = 16'b0000000000000000;
						    endcase
					  4'd7: case(row)
							 0:  pattern_digit = 16'b0111111111111110;
							 1:  pattern_digit = 16'b0000000000000110;
							 2:  pattern_digit = 16'b0000000000001100;
							 3:  pattern_digit = 16'b0000000000011000;
							 4:  pattern_digit = 16'b0000000000110000;
							 5:  pattern_digit = 16'b0000000001100000;
							 6:  pattern_digit = 16'b0000000011000000;
							 7:  pattern_digit = 16'b0000000110000000;
							 8:  pattern_digit = 16'b0000001100000000;
							 9:  pattern_digit = 16'b0000011000000000;
							 10: pattern_digit = 16'b0000110000000000;
							 11: pattern_digit = 16'b0001100000000000;
							 12: pattern_digit = 16'b0011000000000000;
							 13: pattern_digit = 16'b0000000000000000;
							 14: pattern_digit = 16'b0000000000000000;
							 15: pattern_digit = 16'b0000000000000000;
						    endcase
					  4'd8: case(row)
							 0:  pattern_digit = 16'b0000111111110000;
							 1:  pattern_digit = 16'b0011000000001100;
							 2:  pattern_digit = 16'b0100000000000010;
							 3:  pattern_digit = 16'b0100000000000010;
							 4:  pattern_digit = 16'b0100000000000010;
							 5:  pattern_digit = 16'b0011000000001100;
							 6:  pattern_digit = 16'b0000111111110000;
							 7:  pattern_digit = 16'b0011000000001100;
							 8:  pattern_digit = 16'b0100000000000010;
							 9:  pattern_digit = 16'b0100000000000010;
							 10: pattern_digit = 16'b0100000000000010;
							 11: pattern_digit = 16'b0011000000001100;
							 12: pattern_digit = 16'b0000111111110000;
							 13: pattern_digit = 16'b0000000000000000;
							 14: pattern_digit = 16'b0000000000000000;
							 15: pattern_digit = 16'b0000000000000000;
						    endcase
					  4'd9: case(row)
							 0:  pattern_digit = 16'b0000111111110000;
							 1:  pattern_digit = 16'b0011000000001100;
							 2:  pattern_digit = 16'b0100000000000010;
							 3:  pattern_digit = 16'b0100000000000010;
							 4:  pattern_digit = 16'b0100000000000010;
							 5:  pattern_digit = 16'b0011000000001110;
							 6:  pattern_digit = 16'b0000111111111110;
							 7:  pattern_digit = 16'b0000000000000010;
							 8:  pattern_digit = 16'b0000000000000010;
							 9:  pattern_digit = 16'b0000000000000010;
							 10: pattern_digit = 16'b0010000000000110;
							 11: pattern_digit = 16'b0001100000001100;
							 12: pattern_digit = 16'b0000011111110000;
							 13: pattern_digit = 16'b0000000000000000;
							 14: pattern_digit = 16'b0000000000000000;
							 15: pattern_digit = 16'b0000000000000000;
						    endcase
                default: pattern_digit = 8'b0;
            endcase
        end
    endfunction

    function [15:0] pattern_sign;
        input sign; // 1 = negativo, 0 = positivo
        input [3:0] row;
        begin
            if (sign) begin
                if (row == 7)
                    pattern_sign = 16'b0000001111110000;
                else
                    pattern_sign = 16'b0000000000000000;
            end else begin
                pattern_sign = 16'b0000000000000000;
            end
        end
    endfunction

    // pintar
    always @(posedge clk) begin
        if (inDisplayArea) begin
            pixel <= 3'b000;
            // linea 0 (valor de x)
            if (CounterY >= LINE0_Y && CounterY < LINE0_Y + CHAR_HEIGHT) begin
                if (CounterX >= START_X && CounterX < START_X + TOTAL_CHARS*CHAR_AREA - CHAR_SPACE) begin
                    integer char_index, col;
                    char_index = (CounterX - START_X) / CHAR_AREA;
                    col = (CounterX - START_X) % CHAR_AREA;
                    if (col < CHAR_WIDTH) begin
                        reg [15:0] pattern;
                        case(char_index)
                            0: pattern = pattern_x(CounterY - LINE0_Y);
                            1: pattern = pattern_equal(CounterY - LINE0_Y);
                            2: pattern = pattern_sign(sign_x, CounterY - LINE0_Y);
                            3: pattern = pattern_digit(xCen, CounterY - LINE0_Y);
                            4: pattern = pattern_digit(xDec, CounterY - LINE0_Y);
                            5: pattern = pattern_digit(xUni, CounterY - LINE0_Y);
                            default: pattern = 16'b0;
                        endcase
                        if (pattern[15 - col])
                            pixel <= 3'b101; 
                        else
                            pixel <= 3'b000;
                    end else
                        pixel <= 3'b000;
                end else
                    pixel <= 3'b000;
            end
            // linea 1 (valor de y)
            else if (CounterY >= LINE1_Y && CounterY < LINE1_Y + CHAR_HEIGHT) begin
                if (CounterX >= START_X && CounterX < START_X + TOTAL_CHARS*CHAR_AREA - CHAR_SPACE) begin
                    integer char_index, col;
                    char_index = (CounterX - START_X) / CHAR_AREA;
                    col = (CounterX - START_X) % CHAR_AREA;
                    if (col < CHAR_WIDTH) begin
                        reg [15:0] pattern;
                        case(char_index)
                            0: pattern = pattern_y(CounterY - LINE1_Y);
                            1: pattern = pattern_equal(CounterY - LINE1_Y);
                            2: pattern = pattern_sign(sign_y, CounterY - LINE1_Y);
                            3: pattern = pattern_digit(yCen, CounterY - LINE1_Y);
                            4: pattern = pattern_digit(yDec, CounterY - LINE1_Y);
                            5: pattern = pattern_digit(yUni, CounterY - LINE1_Y);
                            default: pattern = 16'b0;
                        endcase
                        if (pattern[15 - col])
                            pixel <= 3'b101;
                        else
                            pixel <= 3'b000;
                    end else
                        pixel <= 3'b000;
                end else
                    pixel <= 3'b000;
            end
            // linea 2 (valor de z)
            else if (CounterY >= LINE2_Y && CounterY < LINE2_Y + CHAR_HEIGHT) begin
                if (CounterX >= START_X && CounterX < START_X + TOTAL_CHARS*CHAR_AREA - CHAR_SPACE) begin
                    integer char_index, col;
                    char_index = (CounterX - START_X) / CHAR_AREA;
                    col = (CounterX - START_X) % CHAR_AREA;
                    if (col < CHAR_WIDTH) begin
                        reg [15:0] pattern;
                        case(char_index)
                            0: pattern = pattern_z(CounterY - LINE2_Y);
                            1: pattern = pattern_equal(CounterY - LINE2_Y);
                            2: pattern = pattern_sign(sign_z, CounterY - LINE2_Y);
                            3: pattern = pattern_digit(zCen, CounterY - LINE2_Y);
                            4: pattern = pattern_digit(zDec, CounterY - LINE2_Y);
                            5: pattern = pattern_digit(zUni, CounterY - LINE2_Y);
                            default: pattern = 16'b0;
                        endcase
                        if (pattern[15 - col])
                            pixel <= 3'b101;
                        else
                            pixel <= 3'b000;
                    end else
                        pixel <= 3'b000;
                end else
                    pixel <= 3'b000;
            end else
                pixel <= 3'b000;
        end else
            pixel <= 3'b000;
    end

endmodule