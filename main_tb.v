`import main.v
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
integer length_file;
integer label_file;

integer scan_file;

// inputs to main function
// vector of strings (max 160 characters per text) (max 32 bits/character)
	reg [31:0] input_data [160:0];
reg input_label;
reg input_length;

// output of main function
wire output_classification;

localparam period = 20;  

	tokenizer_module DUT(.a(input_data));

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
		label_file = $fopen(dictionary_path_list [i], "r");
		length_file = $fopen(length_path_list [i], "r");
		if (data_file == `NULL) begin
			$display("data_file handle was NULL");
		end // if
		else
			$display("data_file read successfully");
		end // else
	end // for

	scan_file = $fscanf(data_file, "%d\n", input_data); 
	scan_file = $fscanf(label_file, "%d\n", input_label); 
	scan_file = $fscanf(length_file, "%d\n", input_length); 
	if (!$feof(data_file)) begin
		
	end // if

end // initial

always @(posedge clk) begin

	#period clk = ~clk;
end // always

// add logic to check return value (ham/spam) with disctonary
// add logic to pass in diffierent hypervector instead of hard coded

// call main module
main U_main (
input_data,
input_label,
input_length,
output_classification
);

end // module

// forever begin
// end // forever

// exit simulation
// $finish
// $stop
