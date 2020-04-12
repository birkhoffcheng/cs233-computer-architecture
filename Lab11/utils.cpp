#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
	if (cache_config.get_num_tag_bits() == 0)
		return 0;
	if (cache_config.get_num_tag_bits() >= 32)
		return address;
	uint32_t mask = -1 ^ ((1 << (32 - cache_config.get_num_tag_bits())) - 1);
	return (address & mask) >> (32 - cache_config.get_num_tag_bits());
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
	if (cache_config.get_num_block_offset_bits() >= 32)
		return 0;
	uint32_t mask;
	if (cache_config.get_num_tag_bits() == 0 || cache_config.get_num_tag_bits() > 32)
		mask = -1;
	else
		mask = (1 << (32 - cache_config.get_num_tag_bits())) - 1;
	mask ^= (1 << cache_config.get_num_block_offset_bits()) - 1;
	return (address & mask) >> cache_config.get_num_block_offset_bits();
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
	if (cache_config.get_num_block_offset_bits() >= 32)
		return address;
	uint32_t mask = (1 << cache_config.get_num_block_offset_bits()) - 1;
	return address & mask;
}
