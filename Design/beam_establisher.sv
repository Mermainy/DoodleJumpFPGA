module beam_establisher(
	input clk,
	input rst,
	
	output logic [10:0] beam_x,
	output logic [9:0] beam_y,
	
	output logic valid,
	
	output logic switch_line,
	output logic switch_frame
);

logic _placeholder;
always_ff @ (posedge clk) begin
	if (rst) begin
		beam_x <= '0;
		beam_y <= '0;
		valid <= 0;
		switch_line <= 1;
		switch_frame <= 1;
		_placeholder <= 0;
	end else begin
	    if (beam_x == 0) begin
	    	switch_line <= 1;
	    	beam_x <= beam_x + 1;
	    	beam_y <= beam_y + 1;
	    end else
	    	beam_x <= beam_x + 1;
	    if (beam_y >= 28 && beam_y <= 795)
	    	if (beam_x == 159)  // waited for the back porch
	    		valid <= 1;
	    	else if (beam_x == 1183)  // waited for the visible area
	    		valid <= 0;
	    if (beam_x == 1207)  // waited for the front porch
	    	switch_line <= 0;
	    else if (beam_x == 1343)  // waited for the switching
	    	beam_x <= '0;
	    	
	    if (beam_y == 0)
	    	switch_frame <= 1;
	    if (beam_y == 28)  // waited for the back porch
	    	_placeholder <= 0;
	    else if (beam_y == 796)  // waited for the visible area
	    	_placeholder <= 1;
	    else if (beam_y == 799)  // waited for the front porch
	    	switch_frame <= 0;
	    else if (beam_y == 805)  // waited for the switching
	    	beam_y <= '0;

	end
end



endmodule