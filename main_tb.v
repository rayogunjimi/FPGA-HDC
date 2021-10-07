`include "main_test.v"
`timescale 1ns / 1ps

module main_tb;

// clk and reset initializations to synchronize modules
reg clk = 0;
reg reset = 0;
integer counter;

// loop variable
integer i;

// number of tests
parameter numof_tests = 10;

// length of message in characters
parameter MAX_LENGTH = 160;

// file paths
reg [8*11:0] data_path_list [numof_tests-1:0];
reg [8*10:0] tag_path_list [numof_tests-1:0];
reg [8*13:0] length_path_list [numof_tests-1:0];

// file descriptor handles
integer filedesc_data;
integer filedesc_tag;
integer filedesc_length;

integer status;

// inputs to main function
// vector of strings (max: 160 characters/text) (max: 32 bits/character)
// reg [31:0] inputreg_data [159:0];
reg [MAX_LENGTH*8-1:0] inputreg_data [0:0];
reg [MAX_LENGTH*8-1:0] inputreg_tag [0:0];
// reg inputreg_tag;
reg [7:0] inputreg_length [0:0];


// output of main function
wire [1:0] output_label;

main U_main(
.msg (inputreg_data[0]),
.length (inputreg_length[0]),
.label (inputreg_tag[0]),
.clk (clk),
.reset (reset),
.result (output_label)
);

// initial begin
//   	clk = 1'b0;
// 	forever #1 clk=~clk;
// end

initial begin
	counter = 0;

	data_path_list[0] = "data_dir/0";
	data_path_list[1] = "data_dir/1";
	data_path_list[2] = "data_dir/2";
	data_path_list[3] = "data_dir/3";
	data_path_list[4] = "data_dir/4";
	data_path_list[5] = "data_dir/5";
	data_path_list[6] = "data_dir/6";
	data_path_list[7] = "data_dir/7";
	data_path_list[8] = "data_dir/8";
	data_path_list[9] = "data_dir/9";
	
	tag_path_list[0] = "tag_dir/0";
	tag_path_list[1] = "tag_dir/1";
	tag_path_list[2] = "tag_dir/2";
	tag_path_list[3] = "tag_dir/3";
	tag_path_list[4] = "tag_dir/4";
	tag_path_list[5] = "tag_dir/5";
	tag_path_list[6] = "tag_dir/6";
	tag_path_list[7] = "tag_dir/7";
	tag_path_list[8] = "tag_dir/8";
	tag_path_list[9] = "tag_dir/9";

	length_path_list[0] = "length_dir/0";
	length_path_list[1] = "length_dir/1";
	length_path_list[2] = "length_dir/2";
	length_path_list[3] = "length_dir/3";
	length_path_list[4] = "length_dir/4";
	length_path_list[5] = "length_dir/5";
	length_path_list[6] = "length_dir/6";
	length_path_list[7] = "length_dir/7";
	length_path_list[8] = "length_dir/8";
	length_path_list[9] = "length_dir/9";

	/*	
	for(i = 0; i < numof_tests; i = i + 1) begin
		filedesc_data = $fopen(data_path_list [i], "r");
		filedesc_tag = $fopen(tag_path_list [i], "r");
		filedesc_length = $fopen(length_path_list [i], "r");
	end // for
	*/

	//filedesc_data = $fopen(data_path_list [0], "r");
	//filedesc_tag = $fopen(tag_path_list [0], "r");
	//filedesc_length = $fopen(length_path_list [0], "r");

	//status = $fscanf(filedesc_data, "%b", inputreg_data); 
	//status = $fscanf(filedesc_tag, "%b", inputreg_tag); 
	///tatus = $fscanf(filedesc_length, "%b", inputreg_length); 

	//filedesc_data = $fclose(data_path_list [0], "r");
	//filedesc_tag = $fclose(tag_path_list [0], "r");
	//filedesc_length = $fclose(length_path_list [0], "r");

	repeat (10) begin
		$readmemb(data_path_list [counter],inputreg_data);
		$readmemb(tag_path_list [counter],inputreg_tag);
		$readmemb(length_path_list [counter],inputreg_length);
		#1000;
		counter = counter + 1;
	end

end // initial
// @TODO
// Remove input label
// Add logic to check label and output parameter
// Add logic to include HAM/SPAM hyper-vectors as input

endmodule



// if (!$feof(filedesc_data)) begin	
// end // if
// `timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps
// localparam period = 20;  
// tokenizer_module DUT(.a(inputreg_data));

// always @(posedge clk) begin

// 	#period clk = ~clk;
// end // always

// forever begin
// end // forever

// exit simulation
// $finish
// $stop
