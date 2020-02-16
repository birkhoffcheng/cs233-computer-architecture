// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
	output except;
	input clock, reset;

	wire [31:0] inst;
	wire [31:0] PC, next_PC;
	wire [31:0] rsData, rtData, rdData;
	wire [4:0] rsAddr, rtAddr, rdAddr;
	wire writeenable, rd_src;
	wire [31:0] alu_in_b, sign_extended_immediate, zero_extended_immediate;
	wire [1:0] alu_src2;
	wire [2:0] alu_op;

	alu32 alu_0(next_PC,,,, PC, 32'h00000004, `ALU_ADD);

	// DO NOT comment out or rename this module
	// or the test bench will break
	register #(32) PC_reg(PC, next_PC, clock, 1'b1, reset);

	// DO NOT comment out or rename this module
	// or the test bench will break
	instruction_memory im(inst, PC[31:2]);

	// DO NOT comment out or rename this module
	// or the test bench will break
	regfile rf(rsData, rtData, inst[25:21], inst[20:16], rdAddr, rdData, writeenable, clock, reset);
	
	mux2v #(5) mux_0(rdAddr, inst[15:11], inst[20:16], rd_src);
	mux3v #(32) mux_1(alu_in_b, rtData, sign_extended_immediate, zero_extended_immediate, alu_src2);
	alu32 alu_1(rdData,,,, rsData, alu_in_b, alu_op);
	assign sign_extended_immediate = {{16{inst[15]}}, inst[15:0]};
	assign zero_extended_immediate = {16'h0000, inst[15:0]};
	mips_decode mips_decoder(rd_src, writeenable, alu_src2, alu_op, except, inst[31:26], inst[5:0]);
endmodule // arith_machine
