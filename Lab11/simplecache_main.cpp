#include "simplecache.h"
#include <cstdio>

int main() {
  SimpleCache sc(3, 2);
  char a[4] = { 'a', 'b', 'c', 'd' };
  sc.insert(1, 0xf00d, a);
  sc.insert(1, 0xf00e, a);
  sc.insert(1, 0xf00f, a);
  sc.insert(1, 0xd00f, a); // overwrite index=1 tag=0xfood
  sc.insert(0, 0xd00f, a);

  printf("0x%x\n", sc.find(1, 0xf00d, 0)); //0xdeadbeef, since tag 0xfood got overwritten
  printf("0x%x\n", sc.find(1, 0xf00e, 0)); // 'a' = 0x61
  printf("0x%x\n", sc.find(1, 0xf00f, 1)); // 'b' = 0x62
  printf("0x%x\n", sc.find(1, 0xd00f, 2)); // 'c' = 0x63
  printf("0x%x\n", sc.find(0, 0xd00f, 3)); // 'd' = 0x64
}
