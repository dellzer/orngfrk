/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */

/* Struct, union, and function definitions */
typedef int64_t(*function0)(void);

/* Function forward definitions */
int64_t _1090_main(void);
int64_t _1092_$anon104(void);
int64_t _1094_$anon105(void);


/* Function definitions */
int64_t _1090_main(void){
    function0 _1090_t0;
    int64_t _1090_t1;
    int64_t _1090_$retval;
    _1090_t0 = (function0) _1092_$anon104;
    $lines[$line_idx++] = "tests/integration/generics/template-in-template.orng:10:11:\n    tempa(149)\n         ^";
    _1090_t1 = _1090_t0();
    $line_idx--;
    _1090_$retval = _1090_t1;
    return _1090_$retval;
}

int64_t _1092_$anon104(void){
    function0 _1092_t1;
    int64_t _1092_t2;
    int64_t _1092_t3;
    int64_t _1092_$retval;
    _1092_t1 = (function0) _1094_$anon105;
    $lines[$line_idx++] = "tests/integration/generics/template-in-template.orng:6:11:\n    tempb(n + 1) + 19\n         ^";
    _1092_t2 = _1092_t1();
    $line_idx--;
    _1092_t3 = 19;
    _1092_$retval = $add_int64_t(_1092_t2, _1092_t3, "tests/integration/generics/template-in-template.orng:6:19:\n    tempb(n + 1) + 19\n                 ^");
    return _1092_$retval;
}

int64_t _1094_$anon105(void){
    int64_t _1094_$retval;
    _1094_$retval = 300;
    return _1094_$retval;
}


int main(void) {
  printf("%ld",_1090_main());
  return 0;
}
