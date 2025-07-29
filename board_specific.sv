module board_specific(
	input MAX10_CLK1_50,
	input [9:0] SW,
	input [1:0] KEY,

	output VGA_HS,
	output VGA_VS,
	output [3:0] VGA_R,
	output [3:0] VGA_G,
	output [3:0] VGA_B
);

game g(
	.clk(MAX10_CLK1_50),
	.rst(SW[0]),
	.button_left(~KEY[1]),
	.button_right(~KEY[0]),

	.VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B)
);

endmodule
