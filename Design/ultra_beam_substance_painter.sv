module ultra_beam_substance_painter #(
	parameter int unsigned GAME_VIEW_LEFT_BORDER_X,
	parameter int unsigned GAME_VIEW_RIGHT_BORDER_X
) (
	input [2:0][3:0] doodle_color,
	input doodle_transparency,
	input [10:0] beam_x,
	input [9:0] beam_y,
	input [2:0][3:0] platform_colors,
	input platform_transparencies,
	input [2:0][3:0] end_signa_color,
	input end_signa_transparency,
    input [2:0][3:0] tabloid_color,
    input tabloid_transparency,

	input draw,
	
	output logic [3:0] red,
	output logic [3:0] green,
	output logic [3:0] blue
);

always_comb begin
	if (draw) begin

		if (beam_x <= GAME_VIEW_LEFT_BORDER_X || beam_x >= GAME_VIEW_RIGHT_BORDER_X) begin
			red = '0;
			green = '0;
			blue = '0;
		end else if (~tabloid_transparency) begin
		    red = tabloid_color[0];
			green = tabloid_color[1];
			blue = tabloid_color[2];
		end else if (~end_signa_transparency) begin
			red = end_signa_color[0];
			green = end_signa_color[1];
			blue = end_signa_color[2];
		end else if (~doodle_transparency) begin
			red = doodle_color[0];
			green = doodle_color[1];
			blue = doodle_color[2];
		end else if (~platform_transparencies) begin
			red = platform_colors[0];
			green = platform_colors[1];
			blue = platform_colors[2];
		end else begin
			red = '1;
			green = '1;
			blue = '1;
		end
	end else begin
		red = '0;
		green = '0;
		blue = '0;
	end
end

endmodule
