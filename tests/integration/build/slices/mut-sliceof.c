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
};

struct struct1 {
    int64_t* _0;
    int64_t _1;
};

/* Function forward definitions */
int64_t _1410_main(void);


/* Function definitions */
int64_t _1410_main(void){
    int64_t _1410_t1;
    int64_t _1410_t2;
    int64_t _1410_t3;
    int64_t _1410_t4;
    int64_t _1410_t5;
    struct struct0 _1411_x;
    int64_t _1410_t8;
    int64_t _1410_t9;
    int64_t* _1410_t10;
    int64_t _1410_t11;
    struct struct1 _1411_y;
    int64_t _1410_t14;
    int64_t _1410_t15;
    int64_t _1410_$retval;
    _1410_t1 = 1;
    _1410_t2 = 2;
    _1410_t3 = 3;
    _1410_t4 = 4;
    _1410_t5 = 5;
    _1411_x = (struct struct0) {_1410_t1, _1410_t2, _1410_t3, _1410_t4, _1410_t5};
    _1410_t8 = 0;
    _1410_t9 = 5;
    $bounds_check(_1410_t8, _1410_t9, "tests/integration/slices/mut-sliceof.orng:4:29:\n    let y: [mut]Int = [mut]x\n                           ^");
    _1410_t10 = ((int64_t*)&_1411_x + _1410_t8);
    _1410_t11 = 5;
    _1411_y = (struct struct1) {_1410_t10, _1410_t11};
    _1410_t14 = 2;
    $bounds_check(_1410_t14, _1411_y._1, "tests/integration/slices/mut-sliceof.orng:5:14:\n    y[2] = 81\n            ^");
    *((int64_t*)_1411_y._0 + _1410_t14) = 81;
    _1410_t15 = 2;
    $bounds_check(_1410_t15, _1411_y._1, "tests/integration/slices/mut-sliceof.orng:2:8:\nfn main() -> Int {\n      ^");
    _1410_$retval = *((int64_t*)_1411_y._0 + _1410_t15);
    return _1410_$retval;
}


int main(void) {
  printf("%ld",_1410_main());
  return 0;
}
