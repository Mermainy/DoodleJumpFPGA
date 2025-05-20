module random_sonya_coin(
	input clk,
	input rst,
	
	output logic [15:0] fibonacci_LSFR
);

always_ff @ (posedge clk) begin
  if (rst)
    fibonacci_LSFR <= 16'b0100001101001101;
  else
    fibonacci_LSFR <= {fibonacci_LSFR[14:0], fibonacci_LSFR[15] ^ fibonacci_LSFR[13] ^ fibonacci_LSFR[12] ^ fibonacci_LSFR[10]};
end


endmodule
