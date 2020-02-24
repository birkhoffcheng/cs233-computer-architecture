.text

# void matrix_mult(int *matr_a, int *matr_b, int *output, unsigned int width) {
#     for (int i = 0; i < width; i++) {
#         for (int j = 0; j < width; j++) {
#             output[i*width + j] = 0;
#             for (int k = 0; k < width; k++) {
#                 output[i*width + j] += matr_a[i*width + k] * matr_b[k*width + j];
#             }
#         }
#     }
# }
#
# // a0: int *matr_a
# // a1: int *matr_b
# // a2: int *output
# // a3: unsigned int width

.globl matrix_mult
matrix_mult:
	jr	$ra


# #define MAX_WIDTH 100
# int working_matrix[MAX_WIDTH*MAX_WIDTH];

# void markov_chain(int *state, int *transitions, unsigned int width, int times) {
#     for (int i = 0; i < times; i++) {
#         matrix_mult(state, transitions, working_matrix, width);
#         copy(state, working_matrix);
#     }
# }
#
# // a0: int *state
# // a1: int *transitions
# // a2: unsigned int width
# // a3: int times

.globl markov_chain
markov_chain:
	# Can access working_matrix from p2_main.s
	jr	$ra
	