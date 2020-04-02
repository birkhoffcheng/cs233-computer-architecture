#ifndef UTILS_H
#define UTILS_H

#include <cassert>
#include <cstdint>
#include "cacheconfig.h"

using std::uint32_t;

inline bool is_power_of_2(uint32_t num) {
  return num != 0 && (num & (num - 1)) == 0;
}

inline uint32_t log_2(uint32_t num) {
  assert(is_power_of_2(num));
  return 31 - __builtin_clz(num);
}

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config);

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config);

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config);

#endif
