module logicunit_test;
	reg A = 0;
	always #1 A = !A;
	reg B = 0;
	always #2 B = !B;
	reg [1:0] control = 0;
	 
	initial begin
		$dumpfile("logicunit.vcd");
		$dumpvars(0, logicunit_test);

		# 4 control = 1;
		# 4 control = 2;
		# 4 control = 3;
		# 4 $finish;
	end

	wire out;
	logicunit l1(out, A, B, control);

	initial begin
		$display("A B control out");
		$monitor("%d %d %d %d (at time %t)", A, B, control, out, $time);
	end
endmodule // logicunit_test
