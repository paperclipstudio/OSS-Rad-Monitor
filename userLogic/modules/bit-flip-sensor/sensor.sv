module sensor 
	(
	output logic error,
	input clk,
  input data
);
	parameter depth=0;
	parameter split_count = 8;
	genvar i;
	
	initial begin
		error = 0;
	end

	generate 
		// leaf senstive to bitflips in array
		if (depth <= 0) begin
			always_ff@(posedge clk) begin
				error <= &data;
			end
		end
		// node sensitive to bitflips in children
		else begin
				int total_data_length = split_count**depth;
				int block_size = total_data_length / split_count;
			wire [split_count-1:0] error_bus;
			reg [split_count-1:0] error_out;
			for (i=0; i < split_count; i++) begin : create_children
				int data_start = i * block_size;
							int data_end = data_start + block_size - 1;

				sensor #(.depth(depth-1), .split_count(split_count)) 
							child (error_bus[i], 
											clk, 
											data[data_end:data_start]
							);
			end
	
			always_ff@(posedge clk) begin
				error <= &error_bus;
			end
	
		end
	endgenerate
endmodule
		
