module FullAdder(a,b,cin,cout,sum);
input a, b, cin; // inputs
output cout, sum; // output
wire w1, w2, w3, w4; // internal nets
xor #(10) (w1, a, b); // delay time of 10 units
xor #(10) (sum, w1, cin);
and #(8) (w2, a, b);
and #(8) (w3, a, cin);
and #(8) (w4, b, cin);
or #(10, 8)(cout, w2, w3, w4); // (rise time of 10, fall 8)
endmodule