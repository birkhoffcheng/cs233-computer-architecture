#ifndef CACHEPOLICY_H
#define CACHEPOLICY_H

class CachePolicy {
public:
  CachePolicy(bool write_back, bool write_allocate)
  : _write_back(write_back), _write_allocate(write_allocate) {
    // that's all folks
  }

  bool is_write_back() const { return _write_back; }
  bool is_write_allocate() const { return _write_allocate; }

private:
  bool _write_back;
  bool _write_allocate;
};

#endif
