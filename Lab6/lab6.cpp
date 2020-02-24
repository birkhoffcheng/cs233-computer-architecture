#include <stdio.h>

/*
 * This file is a test bench to compare
 * the results of your mips code.
 * You can compile this file by running:
 *    gcc lab6.cpp -o cpp_tests
 * And then run those tests with:
 *    ./cpp_tests
 */

#define MAX_WIDTH 100
int working_matrix[MAX_WIDTH*MAX_WIDTH];

// common.s
// copies from src to dest
void copy(int *dest, int *src, unsigned int width) {
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < width; j++) {
            dest[i*width + j] = src[i*width+j];
        }
    }
}

// p1.s
int update_alert_level(unsigned int* stockpiles, unsigned int cutoff,
  unsigned int alert_level) {
    int total_monster = 0;
    for (int i = 0; i < 10; i++) {
        total_monster += stockpiles[i];
    }
    if (total_monster < cutoff) {
        return alert_level + 1;
    } else if (total_monster == cutoff) {
        return alert_level;
    } else {
        return alert_level - 1;
    }
}

// common.s
// prints out a 2d representation of the wall to the console
void matrix_print(int* matr, unsigned int width) {
  for (int row = 0; row < width; row++) {
    for (int col = 0; col < width; col++) {
      printf("%2d ", matr[row*width+col]);
    }
    printf("\n");
  }
}

// p2.s
void matrix_mult(int *matr_a, int *matr_b, int *output, unsigned int width) {
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < width; j++) {
            output[i*width + j] = 0;
            for (int k = 0; k < width; k++) {
                output[i*width + j] += matr_a[i*width + k] * matr_b[k*width + j];
            }
        }
    }
}

// p2.s
void markov_chain(int *state, int *transitions, unsigned int width, int times) {
    for (int i = 0; i < times; i++) {
        matrix_mult(state, transitions, working_matrix, width);
        copy(state, working_matrix, width);
    }
}

// The following function tests update_alert_level
void test1() {
  printf("Test1:\n");
  unsigned int stockpiles[10] = {1, 3, 5, 2, 1, 1, 1, 1, 1, 1};

  int alert_level = 5;
  alert_level = update_alert_level(stockpiles, 5, alert_level);
  printf("Alert level is now %d\n", alert_level);

  unsigned int stockpiles2[10] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
  alert_level = update_alert_level(stockpiles2, 11, alert_level);
  printf("Alert level is now %d\n", alert_level);
}

// matrix a
int matr_a[3*3] = {
  1, 0, 0,
  0, 1, 0,
  0, 0, 1,
};

int matr_b[3*3] = {
  2, 3, 4,
  5, 6, 7,
  8, 9,10,
};

int matr_c[3*3] = {
  9, 9, 9,
  9, 9, 9,
  9, 9, 9,
};

int matr_output[3*3] = {0};

// The following function tests matrix_mult
void test2() {
  printf("Test2:\n");
  matrix_mult(matr_a, matr_b, matr_output, 3);
  matrix_print(matr_output, 3);
  matrix_mult(matr_b, matr_c, matr_output, 3);
  matrix_print(matr_output, 3);
}

// The following function tests markov_chain
void test3() {
  printf("Test3:\n");
  markov_chain(matr_b, matr_a, 3, 5);
  matrix_print(matr_b, 3);
  markov_chain(matr_c, matr_b, 3, 2);
  matrix_print(matr_c, 3);
}

void test4() {
  // Feel free to add more tests  
}

int main() {
  test1();
  test2();
  test3();

  test4();
}