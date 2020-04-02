#include <gtest/gtest.h>
#include "cacheconfig.h"

TEST(CacheConfig, NumBits) {
  CacheConfig config(65536, 64, 4);
  EXPECT_EQ(6, config.get_num_block_offset_bits());
  EXPECT_EQ(8, config.get_num_index_bits());
  EXPECT_EQ(18, config.get_num_tag_bits());
}
