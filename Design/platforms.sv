module platforms # (
    parameter int unsigned FPS,
	parameter int unsigned CLK,
	parameter int signed EARTH
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

logic [29:0][99:0][2:0][3:0] platform_green_rgb;
logic [29:0][99:0] platform_green_alpha;
`INITIAL_PLATFORM_GREEN

logic [14:0] random_sides;
random_sonya_coin sonya_coin(
	.clk(clk),
	.rst(rst),
	
	.corrected_fibonacci_LSFR(random_sides)
);

logic [3:0] move_counter;
logic [2:0] platform_teleportation_timer;
localparam [89:0] random_start = 90'b000000000000000010100000000000000010000100000001010000000010000000001000000000000110000100;
//localparam [89:0] random_start = 90'b000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000;
always_ff @ (posedge clk)
	if (rst) begin
	    move_counter <= '0;
	    platform_teleportation_timer <= 1;
	    platforms <= '0;
	    platform_activation <= '0;

		for (int i = 0; i < 30; i++)
			for (int j = 0; j < 3; j++) begin
				platforms[i * 3 + j][0] <= -162 + i * 30;
				platforms[i * 3 + j][1] <= 342 + j * 114;	
			end
		platform_activation <= random_start;
    end else if (&fps_counter) begin
        if (move_collision || move_counter) begin
            move_counter <= move_counter + 1;
            for (int i = 0; i < 90; i++)
                platforms[i][0] <= platforms[i][0] + 12;
        end

        for (int j = 0; j < 6; j++)
            if ($signed(platforms[j * 15][0]) >= EARTH) begin
                for (int i = j * 15; i < (j + 1) * 15; i++) begin
                    if (i == (j + 1) * 15 - 1 && ~random_sides)
		    			platform_activation[i] <= 1;
		    		else
		    			platform_activation[i] <= random_sides[i - (j * 15)];
		    	    platforms[i][0] <= platforms[i][0] - 948;
		    	end
            end
    end

logic [89:0] draw;
genvar i;
generate 
	for (i = 0; i < 90; i++) begin: name
		assign draw[i] =  $signed(platforms[i][1]) <= $signed(beam_x) && $signed(beam_x) <= $signed(platforms[i][1]) + 100 - 1
			&& $signed(platforms[i][0]) <= $signed(11'(beam_y)) && $signed(11'(beam_y)) <= $signed(platforms[i][0]) + 30 - 1 && platform_activation[i];
	end
endgenerate

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
