########################################################################
# BEWARE!
# DO NOT EDIT CONTENTS OF THIS FILE.
# THIS FILE WILL NOT BE GRADED
########################################################################
# typedef struct TreeNode {
#     struct TreeNode* left;
#     struct TreeNode* center;
#     struct TreeNode* right;
#     char value;
# } TreeNode;
.data
    g_node: 
    .word     0      0      0
    .byte 3
    f_node: 
    .word     0      0      0
    .byte 2
    e_node: 
    .word     0      0      0
    .byte 1
    d_node: 
    .word     0      0      0
    .byte 7
    c_node: 
    .word     0      0      0
    .byte 12
    b_node: 
    .word     e_node f_node g_node
    .byte 11
    a_node: 
    .word     b_node c_node d_node
    .byte 10
.text

# main function ########################################################
#
#  this is a function that will test dfs
#

.globl main
main:
    sub $sp, $sp, 4
    sw  $ra, 0($sp) # save $ra on stack

    # TEST 1
    la $a0, a_node
    jal find_payment
    move $a0, $v0
    jal print_int_and_space # Print 12

    # TEST 2
    la $a0, d_node
    jal find_payment
    move $a0, $v0
    jal print_int_and_space # Print 3

    # Feel free to add more tests

    lw  $ra, 0($sp)
    add $sp, $sp, 4
    jr  $ra


