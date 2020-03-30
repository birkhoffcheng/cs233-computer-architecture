.data
array:	.word	1	255	1024	100	200

# every register except $0 starts holding the address of "array"
#
# this is a cheat so that we don't need to implement addi and lui in
# our pipelined machine.

.text
main:   
	lw	$2,  0($20)		# $2 = 1	(0x1)
	lw	$3,  4($20)		# $3 = 255	(0xff)
	lw	$4,  8($20)		# $4 = 1024	(0x400)
	lw	$5, 12($20)		# $5 = 100	(0x64)
	lw	$6, 16($20)		# $6 = 200	(0xc8)

	sw	$6,  4($20)		
	lw	$7,  4($20)		# $7 = 200	(0xc8)

	add	$8, $5, $5		# $8 = 200	(0xc8)
	sub	$9, $4, $3		# $9 = 769	(0x301)
	add	$10, $8, $5		# $10 = 300	(0x12c)
	and	$11, $10, $3		# $11 = 44	(0x2c)
	sw	$11, 0($20)		

	beq	$8, $6, skip

	add	$31, $8, $0		# should not execute

skip:
	slt	$12, $11, $5		# $12 = 1	(0x1)
	slt	$13, $6, $7		# $13 = 0	(0x0)
	or	$14, $11, $4		# $14 = 1068	(0x42c)
	lw	$15, 0($20)		# $15 = 44	(0x2c)
	slt	$16, $15, $2		# $16 = 0	(0x0)
	beq	$16, $0, skip2

	add	$30, $2, $0		# should not execute

skip2:
	beq	$2, $0, never_reach
	or	$17, $2, $6		# $17 = 201	(0xc9)
	beq	$13, $16, skip2

never_reach:
	add	$29, $8, $10		# should not execute 
