/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef uint8_t(*function0)(int64_t);

/* Function forward definitions */
int64_t _626_main(void);
uint8_t _631_f(int64_t _631_x);

/* Function definitions */
int64_t _626_main(void) {
    function0 _626_t1;
    int64_t _626_t3;
    uint8_t _626_t2;
    int64_t _626_t0;
    int64_t _626_$retval;
    _626_t1 = _631_f;
    _626_t3 = 4;
    $lines[$line_idx++] = "tests/integration/expressions/self-greater.orng:3:10:\n    if f(4) {\n        ^";
    _626_t2 = _626_t1(_626_t3);
    $line_idx--;
    if (_626_t2) {
        goto BB1;
    } else {
        goto BB5;
    }
BB1:
    _626_t0 = 0;
    goto BB4;
BB5:
    _626_t0 = 224;
    goto BB4;
BB4:
    _626_$retval = _626_t0;
    return _626_$retval;
}

uint8_t _631_f(int64_t _631_x) {
    uint8_t _631_$retval;
    (void)_631_x;
    _631_$retval = 0;
    return _631_$retval;
}

int main(void) {
  printf("%ld",_626_main());
  return 0;
}
