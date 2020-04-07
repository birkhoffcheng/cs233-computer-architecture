CFLAGS = -Wall -g -O2
CXX = g++
LIBS = -lm

all: transpose filter

main-transpose.o: main-transpose.cpp transpose.h
	$(CXX) $(CFLAGS) -c main-transpose.cpp

transpose.o: transpose.cpp transpose.h
	$(CXX) $(CFLAGS) -c transpose.cpp

transpose: main-transpose.o transpose.o
	$(CXX) $(CFLAGS) main-transpose.o transpose.o -o transpose

filter.o: filter.cpp filter.h
	$(CXX) $(CFLAGS) -c filter.cpp

main-filter.o: main-filter.cpp filter.h
	$(CXX) $(CFLAGS) -c main-filter.cpp

filter: main-filter.o filter.o 
	$(CXX) $(CFLAGS) main-filter.o filter.o -o filter

clean:
	rm -f *.o *.exe transpose filter
