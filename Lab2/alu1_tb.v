module alu1_test;
	// exhaustively test your 1-bit ALU implementation by adapting mux4_tb.v
	reg A = 0;
	always #1 A = !A;
	reg B = 0;
	always #2 B = !B;
	reg [2:0] control = 0;
	reg cin = 0;
	always #3 cin = !cin;
	 
	initial begin
		$dumpfile("alu1.vcd");
		$dumpvars(0, alu1_test);

		# 8 control = 1;
		# 8 control = 2;
		# 8 control = 3;
		# 8 control = 4;
		# 8 control = 5;
		# 8 control = 6;
		# 8 control = 7;
		# 8 $finish;
	end

	wire out, cout;
	alu1 alu0(out, cout, A, B, cin, control);

	initial begin
		$display("A\tB\tcarryin\tcontrol\tout\tcarryout");
		$monitor("%d\t%d\t%d\t%d\t%d\t%d\t(at time %t)", A, B, cin, control, out, cout, $time);
	end
endmodule
