/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef uint8_t(*function0)(int64_t);

/* Function forward definitions */
int64_t _867_main(void);
uint8_t _872_f(int64_t _872_x);

/* Function definitions */
int64_t _867_main(void){
    function0 _867_t1;
    int64_t _867_t3;
    uint8_t _867_t2;
    int64_t _867_t0;
    int64_t _867_$retval;
    _867_t1 = _872_f;
    _867_t3 = 4;
    $lines[$line_idx++] = "tests/integration/expressions/sub-zero.orng:3:10:\n    if f(4) {\n        ^";
    _867_t2 = _867_t1(_867_t3);
    $line_idx--;
    if (_867_t2) {
        goto BB1116;
    } else {
        goto BB1120;
    }
BB1116:
    _867_t0 = 184;
    goto BB1119;
BB1120:
    _867_t0 = 4;
    goto BB1119;
BB1119:
    _867_$retval = _867_t0;
    return _867_$retval;
}

uint8_t _872_f(int64_t _872_x){
    uint8_t _872_$retval;
    uint8_t _872_t8;
    int64_t _872_t6;
    int64_t _872_t7;
    uint8_t _872_t9;
    _872_t6 = $negate_int64_t(_872_x, "tests/integration/expressions/sub-zero.orng:11:23:\n    x - 0 == x and 0 - x == -x\n                     ^");
    _872_t7 = $negate_int64_t(_872_x, "tests/integration/expressions/sub-zero.orng:11:30:\n    x - 0 == x and 0 - x == -x\n                            ^");
    _872_t9 = _872_t6==_872_t7;
    if (_872_t9) {
        goto BB1108;
    } else {
        goto BB1112;
    }
BB1108:
    _872_t8 = 1;
    goto BB1109;
BB1112:
    _872_t8 = 0;
    goto BB1109;
BB1109:
    _872_$retval = _872_t8;
    return _872_$retval;
}

int main(void) {
  printf("%ld",_867_main());
  return 0;
}
