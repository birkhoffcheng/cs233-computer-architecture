/**
 * @file
 * This file contains code to run your countOnes function
 * against an input number to facilitate testing.
 *
 * We will not look at this file during grading, so don't put code
 * you want graded here.
 */


#include <cstdlib>
#include <iostream>
#include "countOnes.h"

using namespace std;

int main(int argc, char * argv[]) {
	if (argc != 2) {
		cerr << "Usage: " << argv[0] << " number\n";
		return 1;
	}

	char * input = argv[1];
	int base = 10;
	if (input[0] == '0' && (input[1] == 'b' || input[1] == 'x')) {
		base = input[1] == 'b' ? 2 : 16;
		input += 2;
	}

	char * endptr;
	unsigned number = strtoul(input, &endptr, base);
	if (*endptr != '\0') {
		cerr << "Please enter a valid number\n";
		return 1;
	}

	unsigned count = countOnes(number);
	cout << count << "\n";
}
