/*
 * This is the C code for p1 and p2
 * To compile this:
 *      gcc lab7.cpp -o lab7_tests
 * You can then run the tests:
 *      ./lab7_tests
 */

#include <stdio.h>
#include <stdbool.h>

typedef struct TreeNode {
    struct TreeNode* left;
    struct TreeNode* center;
    struct TreeNode* right;
    unsigned char value;
} TreeNode;

TreeNode g = {
    NULL,
    NULL,
    NULL,
    3,
};

TreeNode f = {
    NULL,
    NULL,
    NULL,
    2,
};

TreeNode e = {
    NULL,
    NULL,
    NULL,
    1,
};

TreeNode d = {
    NULL,
    NULL,
    NULL,
    7,
};

TreeNode c = {
    NULL,
    NULL,
    NULL,
    12,
};

TreeNode b = {
    &e,
    &f,
    &g,
    11,
};

TreeNode a = {
    &b,
    &c,
    &d,
    10,
};

// part 1 p1.s
unsigned char find_payment(TreeNode* trav) { 
    // Base case
    if (trav == NULL) {
        return 0;
    }
    // Recurse once for each child
    unsigned char payment_left = find_payment(trav->left);
    unsigned char payment_center = find_payment(trav->center);
    unsigned char payment_right = find_payment(trav->right);
    unsigned char value = payment_left + payment_center + payment_right + trav->value;
    return value / 2;
}

#define MAX_GRIDSIZE 16

struct LightsOut {
    int num_rows;
    int num_cols;
    int num_colors;
    unsigned char board[MAX_GRIDSIZE*MAX_GRIDSIZE];
    bool clue[MAX_GRIDSIZE*MAX_GRIDSIZE]; // (using chars in Spimbot)
};

// part 2 p2.s
void toggle_light(int row, int col, LightsOut* puzzle, int action_num){
    int num_rows = puzzle->num_rows;
    int num_cols = puzzle->num_cols;
    int num_colors = puzzle->num_colors;
    unsigned char* board = (puzzle-> board);
    board[row*num_cols + col] = (board[row*num_cols + col] + action_num) % num_colors;
    if (row > 0){
        board[(row-1)*num_cols + col] = (board[(row-1)*num_cols + col] + action_num) % num_colors;
    }
    if (col > 0){
        board[(row)*num_cols + col-1] = (board[(row)*num_cols + col-1] + action_num) % num_colors;
    }
    
    if (row < num_rows - 1){
        board[(row+1)*num_cols + col] = (board[(row+1)*num_cols + col] + action_num) % num_colors;
    }

    if (col < num_cols - 1){
        board[(row)*num_cols + col+1] = (board[(row)*num_cols + col+1] + action_num) % num_colors;
    }
}

// part 2 p2_extra.s
void zero_board(int num_rows, int num_cols, unsigned char* solution){
    for (int row = 0; row < num_rows; row++) {
        for (int col = 0; col < num_cols; col++) {
            solution[(row)*num_cols + col] = 0;
        }
    }
}

// part 2 p2_extra.s
bool board_done(int num_rows, int num_cols,unsigned char* board){ // it just checks if all lights are off 
    for (int row = 0; row < num_rows; row++) {
        for (int col = 0; col < num_cols; col++) {
            if (board[(row)*num_cols + col] != 0) {
                return false;
            }
        }
    }
    return true;
}

// part 2 p2.s
bool solve(LightsOut* puzzle, unsigned char* solution, int row, int col){
    int num_rows = puzzle->num_rows; 
    int num_cols = puzzle->num_cols;
    int num_colors = puzzle->num_colors;
    int next_row = ((col == num_cols-1) ? row + 1 : row);
    if (row >= num_rows || col >= num_cols) {
         return board_done(num_rows,num_cols,puzzle->board);
    }
    if (puzzle->clue[row*num_cols + col]) {
        return solve(puzzle,solution, next_row, (col + 1) % num_cols);
    }

    for(char actions = 0; actions < num_colors; actions++) {
        solution[row*num_cols + col] = actions;
        toggle_light(row, col, puzzle, actions);
        // Recursive Function Call
        if (solve(puzzle,solution, next_row, (col + 1) % num_cols)) {
            return true;
        }
        toggle_light(row, col, puzzle, num_colors - actions); 
        solution[row*num_cols + col] = 0;
    }
    return false;
}

// part 2 p2_extra.s
bool solve_lightsout(LightsOut* puzzle, unsigned char* solution) { // after calling this function, solution should appear in solution
    zero_board(puzzle->num_rows, puzzle->num_cols, solution);
    return solve(puzzle, solution, 0, 0);
}

// common.s
void print_board(unsigned char* board, int num_rows, int num_cols) {
    for (int row = 0; row < num_rows; row++) {
        for (int col = 0; col < num_cols; col++) {
            printf("%2d ", board[row*num_cols+col]);
        }
        printf("\n");
    }
}

// p1_main.s p2_main.s
int main() {
    // p1_main.s
    // TEST 1 - find_payment
    unsigned char payA = find_payment(&a);
    printf("A: %d\n", payA); // print 12
    // TEST 2 - find_payment
    unsigned char payD = find_payment(&d);
    printf("D: %d\n", payD); // print 3

    // p2_main.s
    // TEST 3 - toggle_light
    LightsOut puzzle1 = LightsOut {
        3,
        3,
        3,
        {
            0, 1, 0,
            0, 0, 0,
            0, 1, 0,
        },{
            false, false, false,
            false, false, false,
            false, false, false,
        }
    };
    printf("Test 3\n");
    toggle_light(1, 1, &puzzle1, 1);
    print_board(puzzle1.board, 3, 3);

    // p2_main.s
    // TEST 4 - toggle_light
    LightsOut puzzle2 = LightsOut {
        3,
        3,
        2,
        {
            1, 1, 1,
            1, 0, 1,
            1, 1, 1,
        },
        {}
    };
    printf("Test 4\n");
    toggle_light(0, 0, &puzzle2, 1);
    print_board(puzzle2.board, 3, 3);

    // p2_main.s
    // TEST 5 - solve
    LightsOut puzzle3 = LightsOut {
        3,
        4,
        3,
        {
            2, 0, 2, 2,
            1, 2, 2, 0,
            2, 1, 0, 2,
        },
        {
             true, false, false, false,
             true, false, false, false,
            false,  true,  true, false,
        }
    };
    unsigned char solution1[MAX_GRIDSIZE*MAX_GRIDSIZE] = {};
    printf("Test 5\n");
    bool solved1 = solve_lightsout(&puzzle3, solution1);
    printf("is solved: %d\n", solved1);
    print_board(solution1, 3, 4);


    // p2_main.s
    // TEST 6 - solve
    LightsOut puzzle4 = LightsOut {
        5,
        5,
        2,
        {
            0, 0, 0, 1, 0,
            1, 1, 1, 0, 1,
            0, 0, 1, 1, 1,
            0, 0, 0, 1, 0,
            1, 0, 0, 0, 0,
        },
        {
             true, false, false,  true, false,
             true, false, false, false, false,
             true, false, false, false,  true,
            false, false, false,  true, false,
             true,  true, false,  true, false,
        }
    };
    unsigned char solution2[MAX_GRIDSIZE*MAX_GRIDSIZE] = {};
    printf("Test 6\n");
    bool solved2 = solve_lightsout(&puzzle4, solution2);
    printf("is solved: %d\n", solved2);
    print_board(solution2, 5, 5);
    // Feel Free to add more tests here:
}