module arraySortCheck_control_test;
    reg       clock = 0;
    always #1 clock = !clock;

    reg go = 0;
    reg reset = 1;
    reg[4:0] array, length;

    integer i;

    wire inversion_found, end_of_array; // arraySortCheck_circuit's output
    wire sorted, done, load_input, load_index, select_index; // arraySortCheck_control's output
    arraySortCheck_circuit circuit(inversion_found, end_of_array, zero_length_array, load_input, load_index, select_index, array, length, clock, reset);
    arraySortCheck_control control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);

    initial begin
        $dumpfile("arraySortCheck_control.vcd");
        $dumpvars(0, arraySortCheck_control_test);
        #2      reset = 0;

	// First, lets give an initial value for all
	// registers equal to their 'index' in the register file
	for ( i = 0; i < 32; i = i + 1)
		circuit.rf.r[i] <= i;


  // Test a sorted array of length 5
  # 2 array = 11; length = 5; go = 1;
  # 10 go = 0;
  # 20


  // Test a partially sorted array length 5
  circuit.rf.r[2] <=  32'd1;
  circuit.rf.r[3] <=  32'd2;
  circuit.rf.r[4] <=  32'd3;
  circuit.rf.r[5] <=  32'd2;
  circuit.rf.r[6] <=  32'd5;
  # 2 array = 2; length = 5; go = 1;
  # 10 go = 0;
  # 20

  // Test walking off the edge of array
	circuit.rf.r[7]  <= 32'd7;
	circuit.rf.r[8]  <= 32'd8;
	circuit.rf.r[9]  <= 32'd9;
	circuit.rf.r[10] <= 32'd6;
	circuit.rf.r[11] <= 32'd7;
	# 2 array = 7; length = 3; go = 1;
	# 10 go = 0;
  # 20
        // Add your own testcases here!

        #10 $finish;
    end

endmodule
