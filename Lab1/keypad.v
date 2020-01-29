module keypad(valid, number, a, b, c, d, e, f, g);
	output valid;
	output [3:0] number;
	input a, b, c, d, e, f, g;
	wire a_or_c, b_or_c, d_or_f, a_and_f, b_and_e, c_and_e, dfac, dbc;

	or o0(a_or_c, a, c);
	or o1(b_or_c, b, c);
	or o2(d_or_f, d, f);
	and a0(a_and_f, a, f);
	and a1(b_and_e, b, e);
	and a2(c_and_e, c, e);

	and a3(valid, g, a_or_c);

	and a4(dfac, d_or_f, a_or_c);
	or o3(number[0], b_and_e, dfac);

	and a5(dbc, d, b_or_c);
	or o4(number[1], dbc, c_and_e, a_and_f);

	or o5(number[2], e, a_and_f);

	and a6(number[3], f, b_or_c);
endmodule // keypad
