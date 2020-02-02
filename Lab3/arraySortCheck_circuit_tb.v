module arraySortCheck_circuit_test;
    reg       clock = 0;
    always #1 clock = !clock;


    reg [4:0] array, length, index_reg;
    reg select_index = 0, load_index = 0, load_input = 0, reset = 1;

    integer i;

    wire inversion_found, end_of_array, zero_length_array;
    arraySortCheck_circuit circuit(inversion_found, end_of_array, zero_length_array, load_input, load_index, select_index, array, length, clock, reset);

    initial begin
        $dumpfile("arraySortCheck_circuit.vcd");
        $dumpvars(0, arraySortCheck_circuit_test);
        #4 reset = 0;

	// First, lets give an initial value for all
	// registers equal to their 'index' in the register file

	for ( i = 0; i < 32; i = i + 1)
		circuit.rf.r[i] <= i;

	// Test a sorted array of length 5
	# 2 array = 11; length = 5; load_input = 1; load_index = 1; select_index = 0;
	# 10 select_index = 1;
  # 20

	// Test a partially sorted array length
	circuit.rf.r[2] <=  32'd1;
	circuit.rf.r[3] <=  32'd2;
	circuit.rf.r[4] <=  32'd3;
	circuit.rf.r[5] <=  32'd2;
	circuit.rf.r[6] <=  32'd5;
  # 2 array = 2; length = 5; load_input = 1; load_index = 1; select_index = 0;
	# 10 select_index = 1;
  # 20

	// Test a descending array
	circuit.rf.r[7]  <= 32'd11;
	circuit.rf.r[8]  <= 32'd10;
	circuit.rf.r[9]  <= 32'd9;
	circuit.rf.r[10] <= 32'd8;
	circuit.rf.r[11] <= 32'd7;
	# 2 array = 7; length = 5; load_input = 1; load_index = 1; select_index = 0;
	# 10 select_index = 1;
  # 20

  // Add your own testcases here!


  #10 $finish;
end

endmodule
