.text

# void toggle_light(int row, int col, LightsOut* puzzle, int action_num){
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int num_colors = puzzle->num_colors;
#     unsigned char* board = (puzzle-> board);
#     board[row*num_cols + col] = (board[row*num_cols + col] + action_num) % num_colors;
#     if (row > 0){
#         board[(row-1)*num_cols + col] = (board[(row-1)*num_cols + col] + action_num) % num_colors;
#     }
#     if (col > 0){
#         board[(row)*num_cols + col-1] = (board[(row)*num_cols + col-1] + action_num) % num_colors;
#     }
#
#     if (row < num_rows - 1){
#         board[(row+1)*num_cols + col] = (board[(row+1)*num_cols + col] + action_num) % num_colors;
#     }
#
#     if (col < num_cols - 1){
#         board[(row)*num_cols + col+1] = (board[(row)*num_cols + col+1] + action_num) % num_colors;
#     }
# }
# $a0 row
# $a1 col
# $a2 puzzle
# $a3 action_num

.globl toggle_light
toggle_light:
	lw		$t0, 0($a2)	# t0 = num_rows = puzzle->num_rows
	lw		$t1, 4($a2)	# t1 = num_cols = puzzle->num_cols
	lw		$t2, 8($a2)	# t2 = num_colors = puzzle->num_colors
	add		$t3, $a2, 12		# t3 = puzzle->board
	mul		$t8, $a0, $t1		# t8 = row * num_cols
	add		$t8, $t8, $a1		# t8 = row * num_cols + col
	add		$t8, $t8, $t3		# t8 = row * num_cols + col + board
	lbu		$t9, 0($t8)			# t9 = board[row*num_cols + col]
	addu	$t9, $t9, $a3		# $t9 = $t9 + $a3
	rem		$t9, $t9, $t2
	sb		$t9, 0($t8)
# if (row > 0)
	ble		$a0, $zero, row_le_0	# if $a0 <= $zero then row_le_0
	sub		$t8, $a0, 1			# t8 = row-1
	mul		$t8, $t8, $t1		# t8 = (row-1) * num_cols
	add		$t8, $t8, $a1		# t8 = (row-1) * num_cols + col
	add		$t8, $t8, $t3		# t8 = (row-1) * num_cols + col + board
	lbu		$t9, 0($t8)			# t9 = board[(row-1)*num_cols + col]
	addu	$t9, $t9, $a3		# $t9 = $t9 + $a3
	rem		$t9, $t9, $t2
	sb		$t9, 0($t8)
row_le_0:
# if (col > 0)
	ble		$a1, $zero, col_le_0	# if $a1 <= $zero then col_le_0
	mul		$t8, $a0, $t1		# t8 = row * num_cols
	add		$t8, $t8, $a1		# t8 = row * num_cols + col
	sub		$t8, $t8, 1			# t8 = row * num_cols + col - 1
	add		$t8, $t8, $t3		# t8 = row * num_cols + col - 1 + board
	lbu		$t9, 0($t8)			# t9 = board[row*num_cols + col-1]
	addu	$t9, $t9, $a3		# $t9 = $t9 + $a3
	rem		$t9, $t9, $t2
	sb		$t9, 0($t8)
col_le_0:
# if (row < num_rows - 1)
	sub		$t6, $t0, 1		# $t6 = $t0 - 1
	bge		$a0, $t6, row_ge_nrow_1	# if $a0 >= $t6 then row_ge_nrow_1
	add		$t8, $a0, 1			# t8 = row+1
	mul		$t8, $t8, $t1		# t8 = (row+1) * num_cols
	add		$t8, $t8, $a1		# t8 = (row+1) * num_cols + col
	add		$t8, $t8, $t3		# t8 = (row+1) * num_cols + col + board
	lbu		$t9, 0($t8)			# t9 = board[(row+1)*num_cols + col]
	addu	$t9, $t9, $a3		# $t9 = $t9 + $a3
	rem		$t9, $t9, $t2
	sb		$t9, 0($t8)
row_ge_nrow_1:
# if (col < num_cols - 1)
	sub		$t6, $t1, 1		# $t6 = $t1 - 1
	bge		$a1, $t6, col_ge_ncol_1	# if $a1 >= $t6 then col_ge_ncol_1
	mul		$t8, $a0, $t1		# t8 = row * num_cols
	add		$t8, $t8, $a1		# t8 = row * num_cols + col
	add		$t8, $t8, 1			# t8 = row * num_cols + col + 1
	add		$t8, $t8, $t3		# t8 = row * num_cols + col + 1 + board
	lbu		$t9, 0($t8)			# t9 = board[row*num_cols + col+1]
	addu	$t9, $t9, $a3		# $t9 = $t9 + $a3
	rem		$t9, $t9, $t2
	sb		$t9, 0($t8)
col_ge_ncol_1:
	jr	$ra



# bool solve(LightsOut* puzzle, unsigned char* solution, int row, int col){
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int num_colors = puzzle->num_colors;
#     int next_row = ((col == num_cols-1) ? row + 1 : row);
#     if (row >= num_rows || col >= num_cols) {
#          return board_done(num_rows,num_cols,puzzle->board);
#     }
#
#     if (puzzle->clue[row*num_cols + col]) {
#          return solve(puzzle,solution, next_row, (col+1) % num_cols);
#     }
#
#     for(char actions = 0; actions < num_colors; actions++) {
#         solution[row*num_cols + col] = actions;
#         toggle_light(row, col, puzzle, actions);
#         if (solve(puzzle,solution, next_row, (col + 1) % num_cols)) {
#             return true;
#         }
#         toggle_light(row, col, puzzle, num_colors - actions);
#         solution[row*num_cols + col] = 0;
#     }
#     return false;
# }
# $a0 puzzle
# $a1 solution
# $a2 row
# $a3 col

