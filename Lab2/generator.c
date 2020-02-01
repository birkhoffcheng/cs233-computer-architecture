// a code generator for the ALU chain in the 32-bit ALU
// look at example_generator.cpp for inspiration

// make generator
// ./generator
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#define WIDTH 32

int main(int argc, char **argv) {
	unsigned ctr = 1;
	for (ctr; ctr < WIDTH; ctr++) {
		printf("\talu1 alu_%d(out[%d], carryw%d, A[%d], B[%d], carryw%d, control);\n", ctr, ctr, ctr, ctr, ctr, ctr-1);
	}
	return 0;
}
