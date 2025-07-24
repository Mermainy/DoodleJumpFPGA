module game #(
    parameter int unsigned FPS = 360,
	parameter int unsigned CLK = 50000000,
	parameter int signed EARTH = 768
) (
	input MAX10_CLK1_50,
	input [9:0] SW,
	input [1:0] KEY,

	output VGA_HS,
	output VGA_VS,
	output logic [3:0] VGA_R,
	output logic [3:0] VGA_G,
	output logic [3:0] VGA_B,

	output [9:0] LEDR
);

logic clk;
wire rst = SW[0];
logic [$clog2(CLK / FPS):0] fps_counter;
logic [1:0] game_state;

logic button_left;
logic button_right;
logic [10:0] beam_x_raw;
logic [9:0] beam_y_raw;
logic [10:0] beam_x;
logic [9:0] beam_y;

always_ff @ (posedge clk)
    if (rst)
        fps_counter <= '0;
    else
        fps_counter <= fps_counter + 1;

board_specific bs(
	.MAX10_CLK1_50(MAX10_CLK1_50),
	.KEY(KEY),
	.beam_x_raw(beam_x_raw),
	.beam_y_raw(beam_y_raw),
	
	.clk(clk),
	.button_left(button_left),
	.button_right(button_right),
	.beam_x(beam_x),
	.beam_y(beam_y)
);

logic signed [8:0] delta_x;
control #(
    .FPS(FPS),
	 .CLK(CLK)
) c (
	.clk(clk),
	.rst(rst),
	.fps_counter(fps_counter),

	.button_left(button_left),
	.button_right(button_right),
	
	.game_state(game_state),
	.delta_x(delta_x)
);

logic draw;
beam_establisher be(
	.clk(clk),
	.rst(rst),
	
	.beam_x(beam_x_raw),
	.beam_y(beam_y_raw),
	.valid(draw),

	.switch_line(VGA_HS),  // horizontal sync
	.switch_frame(VGA_VS) 
);

logic [1:0][9:0] ground;
logic doodle_collision;
logic move_collision;
collision_observer #(
    .EARTH(EARTH)
) cobs (
	.clk(clk),
	.rst(rst),

	.platforms(platforms),
	.doodle_x(doodle_x),
	.doodle_y(doodle_y),
	.platform_activation(platform_activation),
	.doodle_fall_direction(doodle_fall_direction),

	.doodle_collision(doodle_collision),
	.move_collision(move_collision),
	.ground(ground)
);

logic [2:0][3:0] doodle_color;
logic doodle_transparency;
logic doodle_fall_direction;
logic [9:0] doodle_y;
logic [10:0] doodle_x;
doodle #(
    .FPS(FPS),
	.CLK(CLK)
) d (
	.clk(clk),
	.rst(rst),
	.fps_counter(fps_counter),

	.beam_x(beam_x),
	.beam_y(beam_y),
	.move_collision(move_collision),

	.ground(ground),
	.collision(doodle_collision),
	.game_state(game_state),

	.delta_x(delta_x),  // [-8:7]
	.doodle_y(doodle_y),
	.doodle_x(doodle_x),
	.doodle_fall_direction(doodle_fall_direction),  // false for up

	.color(doodle_color),
	.is_transparent(doodle_transparency)
);

ultra_beam_substance_painter ubsp(
	.doodle_color(doodle_color),
	.doodle_transparency(doodle_transparency),
	.beam_x(beam_x),
	.beam_y(beam_y),
	.draw(draw),
	.platform_colors(platform_colors),
	.platform_transparencies(platform_transparencies),
	
	.red(VGA_R),
	.green(VGA_G),
	.blue(VGA_B)
);

logic signed [92:0][1:0][10:0] platforms;
logic [92:0] platform_activation;
logic [2:0][3:0] platform_colors;
logic platform_transparencies;
platforms #(
    .FPS(FPS),
	.CLK(CLK),
	.EARTH(EARTH)
) p (
	.clk(clk),
	.rst(rst),
	.fps_counter(fps_counter),

	.beam_x(beam_x),
	.beam_y(beam_y),

	.doodle_y(doodle_y),
	.doodle_x(doodle_x),

	.move_collision(move_collision),
	
	.platforms(platforms),
	.platform_activation(platform_activation),
	
	.color(platform_colors),
	.is_transparent(platform_transparencies),

	.led(LEDR)
);

endmodule