.globl solve
solve:
	lw		$t0, 0($a0)	# t0 = num_rows = puzzle->num_rows
	lw		$t1, 4($a0)	# t1 = num_cols = puzzle->num_cols
	lw		$t2, 8($a0)	# t2 = num_colors = puzzle->num_colors
# if (row >= num_rows || col >= num_cols)
	bge		$a2, $t0, first_if_true
	blt		$a3, $t1, first_if_false
first_if_true:
# return board_done(num_rows,num_cols,puzzle->board);
	addu	$a2, $a0, 12
	move 	$a0, $t0
	move 	$a1, $t1
	sub		$sp, $sp, 4
	sw		$ra, 0($sp)
	jal		board_done
	j		retq
first_if_false:
# int next_row = ((col == num_cols-1) ? row + 1 : row);
	move	$t3, $a2	# $t3 = next_row = row
	sub		$t9, $t1, 1	# num_col - 1
	bne		$a3, $t9, just_row	# (col == num_cols-1) ?
	add		$t3, $t3, 1 # next_row += 1
just_row:
	mul		$t9, $a2, $t1	# $t9 = row * num_cols
	add		$t9, $t9, $a3	# $t9 += col
	add		$t9, $t9, 268	# $t9 += clue offset
	add		$t9, $t9, $a0	# $t9 += puzzle
	lbu		$t9, 0($t9)		# $t9 = puzzle->clue[row*num_cols + col]
	beq		$t9, $zero, save_s_regs
	move	$a2, $t3
	add		$a3, $a3, 1
	rem		$a3, $a3, $t1
# callq solve
	sub		$sp, $sp, 4
	sw		$ra, 0($sp)
	jal		solve
	j		retq
save_s_regs:
# push $ra
	sub		$sp, $sp, 4
	sw		$ra, 0($sp)
	sub		$sp, $sp, 32
	sw		$s0, 0($sp)
	sw		$s1, 4($sp)
	sw		$s2, 8($sp)
	sw		$s3, 12($sp)
	sw		$s4, 16($sp)
	sw		$s5, 20($sp)
	sw		$s6, 24($sp)
	sw		$s7, 28($sp)
	add		$s0, $zero, 0	# $s0 = actions = 0
	move 	$s1, $t1		# $s1 = $t1 = num_cols
	move 	$s2, $t2		# $s2 = $t2 = num_colors
	move 	$s3, $a2		# $s3 = $a2 = row
	move 	$s4, $a3		# $s4 = $a3 = col
	move 	$s5, $t3		# $s5 = $t3 = next_row
	move 	$s6, $a1		# $s6 = $a1 = solution
	move 	$s7, $a0		# $s7 = $a0 = puzzle
begin_for_loop:
	bge		$s0, $s2, end_for_loop
# solution[row*num_cols + col] = actions;
	mul		$t0, $s3, $s1	# $t0 = row * num_cols
	add		$t0, $t0, $s4	# $t0 = row * num_cols + col
	add		$t0, $t0, $s6	# $t0 = row * num_cols + col + solution
	sb		$s0, 0($t0)
# toggle_light(row, col, puzzle, actions);
	move 	$a0, $s3		# $a0 = $s3 = row
	move 	$a1, $s4		# $a1 = $s4 = col
	move 	$a2, $s7		# $a2 = $s7 = puzzle
	move 	$a3, $s0		# $a3 = $s0 = actions
	jal		toggle_light
# solve(puzzle,solution, next_row, (col + 1) % num_cols)
	move 	$a0, $s7		# $a0 = $s7 = puzzle
	move 	$a1, $s6		# $a1 = $s6 = solution
	move 	$a2, $s5		# $a2 = $s5 = next_row
	add		$a3, $s4, 1		# $a3 = col + 1
	rem		$a3, $a3, $s1	# (col + 1) % num_cols
	jal		solve
	bne		$v0, $zero, restore_s_regs	# restore s_regs and return true
# toggle_light(row, col, puzzle, num_colors - actions);
	move 	$a0, $s3		# $a0 = $s3 = row
	move 	$a1, $s4		# $a1 = $s4 = col
	move 	$a2, $s7		# $a2 = $s7 = puzzle
	sub		$a3, $s2, $s0	# $a3 = num_colors - actions
	jal		toggle_light
# solution[row*num_cols + col] = 0;
	mul		$t0, $s3, $s1	# $t0 = row * num_cols
	add		$t0, $t0, $s4	# $t0 = row * num_cols + col
	add		$t0, $t0, $s6	# $t0 = row * num_cols + col + solution
	sb		$zero, 0($t0)
	add		$s0, $s0, 1
	j		begin_for_loop
end_for_loop:
# return false
	add		$v0, $zero, 0

restore_s_regs:
	lw		$s0, 0($sp)
	lw		$s1, 4($sp)
	lw		$s2, 8($sp)
	lw		$s3, 12($sp)
	lw		$s4, 16($sp)
	lw		$s5, 20($sp)
	lw		$s6, 24($sp)
	lw		$s7, 28($sp)
	add		$sp, $sp, 32
retq:
	lw		$ra, 0($sp)
	add		$sp, $sp, 4
	jr		$ra
