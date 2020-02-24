.data

matr_a:
.word	1  0  0
.word	0  1  0
.word	0  0  1

matr_b:
.word	2  3  4
.word	5  6  7
.word	8  9 10

matr_c:
.word	9  9  9
.word	9  9  9
.word	9  9  9

matr_output:
.word   0:9

.globl working_matrix
working_matrix: .space 10000

.text

# main function ########################################################
#
#  this is a function that will test matrix_mult and markov_chain
#

.globl main
main:
	sub		$sp, $sp, 4
	sw		$ra, 0($sp)		# save $ra on stack

	# Test2 from lab6.cpp
	la		$a0, matr_a		# test matrix_mult
	la		$a1, matr_b
	la		$a2, matr_output
	li		$a3, 3
	jal	matrix_mult
	
	la		$a0, matr_output
	li		$a1, 3
	jal	matrix_print
	# Should print
	# 2  3  4
	# 5  6  7
	# 8  9 10

	li $a0, '\n'
	jal print_char

	la		$a0, matr_b		# test matrix_mult
	la		$a1, matr_c
	la		$a2, matr_output
	li		$a3, 3
	jal	matrix_mult
	
	la		$a0, matr_output
	li		$a1, 3
	jal	matrix_print
	# Should print
	# 81 81 81  
	# 162 162 162
	# 243 243 243

	li $a0, '\n'
	jal print_char

	# Test3 from lab6.cpp
	la		$a0, matr_b		# test markov_chain
	la		$a1, matr_a
	li		$a2, 3
	li		$a3, 5
	jal	markov_chain

	la		$a0, matr_b
	li		$a1, 3
	jal	matrix_print
	# Should print
	# 2  3  4
	# 5  6  7
	# 8  9 10

	li $a0, '\n'
	jal print_char

	la		$a0, matr_c		# test markov_chain
	la		$a1, matr_b
	li		$a2, 3
	li		$a3, 2
	jal	markov_chain

	la		$a0, matr_c
	li		$a1, 3
	jal	matrix_print
	# Should print
	# 2592 3078 3564
	# 2592 3078 3564
	# 2592 3078 3564

	lw	$ra, 0($sp) 		# pop $ra from the stack
	add	$sp, $sp, 4
	jr	$ra
