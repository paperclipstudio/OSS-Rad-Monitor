module sensor #(
	parameter size=64)
	(
	output logic error,
	input clk
);
	parameter splits = 8;
	genvar i;

	generate 
		// leaf senstive to bitflips in array
		int to_split, between;
		if (size < splits) begin
			genvar i;
			reg state[size:0] = 0;
			always_ff@(posedge clk) begin
				for (i=0; i<size; i++) begin
					error <= error & state[i];
				end
			end
		end
		// node sensitive to bitflips in children
		else begin
			assign to_split = size;
			// Create {split} children, and spilt the task of watching 
			// {size} bits
			// and watch them for errors
			wire error_bus[8:0];

			for (i=splits; i > 0; i--) begin
				// i holds the number of children left to split between
				
				// Calculate how much this child should watch
				int childs_size = $ceil(to_split/i);
				assign to_split = to_split - childs_size;

				sensor child #(.size=3) (error_bus[i-1], clk);
				defparam child.size = size;
				genvar j;
				always_ff@(posedge clk) begin
					for (j=0; j<size; j++) begin
						assign error = error_bus[i-1] & error;
					end
				end
			end
		end
	endgenerate
endmodule
		
