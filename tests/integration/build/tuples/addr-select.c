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
    int64_t _0;
    int64_t _1;
    int64_t _2;
    int64_t _3;
};

/* Function forward definitions */
int64_t _1829_main(void);


/* Function definitions */
int64_t _1829_main(void){
    int64_t _1829_t1;
    int64_t _1829_t2;
    int64_t _1829_t3;
    int64_t _1829_t4;
    struct struct0 _1830_x;
    int64_t* _1830_y;
    int64_t _1829_$retval;
    _1829_t1 = 1;
    _1829_t2 = 2;
    _1829_t3 = 3;
    _1829_t4 = 4;
    _1830_x = (struct struct0) {_1829_t1, _1829_t2, _1829_t3, _1829_t4};
    _1830_y = &_1830_x._3;
    *_1830_y = 66;
    _1829_$retval = _1830_x._3;
    return _1829_$retval;
}


int main(void) {
  printf("%ld",_1829_main());
  return 0;
}
