module control # (
    parameter int unsigned FPS,
	parameter int unsigned CLK
) (
	input clk,
	input rst,
	input [$clog2(CLK / FPS):0] fps_counter,

	input button_left,
	input button_right,
	
	output logic signed [8:0] delta_x,
	output logic [1:0] game_state
);


always_ff @ (posedge clk)
	if (rst) begin
		delta_x <= '0;
		game_state <= '0;
	end else if (&fps_counter) begin
		delta_x <= (-button_left + button_right) * 5;
		if (button_left || button_right)
		    game_state <= 1;
	end

endmodule
