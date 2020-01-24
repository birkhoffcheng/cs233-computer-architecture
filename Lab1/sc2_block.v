// Complete the sc2_block module in this file
// Don't put any code in this file besides the sc2_block
// Refer to sc_block.v for hints!

module sc2_block(s, cout, a, b, cin);
	output s, cout;
	input a, b, cin;
	wire w0, w1, w2;

	or o1(cout, w2, w1);
	sc_block sb0(w0, w1, a, b);
	sc_block sb1(s, w2, w0, cin);
endmodule // sc2_block
