#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "filter.h"

void
initialize_image(pixel_t *pix) {
    pix->x = random() % 1024;
    pix->y = random() % 1024;
    pix->z = random() % 1024;
    pix->r = random() % 256;
    pix->g = random() % 256;
    pix->b = random() % 256;
}

void
filter1(pixel_t **image1, pixel_t **image2, int i) {
    image2[i]->x = image1[i - 1]->x + image1[i + 1]->x;
    image2[i]->y = image1[i - 1]->y + image1[i + 1]->y;
    image2[i]->z = image1[i - 1]->z + image1[i + 1]->z;
}

void
filter2(pixel_t **image1, pixel_t **image2, int i) {
    image2[i]->r = image1[i - 2]->r + image1[i + 2]->r;
    image2[i]->g = image1[i - 2]->g + image1[i + 2]->g;
    image2[i]->b = image1[i - 2]->b + image1[i + 2]->b;
}

void
filter3(pixel_t **image, int i) {
    image[i]->x = image[i]->x + image[i + 5]->x;
    image[i]->y = image[i]->y + image[i + 5]->y;
    image[i]->z = image[i]->z + image[i + 5]->z;
}

void
filter_none(pixel_t **image1, pixel_t **image2) {

    for (int i = 1; i < SIZE - 1; i ++) {
        filter1(image1, image2, i);
    }

    for (int i = 2; i < SIZE - 2; i ++) {
        filter2(image1, image2, i);
    }

    for (int i = 1; i < SIZE - 5; i ++) {
        filter3(image2, i);
    }
}

int
main(int argc, char **argv) {
    // allocate more elements than we need (sparse-ish data)
    pixel_t *data1 = (pixel_t *) malloc(SIZE * 10 * sizeof(pixel_t));
    pixel_t *data2 = (pixel_t *) malloc(SIZE * 10 * sizeof(pixel_t));

    pixel_t **image1 = (pixel_t **) malloc(SIZE * sizeof(pixel_t *));
    pixel_t **image2 = (pixel_t **) malloc(SIZE * sizeof(pixel_t *));

    bool *used = (bool *) calloc(SIZE * 10, sizeof(bool)); // zero-initialized

    for (int i = 0; i < SIZE; i ++) {
        int ii;
        do {
            ii = random() % (SIZE * 10);
        } while (used[ii]);
        used[ii] = true;
        image1[i] = &data1[ii];
        image2[i] = &data2[ii];
        initialize_image(image1[i]);
    }

    if (argc < 2) {
        printf("Usage: ./filter <option>\n");
        printf("where option can be 'none', 'prefetch', 'fusion' or 'all' \n");
        exit(1);
    }

    clock_t c1, c2;

    if (!strcmp(argv[1], "none")) {
        c1 = clock();
        for (int i = 1; i < NSTEPS; i ++)
            filter_none(image1, image2);
        c2 = clock();

        printf("Elapsed CPU time without optimization is %lf seconds\n",
               (((double) c2) - c1) / CLOCKS_PER_SEC);

        // Print a random element so that the compiler does not remove the
        // computation above
        printf("Image %d \n", image2[random() % SIZE]->x);

    } else if (!strcmp(argv[1], "prefetch")) {
        c1 = clock();
        for (int i = 1; i < NSTEPS; i ++)
            filter_prefetch(image1, image2);
        c2 = clock();

        printf("Elapsed CPU time with prefetch is %lf seconds\n",
               (((double) c2) - c1) / CLOCKS_PER_SEC);

        // Print a random element so that the compiler does not remove the
        // computation above
        printf("Image %d \n", image2[random() % SIZE]->x);

    } else if (!strcmp(argv[1], "fusion")) {
        c1 = clock();
        for (int i = 1; i < NSTEPS; i ++)
            filter_fusion(image1, image2);
        c2 = clock();

        printf("Elapsed CPU time with fusion is %lf seconds\n",
               (((double) c2) - c1) / CLOCKS_PER_SEC);

        // Print a random element so that the compiler does not remove the
        // computation above
        printf("Image %d \n", image2[random() % SIZE]->x);

    } else if (!strcmp(argv[1], "all")) {
        c1 = clock();
        for (int i = 1; i < NSTEPS; i ++)
            filter_all(image1, image2);
        c2 = clock();

        printf("Elapsed CPU time with all is %lf seconds\n",
               (((double) c2) - c1) / CLOCKS_PER_SEC);

        // Print a random element so that the compiler does not remove the
        // computation above
        printf("Image %d \n", image2[random() % SIZE]->x);
    } else {
        printf("Invalid option\n");
        exit(1);
    }
}
