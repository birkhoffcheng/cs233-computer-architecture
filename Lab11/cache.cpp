#include <cassert>

#include "cache.h"
#include "cacheblock.h"

Cache::~Cache() {
  for (auto block : _blocks) {
    delete block;
  }
}

vector<Cache::Block*> Cache::get_blocks_in_set(uint32_t index) const {
  uint32_t num_sets =
    _config.get_size() / _config.get_block_size() / _config.get_associativity();
  assert(index < num_sets);

  auto first_block =
    _blocks.begin() + (index * _config.get_associativity());
  auto last_block = first_block + _config.get_associativity();
  vector<Block*> set(first_block, last_block);
  return set;
}

void Cache::init_blocks() {
  uint32_t num_blocks = _config.get_size() / _config.get_block_size();

  for (uint32_t i = 0 ; i < num_blocks ; ++i) {
    uint32_t index = i / _config.get_associativity();
    Block* block = new Block(index, _config);
    _blocks.push_back(block);
  }
}
