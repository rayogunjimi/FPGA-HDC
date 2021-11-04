`timescale 1ns / 1ps

module main (msg, length, label, clk, reset, result);
    parameter MAX_LENGTH = 200;
    parameter NUM_CHAR = 37;
    parameter DIM = 10000;
    parameter BITS_PER_CHAR = 8;
    parameter BITS_PER_INT = 16;
    
    input[MAX_LENGTH*8-1:0] msg;
    input[7:0] length;
    input[1:0] label;
    input clk, reset;

    // Testing Data exported to Python
    integer msgPtr;
    integer hamPtr;
    integer spamPtr;
    integer k;
    integer k1;

    real ss;
    integer sum1;
    integer i1;

    output reg signed [1:0] result;

    integer i;
    integer seed = 15;
    real sum;
    real avg;

    reg[7:0] letter;
    reg[7:0] lower_letter;
    reg signed[BITS_PER_INT-1:0] HV[DIM-1:0];
    reg signed[BITS_PER_INT-1:0] msgVector[DIM-1:0];
    reg signed[BITS_PER_INT-1:0] dictMem[NUM_CHAR-1:0][DIM-1:0]; // change to [10000:0] later
    reg signed[BITS_PER_INT-1:0] num_msg[MAX_LENGTH:0]; // range should be determined by the input "length"

    reg signed[BITS_PER_INT-1:0] hamVector[DIM-1:0];
    reg signed[BITS_PER_INT-1:0] spamVector[DIM-1:0];

    integer j = 0;

    initial begin
        // Call the task to generate Item Memory
        // memGen(NUM_CHAR,DIM);
        $readmemb("refMem_Ham_Binary.txt", hamVector, 0, DIM-1);
        $readmemb("refMem_Spam_Binary.txt", spamVector, 0, DIM-1);
        $readmemb("dictMem.txt", dictMem);

        // Testing for the read-in value only
        // for (i = 0; i < 20 ; i = i + 1) begin
        //     $display("%16b", dictMem[2][i]);
        // end
    end

    always @(msg or length or label) begin
        sum = 0;
        avg = 0;
        // In the for loop, the range of i is from 0 to (total_bits of the message - 1)
        // 95 needs to be changed to a variable
        for (i = 0; i < length*8-1 ; i = i + BITS_PER_CHAR) begin 
            letter = msg[i+:8];
            // $display("letter",letter);
            // $display("%d, %c", letter, letter);
            lower_letter = to_lower(letter);
            // $display("%d, %c", lower_letter, lower_letter);
            // if (lower_letter != 0) begin
                if (lower_letter>="a" && lower_letter<="z") begin
                    num_msg[i/BITS_PER_CHAR] = lower_letter-"a"+11;
                end
                else if (lower_letter>="0" && lower_letter<="9") begin
                    num_msg[i/BITS_PER_CHAR] = lower_letter-"0"+1;
                end 
                else begin
                    num_msg[i/BITS_PER_CHAR] = 0;
                end
            // end
        end

        // Call the task to perform encoding to generate HV for each tokenized message
        encoding(DIM);

        msgPtr = $fopen("pythonCS/msg.txt", "w");
        hamPtr = $fopen("pythonCS/ham.txt", "w");
        spamPtr = $fopen("pythonCS/spam.txt", "w");
        if (msgPtr == 0 || hamPtr == 0 || spamPtr == 0) begin               //If inputs file is not found
            $display("Open files with ERROR");
            $finish;
        end

        for (k=0; k<DIM; k = k+1) begin
          for(k1 = 0; k1 < 16; k1 = k1 +1) begin
            $fwrite(msgPtr, "%b", msgVector[k][k1]);
            $fwrite(hamPtr, "%b", hamVector[k][k1]);
            $fwrite(spamPtr, "%b", spamVector[k][k1]);
          end
          $fwrite(msgPtr, "\n");
          $fwrite(hamPtr, "\n");
          $fwrite(spamPtr, "\n");
        end

        $fclose(msgPtr);
        $fclose(hamPtr);
        $fclose(spamPtr);



        // $display("%h", msgVector);
        sumNsquare(ss);
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
        input [6:0] num_char;
        input [13:0] dim;
        integer i,j;
        begin
            for (i = 0; i < num_char ; i = i + 1 ) begin
                for (j = 0; j < dim; j = j + 1 ) begin
                    dictMem[i][j] = $urandom(seed)%2; // generate dictMem
                    if (dictMem[i][j] == 0) begin
                        dictMem[i][j] = -1;
                    end
                    // $display("%b", dictMem[i][j]);
                end
            end
        end
    endtask

    // Encode a message to an HV, message is an array of numbers 
    task encoding;
        input [13:0] dim;
        integer i, j;
        begin

            for (i = 0; i < dim; i = i + 1) begin // make HV all zeros
                HV[i] = 0;
            end

            // In the for loop, the range of i is from 0 to (total_chars in msg)
            for (i = 0; i < length; i = i + 1 ) begin // sum each unit together
                for (j = 0; j < dim ; j = j + 1 ) begin
                    HV[j] = HV[j] + dictMem[num_msg[i]][j];
                    if (i==(length-1)) begin
                        sum = sum + HV[j];
                    end
                end 
            end
            $display(sum);
            avg = sum / dim; // Calculate average
            $display(avg);

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

    task sumNsquare;
        real temp;
        real sum1;
        integer i1;
        real idk;

        output real ss;

        begin
            ss = 0;
            sum1 = 0;
            for(i1=0; i1<DIM; i1 = i1 + 1) begin
                temp = hamVector[i1];
                $display("Elem: %d", hamVector[i1]);
                sum1 = hamVector[i1]*temp;
                $display(sum1);
                ss = ss + sum1;
            end
            $display("Sum & Square: %d", ss);

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
                for (j = 0; j < 16 ; j = j + 1) begin
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
            $display("countSpam = %2.0f", countSpam);
            $display("countHam = %2.0f", countHam);
        end
    endtask

endmodule