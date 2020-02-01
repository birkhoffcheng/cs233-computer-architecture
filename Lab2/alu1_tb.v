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

		# 16 control = 1;
		# 16 control = 2;
		# 16 control = 3;
		# 16 control = 4;
		# 16 control = 5;
		# 16 control = 6;
		# 16 control = 7;
		# 16 $finish;
	end

	wire out, cout;
	alu1 alu0(out, cout, A, B, cin, control);

	initial begin
		$display("A\tB\tcarryin\tcontrol\tout\tcarryout");
		$monitor("%d\t%d\t%d\t%d\t%d\t%d\t(at time %t)", A, B, cin, control, out, cout, $time);
	end
endmodule
