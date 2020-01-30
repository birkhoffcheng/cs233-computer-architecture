/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
	// Length must be a multiple of 8
	assert((length % 8) == 0);

	// allocates an array for the output
	char *message_out = new char[length];
	for (int i = 0; i < length; i++) {
		message_out[i] = 0;    // Initialize all elements to zero.
	}

	// TODO: write your code here
	for (int block = 0; block < length; block += 8) {
		for (int number = 0; number < 8; number++) {
			for (int bit_index = 0; bit_index < 8; bit_index++) {
				message_out[block + bit_index] |= ((message_in[block + number] >> bit_index) & 1) << number;
			}
		}
	}
	return message_out;
}
