// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
	output except;
	input clock, reset;

	wire [31:0] inst;
	wire [31:0] PC, pc_plus_four, next_pc;
	wire [31:0] rsData, rtData, rdData, branch, alu_or_mem, alu_out, alu_or_slt, alu_src2_in, mem_out, data_out, addm_out, not_addm;
	wire [7:0] byte_out;
	wire [4:0] rdAddr;
	wire [2:0] alu_op;
	wire [1:0] control_type, alu_src2;
	wire writeenable, rd_src, lui, slt, byte_load, word_we, byte_we, mem_read, overflow, zero, negative, addm;

	register #(32) PC_reg(PC, next_pc, clock, 1'b1, reset);
	alu32 pc_alu(pc_plus_four,,,, PC, 32'h00000004, `ALU_ADD);
	alu32 branch_alu(branch,,,, pc_plus_four, {{14{inst[15]}}, inst[15:0], 2'b00}, `ALU_ADD);
	alu32 addm_alu(addm_out,,,, rtData, data_out, `ALU_ADD);
	alu32 main_alu(alu_out, overflow, zero, negative, rsData, alu_src2_in, alu_op);

	instruction_memory im(inst, PC[31:2]);
	data_mem data_memory(data_out, alu_out, rtData, word_we, byte_we, clock, reset);

	regfile rf(rsData, rtData, inst[25:21], inst[20:16], rdAddr, rdData, writeenable, clock, reset);
	mux2v #(32) addm_mux(rdData, not_addm, addm_out, addm);
	mux2v #(5) rd_src_mux(rdAddr, inst[15:11], inst[20:16], rd_src);
	mux2v #(32) lui_mux(not_addm, alu_or_mem, {inst[15:0], 16'b0}, lui);
	mux2v #(32) slt_mux(alu_or_slt, alu_out, {31'b0, (negative ^ overflow)}, slt);
	mux2v #(32) mem_read_mux(alu_or_mem, alu_or_slt, mem_out, mem_read);
	mux2v #(32) byte_load_mux(mem_out, data_out, {24'b0, byte_out}, byte_load);
	mux4v #(32) alu_src2_mux(alu_src2_in, rtData, {{16{inst[15]}}, inst[15:0]}, {16'b0, inst[15:0]}, 32'b0, alu_src2);
	mux4v #(8) byte_selection_mux(byte_out, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], alu_out[1:0]);
	mux4v #(32) pc_mux(next_pc, pc_plus_four, branch, {pc_plus_four[31:28], inst[25:0], 2'b00}, rsData, control_type);

	mips_decode decoder(alu_op, writeenable, rd_src, alu_src2, except, control_type, mem_read, word_we, byte_we, byte_load, slt, lui, addm, inst[31:26], inst[5:0], zero);
endmodule // full_machine
