module Hamming(a,b, dist);
    input [9999:0] a, b;
    output dist;

    integer i;
    integer count;

    count <= 1;

    initial begin
        for (i=0; i<10000; i = i+1) begin
            if (a[i] ^ b[i] == 1)
                count = count + 1;
        end
    end
    dist <= count;
endmodule

