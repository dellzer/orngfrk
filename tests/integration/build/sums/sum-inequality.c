/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward typedefs */
struct struct0;

/* Typedefs */
struct struct0 {
    uint64_t tag;
    union {
        int64_t _0;
    };
};

/* Function forward definitions */
int64_t _1470_main(void);

/* Function definitions */
int64_t _1470_main(void){
    int64_t _1470_t0;
    struct struct0 _1471_x;
    uint64_t _1470_t8;
    int64_t _1470_$retval;
    _1470_t0 = 211;
    _1471_x = (struct struct0) {.tag=0, ._0=_1470_t0};
    _1470_t8 = 0;
    $tag_check(_1470_t8, 0, "tests/integration/sums/sum-inequality.orng:4:20:\n    if x != .none {\n                  ^");
    _1470_$retval = _1471_x._0;
    return _1470_$retval;
}

int main(void) {
  printf("%ld",_1470_main());
  return 0;
}
