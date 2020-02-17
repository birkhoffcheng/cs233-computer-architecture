module full_machine_test;
    /* Make a regular pulsing clock. */
    reg       clk = 0;
    always #5 clk = !clk;
    integer     i;

    reg 		reset = 1, done = 0;
    wire         except;

    full_machine fm(except, clk, reset);
    
    initial begin
        $dumpfile("fm.vcd");
        $dumpvars(0, full_machine_test); // dump all variables except memories
        for (i = 0 ; i < 32 ; i = i + 1)
            $dumpvars(1, fm.rf.r[i]); // dump all register values

        # 3 reset = 0;
        # 300 done = 1;
        // this is enough time to run 30 instructions. If you need to run
        // more, change the "300" above to a more appropriate number
    end
   
    initial
        $monitor("At time %t, reset = %d pc = %h, inst = %h, except = %h",
                 $time, reset, fm.PC_reg.q, fm.im.data, except);

    // periodically check for the end of simulation.  When it happens
    // dump the register file contents.
    always @(negedge clk)
    begin
        #0;
        if ((done === 1'b1) | (except === 1'b1))
        begin
            $display ( "Dumping register state: " );
            $display ( "  Register :  hex-value (  dec-value )" );
            for (i = 0 ; i < 32 ; i = i + 1)
                $display ( "%d: 0x%x ( %d )", i, fm.rf.r[i], fm.rf.r[i]);
            $display ( "Done.  Simulation ending." );
            $finish;
        end
    end
   
endmodule // test
