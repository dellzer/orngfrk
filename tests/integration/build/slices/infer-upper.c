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
    int64_t _3;
    int64_t _4;
    int64_t _5;
};

struct struct1 {
    int64_t* _0;
    int64_t _1;
};

typedef int64_t(*function2)(struct struct1);

/* Function forward definitions */
int64_t _1399_main(void);
int64_t _1401_sum_up(struct struct1 _1401_xs);


/* Function definitions */
int64_t _1399_main(void){
    int64_t _1399_t1;
    int64_t _1399_t2;
    int64_t _1399_t3;
    int64_t _1399_t4;
    int64_t _1399_t5;
    int64_t _1399_t6;
    struct struct0 _1400_x;
    int64_t _1399_t9;
    int64_t _1399_t10;
    int64_t* _1399_t11;
    int64_t _1399_t12;
    struct struct1 _1400_y;
    int64_t _1399_t14;
    uint8_t _1399_t15;
    int64_t _1399_t16;
    int64_t* _1399_t17;
    struct struct1 _1400_z;
    function2 _1399_t20;
    int64_t _1399_t21;
    int64_t _1399_$retval;
    _1399_t1 = 34;
    _1399_t2 = 25;
    _1399_t3 = 34;
    _1399_t4 = 100;
    _1399_t5 = 8;
    _1399_t6 = 3;
    _1400_x = (struct struct0) {_1399_t1, _1399_t2, _1399_t3, _1399_t4, _1399_t5, _1399_t6};
    _1399_t9 = 0;
    _1399_t10 = 6;
    $bounds_check(_1399_t9, _1399_t10, "tests/integration/slices/infer-upper.orng:4:19:\n    let y = [mut]x\n                 ^");
    _1399_t11 = ((int64_t*)&_1400_x + _1399_t9);
    _1399_t12 = 6;
    _1400_y = (struct struct1) {_1399_t11, _1399_t12};
    _1399_t14 = 3;
    _1399_t15 = _1399_t14>_1400_y._1;
    if (_1399_t15) {
        goto BB1646;
    } else {
        goto BB1647;
    }
BB1646:
    $lines[$line_idx++] = "tests/integration/slices/infer-upper.orng:5:25:\n    let z: [mut]Int = y[3..]\n                       ^";
    $panic("subslice lower bound is greater than upper bound\n");
BB1647:
    _1399_t16 = $sub_int64_t(_1400_y._1, _1399_t14, "tests/integration/slices/infer-upper.orng:5:25:\n    let z: [mut]Int = y[3..]\n                       ^");
    _1399_t17 = _1400_y._0+_1399_t14;
    _1400_z = (struct struct1) {_1399_t17, _1399_t16};
    _1399_t20 = (function2) _1401_sum_up;
    $lines[$line_idx++] = "tests/integration/slices/infer-upper.orng:6:12:\n    sum_up(z)\n          ^";
    _1399_t21 = _1399_t20(_1400_z);
    $line_idx--;
    _1399_$retval = _1399_t21;
    return _1399_$retval;
}

int64_t _1401_sum_up(struct struct1 _1401_xs){
    int64_t _1402_sum;
    int64_t _1403_i;
    uint8_t _1401_t5;
    int64_t _1401_t7;
    int64_t _1401_$retval;
    _1402_sum = 0;
    _1403_i = 0;
    goto BB1638;
BB1638:
    _1401_t5 = _1403_i<_1401_xs._1;
    if (_1401_t5) {
        goto BB1639;
    } else {
        goto BB1644;
    }
BB1639:
    $bounds_check(_1403_i, _1401_xs._1, "tests/integration/slices/infer-upper.orng:12:15:\n        sum += xs[i]\n             ^");
    _1402_sum = $add_int64_t(_1402_sum, *((int64_t*)_1401_xs._0 + _1403_i), "tests/integration/slices/infer-upper.orng:12:15:\n        sum += xs[i]\n             ^");
    _1401_t7 = 1;
    _1403_i = $add_int64_t(_1403_i, _1401_t7, "tests/integration/slices/infer-upper.orng:11:50:\n    while let mut i: Int = 0; i < xs.length; i += 1 {\n                                                ^");
    goto BB1638;
BB1644:
    _1401_$retval = _1402_sum;
    return _1401_$retval;
}


int main(void) {
  printf("%ld",_1399_main());
  return 0;
}
