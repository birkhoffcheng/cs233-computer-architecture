//Write your test bench for sc2_block here.
//Refer to sc_block_tb.v for formatting!
module sc2_test;
	reg a_in, b_in, c_in;
	wire s_out, c_out;
	sc2_block sc2(s_out, c_out, a_in, b_in, c_in);

	initial begin
		$dumpfile("sc2.vcd");
		$dumpvars(0,sc2_test);

		a_in = 0; b_in = 0; c_in = 0; # 10;
		a_in = 0; b_in = 0; c_in = 1; # 10;
		a_in = 0; b_in = 1; c_in = 0; # 10;
		a_in = 0; b_in = 1; c_in = 1; # 10;
		a_in = 1; b_in = 0; c_in = 0; # 10;
		a_in = 1; b_in = 0; c_in = 1; # 10;
		a_in = 1; b_in = 1; c_in = 0; # 10;
		a_in = 1; b_in = 1; c_in = 1; # 10;

		$finish;
	end

	initial
		$monitor("At time %2t, a_in = %d, b_in = %d, c_in = %d, s_out = %d, c_out = %d", $time, a_in, b_in, c_in, s_out, c_out);
endmodule // sc2_test
