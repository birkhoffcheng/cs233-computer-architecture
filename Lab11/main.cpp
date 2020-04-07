#include <cassert>
#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <vector>

#include "cache.h"
#include "cacheconfig.h"
#include "cachepolicy.h"
#include "cachesimulator.h"
#include "counter.h"
#include "memory.h"
#include "utils.h"

using namespace std;

void access(const CacheSimulator& simulator, Counter& accesses,
    bool write, uint32_t address, uint32_t& data, bool verbose) {
  uint32_t initial_hits = simulator.get_hits();
  ++accesses;

  if (write) {
    simulator.write_access(address, data);
  } else {
    data = simulator.read_access(address);
  }

  if (verbose) {
    bool hit = simulator.get_hits() != initial_hits;
    printf("<%s on %x> ", hit ? "HIT" : "MISS", address);
  }
}

int main(int argc, char* argv[]) {
  bool verbose = argc == 9 && strcmp(argv[8], "verbose") == 0;
  if (argc != 8 && !verbose) {
    cerr << "Usage: " << argv[0] <<
      " <trace_file>"
      " <data_file>"
      " <cache_size>"
      " <block_size>"
      " <set_associativity>"
      " <write_back>"
      " <write_allocate>"
      " [verbose]"
      "\n";
    exit(1);
  }

  string trace_file = argv[1];

  string data_file = argv[2];
  Memory memory(data_file);

  uint32_t size = strtoul(argv[3], NULL, 10);
  uint32_t block_size = strtoul(argv[4], NULL, 10);
  uint32_t set_associativity = strtoul(argv[5], NULL, 10);
  CacheConfig cache_config(size, block_size, set_associativity);

  bool write_back = strtoul(argv[6], NULL, 10);
  bool write_allocate = strtoul(argv[7], NULL, 10);
  CachePolicy cache_policy(write_back, write_allocate);

  Cache cache(cache_config);

  CacheSimulator simulator(&cache, &memory, cache_policy);

  ifstream trace_stream(trace_file);
  if (!trace_stream) {
    throw invalid_argument("Could not open trace file");
  }

  char type;
  uint32_t address1, address2, address;
  uint32_t data1, data2, data;
  Counter accesses;

  while (trace_stream >> dec >> type) {
    switch (type) {
      case 'A':
        trace_stream >> hex >> address >> address1 >> address2 >> dec;
        access(simulator, accesses, false, address1, data1, verbose);
        access(simulator, accesses, false, address2, data2, verbose);
        data = data1 + data2;
        access(simulator, accesses, true, address, data, verbose);
        if (verbose) {
          printf("(%u + %u = %u)\n", data1, data2, data);
        }
        break;

      case 'R':
        trace_stream >> hex >> address >> dec;
        access(simulator, accesses, false, address, data, verbose);
        if (verbose) {
          printf("(%u)\n", data);
        }
        break;
    }
  }

  double hit_rate = 100.0 * simulator.get_hits() / accesses.get_count();
  printf("Accesses: %d, Hits: %d, Hit rate: %.4f%%\n",
      accesses.get_count(), simulator.get_hits(), hit_rate);
  printf("Memory reads: %d, Memory writes: %d\n",
      memory.get_reads(), memory.get_writes());

  return 0;
}
