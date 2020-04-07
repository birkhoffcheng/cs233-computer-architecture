GTEST_DIR := gtest-1.8.0
GTEST_LIB := $(GTEST_DIR)/make/gtest_main.a

CXX = clang++
CPPFLAGS = -isystem $(GTEST_DIR)/include
CXXFLAGS = -g -Wall -Werror -Wno-unused-parameter -Wno-unused-private-field -std=c++11
LD = $(CXX)
LDFLAGS = 

.PHONY: all clean

all: simplecache cachesim unit_tests

cachesim: cache.o cacheblock.o cacheconfig.o cachesimulator.o main.o utils.o
	$(LD) $(LDFLAGS) -o $@ $(filter %.o,$^)

unit_tests: cacheblock.o cacheblock_test.o cacheconfig.o cacheconfig_test.o \
            utils.o utils_test.o $(GTEST_LIB)
	$(LD) $(LDFLAGS) -pthread -o $@ $^

cache.o: cache.h cacheblock.h cacheconfig.h cache.cpp
cacheblock.o: cache.h cacheblock.h counter.h memory.h cacheblock.cpp
cacheconfig.o: cacheconfig.h utils.h cacheconfig.cpp
cachesimulator.o: cache.h cacheblock.h cacheconfig.h cachepolicy.h \
                  cachesimulator.h counter.h memory.h utils.h cachesimulator.cpp
main.o: cache.h cacheconfig.h cachepolicy.h cachesimulator.h counter.h utils.h \
        memory.h main.cpp
utils.o: cacheconfig.h utils.h utils.cpp

cacheblock_test.o: cache.h cacheblock.h counter.h memory.h utils_test.h
cacheconfig_test.o: cacheconfig.h cacheconfig_test.cpp
utils_test.o: cacheconfig.h utils.h utils_test.cpp utils_test.h

simplecache: simplecache_main.o simplecache.o
	$(LD) $(LDFLAGS) -o $@ $^

simplecache_main.o: simplecache.h simplecache_main.cpp
simplecache.o: simplecache.h simplecache.cpp

clean:
	rm -rf *.o *.exe simplecache cachesim unit_tests *.dSYM

# Google Test setup

$(GTEST_LIB):
	$(MAKE) -C $(dir $(GTEST_LIB)) CXX=$(CXX) gtest_main.a
