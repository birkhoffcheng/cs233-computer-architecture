.data
# array1 has the largest element in the middle
array1:	.word 0 8 6 39 781 24 607 5
array1_end:
array1_size = (array1_end - array1) / 4



# array2 has the largest element at the end and is pretty large
array2:	.word 3 9 6 81 2 87 12 55 61 12 43 10 91
	.word 8 2 0 73 6 91 54 11 72 72 87 32 99
array2_end:
array2_size = (array2_end - array2) / 4



# array3 has some very large numbers
array3:	.word 9 1 0xbaadf00d 0x12345678 0xdeadbeef 0xcafebabe
array3_end:
array3_size = (array3_end - array3) / 4



# for use in print_hex_and_space
hex_digits:
	# I'm using this as a sequence of characters
	# so it doesn't need to be null terminated
	.ascii "0123456789abcdef"
hex_prefix:
	# I'm using this as a string (in the PRINT_STRING system call)
	# so it needs to be null terminated
	.asciiz "0x"



# syscall constants (magic numbers are bad, m'kay)
PRINT_INT = 1
PRINT_STRING = 4
PRINT_CHAR = 11

.text
print_int_and_space:			# the int to print is already in $a0
	li	$v0, PRINT_INT		# load the syscall option for printing ints
	syscall				# print the integer
	# flow directly into print_space

	
print_space:
	li	$a0, ' '		# print a black space
	li	$v0, PRINT_CHAR		# load the syscall option for printing chars
	syscall				# print the char
	
	jr	$ra			# return to the calling procedure


print_hex_and_space:
	move	$t0, $a0		# preserve hex number to print
	la	$a0, hex_prefix
	li	$v0, PRINT_STRING
	syscall				# print "0x"

	li	$t1, 28			# shift amount
	li	$v0, PRINT_CHAR		# print a bunch of characters
	li	$t2, 0			# haven't seen any non-zeroes yet

phas_loop:
	# it doesn't matter whether I use srl or sra here
	# you should understand why
	srl	$a0, $t0, $t1
	and	$a0, $a0, 0xf		# get digit
	bnez	$a0, phas_print		# always print non-zeroes
	beqz	$t2, phas_next		# skip leading zeroes

phas_print:
	li	$t2, 1			# seen a non-zero
	lbu	$a0, hex_digits($a0)	# get digit's character
	syscall				# and print it

phas_next:
	sub	$t1, $t1, 4		# move onto next digit
	bgez	$t1, phas_loop		# continue till the end of the number

	# this is a tail call
	# if you're calling a function immediately before returning,
	# jumping to the function allows it to return to your caller
	# directly, instead of you calling the function, it returning
	# to you, and then you returning to your caller.
	# In this case, it also saves us from having to set up a stack frame
	# Tails calls are a lot harder to pull off when you do have
	# to set up a stack frame, however
	j	print_space



.globl main
main:
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)

	# test with array1
	la	$a0, array1
	li	$a1, array1_size
	jal	max
	move	$a0, $v0
	jal	print_int_and_space

	# test with array2
	la	$a0, array2
	li	$a1, array2_size
	jal	max
	move	$a0, $v0
	jal	print_int_and_space

	# test with array3
	la	$a0, array3
	li	$a1, array3_size
	jal	max
	move	$a0, $v0
	jal	print_hex_and_space

	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
