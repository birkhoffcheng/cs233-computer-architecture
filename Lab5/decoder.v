// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op	   (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src	   (output) - should the destination register be rd (0) or rt (1)
// alu_src2	 (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except	   (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read	 (output) - the register value written is coming from the memory
// word_we	  (output) - we're writing a word's worth of data
// byte_we	  (output) - we're only writing a byte's worth of data
// byte_load	(output) - we're doing a byte load
// slt		  (output) - the instruction is an slt
// lui		  (output) - the instruction is a lui
// addm		 (output) - the instruction is an addm
// opcode		(input) - the opcode field from the instruction
// funct		 (input) - the function field from the instruction
// zero		  (input) - from the ALU
`define ALU_ADDU	3'h0
`define ALU_ADD		3'h2
`define ALU_SUB		3'h3
`define ALU_AND		3'h4
`define ALU_OR		3'h5
`define ALU_NOR		3'h6
`define ALU_XOR		3'h7

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type, mem_read, word_we, byte_we, byte_load, slt, lui, addm, opcode, funct, zero);
	output [2:0] alu_op;
	output [1:0] alu_src2;
	output writeenable, rd_src, except;
	output [1:0] control_type;
	output mem_read, word_we, byte_we, byte_load, slt, lui, addm;
	input [5:0] opcode, funct;
	input zero;

	assign writeenable = opcode == `OP_OTHER0 & funct >= `OP0_ADD & funct <= `OP0_NOR & funct != `OP0_SUBU | opcode == `OP_ADDI | opcode == `OP_ADDIU | opcode == `OP_ANDI | opcode == `OP_ORI | opcode == `OP_XORI | opcode == `OP_LUI | opcode == `OP_LW | opcode == `OP_LBU | opcode == `OP_OTHER0 & (funct == `OP0_SLT | funct == `OP0_ADDM);

	assign rd_src = opcode == `OP_ADDI | opcode == `OP_ADDIU | opcode == `OP_ANDI | opcode == `OP_ORI | opcode == `OP_XORI | opcode == `OP_LUI | opcode == `OP_LW | opcode == `OP_LBU;

	assign except = ~(opcode == `OP_OTHER0 & funct >= `OP0_ADD & funct <= `OP0_NOR & funct != `OP0_SUBU | opcode == `OP_ADDI | opcode == `OP_ADDIU | opcode == `OP_ANDI | opcode == `OP_ORI | opcode == `OP_XORI | opcode == `OP_BEQ | opcode == `OP_BNE | opcode == `OP_J | opcode == `OP_LUI | opcode == `OP_LW | opcode == `OP_LBU | opcode == `OP_SW | opcode == `OP_SB | opcode == `OP_OTHER0 & (funct == `OP0_JR | funct == `OP0_SLT));

	assign alu_src2 = (opcode == `OP_OTHER0 & funct >= `OP0_ADD & funct <= `OP0_NOR | opcode == `OP_BEQ | opcode == `OP_BNE | opcode == `OP_J | opcode == `OP_LUI | opcode == `OP_OTHER0 & (funct == `OP0_JR | funct == `OP0_SLT)) ? 2'b00 :
	(opcode == `OP_ADDI | opcode == `OP_ADDIU | opcode == `OP_LW | opcode == `OP_LBU | opcode == `OP_SW | opcode == `OP_SB) ? 2'b01 :
	(opcode == `OP_ANDI | opcode == `OP_ORI | opcode == `OP_XORI) ? 2'b10 : 2'b00;

	assign alu_op = (opcode == `OP_ADDI | opcode == `OP_OTHER0 & (funct == `OP0_ADD | funct == `OP0_ADDM) | opcode == `OP_LW | opcode == `OP_LBU | opcode == `OP_SW | opcode == `OP_SB) ? `ALU_ADD :
	(opcode == `OP_ADDIU | opcode == `OP_OTHER0 & funct == `OP0_ADDU) ? `ALU_ADDU :
	(opcode == `OP_OTHER0 & (funct == `OP0_SUB | funct == `OP0_SLT) | opcode == `OP_BEQ | opcode == `OP_BNE) ? `ALU_SUB :
	(opcode == `OP_ANDI | opcode == `OP_OTHER0 & funct == `OP0_AND) ? `ALU_AND :
	(opcode == `OP_ORI | opcode == `OP_OTHER0 & funct == `OP0_OR) ? `ALU_OR :
	(opcode == `OP_OTHER0 & funct == `OP0_NOR) ? `ALU_NOR :
	(opcode == `OP_XORI | opcode == `OP_OTHER0 & funct == `OP0_XOR) ? `ALU_XOR : `ALU_ADDU;

	assign control_type = (opcode == `OP_BEQ) ? (zero ? 2'b01 : 2'b00) :
	(opcode == `OP_BNE) ? (zero ? 2'b00 : 2'b01) :
	(opcode == `OP_J) ? 2'b10 :
	(opcode == `OP_OTHER0 & funct == `OP0_JR) ? 2'b11 : 2'b00;

	assign mem_read = opcode == `OP_LW | opcode == `OP_LBU;
	assign word_we = opcode == `OP_SW;
	assign byte_we = opcode == `OP_SB;
	assign byte_load = opcode == `OP_LBU;
	assign lui = opcode == `OP_LUI;
	assign slt = opcode == `OP_OTHER0 & funct == `OP0_SLT;
	assign addm = opcode == `OP_OTHER0 & funct == `OP0_ADDM;
endmodule // mips_decode
