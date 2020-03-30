# Disable make's irritating builtin rules
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:


all: 
	@echo Please run one of the following targets:
	@echo pipelined_adding_machine, pipelined_machine,
	@echo no_hazards_or_flushing, forwarding, stalling, flushing, pipeline_test,
	@echo clean

TESTS = no_hazards_or_flushing forwarding stalling flushing pipeline_test
.PHONY: all pipelined_machine pipelined_adding_machine clean $(TESTS)

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

# dumping register values causes spurious VCD warnings to be printed during execution,
# hence the use of grep to filter them up. However, the presence of 'VCD warning' in a
# command freaked a bunch of people out last time, so I'm echoing a fake command instead
# of the actual one to prevent any confusion
pipelined_machine: pipelined_machine_exe 
ifeq ($(wildcard memory.text.dat),)
	$(error You need to set up a test case (see handout))
else
	@echo Running with test $$(basename $$(readlink memory.text.dat) .text.dat)
	@echo ./$<
	@$(UNBUFFER) ./$< | grep -v 'VCD warning'
endif

pipelined_machine_exe: mips_defines.v modules.v rom.v mux_lib.v pipelined_machine.v pipelined_machine_tb.v 
	iverilog -o $@ -Wall $^

pipelined_adding_machine: pipelined_adding_machine_exe 
	./$<

pipelined_adding_machine_exe: mips_defines.v modules.v am_rom.v pipelined_adding_machine.v pipelined_adding_machine_tb.v 
	iverilog -o $@ -Wall $^

clean:
	rm -f pipelined_adding_machine_exe pam.vcd pipelined_machine_exe pm.vcd


$(TESTS): %: %.text.dat
	rm -f memory.text.dat memory.data.dat
	ln -s $*.text.dat memory.text.dat
	ln -s $*.data.dat memory.data.dat

%.text.dat: %.s
	spim-vasm -vasm $* -file $<
	rm -f $*.ktext.dat $*.kdata.dat
