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
};

struct struct1 {
    struct struct0 _0;
    int64_t _1;
};

typedef int64_t(*function2)(struct struct1);

/* Function forward definitions */
int64_t _1933_main(void);
int64_t _1935_f(struct struct1 _1935_a);


/* Function definitions */
int64_t _1933_main(void){
    int64_t _1933_t2;
    int64_t _1933_t3;
    struct struct0 _1933_t1;
    int64_t _1933_t4;
    struct struct1 _1934_x;
    function2 _1933_t6;
    int64_t _1933_t7;
    int64_t _1933_$retval;
    _1933_t2 = 50;
    _1933_t3 = 150;
    _1933_t1 = (struct struct0) {_1933_t2, _1933_t3};
    _1933_t4 = 300;
    _1934_x = (struct struct1) {_1933_t1, _1933_t4};
    _1933_t6 = (function2) _1935_f;
    $lines[$line_idx++] = "tests/integration/tuples/select2.orng:4:7:\n    f(x)\n     ^";
    _1933_t7 = _1933_t6(_1934_x);
    $line_idx--;
    _1933_$retval = _1933_t7;
    return _1933_$retval;
}

int64_t _1935_f(struct struct1 _1935_a){
    int64_t _1935_$retval;
    goto BB2086;
BB2086:
    _1935_$retval = _1935_a._1;
    return _1935_$retval;
}


int main(void) {
  printf("%ld",_1933_main());
  return 0;
}
