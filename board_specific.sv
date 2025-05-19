module board_specific(
	input MAX10_CLK1_50,
	input [1:0] KEY,
	input [10:0] beam_x_raw,
	input [9:0] beam_y_raw,
	
	output clk,
	output button_left,
	output button_right,
	output [10:0] beam_x,
	output [9:0] beam_y
);

assign clk = MAX10_CLK1_50;
assign button_left = ~KEY[1];
assign button_right = ~KEY[0];
assign beam_x = beam_x_raw - 159;
assign beam_y = beam_y_raw - 28;

endmodule
