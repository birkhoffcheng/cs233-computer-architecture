module reg_writer_test;
    reg       clock = 0;
    always #1 clock = !clock;

    reg go = 0;
    reg reset = 1;
    reg direction = 0; 
    reg [31:0] data; 
    wire done;
    wire [4:0] regnum;
   
    wire [31:0] writtenValue;
    reg_writer writer(done, regnum, direction, go, clock, reset);
    regfile rf (, , , ,regnum, data, ~done, clock, reset);

    initial begin
        $dumpfile("reg_writer.vcd");
        $dumpvars(0, reg_writer_test);
        # 2      reset = 0;

	// Test writing down
	# 2 go = 1; data = 32'hd00; direction = 0;
	# 2 go = 0; data = 32'hd01;
	# 2 data = 32'hd02;
	# 2 data = 32'hd03;
	# 2 data = 32'hd04;
	# 2 data = 32'hd05;
	
	# 6 // Finish our run

	# 2 reset = 1; // Reset the machine 
	# 2 reset = 0;

	// Test writing up
	# 2 go = 1; data = 32'hdFF; direction = 1;
	# 2 go = 0; data = 32'hdFE; 
	# 2 data = 32'hdFD;
	# 2 data = 32'hdFC;
	# 2 data = 32'hdFB;
	# 2 data = 32'hdFA;
	
        // Add your own testcases here!

        #10 $finish;
    end

endmodule
