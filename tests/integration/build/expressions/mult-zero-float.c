/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef uint8_t(*function0)(double);

/* Function forward definitions */
int64_t _882_main(void);
uint8_t _887_f(double _887_x);

/* Function definitions */
int64_t _882_main(void){
    function0 _882_t1;
    double _882_t3;
    uint8_t _882_t2;
    int64_t _882_t0;
    int64_t _882_$retval;
    _882_t1 = _887_f;
    _882_t3 = 4.0e+00;
    $lines[$line_idx++] = "tests/integration/expressions/mult-zero-float.orng:3:10:\n    if f(4.0) {\n        ^";
    _882_t2 = _882_t1(_882_t3);
    $line_idx--;
    if (_882_t2) {
        goto BB1;
    } else {
        goto BB5;
    }
BB1:
    _882_t0 = 188;
    goto BB4;
BB5:
    _882_t0 = 4;
    goto BB4;
BB4:
    _882_$retval = _882_t0;
    return _882_$retval;
}

uint8_t _887_f(double _887_x){
    uint8_t _887_$retval;
    (void)_887_x;
    _887_$retval = 1;
    return _887_$retval;
}

int main(void) {
  printf("%ld",_882_main());
  return 0;
}
