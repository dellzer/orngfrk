/* Code generated using the Orng compiler https://ornglang.org */
#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "debug.inc"

/* Forward struct, union, and function declarations */
struct struct0;
struct struct1;

/* Struct, union, and function definitions */
struct struct1 {
    uint64_t tag;
    union {
        double _0;
    };
};

struct struct0 {
    uint64_t tag;
    union {
        int64_t _0;
        struct struct1 _1;
    };
};

/* Function forward definitions */
int64_t _548_main(void);


/* Function definitions */
int64_t _548_main(void){
    int64_t _548_t0;
    struct struct0 _549_x;
    uint64_t _548_t3;
    int64_t _548_$retval;
    _548_t0 = 139;
    _549_x = (struct struct0) {.tag=0, ._0=_548_t0};
    _548_t3 = 0;
    $tag_check(_548_t3, 0, "tests/integration/default/default-error.orng:2:8:\nfn main() -> Int {\n      ^");
    _548_$retval = _549_x._0;
    return _548_$retval;
}


int main(void) {
  printf("%ld",_548_main());
  return 0;
}
