// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
	output out;
	input A, B;
	input [1:0] control;
	wire a_and_b, a_or_b, a_nor_b, a_xor_b;
	and	a1(a_and_b, A, B);
	or o1(a_or_b, A, B);
	nor n1(a_nor_b, A, B);
	xor x1(a_xor_b, A, B);
	mux4 m1(out, a_and_b, a_or_b, a_nor_b, a_xor_b, control);
endmodule // logicunit
