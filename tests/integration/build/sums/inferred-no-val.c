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
        int64_t _1;
    };
};

/* Function forward definitions */
int64_t _1451_main(void);

/* Function definitions */
int64_t _1451_main(void){
    int64_t _1451_t0;
    struct struct0 _1452_x;
    uint64_t _1451_t3;
    int64_t _1451_t4;
    uint8_t _1451_t6;
    int64_t _1451_$retval;
    _1451_t0 = 0;
    _1452_x = (struct struct0) {.tag=0, ._0=_1451_t0};
    _1451_t3 = 0;
    _1451_t4 = 0;
    $tag_check(_1451_t3, 0, "tests/integration/sums/inferred-no-val.orng:3:10:\n    let x: (a: Int | b: Int) = .a\n        ^");
    _1451_t6 = _1452_x._0==_1451_t4;
    if (_1451_t6) {
        goto BB1715;
    } else {
        goto BB1719;
    }
BB1715:
    _1451_$retval = 280;
    return _1451_$retval;
BB1719:
    $lines[$line_idx++] = "tests/integration/sums/inferred-no-val.orng:7:20:\n        unreachable\n                  ^";
    $panic("reached unreachable code\n");
}

int main(void) {
  printf("%ld",_1451_main());
  return 0;
}
