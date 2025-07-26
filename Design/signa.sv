module signa #(
	parameter int unsigned GAME_VIEW_LEFT_BORDER_X
) (
    input clk,
    input rst,
    input [1:0] game_state,

    input [10:0] beam_x,
	input [9:0] beam_y,

    output logic [2:0][3:0] color,
	output logic is_transparent
);

logic [281:0][229:0][2:0][3:0] signa_transparent_rgb;
logic [281:0][229:0] signa_transparent_alpha;
`INITIAL_SIGNA_TRANSPARENT

always_ff @ (posedge clk) begin
	if (game_state == 2
	        && beam_x >= GAME_VIEW_LEFT_BORDER_X + 56 && beam_x < GAME_VIEW_LEFT_BORDER_X + 286
	        && beam_y >= 269 && beam_y < 551) begin
		color[0] <= signa_transparent_rgb[beam_y - 269][beam_x - 56 - GAME_VIEW_LEFT_BORDER_X][0];
		color[1] <= signa_transparent_rgb[beam_y - 269][beam_x - 56 - GAME_VIEW_LEFT_BORDER_X][1];
		color[2] <= signa_transparent_rgb[beam_y - 269][beam_x - 56 - GAME_VIEW_LEFT_BORDER_X][2];
		is_transparent <= signa_transparent_alpha[beam_y - 269][beam_x - 56 - GAME_VIEW_LEFT_BORDER_X];
	end else
	    is_transparent <= 1;
end

endmodule
