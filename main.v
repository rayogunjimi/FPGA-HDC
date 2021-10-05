module main (msg, length, label);
    parameter MAX_LENGTH = 160;
    parameter NUM_CHAR = 37;
    parameter DIM = 128;
    parameter BITS_PER_CHAR = 8;
    input length;
    input[MAX_LENGTH*7:0] msg, label;

    integer i;
    integer seed = 11;
    real sum = 0;
    real avg;

    reg[14*7:0] char; // used for testing part of code only, use the input msg for testbench
    reg[7:0] HV [DIM-1:0];
    reg[7:0] dictMem[NUM_CHAR-1:0][DIM-1:0]; // change to [10000:0] later
    reg[7:0] letter;
    reg[7:0] lower_letter;
    reg[7:0] num_msg[11:0];

    initial begin
        char = "Shenda Huang"; // Used for testing part only
        // In the for loop, the range of i is from 0 to (total_bits of the message - 1)
        // 95 needs to be changed to a variable
        for (i = 0; i < 95 ; i = i + BITS_PER_CHAR) begin 
            letter = {char[i+7],char[i+6],char[i+5],char[i+4],char[i+3],char[i+2],char[i+1],char[i]};
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
                    if (i==11) begin
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
                $display("%0d", $signed(HV[i]));
            end
        end
    endtask

endmodule