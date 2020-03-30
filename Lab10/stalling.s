.data
array:	.word	1	255	1024	100	200

# every register except $0 starts holding the address of "array"
#
# this is a cheat so that we don't need to implement addi and lui in
# our pipelined machine.

.text
main:   
	lw	$2,  0($20)	# $2 = 1	(0x1)

	# stall on rs
	lw	$3,  4($20)	# $3 = 255	(0xff)
	add	$4, $3, $2	# $4 = 256	(0x100)

	# stall on rt
	lw	$5,  8($20)	# $5 = 1024	(0x400)
	add	$6, $3, $5	# $6 = 1279	(0x4ff)

	# no stall: instruction between load and use
	lw	$7, 12($20)	# $7 = 100	(0x64)
	add	$8, $2, $5	# $8 = 1025	(0x401)
	add	$9, $7, $7	# $9 = 200	(0xc8)

	# no stall: rt isn't source
	lw	$10, 16($20)	# $10 = 200	(0xc8)
	lw	$10, 0($20)	# $10 = 1	(0x1)
