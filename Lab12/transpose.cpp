#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;
#define TILE_SIZE 32
// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {
	for (int j = 0; j < SIZE; j += TILE_SIZE) {
		for (int i = 0; i < SIZE; i++) {
			for (int jj = j; jj < min(j + TILE_SIZE, SIZE); jj++) {
				dest[i][jj] = src[jj][i];
			}
		}
	}
}
