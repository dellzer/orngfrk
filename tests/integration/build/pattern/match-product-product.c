/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */
struct struct0;
struct struct1;

/* Struct, union, and function definitions */
struct struct0 {
    int64_t _0;
    int64_t _1;
};

struct struct1 {
    struct struct0 _0;
    struct struct0 _1;
};

/* Function forward definitions */
int64_t _1327_main(void);


/* Function definitions */
int64_t _1327_main(void){
    int64_t _1327_t3;
    int64_t _1327_t4;
    struct struct0 _1327_t2;
    int64_t _1327_t6;
    int64_t _1327_t7;
    struct struct0 _1327_t5;
    struct struct1 _1327_t1;
    int64_t _1327_t8;
    uint8_t _1327_t9;
    int64_t _1327_t10;
    uint8_t _1327_t11;
    int64_t _1327_t0;
    int64_t _1327_t14;
    uint8_t _1327_t15;
    int64_t _1327_$retval;
    int64_t _1327_t12;
    uint8_t _1327_t13;
    _1327_t3 = 100;
    _1327_t4 = 100;
    _1327_t2 = (struct struct0) {_1327_t3, _1327_t4};
    _1327_t6 = 200;
    _1327_t7 = 200;
    _1327_t5 = (struct struct0) {_1327_t6, _1327_t7};
    _1327_t1 = (struct struct1) {_1327_t2, _1327_t5};
    _1327_t8 = 100;
    _1327_t9 = _1327_t1._0._0==_1327_t8;
    if (_1327_t9) {
        goto BB1527;
    } else {
        goto BB1532;
    }
BB1527:
    _1327_t10 = 130;
    _1327_t11 = _1327_t1._0._1==_1327_t10;
    if (_1327_t11) {
        goto BB1529;
    } else {
        goto BB1532;
    }
BB1532:
    _1327_t12 = 100;
    _1327_t13 = _1327_t1._0._0==_1327_t12;
    if (_1327_t13) {
        goto BB1533;
    } else {
        goto BB1537;
    }
BB1529:
    _1327_t0 = 4;
    goto BB1531;
BB1533:
    _1327_t14 = 100;
    _1327_t15 = _1327_t1._0._1==_1327_t14;
    if (_1327_t15) {
        goto BB1535;
    } else {
        goto BB1537;
    }
BB1537:
    $lines[$line_idx++] = "tests/integration/pattern/match-product-product.orng:6:39:\n        _               => unreachable\n                                     ^";
    $panic("reached unreachable code\n");
BB1531:
    _1327_$retval = _1327_t0;
    return _1327_$retval;
BB1535:
    _1327_t0 = 170;
    goto BB1531;
}


int main(void) {
  printf("%ld",_1327_main());
  return 0;
}
