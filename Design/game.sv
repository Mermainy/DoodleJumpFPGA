module game(
	input MAX10_CLK1_50,
	input [9:0] SW,
	
	output VGA_HS,
	output VGA_VS,
	
	output logic [3:0] VGA_R,
	output logic [3:0] VGA_G,
	output logic [3:0] VGA_B
);

logic clk;
logic rst;

assign rst = SW[0];

board_specific bs(
	.MAX10_CLK1_50(MAX10_CLK1_50),
	
	.clk(clk)
);

logic [10:0] beam_x;
logic [9:0] beam_y;
logic draw;

beam_establisher be(
	.clk(clk),
	.rst(rst),
	
	.beam_x(beam_x),
	.beam_y(beam_y),
	.valid(draw),

	.switch_line(VGA_HS),  // horizontal sync
	.switch_frame(VGA_VS) 
);

wire [3:0] delta_x = 0;  // -8 - 7
wire [3:0] delta_y = 0;


logic [2:0][3:0] color;


doodle d(
	.clk(clk),
	.rst(rst),
	
	.beam_x(beam_x),
	.beam_y(beam_y),
	
	.delta_x(delta_x),  // -8 - 7
	.delta_y(delta_y),
	
	.color(color)
);

always_comb begin
	    if (draw) begin
	    		VGA_R = color[0];
	    		VGA_G = color[1];
	    		VGA_B = color[2];
	    end else begin
	    	VGA_R = '0;
	    	VGA_G = '0;
	    	VGA_B = '0;
	    end
end

endmodule
