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
    int64_t* _0;
    int64_t* _1;
};

/* Function forward definitions */
int64_t _1843_main(void);


/* Function definitions */
int64_t _1843_main(void){
    int64_t _1844_x;
    int64_t _1844_y;
    int64_t* _1843_t5;
    int64_t* _1843_t6;
    struct struct0 _1844_z;
    int64_t _1843_$retval;
    _1844_x = 30;
    _1844_y = 29;
    _1843_t5 = &_1844_x;
    _1843_t6 = &_1844_y;
    _1844_z = (struct struct0) {_1843_t5, _1843_t6};
    _1843_$retval = $add_int64_t(*_1844_z._0, *_1844_z._1, "tests/integration/tuples/tuple-addr.orng:6:11:\n    z.a^ + z.b^\n         ^");
    return _1843_$retval;
}


int main(void) {
  printf("%ld",_1843_main());
  return 0;
}
