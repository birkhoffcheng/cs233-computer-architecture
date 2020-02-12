// mips_decode: a decoder for MIPS arithmetic instructions
//
// rd_src	  (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_src2	(output) - should the 2nd ALU source be a register (0), zero extended immediate or sign extended immediate
// alu_op	  (output) - control signal to be sent to the ALU
// except	  (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode	  (input)  - the opcode field from the instruction
// funct	   (input)  - the function field from the instruction
//
`define ALU_ADDU   3'h0
`define ALU_ADD    3'h2
`define ALU_SUB    3'h3
`define ALU_AND    3'h4
`define ALU_OR     3'h5
`define ALU_NOR    3'h6
`define ALU_XOR    3'h7

module mips_decode(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);
	output rd_src, writeenable, except;
	output [1:0] alu_src2;
	output [2:0] alu_op;
	input [5:0] opcode, funct;

	assign writeenable = opcode == `OP_OTHER0 & funct >= `OP0_ADD & funct <= `OP0_NOR & funct != `OP0_SUBU | opcode == `OP_ADDI | opcode == `OP_ADDIU | opcode == `OP_ANDI | opcode == `OP_ORI | opcode == `OP_XORI;

	assign rd_src = opcode == `OP_ADDI | opcode == `OP_ADDIU | opcode == `OP_ANDI | opcode == `OP_ORI | opcode == `OP_XORI;

	assign except = ~((opcode == `OP_OTHER0 & funct >= `OP0_ADD & funct <= `OP0_NOR & funct != `OP0_SUBU) | opcode == `OP_ADDI | opcode == `OP_ADDIU | opcode == `OP_ANDI | opcode == `OP_ORI | opcode == `OP_XORI);

	assign alu_src2 = (opcode == `OP_OTHER0 & funct >= `OP0_ADD & funct <= `OP0_NOR) ? 2'b00 :
	(opcode == `OP_ADDI | opcode == `OP_ADDIU) ? 2'b01 :
	(opcode == `OP_ANDI | opcode == `OP_ORI | opcode == `OP_XORI) ? 2'b10 : 2'b11;

	assign alu_op = (opcode == `OP_ADDI | opcode == `OP_OTHER0 & funct == `OP0_ADD) ? `ALU_ADD :
	(opcode == `OP_ADDIU | opcode == `OP_OTHER0 & funct == `OP0_ADDU) ? `ALU_ADDU :
	(opcode == `OP_OTHER0 & funct == `OP0_SUB) ? `ALU_SUB :
	(opcode == `OP_ANDI | opcode == `OP_OTHER0 & funct == `OP0_AND) ? `ALU_AND :
	(opcode == `OP_ORI | opcode == `OP_OTHER0 & funct == `OP0_OR) ? `ALU_OR :
	(opcode == `OP_OTHER0 & funct == `OP0_NOR) ? `ALU_NOR :
	(opcode == `OP_XORI | opcode == `OP_OTHER0 & funct == `OP0_XOR) ? `ALU_XOR : 3'b001;
endmodule // mips_decode
