.data
array:
	.word 0x8001			# enable interrupts and timer interrupts
	.word 0xffff001c		# timer I/O address
	.word 8				# want timer interrupt in 8 cycles
	.word 0xffff006c		# timer acknowledge address
	.word 1				# some other helpful constants
	.word 7

# every register except $0 starts holding the address of "array"
#
# this is a cheat so that we don't need to implement addi and lui in
# our pipelined machine.

.text
main:
	lw	$2, 0($20)		# $2 = 0x8001
	mtc0	$2, $12			# enable interrupts and timer interrupts

	lw	$3, 4($20)		# $3 = 0xffff001c
	lw	$4, 0($3)		# get timer value
	lw	$5, 8($20)		# $5 = 8
	add	$6, $5, $4
	sw	$6, 0($3)		# request timer 8 cycles from now

	# set all the other registers equal to their register number, except $k0 and $k1
	# interrupt will happen somewhere in middle and resume normal execution after
	# now that you know what .set noat and .set at do
	.set noat
	lw	$1, 16($20)		# $1 = 1
	lw	$7, 20($20)
	add	$8, $7, $1
	add	$9, $8, $1
	add	$10, $9, $1
	add	$11, $10, $1
	add	$12, $11, $1
	add	$13, $12, $1
	add	$14, $13, $1
	add	$15, $14, $1
	add	$16, $15, $1
	add	$17, $16, $1
	add	$18, $17, $1
	add	$19, $18, $1
	add	$20, $19, $1
	add	$21, $20, $1
	add	$22, $21, $1
	add	$23, $22, $1
	add	$24, $23, $1
	add	$25, $24, $1
	add	$28, $25, $1		# skip $k0
	add	$28, $28, $1		# skip $k1
	add	$28, $28, $1
	add	$29, $28, $1
	add	$30, $29, $1
	add	$31, $30, $1
	.set at

.ktext 0x80000180
interrupt_handler:
	lw	$k0, 12($k1)		# $26 = 0xffff006c
	sw	$k1, 0($k0)		# acknowledge interrupt
	add	$k1, $zero, $k0		# $27 = 0xffff006c
	eret
