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

typedef int64_t(*function1)(void);

/* Function forward definitions */
int64_t _1105_main(void);
int64_t _1107_f(void);


/* Function definitions */
int64_t _1105_main(void){
    int64_t _1105_t1;
    int64_t _1105_t2;
    int64_t _1105_t3;
    int64_t _1105_t4;
    struct struct0 _1106_x;
    function1 _1105_t6;
    int64_t _1105_t7;
    int64_t _1105_t8;
    int64_t _1105_$retval;
    _1105_t1 = 0;
    _1105_t2 = 0;
    _1105_t3 = 0;
    _1105_t4 = 0;
    _1106_x = (struct struct0) {_1105_t1, _1105_t2, _1105_t3, _1105_t4};
    _1105_t6 = (function1) _1107_f;
    $lines[$line_idx++] = "tests/integration/lint/array-pos-bounds-check.orng:4:9:\n    x[f()]\n       ^";
    _1105_t7 = _1105_t6();
    $line_idx--;
    _1105_t8 = 4;
    $bounds_check(_1105_t7, _1105_t8, "tests/integration/lint/array-pos-bounds-check.orng:2:8:\nfn main() -> Int {\n      ^");
    _1105_$retval = *((int64_t*)&_1106_x + _1105_t7);
    return _1105_$retval;
}

int64_t _1107_f(void){
    int64_t _1107_$retval;
    _1107_$retval = 100;
    return _1107_$retval;
}


int main(void) {
  printf("%ld",_1105_main());
  return 0;
}
