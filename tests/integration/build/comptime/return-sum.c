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
    uint64_t tag;
    union {
        int64_t _0;
    };
};

/* Function forward definitions */
int64_t _352_main(void);


/* Function definitions */
int64_t _352_main(void){
    int64_t _352_t1;
    struct struct0 _352_t2;
    int64_t _352_$retval;
    _352_t1 = 265;
    _352_t2 = (struct struct0) {.tag=0, ._0=_352_t1};
    _352_$retval = _352_t2._0;
    return _352_$retval;
}


int main(void) {
  printf("%ld",_352_main());
  return 0;
}
