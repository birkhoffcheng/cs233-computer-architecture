/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here

	unsigned left = input & 0xAAAAAAAA;
	unsigned right = input & 0x55555555;
	unsigned sum = (left >> 1) + right;

	left = sum & 0xCCCCCCCC;
	right = sum & 0x33333333;
	sum = (left >> 2) + right;

	left = sum & 0xF0F0F0F0;
	right = sum & 0x0F0F0F0F;
	sum = (left >> 4) + right;

	left = sum & 0xFF00FF00;
	right = sum & 0x00FF00FF;
	sum = (left >> 8) + right;

	left = sum & 0xFFFF0000;
	right = sum & 0x0000FFFF;
	sum = (left >> 16) + right;

	return sum;
}
