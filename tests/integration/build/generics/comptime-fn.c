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
    int64_t _1;
};

typedef int64_t(*function0)(int64_t, int64_t);

/* Function forward definitions */
int64_t _1027_main(void);
int64_t _1029_$anon96(int64_t _1029_x, int64_t _1029_y);


/* Function definitions */
int64_t _1027_main(void){
    function0 _1027_t0;
    int64_t _1027_t2;
    int64_t _1027_t3;
    int64_t _1027_t1;
    int64_t _1027_$retval;
    _1027_t0 = (function0) _1029_$anon96;
    _1027_t2 = 300;
    _1027_t3 = 11;
    $lines[$line_idx++] = "tests/integration/generics/comptime-fn.orng:10:9:\n    add(Int, 300, 11)\n       ^";
    _1027_t1 = _1027_t0(_1027_t2, _1027_t3);
    $line_idx--;
    _1027_$retval = _1027_t1;
    return _1027_$retval;
}

int64_t _1029_$anon96(int64_t _1029_x, int64_t _1029_y){
    int64_t _1029_$retval;
    _1029_$retval = $add_int64_t(_1029_x, _1029_y, "tests/integration/generics/comptime-fn.orng:5:45:\nfn add(const T: Type, x: T, y: T) -> T { x + y }\n                                           ^");
    return _1029_$retval;
}


int main(void) {
  printf("%ld",_1027_main());
  return 0;
}
