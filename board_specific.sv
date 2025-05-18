module board_specific(
	input MAX10_CLK1_50,
	input [1:0] KEY,
	
	output clk,
	output button_left,
	output button_right
);

assign clk = MAX10_CLK1_50;
assign button_left = ~KEY[1];
assign button_right = ~KEY[0];

endmodule
