.data
# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11
.globl GRIDSIZE
GRIDSIZE = 4

.text

########################################################################
# BEWARE!
# DO NOT EDIT CONTENTS OF THIS FILE.
# THIS FILE WILL NOT BE GRADED
########################################################################

# print int and space ##################################################
#
# argument $a0: number to print
.globl print_int_and_space
print_int_and_space:
	li	$v0, PRINT_INT	# load the syscall option for printing ints
	syscall			# print the number

	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure

# print boolean and newline ##################################################
#
# argument $a0: boolean to print
.globl print_bool_and_newline
print_bool_and_newline:
	li $t0, 'F'				 # FALSE
	beq $a0, $0, print_char_and_newline_false
	li $t0, 'T' 			 # TRUE
print_char_and_newline_false:
	move $a0, $t0
	j print_char_and_newline # Calling function in a slightly unusual, yet valid way


# print char and newline ##################################################
#
# argument $a0: number to print
.globl print_char_and_newline
print_char_and_newline:
	li	$v0, PRINT_CHAR		# load the syscall option for printing chars
	syscall					# print the number

	li   	$a0, '\n'      	# print a black space
	li	$v0, PRINT_CHAR		# load the syscall option for printing chars
	syscall					# print the char
	
	jr	$ra					# return to the calling procedure

# print char ###########################################################
#
# argument $a0: char to print
.globl print_char
print_char:
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure
