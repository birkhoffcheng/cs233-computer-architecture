# Disable make's irritating builtin rules
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:


all:
	@echo Please run one of the following targets:
	@echo timer, cp0, machine, clean
.PHONY: all machine clean test regression custom

# Verilog simulations sometimes enter infinite loops, and piping the simulation
# through grep (below) causes it to be block-buffered, meaning nothing gets
# printed out to the screen, confusing people. This is to force line-buffering;
# script should be available everywhere but it uses different parameters on
# Linux and OS X, making it simpler to use stdbuf on Linux instead
ifneq ($(shell command -v stdbuf;),)
    UNBUFFER = stdbuf -oL
else ifneq ($(shell command -v script;),)
    UNBUFFER = script -q /dev/null
endif

timer: timer_exe
	./$<

timer_exe: mips_defines.v modules.v timer.v timer_tb.v
	iverilog -o $@ -Wall $^

cp0: cp0_exe
	./$<

cp0_exe: mips_defines.v modules.v mux_lib.v cp0.v cp0_tb.v
	iverilog -o $@ -Wall $^

# dumping register values causes spurious VCD warnings to be printed during execution,
# hence the use of grep to filter them up. However, the presence of 'VCD warning' in a
# command freaked a bunch of people out last time, so I'm echoing a fake command instead
# of the actual one to prevent any confusion
machine: machine_exe memory.text.dat memory.data.dat memory.ktext.dat memory.kdata.dat
	@echo ./$<
	@$(UNBUFFER) ./$< | grep -v 'VCD warning'

machine_exe: mips_defines.v modules.v mux_lib.v rom.v timer.v cp0.v machine.v machine_tb.v 
	iverilog -o $@ -Wall $^

memory.text.dat memory.data.dat memory.ktext.dat memory.kdata.dat: test.s
	spim-vasm -vasm memory -file test.s

clean:
	rm -f *_exe *.vcd
