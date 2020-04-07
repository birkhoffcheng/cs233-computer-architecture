#ifndef SIMPLECACHEBLOCK_H
#define SIMPLECACHEBLOCK_H

#include <vector>
#include <map>

class SimpleCacheBlock {
  char _data[4]; // assuming fixed block size of 4
  bool _valid;
  int _tag;

  void initialize(int tag, char data[]) {
    _tag = tag;
    for (int i = 0; i < 4; i++) {
      _data[i] = data[i];
    }
  }

 public:
  SimpleCacheBlock() {
    _valid = false;
  }

  void replace(int tag, char data[]) {
    _valid = true;
    initialize(tag, data);
  }

  char get_byte(int block_offset) {
    return _data[block_offset];
  }

  bool valid() {
    return _valid;
  }

  int tag() {
    return _tag;
  }
};

class SimpleCache {
  std::map< int, std::vector< SimpleCacheBlock > > _cache;
  size_t _associativity;

 public:
  SimpleCache(int associativity, int index_range) {
    _associativity = associativity;
    for (int index = 0; index < index_range; index++) {
      _cache[index].resize(_associativity);
    }
  }

  int find(int index, int tag, int byte_index);
  void insert(int index, int tag, char data[]);
};

#endif //SIMPLECACHEBLOCK_H
