module game(
	input MAX10_CLK1_50,
	input [9:0] SW,
	input [1:0] KEY,

	output VGA_HS,
	output VGA_VS,
	output logic [3:0] VGA_R,
	output logic [3:0] VGA_G,
	output logic [3:0] VGA_B
);

assign rst = SW[0];

logic clk;
logic rst;
logic button_left;
logic button_right;

logic [10:0] beam_x_raw;
logic [9:0] beam_y_raw;
logic [10:0] beam_x;
logic [9:0] beam_y;

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

control c(
	.clk(clk),
	.rst(rst),

	.button_left(button_left),
	.button_right(button_right),
	
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


logic [2:0][3:0] doodle_color;
logic doodle_transparency;
logic [9:0] doodle_y;

doodle d(
	.clk(clk),
	.rst(rst),
	
	.ground(690),
	.collision(doodle_y >= 690),
	
	.beam_x(beam_x),
	.beam_y(beam_y),
	
	.delta_x(delta_x),  // -8 - 7
	.doodle_y(doodle_y),
	
	.color(doodle_color),
	.is_transparent(doodle_transparency)
);

ultra_beam_substance_painter ubsp(
	.doodle_color(doodle_color),
	.doodle_transparency(doodle_transparency),
	.beam_x(beam_x),
	.beam_y(beam_y),
	.draw(draw),
	
	.red(VGA_R),
	.green(VGA_G),
	.blue(VGA_B)
);

// always_comb begin
// 	    if (draw) begin
// 	    		VGA_R = color[0];
// 	    		VGA_G = color[1];
// 	    		VGA_B = color[2];
// 	    end else begin
// 	    	VGA_R = '0;
// 	    	VGA_G = '0;
// 	    	VGA_B = '0;
// 	    end
// end

endmodule
