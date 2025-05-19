module ultra_beam_substance_painter (
	input [2:0][3:0] doodle_color,
	input doodle_transparency,
	
	input draw,
	
	output logic [3:0] red,
	output logic [3:0] green,
	output logic [3:0] blue
);

always_comb begin
	if (draw) begin
		if (~doodle_transparency) begin
			red = doodle_color[0];
			green = doodle_color[1];
			blue = doodle_color[2];
		end else begin
			red = '1;
			green = '1;
			blue = '1;
		end
	end else begin
		red = '0;
		green = '0;
		blue = '0;
	end
end

endmodule