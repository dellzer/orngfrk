/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward typedefs */
struct struct0;
struct struct1;

/* Typedefs */
struct struct0 {
    int64_t _0;
    int64_t _1;
};

struct struct1 {
    struct struct0 _0;
    struct struct0 _1;
};

/* Function forward definitions */
int64_t _1126_main(void);

/* Function definitions */
int64_t _1126_main(void){
    int64_t _1126_t2;
    int64_t _1126_t3;
    struct struct0 _1126_t1;
    int64_t _1126_t5;
    int64_t _1126_t6;
    struct struct0 _1126_t4;
    struct struct1 _1126_t0;
    int64_t _1127_x;
    int64_t _1127_y;
    int64_t _1127_a;
    int64_t _1127_b;
    int64_t _1126_t9;
    int64_t _1126_t10;
    struct struct0 _1126_t8;
    int64_t _1126_t12;
    int64_t _1126_t13;
    struct struct0 _1126_t11;
    struct struct1 _1126_t7;
    int64_t _1126_t16;
    int64_t _1126_t17;
    int64_t _1126_$retval;
    _1126_t2 = 0;
    _1126_t3 = 0;
    _1126_t1 = (struct struct0) {_1126_t2, _1126_t3};
    _1126_t5 = 0;
    _1126_t6 = 0;
    _1126_t4 = (struct struct0) {_1126_t5, _1126_t6};
    _1126_t0 = (struct struct1) {_1126_t1, _1126_t4};
    _1127_x = _1126_t0._0._0;
    _1127_y = _1126_t0._0._1;
    _1127_a = _1126_t0._1._0;
    _1127_b = _1126_t0._1._1;
    _1126_t9 = 1;
    _1126_t10 = 40;
    _1126_t8 = (struct struct0) {_1126_t9, _1126_t10};
    _1126_t12 = 2;
    _1126_t13 = 2;
    _1126_t11 = (struct struct0) {_1126_t12, _1126_t13};
    _1126_t7 = (struct struct1) {_1126_t8, _1126_t11};
    _1127_x = _1126_t7._0._0;
    _1127_y = _1126_t7._0._1;
    _1127_a = _1126_t7._1._0;
    _1127_b = _1126_t7._1._1;
    _1126_t16 = $add_int64_t(_1127_x, _1127_y, "tests/integration/pattern/assign-product-product.orng:5:9:\n    (x + y) * (a + b)\n       ^");
    _1126_t17 = $add_int64_t(_1127_a, _1127_b, "tests/integration/pattern/assign-product-product.orng:5:19:\n    (x + y) * (a + b)\n                 ^");
    _1126_$retval = $mult_int64_t(_1126_t16, _1126_t17, "tests/integration/pattern/assign-product-product.orng:5:14:\n    (x + y) * (a + b)\n            ^");
    return _1126_$retval;
}

int main(void) {
  printf("%ld",_1126_main());
  return 0;
}
