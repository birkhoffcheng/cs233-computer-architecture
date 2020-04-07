#ifndef TRANSPOSE_H
#define TRANSPOSE_H

#define SIZE ((1 << 14) - 3) // 16381 (prime)

/* Function declarations */
void transpose_tiled(int **image2, int **image1);

#endif
