module collision_observer (
	input clk,
	input rst,

	input signed [92:0][1:0][10:0] platforms,
	input [10:0] doodle_x,
	input [9:0] doodle_y,
	input logic [92:0] platform_activation,
	input doodle_fall_direction,

	output logic doodle_collision,
	output logic move_collision,
	output logic [1:0][9:0] ground,

	output led
);

assign led = move_collision;

always_ff @ (posedge clk)
	if (rst) begin
		ground[0] <= 767;
		doodle_collision <= 0;
		move_collision <= 0;
	end else begin
	    doodle_collision <= 0;
	    move_collision <= 0;
		for (int i = 0; i < 93; i++)
			if (platform_activation[i] 
					&& platforms[i][0] - 80 <= doodle_y && doodle_y <= platforms[i][0] - 50
					&& platforms[i][1] - 61 <= doodle_x && doodle_x <= platforms[i][1] + 80
					&& doodle_fall_direction) begin
				ground[0] <= platforms[i][0];
				ground[1] <= platforms[i][1];
				doodle_collision <= 1;
				if (ground[0] < 420)
				    move_collision <= 1;
			end
		if (ground[0] == 767 && doodle_y > 767 - 80)
		    doodle_collision <= 1;
	end

endmodule
