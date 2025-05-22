module doodle # (
	parameter int unsigned VELOCITY = 40,
	parameter int unsigned ACCELERATION = 4,
	parameter int unsigned FPS = 50,
	parameter int unsigned CLK = 50000000,
	parameter int unsigned CONST = 10
) (
	input clk,
	input rst,
	
	input [1:0][9:0] ground,
	input [6:0] ground_id,
	
	input [10:0] beam_x,
	input [9:0] beam_y,
	
	input signed [8:0] delta_x,
	input [1:0] move_counter,
	
	output logic [9:0] doodle_y,
	output logic [10:0] doodle_x,
	output logic [2:0][3:0] color,
	output logic is_transparent,
	
	output logic led
);



logic [79:0][79:0][2:0][3:0] doodle_left_rgb;
logic [79:0][79:0] doodle_left_alpha;
`INITIAL_DOODLE_LEFT

logic [79:0][79:0][2:0][3:0] doodle_right_rgb;
logic [79:0][79:0] doodle_right_alpha;
`INITIAL_DOODLE_RIGHT

logic draw;


assign draw = doodle_x <= beam_x && beam_x < doodle_x + 80 - 2 
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

logic [$clog2(CLK / FPS):0] fps_counter; 
logic [7:0] jump_counter;
logic is_ground_moved;

logic [9:0] doodle_y_prev;
logic [9:0] ground_prev;
logic [6:0] ground_id_prev;
logic start_jumping;
// position
always_ff @ (posedge clk) begin
	if (rst) begin
		doodle_x <= 472;
		doodle_y <= 687;
		start_jumping <= 0;
		doodle_y_prev <= doodle_y;
		is_ground_moved <= 0;
		ground_id_prev <= 0;
	end else if (start_jumping) begin
		fps_counter <= fps_counter + 1;
		if (&fps_counter) begin
			ground_id_prev <= ground_id;
			ground_prev[0] <= ground[0];
			ground_prev[1] <= ground[1];
			doodle_y_prev <= doodle_y;
			if (move_counter == 1)
				is_ground_moved <= 1;
			if (doodle_x <= 300) 
				doodle_x <= 641;
			else if (doodle_x >= 642) 
				doodle_x <= 301;
			else 
				doodle_x <= $signed(doodle_x) + delta_x;
			led <= ground[1] <= $signed(doodle_x) && $signed(doodle_x) <= ground[1] + 99 || ground[0] >= 767;
			if (ground[0] <= doodle_y + 80 
					&& doodle_y + 80 <= ground[0] + 30
					&& $signed(doodle_y - doodle_y_prev) > 0
					&& (ground[1] - 61 <= doodle_x 
					&& doodle_x <= ground[1] + 80  || ground[0] >= 767)) begin
				if (~(ground_id == ground_id_prev && is_ground_moved && ground[0] == ground_prev[0] && ground[1] == ground_prev[1])) begin
					doodle_y <= ground[0] - 80 - 1;
					jump_counter <= 1;
					is_ground_moved <= 0;
				end 
			end else begin
				doodle_y <= ground[0] - 80 - VELOCITY * jump_counter + ACCELERATION * jump_counter * jump_counter / 2;
				jump_counter <= jump_counter + 1;
			end
		end
	end else if (~start_jumping)
		start_jumping <= delta_x != 0;
end

endmodule
