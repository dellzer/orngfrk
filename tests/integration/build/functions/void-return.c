/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Typedefs */
typedef void(*function0)(void);

/* Function forward definitions */
int64_t _763_main(void);
void _765_void(void);

/* Function definitions */
int64_t _763_main(void) {
    function0 _763_t0;
    int64_t _763_$retval;
    _763_t0 = _765_void;
    $lines[$line_idx++] = "tests/integration/functions/void-return.orng:3:10:\n    void()\n        ^";
    _763_t0();
    $line_idx--;
    _763_$retval = 65;
    return _763_$retval;
}

void _765_void(void) {
}

int main(void) {
  printf("%ld",_763_main());
  return 0;
}
