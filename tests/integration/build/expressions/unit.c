/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef void(*function0)(void);

/* Function forward definitions */
int64_t _855_main(void);
void _857_f(void);

/* Function definitions */
int64_t _855_main(void) {
    function0 _855_t0;
    int64_t _855_$retval;
    _855_t0 = _857_f;
    $lines[$line_idx++] = "tests/integration/expressions/unit.orng:3:7:\n    f()\n     ^";
    _855_t0();
    $line_idx--;
    _855_$retval = 48;
    return _855_$retval;
}

void _857_f(void) {
    return;
}

int main(void) {
  printf("%ld",_855_main());
  return 0;
}
