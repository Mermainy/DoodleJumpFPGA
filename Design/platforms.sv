module platforms # (
    parameter int unsigned FPS,
	parameter int unsigned CLK,
	parameter int signed EARTH,
	parameter int unsigned WORLD_SHIFT,
	parameter int signed PLATFORM_HEIGHT,
	parameter int signed PLATFORM_WIDTH
) (
	input clk,
	input rst,
	input [$clog2(CLK / FPS):0] fps_counter,

	input [10:0] beam_x,
	input [9:0] beam_y,
	
	input [9:0] doodle_y,
	input [10:0] doodle_x,

	input move_collision,
	
	output logic signed [89:0][1:0][10:0] platforms,
	output logic [89:0] platform_activation,
	
	output logic [2:0][3:0] color,
	output logic is_transparent
);

logic [14:0] random_sides;
random_sonya_coin sonya_coin(
	.clk(clk),
	.rst(rst),
	
	.corrected_fibonacci_LSFR(random_sides)
);

logic [3:0] move_counter;
localparam [89:0] random_start =
    90'b000000000000000010100000000000000010000100000001010000000010000000001000000000000110000100;
always_ff @ (posedge clk)
	if (rst) begin
	    move_counter <= '0;
	    platforms <= '0;
	    platform_activation <= '0;

		for (int i = 0; i < 30; i++)
			for (int j = 0; j < 3; j++) begin
				platforms[i * 3 + j][0] <= -132 + i * 30;
				platforms[i * 3 + j][1] <= 342 + j * 114;
			end
		platform_activation <= random_start;
    end else if (&fps_counter) begin
        for (int j = 0; j < 6; j++)
            for (int i = j * 15; i < (j + 1) * 15; i++) begin
                if ($signed(platforms[j * 15][0]) == EARTH) begin
                    platform_activation[i] <= random_sides[i - (j * 15)];
                    if (move_collision || move_counter)
                        platforms[i][0] <= platforms[i][0] - 900 + WORLD_SHIFT;
		    	    else
		    	        platforms[i][0] <= platforms[i][0] - 900;
		    	end else if (move_collision || move_counter)
                    platforms[i][0] <= platforms[i][0] + WORLD_SHIFT;
            end
        if (move_collision || move_counter)
            move_counter <= move_counter + 1;
    end

logic [89:0] draw;
genvar i;
generate 
	for (i = 0; i < 90; i++) begin: name
		assign draw[i] =  $signed(platforms[i][1]) <= $signed(beam_x)
		    && $signed(beam_x) <= $signed(platforms[i][1]) + PLATFORM_WIDTH - 1
			&& $signed(platforms[i][0]) <= $signed(11'(beam_y))
			&& $signed(11'(beam_y)) <= $signed(platforms[i][0]) + PLATFORM_HEIGHT - 1
			&& platform_activation[i];
	end
endgenerate

logic [29:0][99:0][2:0][3:0] platform_green_rgb;
logic [29:0][99:0] platform_green_alpha;
`INITIAL_PLATFORM_GREEN

always_ff @(posedge clk) begin
	for (int i = 0; i < 90; i++) begin
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
