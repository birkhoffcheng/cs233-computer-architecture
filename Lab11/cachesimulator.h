#ifndef CACHE_SIMULATOR
#define CACHE_SIMULATOR

#include <cassert>
#include <cstdlib>

#include "cache.h"
#include "cacheblock.h"
#include "cacheconfig.h"
#include "cachepolicy.h"
#include "counter.h"
#include "memory.h"
#include "utils.h"

using std::uint32_t;

class CacheSimulator {
public:
  CacheSimulator(Cache* cache, Memory* memory, CachePolicy policy)
  : _cache(cache), _memory(memory), _policy(policy) {
    // cache initialized.
  }

  uint32_t read_access(uint32_t address) const;
  void write_access(uint32_t address, uint32_t word) const;

  uint32_t get_hits() const { return _hits.get_count(); }

private:
  Cache* _cache;
  Memory* _memory;
  CachePolicy _policy;
  mutable Counter _use_clock;
  mutable Counter _hits;

  Cache::Block* find_block(uint32_t address) const;
  Cache::Block* bring_block_into_cache(uint32_t address) const;
};

#endif
