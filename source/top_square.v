// Project F: FPGA Graphics - Square (Verilator SDL)
// (C)2022 Will Green, open source hardware released under the MIT License
// Learn more at https://projectf.io/posts/fpga-graphics/

`default_nettype none
`timescale 1ns / 1ns

module top_square #(parameter CORDW=10) (  // coordinate width
    input  wire clk_pix,             // pixel clock
    input  wire sim_rst,             // sim reset
    output      reg [CORDW-1:0] sdl_sx,  // horizontal SDL position
    output      reg [CORDW-1:0] sdl_sy,  // vertical SDL position
    output      reg sdl_de,              // data enable (low in blanking interval)
    output      reg [7:0] sdl_r,         // 8-bit red
    output      reg [7:0] sdl_g,         // 8-bit green
    output      reg [7:0] sdl_b,         // 8-bit blue
    output      wire hsync,
    output      wire vsync
    );

    // display sync signals and coordinates
    wire [CORDW-1:0] sx, sy;
    wire de;
    simple_480p display_inst (
        .clk_pix,
        .rst_pix(sim_rst),
        .sx,
        .sy,
        /* verilator lint_off PINCONNECTEMPTY */
        .hsync(hsync),
        .vsync(vsync),
        /* verilator lint_on PINCONNECTEMPTY */
        .de
    );

    // define a square with screen coordinates
    logic square;
    always @(*) begin
        square = (sx > 220 && sx < 420) && (sy > 140 && sy < 340);
    end

    // paint colours: white inside square, blue outside
    logic [3:0] paint_r, paint_g, paint_b;
    always @(*) begin
        paint_r = (square) ? 4'hF : 4'h1;
        paint_g = (square) ? 4'hF : 4'h3;
        paint_b = (square) ? 4'hF : 4'h7;
    end

    // SDL output (8 bits per colour channel)
    always @(posedge clk_pix) begin
        sdl_sx <= sx;
        sdl_sy <= sy;
        sdl_de <= de;
        sdl_r <= {2{paint_r}};  // double signal width from 4 to 8 bits
        sdl_g <= {2{paint_g}};
        sdl_b <= {2{paint_b}};
    end
endmodule