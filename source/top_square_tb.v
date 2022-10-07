module top_square_tb;


  // Parameters
  localparam  CORDW = 10;

  // Ports
  reg  clk_pix = 0;
  reg  sim_rst = 0;
  wire [CORDW-1:0] sdl_sx;
  wire [CORDW-1:0] sdl_sy;
  wire sdl_de;
  wire [7:0] sdl_r;
  wire [7:0] sdl_g;
  wire hsync;
  wire vsync;

  top_square 
  #(
    .CORDW (
        CORDW )
  )
  top_square_dut (
    .clk_pix (clk_pix ),
    .sim_rst (sim_rst ),
    .sdl_sx (sdl_sx ),
    .sdl_sy (sdl_sy ),
    .sdl_de (sdl_de ),
    .sdl_r (sdl_r ),
    .sdl_g (sdl_g ),
    .hsync (hsync ),
    .vsync  (vsync)
  );

  initial begin
    begin
      $dumpfile("top_square_tb.vcd");
      $dumpvars(0, top_square_tb);

      sim_rst = 1;
      #100

      sim_rst = 0;

      #20000000
      $finish;
    end
  end

  always
    #20  clk_pix =! clk_pix ;

endmodule
