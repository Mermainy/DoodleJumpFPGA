module game #(
    parameter int unsigned FPS = 360,
	parameter int unsigned CLK = 50000000,
	parameter int signed EARTH = 768,
	parameter int unsigned DOODLE_VELOCITY = 9,
	parameter int unsigned DOODLE_ACCELERATION = 10,
	parameter int unsigned DOODLE_HEIGHT = 80,
	parameter int unsigned DOODLE_WIDTH = 80,
	parameter int unsigned PLATFORM_HEIGHT = 30,
	parameter int unsigned PLATFORM_WIDTH = 100,
	parameter int unsigned PLATFORM_COLLISION_HAPPENING_HEIGHT = 420,
	parameter int unsigned DOODLE_START_POSITION_X = 472,
	parameter int unsigned WORLD_SHIFT = 10,
	parameter int unsigned GAME_VIEW_LEFT_BORDER_X = 340,
	parameter int unsigned GAME_VIEW_RIGHT_BORDER_X = 682
) (
	input MAX10_CLK1_50,
	input [9:0] SW,
	input [1:0] KEY,

	output VGA_HS,
	output VGA_VS,
	output logic [3:0] VGA_R,
	output logic [3:0] VGA_G,
	output logic [3:0] VGA_B
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
	.CLK(CLK),
	.EARTH(EARTH),
	.DOODLE_HEIGHT(DOODLE_HEIGHT)
) c (
	.clk(clk),
	.rst(rst),
	.fps_counter(fps_counter),

	.button_left(button_left),
	.button_right(button_right),
	.doodle_y(doodle_y),
	
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
    .EARTH(EARTH),
    .DOODLE_HEIGHT(DOODLE_HEIGHT),
    .DOODLE_WIDTH(DOODLE_WIDTH),
    .PLATFORM_HEIGHT(PLATFORM_HEIGHT),
    .PLATFORM_WIDTH(PLATFORM_WIDTH),
    .PLATFORM_COLLISION_HAPPENING_HEIGHT(PLATFORM_COLLISION_HAPPENING_HEIGHT)
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
	.CLK(CLK),
	.EARTH(EARTH),
	.VELOCITY(DOODLE_VELOCITY),
	.ACCELERATION(DOODLE_ACCELERATION),
	.WIDTH(DOODLE_WIDTH),
	.HEIGHT(DOODLE_HEIGHT),
	.START_POSITION_X(DOODLE_START_POSITION_X),
	.WORLD_SHIFT(WORLD_SHIFT),
	.GAME_VIEW_LEFT_BORDER_X(GAME_VIEW_LEFT_BORDER_X),
	.GAME_VIEW_RIGHT_BORDER_X(GAME_VIEW_RIGHT_BORDER_X)
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

logic signed [89:0][1:0][10:0] platforms;
logic [89:0] platform_activation;
logic [2:0][3:0] platform_colors;
logic platform_transparencies;
platforms #(
    .FPS(FPS),
	.CLK(CLK),
	.EARTH(EARTH),
	.WORLD_SHIFT(WORLD_SHIFT),
	.PLATFORM_HEIGHT(PLATFORM_HEIGHT),
	.PLATFORM_WIDTH(PLATFORM_WIDTH)
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
	.is_transparent(platform_transparencies)
);

logic [2:0][3:0] end_signa_color;
logic end_signa_transparency;
signa #(
    .GAME_VIEW_LEFT_BORDER_X(GAME_VIEW_LEFT_BORDER_X)
) s (
    .clk(clk),
    .rst(rst),
	.game_state(game_state),

	.beam_x(beam_x),
	.beam_y(beam_y),

    .color(end_signa_color),
	.is_transparent(end_signa_transparency)
);

logic [2:0][3:0] tabloid_color;
logic tabloid_transparency;
tabloid #(
    .FPS(FPS),
	.CLK(CLK),
	.GAME_VIEW_LEFT_BORDER_X(GAME_VIEW_LEFT_BORDER_X)
) t (
    .clk(clk),
	.rst(rst),
	.fps_counter(fps_counter),

	.game_state(game_state),

	.beam_x(beam_x),
	.beam_y(beam_y),

	.move_collision(move_collision),

	.color(tabloid_color),
	.is_transparent(tabloid_transparency)
);

ultra_beam_substance_painter #(
    .GAME_VIEW_LEFT_BORDER_X(GAME_VIEW_LEFT_BORDER_X),
    .GAME_VIEW_RIGHT_BORDER_X(GAME_VIEW_RIGHT_BORDER_X)
) ubsp (
	.doodle_color(doodle_color),
	.doodle_transparency(doodle_transparency),
	.beam_x(beam_x),
	.beam_y(beam_y),
	.platform_colors(platform_colors),
	.platform_transparencies(platform_transparencies),
	.end_signa_color(end_signa_color),
	.end_signa_transparency(end_signa_transparency),
	.tabloid_color(tabloid_color),
    .tabloid_transparency(tabloid_transparency),
    .game_state(game_state),

	.draw(draw),

	.red(VGA_R),
	.green(VGA_G),
	.blue(VGA_B)
);

endmodule
