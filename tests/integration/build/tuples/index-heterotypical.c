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
    uint32_t _0;
    int64_t _1;
    double _2;
};

/* Function forward definitions */
int64_t _1900_main(void);


/* Function definitions */
int64_t _1900_main(void){
    uint32_t _1900_t1;
    int64_t _1900_t2;
    double _1900_t3;
    struct struct0 _1901_x;
    int64_t _1900_$retval;
    _1900_t1 = 960;
    _1900_t2 = 247;
    _1900_t3 = 3.14e0;
    _1901_x = (struct struct0) {_1900_t1, _1900_t2, _1900_t3};
    _1900_$retval = _1901_x._1;
    return _1900_$retval;
}


int main(void) {
  printf("%ld",_1900_main());
  return 0;
}
