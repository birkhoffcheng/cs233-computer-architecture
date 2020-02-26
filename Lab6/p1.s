.text

# // Ignore integer overflow for addition
# int update_alert_level(unsigned int* stockpiles, unsigned int cutoff,
#   unsigned int alert_level) {
#     int total_monster = 0;
#     for (int i = 0; i < 10; i++) {
#         total_monster += stockpiles[i];
#     }
#     if (total_monster < cutoff) {
#         return alert_level + 1;
#     } else if (total_monster == cutoff) {
#         return alert_level;
#     } else {
#         return alert_level - 1;
#     }
# }
# // a0: unsigned int *stockpiles
# // a1: unsigned int cutoff
# // a2: unsigned int alert_level

.globl update_alert_level
update_alert_level:
	andi	$t0, $zero, 0		# int total_monster = 0
	andi	$t1, $zero, 0		# int i = 0
	ori		$t2, $zero, 10		# t2 = 10
for_start:
	bge		$t1, $t2, for_done	# if (i >= t2) end for loop
	lw		$t3, 0($a0)			# t3 = *stockpiles
	add		$t0, $t0, $t3		# total_monster += t3
	addi	$a0, $a0, 4			# stockpiles++
	addi	$t1, $t1, 1			# i++
	j		for_start
for_done:
	blt		$t0, $a1, ret_alp1	# if $t0 < $a1 then return alert_level + 1
	beq		$t0, $a1, ret_al	# if $t0 == $a1 then return alert_level
	sub 	$v0, $a2, 1			# else $v0 = alert_level - 1
	jr		$ra					# return
ret_alp1:
	addi	$v0, $a2, 1			# $v0 = alert_level + 1
	jr		$ra					# return
ret_al:
	move 	$v0, $a2			# $v0 = alert_level
	jr		$ra					# return
