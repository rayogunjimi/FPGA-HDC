`timescale 1ns / 1ps

module main (msg, length, label, clk, reset, result);
    // reg [1023:0] msgVector = 1024'h24c3b3f3ddb7ff8dec0c815c860e97ce29829c0cb677defaca09155439e81c4e554b5b4573e530b6d8c81c8a3d7faea63fdce5a5c1feacad2daf80a8913962bbc23dbb1ad2ea7ff7a1c79059a30b91554ef1ffaa9f5521c137dfcc8b5c2561c7485788b598afcd170aefd09e69654c36a6503f80f5563b4b37147fc3a909717d;
    // reg [9999:0] spamVector = 10000'h000001d200000252fffffe2800000254fffffe62fffffdb60000024a00000254fffffe18fffffdaefffffdbcfffffdacfffffdacffffff72fffffdae00000254fffffe1afffffdb0fffffff6000001fafffffdc6fffffdb2fffffdb400000250fffffdac00000254fffffeb0fffffdacfffffdc400000200000001d400000254fffffdb8fffffe8a00000252fffffdac0000024cfffffdca00000252fffffdd2fffffdac000001a2ffffffbcfffffdc2000001f4000002540000024effffff52fffffdb400000250fffffdacfffffdb00000023c0000007afffffe1affffffbefffffdc200000252000002340000010c0000023000000182fffffdca00000228fffffdacfffffdb200000240fffffdb00000023efffffdacfffffe16fffffdac00000254fffffdb00000025200000252000001befffffdb4000000b800000250000000a20000024afffffdacfffffdaefffffdacfffffddc00000252fffffdbe00000232fffffe02fffffdcc000000100000023afffffddc0000025000000200fffffdacfffffe70fffffdb200000254ffffffa8fffffdbc0000020cfffffed000000254fffffdae000001d20000023cfffffdae00000252fffffffcfffffdacfffffdac00000254000000b6fffffdac0000025400000246fffffdac00000254000002520000025200000250fffffe42fffffe3cfffffdbe000001cc00000196ffffff9a0000020c000001c0ffffffccfffffebe00000194fffffe280000023efffffe9e0000022effffff0cfffffdb00000023c0000002000000224fffffdb20000025400000252fffffe4c0000022cfffffdf6fffffdb0fffffdaefffffdae000002540000021e000002500000020200000210fffffdb0000002500000019e0000025000000254000001ccfffffdfa000002520000016cfffffefafffffdae00000252fffffdb0000000a4fffffdc8fffffdbafffffdacfffffdd800000200fffffdc00000025400000254fffffdaefffffde2fffffe48ffffff0afffffe2e0000025400000250fffffdac0000024c0000024c000002520000025000000254fffffdaefffffdac000001d8fffffdb000000254fffffdbc0000022200000252000001fa00000182000000b8fffffdf2000002440000009efffffdac0000024e000001b8000000f8fffffe40fffffdb40000015c00000246fffffdac0000008e000001b40000025200000252000001d40000016efffffe92fffffdb00000023e00000254000002440000024c00000246000002140000024efffffdb2fffffeb6fffffdac0000023efffffdfa000002540000025400000250ffffff2c00000254ffffffbcfffffdbe000001ae0000025200000252fffffdae0000017200000246000001740000001cfffffdce0000008afffffdae00000242fffffdd6ffffff7c00000228000001d0000002540000003efffffdb0fffffef8fffffe58000002520000025400000240fffffdae00000228fffffdbafffffdb20000021200000252ffffff34fffffdbcfffffebefffffdb0fffffdaefffffdb0fffffedafffffdacfffffdacfffffdaefffffdae0000025200000254fffffdac000001eafffffdae0000024c0000024e00000254fffffe22fffffdacfffffe3800000244fffffdac0000024a000000fcfffffee0000001f80000000c000002540000020400000252fffffdacfffffdacfffffdac00000254000000f000000246ffffffe000000254ffff;
    // reg [9999:0] hamVector = 10000'h00000bfd00000e8bfffff45900000e3900000971fffff0fd000009bd00000a3700000af9fffff3ad00000ce3fffff1efffffff5bfffff80300000e3bfffff0ef00000e6900000e7b00000df300000d8100000e51fffff0ebffffff55fffff13900000e13fffff0ff0000029300000bdbfffff0f1fffff0ebfffff19b00000e77fffff0ebfffff1f3fffff611000001b700000e2d00000da900000c6ffffff2d300000e7b000004bbfffff3b9fffff11bfffff0ef00000e8bfffff1f1fffff19b0000064700000e8500000e3900000e45fffff467fffff11700000e5dfffff0fd00000caf0000021dfffff11b00000dbffffff103fffff5f100000d2d0000000900000d5b00000e1100000b1300000d7bfffff183fffff0ed00000e6b00000aa7fffff1e700000ce3fffffb67fffff24100000e8b000003edfffff181fffff4b500000e9300000abbfffffc35fffff8b700000b03fffff3e700000d0ffffff5b5fffff14d0000081900000df5fffff265fffff19500000103fffff0fd00000e5dfffffbb300000e2700000e45fffff9f900000cd7fffff30900000e8dfffff455fffff11b00000ddbfffff123fffff0ef00000acd00000e8900000e8f00000e8900000e0900000e29fffff7a5fffff33b00000dfb00000c67000004d500000c9500000db7fffffd69fffffa4ffffff829fffffae100000de7fffff10ffffffd0900000e8bfffff153fffff19700000e5ffffff0f70000083ffffff151fffff75300000963fffff30900000a5dfffff10100000e5dfffff103fffff2d700000a83fffff1cbfffff11300000dd30000083ffffffa7900000cbd00000e91000007a9000004c500000e6f00000e5f00000491fffff0f7fffff537fffff783fffffd1bfffff18bfffffff90000022bfffff1230000081100000d3100000e7d00000399fffff3950000085500000e41fffff459fffff0eb00000e15fffff10300000c51fffff2b1fffff0fb00000ab9000000fdfffff2f1fffff55100000d91fffff235000009ebfffff127fffffdbd00000cb3fffffde1fffff2d900000bd900000e6bfffff32900000df9000009abfffff91700000e23fffff20500000e33fffff1c9fffff6170000005dfffff10100000b45fffff145fffff46500000d8dfffff19700000def0000047f00000e0100000d33fffff18bfffff0ef00000e3b00000e4ffffff1e10000082f00000e89fffff27ffffff40700000e77fffff0f3fffff671fffff509fffff2f300000a57fffff109fffff6db0000069bfffff113000004310000020100000dd1fffff0f3fffff101fffff5e3fffff15ffffff4ed00000e8d00000cd3000008c500000c35fffff411fffff0ebfffff477fffff12f00000df300000cfb00000d5f00000b9300000e7dfffff29700000a63fffffe59fffff10d00000acd00000e75fffff127ffffff050000011bfffff115fffff0f3fffff209fffff285ffffffb900000b7dfffff129fffff129fffff0fffffff1adfffff0eb00000c77fffff1c1fffff223fffff59500000df700000d1100000e3dfffff14500000dd7fffff1a700000e6ffffff42700000c7500000b1b00000e8300000b9b00000e7700000b7900000e9300000e49fffff0f7fffffc13fffff197fffff49b00000e7dfffff117fffff317fffff1bf000008a7fffff12d00000e93fffff83dfffff3d5fffff30700000d3ffffff177fffff17dfffff4f900000e6ffffff0efffff;
    // reg signed [1:0] result;
    parameter MAX_LENGTH = 160;
    parameter NUM_CHAR = 37;
    parameter DIM = 10000;
    parameter BITS_PER_CHAR = 8;
    input[MAX_LENGTH*8-1:0] msg;
    input[7:0] length;
    input[1:0] label;
    input clk, reset;

    output reg signed [1:0] result;
    // parameter length = 20;

    integer i;
    integer seed = 13;
    real sum;
    real avg;

    // reg[MAX_LENGTH*7:0] char; // used for testing part of code only, use the input msg for testbench
    reg[7:0] letter;
    reg[7:0] lower_letter;
    reg signed[31:0] HV[DIM-1:0];
    reg[31:0] msgVector[DIM-1:0];
    reg[31:0] dictMem[NUM_CHAR-1:0][DIM-1:0]; // change to [10000:0] later
    reg[31:0] num_msg[MAX_LENGTH:0]; // range should be determined by the input "length"

    reg[31:0] hamVector[DIM-1:0];
    reg[31:0] spamVector[DIM-1:0];

    always @(msg or length or label) begin
        sum = 0;
        avg = 0;
        $readmemb("refMem_Ham_Binary.txt", hamVector, 0, DIM-1);
        $readmemb("refMem_Spam_Binary.txt", spamVector, 0, DIM-1);
        // char = "Shenda xxxxx NOnono.";
        // In the for loop, the range of i is from 0 to (total_bits of the message - 1)
        // 95 needs to be changed to a variable
        for (i = 0; i < length*8-1 ; i = i + BITS_PER_CHAR) begin 
            letter = msg[i+:8];
            // $display("letter",letter);
            // $display("%d, %c", letter, letter);
            lower_letter = to_lower(letter);
            // $display("%d, %c", lower_letter, lower_letter);
            if (lower_letter>="a" && lower_letter<="z") begin
                num_msg[i/BITS_PER_CHAR] = lower_letter-"a"+11;
            end
            else if (lower_letter>="0" && lower_letter<="9") begin
                num_msg[i/BITS_PER_CHAR] = lower_letter-"0"+1;
            end 
            else begin
                num_msg[i/BITS_PER_CHAR] = 0;
            end
        end
        
        // Used for testing part only
        // for(i = 0; i < 12; i = i+1) begin
            // $display (num_msg[i]);
        // end

        // Call the task to generate Item Memory
        memGen(NUM_CHAR,DIM);

        // Call the task to perform encoding to generate HV for each tokenized message
        encoding(DIM);

        // $display("%h", msgVector);
        
        result = 0;
        // hamming(msgVector, hamVector, spamVector, result);
        hamming(result);
        //$display("%b", result);
    end

    // Transform all characters to lower case
    function [7:0] to_lower (input [7:0] in_char);
    begin
        to_lower = in_char;
        if (in_char > 64 && in_char < 91)
            to_lower = in_char + 32;
        end
    endfunction // to_lower

    // Generate item memories
    task memGen;
        input [7:0] num_char, dim;
        integer i,j;
        begin
            for (i = 0; i < num_char ; i = i + 1 ) begin
                for (j = 0; j < dim; j = j + 1 ) begin
                    dictMem[i][j] = $urandom(seed)%2; // generate dictMem
                    // $display("%b", dictMem[i][j]);
                end
            end
        end
    endtask

    // Encode a message to an HV, message is an array of numbers 
    task encoding;
        input [7:0] dim;
        integer i, j;
        begin

            for (i = 0; i < dim; i = i + 1) begin // make HV all zeros
                HV[i] = 0;
            end

            // In the for loop, the range of i is from 0 to (total_chars in msg)
            // 12 needs to be changed to a variable
            for (i = 0; i < length; i = i + 1 ) begin // sum each unit together
                for (j = 0; j < dim ; j = j + 1 ) begin
                    HV[j] = HV[j] + dictMem[num_msg[i]][j];
                    if (i==(length-1)) begin // 11 needs to change to the length of num_msg
                        sum = sum + HV[j];
                    end
                end 
            end

            avg = sum / dim; // Calculate average

            for (i = 0; i < dim; i = i + 1) begin // Do comparison
                if ( HV[i] > avg) begin
                    HV[i] = 1;
                end 
                else if ( HV[i] < avg) begin
                    HV[i] = -1;
                end 
                else begin
                    HV[i] = 0;
                end
                // $display("%0d", HV[i]);
                msgVector[i] = HV[i];
            end
        end
    endtask

    task hamming;
        // input [9999:0] msgVector, hamVector, spamVector;
        output [1:0] HamSpam;

        integer countHam;
        integer countSpam; 
        integer i, j;
        begin
            countHam = 0;
            countSpam = 0;
            for (i = 0; i < DIM; i = i + 1) begin
                for (j = 0; j < 32 ; j = j + 1) begin
                    if (msgVector[i][j] ^ hamVector[i][j] == 1) begin
                        countHam = countHam + 1;
                    end 
                    if (msgVector[i][j] ^ spamVector[i][j] == 1) begin
                        countSpam = countSpam + 1;
                    end
                end
            end
            if (countHam > countSpam) begin
                HamSpam = 0; // The prediction is Spam Message
            end 
            else if (countHam < countSpam) begin
                HamSpam = 1; // The prediction is Ham Message
            end 
            else begin
                HamSpam = -1; // It can't make a prediction
            end
            $display("countSpam: %d", countSpam);
            $display("countHam: %d", countHam);
        end
    endtask

endmodule