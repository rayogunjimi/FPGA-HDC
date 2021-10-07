`timescale 1ns / 1ps
`include "main.v"

module main_tb();
	// clk and reset initializations to synchronize modules
	reg clk = 0;
	reg reset = 0;

	// loop variable
	integer test_counter = 0;
	real correct_counter = 0;

	// register size parameters
	parameter MESSAGE_LENGTH = 160;
	parameter CHAR_LENGTH = 8;
	parameter PATH_LENGTH = 16;
	parameter NUMOF_TESTS = 8;

	// iterable file paths
	reg [CHAR_LENGTH*PATH_LENGTH-1:0] data_path_list [NUMOF_TESTS-1:0];
	reg [CHAR_LENGTH*PATH_LENGTH-1:0] tag_path_list [NUMOF_TESTS-1:0];
	reg [CHAR_LENGTH*PATH_LENGTH-1:0] length_path_list [NUMOF_TESTS-1:0];

	// input arguments to main function
	reg [CHAR_LENGTH*MESSAGE_LENGTH-1:0] inputreg_data [0:0];
	reg [1:0] inputreg_tag [0:0];
	reg [7:0] inputreg_length [0:0];

	// output parameter of main function
	wire [1:0] output_label;

	initial begin
		data_path_list[0] = "data_dir/0";
		data_path_list[1] = "data_dir/1";
		data_path_list[2] = "data_dir/2";
		data_path_list[3] = "data_dir/3";
		data_path_list[4] = "data_dir/4";
		data_path_list[5] = "data_dir/5";
		data_path_list[6] = "data_dir/6";
		data_path_list[7] = "data_dir/7";
		//data_path_list[8] = "data_dir/8";
		//data_path_list[9] = "data_dir/9";

		tag_path_list[0] = "tag_dir/0";
		tag_path_list[1] = "tag_dir/1";
		tag_path_list[2] = "tag_dir/2";
		tag_path_list[3] = "tag_dir/3";
		tag_path_list[4] = "tag_dir/4";
		tag_path_list[5] = "tag_dir/5";
		tag_path_list[6] = "tag_dir/6";
		tag_path_list[7] = "tag_dir/7";
		//tag_path_list[8] = "tag_dir/8";
		//tag_path_list[9] = "tag_dir/9";

		length_path_list[0] = "length_dir/0";
		length_path_list[1] = "length_dir/1";
		length_path_list[2] = "length_dir/2";
		length_path_list[3] = "length_dir/3";
		length_path_list[4] = "length_dir/4";
		length_path_list[5] = "length_dir/5";
		length_path_list[6] = "length_dir/6";
		length_path_list[7] = "length_dir/7";
		//length_path_list[8] = "length_dir/8";
		//length_path_list[9] = "length_dir/9";

		repeat (NUMOF_TESTS) begin
			$readmemb(data_path_list [test_counter],inputreg_data);
			$readmemb(tag_path_list [test_counter],inputreg_tag);
			$readmemb(length_path_list [test_counter],inputreg_length);
			#1000;
			$display("expected label = %b", inputreg_tag[0]);
			$display("actual label = %b", output_label);
			if (-1 == output_label) begin
				$display("Incloncluive results.\n");
			end
			else if (inputreg_tag[0] == output_label) begin
				$display("Results match.\n");
				correct_counter = correct_counter + 1;
			end
			else if (inputreg_tag[0] != output_label) begin
				$display("Results do not match.\n");
			end
			test_counter = test_counter + 1;
		end // repeat
		$display("accuracy = %2.2f", (correct_counter/NUMOF_TESTS)*100, "%");
	end // initial

	main dut (
	.msg (inputreg_data[0]),
	.length (inputreg_length[0]),
	.label (inputreg_tag[0]),
	.clk (clk),
	.reset (reset),
	.result (output_label)
	);

	// @TODO
	// Add logic to check label and output parameter & remove input label input
	// Add logic to include HAM/SPAM hyper-vectors as input

endmodule // main_tb