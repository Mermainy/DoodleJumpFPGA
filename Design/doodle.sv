module doodle # (
    parameter int unsigned FPS,
	parameter int unsigned CLK,
	parameter int unsigned VELOCITY = 40,
	parameter int unsigned ACCELERATION = 4,
	parameter int unsigned CONST = 10
) (
	input clk,
	input rst,
	input [$clog2(CLK / FPS):0] fps_counter,

	input [10:0] beam_x,
	input [9:0] beam_y,
	
	input [1:0][9:0] ground,
	input collision,
	input [1:0] game_state,

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
wire draw = doodle_x <= beam_x && beam_x < doodle_x + 80 - 2
		&& doodle_y <= beam_y && beam_y < doodle_y + 80 - 1;
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
logic [9:0] doodle_y_prev;
// positioning
always_ff @ (posedge clk) begin
	if (rst) begin
		doodle_x <= 472;
		doodle_y <= 687;
		doodle_y_prev <= 687;
		jump_counter <= '0;
	end else if (game_state == 1) begin
		if (&fps_counter) begin
			if (doodle_x <= 300) 
				doodle_x <= 641;
			else if (doodle_x >= 642) 
				doodle_x <= 301;
			else 
				doodle_x <= $signed(doodle_x) + delta_x;
			if (collision) begin
			    doodle_y_prev <= ground[0] - 80 - 1;
				doodle_y <= ground[0] - 80 - 1;
				jump_counter <= 1;
			end else begin
			    doodle_y_prev <= doodle_y;
				doodle_y <= ground[0] - 80 - VELOCITY * jump_counter + ACCELERATION * jump_counter * jump_counter / 2;
				jump_counter <= jump_counter + 1;
			end
		end
	end
end
assign doodle_fall_direction = $signed(doodle_y - doodle_y_prev) > 0;

endmodule
