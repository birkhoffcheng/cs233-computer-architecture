.data

stockpiles:   .word 1, 3, 5, 2, 1, 1, 1, 1, 1, 1
stockpiles2:  .word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

.text
# main function ########################################################
#
#  this will test update_alert_level
#

.globl main
main:
	# Test1 from lab6.cpp
	sub	$sp, $sp, 8
	sw	$s0, 0($sp)			# save $s0 on stack
	sw	$ra, 4($sp)			# save $ra on stack
	
	li   $s0, 5 # alert_level = 5

	la	 $a0, stockpiles # test update_alert_level
	li   $a1, 5
	move $a2, $s0
	jal	update_alert_level
	move $s0, $v0

	move $a0, $s0 # print alert leve and new line
	jal print_int_and_space # Should print 4
	li $a0, '\n'
	jal print_char



	la	 $a0, stockpiles2 # test update_alert_level
	li 	 $a1, 11
	move $a2, $s0
	jal	update_alert_level
	move $s0, $v0

	move $a0, $s0 # print alert leve and new line
	jal print_int_and_space # Should print 5
	li $a0, '\n'
	jal print_char


	# add new tests here


	lw	$ra, 4($sp)			# pop $ra from the stack
	lw	$s0, 0($sp)			# pop $s0 from the stack
	add	$sp, $sp, 8
	jr	$ra
