#ifndef CACHECONFIG_H
#define CACHECONFIG_H

#include <cstdint>

using std::uint32_t;

class CacheConfig {
public:
  CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity);

  uint32_t get_size() const { return _size; }
  uint32_t get_block_size() const { return _block_size; }
  uint32_t get_associativity() const { return _associativity; }

  uint32_t get_num_block_offset_bits() const { return _num_block_offset_bits; }
  uint32_t get_num_index_bits() const { return _num_index_bits; }
  uint32_t get_num_tag_bits() const { return _num_tag_bits; }

private:
  uint32_t _size;
  uint32_t _block_size;
  uint32_t _associativity;

  uint32_t _num_block_offset_bits;
  uint32_t _num_index_bits;
  uint32_t _num_tag_bits;
};

#endif
