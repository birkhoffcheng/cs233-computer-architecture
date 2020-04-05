module pipelined_machine(clk, reset);
	input		clk, reset;

	wire [31:0] PC;
	wire [31:2] next_PC, PC_plus4, PC_target, PC_plus4_DE;
	wire [31:0] inst, inst_IF;
	register #(32) inst_pipeline_reg(inst, inst_IF, clk, 1'b1, reset);
	wire [31:0] imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
	wire [4:0] rs = inst[25:21];
	wire [4:0] rt = inst[20:16];
	wire [4:0] rd = inst[15:11];
	wire [5:0] opcode = inst[31:26];
	wire [5:0] funct = inst[5:0];

	wire [4:0] wr_regnum, wr_regnum_MW;
	wire [2:0] ALUOp;

	wire RegWrite, RegWrite_MW, BEQ, ALUSrc, MemRead, MemRead_MW, MemWrite, MemWrite_MW, MemToReg, MemToReg_MW, RegDst;
	wire PCSrc, zero;
	wire [31:0] rd1_data, rd2_data, rd2_data_MW, B_data, alu_out_data, alu_out_data_DE, load_data, wr_data;


	// DO NOT comment out or rename this module
	// or the test bench will break
	register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */1'b1, reset);

	assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
	adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
	register #(30) pc_plus4_pipeline_reg(PC_plus4_DE, PC_plus4, clk, 1'b1, reset);
	adder30 target_PC_adder(PC_target, PC_plus4_DE, imm[29:0]);
	mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
	assign PCSrc = BEQ & zero;

	// DO NOT comment out or rename this module
	// or the test bench will break
	instruction_memory imem(inst_IF, PC[31:2]);

	mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
		opcode, funct);

	// DO NOT comment out or rename this module
	// or the test bench will break
	regfile rf (rd1_data, rd2_data,
			   rs, rt, wr_regnum_MW, wr_data,
			   RegWrite_MW, clk, reset);

	mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
	alu32 alu(alu_out_data_DE, zero, ALUOp, rd1_data, B_data);
	register #(32) alu_out_pipeline_reg(alu_out_data, alu_out_data_DE, clk, 1'b1, reset);
	// DO NOT comment out or rename this module
	// or the test bench will break
	data_mem data_memory(load_data, alu_out_data, rd2_data_MW, MemRead_MW, MemWrite_MW, clk, reset);
	register #(32) rd2_data_pipeline_reg(rd2_data_MW, rd2_data, clk, 1'b1, reset);
	register #(1) MemRead_pipeline_reg(MemRead_MW, MemRead, clk, 1'b1, reset);
	register #(1) MemWrite_pipeline_reg(MemWrite_MW, MemWrite, clk, 1'b1, reset);
	register #(1) MemToReg_pipeline_reg(MemToReg_MW, MemToReg, clk, 1'b1, reset);
	register #(1) RegWrite_pipeline_reg(RegWrite_MW, RegWrite, clk, 1'b1, reset);
	register #(5) wr_regnum_pipeline_reg(wr_regnum_MW, wr_regnum, clk, 1'b1, reset);
	mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg_MW);
	mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

endmodule // pipelined_machine
