# Disable make's irritating builtin rules
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:


all:
	@echo Please run one of the following targets:
	@echo decoder, full_machine,
	@echo all_test, lwbr_test, fm_test,
	@echo clean
.PHONY: all full_machine all_test lwbr_test fm_test clean

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

decoder: decoder_exe
	./$<

decoder_exe: mips_defines.v decoder.v decoder_tb.v
	iverilog -o $@ -Wall $^

# dumping register values causes spurious VCD warnings to be printed during execution,
# hence the use of grep to filter them up. However, the presence of 'VCD warning' in a
# command freaked a bunch of people out last time, so I'm echoing a fake command instead
# of the actual one to prevent any confusion
full_machine: full_machine_exe
ifeq ($(wildcard memory.text.dat),)
	$(error You need to set up a test case (see handout))
else
	@echo ./full_machine_exe
	@$(UNBUFFER) ./full_machine_exe | grep -v 'VCD warning'
endif

full_machine_exe: mips_defines.v rf.v alu32.v decoder.v mux_lib.v rom.v full_machine.v full_machine_tb.v 
	iverilog -o $@ -Wall $^

all_test: 
	rm -f memory.text.dat memory.data.dat
	ln -s all.text.dat memory.text.dat
	ln -s all.data.dat memory.data.dat

lwbr_test: 
	rm -f memory.text.dat memory.data.dat
	ln -s lwbr.text.dat memory.text.dat
	ln -s lwbr.data.dat memory.data.dat

fm_test: fm.text.dat fm.data.dat
	rm -f memory.text.dat memory.data.dat
	ln -s fm.text.dat memory.text.dat
	ln -s fm.data.dat memory.data.dat

fm.text.dat fm.data.dat: fm.s
	spim-vasm -vasm fm -file fm.s
	rm -f fm.kdata.dat fm.ktext.dat

clean:
	rm -f decoder_exe decoder.vcd full_machine_exe fm.vcd fm.text.dat fm.data.dat
