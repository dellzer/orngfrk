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
    int64_t _2;
    int64_t _3;
};

typedef int64_t(*function1)(void);

/* Function forward definitions */
int64_t _1028_main(void);
int64_t _1030_f(void);

/* Function definitions */
int64_t _1028_main(void){
    int64_t _1028_t1;
    int64_t _1028_t2;
    int64_t _1028_t3;
    int64_t _1028_t4;
    struct struct0 _1029_x;
    function1 _1028_t6;
    int64_t _1028_t7;
    int64_t _1028_t8;
    int64_t _1028_$retval;
    _1028_t1 = 0;
    _1028_t2 = 0;
    _1028_t3 = 0;
    _1028_t4 = 0;
    _1029_x = (struct struct0) {_1028_t1, _1028_t2, _1028_t3, _1028_t4};
    _1028_t6 = _1030_f;
    $lines[$line_idx++] = "tests/integration/lint/array-copy-neg-bounds-check.orng:4:9:\n    x[f()] = 0\n       ^";
    _1028_t7 = _1028_t6();
    $line_idx--;
    _1028_t8 = 4;
    $bounds_check(_1028_t7, _1028_t8, "tests/integration/lint/array-copy-neg-bounds-check.orng:4:15:\n    x[f()] = 0\n             ^");
    *((int64_t*)&_1029_x + _1028_t7) = 0;
    _1028_$retval = 0;
    return _1028_$retval;
}

int64_t _1030_f(void){
    int64_t _1030_$retval;
    _1030_$retval = -100;
    return _1030_$retval;
}

int main(void) {
  printf("%ld",_1028_main());
  return 0;
}
