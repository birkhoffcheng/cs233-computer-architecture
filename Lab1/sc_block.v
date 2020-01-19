module sc_block(s, c, a, b);
    output s, c;
    input  a, b;
    wire   w1, w2, not_a, not_b;

    // the "c" output is just the AND of the two inputs
    and a1(c, a, b);

    // the "s" output is 1 only when exactly one of the inputs is 1
    not n1(not_a, a);
    not n2(not_b, b);
    and a2(w1, a, not_b);
    and a3(w2, b, not_a);
    or  o1(s, w1, w2);
endmodule // sc_block
