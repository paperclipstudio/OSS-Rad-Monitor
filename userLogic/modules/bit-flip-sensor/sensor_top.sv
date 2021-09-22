module sensor_top(
	input logic clk, 
	output logic error,
	input logic inc_data
	);
	sensor sen(.clk(clk), .error(error), .inc_data(inc_data));
		defparam sen.size = 512;
endmodule