module decoder_test;
	reg [5:0] opcode, funct;

	initial begin
		$dumpfile("decoder.vcd");
		$dumpvars(0, decoder_test);

			opcode = `OP_OTHER0; funct = `OP0_ADD;
		# 10 opcode = `OP_OTHER0; funct = `OP0_ADDU;
		# 10 opcode = `OP_OTHER0; funct = `OP0_SUB;
		# 10 opcode = `OP_OTHER0; funct = `OP0_AND;
		# 10 opcode = `OP_OTHER0; funct = `OP0_OR;
		# 10 opcode = `OP_OTHER0; funct = `OP0_NOR;
		# 10 opcode = `OP_OTHER0; funct = `OP0_XOR;
		# 10 funct = 6'b000000; opcode = `OP_ADDI;
		# 10 funct = 6'b000000; opcode = `OP_ADDIU;
		# 10 funct = 6'b000000; opcode = `OP_ANDI;
		# 10 funct = 6'b000000; opcode = `OP_ORI;
		# 10 funct = 6'b000000; opcode = `OP_XORI;
		# 10 funct = `OP0_SUBU; opcode = `OP_OTHER0;
		# 10 funct = 6'b000000; opcode = `OP_OTHER0;
		# 10 $finish;
	end

	// use gtkwave to test correctness
	wire [2:0] alu_op;
	wire [1:0] alu_src2; 
	wire	   rd_src, writeenable, except;
	mips_decode decoder(rd_src, writeenable, alu_src2, alu_op, except,
						opcode, funct);

	initial begin
		$display("opcode funct alu_op rd_src alu_src2 writeenable except");
		$monitor("%x\t%x\t%x\t%x\t%x\t%x\t%x\t(at time %t)", opcode, funct, alu_op, rd_src, alu_src2, writeenable, except, $time);
	end
endmodule // decoder_test
