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
# t0 i
# t1 j
# t2 k
# t3 output[i*width + j]
# t4 index tmp
# t5 var tmp

.globl matrix_mult
matrix_mult:
	and	$t0, $zero, 0	# i = 0
begin_for_one:
	bge	$t0, $a3, end_for_one
	and	$t1, $zero, 0	# j = 0
begin_for_two:
	bge	$t1, $a3, end_for_two
	and	$t3, $zero, 0	# output[i*width + j] = 0
	and	$t2, $zero, 0	# k = 0
begin_for_three:
	bge	$t2, $a3, end_for_three
	mul	$t4, $t0, $a3	# t4 = i * width
	add	$t4, $t4, $t2	# t4 = i * width + k
	mul	$t4, $t4, 4		# t4 = t4 * 4
	add	$t4, $a0, $t4	# $t4 = $a0 + $t4
	lw	$t5, 0($t4)		# t5 = matr_a[i*width + k]
	mul	$t4, $t2, $a3	# t4 = k * width
	add	$t4, $t4, $t1	# t4 = k * width + j
	mul	$t4, $t4, 4		# t4 = t4 * 4
	add	$t4, $a1, $t4	# $t4 = $a1 + $t4
	lw	$t4, 0($t4)		# t4 = matr_b[k*width + j]
	mul	$t4, $t4, $t5	# t4 = t4 * t5
	add	$t3, $t3, $t4	# $t3 = $t3 + $t4
	add	$t2, $t2, 1		# k++
	j 	begin_for_three
end_for_three:
	mul	$t4, $t0, $a3	# t4 = i * width
	add	$t4, $t4, $t1	# t4 = i * width + j
	mul	$t4, $t4, 4		# t4 = t4 * 4
	add	$t4, $t4, $a2	# t4 = output + t4
	sw	$t3, 0($t4)		# store 
	add	$t1, $t1, 1		# j++
	j	begin_for_two
end_for_two:
	add	$t0, $t0, 1		# i++
	j	begin_for_one
end_for_one:
	jr	$ra


# #define MAX_WIDTH 100
# int working_matrix[MAX_WIDTH*MAX_WIDTH];

# void markov_chain(int *state, int *transitions, unsigned int width, int times) {
#     for (int i = 0; i < times; i++) {
#         matrix_mult(state, transitions, working_matrix, width);
#         copy(state, working_matrix, width);
#     }
# }
#
# // a0: int *state
# // a1: int *transitions
# // a2: unsigned int width
# // a3: int times

.globl markov_chain
markov_chain:
	sub		$sp, $sp, 24	# $sp = $sp - 20
	sw		$ra, 0($sp)
	sw		$s0, 4($sp)
	sw		$s1, 8($sp)
	sw		$s2, 12($sp)
	sw		$s3, 16($sp)
	sw		$s4, 20($sp)
	move	$s0, $a0		# $s0 = state
	move 	$s1, $a1		# $s1 = transitions
	move 	$s2, $a2		# $s2 = width
	move 	$s3, $a3		# $s3 = times
	and		$s4, $zero, 0	# i = 0
for:
	bge		$s4, $s3, done_for	# if i >= times then done_for
	move 	$a0, $s0		# state = state_backup
	move 	$a1, $s1		# transitions = transitions_backup
	la		$a2, working_matrix
	move 	$a3, $s2		# width = width_backup
	jal		matrix_mult		# jump to matrix_mult and save position to $ra
	move 	$a0, $s0		# state = state_backup
	la		$a1, working_matrix
	move 	$a2, $s2		# width = width_backup
	jal		copy			# jump to copy and save position to $ra
	add		$s4, $s4, 1		# i++
	j		for				# jump to for
done_for:
	lw		$ra, 0($sp)
	lw		$s0, 4($sp)
	lw		$s1, 8($sp)
	lw		$s2, 12($sp)
	lw		$s3, 16($sp)
	lw		$s4, 20($sp)
	add		$sp, $sp, 24	# $sp = $sp + 20
	jr		$ra
