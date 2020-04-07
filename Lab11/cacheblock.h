#ifndef CACHEBLOCK_H
#define CACHEBLOCK_H

#include <cassert>
#include <cstdint>

#include "cache.h"
#include "counter.h"
#include "memory.h"

using std::uint32_t;
using std::vector;

class Cache::Block {
public:
  Block(uint32_t index, const CacheConfig& cache_config)
  : _index(index), _data(cache_config.get_block_size()),
  _cache_config(cache_config) {
    // nothing to see here. move along.
  }

  uint32_t get_tag() const {
    ++_touches;
    return _tag;
  }
  void set_tag(uint32_t tag) { _tag = tag; }

  bool is_valid() const { return _valid; }
  void mark_as_valid() { _valid = true; }

  bool is_dirty() const { return _dirty; }
  void mark_as_dirty() { _dirty = true; }
  void mark_as_clean() { _dirty = false; }

  uint32_t get_last_used_time() const { return _last_used_time; }
  void set_last_used_time(uint32_t time) { _last_used_time = time; }

  void write_data_to_memory(Memory *memory) const {
    memory->write_block(get_address(), _data);
  }

  void read_data_from_memory(Memory *memory) {
    _data = memory->read_block(get_address(), _data.size());
  }

  uint32_t read_word_at_offset(uint32_t block_offset) const {
    assert(block_offset < _data.size());
    ++_reads;
    return _data[block_offset];
  }

  void write_word_at_offset(uint32_t data, uint32_t block_offset) {
    assert(block_offset < _data.size());
    ++_writes;
    _data[block_offset] = data;
  }

  uint32_t get_address() const;

private:
  // there aren't actually stored in a cache block in real caches
  // we use them here for simplicity
  uint32_t _index;
  uint32_t _last_used_time = 0;

  uint32_t _tag = 0;
  bool _valid =  false;
  bool _dirty = false;
  vector<uint32_t> _data;

  const CacheConfig& _cache_config;

  // used for testing purposes
  mutable Counter _touches;
  mutable Counter _reads;
  mutable Counter _writes;
};

#endif
