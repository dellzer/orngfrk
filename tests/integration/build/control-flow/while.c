/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Function forward definitions */
int64_t _100_main(void);

/* Function definitions */
int64_t _100_main(void) {
    int64_t _101_x;
    int64_t _102_i;
    int64_t _100_t3;
    uint8_t _100_t4;
    int64_t _100_t6;
    int64_t _100_$retval;
    _101_x = 0;
    _102_i = 0;
    goto BB1;
BB1:
    _100_t3 = 10;
    _100_t4 = _102_i <= _100_t3;
    if (_100_t4) {
        goto BB2;
    } else {
        goto BB7;
    }
BB2:
    _101_x = $add_int64_t(_101_x, _102_i, "tests/integration/control-flow/while.orng:5:16:\n        x = x + i\n              ^");
    _100_t6 = 1;
    _102_i = $add_int64_t(_102_i, _100_t6, "tests/integration/control-flow/while.orng:4:47:\n    while let mut i: Int = 0; i <= 10; i = i + 1 {\n                                             ^");
    goto BB1;
BB7:
    _100_$retval = _101_x;
    return _100_$retval;
}

int main(void) {
  printf("%ld",_100_main());
  return 0;
}
