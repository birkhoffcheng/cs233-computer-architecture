//implement a test bench for your 32-bit ALU
module alu32_test;
	reg [31:0] A = 0, B = 0;
	reg [2:0] control = 0;

	initial begin
		$dumpfile("alu32.vcd");
		$dumpvars(0, alu32_test);

			 A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
		# 10 A = 2147483647; B = 1; control = `ALU_ADD; // should have overflow
		# 10 A = 2147483647; B = 1; control = `ALU_UADD; // shouldn't have overflow
		# 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
		# 10 A = 2; B = 2; control = `ALU_SUB; // should be 0
		# 10 A = 19720; B = 29132; control = `ALU_OR; // should be 32204
		# 10 A = 14419; B = 31601; control = `ALU_AND; // should be 14417
		# 10 A = 17186; B = 31601; control = `ALU_XOR; // should be 14419
		# 10 A = 26219; B = 21154; control = `ALU_NOR; // should be -30444
		# 10 $finish;
	end

	wire [31:0] out;
	wire overflow, zero, negative;
	alu32 a(out, overflow, zero, negative, A, B, control);

	integer myint;
	always @(out) myint = out;
	
	initial begin
		$display("\t A\t\t B\tcontrol\t\tint\t\tout\toverflow\tzero\tnegative");
		$monitor("%d\t%d\t%d\t%d\t%d\t%d\t\t%d\t%d\t(at time %t)", A, B, control, myint, out, overflow, zero, negative, $time);
	end
endmodule // alu32_test
