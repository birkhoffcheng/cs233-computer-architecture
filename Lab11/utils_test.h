#ifndef UTILS_TEST_H
#define UTILS_TEST_H

#include <gtest/gtest.h>

inline ::testing::AssertionResult AssertHexEquality(const char* m_exp, const char* n_exp, uint32_t m, uint32_t n)
{
  if (m == n)
    return ::testing::AssertionSuccess();
  char result[100];
  snprintf(result, 100, "Value of: %s\n  Actual: 0x%x\nExpected: 0x%x", n_exp, n, m);
  return ::testing::AssertionFailure() << result;
}

#endif // UTILS_TEST_H
