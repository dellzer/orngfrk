/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Function forward definitions */
int64_t _1_main();
int64_t _3_add(int64_t _3_x,int64_t _3_y);

/* Function definitions */
int64_t _1_main() {
    int64_t _1_t1;
    int64_t _1_t4;
    int64_t _1_t0;
    int64_t _1_$retval;
$lines[$line_idx++] = "tests/integration/functions/default-args.orng:2:27:\nfn main() -> Int {add(add(47), add())}\n                         ^";    _1_t1 = _3_add(47, 1);
    $line_idx--;
$lines[$line_idx++] = "tests/integration/functions/default-args.orng:2:36:\nfn main() -> Int {add(add(47), add())}\n                                  ^";    _1_t4 = _3_add(1, 1);
    $line_idx--;
$lines[$line_idx++] = "tests/integration/functions/default-args.orng:2:23:\nfn main() -> Int {add(add(47), add())}\n                     ^";    _1_t0 = _3_add(_1_t1, _1_t4);
    $line_idx--;
    _1_$retval = _1_t0;
    return _1_$retval;
}

int64_t _3_add(int64_t _3_x,int64_t _3_y) {
    int64_t _3_$retval;
    _3_$retval = $add_int64_t(_3_x, _3_y, "tests/integration/functions/default-args.orng:4:3:\nfn add(x: Int = 1, y: Int = 1) -> Int {x + y}\n ^");
    return _3_$retval;
}

int main()
{
  printf("%ld",_1_main());
  return 0;
}
