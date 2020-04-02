#include "utils_test.h"
#include "utils.h"

TEST(Utils, Extract) {
  CacheConfig config(524288, 256, 8);
  unsigned address = 0xdeadbeef;
  EXPECT_PRED_FORMAT2(AssertHexEquality, 0xef, 
    extract_block_offset(address, config));
  EXPECT_PRED_FORMAT2(AssertHexEquality, 0xbe, 
    extract_index(address, config));
  EXPECT_PRED_FORMAT2(AssertHexEquality, 0xdead, 
    extract_tag(address, config));
}

TEST(Utils, Extract32BitTag) {
  CacheConfig config(4, 1, 4);
  unsigned address = 0xbaadf00d;

  EXPECT_PRED_FORMAT2(AssertHexEquality, 0, extract_block_offset(address, config));
  EXPECT_PRED_FORMAT2(AssertHexEquality, 0, extract_index(address, config));
  EXPECT_PRED_FORMAT2(AssertHexEquality, address, extract_tag(address, config));
}
