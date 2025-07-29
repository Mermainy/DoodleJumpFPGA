module tabloid #(
	parameter int unsigned GAME_VIEW_LEFT_BORDER_X,
	parameter int unsigned DIGIT_WIDTH = 13,
	parameter int unsigned DIGIT_HEIGHT = 12
) (
    input clk,
	input rst,
	input calculation_time,

	input [1:0] game_state,

	input [10:0] beam_x,
	input [9:0] beam_y,

	input move_collision,

	output logic [2:0][3:0] color,
	output logic is_transparent
);

logic [13:0] score;
logic [3:0] move_counter;
always_ff @ (posedge clk)
	if (rst) begin
	    move_counter <= '0;
	    score <= '0;
	end else if (game_state == 1) begin
	    if (calculation_time) begin
	        if (move_collision || move_counter) begin
                move_counter <= move_counter + 1;
                if (move_counter == 0)
                    score <= score + 1;
            end
            if (score == 9999)
                move_counter <= '0;
	    end
	end

logic [11:0][12:0][2:0][3:0] zero_transparent_rgb;
logic [11:0][12:0] zero_transparent_alpha;
`INITIAL_ZERO_TRANSPARENT

logic [11:0][12:0][2:0][3:0] one_transparent_rgb;
logic [11:0][12:0] one_transparent_alpha;
`INITIAL_ONE_TRANSPARENT

logic [11:0][12:0][2:0][3:0] two_transparent_rgb;
logic [11:0][12:0] two_transparent_alpha;
`INITIAL_TWO_TRANSPARENT

logic [11:0][12:0][2:0][3:0] three_transparent_rgb;
logic [11:0][12:0] three_transparent_alpha;
`INITIAL_THREE_TRANSPARENT

logic [11:0][12:0][2:0][3:0] four_transparent_rgb;
logic [11:0][12:0] four_transparent_alpha;
`INITIAL_FOUR_TRANSPARENT

logic [11:0][12:0][2:0][3:0] five_transparent_rgb;
logic [11:0][12:0] five_transparent_alpha;
`INITIAL_FIVE_TRANSPARENT

logic [11:0][12:0][2:0][3:0] six_transparent_rgb;
logic [11:0][12:0] six_transparent_alpha;
`INITIAL_SIX_TRANSPARENT

logic [11:0][12:0][2:0][3:0] seven_transparent_rgb;
logic [11:0][12:0] seven_transparent_alpha;
`INITIAL_SEVEN_TRANSPARENT

logic [11:0][12:0][2:0][3:0] eight_transparent_rgb;
logic [11:0][12:0] eight_transparent_alpha;
`INITIAL_EIGHT_TRANSPARENT

logic [11:0][12:0][2:0][3:0] nine_transparent_rgb;
logic [11:0][12:0] nine_transparent_alpha;
`INITIAL_NINE_TRANSPARENT

always_ff @ (posedge clk) begin
    is_transparent <= 1;
    for (int i = 0; i < 4; i++)
        if (beam_x >= GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i
                && beam_x < GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * (i + 1)
                && beam_y >= 22 && beam_y < 22 + DIGIT_HEIGHT)
            case (i == 0 ? score / 1000 : i == 1 ? (score / 100) % 10 : i == 2 ? (score / 10) % 10 : score % 10)
                0: begin
                    color[0] <= zero_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][0];
	    			color[1] <= zero_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][1];
	    			color[2] <= zero_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][2];
	    			is_transparent <= zero_transparent_alpha[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)];
                end
                1: begin
                    color[0] <= one_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][0];
	    			color[1] <= one_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][1];
	    			color[2] <= one_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][2];
	    			is_transparent <= one_transparent_alpha[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)];
                end
                2: begin
                    color[0] <= two_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][0];
	    			color[1] <= two_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][1];
	    			color[2] <= two_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][2];
	    			is_transparent <= two_transparent_alpha[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)];
                end
                3: begin
                    color[0] <= three_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][0];
	    			color[1] <= three_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][1];
	    			color[2] <= three_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][2];
	    			is_transparent <= three_transparent_alpha[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)];
                end
                4: begin
                    color[0] <= four_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][0];
	    			color[1] <= four_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][1];
	    			color[2] <= four_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][2];
	    			is_transparent <= four_transparent_alpha[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)];
                end
                5: begin
                    color[0] <= five_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][0];
	    			color[1] <= five_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][1];
	    			color[2] <= five_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][2];
	    			is_transparent <= five_transparent_alpha[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)];
                end
                6: begin
                    color[0] <= six_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][0];
	    			color[1] <= six_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][1];
	    			color[2] <= six_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][2];
	    			is_transparent <= six_transparent_alpha[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)];
                end
                7: begin
                    color[0] <= seven_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][0];
	    			color[1] <= seven_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][1];
	    			color[2] <= seven_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][2];
	    			is_transparent <= seven_transparent_alpha[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)];
                end
                8: begin
                    color[0] <= eight_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][0];
	    			color[1] <= eight_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][1];
	    			color[2] <= eight_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][2];
	    			is_transparent <= eight_transparent_alpha[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)];
                end
                9: begin
                    color[0] <= nine_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][0];
	    			color[1] <= nine_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][1];
	    			color[2] <= nine_transparent_rgb[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)][2];
	    			is_transparent <= nine_transparent_alpha[beam_y - 22][beam_x - (GAME_VIEW_LEFT_BORDER_X + 266 + 2 * i + DIGIT_WIDTH * i)];
                end
            endcase
end

endmodule
