/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward typedefs */
struct struct0;

/* Typedefs */
struct struct0 {
    int64_t _0;
    int64_t _1;
};

/* Function forward definitions */
int64_t _1505_main(void);

/* Function definitions */
int64_t _1505_main(void){
    int64_t _1505_t1;
    int64_t _1505_t2;
    struct struct0 _1506_x;
    struct struct0* _1506_y;
    int64_t _1505_$retval;
    _1505_t1 = 11;
    _1505_t2 = 11;
    _1506_x = (struct struct0) {_1505_t1, _1505_t2};
    _1506_y = &_1506_x;
    (*_1506_y)._0 = 50;
    _1505_$retval = $add_int64_t((*_1506_y)._0, (*_1506_y)._1, "tests/integration/tuples/implicit-deref.orng:6:10:\n    y.a + y.b\n        ^");
    return _1505_$retval;
}

int main(void) {
  printf("%ld",_1505_main());
  return 0;
}
