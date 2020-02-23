# add your own tests for the full machine here!
# feel free to take inspiration from all.s and/or lwbr.s

.data
# your test data goes here

.text
main:
	# your test code goes here
	lui	$2, 0x8000 # $2 = 0x80000000
	addi $3, $0, 0x1 # $3 = 1
	slt $4, $2, $3 # $4 = 1

	lui $5, 0x7fff # $5 = 0x7fff
	ori $5, 0xffff # $5 |= 0xffff
	lui $6, 0xffff # $6 = 0xffff
	ori $6, 0xffff # $6 |= 0xffff ($6 = -1)
	slt $7, $5, $6 # $7 = 0
