/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */
struct struct1;

/* Struct, union, and function definitions */
struct struct1 {
    int64_t _0;
};

typedef struct struct1(*function0)(void);

/* Function forward definitions */
int64_t _1874_main(void);
struct struct1 _1876_get(void);


/* Function definitions */
int64_t _1874_main(void){
    function0 _1874_t0;
    struct struct1 _1874_t1;
    struct struct1 _1875_x;
    int64_t _1874_$retval;
    _1874_t0 = (function0) _1876_get;
    $lines[$line_idx++] = "tests/integration/tuples/1-tuple.orng:3:17:\n    let x = get()\n               ^";
    _1874_t1 = _1874_t0();
    $line_idx--;
    _1875_x = _1874_t1;
    _1874_$retval = _1875_x._0;
    return _1874_$retval;
}

struct struct1 _1876_get(void){
    int64_t _1876_t1;
    struct struct1 _1876_$retval;
    _1876_t1 = 234;
    _1876_$retval = (struct struct1) {_1876_t1};
    return _1876_$retval;
}


int main(void) {
  printf("%ld",_1874_main());
  return 0;
}
