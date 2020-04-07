#ifndef CACHE_H
#define CACHE_H

#include <cstdint>
#include <vector>

#include "cacheconfig.h"

using std::uint32_t;
using std::vector;

class Cache {
public:
  class Block;

  Cache(const CacheConfig& config) : _config(config) {
    init_blocks();
  }
  ~Cache();

  vector<Block*> get_blocks_in_set(uint32_t index) const;

  const CacheConfig& get_config() const { return _config; }

private:
  vector<Block*> _blocks;
  CacheConfig _config;

  void init_blocks();
};

#endif
