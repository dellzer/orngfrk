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
    int64_t _2;
};

struct struct1 {
    int64_t* _0;
    int64_t _1;
};

typedef int64_t(*function2)(struct struct1);

/* Function forward definitions */
int64_t _1372_main(void);
int64_t _1374_sum_up(struct struct1 _1374_xs);


/* Function definitions */
int64_t _1372_main(void){
    int64_t _1372_t1;
    int64_t _1372_t2;
    int64_t _1372_t3;
    struct struct0 _1373_x;
    int64_t _1372_t6;
    int64_t _1372_t7;
    int64_t* _1372_t8;
    int64_t _1372_t9;
    struct struct1 _1373_y;
    int64_t _1372_t11;
    uint8_t _1372_t12;
    int64_t _1372_t13;
    int64_t* _1372_t14;
    struct struct1 _1373_z;
    function2 _1372_t17;
    int64_t _1372_t18;
    int64_t _1372_$retval;
    _1372_t1 = 100;
    _1372_t2 = 10;
    _1372_t3 = 1;
    _1373_x = (struct struct0) {_1372_t1, _1372_t2, _1372_t3};
    _1372_t6 = 0;
    _1372_t7 = 3;
    $bounds_check(_1372_t6, _1372_t7, "tests/integration/slices/infer-both.orng:4:19:\n    let y = [mut]x\n                 ^");
    _1372_t8 = ((int64_t*)&_1373_x + _1372_t6);
    _1372_t9 = 3;
    _1373_y = (struct struct1) {_1372_t8, _1372_t9};
    _1372_t11 = 0;
    _1372_t12 = _1372_t11>_1373_y._1;
    if (_1372_t12) {
        goto BB1612;
    } else {
        goto BB1613;
    }
BB1612:
    $lines[$line_idx++] = "tests/integration/slices/infer-both.orng:5:25:\n    let z: [mut]Int = y[..]\n                       ^";
    $panic("subslice lower bound is greater than upper bound\n");
BB1613:
    _1372_t13 = $sub_int64_t(_1373_y._1, _1372_t11, "tests/integration/slices/infer-both.orng:5:25:\n    let z: [mut]Int = y[..]\n                       ^");
    _1372_t14 = _1373_y._0+_1372_t11;
    _1373_z = (struct struct1) {_1372_t14, _1372_t13};
    _1372_t17 = (function2) _1374_sum_up;
    $lines[$line_idx++] = "tests/integration/slices/infer-both.orng:6:12:\n    sum_up(z)\n          ^";
    _1372_t18 = _1372_t17(_1373_z);
    $line_idx--;
    _1372_$retval = _1372_t18;
    return _1372_$retval;
}

int64_t _1374_sum_up(struct struct1 _1374_xs){
    int64_t _1375_sum;
    int64_t _1376_i;
    uint8_t _1374_t5;
    int64_t _1374_t7;
    int64_t _1374_$retval;
    _1375_sum = 0;
    _1376_i = 0;
    goto BB1604;
BB1604:
    _1374_t5 = _1376_i<_1374_xs._1;
    if (_1374_t5) {
        goto BB1605;
    } else {
        goto BB1610;
    }
BB1605:
    $bounds_check(_1376_i, _1374_xs._1, "tests/integration/slices/infer-both.orng:12:15:\n        sum += xs[i]\n             ^");
    _1375_sum = $add_int64_t(_1375_sum, *((int64_t*)_1374_xs._0 + _1376_i), "tests/integration/slices/infer-both.orng:12:15:\n        sum += xs[i]\n             ^");
    _1374_t7 = 1;
    _1376_i = $add_int64_t(_1376_i, _1374_t7, "tests/integration/slices/infer-both.orng:11:50:\n    while let mut i: Int = 0; i < xs.length; i += 1 {\n                                                ^");
    goto BB1604;
BB1610:
    _1374_$retval = _1375_sum;
    return _1374_$retval;
}


int main(void) {
  printf("%ld",_1372_main());
  return 0;
}
