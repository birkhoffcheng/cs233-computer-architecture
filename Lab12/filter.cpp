#include <stdio.h>
#include <stdlib.h>
#include "filter.h"
#define PREFETCH_STEP 32
#define LOCALITY 3

// modify this code by fusing loops together
void
filter_fusion(pixel_t **image1, pixel_t **image2) {
	for (int i = 1; i < SIZE; i++) {
		if (i < SIZE - 1)	filter1(image1, image2, i);
		if (i >= 2 && i < SIZE - 2)	filter2(image1, image2, i);
		if (i >= 6)	filter3(image2, i - 5);
	}
}

// modify this code by adding software prefetching
void
filter_prefetch(pixel_t **image1, pixel_t **image2) {
	for (int i = 1; i < SIZE - 1; i++) {
		__builtin_prefetch(image1[i+PREFETCH_STEP], 0, LOCALITY);
		__builtin_prefetch(image2[i+PREFETCH_STEP], 1, LOCALITY);
		filter1(image1, image2, i);
	}

	for (int i = 2; i < SIZE - 2; i++) {
		__builtin_prefetch(image1[i+PREFETCH_STEP], 0, LOCALITY);
		__builtin_prefetch(image2[i+PREFETCH_STEP], 1, LOCALITY);
		filter2(image1, image2, i);
	}

	for (int i = 1; i < SIZE - 5; i++) {
		__builtin_prefetch(image2[i+PREFETCH_STEP], 1, LOCALITY);
		filter3(image2, i);
	}
}

// modify this code by adding software prefetching and fusing loops together
void
filter_all(pixel_t **image1, pixel_t **image2) {
	for (int i = 1; i < SIZE; i++) {
		__builtin_prefetch(image1[i+PREFETCH_STEP], 0, LOCALITY);
		__builtin_prefetch(image2[i+PREFETCH_STEP], 1, LOCALITY);
		if (i < SIZE - 1)	filter1(image1, image2, i);
		if (i >= 2 && i < SIZE - 2)	filter2(image1, image2, i);
		if (i >= 6)	filter3(image2, i - 5);
	}
}
