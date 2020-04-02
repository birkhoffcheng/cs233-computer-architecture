#ifndef FILTER_H
#define FILTER_H

#define SIZE 1000000
#define NSTEPS 100

struct pixel_t {
    int x, y, z;
    int r, g, b;
};

/* Function declarations */
void filter_fusion(pixel_t **image1, pixel_t **image2);
void filter_prefetch(pixel_t **image1, pixel_t **image2);
void filter_all(pixel_t **image1, pixel_t **image2);
void filter1(pixel_t **image1, pixel_t **image2, int i);
void filter2(pixel_t **image1, pixel_t **image2, int i);
void filter3(pixel_t **image, int i);

#endif
