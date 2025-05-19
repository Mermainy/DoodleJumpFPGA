module platforms(
	input clk,
	input rst,
	
	output logic [9:0] led,

	input [10:0] beam_x,
	input [9:0] beam_y,

	output logic signed [92:0][1:0][10:0] platforms,
	output logic [92:0] platform_activation,
	
	output logic [2:0][3:0] color,
	output logic is_transparent
);

logic [29:0][99:0][2:0][3:0] platform_green_rgb;
logic [29:0][99:0][2:0][3:0] platform_green_alpha;
`INITIAL_PLATFORM_GREEN

logic [92:0] draw;
logic  [6:0] here_platform_was_generated;

/*assign platforms[0][1] = 342;
assign platforms[0][0] = 500;
assign platform_activation[0] = 1;*/
always_ff @ (posedge clk) begin
	if (rst) begin
		for (int i = 0; i < 31; i++)
			for (int j = 0; j < 3; j++) begin
				platforms[i * 3 + j][0] <= -162 + i * 30;
				platforms[i * 3 + j][1] <= 342 + j * 114;	
			end
		// random activation (6 fors + control)
		/*for (int j = 0; j < 7; j++)
			for (int i = 0; i < (j < 6 ? 15 : 3); i++) begin
				if (i == (j < 6 ? 14 : 2) && ~here_platform_was_generated[j])
					platform_activation[i] <= 1;
				else begin
					platform_activation[i] <= 1;//$random(0);
					if (i == 0) here_platform_was_generated[j] <= platform_activation[i];
					else here_platform_was_generated[j] <= here_platform_was_generated[j] || platform_activation[i];
				end
				
			end*/
			platform_activation <= '1;
	end else begin
		led[0] <= platforms[0][0] > 0;
	end
end

genvar i;
generate 
	for (i = 0; i < 93; i++) begin: name
		assign draw[i] = platforms[i][1] <= beam_x && beam_x <= platforms[i][1] + 100 - 1
			&& platforms[i][0] <= beam_y && beam_y <= platforms[i][0] + 30 - 1 && platform_activation[i];
	end
endgenerate

always_ff @(posedge clk) begin
	for (int i = 0; i < 93; i++) begin 
		if (draw[i]) begin 
			color[0] = platform_green_rgb[beam_y - platforms[i][0]][beam_x - platforms[i][1]][0];
			color[1] = platform_green_rgb[beam_y - platforms[i][0]][beam_x - platforms[i][1]][1];
			color[2] = platform_green_rgb[beam_y - platforms[i][0]][beam_x - platforms[i][1]][2];
			is_transparent = platform_green_alpha[beam_y - platforms[i][0]][beam_x - platforms[i][1]];
		end 
	end
	if (~|draw) begin 
		is_transparent = 1; 
		color = '1;
	end
end

endmodule
