/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef void(*function0)(void);

/* Function forward definitions */
int64_t _824_main(void);
void _826_f(void);

/* Function definitions */
int64_t _824_main(void) {
    function0 _824_t0;
    int64_t _824_$retval;
    _824_t0 = _826_f;
    $lines[$line_idx++] = "tests/integration/expressions/unit.orng:3:7:\n    f()\n     ^";
    _824_t0();
    $line_idx--;
    _824_$retval = 48;
    return _824_$retval;
}

void _826_f(void) {
}

int main(void) {
  printf("%ld",_824_main());
  return 0;
}
