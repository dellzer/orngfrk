/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef struct {
    int64_t _0;
    int64_t _1;
} struct0;

typedef struct {
    struct0 _0;
    struct0 _1;
} struct1;

/* Function forward definitions */
int64_t _1494_main(void);

/* Function definitions */
int64_t _1494_main(void) {
    int64_t _1494_t2;
    int64_t _1494_t3;
    struct0 _1494_t1;
    int64_t _1494_t5;
    int64_t _1494_t6;
    struct0 _1494_t4;
    struct1 _1495_x;
    int64_t _1494_t7;
    int64_t _1494_t8;
    int64_t _1494_$retval;
    _1494_t2 = 25;
    _1494_t3 = 75;
    _1494_t1 = (struct0) {_1494_t2, _1494_t3};
    _1494_t5 = 5;
    _1494_t6 = 90;
    _1494_t4 = (struct0) {_1494_t5, _1494_t6};
    _1495_x = (struct1) {_1494_t1, _1494_t4};
    _1494_t7 = $add_int64_t(_1495_x._0._0, _1495_x._0._1, "tests/integration/tuples/named-field-2d.orng:10:12:\n    x.a.c + x.a.d + x.b.e + x.b.f\n          ^");
    _1494_t8 = $add_int64_t(_1494_t7, _1495_x._1._0, "tests/integration/tuples/named-field-2d.orng:10:20:\n    x.a.c + x.a.d + x.b.e + x.b.f\n                  ^");
    _1494_$retval = $add_int64_t(_1494_t8, _1495_x._1._1, "tests/integration/tuples/named-field-2d.orng:10:28:\n    x.a.c + x.a.d + x.b.e + x.b.f\n                          ^");
    return _1494_$retval;
}

int main(void) {
  printf("%ld",_1494_main());
  return 0;
}
