#ifndef MEMORY_H
#define MEMORY_H

#include <fstream>
#include <map>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

#include "counter.h"
#include "utils.h"

using std::make_pair;
using std::uint32_t;
using std::vector;

class Memory {
public:
  Memory(const std::string& data_file) {
    if (!data_file.empty()) {
      std::ifstream data_stream(data_file);
      if (!data_stream) {
        throw std::invalid_argument("Could not open data file");
      }

      uint32_t address, data;
      while (data_stream >> std::hex >> address >> std::dec >> data) {
        _data.insert(make_pair(address, data));
      }
    }
  }

  vector<uint32_t> read_block(uint32_t address, uint32_t block_size) {
    uint32_t block_offset_bits = log_2(block_size);
    // address must be the starting address of a block of size block_size
    assert(address == ((address >> block_offset_bits) << block_offset_bits));

    vector<uint32_t> block;
    for (uint32_t i = 0; i < block_size; ++i) {
      block.push_back(_data[address | i]);
    }

    _reads.push_back(address);

    return block;
  }

  void write_block(uint32_t address, vector<uint32_t> data) {
    uint32_t block_size = data.size();
    assert(is_power_of_2(block_size));

    uint32_t block_offset_bits = log_2(block_size);
    // address must be the starting address of a block of size block_size
    assert(address == ((address >> block_offset_bits) << block_offset_bits));

    for (uint32_t i = 0; i < block_size; ++i) {
      _data[address | i] = data[i];
      _writes.push_back(make_pair((address | i), data[i]));
    }

    ++_num_writes;
  }

  void write_word(uint32_t address, uint32_t data) {
    _data[address] = data;
    _writes.push_back(make_pair(address, data));

    ++_num_writes;
  }

  uint32_t get_reads() const { return _reads.size(); }
  uint32_t get_writes() const { return _num_writes.get_count(); }

private:
  std::map<uint32_t, uint32_t> _data;
  mutable vector<uint32_t> _reads;
  mutable vector<std::pair<uint32_t, uint32_t>> _writes;
  mutable Counter _num_writes;
};

#endif
