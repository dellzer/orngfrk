/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef uint8_t(*function0)(double);

/* Function forward definitions */
int64_t _562_main(void);
uint8_t _567_f(double _567_x);

/* Function definitions */
int64_t _562_main(void) {
    function0 _562_t1;
    double _562_t3;
    uint8_t _562_t2;
    int64_t _562_t0;
    int64_t _562_$retval;
    _562_t1 = _567_f;
    _562_t3 = 4.0e+00;
    $lines[$line_idx++] = "tests/integration/expressions/mult-zero-float.orng:3:10:\n    if f(4.0) {\n        ^";
    _562_t2 = _562_t1(_562_t3);
    $line_idx--;
    if (_562_t2) {
        goto BB1;
    } else {
        goto BB5;
    }
BB1:
    _562_t0 = 188;
    goto BB4;
BB5:
    _562_t0 = 4;
    goto BB4;
BB4:
    _562_$retval = _562_t0;
    return _562_$retval;
}

uint8_t _567_f(double _567_x) {
    uint8_t _567_$retval;
    (void)_567_x;
    _567_$retval = 1;
    return _567_$retval;
}

int main(void) {
  printf("%ld",_562_main());
  return 0;
}
