module arith_machine_test;
    /* Make a regular pulsing clock. */
    reg       clock = 0;
    always #5 clock = !clock;
    integer   i;

    reg       reset = 1, done = 0;
    wire      except;

    arith_machine am(except, clock, reset);
    
    initial begin
        $dumpfile("am.vcd");
        $dumpvars(0, arith_machine_test);
        for (i = 0 ; i < 32 ; i = i + 1)
            $dumpvars(1, am.rf.r[i]); // dump all register values

        # 3 reset = 0;
        # 200 done = 1;
    end
    
    initial
        $monitor("At time %t, reset = %d pc = %h, inst = %h, except = %h",
                 $time, reset, am.PC_reg.q, am.im.data, except);

    // periodically check for the end of simulation.  When it happens
    // dump the register file contents.
    always @(negedge clock)
    begin
        if ((done === 1'b1) | (except === 1'b1))
        begin
            $display ( "Dumping register state: " );
            $display ( "  Register :  hex-value (  dec-value )" );
            for (i = 0 ; i < 32 ; i = i + 1)
                $display ( "%d: 0x%x ( %d )", i, am.rf.r[i], am.rf.r[i]);
            $display ( "Done.  Simulation ending." );
            $finish;
        end
    end
endmodule // arith_machine_test
