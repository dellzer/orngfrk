/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef struct {
    uint64_t tag;
    union {
        int32_t _1;
    };
} struct0;

/* Function forward definitions */
int64_t _332_f(struct0 _332_x);
int64_t _329_main(void);

/* Function definitions */
int64_t _332_f(struct0 _332_x){
    uint64_t _332_t1;
    uint64_t _332_t2;
    uint8_t _332_t3;
    int64_t _332_t0;
    uint64_t _332_t4;
    uint64_t _332_t5;
    uint8_t _332_t6;
    int64_t _332_$retval;
    _332_t1 = 1;
    _332_t2 = _332_x.tag;
    _332_t3 = _332_t2 == _332_t1;
    if (_332_t3) {
        goto BB3;
    } else {
        goto BB6;
    }
BB3:
    _332_t0 = 250;
    goto BB5;
BB6:
    _332_t4 = 0;
    _332_t5 = _332_x.tag;
    _332_t6 = _332_t5 == _332_t4;
    if (_332_t6) {
        goto BB8;
    } else {
        goto BB10;
    }
BB5:
    _332_$retval = _332_t0;
    return _332_$retval;
BB8:
    _332_t0 = 11;
    goto BB5;
BB10:
    $lines[$line_idx++] = "tests/integration/comptime/optional.orng:10:28:\n        else => unreachable\n                          ^";
    $panic("reached unreachable code\n");
}

int64_t _329_main(void){
    int64_t _329_$retval;
    _329_$retval = 261;
    return _329_$retval;
}

int main(void) {
  printf("%ld",_329_main());
  return 0;
}