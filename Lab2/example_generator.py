## Virtues of a programmer (from Programming Perl, Wall, Schwartz and
## Christiansen)
## 
## Laziness - The quality that makes you go to great effort to reduce
## overall energy expenditure. It makes you write labor-saving programs
## that other people will find useful, and document what you wrote so you
## don't have to answer so many questions about it. 
## 
## 
## This function generates part of a circuit (albeit a slow one)
## to compute whether a bus is all zeros.
## 
## python example_generator.py

from __future__ import print_function 	# Ensures that the code can run on both Python 2 and Python 3

width = 32
for i in range(2, width):
    print("    or o{0}(chain[{0}], in[{0}], chain[{1}]);".format(i, i - 1))
