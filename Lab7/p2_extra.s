########################################################################
# p2_given.s - Solver for Lights Out puzzle auxillary functions
#             CS 233 Spring 2020
#
# BEWARE!
# DO NOT EDIT CONTENTS OF THIS FILE.
# THIS FILE WILL NOT BE GRADED
########################################################################

PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# void zero_board(int num_rows, int num_cols, unsigned char* solution){
#     for (int row = 0; row < num_rows; row++) {
#         for (int col = 0; col < num_cols; col++) {
#             solution[(row)*num_cols + col] = 0;
#         }
#     }
# }
.globl solver_zero_board
solver_zero_board:
    ## Variables corresponding to registers:

    ##
    ##    $t1 = col
    ##    $t0 = row
    ##    $a2 = solution
    ##    $a1 = num_cols
    ##    $a0 = num_rows
    ##
    ## End aliases


        li      $t0, 0
    solver_zero_board_for_row:
        bge     $t0, $a0, solver_zero_board_for_row_end
            
        li      $t1, 0
    solver_zero_board_for_col:
        bge     $t1, $a1, solver_zero_board_for_col_end
            
        # assign  $zero =>:: $a2&[$t0 * $a1 + $t1]
        mul     $t9, $t0, $a1
        add     $t9, $t9, $t1
        add     $t9, $t9, $a2
        sb      $zero, 0($t9)
    
        add     $t1, $t1, 1
        j       solver_zero_board_for_col
    solver_zero_board_for_col_end:
        
        add     $t0, $t0, 1
        j       solver_zero_board_for_row
    solver_zero_board_for_row_end:
        
    jr      $ra
    

# // it just checks if all lights are off 
# bool board_done(int num_rows, int num_cols,unsigned char* board){ 
#     for (int row = 0; row < num_rows; row++) {
#         for (int col = 0; col < num_cols; col++) {
#             if (board[(row)*num_cols + col] != 0) {
#                 return false;
#             }
#         }
#     }
#     return true;
# }
.globl solver_board_done
solver_board_done:
    ## Variables corresponding to registers:

    ##
    ##    $t2 = condition_val
    ##    $t1 = col
    ##    $t0 = row
    ##    $a2 = board
    ##    $a1 = num_cols
    ##    $a0 = num_rows
    ##
    ## End aliases


        li      $t0, 0
    solver_board_done_for_row:
        bge     $t0, $a0, solver_board_done_for_row_end
            
        li      $t1, 0
    solver_board_done_for_col:
        bge     $t1, $a1, solver_board_done_for_col_end
            
        # assign  $t2 = $a2[$t0 * $a1 + $t1]
        mul     $t2, $t0, $a1
        add     $t2, $t2, $t1
        add     $t2, $t2, $a2
        lb     $t2, 0($t2)
    solver_board_done_if:
        beq     $t2, $0, solver_board_done_if_skip

        # @RETURN $zero
        move    $v0, $zero
    jr      $ra

    solver_board_done_if_skip:
    
        add     $t1, $t1, 1
        j solver_board_done_for_col
    solver_board_done_for_col_end:
    
            
        add     $t0, $t0, 1
        j solver_board_done_for_row
    solver_board_done_for_row_end:
        
        # @RETURN 1
        li      $v0, 1
    jr      $ra



# print char board ##########################################################
#
# argument $a0: pointer to start of 2d tiles array
# argument $a1: #rows for 2d array
# argument $a2: #cols for 2d array
print_board:
    sub     $sp, $sp, 24
    sw      $ra,  0($sp)        # save $ra on stack
    sw      $s0,  4($sp)        # save $s0 on stack
    sw      $s1,  8($sp)        # save $s1 on stack
    sw      $s2, 12($sp)        # save $s2 on stack
    sw      $s3, 16($sp)        # save $s3 on stack
    sw      $s4, 20($sp)        

    move    $s0, $a0            # base
    move    $s1, $a1            # rows
    move    $s4, $a2            # cols

    mul     $s2, $s4, $s1       # total length
    li      $s3, 0              # i=0
print_board_loop:
    bge     $s3, $s2, print_board_end 
    add     $t0, $s0, $s3       
    lb      $t0, 0($t0)         # tile to be printed

    move    $a0, $t0            
    jal     print_int_and_space # print tile

    addi    $s3, $s3, 1         # increment i
    
    div     $s3, $s4
    mfhi    $t0

    bne     $t0, $0, print_board_loop
    li      $a0, '\n'
    jal     print_char
    j       print_board_loop
print_board_end:
    lw      $ra,  0($sp)        # pop $ra from the stack
    lw      $s0,  4($sp)        # pop $s0 from the stack
    lw      $s1,  8($sp)        # pop $s1 from the stack
    lw      $s2, 12($sp)        # pop $s2 from the stack
    lw      $s3, 16($sp)        # pop $s3 from the stack
    lw      $s4, 20($sp)    
    add     $sp, $sp, 24
    jr      $ra
