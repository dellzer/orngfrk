/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */
struct struct0;
struct struct1;

/* Struct, union, and function definitions */
struct struct0 {
    int64_t _0;
    int64_t _1;
    int64_t _2;
    int64_t _3;
};

struct struct1 {
    int64_t* _0;
    int64_t _1;
};

typedef int64_t(*function2)(void);

/* Function forward definitions */
int64_t _1175_main(void);
int64_t _1177_f(void);


/* Function definitions */
int64_t _1175_main(void){
    int64_t _1175_t1;
    int64_t _1175_t2;
    int64_t _1175_t3;
    int64_t _1175_t4;
    struct struct0 _1176_x;
    int64_t _1175_t7;
    int64_t _1175_t8;
    int64_t* _1175_t9;
    int64_t _1175_t10;
    struct struct1 _1176_y;
    function2 _1175_t12;
    int64_t _1175_t13;
    int64_t _1175_$retval;
    _1175_t1 = 0;
    _1175_t2 = 0;
    _1175_t3 = 0;
    _1175_t4 = 0;
    _1176_x = (struct struct0) {_1175_t1, _1175_t2, _1175_t3, _1175_t4};
    _1175_t7 = 0;
    _1175_t8 = 4;
    $bounds_check(_1175_t7, _1175_t8, "tests/integration/lint/slice-pos-bounds-check.orng:4:16:\n    let y = []x\n              ^");
    _1175_t9 = ((int64_t*)&_1176_x + _1175_t7);
    _1175_t10 = 4;
    _1176_y = (struct struct1) {_1175_t9, _1175_t10};
    _1175_t12 = (function2) _1177_f;
    $lines[$line_idx++] = "tests/integration/lint/slice-pos-bounds-check.orng:5:9:\n    y[f()]\n       ^";
    _1175_t13 = _1175_t12();
    $line_idx--;
    $bounds_check(_1175_t13, _1176_y._1, "tests/integration/lint/slice-pos-bounds-check.orng:2:8:\nfn main() -> Int {\n      ^");
    _1175_$retval = *((int64_t*)_1176_y._0 + _1175_t13);
    return _1175_$retval;
}

int64_t _1177_f(void){
    int64_t _1177_$retval;
    _1177_$retval = 100;
    return _1177_$retval;
}


int main(void) {
  printf("%ld",_1175_main());
  return 0;
}
