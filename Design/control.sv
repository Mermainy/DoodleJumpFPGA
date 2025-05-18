module control # (
	parameter int unsigned VELOCITY = 16,
	parameter int unsigned ACCELERATION = 10,
	parameter int unsigned FPS = 50,
	parameter int unsigned CLK = 50000000
) (
	input clk,
	input rst,

	input button_left,
	input button_right,
	
	output logic signed [8:0] delta_x
);

logic [$clog2(CLK / FPS):0] fps_counter; 
always_ff @ (posedge clk) begin
	if (rst) begin
		delta_x <= '0;
	end else begin
		fps_counter <= fps_counter + 1;
		if (&fps_counter) begin
			delta_x <= (-button_left + button_right) * 5;
		end
	end
end

endmodule
