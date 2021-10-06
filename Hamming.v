module Hamming(a, hamVector, spamVector, dist);
    input [9999:0] a, hamVector, spamVector;
    output HamSpam;

    integer i;
    integer countHam;
    integer countSpam;

    initial begin
        countHam <= 0;
        countSpam <= 0;
        for (i=0; i<10000; i = i+1) begin
            if (a[i] ^ hamVector[i] == 1)
                countHam = countHam + 1;
            else if (a[i] ^ spamVector[i] == 1) begin
                countSpam = countSpam + 1;
            end
        end
        if (countHam > countSpam)
            HamSpam <= -1;
        else if (countHam < countSpam) begin
            HamSpam <= 1;
        end else
            HamSpam <= 0;
    end
endmodule

