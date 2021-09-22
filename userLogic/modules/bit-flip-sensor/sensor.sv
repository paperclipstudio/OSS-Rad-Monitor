module sensor 
	(
	output logic error,
	input clk,
	input logic inc_data
);
	parameter size=0;
	parameter splits = 8;
	parameter nothing = 0;
	genvar i;
	
	initial begin
		error = 0;
	end

	generate 
		// leaf senstive to bitflips in array
		int to_split, between;
		if (size <= splits) begin
			reg [size:0] state = 0;
		
			always_ff@(posedge clk) begin
				error <= &state;
				//state += inc_data;
			end
		end
		// node sensitive to bitflips in children
		else begin
			// Create {split} children, and spilt the task of watching 
			// {size} bits
			// and watch them for errors
			wire [splits-1:0] error_bus;
			reg [splits-1:0] error_out;
			
			

			for (i=0; i < splits; i++) begin : create_children
				// i holds the number of children left to split between
			int new_size = size / splits;

				sensor #(.size(new_size )) child (error_bus[i], clk, inc_data);
			end
			
	
			always_ff@(posedge clk) begin
				error <= &error_bus;
			end
	
		end
	endgenerate
endmodule
		
