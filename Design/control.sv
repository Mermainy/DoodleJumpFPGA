module control # (
    parameter int unsigned FPS,
	parameter int unsigned CLK,
	parameter int signed EARTH,
	parameter int unsigned DOODLE_HEIGHT
) (
	input clk,
	input rst,
	input [$clog2(CLK / FPS):0] fps_counter,

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
	end else if (&fps_counter) begin
		delta_x <= (-button_left + button_right) * 5;
		if ((button_left || button_right) && game_state == 0)
		    game_state <= 1;
		else if (doodle_y + DOODLE_HEIGHT - 10 >= EARTH && game_state == 1)
		    game_state <= 2;
	end

endmodule
