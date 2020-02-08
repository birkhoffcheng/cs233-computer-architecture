module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array, zero_length_array;
	input clock, reset;

	wire sGarbage, sDN, sIncIndex, sTrue, sFalse;

	wire sGarbage_next = reset | ((sTrue | sFalse) & go) | (sGarbage & ~go);
	wire sDN_next = ~reset & ((sGarbage & go) | sIncIndex);
	wire sIncIndex_next = ~reset & sDN & ~inversion_found & ~end_of_array & ~zero_length_array;
	wire sTrue_next = ~reset & ((sDN & (end_of_array | zero_length_array)) | (sTrue & ~go));
	wire sFalse_next = ~reset & ((sDN & inversion_found) | (sFalse & ~go));

	dffe d0(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
	dffe d1(sDN, sDN_next, clock, 1'b1, 1'b0);
	dffe d2(sIncIndex, sIncIndex_next, clock, 1'b1, 1'b0);
	dffe d3(sTrue, sTrue_next, clock, 1'b1, 1'b0);
	dffe d4(sFalse, sFalse_next, clock, 1'b1, 1'b0);

	assign sorted = sTrue;
	assign done = sTrue | sFalse;
	assign load_input = sGarbage;
	assign load_index = sGarbage | sIncIndex;
	assign select_index = sIncIndex;
endmodule
