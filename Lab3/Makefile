.PHONY: all clean arraySortCheck_control register
all:
	@echo Please use one of the make targets specified in the handout.


arraySortCheck_circuit: arraySortCheck_circuit_exe
	./$<

arraySortCheck_circuit_exe: arraySortCheck_circuit_tb.v arraySortCheck_circuit.v register.v arraySortCheck_lib.v
	iverilog -o $@ -Wall $^

arraySortCheck_control: arraySortCheck_control_exe
	./$<

arraySortCheck_control_exe: arraySortCheck_control_tb.v arraySortCheck_control.v arraySortCheck_circuit.v arraySortCheck_lib.v register.v
	iverilog -o $@ -Wall $^

register: register_exe
	./$<

register_exe: register.v register_tb.v
	iverilog -o $@ -Wall $^

reg_writer_exe: reg_writer_tb.v reg_writer.v register.v arraySortCheck_lib.v
	iverilog -o $@ -Wall $^

reg_writer: reg_writer_exe
	./$<
clean:
	rm -f *_exe *.vcd
