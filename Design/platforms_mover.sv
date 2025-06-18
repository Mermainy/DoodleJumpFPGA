module platforms_mover(
	input clk,
	input rst,
	input [10:0] doodle_x,
	input [9:0] doodle_y,
	input [1:0][9:0] ground,

	output logic [9:0] delta
	
	
);

always_ff @(posedge clk) begin
	if (rst) begin
		delta <= '0;
	end else begin
		if (ground[0] <= doodle_y + 80 && doodle_y + 80 <= ground[0] + 30 
					&& (ground[1] - 61 <= doodle_x && doodle_x <= ground[1] + 80  || ground[0] >= 767)) begin
					if (doodle_y <= 520) 
						delta <= 520 - doodle_y;
					else delta <= '0;
		end else delta <= '0;
	end
end

endmodule
