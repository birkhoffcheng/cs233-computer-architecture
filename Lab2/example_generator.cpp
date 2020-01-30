// Virtues of a programmer (from Programming Perl, Wall, Schwartz and
// Christiansen)
// 
// Laziness - The quality that makes you go to great effort to reduce
// overall energy expenditure. It makes you write labor-saving programs
// that other people will find useful, and document what you wrote so you
// don't have to answer so many questions about it. 


// This function generates part of a circuit (albeit a slow one)
// to compute whether a bus is all zeros.

// make example_generator
// ./example_generator

#include <cstdio>
using std::printf;

int
main() {
    int width = 32;
    for (int i = 2 ; i < width ; i ++) {
        printf("    or o%d(chain[%d], in[%d], chain[%d]);\n", i, i, i, i-1);
    }
}
