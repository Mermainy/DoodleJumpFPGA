module random_sonya_coin(
	input clk,
	input rst,

	output logic [14:0] corrected_fibonacci_LSFR
);

logic [2:0][15:0] fibonacci_LSFR;
always_ff @ (posedge clk) begin
  if (rst) begin
    fibonacci_LSFR[0] <= 16'b1001001110100111;
    fibonacci_LSFR[1] <= 16'b1110111001101001;
    fibonacci_LSFR[2] <= 16'b1100000111111011;
    corrected_fibonacci_LSFR <= '0;
  end else begin
    for (int i = 0; i < 3; i++)
        fibonacci_LSFR[i] <= {fibonacci_LSFR[i][14:0], fibonacci_LSFR[i][15] ^ fibonacci_LSFR[i][13] ^ fibonacci_LSFR[i][12] ^ fibonacci_LSFR[i][10]};
    corrected_fibonacci_LSFR <= fibonacci_LSFR[0] & fibonacci_LSFR[1] & fibonacci_LSFR[2];
	 end
end


endmodule
