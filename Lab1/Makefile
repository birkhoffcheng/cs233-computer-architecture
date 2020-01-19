CXX = clang++
LD = clang++
CPPFLAGS = -g -Wall -Werror

.PHONY: all keypad clean

EXES = keypad_exe extractMessage countOnes
all: $(EXES)

keypad: keypad_exe
	./$<

keypad_exe: keypad.v keypad_tb.v
	iverilog -o $@ -Wall $^

extractMessage: extractMessage_main.o extractMessage.o
	$(LD) -o $@ $(filter %.o,$^)

countOnes: countOnes_main.o countOnes.o
	$(LD) -o $@ $^

extractMessage_main.o: extractMessage_main.cpp extractMessage.h

extractMessage.o: extractMessage.cpp extractMessage.h 

countOnes_main.o: countOnes_main.cpp countOnes.h

countOnes.o: countOnes.cpp countOnes.h

clean:
	rm -f $(EXES) *.o *.exe *.vcd
