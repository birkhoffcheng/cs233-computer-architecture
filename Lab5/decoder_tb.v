module decoder_test;
	reg [5:0] opcode, funct;
	reg zero  = 0;

	initial begin
		$dumpfile("decoder.vcd");
		$dumpvars(0, decoder_test);

		// remember that all your instructions from last week should still work
		opcode = `OP_OTHER0; funct = `OP0_ADD;
		# 10 funct = `OP0_ADDU;
		# 10 funct = `OP0_SUB;
		# 10 funct = `OP0_AND;
		# 10 funct = `OP0_OR;
		# 10 funct = `OP0_NOR;
		# 10 funct = `OP0_XOR;
		# 10 opcode = `OP_ADDI;
		# 10 opcode = `OP_ADDIU;
		# 10 opcode = `OP_ANDI;
		# 10 opcode = `OP_ORI;
		# 10 opcode = `OP_XORI;
		# 10 opcode = `OP_BEQ;
		# 10 opcode = `OP_BNE;
		# 10 opcode = `OP_J;
		# 10 opcode = `OP_OTHER0; funct = `OP0_JR;
		# 10 opcode = `OP_LUI;
		# 10 opcode = `OP_OTHER0; funct = `OP0_SLT;
		# 10 opcode = `OP_LW;
		# 10 opcode = `OP_LBU;
		# 10 opcode = `OP_SW;
		# 10 opcode = `OP_SB;
		# 10 opcode = `OP_OTHER0; funct = `OP0_ADDM;
		# 10 funct = `OP0_DIV; // test except
		// test all of the others here
		
		// as should all the new instructions from this week
		# 10 opcode = `OP_BEQ; zero = 0; // try a not taken beq
		# 10 opcode = `OP_BEQ; zero = 1; // try a taken beq
		// add more tests here!

		# 10 $finish;
	end

	// use gtkwave to test correctness
	wire [2:0] alu_op;
	wire [1:0] alu_src2;
	wire writeenable, rd_src, except;
	wire [1:0] control_type;
	wire mem_read, word_we, byte_we, byte_load, slt, lui, addm;
	mips_decode decoder(alu_op, writeenable, rd_src, alu_src2, except, control_type, mem_read, word_we, byte_we, byte_load, slt, lui, addm, opcode, funct, zero);
endmodule // decoder_test
