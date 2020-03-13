module timer(TimerInterrupt, cycle, TimerAddress,
			data, address, MemRead, MemWrite, clock, reset);
	output TimerInterrupt;
	output [31:0] cycle;
	output TimerAddress;
	input [31:0] data, address;
	input MemRead, MemWrite, clock, reset;
	wire [31:0] alu_out, cycle_counter_out, interrupt_cycle_out;
	wire TimerWrite = address == 32'hffff001c & MemWrite;
	wire TimerRead = address == 32'hffff001c & MemRead;
	assign TimerAddress = address == 32'hffff001c | address == 32'hffff006c;
	wire acknowledge = address == 32'hffff006c & MemWrite;
	// complete the timer circuit here

	// HINT: make your interrupt cycle register reset to 32'hffffffff
	//		(using the reset_value parameter)
	//		to prevent an interrupt being raised the very first cycle
	alu32 main_alu(alu_out,,, 3'h0, cycle_counter_out, 32'b1);
	register cycle_counter(cycle_counter_out, alu_out, clock, 1'b1, reset);
	register #(32, 32'hffffffff) interrupt_cycle(interrupt_cycle_out, data, clock, TimerWrite, reset);
	tristate cycle_tristate(cycle, cycle_counter_out, TimerRead);
	dffe interrupt_line(TimerInterrupt, 1'b1, clock, interrupt_cycle_out == cycle_counter_out, acknowledge | reset);
endmodule
