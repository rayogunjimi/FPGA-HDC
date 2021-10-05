`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module fpga_hdc_tb()

// clk and reset initializations to synchronize modules
reg clk = 0;
reg reset = 0;

// loop variable
integer i;

// number of tests
integer numof_tests = 10;

// file paths
string test_path_list [0:numof_tests-1];

// file read handling
integer data_file;
integer scan_file;

// vector of strings (max 160 characters per text) (max 32 bits/character)
reg [31:0] input_vector [160:0];

localparam period = 20;  

tokenizer_module DUT(.a(input_vector));

initial begin
	// file paths
	test_path_list[0] = test_data/0.txt;
	test_path_list[1] = test_data/1.txt;
	test_path_list[2] = test_data/2.txt;
	test_path_list[3] = test_data/3.txt;
	test_path_list[4] = test_data/4.txt;
	test_path_list[5] = test_data/5.txt;
	test_path_list[6] = test_data/6.txt;
	test_path_list[7] = test_data/7.txt;
	test_path_list[8] = test_data/8.txt;
	test_path_list[9] = test_data/9.txt;
	
	for(i = 0; i < numof_tests; i = i + 1) begin
		data_file = $fopen(test_path_list [i], "r");
		if (data_file == `NULL) begin
			$display("data_file handle was NULL");
		end // if
		else
			$display("data_file read successfully");
		end // else
	end // for

	scan_file = $fscanf(data_file, "%d\n", input_vector); 
	if (!$feof(data_file)) begin
		
	end

end // initial

always @(posedge clk) begin

	#period clk = ~clk;
end

// forever begin
// end // forever

// add logic to check return value (ham/spam) with disctonary
 
end // module

// exit simulation
// $finish
// $stop
