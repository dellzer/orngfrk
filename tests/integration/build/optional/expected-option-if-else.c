/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */
struct struct0;

/* Struct, union, and function definitions */
struct struct0 {
    uint64_t tag;
    union {
        int64_t _0;
    };
};

/* Function forward definitions */
int64_t _1154_main(void);


/* Function definitions */
int64_t _1154_main(void){
    int64_t _1154_t0;
    struct struct0 _1155_x;
    uint64_t _1154_t3;
    int64_t _1154_$retval;
    _1154_t0 = 125;
    _1155_x = (struct struct0) {.tag=0, ._0=_1154_t0};
    _1154_t3 = 0;
    $tag_check(_1154_t3, 0, "tests/integration/optional/expected-option-if-else.orng:2:8:\nfn main() -> Int {\n      ^");
    _1154_$retval = _1155_x._0;
    return _1154_$retval;
}


int main(void) {
  printf("%ld",_1154_main());
  return 0;
}
