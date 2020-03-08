module cp0_test;
    reg   [4:0] regnum = 0;
    reg  [31:0] wr_data = 0;
    reg  [29:0] next_pc = 0;
    reg         TimerInterrupt = 0, MTC0 = 0, ERET = 0;
    reg         clock = 0;
    always #5   clock = !clock;
    reg         reset = 1;

    initial begin
        $dumpfile("cp0.vcd");
        $dumpvars(0, cp0_test);

        # 10
            // write to status register
            reset = 0;
            MTC0 = 1;
            regnum = `STATUS_REGISTER;
            wr_data = 32'hffffffff;

        # 10
            // make sure only user-writable bits got set
            MTC0 = 0;
            regnum = `STATUS_REGISTER; // rd_data should show 0x0000ff01

        # 10
            // raise a timer interrupt
            TimerInterrupt = 1;
            next_pc = 32'h100001;

        # 10
            // verify that TakenInterrupt is only 1 for one cycle
            // and that EPC doesn't get overwritten
            // and that exception level bit gets set in status register
            next_pc = 32'h100002;

        # 10
            // make sure EPC is output correctly
            regnum = `EPC_REGISTER;


        # 10
            // make sure cause register is set correctly
            regnum = `CAUSE_REGISTER;

        # 10
            // stop raising timer interrupt
            TimerInterrupt = 0;

            // execute an ERET
            ERET = 1;

        # 10
            // make sure exception level bit got cleared
            regnum = `STATUS_REGISTER;

        # 10
            // make sure cause register bit got cleared
            regnum = `CAUSE_REGISTER;

            // some more tests you should try (because we will be):
            // * set the EPC register via mtc0
            // * check that disabling all interrupts works
            // * check that disabling the timer interrupt works
            // * make sure reset works
            // * etc.

        # 10
            $finish;
    end

    wire [31:0] rd_data;
    wire [29:0] EPC;
    wire        TakenInterrupt;
    cp0 c0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);

    // it's gonna be a lot easier to verify (and debug) your circuit using gtkwave
    // trust me on this one
    /*
    initial
        $monitor("At time %3t, regnum = %2d wr_data = 0x%x next_pc = 0x%x TimerInterrupt = %b MTC0 = %b ERET = %b rd_data = 0x%x EPC = 0x%x TakenInterrupt = %b", $time, regnum, wr_data, next_pc, TimerInterrupt, MTC0, ERET, rd_data, EPC, TakenInterrupt);
	*/
endmodule
