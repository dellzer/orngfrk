/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Function forward definitions */
int64_t _1_main();
int64_t _3_div(int64_t _3_x,int64_t _3_y);

/* Function definitions */
int64_t _1_main() {
    int64_t _1_t0;
    int64_t _1_$retval;
    $lines[$line_idx++] = "tests/integration/functions/named-arg.orng:3:9:\n    div(.x = 510, .y = 10)\n       ^";
    _1_t0 = _3_div(510, 10);
    $line_idx--;
    _1_$retval = _1_t0;
    return _1_$retval;
}

int64_t _3_div(int64_t _3_x,int64_t _3_y) {
    int64_t _3_$retval;
    _3_$retval = _3_x / _3_y;
    return _3_$retval;
}

int main()
{
  printf("%ld",_1_main());
  return 0;
}
