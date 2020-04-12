#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
	if (_cache_config.get_num_tag_bits() != 32 - _cache_config.get_num_index_bits() - _cache_config.get_num_block_offset_bits())
		return 0;
	uint32_t address = _tag << (32 - _cache_config.get_num_tag_bits());
	address |= _index << _cache_config.get_num_block_offset_bits();
	return address;
}
