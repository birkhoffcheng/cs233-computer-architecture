module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array, zero_length_array;
	input clock, reset;

	wire garbage, prep, increment_index, return_true, return_false;

	wire garbage_next = reset | (garbage & ~go);
	wire prep_next = ~reset & (return_true | return_false | garbage | prep) & go;
	wire increment_index_next = ~reset & ((prep & ~go) | (increment_index & ~inversion_found & ~end_of_array & ~zero_length_array));
	wire return_true_next = ~reset & ((increment_index & (end_of_array | zero_length_array)) | (return_true & ~go));
	wire return_false_next = ~reset & ((inversion_found & ~end_of_array & ~zero_length_array) | (return_false & ~go));

	dffe d0(garbage, garbage_next, clock, 1'b1, 1'b0);
	dffe d1(prep, prep_next, clock, 1'b1, 1'b0);
	dffe d2(increment_index, increment_index_next, clock, 1'b1, 1'b0);
	dffe d3(return_true, return_true_next, clock, 1'b1, 1'b0);
	dffe d4(return_false, return_false_next, clock, 1'b1, 1'b0);

	assign sorted = return_true;
	assign done = return_true | return_false;
	assign load_input = prep;
	assign load_index = prep | increment_index;
	assign select_index = increment_index;
endmodule
