module collision_observer(
	input clk,
	input rst,
	output logic led,
	input signed [92:0][1:0][10:0] platforms,
	input [10:0] doodle_x,
	input [9:0] doodle_y,
	input logic [92:0] platform_activation,
	
	output logic [1:0][9:0] ground
);
logic [9:0] doodle_y_prev;

always_ff @ (posedge clk) begin
	if (rst) begin
		doodle_y_prev <= doodle_y;
		ground[0] <= 767;
	end else begin
		doodle_y_prev <= doodle_y;
		for (int i = 0; i < 93; i++) begin
			if (platform_activation[i])
				led <= (platforms[i][1] <= $signed(doodle_x) && $signed(doodle_x) <= platforms[i][1] + 99);
			if (platform_activation[i] 
					&& platforms[i][0] <= doodle_y + 80 && doodle_y + 80 <= platforms[i][0] + 30
					&& $signed(doodle_y - doodle_y_prev) > 0
					&& (platforms[i][1] <= $signed(doodle_x) && $signed(doodle_x) <= platforms[i][1] + 99)) begin
				ground[0] <= platforms[i][0];
				ground[1] <= platforms[i][1];
			end
		end
	end
end

endmodule
