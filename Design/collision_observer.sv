module collision_observer(
	input clk,
	input rst,

	input signed [92:0][1:0][10:0] platforms,
	input [11:0] doodle_x,
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
		for (int i = 0; i < 93; i++) begin
			if (platforms[i][0] <= doodle_y + 80 && doodle_y + 80 <= platforms[i][0] + 30  /*&& (platforms[i][1] - 51 <= doodle_x
			&& doodle_x <= platforms[i][1] + 99 || ground[0] == 767)*/ && $signed(doodle_y) - $signed(doodle_y_prev) > 0
			&& platform_activation[i]) begin
				ground <= platforms[i];
			end
		end
	end
end

endmodule
