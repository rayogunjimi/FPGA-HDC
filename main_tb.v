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
	parameter MESSAGE_LENGTH = 200;
	parameter CHAR_LENGTH = 8;
	parameter PATH_LENGTH = 16;
	parameter NUMOF_TESTS = 50;

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

	integer data_inputs, tag_inputs, length_inputs;
    integer scan_data_inputs, scan_tag_inputs, scan_length_inputs;

	initial begin

		data_inputs = $fopen("input_path_list/data_path.txt", "r");
		tag_inputs = $fopen("input_path_list/tag_path.txt", "r");
		length_inputs = $fopen("input_path_list/length_path.txt", "r");
        if (data_inputs == 0 || tag_inputs == 0 || length_inputs == 0) begin               //If inputs file is not found
            $display("Open files with ERROR");
            $finish;
        end

		repeat (NUMOF_TESTS) begin
			scan_data_inputs = $fscanf(data_inputs, "%s\n", data_path_list[test_counter]);
			scan_tag_inputs = $fscanf(tag_inputs, "%s\n", tag_path_list[test_counter]);
			scan_length_inputs = $fscanf(length_inputs, "%s\n", length_path_list[test_counter]);
            $display ("Data :[inputs: %s]", data_path_list[test_counter]);

			$readmemb(data_path_list [test_counter],inputreg_data);
			$readmemb(tag_path_list [test_counter],inputreg_tag);
			$readmemb(length_path_list [test_counter],inputreg_length);
			#10000;
			$display("expected label = %b", inputreg_tag[0]);
			$display("actual label = %b", output_label);
			if (-1 == output_label) begin
				$display("inclonclusive results.\n");
			end
			else if (inputreg_tag[0] == output_label) begin
				$display("results match.\n");
				correct_counter = correct_counter + 1;
			end
			else if (inputreg_tag[0] != output_label) begin
				$display("results do not match.\n");
			end
			test_counter = test_counter + 1;
		end // repeat
		$display("accuracy = %2.2f%%", (correct_counter/NUMOF_TESTS)*100);

		$fclose(data_inputs);
		$fclose(tag_inputs);
		$fclose(length_inputs);
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
