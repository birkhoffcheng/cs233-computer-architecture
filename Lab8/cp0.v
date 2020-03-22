`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER	5'd14

module cp0(rd_data, EPC, TakenInterrupt, wr_data, regnum, next_pc, MTC0, ERET, TimerInterrupt, clock, reset);
	output [31:0] rd_data;
	output [29:0] EPC;
	output TakenInterrupt;
	input [31:0] wr_data;
	input [4:0] regnum;
	input [29:0] next_pc;
	input MTC0, ERET, TimerInterrupt, clock, reset;
	wire [31:0] user_status, decoder32_out;
	wire exception_level;
	wire [29:0] epc_register_in;
	wire [31:0] cause_register = {16'b0, TimerInterrupt, 15'b0};
	wire [31:0] status_register = {16'b0, user_status[15:8], 6'b0, exception_level, user_status[0]};
	decoder32 dec(decoder32_out, regnum, MTC0);
	register user_status_register(user_status, wr_data, clock, decoder32_out[12], reset);
	dffe exception_level_dffe(exception_level, 1'b1, clock, TakenInterrupt, reset | ERET);
	mux2v #(30) taken_interrupt_mux(epc_register_in, wr_data[31:2], next_pc, TakenInterrupt);
	register #(30) epc_register(EPC, epc_register_in, clock, TakenInterrupt | decoder32_out[14], reset);
	mux32v #(32) rd_data_mux(rd_data, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, status_register, cause_register, {EPC, 2'b0}, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, regnum);
	assign TakenInterrupt = (cause_register[15] & status_register[15]) & (~status_register[1] & status_register[0]);
endmodule
