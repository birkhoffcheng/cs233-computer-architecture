module timer_test;
    reg  [31:0] address = 0, data = 0;
    reg         MemRead = 0, MemWrite = 0;
    reg         clock = 0;
    always #5   clock = !clock;
    reg         reset = 1;

    initial begin
        $dumpfile("timer.vcd");
        $dumpvars(0, timer_test);

        # 10
            // count for a while
            reset = 0;
            address = 32'hffff001c;
            MemRead = 1;
            MemWrite = 0;

        # 40
            // request a timer interrupt
            address = 32'hffff001c;
            data = 6;
            MemRead = 0;
            MemWrite = 1;

        # 10
            // start reading again
            address = 32'hffff001c;
            MemRead = 1;
            MemWrite = 0;

        # 40
            // wait for interrupt to happen
            // then acknowledge it
            address = 32'hffff006c;
            MemRead = 0;
            MemWrite = 1;

        # 10
            // wait for acknowledgement to get processed
            $finish;
    end

    wire        TimerInterrupt, TimerAddress;
    wire [31:0] cycle;
    timer t(TimerInterrupt, cycle, TimerAddress,
            data, address, MemRead, MemWrite, clock, reset);

    // it's gonna be a lot easier to verify (and debug) your circuit using gtkwave
    // trust me on this one
    /*
    initial
        $monitor("At time %t, address = 0x%x data = %0d MemRead = %d MemWrite = %d TimerInterrupt = %d TimerAddress = %d cycle = %0d",
                 $time, address, data, MemRead, MemWrite, TimerInterrupt, TimerAddress, cycle);
	*/
endmodule
