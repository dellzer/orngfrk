/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */
struct struct0;

/* Struct, union, and function definitions */
struct struct0 {
    int64_t _0;
    int64_t _1;
};

/* Function forward definitions */
int64_t _1215_main(void);


/* Function definitions */
int64_t _1215_main(void){
    int64_t _1215_t1;
    int64_t _1215_t2;
    struct struct0 _1215_t0;
    int64_t _1216_x;
    int64_t _1216_y;
    struct struct0 _1215_t4;
    int64_t _1215_t6;
    uint8_t _1215_t8;
    int64_t _1215_$retval;
    int64_t _1215_t9;
    uint8_t _1215_t11;
    _1215_t1 = 1;
    _1215_t2 = 2;
    _1215_t0 = (struct struct0) {_1215_t1, _1215_t2};
    _1216_x = _1215_t0._0;
    _1216_y = _1215_t0._1;
    _1215_t4 = (struct struct0) {_1216_x, _1216_y};
    _1216_y = _1215_t4._0;
    _1216_x = _1215_t4._1;
    _1215_t6 = 1;
    _1215_t8 = _1216_y==_1215_t6;
    if (_1215_t8) {
        goto BB1383;
    } else {
        goto BB1390;
    }
BB1383:
    _1215_t9 = 2;
    _1215_t11 = _1216_x==_1215_t9;
    if (_1215_t11) {
        goto BB1386;
    } else {
        goto BB1390;
    }
BB1390:
    $lines[$line_idx++] = "tests/integration/pattern/assign-swap.orng:8:20:\n        unreachable\n                  ^";
    $panic("reached unreachable code\n");
BB1386:
    _1215_$retval = 159;
    return _1215_$retval;
}


int main(void) {
  printf("%ld",_1215_main());
  return 0;
}
