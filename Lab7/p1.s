.text

# // part 1 p1.s
# unsigned char find_payment(TreeNode* trav) {
# 	// Base case
# 	if (trav == NULL) {
# 		return 0;
# 	}
# 	// Recurse once for each child
# 	unsigned char payment_left = find_payment(trav->left);
# 	unsigned char payment_center = find_payment(trav->center);
# 	unsigned char payment_right = find_payment(trav->right);
# 	unsigned char value = payment_left + payment_center + payment_right + trav->value;
# 	return value / 2;
# }

.globl find_payment
find_payment:
	bne		$a0, $zero, else	# if trav == 0
	addi	$v0, $zero, 0		# return 0
	jr		$ra
else:
	sub		$sp, $sp, 12
	sw		$ra, 0($sp)
	sw		$s0, 4($sp)
	sw		$s1, 8($sp)
	move 	$s0, $a0			# $s0 = trav
	lw		$a0, 0($s0)			# trav->left
	jal		find_payment		# find_payment(trav->left)
	move 	$s1, $v0			# $s1 = payment_left
	lw		$a0, 4($s0)			# trav->center
	jal		find_payment		# find_payment(trav->center)
	add		$s1, $s1, $v0		# $s1 = payment_left + payment_center
	lw		$a0, 8($s0)			# trav->right
	jal		find_payment		# find_payment(trav->right)
	lbu		$t0, 12($s0)		# trav->value
	add		$v0, $v0, $s1		# value = payment_left + payment_center + payment_right
	add		$v0, $v0, $t0		# value = payment_left + payment_center + payment_right + trav->value
	srl		$v0, $v0, 1			# value >> 1
	lw		$ra, 0($sp)
	lw		$s0, 4($sp)
	lw		$s1, 8($sp)
	addi	$sp, $sp, 12
	jr		$ra
