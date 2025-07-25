module doodle # (
    parameter int unsigned FPS,
	parameter int unsigned CLK,
	parameter int signed EARTH,
	parameter int unsigned VELOCITY,
	parameter int unsigned ACCELERATION,
	parameter int unsigned HEIGHT,
	parameter int unsigned WIDTH,
	parameter int unsigned START_POSITION_X,
	parameter int unsigned WORLD_SHIFT,
	parameter int unsigned GAME_VIEW_LEFT_BORDER_X,
	parameter int unsigned GAME_VIEW_RIGHT_BORDER_X
) (
	input clk,
	input rst,
	input [$clog2(CLK / FPS):0] fps_counter,

	input [10:0] beam_x,
	input [9:0] beam_y,
	
	input [1:0][9:0] ground,
	input collision,
	input [1:0] game_state,
	input move_collision,

	input signed [8:0] delta_x,

	output logic [9:0] doodle_y,
	output logic [10:0] doodle_x,
	output doodle_fall_direction,

	output logic [2:0][3:0] color,
	output logic is_transparent
);



logic [79:0][79:0][2:0][3:0] doodle_left_rgb;
logic [79:0][79:0] doodle_left_alpha;
`INITIAL_DOODLE_LEFT

logic [79:0][79:0][2:0][3:0] doodle_right_rgb;
logic [79:0][79:0] doodle_right_alpha;
`INITIAL_DOODLE_RIGHT


// coloring
wire draw = doodle_x <= beam_x && beam_x < doodle_x + WIDTH - 2
		&& doodle_y <= beam_y && beam_y < doodle_y + HEIGHT - 1;
logic previous_texture_direction;  // 1 - left
always_ff @ (posedge clk) begin
	if (rst) begin
		previous_texture_direction <= 0;
	end else begin
		if (draw) begin
			if (delta_x < 0 || delta_x == 0 && previous_texture_direction) begin
				previous_texture_direction = 1;
				color[0] = doodle_left_rgb[beam_y - doodle_y][beam_x - doodle_x][0];
				color[1] = doodle_left_rgb[beam_y - doodle_y][beam_x - doodle_x][1];
				color[2] = doodle_left_rgb[beam_y - doodle_y][beam_x - doodle_x][2];
				is_transparent = doodle_left_alpha[beam_y - doodle_y][beam_x - doodle_x];
			end else begin
				previous_texture_direction = 0;
				color[0] = doodle_right_rgb[beam_y - doodle_y][beam_x - doodle_x][0];
				color[1] = doodle_right_rgb[beam_y - doodle_y][beam_x - doodle_x][1];
				color[2] = doodle_right_rgb[beam_y - doodle_y][beam_x - doodle_x][2];
				is_transparent = doodle_right_alpha[beam_y - doodle_y][beam_x - doodle_x];
			end
		end else begin 
			is_transparent = 1; 
			previous_texture_direction = previous_texture_direction;
		end
	end
end

logic [7:0] jump_counter;
logic [3:0] move_counter;
logic [9:0] doodle_y_prev;
// positioning
always_ff @ (posedge clk) begin
	if (rst) begin
		doodle_x <= START_POSITION_X;
		doodle_y <= EARTH - HEIGHT - 1;
		doodle_y_prev <= EARTH - HEIGHT - 1;
		jump_counter <= '0;
		move_counter <= '0;
	end else if (game_state == 1) begin
		if (&fps_counter) begin
			if (doodle_x <= GAME_VIEW_LEFT_BORDER_X - WIDTH / 2)
				doodle_x <= GAME_VIEW_RIGHT_BORDER_X - WIDTH / 2 - 1;
			else if (doodle_x >= GAME_VIEW_RIGHT_BORDER_X - WIDTH / 2)
				doodle_x <= GAME_VIEW_LEFT_BORDER_X - WIDTH / 2 + 1;
			else 
				doodle_x <= $signed(doodle_x) + delta_x;
			if (collision) begin
			    doodle_y_prev <= ground[0] - HEIGHT - 1;
				doodle_y <= ground[0] - HEIGHT - 1;
				jump_counter <= 1;
			end else begin
			    doodle_y_prev <= doodle_y;
				doodle_y <= ground[0] - HEIGHT
				    - VELOCITY * jump_counter + ACCELERATION * jump_counter * jump_counter / 100;
				jump_counter <= jump_counter + 1;
			end
			if (move_collision || move_counter) begin
                move_counter <= move_counter + 1;
                doodle_y <= doodle_y + WORLD_SHIFT;
            end
		end
	end else if (game_state == 2) begin
	    if (&fps_counter) begin
	        doodle_y <= ground[0] - HEIGHT - VELOCITY * jump_counter + ACCELERATION * jump_counter * jump_counter / 100;
	        if (doodle_y < EARTH)
	            jump_counter <= jump_counter + 1;
	    end
	end
end
assign doodle_fall_direction = $signed(doodle_y - doodle_y_prev) > 0;

endmodule
