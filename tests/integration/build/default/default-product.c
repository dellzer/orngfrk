/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef struct {
    int64_t _0;
    double _1;
} struct0;

/* Function forward definitions */
int64_t _461_main(void);

/* Function definitions */
int64_t _461_main(void) {
    int64_t _461_t1;
    double _461_t2;
    struct0 _462_x;
    int64_t _461_t5;
    uint8_t _461_t7;
    int64_t _461_t3;
    int64_t _461_$retval;
    double _461_t8;
    uint8_t _461_t10;
    _461_t1 = 0;
    _461_t2 = 0.0e+00;
    _462_x = (struct0) {_461_t1, _461_t2};
    _461_t5 = 0;
    _461_t7 = _462_x._0 == _461_t5;
    if (_461_t7) {
        goto BB3;
    } else {
        goto BB11;
    }
BB3:
    _461_t8 = 0.0e+00;
    _461_t10 = _462_x._1 == _461_t8;
    if (_461_t10) {
        goto BB7;
    } else {
        goto BB11;
    }
BB11:
    _461_t3 = 0;
    goto BB10;
BB7:
    _461_t3 = 135;
    goto BB10;
BB10:
    _461_$retval = _461_t3;
    return _461_$retval;
}

int main(void) {
  printf("%ld",_461_main());
  return 0;
}
