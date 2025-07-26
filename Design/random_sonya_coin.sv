module random_sonya_coin(
	input clk,
	input rst,

	output [14:0] corrected_fibonacci_LSFR
);

logic [14:0][15:0] fibonacci_LSFR;
always_ff @ (posedge clk) begin
    if (rst) begin
        fibonacci_LSFR[0] <= 16'b1001001110100111;
        fibonacci_LSFR[1] <= 16'b1110111001101001;
        fibonacci_LSFR[2] <= 16'b1100000111111011;
        fibonacci_LSFR[3] <= 16'b1111001101010111;
        fibonacci_LSFR[4] <= 16'b0101010100100000;
        fibonacci_LSFR[5] <= 16'b1000000100111101;
        fibonacci_LSFR[6] <= 16'b0100000010011110;
        fibonacci_LSFR[7] <= 16'b1100100000010011;
        fibonacci_LSFR[8] <= 16'b0111001000000100;
        fibonacci_LSFR[9] <= 16'b1010101011100100;
        fibonacci_LSFR[10] <= 16'b1010101010111001;
        fibonacci_LSFR[11] <= 16'b0110101010101110;
        fibonacci_LSFR[12] <= 16'b1101100000010101;
        fibonacci_LSFR[13] <= 16'b0110110000001010;
        fibonacci_LSFR[14] <= 16'b1011011000000101;

    end else begin
       for (int i = 0; i < 15; i++)
           fibonacci_LSFR[i] <= {fibonacci_LSFR[i][14:0],
               fibonacci_LSFR[i][15] ^ fibonacci_LSFR[i][13] ^ fibonacci_LSFR[i][12] ^ fibonacci_LSFR[i][10]};
    end
end

wire [4:0][15:0] merged_fibonacci_LSFR;
always_comb begin
    corrected_fibonacci_LSFR = 15'b100000000000010;
    for (int i = 0; i < 5; i++) begin
        merged_fibonacci_LSFR[i] = fibonacci_LSFR[i * 3] & fibonacci_LSFR[i * 3 + 1] & fibonacci_LSFR[i * 3 + 2];
        if (merged_fibonacci_LSFR[i][15:13] != 3'b000 && merged_fibonacci_LSFR[i][3:1] != 3'b000)
            corrected_fibonacci_LSFR = merged_fibonacci_LSFR[i][15:1];
    end
end

endmodule
