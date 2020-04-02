#ifndef COUNTER_H
#define COUNTER_H

class Counter {
public:
  Counter& operator++() { _increment(); return *this; } // prefix
  Counter operator++(int) { // postfix
    Counter temp(*this);
    _increment();
    return temp;
  }
  uint32_t get_count() const { return _count; }
private:
  uint32_t _count = 0;
  void _increment() { ++_count; }
};

#endif
