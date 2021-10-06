module main (msg, length, label, output_label);
    reg [1023:0] msgVector = 1024'h24c3b3f3ddb7ff8dec0c815c860e97ce29829c0cb677defaca09155439e81c4e554b5b4573e530b6d8c81c8a3d7faea63fdce5a5c1feacad2daf80a8913962bbc23dbb1ad2ea7ff7a1c79059a30b91554ef1ffaa9f5521c137dfcc8b5c2561c7485788b598afcd170aefd09e69654c36a6503f80f5563b4b37147fc3a909717d;
    reg [1023:0] hamVector = 1024'h6973ec44852c0b7dbe818b1252bb32f7d4e11ee67caec9c51a9114b01f45a541aa50870eca90d65bcdc8cd2a5dfc2a85d1ee44396d711e575a6b8b38a2a629f5d2877eb843580122b50e90fb1a05f1066348b7923810bf532aada6307bead6e69731715a2ec8ba9719955bd8c2171b9c5d24250ea22063e6fd6cabbb44dbb910;
    reg [1023:0] spamVector = 1024'hc74bd2f639636ac7c9b829681c97707b85b05aa2a7e1b8335ea06c79acca6274d594705e53b0d152895366dd7dc9610dff17b1f42a1fc6c3d5c87877a97ed34238bbcb11e1ba8b088d0047d9695588607a148cc4ea3cd19bb56d157dffe24892c1f934687d24cb69d682dec7277cc362f711a9d553867dac9819fcfff0d136c4;
    reg signed [1:0] result;

    parameter MAX_LENGTH = 160;
    parameter NUM_CHAR = 37;
    parameter DIM = 128;
    parameter BITS_PER_CHAR = 8;
    input[MAX_LENGTH*7-1:0] msg;
    input length;
    input[MAX_LENGTH*7-1:0] label;
    input[MAX_LENGTH*7-1:0] output_label;

    integer i;
    integer seed = 11;
    real sum = 0;
    real avg;

    reg[MAX_LENGTH*7:0] char; // used for testing part of code only, use the input msg for testbench
    reg[7:0] letter;
    reg[7:0] lower_letter;
    reg signed [7:0] HV [DIM-1:0];
    reg[7:0] dictMem[NUM_CHAR-1:0][DIM-1:0]; // change to [10000:0] later
    reg[7:0] num_msg[11:0]; // range should be determined by the input "length"

    initial begin
        char = "Shenda Huang"; // Used for testing part only
        // In the for loop, the range of i is from 0 to (total_bits of the message - 1)
        // 95 needs to be changed to a variable
        for (i = 0; i < 95 ; i = i + BITS_PER_CHAR) begin 
            letter = char[i+:8];
            // $display("%d, %c", letter, letter);
            lower_letter = to_lower(letter);
            // $display("%d, %c", lower_letter, lower_letter);
            if (lower_letter>="a" && lower_letter<="z")
                num_msg[i/BITS_PER_CHAR] = lower_letter-"a"+11;
            else if (lower_letter>="0" && lower_letter<="9") begin
                num_msg[i/BITS_PER_CHAR] = lower_letter-"0"+1;
            end else
                num_msg[i/BITS_PER_CHAR] = 0;
        end
        
        // Used for testing part only
        for(i = 0; i < 12; i = i+1) begin
            // $display (num_msg[i]);
        end

        // Call the task to generate Item Memory
        memGen(NUM_CHAR,DIM);

        // Call the task to perform encoding to generate HV for each tokenized message
        encoding(DIM);
        
        result = 0;
        hamming(msgVector, hamVector, spamVector, result);
        $display("%b, %d", result,result);
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
            for (i = 0; i < 12; i = i + 1 ) begin // sum each unit together
                for (j = 0; j < dim ; j = j + 1 ) begin
                    HV[j] = HV[j] + dictMem[num_msg[i]][j];
                    if (i==11) begin // 11 needs to change to the length of num_msg
                        sum = sum + HV[j];
                    end
                end 
            end

            avg = sum / dim; // Calculate average

            for (i = 0; i < dim; i = i + 1) begin // Do comparison
                if ( HV[i] > avg)
                    HV[i] = 1;
                else if ( HV[i] < avg) begin
                    HV[i] = -1;
                end else
                    HV[i] = 0;
                // $display("%0d", HV[i]);
            end
        end
    endtask

    task hamming;
        input [1023:0] msgVector, hamVector, spamVector;
        output [1:0] HamSpam;

        integer countHam;
        integer countSpam; 
        begin
            countHam = 0;
            countSpam = 0;
            for (i = 0; i < 1024; i = i + 1) begin
                if (msgVector[i] ^ hamVector[i] == 1) begin
                    countHam = countHam + 1;
                end 
                if (msgVector[i] ^ spamVector[i] == 1) begin
                    countSpam = countSpam + 1;
                end
            end
            if (countHam > countSpam)
                HamSpam = -1; // The prediction is Spam Message
            else if (countHam < countSpam) begin
                HamSpam = 1; // The prediction is Ham Message
            end else
                HamSpam = 0; // It can't make a prediction
            $display(countHam, countSpam, $signed(HamSpam));
        end
    endtask

endmodule