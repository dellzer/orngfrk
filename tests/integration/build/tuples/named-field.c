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

/* Function forward definitions */
int64_t _1214_main(void);

/* Function definitions */
int64_t _1214_main(void) {
    int64_t _1214_t1;
    int64_t _1214_t2;
    struct0 _1215_x;
    int64_t _1214_$retval;
    _1214_t1 = 20;
    _1214_t2 = 3;
    _1215_x = (struct0) {_1214_t1, _1214_t2};
    _1214_$retval = $mult_int64_t(_1215_x._0, _1215_x._1, "tests/integration/tuples/named-field.orng:4:10:\n    x.a * x.b\n        ^");
    return _1214_$retval;
}

int main(void) {
  printf("%ld",_1214_main());
  return 0;
}
