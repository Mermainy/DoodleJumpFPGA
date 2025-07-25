module collision_observer #(
    parameter int signed EARTH,
    parameter int unsigned DOODLE_HEIGHT,
    parameter int unsigned DOODLE_WIDTH,
    parameter int unsigned PLATFORM_HEIGHT,
    parameter int unsigned PLATFORM_WIDTH,
    parameter int unsigned PLATFORM_COLLISION_HAPPENING_HEIGHT
) (
	input clk,
	input rst,

	input signed [89:0][1:0][10:0] platforms,
	input [10:0] doodle_x,
	input [9:0] doodle_y,
	input [89:0] platform_activation,
	input doodle_fall_direction,

	output logic doodle_collision,
	output logic move_collision,
	output logic [1:0][9:0] ground
);

always_ff @ (posedge clk)
	if (rst) begin
	    ground[1] <= '0;
		ground[0] <= EARTH;
		doodle_collision <= 0;
		move_collision <= 0;
	end else begin
	    doodle_collision <= 0;
	    move_collision <= 0;
		for (int i = 0; i < 90; i++)
			if (platform_activation[i] 
				    && platforms[i][0] - DOODLE_HEIGHT <= doodle_y
				    && doodle_y <= platforms[i][0] + PLATFORM_HEIGHT - DOODLE_HEIGHT
				    && platforms[i][1] - PLATFORM_WIDTH + 39 <= doodle_x
				    && doodle_x <= platforms[i][1] + DOODLE_WIDTH
				    && doodle_fall_direction) begin
				ground[0] <= platforms[i][0];
				ground[1] <= platforms[i][1];
				doodle_collision <= 1;
				if (ground[0] < PLATFORM_COLLISION_HAPPENING_HEIGHT)
				    move_collision <= 1;
			end
		if (ground[0] == EARTH && doodle_y > EARTH - DOODLE_HEIGHT)
		    doodle_collision <= 1;
	end

endmodule
