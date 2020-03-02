########################################################################
# BEWARE!
# DO NOT EDIT CONTENTS OF THIS FILE.
# THIS FILE WILL NOT BE GRADED
########################################################################

# 
#     struct LightsOut {
#     int num_rows;
#     int num_cols;
#     int num_color;
#     unsigned char board[MAX_GRIDSIZE*MAX_GRIDSIZE];
#     bool clue[MAX_GRIDSIZE*MAX_GRIDSIZE]; //(using bytes in SpimBot)
#     };

.data

puzzle1:
.word 3 3 3 # num_rows, num_cols, color

.byte 0 1 0 
.byte 0 0 0 
.byte 0 1 0
.space 247

.byte 0 0 0
.byte 0 0 0
.byte 0 0 0
.space 247
# solution:
#  0 2 0 
#  1 1 1
#  0 2 0

puzzle2:
.word 3 3 2 # num_rows, num_cols, color

.byte 1 1 1  # board
.byte 1 0 1 
.byte 1 1 1 
.space 247

.byte 0 0 0 # clue
.byte 0 0 0 
.byte 0 0 0 
.space 247
# solution:
#  0 0 1
#  0 0 1
#  1 1 1

puzzle3:
.word 3 4 3 # num_rows, num_cols, color

.byte 2 0 2 2  # board
.byte 1 2 2 0
.byte 2 1 0 2
.space 244

.byte 1 0 0 0  # clue
.byte 1 0 0 0
.byte 0 1 1 0
.space 244
# solution:
# 0 1 1 0
# 0 1 2 0
# 1 0 0 1

puzzle4:
.word 5 5 2 # num_rows, num_cols, color

.byte 0 0 0 1 0 # board
.byte 1 1 1 0 1
.byte 0 0 1 1 1
.byte 0 0 0 1 0
.byte 1 0 0 0 0
.space 231

.byte 1 1 0 1 0 # clue
.byte 1 0 0 0 0
.byte 1 0 0 0 1
.byte 0 0 0 1 0
.byte 1 1 0 1 0
.space 231
# solution:
# 0 2 1
# 0 1 1
# 0 3 0

heap:   # this is actually a place to store solution, not heap
.space 256

.text
# main function
.globl main
main:
    sub $sp, $sp, 4
    sw  $ra, 0($sp)   # save $ra on stack
# tests for toggle_light ###################################
    # TEST 3
    li $a0, 1
    li $a1, 1
    la  $a2, puzzle1
    li $a3, 1
    jal toggle_light        # toggle_light(1,2,puzzle1,1)
    la  $a0, puzzle1
    lw  $a1, 0($a0)
    lw  $a2, 4($a0)
    add $a0, $a0, 12
    jal print_board    # print_board(puzzle1, #row, #col)
    # Print Board
    # 0  2  0
    # 1  1  1
    # 0  2  0
     
    # TEST 4
    li $a0, 0
    li $a1, 0
    la  $a2, puzzle2
    li $a3, 1
    jal toggle_light        # toggle_light(1,2,puzzle2,1)
    la  $a0, puzzle2
    lw  $a1, 0($a0)
    lw  $a2, 4($a0)
    add $a0, 12
    jal print_board    # print_board(puzzle2, #row, #col)
    # Print Board
    # 0  0  1
    # 0  0  1
    # 1  1  1

# tests for solve ###################################
    # TEST 5
    la  $a2, puzzle3
    lw  $a0, 0($a2)
    lw  $a1, 4($a2)
    la  $a2, heap
    jal solver_zero_board   # clear heap

    la $a0, puzzle3
    la $a1, heap
    li $a2, 0
    li $a3, 0
    jal solve        # solve(puzzle1, heap, 0, 0)
    move $a0, $v0
    jal print_bool_and_newline # Will print T
    la  $a0, puzzle3
    lw  $a1, 0($a0)
    lw  $a2, 4($a0)
    la  $a0, heap
    jal print_board    # print_board(heap, #row, #col)
    # Print Solution
    # 0  1  1  0  
    # 0  1  2  0
    # 1  0  0  1

    # TEST 6
    la  $a2, puzzle4
    lw  $a0, 0($a2)
    lw  $a1, 4($a2)
    la  $a2, heap
    jal solver_zero_board   # clear heap
    la $a0, puzzle4
    la $a1, heap
    li $a2, 0
    li $a3, 0
    jal solve        # solve(puzzle2, heap, 0, 0)
    move $a0, $v0
    jal print_bool_and_newline # Will print T
    la  $a0, puzzle4
    lw  $a1, 0($a0)
    lw  $a2, 4($a0)
    la  $a0, heap
    jal print_board    # print_board(heap, #row, #col)
    # Print Solution
    # 0  0  1  0  1
    # 0  1  1  1  1
    # 0  1  1  1  0
    # 1  1  1  0  1
    # 0  0  1  0  1

    lw  $ra, 0($sp)
    add $sp, $sp, 4
    jr  $ra


