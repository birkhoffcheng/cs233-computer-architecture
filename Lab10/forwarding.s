.data
array:	.word	1	255	1024	100	200

# every register except $0 starts holding the address of "array"
#
# this is a cheat so that we don't need to implement addi and lui in
# our pipelined machine.

.text
main:   
	lw	$2,  0($20)	# $2 = 1	(0x1)
	lw	$3,  4($20)	# $3 = 255	(0xff)
	lw	$4,  8($20)	# $4 = 1024	(0x400)
	lw	$5, 12($20)	# $5 = 100	(0x64)
	lw	$6, 16($20)	# $6 = 200	(0xc8)

	# forwarding to rs
	add	$7, $2, $5	# $7 = 101	(0x65)
	add	$8, $7, $4	# $8 = 1125	(0x465)

	# forwarding to rt
	add	$9, $3, $6	# $9 = 455	(0x1c7)
	add	$10, $2, $9	# $10 = 456	(0x1c8)

	# forwarding when consumer doesn't write register file
	add	$11, $2, $3	# $11 = 256	(0x100)
	sw	$11, 4($20)
	lw	$12, 4($20)	# $12 = 256	(0x100)

	# no forwarding: destination is $zero
	add	$0, $7, $9	# $0 = 0	(0x0)
	add	$13, $0, $0	# $13 = 0	(0x0)
