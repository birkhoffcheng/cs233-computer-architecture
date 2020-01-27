module mux4_test;

    // cycle through all combinations of A, B, C, D every 16 time units
    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;
    reg C = 0;
    always #4 C = !C;
    reg D = 0;
    always #8 D = !D;
     
    reg [1:0] control = 0;
     
    initial begin
        $dumpfile("mux4.vcd");
        $dumpvars(0, mux4_test);

        // control is initially 0
        # 16 control = 1; // wait 16 time units (why 16?) and then set it to 1
        # 16 control = 2; // wait 16 time units and then set it to 2
        # 16 control = 3; // wait 16 time units and then set it to 3
        # 16 $finish; // wait 16 time units and then end the simulation
    end

    wire out;
    mux4 m4(out, A, B, C, D, control);

    // you really should be using gtkwave instead
    /*
    initial begin
        $display("A B C D s o");
        $monitor("%d %d %d %d %d %d (at time %t)", A, B, C, D, control, out, $time);
    end
    */
endmodule // mux4_test
