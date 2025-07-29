module control # (
	parameter int signed EARTH,
	parameter int unsigned DOODLE_HEIGHT
) (
	input clk,
	input rst,
	input calculation_time,

	input button_left,
	input button_right,
	input [9:0] doodle_y,
	
	output logic signed [8:0] delta_x,
	output logic [1:0] game_state
);


always_ff @ (posedge clk)
	if (rst) begin
		delta_x <= '0;
		game_state <= '0;
	end else if (calculation_time) begin
		delta_x <= (-button_left + button_right) * 5;
		if ((button_left || button_right) && game_state == 0)
		    game_state <= 1;
		else if (doodle_y + DOODLE_HEIGHT - 10 >= EARTH && game_state == 1)
		    game_state <= 2;
	end

endmodule
