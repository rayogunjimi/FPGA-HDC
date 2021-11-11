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

    real ssHam;
    real ssSpam;
    real ssMsg;
    real prodHam;
    real prodSpam;
    real normHam;
    real normSpam;
    real normMsg;
    real sqrt;
    real cosHam;
    real cosSpam;

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

        msgPtr = $fopen("msg.txt", "w");
        if (msgPtr == 0) begin               //If inputs file is not found
            $display("Open files with ERROR");
            $finish;
        end
        for (k=0; k<DIM; k = k+1) begin
          for(k1 = 0; k1 < 16; k1 = k1 +1) begin
            $fwrite(msgPtr, "%b", msgVector[k][k1]);
          end
          $fwrite(msgPtr, "\n");
        end
        $fclose(msgPtr);


        // $display("%h", msgVector);
        sumNsquareHam(ssHam);
        sumNsquareSpam(ssSpam);
        sumNsquareMsg(ssMsg);
        dotprodHam(prodHam);
        dotprodSpam(prodSpam);
        root(ssHam);
        normHam = sqrt;
        root(ssSpam);
        normSpam = sqrt;
        cosHam = (prodHam)/(normHam*100);
        cosSpam = (prodSpam)/(normSpam*100);

        $display("Cosine Similarity w/ Ham: %7.2f", cosHam);
        $display("Cosine Similarity w/ Spam: %7.2f", cosSpam);


        result = 0;
        // hamming(msgVector, hamVector, spamVector, result);
        out(result);
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

    task root;
        input [63:0] num;  //declare input
        //intermediate signals.
        reg [63:0] a;
        reg [30:0] q;
        reg [33:0] left,right,r;    
        integer i;
        begin
            //initialize all the variables.
            a = num;
            q = 0;
            i = 0;
            left = 0;   //input to adder/sub
            right = 0;  //input to adder/sub
            r = 0;  //remainder
            //run the calculations for 16 iterations.
            for(i=0;i<32;i=i+1) begin 
                right = {q,r[33],1'b1};
                left = {r[31:0],a[63:62]};
                a = {a[61:0],2'b00};    //left shift by 2 bits.
                if (r[33] == 1) //add if r is negative
                    r = left + right;
                else    //subtract if r is positive
                    r = left - right;
                q = {q[29:0],!r[33]};       
            end
            $display("Square Root: %7.2f", q);
            sqrt = q;   //final assignment of output.
        end
    endtask

    task sumNsquareHam;
        real temp;
        real sum1;
        integer i1;

        output real ssHam;

        begin
            ssHam = 0;
            sum1 = 0;
            for(i1=0; i1<DIM; i1 = i1 + 1) begin
                temp = hamVector[i1];
                sum1 = hamVector[i1]*temp;
                ssHam = ssHam + sum1;
            end
            $display("Sum & Square Ham: %d", ssHam);

        end
    endtask

    task sumNsquareSpam;
        real temp;
        real sum1;
        integer i1;

        output real ssSpam;

        begin
            ssSpam = 0;
            sum1 = 0;
            for(i1=0; i1<DIM; i1 = i1 + 1) begin
                temp = spamVector[i1];
                sum1 = spamVector[i1]*temp;
                ssSpam = ssSpam + sum1;
            end
            $display("Sum & Square Spam: %d", ssSpam);

        end
    endtask

    task sumNsquareMsg;
        real temp;
        real sum1;
        integer i1;

        output real ssSpam;

        begin
            ssMsg = 0;
            sum1 = 0;
            for(i1=0; i1<DIM; i1 = i1 + 1) begin
                temp = msgVector[i1];
                sum1 = msgVector[i1]*temp;
                ssMsg = ssMsg + sum1;
            end
            $display("Sum & Square Msg: %d", ssMsg);

        end
    endtask


    task dotprodHam;
        real sum;
        real temp1;
        real temp2;
        integer i2;

        output real prodHam;
        begin
            sum = 0;
            prodHam = 0;
          for (i2 = 0; i2<DIM; i2 = i2 + 1) begin
            temp1 = hamVector[i2];
            temp2 = msgVector[i2];
            sum = temp1*temp2;
            prodHam = prodHam + sum;
          end
          $display("Ham Dot Prod: %d", prodHam);
        end
    endtask

    task dotprodSpam;
        real sum;
        real temp1;
        real temp2;
        integer i2;

        output real prodSpam;
        begin
            sum = 0;
            prodSpam = 0;
          for (i2 = 0; i2<DIM; i2 = i2 + 1) begin
            temp1 = spamVector[i2];
            temp2 = msgVector[i2];
            sum = temp1*temp2;
            prodSpam = prodSpam + sum;
          end
          $display("Spam Dot Prod: %d", prodSpam);
        end
    endtask

    task out;
        output [1:0] HamSpam;

        begin
            if (cosHam>cosSpam) begin
              HamSpam = 0;
            end
            else if (cosHam<cosSpam) begin
              HamSpam = 1;
            end
            else begin
              HamSpam = -1;
            end
        end
    endtask

    // task hamming;
    //     // input [9999:0] msgVector, hamVector, spamVector;
    //     output [1:0] HamSpam;

    //     integer countHam;
    //     integer countSpam; 
    //     integer i, j;
    //     begin
    //         countHam = 0;
    //         countSpam = 0;
    //         for (i = 0; i < DIM; i = i + 1) begin
    //             for (j = 0; j < 16 ; j = j + 1) begin
    //                 if (msgVector[i][j] ^ hamVector[i][j] == 1) begin
    //                     countHam = countHam + 1;
    //                 end 
    //                 if (msgVector[i][j] ^ spamVector[i][j] == 1) begin
    //                     countSpam = countSpam + 1;
    //                 end
    //             end
    //         end
    //         if (countHam > countSpam) begin
    //             HamSpam = 0; // The prediction is Spam Message
    //         end 
    //         else if (countHam < countSpam) begin
    //             HamSpam = 1; // The prediction is Ham Message
    //         end 
    //         else begin
    //             HamSpam = -1; // It can't make a prediction
    //         end
    //         $display("countSpam = %2.0f", countSpam);
    //         $display("countHam = %2.0f", countHam);
    //     end
    // endtask

endmodule