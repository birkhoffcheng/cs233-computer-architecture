# Basic lw and beq tests
.data
array:	.word	1	255	1024	0xcafebabe	target

.text
main:   
	la	$2, array	# $2  = 0x10010000	testing lui
				      
	lw	$3, 12($2)	# $3  = 0xcafebabe	
	slt	$8, $3, $0	# $8  = 1	  	testing slt
	slt	$9, $2, $0	# $9  = 0
	slt	$10, $0, $2	# $10 = 1
	slt	$11, $2, $3	# $11 = 0

	bne	$9, $0, end
	beq	$11, $8, target

	lbu	$4, 12($2)	# $4 = be		test load byte unsigned
	lbu	$5, 13($2)	# $5 = ba
	lbu	$6, 14($2)	# $6 = fe
	lbu	$7, 15($2)	# $7 = ca

	sw	$0, 0($2)	#			test stores
	lw	$12, 0($2)	# $12 = 0
	sb	$4, 2($2)	
	lw	$13, 0($2)	# $13 = 0x00be0000

	addm	$18, $2, $2	# $18 = 0x10bf0000

	lw	$14, 16($2)	# $14 = target = 0x0000005c
	jr	$14  		#  PC = 0x0000005c	test indirect branches

skipped:
	addi	$15, $zero, 1	# skipped so $15 remains 0
	j	skipped	    	# skipped

end:	lui	$17, 0xf00f	# $17 = 0xf00f0000
	j	end

target:
	addi	$16, $zero, 2	# $16 = 2
	bne	$16, $0, end	# unconditional jump



