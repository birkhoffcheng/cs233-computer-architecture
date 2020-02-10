# feel free to add or change any of the test cases to
# compile, get spim on your own machine using the guide
# CS 233 on Your Own Machine on the website Resources page.

.text
main:
	addi	$6, $0, 100					# $6  =   100 (0x64)
	addi	$7, $6, 155					# $7  =   255 (0xff)
	add	$8, $6, $6						# $8  =   200 (0xc8)
	sub	$9, $7, $8						# $9  =    55 (0x37)
	sub	$10, $8, $7						# $10 =   -55 (0xffffffc9)
	add	$11, $8, $6						# $11 =   300 (0x12c)
	and	$12, $11, $7					# $12 =    44 (0x2c)
	or	$13, $10, $7					# $13 =    -1 (0xffffffff)
	xori	$14, $7, 0x5555 		# $14 = 21930 (0x55aa)
	sub	$15, $7, $13					# $15 =   256 (0x100)
	add	$16, $6, $13					# $16 =    99 (0x63)
	nor	$17, $15, $7					# $17 =  -512 (0xfffffe00)
	add	$18, $17, $15					# $18 =  -256 (0xffffff00)
	addu $19, $11, $12  			# $19 = 	344 (0x00000158)
	ori	$20, $7, 0xAAAA 			# $20 = 43775 (0xaaff)
	addiu $21, $13, 0xff  		# $21 = 	254 (0xfe)
