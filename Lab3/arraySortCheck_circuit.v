`define ALU_ADD    3'h0
`define ALU_SUB    3'h1

// arraySortCheck datapath
module arraySortCheck_circuit(inversion_found, end_of_array, zero_length_array, load_input, load_index, select_index, array, length, clk, reset);
	output inversion_found, end_of_array, zero_length_array;
	input load_input, load_index, select_index;
	input [4:0] array, length;
	input clk, reset;

	reg [4:0]  array_reg, length_reg, index_reg;

	always@(posedge clk)
	begin
		if (reset == 1'b1)
			begin
				array_reg <= 0;
				length_reg <= 0;
				index_reg <= 0;
			end
		else
			begin
				if((reset == 1'b0) && (load_input == 1'b1))
				begin
					array_reg <= array;
					length_reg <= length;
				end

				if((reset == 1'b0) && (load_index == 1'b1) && (select_index == 1'b0))
				begin
					index_reg <= 0;
				end

				else if ((reset == 1'b0) && (load_index == 1'b1) && (select_index == 1'b1))
				begin
					index_reg <= index_reg + 1;
				end
			end
		end


	wire [31:0] array_alu_in, index_alu_in;
	assign array_alu_in[31:5] = 0;
	assign array_alu_in[4:0] = array_reg;
	assign index_alu_in[31:5] = 0;
	assign index_alu_in[4:0] = index_reg;

	wire [31:0] array_plus_index, array_plus_index_plus_1;
	assign array_plus_index = array_alu_in + index_alu_in;
	assign array_plus_index_plus_1 = array_plus_index + 1;

	wire [31:0] a, b;
	regfile rf(a, b, array_plus_index[4:0], array_plus_index_plus_1[4:0], , , , clk, reset);

	wire a_lt_b_1, a_ne_b_1;
	comparator #(32) compareElements(a_lt_b_1, a_ne_b_1, a, b);
	assign inversion_found = (~a_lt_b_1) & a_ne_b_1;

	wire [4:0] length_minus_1;
	assign length_minus_1 = length_reg - 1;

	wire zero_length_case;
	comparator #(5) comparelengthzero(, zero_length_case, length_reg, 5'd0);
  assign zero_length_array = ~zero_length_case;

	wire a_lt_b_2;
	comparator #(5) comparelength(a_lt_b_2, , index_reg, length_minus_1);
	assign end_of_array = ~a_lt_b_2;

endmodule
