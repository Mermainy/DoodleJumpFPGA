module collision_observer(
	input clk,
	input rst,

	input signed [92:0][1:0][10:0] platforms,
	input [10:0] doodle_x,
	input [9:0] doodle_y,
	input logic [92:0] platform_activation,
	input doodle_fall_direction,
	
	output logic doodle_collision,
	output logic [1:0][9:0] ground
);

always_ff @ (posedge clk) begin
	if (rst) begin
		ground[0] <= 767;
	end else begin
		for (int i = 0; i < 93; i++) begin
			if (platform_activation[i] 
					&& platforms[i][0] <= doodle_y + 80 && doodle_y + 80 <= platforms[i][0] + 30
					&& doodle_fall_direction
					&& (platforms[i][1] - 61 <= doodle_x && doodle_x <= platforms[i][1] + 80)) begin
				ground[0] <= platforms[i][0];
				ground[1] <= platforms[i][1];
				
			end
		end
		doodle_collision <= (ground[0] <= doodle_y + 80 
					&& doodle_y + 80 <= ground[0] + 30
					&& doodle_fall_direction
					&& (ground[1] - 61 <= doodle_x 
					&& doodle_x <= ground[1] + 80  || ground[0] >= 767));
	end
end

endmodule
